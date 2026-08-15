# 基于证据的跨设备三星 IMS 移植指南

> English: [Evidence-Driven Cross-Device Samsung IMS Porting Guide](CROSS_DEVICE_PORTING_GUIDE.md)
>
> **这是参考实现，不是可直接移植的工具包。** 本仓库只验证了一种三星骁龙 S20 场景。它不能证明其中的 APK、DEX、JAR 修改、native 库、守护进程配置、SELinux 标签、Magisk 模块、签名方式或运营商行为可用于其他设备。

本文面向希望把某一台三星设备的原厂 IMS 栈接入 AOSP ROM/GSI 的开发者，以及协助这类工作的 AI 编程工具。重点不是“把 S20 文件复制到新手机”，而是如何建立证据、找出真正缺失的集成边界、一次只修改一个变量、保留可回滚路径，并在目标设备没有安全可维护的路径时及时停止。

本文**不是**让你把 S20 模块刷入其他设备的说明，也不保证任意三星设备都能完成 IMS 移植。三星固件、Android platform API、SoC/radio 栈、SELinux policy、运营商配置和 platform 签名安排都会随设备与版本显著变化。

## 先阅读这些文档

| 需要了解的内容 | 本仓库中的权威参考 |
|---|---|
| 已验证的 S20 架构与当前边界 | [架构与兼容性模型](ARCHITECTURE.zh-CN.md) |
| 已验证的 S20 四 DEX 构建契约 | [BUILD.md](../BUILD.md) |
| 本地工具链与被忽略输入 | [tools/README.md](../tools/README.md) |
| S20 framework-JAR 兼容覆盖 | [imsmanager-compat/README.md](../imsmanager-compat/README.md) |
| S20 Magisk payload 与打包规则 | [magisk-module/README.md](../magisk-module/README.md) |
| S20 运行时启动实现 | [post-fs-data.sh](../magisk-module/post-fs-data.sh) 和 [ims_sock_launch.c](../c/ims_sock_launch.c) |
| S20 SELinux 证据、实验与残留风险 | [selinux/README.md](../selinux/README.md) |
| 支持的 S20 基线、限制与许可证 | [README.zh-CN.md](../README.zh-CN.md) |

`BUILD.md` 有意只针对已记录的 S20 固件。应将它作为“如何建立可复现产物契约”的示例，而不能把它的 hash、DEX 数量、patch 名称或 payload 列表理解成其他设备的要求。

## 安全、法律与支持边界

在收集固件或修改设备之前，必须接受以下约束：

- **不要依赖实验性移植拨打紧急电话。** 即使有限测试看似正常，网络状态、配置、定位、路由、设备恢复或未测运营商路径也可能导致失败。始终保留其他紧急联络手段。
- **每一次刷入前都保留恢复路径。** 必须知道如何禁用/移除最新 Magisk 模块、恢复已知可启动状态，并回到普通电话可用的基线；不能依赖正在测试的候选模块本身完成恢复。
- **合法取得并处理固件与专有组件。** 应合法取得 donor firmware，遵守版权、许可证、再分发限制、运营商条款和当地法律。公开源码树应只放项目自研代码、脚本、manifest、hash 和文档；不要放未审阅的固件提取物、签名私钥或机密运营商材料。
- **采集证据默认含敏感信息。** logcat、kernel audit、modem/IMS trace、PCAP、package dump 和截图都可能含 IMSI、IMEI、电话号码、SIP 标识、注册数据、证书或位置信息。原始采集应保留在本地，公开前必须脱敏，默认不提交。S20 的 [selinux/README.md](../selinux/README.md) 遵循此规则。
- **不要关闭全局 SELinux enforcing。** S20 项目观察到 `setenforce 0` 会触发三星 RKP 重启。这是 S20 的证据，但操作本身风险足够高，不能作为新目标的默认诊断手段。
- **不要复制 platform 私钥。** system/shared-UID 包必须按目标 ROM 的 platform 签名规则签名。只有目标 ROM 确实使用并接受 test key 时，test key 才有效。绝不能公开私钥。
- **不要因构建成功就宣称支持。** 编译、apktool 重建、安装、服务绑定、IMS 注册、通话建立、音频、短信和恢复能力是相互独立的里程碑。

## 本文使用的证据标签

每一条设计说明、源码注释、实验记录和 AI 生成方案都应区分事实与推论。

| 标签 | 含义 | 必须采取的行为 |
|---|---|---|
| **[S20-已验证]** | 只在本文档指定的 S20 基线上验证。 | 引用 S20 实现/证据，并保留其狭窄适用条件。 |
| **[可复用方法]** | 可复用的调查技术。 | 说明在新目标应用前必须收集哪些数据。 |
| **[目标相关]** | 每台设备/固件/ROM 都必须重新发现的值或契约。 | 使用模板字段，而非 S20 默认值。 |
| **[假设]** | 对新目标尚未验证的合理解释或候选修改。 | 写明实验、预期观察、失败解释和回滚。 |
| **[禁止直接复制]** | 已知的 S20 专属产物、被拒绝路径或不安全捷径。 | 说明直接复用为何不可靠。 |

只有在记录中同时包含以下内容时，才能说某修改“修复”了问题：

1. 目标 profile 和产物 hash；
2. 一个预期修改变量；
3. 有时间边界的 workload；
4. 证据来源和采集窗口；
5. 预期与实际结果；
6. 回归与回滚结果。

“没有看到 AVC”不等于成功，除非同时有 liveness 与 workload 证据。“APK 能安装”不等于成功，除非同时有 framework binding 与功能证据。

---

# 第一部分：核心模型

## 1. 移植是分层集成问题

三星 IMS 包通常不只依赖 APK 内 Java 代码。可用下图理解：

```text
AOSP/GSI framework 选择与 Telephony IMS 契约
        |
        v
IMS package 声明、RRO 选择、特权/签名身份
        |
        v
APK DEX、三星 framework JAR 符号、Binder/AIDL 契约
        |
        v
三星 IMS 服务、daemon、socket、native 库、EPDG 数据
        |
        v
init 生命周期、UID/GID/groups/capability、SELinux 标签/域
        |
        v
已有 vendor RIL、radio HAL、IMS PDN、modem、运营商配置
        |
        v
signaling、bearer、SDP/codec、RTP/audio、SMS、恢复行为
```

上层故障常常会伪装成下层故障。例如：

