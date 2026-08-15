# S20 IMS 系统属性测试参考

> 本文是已记录 **S20 / Android 13 GSI** 基线的中文测试参考。英文架构和跨设备方法论见[架构与兼容性模型](ARCHITECTURE.md)与[跨设备三星 IMS 移植指南](CROSS_DEVICE_PORTING_GUIDE.zh-CN.md)。
>
> **不能把这些值复制到其他设备。** 属性名、默认值、读取时机、IMS API、radio 行为、SELinux property context 和 audio 路径都可能随固件、SoC、ROM、运营商和 APK 构建而变化。

本文件列出当前公开工程中由 IMS bridge、Magisk runtime 或已记录测试流程实际读取的 Android system property。它用于控制一次有证据、有回滚的测试；不是“让 IMS 工作”的通用 `setprop` 清单。

## 先读安全规则

- 只在保留了 last-known-good 模块和设备恢复方式的测试设备上修改属性。
- 一次 candidate **只修改一个概念变量**；记录旧值、命令、APK/module SHA-256、workload、时间窗口和回滚结果。
- `persist.*` 通常跨重启保留。测试结束必须恢复或清空；不能仅依赖下一次刷模块来覆盖它。
- 不要手写 `ril.halservice.registered.slot1`、`sys.boot_completed`、`ro.build.tags`、`persist.radio.multisim.config` 或 `persist.ims.mock.multisim`。它们在本项目中是**观测值**，不是开关。
- 不要执行 `setenforce 0`。已验证 S20 上全局关闭 enforcing 会触发三星 RKP 重启；详见 [SELinux 文档](../selinux/README.md)。
- 不要把测试中的 IMSI、IMEI、号码、SIP/PCAP 或私钥提交到仓库。
- 不要依赖实验性 IMS 拨打紧急电话；始终保留其他紧急联络方式。

## 证据与状态标签

| 标签 | 含义 |
|---|---|
| **当前基线** | 当前公开 bridge 会读取，且是已记录 S20 成果的一部分。 |
| **诊断开关** | 当前代码可读取，但只应用于受控诊断；不能据此宣称功能支持。 |
| **高风险实验** | 会拆注册、IMS PDN 或 radio；必须人工确认、单变量执行并验证恢复。 |
| **历史/已替代** | 保留在源码中用于重现实验或 bisect；不是推荐默认路径。 |
| **只读观测** | 项目只读取；不能人工伪造或写入。 |

## 读取与生效规则

所有项目自定义测试开关均为 `persist.vendor.ims.*`，桥接代码只通过 `android.os.SystemProperties.get*()` **读取**，不会写入它们。若目标 ROM 的 property policy 允许，可由 root shell 在测试前设置；是否允许、是否持久化及何时真正生效均须在设备上验证。

常用的受控测试模板如下。它不是对每个属性都安全或适用：

```bash
adb shell su -c 'getprop persist.vendor.ims.<name>'
```

```bash
adb shell su -c 'setprop persist.vendor.ims.<name> <value>'
```

```bash
adb shell su -c 'setprop persist.vendor.ims.<name> ""'
```

最后一条用于清空测试值并让 bridge 回退代码默认值；清空后按该属性的读取时机重启 IMS、结束当前通话或重启设备。`persist.*` 的空值是否完全等价于“未设置”，必须用 `getprop` 和 bridge 日志确认。

`ApMediaConfigPoc` 对大多数布尔值接受 `1`/`true`/`on`/`yes` 与 `0`/`false`/`off`/`no`（不区分大小写）；其它值会记录 `CONFIG_REJECT` 并回退默认值。整数开关必须在代码定义范围内，否则也会回退默认值。读取来源见 [`ApMediaConfigPoc.java`](../java/com/sec/internal/google/ApMediaConfigPoc.java)。

## 总览

