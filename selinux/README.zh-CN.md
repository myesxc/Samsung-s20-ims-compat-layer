# SELinux 权限收敛

> English documentation: [README.md](README.md)

---

此模块如何从**四个宽容域加两个 root 守护进程**下降到**一个宽容域和两个无特权守护进程 —— 且零新增 allow 规则**。

这里的所有内容都是证据驱动的：每一步都在真实设备上应用、根据内核审计记录验证，并根据设备实际报告的内容保留或恢复。

---

## 为什么不只是 `setenforce 0`

Samsung 的 RKP（Knox EL2 hypervisor）**会在全局 SELinux enforce 位被清除时强制重启设备**。这在三个不同 GSI 上都复现过，所以切换 ROM 无济于事。Magisk 的 `sepolicy.rule` 打补丁相比之下不动全局位，也不会触发 RKP。

本目录中的所有内容都源于那个约束。

---

## 最终状态

| 项目 | 之前 | 之后 | 如何 |
|---|---|---|---|
| `permissive init` | 存在 | **已删除** | 没有模块进程在 `init` 中运行 |
| `permissive radio` | 存在 | **已删除** | 没有模块进程在 `radio` 中运行 |
| `permissive system_server` | 存在 | **已删除** | 拒绝是通用 GSI 噪声，非 IMS |
| `permissive system_app` | 存在 | **保留** | 阻止于 `resourcecache_data_file` |
| `/dev/socket/imsd` | `socket_device` → 拒绝 | `imsd_socket` | `chcon`，复用现有规则 |
| `/data/log/imscr` | `system_data_file` → 拒绝 | `rdxdump_data_file` | `chcon`，复用现有规则 |
| 模块文件 | `adb_data_file` | `system_file` + `system_lib_file` | 递归 `chcon` 匹配原厂 |
| `imsd` | root，38 个 cap | uid/gid 1000，仅 `NET_RAW`+`NET_ADMIN` | `ims_sock_launch` |
| `multiclientd` | root，38 个 cap | uid/gid 1001，**零** cap | `ims_sock_launch --no-socket` |

**在任何时刻都没有添加 allow 规则。** 每个修复都重新标签一个对象，以便 GSI 策略**已经包含**的规则对它应用。

---

## 指导技术：重新标签，不要授予

GSI 的策略已经包含如下规则：

```text
allow system_app imsd_socket sock_file { write }
allow system_app magisk unix_stream_socket { getopt connectto }
```

`/dev/socket/imsd` 拒绝从不是一个丢失的规则 —— `ims_sock_launch` 将节点创建为通用 `socket_device`，那些规则不覆盖它。一个 `chcon` 到 `imsd_socket`，拒绝消失，没有策略变化。

同样的推理修复了 IMS 呼叫记录日志。`system_app` 对 `system_data_file` 没有文件权限，但 Samsung 的 `rdxdump_data_file` 类型授予 `system_app` 完整的 `file { create append rename unlink }` + `dir { create add_name remove_name }` 集，仅可由 `init` 和 `system_app` 到达，在此 GSI 上其他地方未使用。重新标签 `/data/log/imscr` 到它成本为零。

> `radio_data_file` 看起来是自然的选择，但**不可用**：它是唯一缺少 `create` / `add_name` / `rename` 的候选，所以目录创建在启动时失败。

---

## 内容

| 路径 | 是什么 |
|---|---|
| `sepolicy_requirements.csv` | 台账。每行一条规则考虑过，带状态、证据文件及理由 —— 包括被拒绝的及为什么。 |
| `candidates/01-labels/` … `05-…/` | 每个尝试的步骤：其 `post-fs-data.sh`、`sepolicy.rule`、校验和及说明结果的 README。 |
| `sepolicy.rule.baseline-permissive` | 原始全宽容策略，保留用于离线回滚。未在模块中发布。 |
| `tools/collect_selinux_ims.sh` | 两阶段设备上证据采集器（`arm` 然后 `collect`）。 |
| `tools/COLLECT_SELINUX_WINDOWS.cmd` | 采集器的 Windows 包装。 |

候选 01 和 02 **失败**并被故意保留 —— 它们记录了一条死胡同，值得不重复（见下文）。

---

