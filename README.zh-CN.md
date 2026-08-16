# Samsung S20 IMS Service —— Android 13 AOSP 移植

在运行 **Android 13/14 GSI**（已在 LineageOS 20/21 上验证）的骁龙版三星 Galaxy S20 上启用
**VoLTE**、**IMS 短信**和 **IMS 紧急呼叫**。

本项目衍生自 [jameskdev/android_samsung_imsservice](https://github.com/jameskdev/android_samsung_imsservice)
（A21s / Android 11），并将其扩展到 S20 / Android 13/14：现代 `ImsService` 桥接、AP 侧 RTP 媒体、
IMS 短信、紧急呼叫，以及一套**保持 selinux 为 enforce **的 SELinux 权限收敛。

> English documentation: [README.md](README.md)

---

## 功能状态

| 功能 | 状态 |
|---|---|
| VoLTE 去电（AMR-NB / AMR-WB） | ✅ 已验证 |
| VoLTE 来电 | ✅ 已验证 |
| IMS 短信（收发、多段长短信） | ✅ 已验证 |
| RFC 4733 DTMF 按键音 | ✅ 已验证（NB/WB 各自的 codec 映射） |
| 紧急呼叫 | ⚠️ 未完全验证 —— 见"已知缺陷 #4" |
| SELinux enforcing（无全局 permissive） | ⚠️ 仅剩 `permissive system_app` —— 见 #3 |
| 副卡（SIM 2） | ❌ 暂无修复计划 —— 见 #1 |
| UT界面 | ❌ 暂无修复计划 |
| 视频通话 | ❌ 无修复计划 |
| VoWifi | ❌ 无修复计划 |
| RCS | ❌ 无修复计划 |

### 已验证配置

| | |
|---|---|
| **主测试机型** | 三星 Galaxy S20 5G **SM-G981N**（KOO，韩版） |
| **另行验证机型** | 三星 Galaxy S20 5G **SM-G9880**（TGY，港版） |
| **系统** | **LineageOS 20/21**（Android 13/14） |
| **运营商** | 中国电信、中国联通 |
| **Root** | Magisk 26+ |

两台机器都是骁龙 865。Exynos 版本未经测试，且很可能需要不同的 blob。

---

## 做了哪些改造

三星的 IMS 组件（`com.sec.imsservice`）并不继承 AOSP 的 IMS 框架接口，而是调用三星自家的
平台 API —— 这些 API 在 GSI 上并不存在。本项目在两者之间搭桥：

1. **`AndroidManifest.xml`** —— 补上让 `ImsResolver` 能够绑定的现代服务声明
   （`android.telephony.ims.ImsService` action、`BIND_IMS_SERVICE` 权限、
   `MMTEL_FEATURE` 元数据），并移除仅三星平台才有的依赖。
2. **`smali_patch.diff`** —— 对原厂 smali 的定点补丁：去私有化、现代 `ImsService` 注册、
   通话会话生命周期修复。
3. **`java/`**（编译产物为 `smali_out/`）—— 注入 `classes.dex` 的新桥接类：
   - `ModernImsSms` —— 走现代 `ImsService` API 的 IMS 短信
   - `ApRtpReceivePoc` / `ApRtpUplinkPoc` —— AP 侧 RTP 收发（GSI 上 CP 媒体通路从不触发，
     因此媒体在用户态终结）
   - `ApMediaNegotiationPoc` / `ApMediaConfigPoc` —— SDP / codec 协商
   - `ApIncomingCallBridge` —— 来电通路
   - `ApBearerLatchProbe` / `ApStuckCallFix` —— 承载状态处理与恢复
   - 诊断类（`ApDualImsDiag`、`ApEpsOnlyDiag` 等）
4. **`imsmanager-compat/`** —— 保留 Samsung 原厂 `imsmanager.jar` 主 DEX，仅注入一个
   含五个最小 Samsung framework API stub 的第二 DEX，供 GSI 解析。已验证在目标
   Android 13 系统恢复纯原厂 JAR 会导致 IMS 无法注册。
5. **`c/ims_sock_launch.c`** —— 替代 init 的小助手（见 [SELinux](#selinux) 一节）。
6. **`magisk-module/`** —— 以正确的 socket 标签和降权身份拉起 `imsd`、`multiclientd` 的模块脚本。
7. **`selinux/`** —— 完整的权限收敛记录：四条 permissive 收敛到一条，且**零新增 allow 规则**，
   每一步都有实机验证。

---

## 目录结构

```text
AndroidManifest.xml                 改造后的清单（替换原厂）
smali_patch.diff                    针对原厂反编译 smali 的补丁
java/                               桥接源码（本项目自研代码）
smali_out/                          编译好的桥接 smali —— 拷进反编译后的 APK
libs/                               仅编译期使用的 jar（imsmanager / EpdgManager / rcsopenapi）
imsmanager-compat/                  可复现的本地 imsmanager.jar GSI 兼容覆盖
rro/                                S20 IMS 选择 RRO 的源码 + 可复现构建器
c/                                  ims_sock_launch 助手：源码 + 交叉编译脚本
build.sh                            java/ -> smali_out/
magisk-module/                      Magisk 模块脚本（post-fs-data.sh、sepolicy.rule 等）
proprietary_vendor_samsung_ims/     三星专有文件 + 供 ROM 源码树使用的 Android.bp/mk
selinux/                            SELinux 收敛过程：候选方案、台账、采集器
tools/                              （空目录）环境与版本要求说明
```

---

## 前置条件

- **机型**：骁龙版三星 Galaxy S20 (SM-G98xx)。
  已在 SM-G981N 与 SM-G9880 上验证。
- **系统**：Android 13 GSI，已在 LineageOS 20 上验证。
  除非你持有该 ROM 的平台私钥，否则必须是 **test-keys** 版本（`getprop ro.build.tags`）——
  IMS/RRO APK 以 `android.uid.system` 运行，必须带有该 ROM 的平台签名。
- **Magisk** 26+ 且已 root。
- **SIM 卡**：已开通 IMS 的号码。已在中国电信、中国联通上验证。

---

## 如何构建

> **重要：**可用的 S20 移植依靠一份四 DEX APK。
> 此前仅使用 `smali_patch.diff`的单 DEX 流程并不完整，会构建出无法注册 IMS 的 APK。
> 请改用**[BUILD.md](BUILD.md)** 中的分阶段流程：它会校验精确的原厂输入，
> 依次应用`stock-to-desem5` 和 `desem5-to-desem81`，来完成最终的 IMS 服务实现。

完整环境搭建、依赖包清单和精确版本号见 **[tools/README.md](tools/README.md)**。

关于三星/One UI 依赖、AOSP 桥接边界、四 DEX 产物设计和运行时适配，见 **[架构与兼容性模型](docs/ARCHITECTURE.zh-CN.md)**。

如需为**其他型号的**三星设备进行基于证据的调查与适配，见 **[跨设备三星 IMS 移植指南](docs/CROSS_DEVICE_PORTING_GUIDE.zh-CN.md)**。该指南仅供参考，本项目的 S20 payload 不直接适用于其他设备。

如果你是开发者，需要进行开发或测试，项目有一些测试开关、只读 readiness 属性及回滚边界，见 **[IMS 系统属性测试参考](docs/S20_IMS_SYSTEM_PROPERTIES.zh-CN.md)**。

```bash
source tools/env.sh
bash build.sh release --stock-apk path/to/mount_system/system/priv-app/imsservice/imsservice.apk --stock-system path/to/mount_system/system --output-dir out/release --sign
```

该端到端命令会构建最终四 DEX APK、生成所需的本地 `imsmanager.jar` 兼容覆盖，并打包
经过验证的 Magisk ZIP。本地 `classes2.dex`、Samsung framework 与 VSIM 输入的准备方式见
[BUILD.md](BUILD.md)。单独运行 `bash build.sh` 仅是维护者重新生成受审阅 Java bridge
快照的可选命令。

最终组装脚本会在两个 patch 都应用完成后、apktool 汇编 `classes.dex` 之前，自动将
`java/` 编译到私有临时 smali 目录并注入 32 个 bridge 类。单独运行 `bash build.sh`
仅用于维护者重新生成受审阅且跟踪的 `smali_out/` 快照；若新编译结果与该快照不同，
最终组装会拒绝继续，避免 Java 源码与 APK 内容漂移。


### 历史手工流程

下方旧的单 DEX 补丁步骤只为说明历史版本而保留，**不能**作为支持的重建方法：它会丢失
`classes2.dex`、`classes3.dex` 和 `classes4.dex`，从而缺少 Samsung API、Gson 与 VSIM 兼容类。
请使用 [BUILD.md](BUILD.md) 的四 DEX 分阶段流程。

仓库内 `proprietary_vendor_samsung_ims/proprietary/system/priv-app/imsservice/imsservice.apk`
**已经打好补丁并用 AOSP testkey 签名**。如果你的 ROM 使用同一证书，可直接使用，跳过本节。

自行重建的步骤：

1. 从三星固件 **G981NKSU1HVJG**（SM-G981N，Android 13）中提取 `imsservice.apk`，
   位于 `system.img` 内的 `system/priv-app/imsservice/imsservice.apk`。
2. `apktool d imsservice.apk -o imsservice_dec`
   该固件 APK 仅包含一个 `classes.dex`，所以 apktool 会生成 `smali/`；本项目的补丁
   和新增类都应放在此目录。
3. `patch -p1 -d imsservice_dec/smali < smali_patch.diff`
4. `cp -r smali_out/* imsservice_dec/smali/`
5. `cp AndroidManifest.xml imsservice_dec/AndroidManifest.xml`
6. `apktool b imsservice_dec -o imsservice_unsigned.apk`
7. `zipalign -p -f 4 imsservice_unsigned.apk imsservice_aligned.apk`
   *（zipalign 是必须的 —— 未对齐的 APK 在 Android R+ 上会安装成"未安装"）*
8. 用目标 ROM 的平台密钥签名：
   ```bash
   apksigner sign --key tools/keys/platform.pk8 \
                  --cert tools/keys/platform.x509.pem \
                  imsservice_aligned.apk
   ```

---

## 如何安装

1. 先针对挂载的原厂 system 镜像校验声明的 61 个 Magisk payload 文件：
   ```bash
   bash magisk-module/verify_payload.sh /path/to/mount_system/system
   ```
2. 使用已提交、实机验证的基线构建测试模块；如果使用新重建的 APK，需先通过
   `build/verify_apk.sh final`，再用 `--apk` 显式传入：
   ```bash
   bash magisk-module/build_module.sh --stock-root /path/to/mount_system/system out/S20_VoLTE_IMS.zip
   ```
3. 在 Magisk 中刷入生成的 ZIP。
4. **重启两次。** 第一次开机完成模块安装，IMS 注册通常在第二次开机后稳定生效。
5. 验证：
   ```bash
   adb logcat -s S20VOLTE
   ```
   应能看到 `imsd` supervisor 启动，以及 `multiclientd -s 1` 以 `radio/1001` 身份拉起。

模块同时会装一个 RRO overlay，把 `config_ims_mmtel_package` 指向 `com.sec.imsservice`。
如果你的 ROM 自带其他 IMS 包且其 overlay 可变（LineageOS 有 `flossims_telephony`），
必须将其禁用，否则注册会被抢走。

---

## SELinux

三星 RKP（Knox EL2 hypervisor）在全局 SELinux enforce 位被清除时会**强制重启设备**，
因此 `setenforce 0` 这条路走不通 —— 这一点在三个不同 GSI 上都复现过，换 ROM 无用。
本项目从不触碰全局 enforce 位，只用 Magisk 的 `sepolicy.rule` 加上 `post-fs-data.sh`
里的定点 `chcon` 打标签。

起点是四条 permissive 加两个以 root 运行的守护进程。当前状态：

| 项目 | 之前 | 之后 |
|---|---|---|
| `permissive init` / `radio` / `system_server` | 四条 permissive | **已删除** |
| `permissive system_app` | —— | **仍需保留**（见 #3） |
| `/dev/socket/imsd` | `socket_device`（被拒绝） | `imsd_socket` |
| IMS 通话记录日志目录 | `system_data_file`（被拒绝） | `rdxdump_data_file` |
| 模块文件（磁挂载） | `adb_data_file` | `system_file` / `system_lib_file` |
| `imsd` 身份 | root，全部 38 个 capability | `system`(1000)，仅 `NET_RAW`+`NET_ADMIN` |
| `multiclientd` 身份 | root，全部 38 个 capability | `radio`(1001)，**零** capability |

以上每一项都是复用 GSI 策略里**已有**的规则 —— **没有新增任何 allow 规则**。
完整历程、证据与需求台账见 [selinux/](selinux/)。

### `ims_sock_launch`

Magisk 对模块 `/system/etc/init/*.rc` 的磁挂载发生在 init 解析完 `/system/etc/init`
**之后**，所以 init 永远不会注册 `imsd`，也就不会创建它的控制 socket，`imsd` 随即以
`Obtaining file descriptor socket 'imsd' failed` 退出。

`c/ims_sock_launch.c` 复刻了 init 本该做的事：

- 创建 `/dev/socket/imsd`，完成 bind / chmod / chown / listen，导出 `ANDROID_SOCKET_imsd`，
  然后 `execv` 拉起守护进程；
- 从 post-fs-data 的完整 root 降到原厂 `.rc` 文件指定的身份（uid/gid、附加组、
  capability、ambient capability）。

它**不会**改变 SELinux 域：本 GSI 策略里没有 `imsd_exec` / `multiclientd_exec` 类型，
域转换根本无从建立，两个守护进程只能留在 `magisk` 域。Unix 身份与 SELinux 域是两条
独立防线，这里把能收紧的那一条收紧了。

需要重新编译时执行 `bash c/build_ims_sock_launch.sh`（需要 NDK r26d）。
仓库内已提交预编译好的二进制。

---

## 已知缺陷

**1. 副卡（SIM 2）不可用。**
VoLTE 目前仅在 **卡槽 1** 正常工作，卡槽 2 无法使用 VoLTE 功能。`multiclientd` 以 `-s 1`
（单卡槽）启动 —— 原厂用 `-s 2` 支持双卡双待，但本 GSI 的 radio HAL 只暴露了 slot1。

**2. 每次通话后会有几秒断网。**
由于技术能力有限，没有完全弄清楚三星 IMS 内部的状态机。若不加干预，上一通电话结束后
**下一通电话会没有声音**。因此目前采用切换移动无线电电源开关的方式来硬重置状态机，
以保证下一次通话正常。代价是：每次通话后大约会**断网 3 秒**、**电话离线 7 秒**，
期间无法接打电话、无法收发短信。这是一个粗暴的规避手段而非真正的修复；
若能找到精确的状态机或承载重置路径，即可去掉它。

**3. SELinux 没有完全收束，`system_app` 仍是宽容状态。**
四条 permissive 已删掉三条，但 `permissive system_app` 仍然保留，可能存在安全性问题。
删除它会导致 IMS 无法注册，断点在 `/data/resource-cache/`（`resourcecache_data_file`）——
本 GSI 策略没有给 `system_app` 任何相关规则。该域下共有 8 个进程（设置、keychain、
dynsystem ×2、localtransport、lineageparts、qcrilam、imsservice）。要真正修好需要新增
allow 规则。欢迎贡献。

**4. 由于法律法规限制，紧急呼叫功能无法完全测试。**
仅完成了**多次测试号码呼叫**和 **1 次真实紧急号码（110）**的测试。
**不保证、也不承诺紧急呼叫在任何时候、任何情况下都可用。请勿依赖本软件拨打紧急电话**，
请始终保留其他可联系紧急服务的手段。

**5. 长时间测试中出现过 1 次 IMS 服务崩溃。**
后续一直无法复现，且缺少相关日志信息，因此暂时无法定位与修复。
如果你遇到这种情况，**需要重启设备**恢复。如能提供该场景的日志，非常欢迎提 issue。

### 其他注意事项

- 请保持 `persist.vendor.ims.ap_media_rotate_ports=false`。开启后 AP 会轮换自己的 RTP
  接收端口，而 SDP 里的端口由 native 栈独立决定，从第三通电话起两者不一致，
  表现为"接通但无声"。
- 构建不是字节级确定性的。仓库内提交的 APK 是经过实机验证的基线版本。
- 仅在上文列出的机型、ROM 和运营商上测试过。

---

## 固件来源

`proprietary_vendor_samsung_ims/proprietary/` 下的专有文件提取自：

```text
机型：  三星 Galaxy S20 5G —— SM-G981N（KOO）
固件：  G981NKSU1HVJG（Android 13）
```

`ims_sock_launch` **不是**三星固件文件，而是本项目自研的辅助程序
（`c/ims_sock_launch.c`，Apache-2.0）。`libapims_signaling.so` 同样是本项目附加的。
与原厂的差异清单见 `proprietary_vendor_samsung_ims/vendor-ims.mk`。

---

## 许可

- 本项目自研代码（`java/`、`c/`、`build.sh`、`magisk-module/*.sh`、`selinux/`）
  采用 Apache-2.0，见 [LICENSE](LICENSE)。
- `proprietary_vendor_samsung_ims/` 内是从原厂固件提取的**三星专有二进制文件**，
  **不适用** Apache-2.0，此处仅为互操作目的再分发。再分发前请自行确认所处法域的合规性。
- 不包含任何签名密钥。

---

## 相关项目与致谢

- [jameskdev/android_samsung_imsservice](https://github.com/jameskdev/android_samsung_imsservice)
  —— 最初的 A21s / Android 11 移植，本项目的基础。
- [phhusson/ims](https://github.com/phhusson/ims)（PhhIms）—— 完全不使用三星栈的
  纯用户态 SIP/RTP 替代方案，参考了他们音频部分的处理方法。
