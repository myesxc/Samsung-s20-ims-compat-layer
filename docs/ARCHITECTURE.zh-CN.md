# 架构与兼容性模型

> English: [Architecture and compatibility model](ARCHITECTURE.md)
>
> 如需为**另一台**三星设备调查和适配类似能力，且不将 S20 产物当作可移植文件，请阅读[基于证据的跨设备三星 IMS 移植指南](CROSS_DEVICE_PORTING_GUIDE.zh-CN.md)。
>
> 已记录 S20 测试开关、只读 readiness 属性及回滚边界见[IMS 系统属性测试参考](S20_IMS_SYSTEM_PROPERTIES.zh-CN.md)。

本文说明如何在已记录的 Android 13 GSI 上运行来自已记录 Android 13 固件的三星 IMS 组件。它描述的是本项目的兼容边界，并非通用的三星 IMS 或 One UI 移植方案。

**适用范围。** 已记录的基线为 Snapdragon Galaxy S20 固件 `G981NKSU1HVJG`，主测设备为 SM-G981N，系统为 LineageOS 20 / Android 13 GSI。已验证的设备、运营商、安装要求、许可证和安全限制见[根目录 README](../README.zh-CN.md)。

## 为什么原厂 IMS 栈不能直接在 GSI 上运行

三星 IMS 不只是 `imsservice.apk`。原厂集成假定存在三星/One UI 软件环境：三星 framework API 与共享库、特权包身份、三星守护进程和 native 库、由 init 管理的服务与 socket、三星 SELinux 标签/类型，以及与之匹配的 vendor 无线电环境。

目标 GSI 提供的则是 AOSP IMS 服务契约。`ImsResolver`/Telephony 必须选定一个 IMS 包，并绑定其对 AOSP 可见的 `android.telephony.ims.ImsService` 端点。仅安装原厂 APK 并不能补齐该绑定契约、缺失的三星 framework 符号、启动阶段的守护进程准备工作，以及其余三星运行时依赖。

本项目**不**模拟完整 One UI。它保留已记录目标所需的匹配三星专有组件，只在 GSI 缺少必要边界契约的位置加入范围受限的适配器和兼容产物。本项目不替换设备的 `rild`、radio HAL、IMS PDN 配置或运营商网络集成，也不是可移植的三星 IMS 替代实现。

| 集成边界 | 原厂假设 | 项目处理方式 |
|---|---|---|
| AOSP IMS 发现 | 三星原厂集成不会通过目标 GSI 的标准契约被直接选中。 | 最终 [manifest](../AndroidManifest.xml) 暴露 `GoogleModernImsService`，包含 `BIND_IMS_SERVICE`、`android.telephony.ims.ImsService` action，以及 MMTEL/紧急 MMTEL metadata。 |
| framework IMS 包选择 | GSI 可能选择另一个 IMS 实现。 | 模块安装 RRO，使 `config_ims_mmtel_package` 指向 `com.sec.imsservice`；若 ROM 有竞争性的可变 IMS overlay，必须禁用，否则它可以抢走选择权。 |
| 三星 framework API | 部分三星 API 在 GSI 中不存在。 | 有序 APK patch 和 `imsmanager.jar` 兼容 DEX 提供定点替代/兼容桩。 |
| APK 组成 | 只重建 primary DEX 会遗漏必要依赖。 | 支持的产物是经过验证的四 DEX APK。 |
| 启动生命周期 | Magisk 在 init 已解析 `/system/etc/init` 后才使挂载的 init 文件可见。 | 模块在 `post-fs-data` 阶段重建所需的 `imsd` socket/服务启动工作。 |
| SELinux 类型/域 | GSI policy 中没有三星守护进程类型与域转换。 | 尽可能复用现有标签；在配置允许时降低 Unix 身份；保留已记录的 `system_app` permissive 残留状态。 |

## 系统关系图

```text
AOSP GSI framework
  ImsResolver + Telephony + RRO 选定的 IMS 包
                     |
                     | 标准 android.telephony.ims.ImsService 绑定
                     v
项目兼容层
  manifest + 分阶段 smali patch + 生成的 Java bridge
  imsmanager.jar 五类 stub DEX + Magisk 运行时适配
                     |
                     v
三星专有 IMS runtime
  com.sec.imsservice + framework JAR + imsd + multiclientd
  native 库 + EPDG 配置
                     |
                     v
设备已有的 vendor 无线电运行时
  vendor rild / radio HAL / IMS PDN / 运营商网络
```

项目保留三星的协议和设备特定实现组件；不替换设备 vendor 的 `rild`、radio HAL 或 IMS PDN 配置。模块只等待已经存在的 `rild` 与暴露出的 slot 1 radio HAL 就绪后，再启动 `multiclientd`。