- 缺失 manifest 声明可能表现为“IMS 永远不能注册”；
- 缺失 framework 符号可能表现为 daemon 初始化失败；
- 缺失由 init 创建的 socket 可能表现为 native binary 不兼容；
- 错误 SELinux 标签可能表现为 app permission 问题；
- RRO 选择了其他 IMS 包，可能使正确的 bridge 看起来从未使用；
- 已注册服务仍可能无音频，因为 media/bearer 路径不同。

因此，不要先复制大量专有 blob 或写宽泛 SELinux policy。应先找出缺失的边界，并用目标设备证据证明它。

## 2. 为什么原厂三星 IMS 通常不能直接运行在 AOSP 上

[S20-已验证] S20 原厂集成假定存在三星 framework API、特权身份、匹配的专有 runtime、由 init 管理的 daemon/socket、三星风格 SELinux 类型和兼容的 vendor radio 环境。AOSP GSI 的 Telephony 则要求一个被 framework 选中的 package，提供标准 IMS service 契约。S20 项目保留匹配的三星组件，只在其 GSI 缺失必要契约的边界增加 adapter。见 [ARCHITECTURE.zh-CN.md](ARCHITECTURE.zh-CN.md)。

[可复用方法] 对每个目标依次回答：

1. **发现：** 目标 AOSP framework 选择哪个 IMS package？选择由何处配置？
2. **绑定：** 它要求哪一代 `ImsService` API 和 metadata？是 modern `android.telephony.ims.ImsService`、compat API，还是 ROM 专有路径？
3. **特权：** package 是否需要 platform certificate、shared UID、priv-app permission、allowlist 或特定分区安装位置？
4. **内部 API：** GSI 缺少哪些三星 class、JAR method、property、AIDL interface、provider 或 resource？
5. **native/runtime：** APK 假定哪些 process、socket、native library、configuration、certificate 和 carrier data 已存在？
6. **radio：** 哪个 vendor RIL、HAL service、slot、property、IMS PDN 和 modem 状态必须先就绪？
7. **policy：** stock firmware 假定哪些 file/socket label、process identity、capability 与 SELinux domain？
8. **media：** signaling 正常后，该目标的 RTP、codec negotiation、bearer indication 与 audio routing 在哪里发生？

这些答案应形成 target profile，而不是猜测。若仍有多项未知，下一步是调查，不是 patch。

## 3. 不能变成默认值的 S20 参考案例

| S20 参考案例 | 它说明什么 | 新目标必须重新发现什么 |
|---|---|---|
| `GoogleModernImsService`，包含 `BIND_IMS_SERVICE`、MMTEL metadata、emergency-MMTEL metadata 和 `android.telephony.ims.ImsService` action | 原厂三星集成可能缺少对 AOSP 可见的 IMS endpoint。 | framework API 代际、选中 package、service class、action、metadata、permission、exported/single-user 规则和 Binder 行为。 |
| RRO 将 `config_ims_mmtel_package` 指向 `com.sec.imsservice` | package selection 可能独立于 APK 安装。 | resource name、overlay policy、package name、竞争 overlay、是否可变以及 framework 解析方式。 |
| 四 DEX S20 APK | 仅重建 primary DEX 即使能安装，也可能功能不完整。 | 所有 archive entry 的角色/hash、class-loader 期望、native library、asset、manifest/resource 修改以及 multidex 是否必要。 |
| 向 `imsmanager.jar!classes2.dex` 加五个 stub | 最小 framework augmentation 可修复缺失符号，同时保留 vendor primary DEX。 | 精确缺失符号、语义、call site、stock JAR layout、secondary DEX loading，以及 stub 是否足够。 |
| `imsd`、`multiclientd`、native library、EPDG 配置 | 三星 APK 可能依赖匹配的 runtime suite。 | process graph、executable path、shared-library ABI/dependency、config、certificate、init 定义和 donor artifact 与目标 SoC/firmware 的匹配性。 |
| `ims_sock_launch` 重建 init socket | Magisk 可能因挂载时机过晚而无法让 init 注册 stock service。 | init timing 是否确为原因、socket name/mode/owner/context、环境变量、daemon args、restart policy 与 service responsibility。 |
| AP 侧 RTP 代码 | 注册/通话 signaling 和 media 可能经过不同路径。 | CP media 是否触发、bearer callback、SDP 所有权、RTP endpoint、audio routing 与 codec 要求。 |
| `multiclientd -s 1` 和 SIM 1 限制 | GSI port 暴露的 slot 可能少于 stock firmware。 | slot topology、subscription mapping、HAL property、daemon slot 参数、DSDS 行为和 multi-SIM 可行性。 |
| S20 RKP 对 global permissive 的反应 | policy 修改可触发设备专属安全行为。 | target boot/reboot 行为、可用 label/rule/type、audit source 和安全的窄范围 policy 实验。 |

---

# 第二部分：带闸门的移植流程

下面每一阶段都有明确目的：避免产出一个“看似可用”、但实际所需 runtime dependency 尚未理解的 artifact。不要因为 S20 的早期实验曾跳过某阶段，就跳过新目标的验证。

## 阶段 0：安全、法律与恢复准备

### 目标

建立可从失败 candidate 中恢复、且每份证据能准确归因到一次实验的实验环境。

### 必要输入

- 已解锁/root 的目标设备，或可恢复的测试设备；
- 合法获得的 donor firmware 与来源明确的 target ROM/GSI image；
- 已知可用 boot/recovery 路径和 module disable/remove 方法；
- last-known-good module ZIP 或 baseline image；
- 分开的本地目录：immutable source artifact、derived artifact、sensitive capture 和 source-controlled project file；
- 备用紧急联络方式。

### 操作

1. 记录当前手机正常状态：普通通话、数据、SMS、carrier、SIM slot、ROM build、root/Magisk 版本与恢复方式。
2. 将原始 donor APK/JAR/configuration **复制**到不可变本地 input store，不要移动它们。
3. 在 decompile、mount 或 patch 前计算每个输入的 hash。
4. 建立 experiment ledger；每个 candidate 占一行。
5. 在修改前定义一个 rollback trigger：boot loop、重复重启、普通电话不可用、daemon crash loop、不安全的温度/电池行为、持续无信号或无边界 policy denial。
6. 每次 candidate 使用新 module/output directory，绝不覆盖 known-good artifact。

### 最小 experiment ledger