| 属性 | 分类 | 默认/安全基线 | 读取时机 | 状态 |
|---|---|---|---|---|
| `persist.vendor.ims.ap_media_rotate_ports` | 媒体开关 | `false` | 每通已建立呼叫 | 当前基线；已验证必须关闭 |
| `persist.vendor.ims.ap_rtp_playback` | 下行媒体 | `true` | 每通建立时 | 当前基线 |
| `persist.vendor.ims.ap_uplink_rtp` | 上行媒体 | `true` | endpoint 锁定和发送循环 | 当前基线 |
| `persist.vendor.ims.ap_dtmf_rtp` | RFC 4733 DTMF | `true` | DTMF 事件时 | 当前基线 |
| `persist.vendor.ims.ap_rtp_port` / `ap_rtcp_port` | RTP 端口 | `1234` / `1235` | 每通建立时 | 诊断开关 |
| `persist.vendor.ims.ap_rtp_mode` | 下行播放/采集模式 | `play` | Probe 创建时 | 诊断开关 |
| `persist.vendor.ims.ap_rtp_capture_bytes` | 下行采集上限 | `1048575` | Probe 创建时 | 诊断开关；有隐私风险 |
| `persist.vendor.ims.ap_rtp_jitter` | 下行抖动队列 | `12` | Probe 创建时 | 诊断开关 |
| `persist.vendor.ims.ap_rtcp_rr` / `ap_rtcp_rr_interval` / `ap_rtcp_rr_ssrc` | RTCP RR | `true` / `5` / 随机 | 每通 Probe/发送 RR 时 | 诊断开关 |
| `persist.vendor.ims.ap_uplink_source` | 上行音频源 | `voice_uplink` | 上行建立时 | 当前基线 |
| `persist.vendor.ims.ap_uplink_rtp_seconds` | 上行最长时长 | `32766` | 上行线程创建时 | 诊断开关 |
| `persist.vendor.ims.ap_uplink_pt_override` | 上行 PT override | `-1` | wire-profile 解析时 | 诊断开关 |
| `persist.vendor.ims.ap_uplink_nb_bitrate` / `ap_uplink_wb_bitrate` | AMR bitrate | `12200` / `12650` | 上行编码器创建时 | 诊断开关 |
| `persist.vendor.ims.ap_dtmf_nb_pt` / `ap_dtmf_wb_pt` / `ap_dtmf_clock` / `ap_dtmf_pt` | DTMF/RTP PT | `110` / `111` / media clock / `111` | DTMF 或 media profile 时 | 诊断开关 |
| `persist.vendor.ims.ap_uplink_capture` / `ap_uplink_seconds` / `ap_uplink_bytes` / `ap_uplink_file` | 上行 PCM 采集 | `false` / `10` / `320000` / `false` | 已建立呼叫时 | 诊断开关；高隐私风险 |
| `persist.vendor.ims.ap_allow_call_waiting` | 第二来电 gate | `false` | 来电投递时 | 诊断开关；功能风险 |
| `persist.vendor.ims.ap_stuck_call_fix` | 失败呼叫终结补偿 | `true` | `callSessionInitiatingFailed` 时 | 当前基线 |
| `persist.vendor.ims.ap_latch_probe_*` | 第二通 bearer/reset 实验 | rung `6` | 最后一通结束后 | 高风险实验 |
| `persist.vendor.ims.ap_dual_ims_override` | 双 IMS UA config override | `false` | UA 配置时 | 诊断开关；未形成 DSDS 支持 |
| `persist.vendor.ims.ap_eps_only_override` | EPS-only call setup override | `false` | 呼叫 setup 时 | 诊断开关 |
| `persist.vendor.ims.ap_sae_reset_on_last_call` | `saeTerminate` 尝试 | `false` | 最后一 session 移除时 | 历史/已替代 |
| `persist.vendor.ims.ap_media_timeout` | Samsung native media timeout override | `32766` | 注册 profile 构建时 | 诊断开关；高风险 |
| `persist.ims.gcfmode` / `persist.radio.gcfmode` | Samsung GCF test-mode 状态 | 由 Samsung 代码写入 | GCF mode 切换时 | 原厂内部属性；不作为手工测试开关 |
| `persist.ims.salescode.sve` | SVE camera sales-code 状态 | 由 Samsung 代码写入 | 视频/相机启动路径 | 原厂内部属性；不作为 IMS 测试开关 |
| `persist.ims.simmobility` | Samsung SIM-mobility 状态 | 由 Samsung 代码读取 | SIM mobility 配置路径 | 原厂内部属性；只读观察 |
| `ro.product.first_api_level` | 首发 API level | ROM 固定 | IMS service-switch 路径 | 只读观测 |
| `ril.halservice.registered.slot1` | radio readiness | 期望 `true` | 模块启动 `multiclientd` 前 | 只读观测 |
| `sys.boot_completed` | boot readiness | 期望 `1` | `service.sh` 等待启动完成 | 只读观测 |
| `persist.radio.multisim.config` | dual-SIM 诊断 | 无项目默认值 | UA/call snapshot | 只读观测 |
| `persist.ims.mock.multisim` | dual-SIM 诊断 | 无项目默认值 | UA/call snapshot | 只读观测 |
| `ro.build.tags` | 签名环境检查 | `test-keys` 或 `release-keys` | 构建/部署前 | 只读观测 |

下文中出现的所有 `ap_*` suffix 均完整展开为 `persist.vendor.ims.ap_*`。

---

# 1. 当前媒体与通话基线

## `persist.vendor.ims.ap_media_rotate_ports`

| 字段 | 内容 |
|---|---|
| 分类 | 当前基线的媒体开关 |
| 默认值 | `false` |
| 允许值 | 布尔值；代码接受 `1/0`、`true/false`、`on/off`、`yes/no` |
| 读取者 | `ApRtpReceivePoc.onEstablished()`，经 `ApMediaConfigPoc.bool()` |
| 生效时机 | 每通已建立时选择 RTP/RTCP 监听端口 |
| 作用 | `false` 时每通固定用 `ap_rtp_port`/`ap_rtcp_port`；`true` 时按 `callId` 将端口每次加 2。 |
| 回滚 | 设置为 `false` 或清空，再结束当前通话并进行下一次全新通话；必要时重启。 |