## APK 兼容路径

构建过程使用命名状态，以便历史兼容性工作可审计：

```text
经哈希验证的 stock APK
  -> stock-to-desem5.patch
  -> desem5-to-desem81.patch
  -> 在私有临时 smali 树中编译 Java bridge
  -> 与受审阅的 smali_out/ 对比
  -> 将 bridge smali 注入 primary DEX
  -> 注入稳定的 secondary DEX payload
  -> 对最终 APK 对齐、签名并做结构验证
```

- **stock** 是本地提供、经哈希验证的单 DEX 三星输入 APK。
- **desem5** 是 patch 与验证边界；普通构建者不需要保留、签名或安装它。
- **desem81/final** 是当前最终兼容状态。
- **`smali_out/`** 是由 Java bridge 生成的、经审阅的 smali 快照。最终构建会在私有位置重新生成 bridge；若与此快照不一致，构建会拒绝继续。

历史 `smali_patch.diff` 不是支持的独立构建路径。只包含 primary DEX 的重建 APK 可以安装和签名，却可能因遗漏多 DEX 依赖而无法注册 IMS。权威构建步骤见 [BUILD.md](../BUILD.md)。

### 四个 DEX 文件

| 压缩包条目 | 作用 | 来源策略 |
|---|---|---|
| `classes.dex` | 已 patch 的三星 primary DEX，加上生成的 Java bridge。 | 从精确 stock APK 和有序 patch 重建。 |
| `classes2.dex` | 204 类 Gson 兼容 payload。 | 历史本地输入，使用哈希验证。 |
| `classes3.dex` | 120 个三星 IMS framework API 类。 | 本地提供/从专有 framework 输入导出。 |
| `classes4.dex` | 12 个 VSIM/softphone stub。 | 从受跟踪的 [`vsim_stub/`](../vsim_stub/) 重建。 |

构建会验证结构、DEX 哈希、类数量、所需现代 IMS 类和 manifest 绑定。它不承诺 APK ZIP 字节完全一致，因为 apktool、DEX 工具、压缩、对齐和签名 metadata 都可能改变字节。

## 面向 AOSP 的桥接层与保留的三星内部实现

最终[第二阶段 patch](../patches/desem5-to-desem81.patch)和生成的 bridge 类暴露面向 AOSP 的现代 IMS 层，同时保留其后的三星内部服务模块。

- `GoogleModernImsService`、现代 MMTEL feature 和 registration 类，使服务能按 AOSP framework 契约被绑定并上报。
- call-session bridge 将 framework 的通话流程适配到保留的三星 call/session 对象。
- `ModernImsSms` 将现代 IMS-SMS callback 适配到三星 SMS 实现。
- `ApIncomingCallBridge` 将来电投递适配到现代 feature 路径。
- AP 侧 RTP 收发和媒体协商类，是针对本项目观察到的目标 GSI 条件所做的用户态媒体适配：CP 侧媒体路径在该环境中不会触发；它们不是通用 Android IMS 媒体设计。
- bearer/session/recovery 类包含诊断和规避措施；这并不表示三星内部状态机已被完全理解。

保留的运行时仍依赖匹配的三星 framework/API 输入、`imsd`、`multiclientd`、native 库、EPDG 配置，以及设备的 vendor `rild`/radio HAL/IMS PDN 环境。这是对专有栈的适配器，不是 IMS 的替代实现。

## 两个不同的 `classes2.dex`

这个名字在不同父归档中含义不同：

```text
imsservice.apk!classes2.dex
  -> 204 类 Gson 兼容 payload

imsmanager.jar!classes2.dex
  -> 恰好五个三星 framework 兼容 stub
```

[`imsmanager-compat`](../imsmanager-compat/README.md) 组件会字节不变地保留 stock `imsmanager.jar!classes.dex`，仅注入下列五个 stub：

```text
android.os.SemSystemProperties
com.samsung.android.emergencymode.SemEmergencyConstants
com.samsung.android.feature.SemCscFeature
com.samsung.android.feature.SemFloatingFeature
com.samsung.android.wifi.SemWifiManager
```

在已记录目标上，恢复纯 stock JAR 会导致 IMS 注册失败。因此它是最小化的 framework 兼容增强，而不是重写三星 framework 库。

## 启动与守护进程适配

保留 stock init 声明是为了来源可追溯；但 Magisk magic-mount 的时序意味着 init 无法从模块中注册这些服务。因此运行时脚本会：

