# S20 IMS System Property Test Reference

> 中文版：[S20 IMS 系统属性测试参考](S20_IMS_SYSTEM_PROPERTIES.zh-CN.md)
>
> This is an **S20 / Android 13 GSI-specific** test reference. It does not make the property names, defaults, readers, radio behavior, SELinux property contexts, or audio path portable to another Samsung device, firmware, ROM, carrier, or bridge build.

This document inventories Android system properties that the public project actually reads through the IMS bridge, Magisk runtime, or documented test workflow. It is a reference for a bounded, evidence-backed, reversible experiment—not a generic list of `setprop` commands that “enables IMS.”

For the S20 integration boundary, see the [Architecture and compatibility model](ARCHITECTURE.md). For how to rediscover these contracts on another device rather than copy them, see the [Evidence-Driven Cross-Device Samsung IMS Porting Guide](CROSS_DEVICE_PORTING_GUIDE.md).

## Safety rules

- Change properties only on a test device with a known-good module and a tested recovery path.
- Change **one conceptual variable per candidate**. Record the previous value, command, APK/module SHA-256, workload, collection window, result, and rollback.
- `persist.*` properties normally survive reboot. Restore or clear them after an experiment; flashing another module does not necessarily undo them.
- Do **not** write `ril.halservice.registered.slot1`, `sys.boot_completed`, `ro.build.tags`, `persist.radio.multisim.config`, or `persist.ims.mock.multisim`. This project treats them as observations, not controls.
- Do **not** run `setenforce 0`. On the verified S20 targets, clearing global enforcing triggered Samsung RKP reboots. See [SELinux evidence](../selinux/README.md).
- Do not commit IMSI, IMEI, telephone numbers, SIP traces, PCAPs, captured audio, or private keys.
- Do not rely on an experimental IMS path for emergency calling.

## Status labels

| Label | Meaning |
|---|---|
| **Current baseline** | Current public bridge reads it and it forms part of the documented S20 result. |
| **Diagnostic switch** | Current code reads it, but it is only for a controlled diagnosis—not a support claim. |
| **High-risk experiment** | Can remove registration, tear down the IMS PDN, or cycle radio; requires explicit review and recovery validation. |
| **Historical / superseded** | Retained for reproduction or bisecting, not a recommended default. |
| **Read-only observation** | The project only reads it; do not fabricate or write it. |

## Read and activation rules

Project-defined switches use the `persist.vendor.ims.*` namespace. The bridge only reads them through `android.os.SystemProperties.get*()`; it does not write them. A rooted shell may set one only when the target ROM property policy permits it.

```bash
adb shell su -c 'getprop persist.vendor.ims.<name>'
```

```bash
adb shell su -c 'setprop persist.vendor.ims.<name> <value>'
```

```bash
adb shell su -c 'setprop persist.vendor.ims.<name> ""'
```

The last command clears a test override so code can use its built-in fallback. Confirm with `getprop` and bridge logs: a cleared persistent property is not automatically proof that the target property service treats it exactly as an unset value. Apply rollback according to the read time—new call, daemon restart, IMS re-registration, or device reboot.

Most booleans parsed by [`ApMediaConfigPoc.java`](../java/com/sec/internal/google/ApMediaConfigPoc.java) accept `1`/`true`/`on`/`yes` and `0`/`false`/`off`/`no`, case-insensitively. Invalid strings log `CONFIG_REJECT` and use the code fallback. Integer values outside the implementation range also fall back.

## Inventory at a glance