[S20-已验证] 必须保持 `false`。若为 `true`，AP 侧接收端口按 `1234 + (callId - 1) * 2` 等轮换，但 Samsung native SDP 端口独立决定且未同步这一属性。第三通及以后可能出现 SDP 仍报 `1234`、AP 却绑定 `1238`，表现为“接通但无声”。来源：[README.md](../README.md) 和 [`ApRtpReceivePoc.java`](../java/com/sec/internal/google/ApRtpReceivePoc.java)。

**测试建议：** 不要把它当作性能优化。仅在研究端口轮换假设时，将它改为 `true`，至少测试三通连续电话，记录 `PORT_SELECT`、SDP/协商日志、`FIRST_RTP` 与双向音频；完成后立即恢复 `false`。

## `persist.vendor.ims.ap_rtp_playback`

| 字段 | 内容 |
|---|---|
| 分类 | 下行 RTP 解码/播放 gate |
| 默认值 | `true` |
| 读取者 | `ApRtpReceivePoc.onEstablished()` |
| 生效时机 | 每通建立时 |
| `true` | 创建 AP RTP/RTCP Probe，继续接收、解码并播放下行音频。 |
| `false` | 本通不创建 Probe；可用于隔离 CP/AP 下行媒体问题。 |
| 回滚 | 设回 `true` 或清空，然后重新发起通话。 |

`false` 不是“修复无声”，而是用于确认问题是否位于 AP 下行链路。它会故意关闭项目的下行媒体实现。

## `persist.vendor.ims.ap_uplink_rtp`

| 字段 | 内容 |
|---|---|
| 分类 | 上行 RTP gate |
| 默认值 | `true` |
| 读取者 | `ApRtpReceivePoc` endpoint 锁定后，以及 `ApRtpUplinkPoc` 发送循环中 |
| 生效时机 | endpoint 识别后和每次上行读音频循环时 |
| `true` | 以协商/wire profile 的 PT 启动 AP 上行 RTP。 |
| `false` | 不启动或停止 AP 上行 RTP；可用于验证上行是否来自该 bridge。 |
| 回滚 | 设回 `true` 或清空，重新建立通话。 |

此属性允许在通话过程中被发送循环再次读取，但不应把动态切换当作稳定功能；用新的通话做比较。

## `persist.vendor.ims.ap_dtmf_rtp`

| 字段 | 内容 |
|---|---|
| 分类 | RFC 4733 DTMF ownership gate |
| 默认值 | `true` |
| 读取者 | `ApRtpReceivePoc.routeDtmf()` |
| 生效时机 | 每个 DTMF start/stop/pulse 事件 |
| `true` | 在存在唯一有效 AP 上行 session 时，由 AP RTP 路径发送 DTMF。 |
| `false` | bridge 返回 `false`，允许既有路径处理 DTMF。 |
| 回滚 | 设回 `true` 或清空；用 NB/WB 分别验证。 |

DTMF PT 及 clock 需与 codec profile 一起验证；见第 3 节。

## `persist.vendor.ims.ap_rtp_port` 与 `persist.vendor.ims.ap_rtcp_port`

| 属性 | 默认值 | 范围 | 作用 |
|---|---:|---:|---|
| `persist.vendor.ims.ap_rtp_port` | `1234` | `1..65535` | 每通固定端口模式下的 RTP 监听基端口。 |
| `persist.vendor.ims.ap_rtcp_port` | `1235` | `1..65535` | 每通固定端口模式下的 RTCP 监听基端口。 |

无效值会回退默认值。两者不能相同；代码在通话建立时会拒绝相同/越界端口。不要随意改成 carrier 或 native 已占用端口。改动后以新通话验证 `PORT_SELECT`、socket bind、`FIRST_RTP`/`FIRST_RTCP` 和双向语音。回滚为清空或恢复 `1234`/`1235`。

## `persist.vendor.ims.ap_rtp_mode`

| 字段 | 内容 |
|---|---|
| 分类 | 下行 RTP 诊断模式 |
| 默认值 | `play` |
| 读取者 | `ApRtpReceivePoc.Probe` 创建时 |
| `play` | 解码并创建 `AudioTrack`；正常测试模式。 |
| `capture` | 保留 RTP 采集但关闭 decode/track，用于分离包到达与音频渲染。 |
| 其他任何值 | 当前实现仍会 decode，但不会创建 track；这不是稳定公开模式。 |
| 回滚 | 清空或设为 `play`，下一通重新建立。 |

仅 `play` 和 `capture` 应用于有意测试。不要用未知字符串做“关闭媒体”的开关。

## `persist.vendor.ims.ap_rtp_capture_bytes`