```text
experiment_id:           target-YYYYMMDD-NN
intent:                  一句话；只含一个概念变量
operator:                本地开发者或经审阅的 AI 辅助流程
target_profile_id:       device/firmware/ROM/carrier tuple
donor_profile_id:        source firmware tuple
baseline_artifact_hash:  SHA-256
candidate_artifact_hash: SHA-256
changed_files:           精确列表
commands_run:            本地保存
workload:                boot / registration / call duration / SMS 等
evidence_window:         起止时间；若可用则记录 kernel audit serial
expected_result:         可观察且可证伪
observed_result:         pass/fail/partial/blocked
rollback_trigger:        预定义条件
rollback_result:         已验证的普通 telephony/data 状态
next_action:             只能由证据决定
```

### 退出条件

- 已测试或可信记录了此设备的 known-good recovery path。
- input 与 baseline hash 已记录。
- 不依赖 candidate 本身即可移除 candidate。
- 第一次 flash 前 experiment ledger 已存在。

### 停止条件

若目标无法恢复、donor 不能精确识别、必要 platform signing 无法合法完成，或继续工作必须公开私有 artifact，则在移植前停止。

---

## 阶段 1：建立 donor 与 target discovery matrix

### 目标

用精确 compatibility profile 替代“这是一台三星手机”。设备系列名过于宽泛：地区版本、SoC、firmware revision、Android API、modem stack、carrier configuration 和 GSI 都可能改变相关契约。

### Target profile 模板

```markdown
## Target profile

| Field | Value | Evidence / command / source | Confidence |
|---|---|---|---|
| Target model / codename |  |  |  |
| Board / SoC / ABI |  |  |  |
| Device variant / CSC / region |  |  |  |
| Bootloader / root / recovery route |  |  |  |
| Target ROM or GSI name/version |  |  |  |
| Android API / security patch |  |  |  |
| `ro.build.tags` and platform-signing condition |  |  |  |
| Vendor firmware build / baseband |  |  |  |
| Carrier / SIM slot / provisioning state |  |  |  |
| Stock IMS package path/name/version/certificate |  |  |  |
| APK archive entries / DEX list |  |  |  |
| Framework JAR paths / DEX lists |  |  |  |
| Native binaries / libraries / ABI dependencies |  |  |  |
| Init service definitions / sockets |  |  |  |
| UID/GID/groups/capabilities |  |  |  |
| Relevant RIL/HAL services/properties |  |  |  |
| AOSP IMS selection / RRO path |  |  |  |
| SELinux live contexts / policy declarations |  |  |  |
| Baseline IMS/call/SMS state |  |  |  |
| Restore method / known-good artifact |  |  |  |
```

为 donor profile 建立相同字段；不要仅因 model name 相近，就把 donor 和 target 合并。

### 安全的调查方式

- 尽可能以只读方式 mount firmware image；在 APK/JAR copy 上工作。
- 使用 Linux/WSL 环境递归检查 archive/decompiled tree。S20 调查表明 host 端递归搜索错误可能得出假结论；必须确认真实 path 与权限。
- 使用与格式匹配的工具：`jar tf`、`aapt`、`apksigner`、`readelf`、`nm`、`strings`、`baksmali`、`apktool`。
- 检查受保护的 system directory 时要考虑目录 traversal permission；非 root 枚举可能造成 false negative。
- 将 command output 与 input hash 一起记录到 inventory。

### 绝不能从 S20 继承的值

- firmware build 和 APK SHA-256；
- APK/JAR DEX count 或 class count；
- package name 与 service class；
- service action/metadata/API generation；
- overlay package/resource；
- daemon name/argument/slot count；
- user/group/capability set；
- SELinux type 或 allow rule；
- library list 与 ABI；
- signing certificate；
- carrier profile 与 emergency test number；
- audio/RTP port/codec；
- build-tool version（除非已独立验证兼容）。

### 退出条件

你应能用证据回答核心模型中的八个问题；或者明确哪一个被阻塞以及原因。不要在 stock APK identity 或 platform-signing path 未知时开始 runtime patch。

---

## 阶段 2：建立未修改基线与有边界的对比证据

### 目标

明确 stock firmware 做什么、unmodified GSI 做什么、每次 candidate 后发生何种变化；这样后续 log 才有解释力。

### 必须进行的 baseline run

在合法且可行时，对下列状态执行相同、时间有边界的 workload：

1. matching stock/donor firmware；
2. 移植前 target GSI；
3. clean reboot 后的每个 candidate；
4. failed candidate 回滚后的 baseline。

workload 应记录开始/结束时间，且只包含安全、授权的操作，例如：

- boot completion 与 package/service discovery；
- IMS registration observation；
- 向安全测试联系人发起一次普通 outgoing call；
- 可行时的一次 incoming call；
- 确认双向 audio 的短通话；
- 适当时的 DTMF；
- 经同意的 IMS SMS；
- 一次 reboot persistence check。

不要反复拨打真实 emergency number。若 operator 有合法 emergency test route，应单独授权、设置时间边界，且永远不能作为安全性的唯一证明。

### 每次运行的 evidence packet

- target/donor profile identifier；
- 精确 artifact hash；
- device time 与 collection-window 起止；
- 与 IMS selection 相关的 package/service dump；
- 包含 UID 与 SELinux context 的 process list；
- daemon state/restart count；
- 相关 system property/HAL readiness state；
- 脱敏 logcat excerpt；
- policy 相关时的 bounded kernel audit/dmesg excerpt；
- workload counter：calls attempted、calls connected、inbound event、SMS segment、RTP/audio observation 等；
- 结果：pass、fail、partial、blocked、regressed、untested 或 not applicable。

### 为什么日志采集必须严谨

[S20-已验证] S20 SELinux 工作发现，Android 13 上重要 AVC 出现在 kernel audit buffer/dmesg，而非稳定出现在 logcat；仅凭 logcat “干净”得出的结论不可靠。`dontaudit` 也可能在 enforcement 仍存在时隐藏 denial。见 [selinux/README.md](../selinux/README.md)。

[可复用方法] 在新目标上，先证明相关 audit event 出现在哪里，再用“没有日志”作为证据。应在 workload 前 arm collection，按时间或 audit serial 限定窗口，并采集 liveness/workload counter。不能从 idle 或 boot-loop process 的无日志推断成功。

### 退出条件