| Property/group | Category | Default or safe S20 baseline | Read time | Status |
|---|---|---|---|---|
| `persist.vendor.ims.ap_media_rotate_ports` | Media switch | `false` | Each established call | Current baseline; must remain disabled |
| `persist.vendor.ims.ap_rtp_playback` | Downlink media | `true` | Call setup | Current baseline |
| `persist.vendor.ims.ap_uplink_rtp` | Uplink media | `true` | Endpoint lock and send loop | Current baseline |
| `persist.vendor.ims.ap_dtmf_rtp` | RFC 4733 DTMF | `true` | Each DTMF event | Current baseline |
| `ap_rtp_port` / `ap_rtcp_port` | RTP ports | `1234` / `1235` | Call setup | Diagnostic switch |
| `ap_rtp_mode`, `ap_rtp_capture_bytes`, `ap_rtp_jitter` | Downlink diagnostics | `play`, `1048575`, `12` | Probe creation | Diagnostic; capture is sensitive |
| `ap_rtcp_rr`, `ap_rtcp_rr_interval`, `ap_rtcp_rr_ssrc` | RTCP RR | `true`, `5`, random | Probe/RR transmission | Diagnostic switch |
| `ap_uplink_source`, `ap_uplink_rtp_seconds` | Uplink audio | `voice_uplink`, `32766` | Uplink creation | Current baseline / diagnostic |
| `ap_uplink_pt_override`, bitrate, DTMF PT/clock values | Codec diagnostics | See details | Profile/encoder/DTMF | Diagnostic switch |
| `ap_uplink_capture`, `ap_uplink_seconds`, `ap_uplink_bytes`, `ap_uplink_file` | PCM capture | `false`, `10`, `320000`, `false` | Established call | Diagnostic; high privacy risk |
| `ap_allow_call_waiting` | Incoming-call gate | `false` | Incoming call delivery | Diagnostic; feature risk |
| `ap_stuck_call_fix` | Failed-call completion | `true` | Initiating failure | Current baseline |
| `ap_latch_probe_*` | Second-call/bearer reset | rung `6` | Last call ends | High-risk experiment |
| `ap_dual_ims_override`, `ap_eps_only_override` | Samsung-state diagnostics | `false` | UA/call setup | Diagnostic switch |
| `ap_sae_reset_on_last_call` | `saeTerminate` attempt | `false` | Last session removed | Historical / superseded |
| `ap_media_timeout` | Native media timeout | `32766` | Registration profile build | Diagnostic; high risk |
| `persist.ims.*`, `persist.radio.gcfmode` | Samsung internal state | Samsung-controlled | Internal paths | Do not manually control |
| `ril.halservice.registered.slot1`, `sys.boot_completed`, `ro.*` | Readiness/environment | target-produced | Startup/deployment | Read-only observation |

Every abbreviated `ap_*` name in this table expands to `persist.vendor.ims.ap_*`.

---

# 1. Current media and call baseline

## `persist.vendor.ims.ap_media_rotate_ports`

| Field | Value |
|---|---|
| Category | Current media baseline switch |
| Default | `false` |
| Accepted values | Boolean values accepted by `ApMediaConfigPoc.bool()` |
| Reader | `ApRtpReceivePoc.onEstablished()` |
| Read time | Each established call chooses RTP/RTCP listener ports |
| Rollback | Set `false` or clear it, end the call, and test a new call; reboot if needed. |

[S20-validated] This must remain `false`. When true, AP receive ports rotate by `callId` (`1234 + (callId - 1) * 2` with the baseline ports), while Samsung native SDP independently chooses its port and does not consume this setting. From a later call onward, SDP can still advertise `1234` while AP binds `1238`: the call connects but has no audio. See [README.md](../README.md) and [`ApRtpReceivePoc.java`](../java/com/sec/internal/google/ApRtpReceivePoc.java).

Only set it to `true` to test the port-rotation hypothesis. Run at least three consecutive calls and capture `PORT_SELECT`, negotiation/SDP evidence, `FIRST_RTP`, and bidirectional audio. Restore `false` immediately afterward.

## `persist.vendor.ims.ap_rtp_playback`

| Field | Value |
|---|---|
| Category | Downlink RTP decode/playback gate |
| Default | `true` |
| Reader | `ApRtpReceivePoc.onEstablished()` |
| Read time | Call establishment |
| `true` | Creates the AP RTP/RTCP probe and decodes/plays downlink audio. |
| `false` | Does not create the probe for this call; isolates CP versus AP downlink behavior. |
| Rollback | Set `true` or clear, then place a new call. |

`false` deliberately disables the project's downlink media implementation. It is a diagnostic control, not a fix for no audio.

## `persist.vendor.ims.ap_uplink_rtp`