| 字段 | 内容 |
|---|---|
| 分类 | 下行 RTP 调试采集大小上限 |
| 默认值 | `1048575` bytes |
| 有效范围 | `0..8388607`，超界会 clamp |
| 生效 | 每通 Probe 创建时 |
| `0` | 不写下行 RTP capture 文件。 |
| 大于 `0` | 最多采集该字节量到 `/data/vendor/ims/desem22_call_<id>.rtpdump`。 |
| 风险 | 捕获 RTP 可能包含语音/号码相关内容；不能提交或公开。 |
| 回滚 | 设 `0` 或清空；删除本地敏感 capture。 |

建议默认使用 `0`，除非正在进行经过授权的媒体故障调查。

## `persist.vendor.ims.ap_rtp_jitter`

| 字段 | 内容 |
|---|---|
| 默认值 | `12` |
| 有效范围 | `3..50`，超界值会 clamp |
| 读取时机 | 每通 Probe 创建时 |
| 作用 | 限制下行 RTP 重排序队列大小；过小会增加丢帧/重排风险，过大增加延迟。 |
| 回滚 | 清空或恢复 `12`，对比相同网络和 codec 的通话。 |

这是媒体调参，不是网络丢包的通用修复。需同时记录 `dropped`、`reordered`、jitter、RTP 包数和实际听感。

---

# 2. RTCP、codec、PT 与上行音频参数

## `persist.vendor.ims.ap_rtcp_rr`、`persist.vendor.ims.ap_rtcp_rr_interval`、`persist.vendor.ims.ap_rtcp_rr_ssrc`

| 属性 | 默认值 | 有效值 | 作用与风险 |
|---|---:|---|---|
| `persist.vendor.ims.ap_rtcp_rr` | `true` | 布尔值 | 是否发送 RTCP Receiver Report；关闭可隔离反馈路径，但不应作为长期媒体配置。 |
| `persist.vendor.ims.ap_rtcp_rr_interval` | `5` 秒 | `3..10` | RR 发送间隔；无效值回退默认。 |
| `persist.vendor.ims.ap_rtcp_rr_ssrc` | 随机 32-bit 值 | 十进制或 `0x` 十六进制，`0..0xffffffff` | 覆盖接收端 SSRC；无效值回退随机值。 |

它们在每通 `Probe` 创建时读取（SSRC 在每次 RR 发送时读取）。只有在已经证实 RTP/RTCP endpoint 和网络绑定正常后才测试。固定 SSRC 可能影响远端对会话的处理，不应作为普通用户设置。清空可恢复默认。

## `persist.vendor.ims.ap_uplink_source`

| 字段 | 内容 |
|---|---|
| 分类 | 上行音频来源选择 |
| 默认值 | `voice_uplink` |
| 允许值 | `mic`、`voice_communication`、`voice_uplink` |
| 读取者 | `ApMediaConfigPoc.source()` 和 `ApRtpUplinkPoc` |
| 生效时机 | 上行 encoder/`AudioRecord` 创建时 |
| 回滚 | 清空或设为 `voice_uplink`，重新通话。 |

`voice_uplink` 是已记录 S20 基线。`mic` 或 `voice_communication` 仅用于比较 audio HAL 路由；它们可能产生静音、回声、错误音源或权限/路由差异。`ApUplinkCapturePoc` 的独立诊断默认值是 `mic`，不要把该 capture 默认误认为正式上行 RTP 默认。

## `persist.vendor.ims.ap_uplink_rtp_seconds`

| 字段 | 内容 |
|---|---|
| 默认值 | `32766` 秒 |
| 有效范围 | `0..32766` |
| 生效 | 上行 RTP thread 创建时 |
| `0` | 代码将其视为不设时长上限，直到通话生命周期结束。 |
| 正整数 | 到达秒数后停止上行 RTP；用于短时诊断。 |
| 回滚 | 清空；不要把短时长遗留到功能测试。 |

## `persist.vendor.ims.ap_uplink_pt_override`

| 字段 | 内容 |
|---|---|
| 默认值 | `-1`（不覆盖） |
| 有效值 | `-1` 或动态 PT `96..127`；其他静态 PT 会被拒绝并回退 `-1`。 |
| 生效 | 在未获得协商 media、由 wire profile 识别 codec 时。 |
| 作用 | 强制 AP uplink 使用指定 PT，而不是使用 wire 对称假设。 |
| 风险 | PT 与对端/SDP 不一致会导致上行无声或 codec 错误。 |
| 回滚 | 清空或 `-1`，重新发起通话。 |

不应把抓包中一次看到的 PT 当作永久值。优先使用协商 profile；此属性只用于证明 PT 假设。

## `persist.vendor.ims.ap_uplink_nb_bitrate` 与 `persist.vendor.ims.ap_uplink_wb_bitrate`

| 属性 | 默认值 | 允许值 | 说明 |
|---|---:|---|---|
| `persist.vendor.ims.ap_uplink_nb_bitrate` | `12200` | `4750`、`5150`、`5900`、`6700`、`7400`、`7950`、`10200`、`12200` | AMR-NB encoder bitrate。非法值回退 `12200`。 |
| `persist.vendor.ims.ap_uplink_wb_bitrate` | `12650` | 当前实现只接受 `12650` | AMR-WB bitrate；其它值不会形成有效 override。 |