1. 为 magic-mounted 文件和库恢复合适标签；
2. 准备 IMS 通话记录日志目录；
3. 通过 [`ims_sock_launch`](../c/ims_sock_launch.c) 创建 `/dev/socket/imsd`、设置其所有者/权限、导出 `ANDROID_SOCKET_imsd` 并执行 `imsd`；
4. 在 `imsd` 退出后进行守护；
5. 将新建 socket inode 重标记为 `imsd_socket`，但不删除活动 socket；
6. 等待 `rild` 和 `ril.halservice.registered.slot1=true`，再启动唯一的 `multiclientd -s 1` 实例。

`ims_sock_launch` 在执行前会把 `imsd` 降到 stock 风格的 `system` 身份，只保留 `NET_RAW` 和 `NET_ADMIN`。它的 `--no-socket` 模式提供将 `multiclientd` 以无 capability 的 `radio` 身份启动的较低权限路径。**但当前受跟踪的运行时配置设置了 `S20VOLTE_MULTICLIENTD_ROOT=1`，因此默认部署会为 `multiclientd` 选择已记录的 root fallback；`radio` 路径仍可供诊断或未来使用。** Unix UID/GID/capability 收束与 SELinux 域隔离是两件独立的事。

仅支持 SIM 1 是已记录 GSI/runtime 路径只暴露并启动 slot 1 的架构结果；这不表示三星 stock 固件本身只支持单卡。

## SELinux 边界

项目从不使用 `setenforce 0`：[SELinux 证据](../selinux/README.md)记录了在已测试 GSI 上清除全局 enforcing 位会触发三星 RKP 重启。

policy 策略主要是**重标记而非新增授权**：

- 模块文件标记为 `system_file`，库标记为 `system_lib_file`；
- `/dev/socket/imsd` 重标记为 `imsd_socket`；
- `/data/log/imscr` 标记为 `rdxdump_data_file`。

这样复用 loaded policy 中已经赋予这些标签的访问权限，与新增 `allow` rule 不同。

不过这不等于完全隔离：

- 目标 GSI 没有声明 `imsd`、`imsd_exec`、`multiclientd` 或 `multiclientd_exec` 类型，因此这些守护进程不会转换到三星专用 SELinux 域，而是留在 `magisk` 域；
- Unix 身份收束不等于 SELinux 域隔离；
- `system_app` 仍需 permissive，因为 enforcing 会通过 framework 管理的 resource-cache/idmap 访问使 IMS 注册失败。

保持全局 SELinux Enforcing 并不会消除这一残留安全限制。

## Payload 与来源边界

[`payload-manifest.tsv`](../magisk-module/payload-manifest.tsv) 是 Magisk 打包的权威来源。它声明精确匹配的 system payload、项目新增内容、`imsmanager.jar` 兼容覆盖、已 patch APK，以及有意省略的 stock 证书。模块构建器会验证 manifest、选用的重建 APK、可选的派生 JAR 和最终 ZIP。

来自三星固件的组件仍是专有内容。本地 framework 输入、stock JAR、DEX 缓存、platform key 和构建工具都被有意忽略，不作为项目源代码分发。

## 限制与安全提示

此架构只在[根目录 README](../README.zh-CN.md)所列配置下验证。它不保证适用于其他三星型号、Exynos 硬件、固件版本、Android 版本、GSI、运营商或 platform 签名环境。

目前的重要限制包括：仅支持 SIM 1；未实现视频通话和 RCS；每次通话后会通过 radio-reset 规避措施短暂中断服务；仍残留 `permissive system_app` 域；以及一次尚未复现的服务崩溃。紧急呼叫仅做过部分测试，不能保证可用，也不得依赖本软件进行紧急呼叫。

## 证据与实现参考

| 主题 | 主要来源 |
|---|---|
| 支持的基线与限制 | [README](../README.zh-CN.md) |
| 四 DEX 构建与产物契约 | [BUILD.md](../BUILD.md) |
| AOSP 服务声明 | [AndroidManifest.xml](../AndroidManifest.xml) |
| 有序 APK 变更 | [`patches/`](../patches/) |
| Java bridge | [`java/com/sec/internal/google/`](../java/com/sec/internal/google/) |
| Framework-JAR stub | [`imsmanager-compat/`](../imsmanager-compat/README.md) |
| 运行时 launcher | [`post-fs-data.sh`](../magisk-module/post-fs-data.sh) 和 [`ims_sock_launch.c`](../c/ims_sock_launch.c) |
| 模块 payload | [`payload-manifest.tsv`](../magisk-module/payload-manifest.tsv) |
| SELinux 方法与残留风险 | [`selinux/README.md`](../selinux/README.md) |