| Field | Value |
|---|---|
| Category | AP uplink RTP gate |
| Default | `true` |
| Readers | `ApRtpReceivePoc` after endpoint lock; `ApRtpUplinkPoc` send loop |
| `true` | Starts/continues AP uplink RTP using the negotiated or wire-derived payload type. |
| `false` | Does not start, or stops, AP uplink RTP; isolates whether uplink comes from this bridge. |
| Rollback | Set `true` or clear and establish a new call. |

The send loop can observe a changed value during a call, but dynamic switching is not a supported feature. Compare separate calls instead.

## `persist.vendor.ims.ap_dtmf_rtp`

| Field | Value |
|---|---|
| Category | RFC 4733 DTMF ownership gate |
| Default | `true` |
| Reader | `ApRtpReceivePoc.routeDtmf()` |
| Read time | Each DTMF start/stop/pulse |
| `true` | AP RTP sends DTMF when one valid AP uplink session exists. |
| `false` | Bridge returns `false`, allowing the existing path to handle DTMF. |
| Rollback | Set `true` or clear; test NB and WB independently. |

## `persist.vendor.ims.ap_rtp_port` and `persist.vendor.ims.ap_rtcp_port`

| Property | Default | Valid range | Role |
|---|---:|---:|---|
| `persist.vendor.ims.ap_rtp_port` | `1234` | `1..65535` | RTP base listener port when rotation is disabled. |
| `persist.vendor.ims.ap_rtcp_port` | `1235` | `1..65535` | RTCP base listener port when rotation is disabled. |

Invalid values fall back. The ports must differ; call setup rejects equal/out-of-range values. Do not select a port already owned by carrier/native media. Validate a new call with `PORT_SELECT`, bind results, `FIRST_RTP`/`FIRST_RTCP`, and bidirectional audio. Clear or restore `1234`/`1235` to roll back.

## `persist.vendor.ims.ap_rtp_mode`, `ap_rtp_capture_bytes`, and `ap_rtp_jitter`

| Property | Default | Semantics | Risk / rollback |
|---|---:|---|---|
| `persist.vendor.ims.ap_rtp_mode` | `play` | `play` decodes and creates `AudioTrack`; `capture` keeps RTP capture but disables decode/track. Other strings decode but do not create a track and are not supported modes. | Clear or set `play`; test a new call. |
| `persist.vendor.ims.ap_rtp_capture_bytes` | `1048575` | `0..8388607`, clamped. `0` disables file capture; positive values write up to the limit to `/data/vendor/ims/desem22_call_<id>.rtpdump`. | Captures may contain voice. Prefer `0`, delete local captures, and never commit them. |
| `persist.vendor.ims.ap_rtp_jitter` | `12` | `3..50`, clamped. Limits downlink reorder queue size. | Small values can drop/reorder frames; large values add latency. Clear or restore `12`. |

For jitter experiments collect `dropped`, `reordered`, jitter, RTP packet count, and listening results. It is not a general packet-loss repair.

---

# 2. RTCP, codec/PT, and uplink audio parameters

## RTCP receiver reports

| Property | Default | Valid values | Effect |
|---|---:|---|---|
| `persist.vendor.ims.ap_rtcp_rr` | `true` | Boolean | Enables RTCP Receiver Reports. Disabling isolates feedback only. |
| `persist.vendor.ims.ap_rtcp_rr_interval` | `5` seconds | `3..10` | RR interval; invalid values fall back. |
| `persist.vendor.ims.ap_rtcp_rr_ssrc` | Random 32-bit value | Decimal or `0x` hexadecimal, `0..0xffffffff` | Overrides receiver SSRC; invalid values use random. |

Probe-level settings are read at call creation; RR SSRC is read on each RR transmission. Test only after RTP/RTCP endpoint and network binding are known to work. A forced SSRC can affect remote session handling; clear it to return to random behavior.

## `persist.vendor.ims.ap_uplink_source`

| Field | Value |
|---|---|
| Default | `voice_uplink` |
| Accepted values | `mic`, `voice_communication`, `voice_uplink` |
| Readers | `ApMediaConfigPoc.source()` and `ApRtpUplinkPoc` |
| Read time | Uplink encoder/`AudioRecord` creation |
| Rollback | Clear or set `voice_uplink`, then make a new call. |