读取于上行 encoder 创建时。bitrate 必须与协商 codec/profile 和网络允许的模式相匹配；仅因“声音差”而盲改 bitrate 会掩盖 PT、RTP 或 audio-source 错误。回滚为清空。

## DTMF 相关 PT/clock

| 属性 | 默认值 | 有效范围/规则 | 用途 |
|---|---:|---|---|
| `persist.vendor.ims.ap_dtmf_nb_pt` | `110` | `96..127` | AMR-NB RFC 4733 PT。 |
| `persist.vendor.ims.ap_dtmf_wb_pt` | `111` | `96..127` | AMR-WB RFC 4733 PT。 |
| `persist.vendor.ims.ap_dtmf_clock` | 当前 media clock | 只能是 `8000` 或 `16000`，且必须等于当前 media clock | DTMF clock override。 |
| `persist.vendor.ims.ap_dtmf_pt` | `111` | `96..127` | media 尚未解析时用于避免把 DTMF PT 误识别为 voice RTP 的 acquisition filter。 |

所有值都必须按 NB/WB codec 分别验证。错误 PT 或 clock 会造成 DTMF 不生效、被对端当作语音或破坏 media profile 识别。通常不应设置任何 override；清空即可恢复代码默认值。

---

# 3. 上行/下行采集与来电控制诊断

## `persist.vendor.ims.ap_uplink_capture`、`ap_uplink_seconds`、`ap_uplink_bytes`、`ap_uplink_file`

这些属性控制**独立上行 PCM 采集诊断**，不负责发送 RTP。

| 属性 | 默认值 | 有效范围/值 | 作用 |
|---|---:|---|---|
| `persist.vendor.ims.ap_uplink_capture` | `false` | 布尔值 | 已建立呼叫时是否启动 `ApUplinkCapturePoc`。 |
| `persist.vendor.ims.ap_uplink_seconds` | `10` | `1..30`（clamp） | 采集持续时间。 |
| `persist.vendor.ims.ap_uplink_bytes` | `320000` | `3200..960000`（clamp） | 最大 PCM 字节数。 |
| `persist.vendor.ims.ap_uplink_file` | `false` | 布尔值 | 是否将 PCM 写入 `/data/vendor/ims/desem26_call_<id>_<source>.pcm`。 |

诊断 capture 默认 `ap_uplink_source=mic`，与正式上行 RTP 默认 `voice_uplink` 不同。`ap_uplink_file=true` 会写入可能含语音的敏感文件；仅在明确授权的本地测试中启用，结束后设回 `false`、删除文件，并绝不提交。源文件：[ApUplinkCapturePoc.java](../java/com/sec/internal/google/ApUplinkCapturePoc.java)。

## `persist.vendor.ims.ap_allow_call_waiting`

| 字段 | 内容 |
|---|---|
| 默认值 | `false` |
| 读取者 | `ApIncomingCallBridge.notifyIncoming()` |
| 生效 | 每次收到来电且已有活动 session 时 |
| `false` | 默认拒绝第二来电，使用 busy cause `2`。 |
| `true` | 允许 bridge 尝试把第二来电交给 framework；不代表 call waiting 已完整支持。 |
| 回滚 | 清空/设回 `false`，再做单通与第二来电回归。 |

[S20-已验证] call waiting 仍有已知无声/重置干扰问题。此属性只能用于隔离来电投递分支；不能把 `true` 作为正式功能承诺。

## `persist.vendor.ims.ap_stuck_call_fix`

| 字段 | 内容 |
|---|---|
| 分类 | 当前基线的失败呼叫终结补偿 |
| 默认值 | `true` |
| 读取者 | `ApStuckCallFix.shouldSynthesiseTerminated()` |
| 生效 | Samsung 栈发出 `callSessionInitiatingFailed` 且 session 尚未 closing 时 |
| `true` | 发送合成的 `callSessionTerminated`，避免 framework Telecom call 停在 `DISCONNECTING`。 |
| `false` | 禁用补偿，用于观察原始失败路径；可能导致无法挂断、不能继续拨号。 |
| 回滚 | 清空或明确设 `true`，并用失败拨号场景确认 Telecom 可恢复。 |

不建议在普通稳定性测试中关闭它。关闭后看到的卡死是已知 failure mode，不是 bearer 诊断的结论。

---

# 4. bearer latch / radio reset 实验属性（高风险）

这些属性由 [`ApBearerLatchProbe.java`](../java/com/sec/internal/google/ApBearerLatchProbe.java) 读取，目标是研究“首通后下一通无声/无 bearer”的状态机问题。它们可能导致 IMS PDN 被拆除、注册被移除、radio 短暂关闭或电话暂时不可达。

**使用前要求：** 保留 known-good 模块；只在非紧急测试窗口；记录当前注册与 data 状态；每个 rung 单独测；完成后恢复 rung `6` 或回到已验证 artifact。不能在通话中修改。

