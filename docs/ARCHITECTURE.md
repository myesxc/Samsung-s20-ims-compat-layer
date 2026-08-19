# Architecture and compatibility model

> 中文版：[架构与兼容性模型](ARCHITECTURE.zh-CN.md)
>
> For a methodology to investigate and adapt this work for a **different** Samsung target—without treating S20 artifacts as portable—see the [Evidence-Driven Cross-Device Samsung IMS Porting Guide](CROSS_DEVICE_PORTING_GUIDE.md).

This document explains the compatibility design used to run the Samsung IMS components from the documented Android 13 firmware on the documented Android 13 GSI. It describes the project boundary, not a universal Samsung IMS or One UI port.

**Scope.** The documented baseline is Snapdragon Galaxy S20 firmware `G981NKSU1HVJG`, primarily SM-G981N, on LineageOS 20 / Android 13 GSI. See the [README](../README.md) for the tested device/carrier matrix, installation requirements, licensing, and safety limits.

## Why the stock stack does not directly work on a GSI

Samsung IMS is not only `imsservice.apk`. The stock integration assumes a Samsung/One UI software environment: framework APIs and shared libraries, a privileged package identity, Samsung daemons and native libraries, init-managed services and sockets, Samsung policy labels/types, and the matching vendor radio environment.

The target GSI instead exposes the AOSP IMS service contract. `ImsResolver`/Telephony must select a package and bind an AOSP-visible `android.telephony.ims.ImsService` endpoint. Installing the stock APK alone does not provide that binding contract, the missing Samsung framework symbols, the required boot-time daemon setup, or the rest of the Samsung runtime dependencies.

This project does **not** emulate all of One UI. It retains the matching proprietary components required by the documented target and adds narrowly scoped adapters and compatibility artifacts only where the GSI lacks a necessary boundary contract. It does not replace the device's `rild`, radio HAL, IMS PDN setup, or carrier network integration, and it is not a portable replacement Samsung IMS implementation.

| Integration boundary | Stock assumption | Project response |
|---|---|---|
| AOSP IMS discovery | Samsung integration is not directly selected through the target GSI's standard contract. | The final [manifest](../AndroidManifest.xml) exposes `GoogleModernImsService` with `BIND_IMS_SERVICE`, the `android.telephony.ims.ImsService` action, and MMTEL/emergency-MMTEL metadata. |
| Framework package selection | A GSI can select a different IMS implementation. | The module installs an RRO that points `config_ims_mmtel_package` at `com.sec.imsservice`; a competing mutable IMS overlay must be disabled or it can take selection away. |
| Samsung framework APIs | Selected Samsung APIs are absent from the GSI. | Ordered APK patches and an `imsmanager.jar` compatibility DEX provide targeted substitutions/stubs. |
| APK composition | Rebuilding only the primary DEX omits required dependencies. | The supported output is a verified four-DEX APK. |
| Boot lifecycle | Magisk makes mounted init files visible after init has parsed `/system/etc/init`. | The module recreates the required `imsd` socket/service-launch work at `post-fs-data`. |
| SELinux types/domains | Samsung daemon types and transitions are absent from the GSI policy. | Reuse existing labels where possible; reduce Unix credentials where configured; retain the documented residual `system_app` permissive state. |

## System map

```text
AOSP GSI framework
  ImsResolver + Telephony + RRO-selected IMS package
                     |
                     | standard android.telephony.ims.ImsService binding
                     v
Project compatibility layer
  manifest + staged smali patches + generated Java bridge
  imsmanager.jar five-stub DEX + Magisk runtime adaptation
                     |
                     v
Samsung proprietary IMS runtime
  com.sec.imsservice + framework JARs + imsd + multiclientd
  native libraries + EPDG configuration
                     |
                     v
Existing device vendor radio runtime
  vendor rild / radio HAL / IMS PDN / carrier network
```

The project retains Samsung protocol and device-specific implementation components. It does not replace the device vendor `rild`, radio HAL, or IMS PDN setup. The module waits for the existing `rild` and the exposed slot-1 radio HAL before launching `multiclientd`.

## APK compatibility path

The build uses named states to make the historical compatibility work auditable:

```text
hash-verified stock APK
  -> stock-to-desem5.patch
  -> desem5-to-desem81.patch
  -> compile Java bridge into a private temporary smali tree
  -> compare it with reviewed smali_out/
  -> inject bridge smali into primary DEX
  -> inject stable secondary DEX payloads
  -> align, sign, and structurally verify final APK
```

- **stock** is the locally supplied, hash-verified one-DEX Samsung input.
- **desem5** is a patch and validation boundary. It is not an APK that an ordinary builder must retain, sign, or install.
- **desem81/final** is the current final compatibility state.
- **`smali_out/`** is a reviewed snapshot of generated Java bridge smali. The final builder regenerates the bridge privately and rejects a build if it differs from this snapshot.

The historical `smali_patch.diff` single-DEX path has been removed. It covered only 21 of the 163 patched files — omitting the modern `ImsService` classes that registration depends on — and it also dropped the three secondary DEX files, so a rebuild from it could install and sign yet never register IMS. `patches/` supersedes it entirely. The authoritative procedure is [BUILD.md](../BUILD.md).

### Four DEX files

| Archive entry | Role | Source policy |
|---|---|---|
| `classes.dex` | Patched Samsung primary DEX plus generated Java bridge. | Rebuilt from the exact stock APK and ordered patches. |
| `classes2.dex` | 204-class Gson compatibility payload. | Historical local, hash-validated input. |
| `classes3.dex` | 120 Samsung IMS framework API classes. | Locally supplied/derived proprietary framework input. |
| `classes4.dex` | 12 VSIM/softphone stubs. | Rebuilt from tracked [`vsim_stub/`](../vsim_stub/). |

The build validates structure, DEX hashes, class counts, required modern IMS classes, and manifest binding. It does not claim byte-identical APK ZIP output because apktool, DEX tooling, compression, alignment, and signing metadata may change bytes.

## AOSP-facing bridge and retained Samsung internals

The final [second-stage patch](../patches/desem5-to-desem81.patch) and generated bridge classes expose an AOSP-facing modern IMS layer while retaining Samsung internal service modules behind it.

- `GoogleModernImsService`, its modern MMTEL feature, and registration classes make the service bindable and reportable through the AOSP framework contract.
- Call-session bridges adapt framework call flow to retained Samsung call/session objects.
- `ModernImsSms` adapts modern IMS-SMS callbacks to Samsung's SMS implementation.
- `ApIncomingCallBridge` adapts incoming-call delivery to the modern feature path.
- AP-side RTP receive/uplink and media-negotiation classes are a target-specific userspace-media adaptation for the project-observed condition where the CP-side media path does not fire on this GSI; they are not a general Android IMS media design.
- Bearer/session/recovery classes include diagnostics and workarounds. They do not establish that Samsung's internal state machine is completely understood.

The retained runtime still includes matching Samsung framework/API inputs, `imsd`, `multiclientd`, native libraries, EPDG configuration, and the device's vendor `rild`/radio HAL/IMS-PDN environment. This is an adapter over a proprietary stack, not a replacement IMS implementation.

## Two different `classes2.dex` files

The name is overloaded; their parent archives and purposes differ:

```text
imsservice.apk!classes2.dex
  -> 204-class Gson compatibility payload

imsmanager.jar!classes2.dex
  -> exactly five Samsung-framework compatibility stubs
```

The [`imsmanager-compat`](../imsmanager-compat/README.md) component preserves the stock `imsmanager.jar!classes.dex` byte-for-byte and injects only these five stubs:

```text
android.os.SemSystemProperties
com.samsung.android.emergencymode.SemEmergencyConstants
com.samsung.android.feature.SemCscFeature
com.samsung.android.feature.SemFloatingFeature
com.samsung.android.wifi.SemWifiManager
```

On the documented target, restoring the pure stock JAR causes IMS registration to fail. This is therefore a minimal framework compatibility augmentation, not a rewrite of Samsung's framework library.

## Boot and daemon adaptation

The stock init declarations are included for provenance, but Magisk magic-mount timing means init does not register their services from the module. The runtime script instead:

1. restores suitable labels to magic-mounted files and libraries;
2. prepares the IMS record-log directory;
3. uses [`ims_sock_launch`](../c/ims_sock_launch.c) to create `/dev/socket/imsd`, set its ownership/mode, export `ANDROID_SOCKET_imsd`, and execute `imsd`;
4. supervises `imsd` after exit;
5. relabels newly created socket inodes as `imsd_socket` without deleting a live socket;
6. waits for `rild` and `ril.halservice.registered.slot1=true` before launching one `multiclientd -s 1` instance.

`ims_sock_launch` drops `imsd` to its stock-style `system` identity with only `NET_RAW` and `NET_ADMIN` before exec. Its `--no-socket` mode provides a lower-privilege `multiclientd` path as `radio` with no capabilities. **The checked-in runtime configuration currently sets `S20VOLTE_MULTICLIENTD_ROOT=1`, so the deployed default selects the documented root fallback for `multiclientd`; the `radio` path remains available for diagnostic or future use.** Unix credential reduction is separate from SELinux domain confinement.

SIM 1 only is an architectural consequence of the documented GSI/runtime path exposing and launching only slot 1. It does not imply that Samsung stock firmware itself is single-SIM.

## SELinux boundary

The project never uses `setenforce 0`: the [SELinux evidence](../selinux/README.md) records that clearing the global enforcing bit triggered Samsung RKP reboots on tested GSIs.

The policy strategy is primarily **relabel, do not grant**:

- module files are labeled `system_file`, and libraries `system_lib_file`;
- `/dev/socket/imsd` is relabeled `imsd_socket`;
- `/data/log/imscr` is labeled `rdxdump_data_file`.

This reuses access already available to those labels in the loaded policy. It is distinct from creating new `allow` rules.

However, this is not full confinement:

- the target GSI has no declared `imsd`, `imsd_exec`, `multiclientd`, or `multiclientd_exec` types, so these daemons do not transition into a Samsung-specific SELinux domain and remain in the `magisk` domain;
- Unix credential reduction is separate from SELinux domain confinement;
- `system_app` remains permissive because enforcing it breaks registration through framework-owned resource-cache/idmap access.

Global SELinux remaining Enforcing does not remove this residual security limitation.

## Payload and provenance boundary

[`payload-manifest.tsv`](../magisk-module/payload-manifest.tsv) is the authority for Magisk packaging. It declares the exact matching system payload, the project additions, the `imsmanager.jar` compatibility override, the patched APK, and intentional stock-certificate omissions. The module builder validates the manifest, selected rebuilt APK, optional derived JAR, and its final ZIP.

Samsung firmware-derived components remain proprietary. Local framework inputs, stock JARs, DEX caches, platform keys, and build tools are deliberately ignored and are not project-distributed source.

## Limits and safety

The architecture is validated only under the configurations stated in the [README](../README.md). It does not guarantee operation on other Samsung variants, Exynos hardware, firmware releases, Android versions, GSIs, carriers, or platform-signing environments.

Important current limits include SIM 1 only, no video calling or RCS, a post-call radio-reset workaround that briefly interrupts service, a residual permissive `system_app` domain, and one unreproduced service crash. Emergency calling is only partially tested, is not guaranteed, and must not be relied upon.

## Evidence and implementation references

| Topic | Primary source |
|---|---|
| Supported baseline and limits | [README](../README.md) |
| Four-DEX build and artifact contract | [BUILD.md](../BUILD.md) |
| AOSP service declaration | [AndroidManifest.xml](../AndroidManifest.xml) |
| Ordered APK changes | [`patches/`](../patches/) |
| Java bridge | [`java/com/sec/internal/google/`](../java/com/sec/internal/google/) |
| Framework-JAR stubs | [`imsmanager-compat/`](../imsmanager-compat/README.md) |
| Runtime launcher | [`post-fs-data.sh`](../magisk-module/post-fs-data.sh) and [`ims_sock_launch.c`](../c/ims_sock_launch.c) |
| Module payload | [`payload-manifest.tsv`](../magisk-module/payload-manifest.tsv) |
| SELinux methodology and remaining risk | [`selinux/README.md`](../selinux/README.md) |