`voice_uplink` is the S20 baseline. `mic` and `voice_communication` only compare Audio HAL routing and can result in silence, echo, a wrong source, or route/permission differences. The separate capture diagnostic defaults to `mic`; that does not change the production uplink baseline.

## Uplink duration, PT, and bitrate

| Property | Default | Accepted values | Meaning |
|---|---:|---|---|
| `persist.vendor.ims.ap_uplink_rtp_seconds` | `32766` | `0..32766` | Uplink thread duration. `0` is unbounded until call lifecycle ends; positive values stop it after that many seconds. |
| `persist.vendor.ims.ap_uplink_pt_override` | `-1` | `-1` or dynamic PT `96..127` | Overrides uplink PT only when wire profile supplies the media profile; static PTs are rejected. |
| `persist.vendor.ims.ap_uplink_nb_bitrate` | `12200` | `4750`, `5150`, `5900`, `6700`, `7400`, `7950`, `10200`, `12200` | AMR-NB encoder bitrate. |
| `persist.vendor.ims.ap_uplink_wb_bitrate` | `12650` | Current implementation accepts only `12650` | AMR-WB encoder bitrate. |

These values are read while the encoder/profile is created. A forced PT or bitrate that disagrees with negotiation can cause uplink silence or codec failure. Do not convert a single captured PT into a permanent setting; prefer negotiated profile behavior. Clear diagnostic overrides after a test.

## DTMF PT and clock

| Property | Default | Valid rule | Role |
|---|---:|---|---|
| `persist.vendor.ims.ap_dtmf_nb_pt` | `110` | `96..127` | AMR-NB RFC 4733 PT. |
| `persist.vendor.ims.ap_dtmf_wb_pt` | `111` | `96..127` | AMR-WB RFC 4733 PT. |
| `persist.vendor.ims.ap_dtmf_clock` | Current media clock | `8000` or `16000`, and must equal current media clock | DTMF clock override. |
| `persist.vendor.ims.ap_dtmf_pt` | `111` | `96..127` | Pre-profile acquisition filter that avoids treating DTMF as voice RTP. |

Verify NB and WB separately. Wrong PT/clock can make DTMF fail, be interpreted as voice, or prevent media profile detection. Normally leave all overrides unset.

---

# 3. Capture and incoming-call diagnostics

## `persist.vendor.ims.ap_uplink_capture`, `ap_uplink_seconds`, `ap_uplink_bytes`, `ap_uplink_file`

These control an independent uplink PCM capture diagnostic; they do **not** send RTP.

| Property | Default | Accepted values | Role |
|---|---:|---|---|
| `persist.vendor.ims.ap_uplink_capture` | `false` | Boolean | Starts `ApUplinkCapturePoc` after call establishment. |
| `persist.vendor.ims.ap_uplink_seconds` | `10` | `1..30`, clamped | Capture duration. |
| `persist.vendor.ims.ap_uplink_bytes` | `320000` | `3200..960000`, clamped | Maximum PCM bytes. |
| `persist.vendor.ims.ap_uplink_file` | `false` | Boolean | Writes PCM to `/data/vendor/ims/desem26_call_<id>_<source>.pcm`. |

The capture diagnostic defaults its source to `mic`, unlike production uplink RTP's `voice_uplink` default. With `ap_uplink_file=true`, the file may contain voice data. Enable only for authorized local tests, restore `false`, delete the file, and do not commit it. See [`ApUplinkCapturePoc.java`](../java/com/sec/internal/google/ApUplinkCapturePoc.java).

## `persist.vendor.ims.ap_allow_call_waiting`

| Field | Value |
|---|---|
| Default | `false` |
| Reader | `ApIncomingCallBridge.notifyIncoming()` |
| Read time | Incoming call arrives while another session is active |
| `false` | Default rejects second call with busy cause `2`. |
| `true` | Allows the bridge to try delivery to framework; does not make call waiting complete. |
| Rollback | Clear/set `false`, then regress a single call and a second incoming call. |