## `persist.vendor.ims.ap_latch_probe_rung`

| 值 | 行为 | 当前解释 |
|---:|---|---|
| `0` | 不做 reset | control run。 |
| `1` | `sendReRegister` | 仅 SIP re-REGISTER，保留 PDN；必须以实际 outbound REGISTER 验证，而非仅看返回值。 |
| `2` | `deregisterProfile` 后显式 `registerProfile` | 会触发完整周期；单独 deregister 会把 profile 移除并导致不自动重注册。 |
| `3` | `stopPdnConnectivity` | 尝试拆 IMS PDN，但可能因 listener/内部契约不匹配而静默 no-op。 |
| `4` | airplane-mode radio cycle | 已记录稳定 fallback；会短暂中断 service。 |
| `5` | 显式 IMS PDN stop/start | 实验性 PDN rebuild；必须验证 `SETUP_DATA_CALL`，返回值不是成功证据。 |
| `6` | `TelephonyManager.setRadioPower` cycle | 当前代码默认值；直接 radio cycle，不写 airplane setting。 |

允许范围为 `0..6`；非法值回退默认 `6`。`rung 4/6` 会影响普通电话和 data。rung 1–5 不是“更优修复”的证明：历史实验表明方法可能返回正常却没有真正触发目标动作。

**验证：** 使用 bridge 的 `VERIFY_REGISTER_SENT`、`VERIFY_MOVED` 或 `VERIFY_PDN_REBUILT` 日志，以及第二通真实媒体/通话结果。`VERIFY_NO_CHANGE` 表示本次请求可能是 no-op，不能解读为“该层不重要”。

## 延时与 PDN 参数

| 属性 | 默认值 | 范围/读取规则 | 风险与用途 |
|---|---:|---|---|
| `persist.vendor.ims.ap_latch_probe_delay_ms` | `1500` ms | `0..60000` | 最后一通结束与执行 rung 的延时；过短可与 teardown 竞争。 |
| `persist.vendor.ims.ap_latch_probe_pdn_type` | `11` | 直接 `getInt`，无 clamp | 传给特定 IMS/PDN API 的候选 PDN type；`11` 是 S20 日志中 IMS 值。错误值可使 API 静默匹配不到 task。 |
| `persist.vendor.ims.ap_latch_probe_rereg_delay_ms` | `2000` ms | 直接 `getInt`，无 clamp | rung 2 deregister 与明确 re-register 的间隔。 |
| `persist.vendor.ims.ap_latch_probe_radio_dwell_ms` | `400` ms | `200..10000` | rung 4/6 radio-off dwell。过短可能导致远端振铃、但本地仍在拨号。 |
| `persist.vendor.ims.ap_latch_probe_pdn_gap_ms` | `1200` ms | 直接 `getInt`，无 clamp | rung 5 stop/start PDN 间隔。 |

`pdn_type`、`rereg_delay_ms` 和 `pdn_gap_ms` 缺少范围检查，因而更不适合作为一般用户开关。除非已有目标代码/日志证明参数语义，保持默认并不要尝试负数或超长值。

### 回滚

- 将 `ap_latch_probe_rung` 恢复为当前基线值 `6`，或清空以让代码用默认值；不要遗留 `1`–`5`。
- 清空所有 `ap_latch_probe_*` 延时/PDN override。
- 完成一次重启，确认 `rild`、IMS 注册、普通 data 与一次常规通话恢复。

---

# 5. 诊断 override 与已替代实验

## `persist.vendor.ims.ap_dual_ims_override`

| 字段 | 内容 |
|---|---|
| 默认值 | `false` |
| 读取者 | `ApDualImsDiag.effectiveConfig()` |
| `true` | 仅当原始 UA dual-IMS config 为 `0` 时，将 effective 值改为 `3`。 |
| `false` | 保留原值。 |
| 用途 | 诊断 Samsung UA config 对 dual IMS 的翻译路径。 |
| 限制 | 不会让 GSI 自动支持 SIM 2，也不替代 radio HAL、slot 或 `multiclientd` DSDS 路径。 |

这是诊断 override，不是双卡支持开关。改动前后记录 `AP_DUAL_IMS` 中的 `phoneCount`、`config`、`translated` 和 UA log；测试结束清空。

## `persist.vendor.ims.ap_eps_only_override`

| 字段 | 内容 |
|---|---|
| 默认值 | `false` |
| 读取者 | `ApEpsOnlyDiag.effectiveCallSetup()` |
| `true` 的精确条件 | 仅在原判定为 `false`、非 emergency、`callType == 1`、该 `phoneId` data registration 为 `0`、data network 为 LTE `13` 时，将结果变为 `true`。 |
| 其它情况 | 保持原始判断。 |
| 用途 | 分析 EPS-only/VoLTE call setup gate。 |
| 风险 | 可能绕过原厂状态判断；不得用于 emergency；不能作为一般注册修复。 |