- baseline behavior 已被描述，而不是假设。
- 每个后续 candidate 都能与相同 workload 比较。
- 敏感原始数据保留在可发布 tree 外。

---

## 阶段 3：映射依赖并定位真正缺失的边界

### 目标

在决定是否需要 APK bridge、framework compatibility shim、runtime payload、startup adaptation、policy change 或无需修改前，对每个必要 component 分类。

### Dependency ledger 模板

```markdown
| Dependency | Stock source/path | Target availability | Classification | Evidence | Decision | Owner / next experiment |
|---|---|---|---|---|---|---|
| AOSP IMS package selection |  | existing / absent / unknown | target capability / generated adaptation / unknown |  |  |  |
| Manifest service contract |  |  |  |  |  |  |
| Samsung framework symbol |  |  |  |  | stub / implementation / not needed |  |
| Framework JAR |  |  | donor artifact / target replacement |  |  |  |
| APK DEX entry |  |  | preserved / rebuilt / generated |  |  |  |
| Native library |  |  | matched donor artifact / target capability |  |  |  |
| Daemon/init service/socket |  |  | existing / startup adaptation |  |  |  |
| RIL/HAL/property |  |  | target capability |  |  |  |
| SELinux type/rule |  |  | existing label / candidate policy / unknown |  |  |  |
| Carrier/EPDG config |  |  | matched donor artifact / unknown |  |  |  |
| Media/bearer path |  |  | target-dependent hypothesis |  |  |  |
```

### 分类说明

- **Existing target capability：** target ROM/vendor 已提供；没有证据时不应替换。
- **Matched donor artifact：** 必须来自匹配 donor firmware，且需与周边 stack 保持兼容。
- **Generated adaptation：** 为满足一个已证实缺失契约而写的 project bridge、stub、overlay、launcher 或 build output。
- **Target replacement：** 有意使用 target ROM 提供的 component 替代 donor firmware；必须验证 ABI 与语义兼容。
- **Deliberate exclusion：** 有意省略的 stock component，必须有理由与回归证据。
- **Unknown：** 尚未映射的 dependency；它会阻塞宽泛 packaging 决策。

### 关键诊断区别：内部初始化与 framework binding

[S20 历史经验] 增加缺失三星 framework stub 让更多内部三星初始化继续执行，但没有自动创建 AOSP 可见 IMS service。private singleton 或 private AIDL binder 可以初始化，而 `ImsResolver` 仍没有标准 endpoint。

[可复用方法] 将下列检查分开：

1. stock/internal Samsung graph 是否能在无 missing symbol 情况下初始化？
2. AOSP framework 是否选择了 intended package？
3. framework 是否绑定 declared IMS service？
4. service 是否通过 target API 创建 non-null MMTEL/registration feature？
5. 该 feature 是否真的将 Samsung registration/capability/call event 反映给 framework？

第 2 步失败不能靠添加更多 native blob 修复；第 1 步失败不能靠修改 RRO 修复。必须保持边界清晰。

### API signature 纪律

[S20 历史经验] 早期参考设备也有类似 `GoogleImsService` 概念，但 method signature 和 return type 不同。整体替换 S20 实现会破坏 Android 13 target。可行策略是将 bridge 适配到 target signature，并在有证据时最小化 patch target implementation。

[可复用方法] 对每一个复制或参考的 class，至少验证：

- `.class` 与 `.super` descriptor；
- implemented interface；
- method name、parameter descriptor、return descriptor、throw exception；
- access flag 与 static/instance 行为；
- 引用的 target framework/JAR class；
- field type 与 initialization order；
- 必要时 Binder/AIDL transaction expectation；
- Android API level availability。

class name 相似不是兼容性证据。除非每个 ABI 和行为假设都被证明，否则不得整体替换 target service implementation。

### 退出条件

书面 dependency ledger 已找出第一个需处理的缺失边界。如果 ledger 的结论是“复制所有文件”，说明它仍不完整。

---

## 阶段 4：受控构建与产物可复现性

### 目标

产出可追溯到 immutable donor input、并可在到达设备前检查的 artifact。

### 从 S20 build 可复用的做法

S20 build 是一个模式而不是模板：

```text
经 hash 验证的 stock input
  -> 有序、可审阅的 transformation stage
  -> 在私有目录编译 generated bridge
  -> 与受审阅 snapshot 对比
  -> 只注入已定义的 generated/preserved payload
  -> 适当时 align/sign
  -> structural verification
  -> 单独打包/验证 module
```

对应 S20 script 为 [build/verify_input.sh](../build/verify_input.sh)、[build/build_apk.sh](../build/build_apk.sh)、[build/verify_apk.sh](../build/verify_apk.sh) 和 [BUILD.md](../BUILD.md)。

在新目标上采用这些控制：

1. **固定 input identity。** 修改前 hash donor APK/JAR，并记录 archive entry。
2. **使用有序 stage。** 每个概念状态有名称；stage 必须有已知 input、已知 patch/transform 与验证结果。
3. **分离 generated 与 in-place modification。** patch 修改已有 stock class；generated source 创建完整新 class。没有明确 override rule 时，同一 class 不应同时来自两者。
4. **验证 transformed structure。** decode/reinspect output；检查 DEX entry、expected class、manifest declaration、package/signing metadata 和禁止残留引用。
5. **本地依赖留在本地。** tool JAR、proprietary input、framework dump、cache DEX 和 signing key 应在 ignored directory，不放公开仓库。
6. **区分可复现范围。** functional structure 可复现，而最终 ZIP bytes 可能受 tool version、compression、alignment 和 signing metadata 影响。
7. **拒绝 mismatch。** input hash、DEX layout、required class 或 patch precondition 不匹配时 verifier 应提前失败；不能为了让 unknown input 通过而削弱 verifier。

### Multi-DEX 是 artifact contract，不是优化细节

[S20-已验证] 已记录 S20 stock APK 起初只有一个 DEX，而最终工作产物有四个 DEX。旧的 primary-DEX-only rebuild 虽能安装和签名，却因遗漏功能性 compatibility payload 而无法注册 IMS。

[目标相关] 重建前应盘点 target APK/JAR archive：

```bash
# 仅为模板：替换 input path，并在目标实验环境使用可用工具。
jar tf /path/to/target-ims.apk | grep -E '(^|/)classes[0-9]*\.dex$'
```

对每个 DEX 记录 source、hash、class count、role、class-loader expectation，以及它是 stock-preserved、generated 还是 derived。不要假设所有 secondary DEX 都可直接复制，也不要假设 single DEX 代表没有外部 dependency。