[S20-validated] Call waiting retains known audio/reset interference. Use this only to isolate incoming-call delivery—not as a feature-support switch.

## `persist.vendor.ims.ap_stuck_call_fix`

| Field | Value |
|---|---|
| Category | Current failed-call terminal-event compensation |
| Default | `true` |
| Reader | `ApStuckCallFix.shouldSynthesiseTerminated()` |
| Read time | Samsung stack emits `callSessionInitiatingFailed` and session is not already closing |
| `true` | Synthesizes `callSessionTerminated`, preventing Telecom from remaining in `DISCONNECTING`. |
| `false` | Exposes original failure path; can leave a call unhangable and prevent further calls. |
| Rollback | Clear or explicitly set `true`; verify Telecom recovers from a failed dial attempt. |

Do not disable it during ordinary stability testing. The resulting stuck call is a known failure mode, not evidence about bearer behavior.

---

# 4. Bearer-latch/radio-reset experiment properties — high risk

[`ApBearerLatchProbe.java`](../java/com/sec/internal/google/ApBearerLatchProbe.java) reads these properties to investigate the “first call works, next call lacks audio/bearer” state-machine issue. They can remove registration, tear down IMS PDN, cycle radio, or leave normal telephony temporarily unavailable.

Before use: retain a known-good module, work outside any emergency window, record registration/data state, test each rung independently, and do not modify properties during a call.

## `persist.vendor.ims.ap_latch_probe_rung`

| Value | Action | Current interpretation |
|---:|---|---|
| `0` | No reset | Control run. |
| `1` | `sendReRegister` | SIP re-REGISTER only; keeps PDN. Prove an outbound REGISTER, not merely a returned API call. |
| `2` | `deregisterProfile` then explicit `registerProfile` | Full cycle. Deregistration alone removes the profile and does not automatically re-register. |
| `3` | `stopPdnConnectivity` | Attempts IMS PDN teardown; internal listener mismatch can make it a silent no-op. |
| `4` | Airplane-mode radio cycle | Documented stable fallback; briefly interrupts service. |
| `5` | Explicit IMS PDN stop/start | Experimental rebuild; prove `SETUP_DATA_CALL`; return value is not success evidence. |
| `6` | `TelephonyManager.setRadioPower` cycle | Current code default; direct radio cycle without writing airplane setting. |

Allowed range is `0..6`; invalid values fall back to `6`. Rungs 4/6 affect normal calls/data. Rungs 1–5 are not proof of a better repair: historical attempts can return normally without reaching the target action.

Verify with `VERIFY_REGISTER_SENT`, `VERIFY_MOVED`, or `VERIFY_PDN_REBUILT` plus the actual next-call result. `VERIFY_NO_CHANGE` means an operation may have been a no-op; it does not prove the layer is irrelevant.

## Delay and PDN parameters

| Property | Default | Validation / risk |
|---|---:|---|
| `persist.vendor.ims.ap_latch_probe_delay_ms` | `1500` ms | `0..60000`; delay after final call before rung. Too short can race teardown. |
| `persist.vendor.ims.ap_latch_probe_pdn_type` | `11` | Direct `getInt`, no clamp. S20 IMS PDN value observed in logs; wrong values can silently match no task. |
| `persist.vendor.ims.ap_latch_probe_rereg_delay_ms` | `2000` ms | Direct `getInt`, no clamp. Gap between rung-2 deregistration/re-registration. |
| `persist.vendor.ims.ap_latch_probe_radio_dwell_ms` | `400` ms | `200..10000`. Rung 4/6 radio-off dwell; too short can desynchronize remote ringing and local UI. |
| `persist.vendor.ims.ap_latch_probe_pdn_gap_ms` | `1200` ms | Direct `getInt`, no clamp. Rung-5 PDN stop/start gap. |

`pdn_type`, re-registration delay, and PDN gap lack range validation and are unsuitable as general-user switches. Keep defaults unless target code/logs prove their parameter semantics.

### Rollback

1. Restore `ap_latch_probe_rung` to current baseline `6`, or clear it to use the code default; do not leave rungs 1–5 configured.
2. Clear all `ap_latch_probe_*` delay/PDN overrides.
3. Reboot, then verify `rild`, IMS registration, ordinary data, and one normal call.

