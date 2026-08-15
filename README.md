# Samsung S20 IMS Service — Android 13 GSI port

Enable **VoLTE**, **IMS SMS** and **IMS emergency calls** on a Snapdragon Samsung Galaxy S20
running an **Android 13 GSI** (verified on LineageOS 20).

Derived from [jameskdev/android_samsung_imsservice](https://github.com/jameskdev/android_samsung_imsservice)
(A21s / Android 11). This project extends that work to S20 / Android 13 with a modern
`ImsService` bridge, AP-side RTP media, IMS SMS, emergency calling, and a SELinux
convergence that never touches the global enforce bit.

## 中文文档

See [README.zh-CN.md](README.zh-CN.md).

---

## Status

| Feature | Status |
|---|---|
| VoLTE outgoing call (AMR-NB / AMR-WB) | ✅ Verified |
| VoLTE incoming call | ✅ Verified |
| IMS SMS (MO / MT, multi-segment) | ✅ Verified |
| RFC 4733 DTMF | ✅ Verified (codec-specific NB and WB mapping) |
| Emergency calls | ⚠️ Partially verified — see Known Limitations #4 |
| SELinux enforcing (no global permissive) | ⚠️ Only `permissive system_app` remains — see #3 |
| Second SIM slot (SIM 2) | ❌ No repair plan in place, temporary - see #1 |
| UT interface | ❌ No repair plan in place, temporary |
| Video calls | ❌ No repair plan |
| VoWifi | ❌ No repair plan |
| RCS | ❌ No repair plan |

### Verified configurations

| | |
|---|---|
| **Primary test device** | Samsung Galaxy S20 5G **SM-G981N** (KOO, Korea) |
| **Also verified on** | Samsung Galaxy S20 5G **SM-G9880** (TGY, Hong Kong) |
| **ROM** | **LineageOS 20** (Android 13) |
| **Carriers** | China Telecom, China Unicom |
| **Root** | Magisk 26+ |

Both devices are Snapdragon 865. Exynos variants are untested and are likely to need
different blobs.

---

## What was modified

Samsung's IMS stack (`com.sec.imsservice`) does not extend the AOSP IMS framework
interfaces — it talks to Samsung's own platform APIs, which do not exist on a GSI.
This project bridges the two:

1. **`AndroidManifest.xml`** — declares the modern service so `ImsResolver` can bind it
   (`android.telephony.ims.ImsService` action, `BIND_IMS_SERVICE` permission,
   `MMTEL_FEATURE` metadata), and removes Samsung-platform-only requirements.
2. **`smali_patch.diff`** — targeted patches to Samsung's original smali: de-Samsung-ing
   private API calls, modern `ImsService` registration, and call-session lifecycle fixes.
3. **`java/`** (compiled to `smali_out/`) — new bridge classes injected into `classes.dex`:
   - `ModernImsSms` — IMS SMS over the modern `ImsService` API
   - `ApRtpReceivePoc` / `ApRtpUplinkPoc` — AP-side RTP receive and uplink (the CP media
     path never fires on a GSI, so media is terminated in userspace)
   - `ApMediaNegotiationPoc` / `ApMediaConfigPoc` — SDP/codec negotiation
   - `ApIncomingCallBridge` — incoming-call path
   - `ApBearerLatchProbe` / `ApStuckCallFix` — bearer state handling and recovery
   - diagnostics (`ApDualImsDiag`, `ApEpsOnlyDiag`, etc.)
4. **`imsmanager-compat/`** — retains Samsung's original `imsmanager.jar` primary DEX and
   injects a second DEX with five minimal Samsung-framework API stubs required on the GSI.
   Restoring the pure stock JAR breaks IMS registration on the verified Android 13 target.
5. **`c/ims_sock_launch.c`** — a small init-replacement helper (see [SELinux](#selinux)).
6. **`magisk-module/`** — module scripts that launch `imsd` and `multiclientd` with the
   right socket label and reduced privileges.
7. **`selinux/`** — the full privilege-convergence record: four permissive domains reduced
   to one, with **zero new allow rules**, each step verified on-device.

---

## Repository layout

```text
AndroidManifest.xml                 patched manifest (replaces the stock one)
smali_patch.diff                    patch against the stock decompiled smali
java/                               bridge sources (this project's own code)
smali_out/                          compiled bridge smali — copy into the decompiled APK
libs/                               compile-time-only jars (imsmanager, EpdgManager, rcsopenapi)
imsmanager-compat/                  reproducible local imsmanager.jar GSI compatibility override
rro/                                source + reproducible builder for the S20 IMS-selection RRO
c/                                  ims_sock_launch helper: source + cross-build script
build.sh                            java/ -> smali_out/
magisk-module/                      Magisk module scripts (post-fs-data.sh, sepolicy.rule, …)
proprietary_vendor_samsung_ims/     Samsung blobs + Android.bp/mk for ROM-tree builds
selinux/                            SELinux convergence: candidates, ledger, collector
tools/                              (empty) environment and version requirements
```

---

## Prerequisites

- **Device**: Snapdragon Samsung Galaxy S20 (SM-G98xx).
  Verified on SM-G981N and SM-G9880.
- **ROM**: Android 13 GSI. Verified on LineageOS 20.
  The build must be **test-keys** (`getprop ro.build.tags`) unless you hold that ROM's
  platform private key — the IMS/RRO APK runs as `android.uid.system` and must carry the
  ROM's platform signature.
- **Magisk** 26+ with root.
- **Carrier**: an IMS-provisioned SIM. Verified with China Telecom and China Unicom.

---

## How to build

> **Important:** The working S20 port is a four-DEX APK. The former single-DEX
> `smali_patch.diff` procedure is incomplete and produces an APK that cannot register IMS.
> Follow the staged build in **[BUILD.md](BUILD.md)** instead. It validates the exact stock
> input, applies `stock-to-desem5` then `desem5-to-desem81`, preserves all four DEX files,
> and verifies the final modern IMS service implementation.

Full environment setup, package list and exact versions: **[tools/README.md](tools/README.md)**.

For the Samsung/One UI dependency model, AOSP bridge boundaries, four-DEX artifact design, and runtime adaptation, see **[Architecture and compatibility model](docs/ARCHITECTURE.md)**.

For an evidence-driven methodology to investigate a **different** Samsung device, see **[Cross-device Samsung IMS porting guide](docs/CROSS_DEVICE_PORTING_GUIDE.md)**. It does not make this S20 payload portable.

```bash
source tools/env.sh
bash build.sh release --stock-apk /path/to/mount_system/system/priv-app/imsservice/imsservice.apk --stock-system /path/to/mount_system/system --output-dir out/release --sign
```

This end-to-end command builds the final four-DEX APK, derives the required local
`imsmanager.jar` compatibility override, and packages a validated Magisk ZIP. See
[BUILD.md](BUILD.md) for the required local `classes2.dex`, Samsung-framework and VSIM inputs.
Plain `bash build.sh` remains an optional maintainer command that regenerates the reviewed Java
bridge snapshot only.

The final assembler automatically compiles `java/` to a private temporary smali tree and
injects the 32 bridge classes after the two staged patches, before apktool produces `classes.dex`.
Running `bash build.sh` separately is an optional maintainer check that regenerates the reviewed,
tracked `smali_out/` snapshot; the assembler refuses a final build if fresh Java output differs
from that snapshot.


### Historical manual procedure

The former single-DEX patch sequence below is retained only to explain older releases. It is
**not** a supported rebuild method: it drops `classes2.dex`, `classes3.dex` and `classes4.dex`
and therefore omits required Samsung API, Gson and VSIM compatibility classes. Use the staged
four-DEX workflow in [BUILD.md](BUILD.md).

The APK at `proprietary_vendor_samsung_ims/proprietary/system/priv-app/imsservice/imsservice.apk`
is **already patched and signed** with the AOSP testkey. If your ROM uses that certificate
you can use it directly and skip this section.

To rebuild it yourself:

1. Obtain `imsservice.apk` from Samsung firmware **G981NKSU1HVJG** (SM-G981N, Android 13),
   at `system/priv-app/imsservice/imsservice.apk` inside `system.img`.
2. `apktool d imsservice.apk -o imsservice_dec`
   This firmware APK contains one `classes.dex`, so apktool creates `smali/`. Everything
   this project patches and adds belongs in that directory.
3. `patch -p1 -d imsservice_dec/smali < smali_patch.diff`
   *(note the `/smali` — the diff paths are `a/com/...`, relative to the smali root, not to
   the decompiled APK root)*
4. `cp -r smali_out/* imsservice_dec/smali/`
5. `cp AndroidManifest.xml imsservice_dec/AndroidManifest.xml`
6. `apktool b imsservice_dec -o imsservice_unsigned.apk`
7. `zipalign -p -f 4 imsservice_unsigned.apk imsservice_aligned.apk`
   *(zipalign is mandatory — an unaligned APK installs as "App not installed" on R+)*
8. Sign with your ROM's platform key:
   ```bash
   apksigner sign --key tools/keys/platform.pk8 \
                  --cert tools/keys/platform.x509.pem \
                  imsservice_aligned.apk
   ```

Steps 3 and 4 are distinct and both required. The patch modifies **existing** Samsung
classes and also adds the two stock-missing compat bridge classes
`GoogleImsServiceAdapter` and `ImsMmtelFeature`; `smali_out/` adds the Java-built AP-media,
SMS and diagnostic bridge classes. Applying only one of the two produces an incomplete APK.

---

## How to install

1. Verify the declared 61-file Magisk payload against the mounted stock system image:
   ```bash
   bash magisk-module/verify_payload.sh /path/to/mount_system/system
   ```
2. Build a test module from the committed known-device baseline, or pass a newly rebuilt APK
   explicitly with `--apk` after it passes `build/verify_apk.sh final`:
   ```bash
   bash magisk-module/build_module.sh --stock-root /path/to/mount_system/system out/S20_VoLTE_IMS.zip
   ```
3. Flash the resulting ZIP in Magisk.
4. **Reboot twice.** The first boot installs the module; IMS registration reliably comes
   up on the second.
5. Verify:
   ```bash
   adb logcat -s S20VOLTE
   ```
   You should see the `imsd` supervisor start and `multiclientd -s 1` launch as
   `radio/1001`.

The module also installs an RRO overlay that points `config_ims_mmtel_package` at
`com.sec.imsservice`. If your ROM ships another IMS package with a mutable overlay
(LineageOS has `flossims_telephony`), disable it or registration will be hijacked.

---

## SELinux

Samsung RKP (Knox EL2 hypervisor) **force-reboots the device** if the global SELinux
enforce bit is cleared. `setenforce 0` is therefore not an option — this was reproduced on
three different GSIs, so changing ROM does not help. This project never touches the global
enforce bit; it uses Magisk's `sepolicy.rule` plus targeted `chcon` labels in
`post-fs-data.sh`.

Starting point was four permissive domains and two daemons running as root. Current state:

| Item | Before | After |
|---|---|---|
| `permissive init` / `radio` / `system_server` | 4 permissive lines | **removed** |
| `permissive system_app` | — | **still required** (see #3) |
| `/dev/socket/imsd` | `socket_device` (denied) | `imsd_socket` |
| IMS call-record log dir | `system_data_file` (denied) | `rdxdump_data_file` |
| Module files (magic-mount) | `adb_data_file` | `system_file` / `system_lib_file` |
| `imsd` identity | root, all 38 caps | `system` (1000), `NET_RAW`+`NET_ADMIN` only |
| `multiclientd` identity | root, all 38 caps | `radio` (1001), **zero** caps |

Every one of these reuses a rule the GSI policy already had — **no new allow rules were
added**. Full history, evidence and the requirements ledger are in
[selinux/](selinux/).

### `ims_sock_launch`

Magisk magic-mounts a module's `/system/etc/init/*.rc` *after* init has already parsed
`/system/etc/init`, so init never registers `imsd` and never creates its control socket.
`imsd` then dies with `Obtaining file descriptor socket 'imsd' failed`.

`c/ims_sock_launch.c` reproduces what init would have done:

- creates, binds, chmods, chowns and listens on `/dev/socket/imsd`, exports
  `ANDROID_SOCKET_imsd`, then `execv`s the daemon;
- drops from post-fs-data's full root to the identity the stock `.rc` file specifies
  (uid/gid, supplementary groups, capabilities, ambient caps).

It does **not** change the SELinux domain: this GSI's policy contains no `imsd_exec` or
`multiclientd_exec` type, so no domain transition can exist and both daemons stay in the
`magisk` domain. Unix identity and SELinux domain are independent layers; this hardens the
one that can be hardened here.

Rebuild it with `bash c/build_ims_sock_launch.sh` (needs NDK r26d). A pre-built binary is
committed.

---

## Known limitations

**1. SIM 2 does not work.**
VoLTE only functions on **SIM slot 1**. The second slot cannot use IMS. `multiclientd` is
launched with `-s 1` (single slot) — stock uses `-s 2` for DSDS, but this GSI only exposes
slot 1 through the radio HAL.

**2. A post-call radio reset drops the network for a few seconds.**
Samsung's IMS internal state machine is not fully understood. Without intervention the
*next* call after a completed call comes up with no audio. As a workaround, the mobile
radio power is toggled to hard-reset the state machine after each call. Consequence: after
every call the data connection drops for roughly **3 seconds** and the phone is offline for
roughly **7 seconds**, during which calls and SMS cannot be received or sent. This is a
blunt workaround, not a fix; a precise state-machine or bearer-reset path would remove it.

**3. SELinux is not fully converged — `system_app` is still permissive.**
Three of the four permissive domains were removed, but `permissive system_app` remains and
may be a security concern. Removing it breaks IMS registration through
`/data/resource-cache/` (`resourcecache_data_file`), for which this GSI's policy grants
`system_app` nothing. Eight processes share that domain (Settings, keychain, dynsystem ×2,
localtransport, lineageparts, qcrilam, imsservice). Fixing it properly requires new allow
rules. Contributions welcome.

**4. Emergency calling is not fully tested, and no guarantee is made.**
Legal restrictions make repeated real emergency calls impossible. Testing covered many
calls to the **test emergency number** plus **one** real call to **110**. Emergency calling
is **not guaranteed to work in any given situation**. **Do not rely on this software for
emergency calls.** Always keep another means of contacting emergency services.

**5. One unreproducible IMS service crash.**
During extended testing the IMS service crashed once. It has never reproduced, and no logs
of the event were captured, so the cause is unknown and it cannot be fixed for now. If it
happens to you, **reboot the device** to recover. Logs of such a crash would be very
welcome in an issue report.

### Other notes

- Keep `persist.vendor.ims.ap_media_rotate_ports=false`. When enabled, the AP rotates its
  RTP receive port while the SDP port is chosen independently by the native stack, so from
  the third call onward the two disagree and the call connects with no audio.
- The build is not byte-for-byte deterministic. The committed APK is the on-device
  verified baseline.
- Only tested on the devices, ROM and carriers listed above.

---

## Firmware source

Blobs in `proprietary_vendor_samsung_ims/proprietary/` are extracted from:

```text
Device:   Samsung Galaxy S20 5G — SM-G981N (KOO)
Firmware: G981NKSU1HVJG (Android 13)
```

`ims_sock_launch` is **not** from Samsung firmware — it is this project's own helper
(`c/ims_sock_launch.c`, Apache-2.0). `libapims_signaling.so` is likewise project-added.
Deviations from stock are listed in `proprietary_vendor_samsung_ims/vendor-ims.mk`.

---

## Licensing

- This project's own code (`java/`, `c/`, `build.sh`, `magisk-module/*.sh`, `selinux/`)
  is Apache-2.0. See [LICENSE](LICENSE).
- `proprietary_vendor_samsung_ims/` contains **proprietary Samsung binaries** extracted
  from stock firmware. They are **not** covered by Apache-2.0 and are redistributed here
  for interoperability only. Verify your own legal position before redistributing.
- No signing keys are included.

---

## Related projects and Acknowledgements

- [jameskdev/android_samsung_imsservice](https://github.com/jameskdev/android_samsung_imsservice)
  — the original A21s / Android 11 port that made this possible.
- [phhusson/ims](https://github.com/phhusson/ims) (PhhIms) — a pure-userspace SIP/RTP
  alternative that does not use Samsung's stack at all, which refers to the processing method of their audio section.

---