### Build decision tree

```text
Input hash/layout mismatch
  -> 停止；更新 target profile 或选择正确 donor

Patch 无法 clean apply
  -> 停止；比较精确 target class/tree；不要强行 patch offset

Build 失败
  -> 验证 target API JAR、classpath、tool version、descriptor、resource

Structural verifier 失败
  -> 不要 flash；先修复 artifact contract

Install/signature 失败
  -> 检查 package identity、alignment、certificate、shared UID、priv-app placement

Install 成功但 service 未被使用
  -> 在编辑 call code 前检查 selection/manifest/RRO/framework binding

Service bind 但 registration 失败
  -> 检查 target framework symbol、internal initialization、runtime daemon/socket、vendor dependency、policy
```

### Signing 与 package identity

system IMS package 可能以 privileged/shared UID 运行，需要 target ROM platform signature。应确认：

- package name 与 `sharedUserId`/UID 行为；
- target ROM certificate lineage 及是否确实接受 test key；
- installation partition 与 priv-app allowlist；
- manifest-only change 后 package-manager cache 行为；
- signing 是否移除/改变相关 APK entry；
- target Android version 是否要求 ZIP alignment。

[S20 历史经验] 未对齐 APK 可在 Android R+ 安装失败；stale package cache 可掩盖 manifest-only change。这是有用检查项，不代表所有 target 都表现相同。

### 退出条件

candidate artifact 有 source/input manifest、hash、structural verification record 和 rollback artifact。仅成功 compile 不构成退出条件。

---

## 阶段 5：AOSP selection、bridge design 与 runtime startup

本阶段要分开四个经常被混淆的问题：package selection、service binding、internal service adaptation 和 daemon startup。

### 5.1 先证明 framework package selection

framework 不会调用它未选中的 bridge。

#### 调查内容

- target API level 的 `ImsResolver`/Telephony 行为；
- 已安装 IMS-capable package 与 service declaration；
- package enablement 与 package-manager state；
- 控制 IMS package 的 resource overlay，包括 mutable overlay；
- package priority/subscription/slot association；
- 显示 selected package 与 binding attempt 的 framework log/dump。

[S20-已验证] S20 module 使用 RRO 将 `config_ims_mmtel_package` 设为 `com.sec.imsservice`；另一个 mutable IMS overlay 可抢走该 selection。这是 target-specific solution；新目标必须识别真实 resource 与 policy，而不是复制 S20 overlay。

#### 退出条件

在调试 registration 或 media 前，已能用 target evidence 证明 intended package 被 intended slot/subscription 选中。

### 5.2 根据 target contract 设计 AOSP-visible bridge

bridge 可能需要暴露标准 registration、MMTEL feature、call session、incoming call、SMS、emergency、capability 与 configuration 行为，同时委托给 private Samsung implementation。

#### 流程

1. 检查 target framework 与 telephony-common JAR，确定所需 IMS API generation。
2. 检查 stock Samsung service 的 public/private service declaration、Binder interface、singleton/module graph 与 callback path。
3. 定义最小 target-specific adapter boundary：
   - service endpoint；
   - 一个或多个 feature wrapper；
   - registration/capability propagation；
   - call-session conversion；
   - SMS callback conversion；
   - incoming-call notification path。
4. 对 target framework API 编译/编写，而不是对 reference-device JAR。
5. 只有 target implementation 证明必须且安全时，才增加 readiness accessor 或 internal hook。
6. 明确标记未实现 interface path。一个 `null` return 或 no-op 可用于里程碑，但必须记录，不能被误认为支持。

#### 必须进行的静态检查

- manifest action、permission、metadata、exported/single-user setting 与 target framework contract 一致；
- bridge class 使用 target-compatible descriptor；
- hidden/compile-only stub 除非明确需要 runtime，否则不得进入 final output；
- framework service creation 到达 non-null feature instance；
- registration 与 capability state 不仅存于内部，也通过 target API callback path 传递。

### 5.3 区分 registration、capability 和 call bridging

[S20 历史经验] 三星 private registration broadcast 或内部 “ready” state 并不会自动让 AOSP `isImsRegistered` 变为 true。bridge 必须连接 framework-visible registration/capability feature 与 retained Samsung state。

[可复用方法] 将以下问题单独测试：

| 问题 | 所需证据 |
|---|---|
| service 是否被选中并绑定？ | Package/framework dump 加 service lifecycle log。 |
| 是否创建了 feature object？ | Target API callback/method trace 与 non-null return。 |
| framework registration 是否可见？ | Telephony/IMS dump 与 registration callback trace。 |
| capability 是否可见？ | MMTEL capability state 与 callback trace。 |
| framework 能否创建 call session？ | Outgoing-call API → bridge → vendor session trace。 |
| vendor inbound state 能否到达 dialer？ | Vendor callback → bridge → framework incoming-call event。 |

不能用“SIP registration 成功”证明 AOSP dialer integration 正常。

### 5.4 在重建 service 前证明 Magisk/init timing

[S20-已验证] Magisk magic-mount 在 init 解析 `/system/etc/init` 后才让 module init `.rc` 可见；init 因而没有注册 S20 `imsd`，也没有创建 control socket。S20 项目用 `ims_sock_launch` 重建这一已证实缺失职责。见 [post-fs-data.sh](../magisk-module/post-fs-data.sh)。

[可复用方法] 新目标增加 launcher 前必须确认：

- stock init 是否定义该 daemon service？
- target GSI 上该 service 是否确实注册/启动？
- binary 是否因 missing inherited socket、property trigger、environment variable、working directory、user/group、capability、label 或 dependent service 而失败？
- systemless mount 是否确实晚于 init parsing，还是另有原因？
- 需要重建的精确职责是什么？

安全 launcher 只应重建 stock init 已证实提供的内容，例如 socket creation、mode/ownership、一个 environment variable、credential drop 和 exec。它不应变成 init 的通用替代品，也不应手动启动所有 donor binary。

### 5.5 从 stock definition 推导 readiness order 与 privilege

检查 stock `.rc`、service manager state、process attribute 与 live target behavior，记录：

- binary path 与 argument；
- trigger condition 与 dependency；
- 需要的 property/HAL service state；
- socket name/type/mode/owner/group/context；
- UID/GID/supplementary group/capability；
- restart policy 与 crash behavior；
- SELinux process/file context；
- slot/subscription argument semantic。