验证 `AP_EPS_ONLY` 的 `SERVICE_STATE`、`OVERRIDE` 和 `CALL_SETUP` 日志。回滚为清空或 `false`，并重新建立 IMS 状态。

## `persist.vendor.ims.ap_sae_reset_on_last_call`

| 字段 | 内容 |
|---|---|
| 默认值 | `false` |
| 读取者 | `ApSaeResetPoc.onSessionRemoved()` |
| `true` | 最后一 session 移除时反射调用媒体接口的 `saeTerminate()`。 |
| 状态 | **历史/已替代**。 |
| 原因 | 历史注释记录一个早期 rung 使用不存在的方法名，导致每次调用抛异常而没有真正测试假设；后续 bearer/radio 结论不应依赖此路径。 |
| 建议 | 保持 `false`；不要把它作为当前连续通话修复。 |

若为了历史复现必须开启，必须单变量、记录 `SAE_TERMINATE_COMPLETE`/`SAE_TERMINATE_FAIL`，并准备重启恢复。

---

# 6. 原厂内部属性：记录但不手动控制

下列属性出现在已 patch 的 Samsung stock smali 中。项目将 `SemSystemProperties` 调用替换为 AOSP `SystemProperties`，使原厂路径可在 GSI 上运行；这**不是**授权测试者手写这些属性。它们由 Samsung 内部代码读写，语义还依赖原厂 module/configuration。

## `persist.vendor.ims.ap_media_timeout`

| 字段 | 内容 |
|---|---|
| 分类 | Samsung native RTP/RTCP timeout 的诊断 override |
| 默认值 | `32766` |
| 有效范围 | `30..32766`；范围外回退 `32766`。 |
| 注入位置 | `patches/desem5-to-desem81.patch` 中 `ResipRegistrationManager.configureMedia()`。 |
| 作用 | 同时覆盖 `CallProfile` 的 RTP timeout 和 RTCP timeout。 |
| 风险 | 值过低会将 media session 误判超时；值过高会延长故障发现。它不修复 RTP 端口、codec、bearer 或 audio routing。 |
| 回滚 | 清空或恢复 `32766`；重新注册/重启 IMS 后检查 `AP_MEDIA_TIMEOUT` 日志。 |

只能在研究“原厂 timeout 是否导致已知 media failure”时单独测试。不要因为无声就降低该值。

## `persist.ims.gcfmode` 与 `persist.radio.gcfmode`

| 属性 | 原厂路径 | 当前项目关系 | 规则 |
|---|---|---|---|
| `persist.ims.gcfmode` | 原厂 GCF mode 设置代码会写入。 | `stock-to-desem5.patch` 只将写入 API 从 `SemSystemProperties` 改为 AOSP `SystemProperties`。 | 不手工修改。GCF/test mode 可能影响运营商、注册和认证行为。 |
| `persist.radio.gcfmode` | 原厂 GCF mode 代码在相应条件下写入 `1`。 | 同上。 | 不手工修改；仅在分析已启用的原厂 GCF 流程时读取日志。 |

本仓库没有把它们当作 S20 IMS 的推荐测试开关，也没有为“关闭/打开后功能应如何变化”建立公开验证矩阵。

## `persist.ims.salescode.sve`

原厂 `ResipMediaHandler` 在启动 SVE camera 路径时写入此属性；patch 仅将 API 调用替换为 AOSP `SystemProperties`。它与 video/camera/SVE 路径相关，而当前项目不支持 video call。**不要人工设置。** 它不用于 VoLTE 音频、IMS 注册或 SMS 测试。

## `persist.ims.simmobility`

原厂 `ImsSimMobilityUpdate` 读取此整数属性，patch 同样只是替换 `SemSystemProperties` API。它的语义属于 Samsung SIM-mobility 配置，而不是公开的“让本项目移动网络可用”开关。只在调查原厂 SIM mobility 逻辑时读取；不设置、不以它伪造 carrier/slot 状态。

## `ro.product.first_api_level`

原厂 IMS service-switch 路径读取该 ROM 固定属性。它是只读的 product-first API level，不是当前 Android API level，也不是一个可写兼容开关。项目仅因 GSI 缺少 `SemSystemProperties` 而将读取 API 换成 AOSP `SystemProperties`。不要修改 `ro.*` 属性。

# 7. 只读 system property：观察，不要写入

## `ril.halservice.registered.slot1`

| 字段 | 内容 |
|---|---|
| 分类 | 只读 radio/HAL readiness 观测 |
| 项目读取者 | `magisk-module/post-fs-data.sh` |
| 期望值 | `true`，且 `rild` 进程存在时，才启动 `multiclientd -s 1`。 |
| 不应做的事 | 不得人工 `setprop` 伪造为 `true`。 |

它是 module 启动门槛，不是 IMS 注册开关。脚本最多等待约 120 秒；超时会记录 `multiclientd prerequisites timed out` 并不启动。若它始终不为 `true`，调查 target radio HAL、slot topology 和 `rild`，不要修改属性。