---

# 5. Diagnostic overrides and superseded experiments

## `persist.vendor.ims.ap_dual_ims_override`

| Field | Value |
|---|---|
| Default | `false` |
| Reader | `ApDualImsDiag.effectiveConfig()` |
| `true` | Changes effective UA dual-IMS config from `0` to `3` only. |
| Purpose | Diagnoses Samsung UA dual-IMS translation path. |
| Limitation | Does not implement SIM 2, radio HAL slot support, or `multiclientd` DSDS behavior. |

This is a diagnostic override, not a dual-SIM support switch. Record `AP_DUAL_IMS` `phoneCount`, `config`, `translated`, and UA logs before/after; clear after the test.

## `persist.vendor.ims.ap_eps_only_override`

| Field | Value |
|---|---|
| Default | `false` |
| Reader | `ApEpsOnlyDiag.effectiveCallSetup()` |
| Exact `true` condition | Original decision is false; call is non-emergency type `1`; matching phone has data registration `0` and LTE data network `13`. |
| Other cases | Leaves original decision unchanged. |
| Risk | Can bypass stock state judgment; never use for emergency; not a general registration fix. |

Validate `AP_EPS_ONLY` `SERVICE_STATE`, `OVERRIDE`, and `CALL_SETUP` logs; clear/set false and recreate IMS state to roll back.

## `persist.vendor.ims.ap_sae_reset_on_last_call`

| Field | Value |
|---|---|
| Default | `false` |
| Reader | `ApSaeResetPoc.onSessionRemoved()` |
| `true` | Reflectively invokes `saeTerminate()` after last session removal. |
| Status | **Historical / superseded** |

A historical rung used a nonexistent method and threw every time, so the hypothesis was never actually tested. Do not use it as the current repeated-call repair. If reproducing history, record `SAE_TERMINATE_COMPLETE`/`SAE_TERMINATE_FAIL` and be prepared to reboot.

---

# 6. Samsung-internal properties — record, do not manually control

These appear in patched Samsung stock smali because the project replaces unavailable `SemSystemProperties` APIs with AOSP `SystemProperties`. That compatibility change does **not** authorize manual writes: their semantics depend on proprietary modules/configuration.

## `persist.vendor.ims.ap_media_timeout`

| Field | Value |
|---|---|
| Category | Native RTP/RTCP timeout diagnostic override |
| Default | `32766` |
| Valid range | `30..32766`; values outside range fall back to `32766`. |
| Injection point | `ResipRegistrationManager.configureMedia()` in `patches/desem5-to-desem81.patch` |
| Effect | Sets both `CallProfile` RTP and RTCP timeouts. |
| Risk | Low values can falsely time out media; high values delay fault detection. It does not fix ports, codec, bearer, or routing. |

Test only a specific timeout hypothesis. Clear/restore `32766`, re-register/restart IMS, and inspect `AP_MEDIA_TIMEOUT`; do not lower it merely because audio is absent.

## `persist.ims.gcfmode`, `persist.radio.gcfmode`, `persist.ims.salescode.sve`, `persist.ims.simmobility`

| Property | Stock relationship | Rule |
|---|---|---|
| `persist.ims.gcfmode` | Samsung GCF-mode code writes it; the first-stage patch only substitutes the property API. | Do not write manually. GCF/test mode can alter carrier, registration, or authentication behavior. |
| `persist.radio.gcfmode` | Samsung GCF-mode code may write `1`. | Do not write manually; inspect only during analysis of stock-enabled GCF flow. |
| `persist.ims.salescode.sve` | `ResipMediaHandler` writes it on SVE camera startup. | Video/camera-specific; video calling is unsupported. Do not set for VoLTE/SMS tests. |
| `persist.ims.simmobility` | `ImsSimMobilityUpdate` reads it as an integer. | Samsung SIM-mobility configuration, not a public carrier/slot switch. Observe only. |

## `ro.product.first_api_level`

Samsung service-switch paths read this ROM-fixed first API level. It is not current API level and not a writable compatibility control. The patch only substitutes the `SemSystemProperties` read API. Do not alter `ro.*` properties.