[S20-已验证] S20 launcher 在启动一个 `multiclientd -s 1` 前等待 `rild` 与 `ril.halservice.registered.slot1=true`。`imsd` 经 launcher 降到受限 `system` identity。当前 tracked S20 script 为 `multiclientd` 选择 root fallback；低权限 radio path 虽存在，但并非默认。任何一项都不是其他 target 的安全默认值。

### 退出条件

- framework 选中并绑定 intended package；
- bridge 无 class/linkage error 地创建可用 target API feature；
- required daemon 只在 evidence-backed readiness condition 后启动；
- process identity、socket ownership 与 basic liveness 符合 target plan。

---

## 阶段 6：将 SELinux 最小化当作证据循环

### 目标

在保持 global enforcing 的前提下，做最小、可辩护的 policy/label/identity 修改来支持已证实 workload，并明确记录残留风险。

### 不可违反的规则

1. 不得把 `setenforce 0` 当作移植方法。
2. 不得假设 stock Samsung SELinux type 存在于 GSI。
3. 不得仅因 stock policy 存在，就复制 `allow` rule、permissive domain 或 domain transition。
4. 不得因规则行数减少就称为“最小”；只有 evidence ledger 解释每项剩余特权为何需要时才能称最小。
5. 不得以 logcat 中没有 AVC 作为 permission evidence。
6. Unix UID/GID/capability 收束与 SELinux-domain confinement 必须分开讨论。

### Evidence-driven loop

```text
functional baseline
  -> arm kernel-audit/log collection
  -> 运行带 liveness counter 的 bounded workload
  -> collect 并分类 evidence
  -> 提出一个窄范围 candidate
  -> flash/apply candidate
  -> 重复完整 workload
  -> 以书面理由 keep 或 revert
```

### 提出 policy 前必须采集的数据

- candidate source/target type 的 loaded-policy declaration；
- live process context（`ps -AZ` 或等价方式）；
- live file、library、directory、device、property、socket context；
- process UID/GID/groups/capability；
- workload 附近的 kernel audit record；
- app/framework/native log 与 restart count；
- 精确 workload/liveness counter；
- candidate 与 baseline diff。

### 只有 policy 证明合适时才优先 relabel

[S20-已验证] S20 工作在 loaded GSI policy 已提供必要 access 的情况下复用了 `system_file`、`system_lib_file`、`imsd_socket` 与 `rdxdump_data_file` 等 label；没有添加新 allow rule。`radio_data_file` 因缺少所需 directory creation permission 被拒绝。target GSI 没有 `imsd`/`imsd_exec` 或 `multiclientd`/`multiclientd_exec` type，因此三星专用 domain transition 不可能工作。

[可复用方法] 新目标上 relabel 只有在以下条件全部满足时才有效：

1. target loaded policy 声明 candidate type；
2. relevant source domain 已拥有精确所需 operation；
3. object semantic 与 type 的预期 exposure 一致；
4. 完整 workload 中 operation 成功；
5. relabel 不会让额外的非预期 client 获得更宽 access；
6. 结果有 pre/post context 和 audit evidence 记录。

任何一个条件不满足都应视为 hypothesis failure，不能把任意 path 重标记为“看起来有希望”的三星 type。

### Residual permissive 必须报告，不能隐藏

[S20-已验证] 当前 S20 port 保留 `permissive system_app`，因为 enforcing 会通过 framework-owned resource-cache/idmap access 阻断注册。该 path 归 framework 所有，不能靠 module relabel 解决；宽泛新 grant 会影响 domain 内多个 process。因此 global enforcing 不等于完全 confined IMS。

[可复用方法] 若新目标必须保留 permissive domain，应记录：

- exact domain 与共享它的 process；
- 移除后失败的 required workload 与 symptom；
- bounded audit/evidence attempt；
- 已尝试并拒绝的替代方案；
- risk statement；
- rollback behavior；
- 未来重新评估的条件。

绝不能将它掩盖在“SELinux enforcing”措辞后。

### 退出条件

candidate 已通过必要 workload 且有证据。SELinux ledger 解释每个仍保留的 label、policy rule、permissive setting、identity 和 capability。若做不到，应将 port 标记为 experimental，并保留 known-good rollback route。

---

## 阶段 7：signaling、media、重复通话与恢复验证

### 目标

证明用户可见的 IMS 行为，而不是停在 registration。

### Required feature matrix

对每个 target/firmware/ROM/carrier 组合使用此表；`Pass` 必须带有日期、artifact/profile/evidence reference。

| Feature | Status | Evidence ID | Notes / regression condition |
|---|---|---|---|
| Package selected by framework | untested |  |  |
| IMS service bound | untested |  |  |
| Framework registration visible | untested |  |  |
| MMTEL capabilities visible | untested |  |  |
| Outgoing ordinary call setup | untested |  |  |
| Incoming ordinary call delivery | untested |  |  |
| Bidirectional audio | untested |  |  |
| Codec negotiation | untested |  |  |
| RFC 4733 DTMF, if applicable | not applicable |  |  |
| IMS SMS MO | untested |  |  |
| IMS SMS MT / multi-segment | untested |  |  |
| Repeated call after teardown | untested |  |  |
| Reboot persistence | untested |  |  |
| Network/radio transition | untested |  |  |
| Call waiting/hold/forwarding | untested |  |  |
| Video / RCS | unsupported |  |  |
| Authorized emergency-test route | untested |  | 不得作为唯一安全证明。 |
| Long-duration stability | untested |  |  |

允许状态为 **pass**、**fail**、**partial**、**blocked**、**untested**、**regressed**、**not applicable**；不能用“works”替代。

### 分离 signaling 与 media

一个 call 可注册并 connect，却出现 one-way/no audio。应依次调查：

1. framework selected/bound state；
2. registration 与 capability state；
3. outgoing/incoming call session creation；
4. 在合法可查看时的 SIP/IMS signaling 与 SDP offer/answer；
5. bearer/dedicated-bearer 或等价 vendor callback state；
6. codec/PT mapping 与 negotiated bitrate；
7. RTP endpoint ownership、bind address/port、socket routing 与 packet direction；
8. Android audio routing 与 call-audio integration；
9. teardown 与下一次通话 state。