## `sys.boot_completed`

| 字段 | 内容 |
|---|---|
| 分类 | 只读 boot readiness 观测 |
| 项目读取者 | `magisk-module/service.sh` |
| 期望值 | `1` |
| 作用 | service 脚本等待 Android boot 完成后采集/输出 SELinux denial snapshot。 |
| 不应做的事 | 不得手动写入。 |

它不启动 IMS daemon，也不决定注册状态；仅用于避免 service 脚本在 boot 未完成时运行。

## `persist.radio.multisim.config` 与 `persist.ims.mock.multisim`

| 属性 | 项目用途 | 规则 |
|---|---|---|
| `persist.radio.multisim.config` | `ApDualImsDiag` 记录 radio multi-SIM 配置用于诊断。 | 只读观测；不应用于强制 slot/DSDS。 |
| `persist.ims.mock.multisim` | `ApDualImsDiag` 记录 mock multi-SIM 状态。 | 只读观测；不是公开的 S20 双卡支持开关。 |

即使它们显示某种 multi-SIM 配置，也不能证明 GSI port 的 slot 2 可用。S20 当前公开限制仍是 SIM 1；见 [README.zh-CN.md](../README.zh-CN.md)。

## `ro.build.tags`

| 字段 | 内容 |
|---|---|
| 分类 | 只读 ROM signing-environment 观测 |
| 使用位置 | README/tools 部署前检查 |
| 典型值 | `test-keys` 或 `release-keys` |
| 作用 | 判断目标 ROM 是否可能接受可用 test platform key，或是否必须持有该 ROM 的实际 platform signing identity。 |
| 不应做的事 | `ro.*` 是只读属性，不能也不应尝试修改。 |

它不是 IMS runtime 开关。`test-keys` 也不等于“任何 test key 都可以签”；必须匹配 ROM 实际信任的 key。

---

# 8. 不是 Android system property 的相关开关

下面名称容易与 `getprop`/`setprop` 混淆，但它们是 shell environment variable 或 Android setting，不属于本清单的 system property：

| 名称 | 类型 | 当前作用 | 注意事项 |
|---|---|---|---|
| `S20VOLTE_MULTICLIENTD_ROOT` | `post-fs-data.sh` shell 变量 | 当前值 `1`，选择 root fallback 启动 `multiclientd`。 | 不是 `setprop` 属性；低权限 radio path 虽存在，但当前默认未使用。 |
| `IMS_SOCK_LAUNCH_NO_DROP` | launcher environment variable | 可触发 launcher 不降权的 fallback 行为。 | 诊断/回归 bisect 用，不能当安全默认。 |
| `airplane_mode_on` | `Settings.Global` setting | `ApBearerLatchProbe` rung 4 经 framework API 写入并广播，驱动 radio cycle。 | 不是 system property；会中断 service，不能用 `setprop` 模拟。 |
| `SDK_HOME`、`AAPT2`、`ZIPALIGN` 等 | host shell environment | 本地构建工具路径。 | 不进入设备 property inventory。 |

---

# 9. 测试流程与回滚清单

## 修改一个可写属性前

```text
[ ] 当前 APK/module 与 target profile 的 SHA-256 已记录。
[ ] 已保存当前 property 值和 last-known-good artifact。
[ ] 已定义一个可证伪的假设与一个变量。
[ ] 已定义 workload（例如一次短通话、第二通、NB/WB DTMF 或短信）。
[ ] 已 arm 时间有界的 log/kernel-audit 采集。
[ ] 已定义失败触发条件和回滚步骤。
```

## 修改后验证

```text
[ ] getprop 值与预期一致。
[ ] 对“每通读取”属性，以新的通话验证，不用已有通话推断。
[ ] 对“启动读取”属性，按需要重启 daemon 或设备。
[ ] 记录 bridge 的 CONFIG_OVERRIDE / CONFIG_REJECT / MEDIA_GATE / PORT_SELECT 等日志。
[ ] 同时记录注册、通话建立、双向音频、DTMF、第二通和 data 状态。
[ ] AVC 调查使用 kernel audit/dmesg 的有边界窗口，而非只看 logcat。
```

## 回滚

1. 清空或恢复本次唯一修改的 `persist.vendor.ims.*` 值。
2. 对媒体属性使用一通新的电话验证；对启动或 radio 实验执行重启。
3. 检查 `getprop`、IMS 注册、普通 data、一次安全的常规通话。
4. 若设备进入 crash loop、无注册或 radio 未恢复，先移除 candidate/恢复 known-good module，不要继续叠加属性修改。
5. 把失败 candidate 标记为 `fail`、`partial`、`blocked` 或 `regressed`，而不是模糊地写“无效”。

## 维护规则

新增或删除 bridge 属性时，同时更新本文件；每条记录必须包含代码读取路径、默认/允许值、风险和回滚。若一次实验推翻旧结论，将旧属性标为“历史/已替代”，不要删除历史而让后续维护者重走同一个失败路径。