## 仍然被阻止的

`permissive system_app` 目前无法移除。这样做会破坏 IMS 注册，同时产生**零 `system_app` AVC**：失败表现为 ~250× `Failed to load asset path /system/priv-app/imsservice/imsservice.apk` 和对 `/data/resource-cache/…@idmap` 的重复失败。此 GSI 的策略仅向 `system_server` 和 `init` 授予 `resourcecache_data_file` 访问 —— `system_app` 根本没有规则，没有重新标签技巧适用，因为路径由框架拥有，不是本模块拥有。

修复它需要真正的新策略，这会为那个域中的所有 **8 个进程**扩宽访问：Settings、keychain、dynsystem（×2）、localtransport、lineageparts、qcrilam 和 imsservice。那个权衡被判断为不值得单方面做出。
**欢迎贡献。**

---

## 两条值得知道的死胡同

**1. 没有 `imsd` 域可转换到。** 候选 01 和 02 尝试标签守护进程 `imsd_exec` 并添加 `magisk → imsd` 域转换。GSI 从整体上替换了 Samsung 的平台 sepolicy，所以 `imsd`、`imsd_exec`、`multiclientd` 和 `multiclientd_exec` 在加载的策略中**零声明**。标签无法应用，转换永远无法激活。两个守护进程必然停留在 `magisk` 域；仅它们的 Unix 身份可被降低，那是 `ims_sock_launch` 做的。

**2. 移除 `permissive init` 和 `permissive radio` 没有带来安全。** `ps -AZ` 显示 `radio` 域仅持有 `com.android.phone` 及 `init` 域一个无关进程。没有模块进程在两者中的任何一个中运行。行被删除，因为它们是死重，不是因为它们保护什么。

---

## 方法论注记 —— 采集证据前读这个

**在 Android 13 上，SELinux 拒绝去内核审计缓冲，而不是 logcat。**

原始采集器仅刮 `logcat`。在一个启动采集中产生了 14 条 AVC 行，带**零**模块相关条目，而同一启动的 `dmesg` 持有 245 行，其中 11 个模块相关。每个"无 AVC，因此此权限不必要"的结论在那个发现之前被得出是不健全的，必须被重新派生。

`tools/collect_selinux_ims.sh` 现在是两阶段的：`arm` 记录最后内核审计序列号和 logcat 时间戳，然后 `collect` 仅保留更新的记录。其他它绕过的陷阱，每个都至少一次产生了错误结论：

- **按时间边界 logcat，从不按行数。** `logcat -t 1200` 在繁忙设备上返回了 8 秒窗口，使两个真实电话看起来似乎从未发生过。`logcat -T <timestamp>` 返回预期的 80+ 秒。
- **玩具盒 `grep` 不支持 `\b`。** `\bINVITE\b` 在设备上匹配什么都没有，而构建主机上的 GNU grep 报告 27 —— 一个容易"证明"错误的方式。仅普通子字符串。
- **`grep -c … || echo 0` 发出两行**（grep 在零匹配时退出 1，触发备选*和*打印 `0`）。使用 `| head -1`。
- **`ls -Z` 列位置因玩具盒版本而变化。** 匹配上下文模式而不是采用 `$4`。
- **零拒绝在没有工作负荷数的情况下意味着什么。** 总是采集活力和活动计数器（拨打的呼叫、看到的 INVITE、日志写）伴随。一个"清洁"采集转出是一个启动循环，其中进程从未启动。

`dontaudit` 规则从审计日志抑制拒绝而不影响实施，此设备的 Magisk 无法剥离它们。在 2142 活 `dontaudit` 规则中，11 个将 `system_app` 命名为源，其中没有任何一个接触套接字、IMS 文件、IMS 属性或电话。与其把它当作阻碍，接受准则变成了**完整功能回归** —— 这自然对 `dontaudit` 免疫，因为破坏的功能无论拒绝是否被日志记录都显示出来。

---

## 隐私

设备采集**不**包括在这里：它们包含 IMSI、电话号码和 IMEI。仅脚本、策略文件、校验和和书面分析被提交。`.gitignore` 阻止 `logcat_*`、`dmesg*`、`*.pcap` 和日期采集目录 —— 添加新证据时保持那样。