[S20-已验证] S20 项目在其 GSI 上观察到 CP-side media path 不触发，因此增加 AP-side RTP/media adaptation；后续又发现 repeated-call port rotation、codec/DTMF 细节需要 target-specific handling。这说明 media 是独立 subsystem，不是把 AP RTP 代码预先移植到其他设备的理由。

### 调用“reset”API 前追踪 lifecycle semantic

[S20 历史经验] 一项 deregistration 实验破坏了下一次 registration，因为所选三星 API 执行的是 manual profile removal，而非临时 network refresh。更早实验还因 log string 与最终 consumer 不一致而误读 parameter semantic。

[可复用方法] 调用 vendor “reset”、“deregister”、“remove”、“stop” 或 “release” API 前：

- 将 parameter trace 到最终 consumer；
- 确定它是 manual 还是 network-triggered behavior；
- 找出谁会在之后 recreate profile/session；
- 证明 idempotency 与 repeated-call behavior；
- 将 destructive action 与有文档的 rebuild/re-register path 配对；
- 分别测试 clean reboot 与 repeat call。

不得将 radio reset 作为静默永久修复；若 workaround 会中断 service，必须显著说明持续时间、影响和 unsupported scenario。

### 退出条件

target 有一份 evidence-backed feature matrix。只完成 registration 的 port 只是 registration prototype，不是 VoLTE/IMS release。

---

## 阶段 8：release、rollback 与维护交接

### 目标

将成功的 lab result 变成有边界、可复现的 deliverable；或清楚说明它仍是 experimental。

### Release manifest

每个 proposed release 至少应包含：

```text
release_id:
source_revision:
target_profile_id:
donor_firmware_identity:
donor_artifact_hashes:
target_rom_gsi_identity:
platform-signing requirement:
toolchain versions:
input/proprietary source policy:
APK/JAR/module artifact hashes:
payload manifest hash:
validation matrix reference:
known limitations:
residual SELinux/privilege risks:
unsupported variants:
rollback artifact and instructions:
```

### 只打包已声明 payload

[S20-已验证] S20 module 使用 `payload-manifest.tsv` 作为 packaging authority，并验证 selected input/final ZIP；这可避免意外发布 host tool、log、key、temporary file、old experiment 或任意 blob。

[可复用方法] 创建 target-specific manifest，使用如 stock-identical、project addition、compatibility override、patched artifact 和 intentional omission 等类别。每个 non-stock entry 都必须有 reason、source、hash 和 regression result；不得 bulk-copy 整个 vendor/system tree。

### Rollback runbook

1. 到达预定义 rollback trigger 时停止测试。
2. 在进一步改变状态前保存安全、脱敏证据。
3. 通过 target 预定 recovery route 禁用/移除最新 candidate。
4. 恢复 verified last-known-good module 或 stock baseline。
5. reboot 后确认普通 telephony/data，再继续调查。
6. 以 hash、精确 symptom、evidence window 和 rollback result 将 candidate 标记为 rejected。
7. 不要把 rejected candidate 中未经审阅的修改带入下一个 candidate。

### Publishing rule

只发布 validation matrix 支持的 claim。明确 model、SoC、firmware、ROM/GSI、Android version、carrier condition、signing assumption、known limitation 和 residual policy risk。不能因为一个地区版本成功就声称整个 device family 可用。

---

# 第三部分：开发者与 AI 编程工具操作规范

## 1. AI 编程工具可以和不可以做什么

AI 可协助 inventory file、compare interface、draft hypothesis、propose narrow diff、编写 verifier、生成模板、总结脱敏 evidence 和编写文档。

AI 不得：

- 捏造 command output、hash、class descriptor、policy declaration、成功测试、radio behavior 或 carrier support；
- 仅凭 model name 或 reference-device source 推断 target compatibility；
- 自动 flash module、修改 rooted device、修改 recovery asset 或测试 emergency route；
- 默认建议 `setenforce 0`；
- 提取、发布或提交 platform key、proprietary blob、PCAP、raw IMS trace 或 personal identifier；
- 为使 unknown artifact 通过而削弱 hash/structural verifier；
- 未建立 dependency ledger 且未经人工审阅就替换 vendor RIL/radio component 或复制全部 donor blob；
- 未经明确人工批准和风险记录就悄悄扩大 SELinux policy、增加 permissive domain 或保留 root daemon execution。

## 2. Read-before-write protocol

在提出 code 或 policy change 前，AI 必须检查：

1. target profile 与 donor profile；
2. baseline artifact hash 与 archive layout；
3. 当前 build/runtime/policy implementation；
4. 最近的相关历史实验及其 active、rejected 或 superseded 状态；
5. 实际 target class/method descriptor 与 target framework API；
6. 当前 failure evidence 与 collection window；
7. 人工批准的 allowed file 与 scope。

在提出 command 前，应先分类：

| Command class | 示例 | 要求 |
|---|---|---|
| Read-only host | archive listing、hashing、decode 到 temp copy | 写明 source path 与 expected observation。 |
| Read-only device | dump、process/context/property inspection | 写明 privacy impact 与 collection window。 |
| Derived artifact build | compile、patch copy、sign derived output | 写明 input、output path、verification 与 no-overwrite rule。 |
| Device mutation | module install、policy/identity change、property change | 需要明确人工批准、rollback 与 success/failure criteria。 |
| Recovery-affecting | boot/vendor/system modification、故障时 module removal | 需要人工确认 recovery plan。 |

## 3. 必须提供给 AI 的 evidence packet

应给 AI 提供紧凑但完整的 packet，而不是无限长的原始日志：

```markdown
## Goal
一条可证伪的句子。

## Single experiment variable
恰好一个概念修改。

## Target profile
Device、SoC、firmware、ROM/GSI、Android API、carrier/slot、signing condition。

## Donor profile
精确 firmware/build 与 source artifact hash。

## Baseline
Known-good artifact/hash 与可观察 baseline behavior。

## Evidence
含 timestamp/audit serial、workload counter 和 source path 的脱敏 excerpt。

## Expected observation
什么结果会支持 hypothesis？

## Failure interpretation
什么结果会否定它，或将 triage 移到其他 layer？

## Rollback
Artifact/path/procedure 与 trigger。

## Allowed scope
AI 可 inspect 或 modify 的 file/command。
```

## 4. AI 输出契约

每个 proposal 必须包含：