---

# 7. Read-only observations — do not write

## `ril.halservice.registered.slot1`

| Field | Value |
|---|---|
| Category | Radio/HAL readiness observation |
| Reader | `magisk-module/post-fs-data.sh` |
| Expected value | `true` plus a live `rild` process before launching `multiclientd -s 1`. |
| Prohibition | Never fake it with `setprop`. |

It is a module startup gate, not an IMS-registration switch. The script waits about 120 seconds, then logs a timeout and does not launch `multiclientd`. If it remains false, investigate target radio HAL, slot topology, and `rild`.

## `sys.boot_completed`

Read by `magisk-module/service.sh`; expected `1`. It delays the service script until Android completes boot so it can collect/output a SELinux denial snapshot. It neither starts IMS daemons nor determines registration. Do not write it.

## `persist.radio.multisim.config` and `persist.ims.mock.multisim`

`ApDualImsDiag` records these values as radio/mock multi-SIM diagnostics. They are not public switches for forcing DSDS or slot selection. A multi-SIM-looking value does not prove that slot 2 works on this GSI; the documented S20 limitation remains SIM 1 only.

## `ro.build.tags`

This read-only ROM-signing observation is checked before deployment. Typical values are `test-keys` and `release-keys`; it helps determine whether an available platform signing identity can plausibly be accepted. It is not an IMS runtime control. `test-keys` also does not mean every test key is accepted—the key must match ROM trust.

---

# 8. Related controls that are not Android system properties

| Name | Type | Current role | Important note |
|---|---|---|---|
| `S20VOLTE_MULTICLIENTD_ROOT` | `post-fs-data.sh` shell variable | Current value `1` chooses root fallback for `multiclientd`. | Not a `setprop` value; lower-privilege radio path exists but is not the current default. |
| `IMS_SOCK_LAUNCH_NO_DROP` | Launcher environment variable | Enables launcher no-drop fallback. | Diagnostic/bisecting aid, not a security default. |
| `airplane_mode_on` | `Settings.Global` setting | Latch-probe rung 4 writes it through framework API and broadcasts the change to cycle radio. | Not a property; interrupts service and cannot be simulated with `setprop`. |
| `SDK_HOME`, `AAPT2`, `ZIPALIGN` | Host shell environment | Local build tool paths. | Not part of device property inventory. |

---

# 9. Test and rollback checklist

## Before changing a writable property

```text
[ ] Current APK/module and target-profile SHA-256 are recorded.
[ ] Current property value and last-known-good artifact are preserved.
[ ] One falsifiable hypothesis and one variable are defined.
[ ] Workload is defined: short call, repeat call, NB/WB DTMF, or SMS.
[ ] Time-bounded log/kernel-audit collection is armed.
[ ] Failure trigger and rollback steps are defined.
```

## Validate after a change

```text
[ ] getprop matches the intended value.
[ ] Per-call properties are tested on a new call, not inferred from a current call.
[ ] Startup/radio properties receive the required daemon restart or device reboot.
[ ] CONFIG_OVERRIDE / CONFIG_REJECT / MEDIA_GATE / PORT_SELECT logs are recorded.
[ ] Registration, call setup, bidirectional audio, DTMF, repeat call, and data state are recorded.
[ ] AVC investigation uses a bounded kernel-audit/dmesg window, not logcat alone.
```

## Roll back

1. Clear or restore the one `persist.vendor.ims.*` value changed by the candidate.
2. Make a new call for media properties; reboot for startup/radio experiments.
3. Recheck `getprop`, IMS registration, ordinary data, and one safe ordinary call.
4. If registration/radio does not recover or the device crash-loops, remove the candidate/restore the known-good module before changing any more properties.
5. Mark the candidate `fail`, `partial`, `blocked`, or `regressed`; do not reduce evidence to “ineffective.”

## Maintenance rule

When bridge properties are added or removed, update both language versions of this reference. Every entry needs its reader, default/allowed values, risk, rollback, and evidence status. If an experiment overturns an old conclusion, mark it historical/superseded rather than deleting the lesson and inviting the same failed experiment again.