1. hypothesis 与 confidence label；
2. 引用的 local evidence/source path；
3. dependency model 中受影响的 layer；
4. 最小 file list 及每个改动理由；
5. 精确 build/structural verification；
6. bounded on-device validation workload；
7. negative/regression test；
8. rollback instruction；
9. assumption 与 unknown；
10. 该修改明确**不能**证明什么。

应拒绝“add permissive”、“copy the blobs”、“replace the service”、“flash and see”或“try the S20 patch”这类模糊输出，除非它被转换成有证据、可回滚的窄范围实验。

## 5. Symptom-first triage matrix

| Symptom | 首先采集的证据 | 不应先假设 |
|---|---|---|
| APK 无法安装 | alignment、certificate、shared UID、partition placement、package-manager error | DEX code 一定有问题 |
| APK 已安装但 IMS package 未使用 | manifest service、action/permission/metadata、overlay selection、package enablement | modem/radio 已坏 |
| Package 已选中但 framework binding 失败 | target API contract、service lifecycle、class/linkage error、feature creation | 必定需要更多 blob |
| Service bind 但 registration 仍 false | registration/capability callback bridge、missing framework symbol、internal readiness、daemon/socket state | SIP registration 本身足够 |
| Daemon 立即退出 | stock init contract、socket FD/env、executable path、UID/GID/cap、SELinux context、missing library | restart loop 能修复 |
| Registration 正常但 outgoing call 失败 | session bridge、slot/radio readiness、daemon/vendor/RIL state、call log | audio/media code 已相关 |
| Call connect 但无音频 | SDP/codec/bearer/RTP path/audio routing、合法时的 packet evidence | registration 已坏 |
| 仅 repeated/second call 失败 | teardown/recovery state、port rotation、profile lifecycle、与 clean reboot 比较 | 首通成功证明稳定 |
| AVC 看似干净但功能失败 | kernel audit source、`dontaudit`、workload completeness、process liveness | policy 无关 |
| Boot loop/reboot/crash loop | 先执行 rollback；其次保存安全 evidence | 更多修改仍安全 |

## 6. Human approval gate

下列操作前必须有明确人工确认：

- flash/install 新 candidate；
- 修改 daemon UID/GID/groups/capability；
- 增加 SELinux rule、label 或 permissive domain；
- 修改会改变 IMS selection 的 package manifest 或 RRO；
- 增加/删除 module payload entry；
- 将 proprietary dependency 引入 distribution；
- 运行 emergency 相关测试；
- 发布 binary 或 support claim。

---

# 第四部分：可复用 checklist 与模板

## A. Donor extraction 与 provenance manifest

```markdown
# Donor provenance manifest

- donor_profile_id:
- lawful source/reference:
- model / board / SoC / region:
- firmware build / Android API / patch level:
- extraction image and partition:
- mount mode: read-only / other (explain)
- artifact path:
- SHA-256:
- archive entry inventory saved at:
- dependent JAR/library/binary/configuration inventory:
- license/redistribution classification:
- local storage location (not committed):
- extraction date/operator:
- verification reviewer:
```

## B. Artifact verification checklist

```markdown
- [ ] Input hash matches target profile.
- [ ] Input archive entries/DEX layout recorded before modification.
- [ ] Ordered patches/transforms apply cleanly to this exact input.
- [ ] Generated classes do not collide with patched/preserved classes.
- [ ] Output DEX entries and class sets match the declared target artifact contract.
- [ ] Manifest service/action/permission/metadata match target framework evidence.
- [ ] Hidden compile-only classes are absent unless explicitly required at runtime.
- [ ] Native libraries/assets/configuration are declared, not incidental.
- [ ] APK alignment is verified where required.
- [ ] Signature/certificate/shared-UID expectations match the target ROM.
- [ ] Output hash and build tool versions are recorded.
- [ ] A structural failure prevents flashing.
```

## C. Runtime readiness checklist

```markdown
- [ ] Intended package is selected by the target framework.
- [ ] Intended service is bound for the intended slot/subscription.
- [ ] Feature creation is observed and non-null.
- [ ] Registration and capabilities become visible through framework callbacks/dumps.
- [ ] Required donor daemons are identified and only necessary ones start.
- [ ] Every required socket has target-derived name/mode/owner/context.
- [ ] Required properties/HAL/radio state are ready before dependent daemon launch.
- [ ] Process path, UID/GID/groups/capabilities, and SELinux context are recorded.
- [ ] Crash/restart behavior has a bounded policy and is observable.
- [ ] Module does not block boot or leave unbounded retry loops.
```

## D. SELinux candidate ledger

```markdown
| Candidate ID | One change | Source/target types | Precondition evidence | Workload | AVC/audit result | Functional result | Exposure/risk | Keep or revert | Rollback verified |
|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |
```

## E. Failure 与 rollback report

```markdown
# Candidate failure report

- candidate artifact/hash:
- target profile:
- first bad boot/test timestamp:
- workload completed before failure:
- symptom and user-visible impact:
- process/daemon state:
- redacted evidence references:
- changed variable:
- hypothesis result: supported / refuted / inconclusive
- rollback trigger met:
- rollback procedure:
- post-rollback ordinary telephony/data verification:
- candidate disposition: rejected / needs narrower reproduction
- prohibition for future work (if applicable):
```

## F. Release 与 non-claim checklist

```markdown
- [ ] Exact target model, SoC, firmware, ROM/GSI, Android version, and carrier conditions are stated.
- [ ] Donor artifacts and derived outputs have hashes/provenance.
- [ ] Platform-signing requirement is stated without publishing a key.
- [ ] Module payload is manifest-defined and excludes host tools, logs, keys, and temporary artifacts.
- [ ] Build and module verifiers pass.
- [ ] Validation matrix is attached with pass/fail/partial/untested states.
- [ ] Known limitations and residual SELinux/privilege risks are visible.
- [ ] Emergency behavior is not guaranteed or marketed as safe.
- [ ] Unsupported variants are explicitly listed.
- [ ] Rollback artifact and recovery steps are available.
- [ ] No raw identifiers, PCAPs, private keys, or proprietary blobs are committed without legal review.
```

## 最终原则

参考 port 的价值在于它展示了**如何提出并验证正确问题**；当它被当作一箱可互换的三星文件时，它就会变得危险。

对每一个新设备，都应重新从 target profile、immutable donor evidence、framework contract、dependency ledger 和 one-variable experiment 开始。保留已验证可用的内容，证明其为何可用，并清楚记录仍不支持的部分。
