# S20 IMS package-selection RRO

> 中文版：[S20 IMS 包选择 RRO](README.zh-CN.md)

This directory contains the **project-authored source** for `S20VoLTEImsOverlay.apk`, the static runtime resource overlay (RRO) packaged by the Magisk module. It is not Samsung firmware and contains no Java, Kotlin, native code, or DEX files.

## Purpose

AOSP Telephony selects an IMS implementation through framework resources. On the documented S20 / Android 13 GSI target, this RRO overlays `com.android.phone` so that `ImsResolver` selects Samsung's `com.sec.imsservice` package:

| Overridden resource | Value |
|---|---|
| `config_ims_mmtel_package` | `com.sec.imsservice` |
| `config_ims_rcs_package` | `com.sec.imsservice` |

The overlay does not implement IMS, change `imsservice.apk`, add Samsung APIs, launch daemons, or relax SELinux. It addresses only the framework package-selection boundary described in [Architecture and compatibility model](../docs/ARCHITECTURE.md).

## S20-specific overlay contract

| Property | Value |
|---|---|
| APK package | `com.s20volte.imsoverlay` |
| Target package | `com.android.phone` |
| Overlay mode | Static runtime resource overlay |
| Priority | `9999` |
| Application code | None (`android:hasCode="false"`) |
| API build values | min SDK 30; target SDK 33 |
| Canonical payload location | `proprietary_vendor_samsung_ims/proprietary/system/product/overlay/S20VoLTEImsOverlay.apk` |
| Magisk install location | `/system/product/overlay/S20VoLTEImsOverlay.apk` |

This contract is validated for the repository's documented S20 Android 13 baseline only. **Do not copy this RRO to another model, firmware, or ROM merely because it is Samsung-based.** A different target may use another resource name, target package, overlay policy, API level, signing requirement, package name, or IMS framework path.

Before adapting it elsewhere, follow the [cross-device porting guide](../docs/CROSS_DEVICE_PORTING_GUIDE.md): inspect the target `framework-res.apk`, `ImsResolver` selection behavior, overlayable policy, installed overlays, target package, and accepted signature identity.

## Source layout

```text
rro/
├── AndroidManifest.xml       Static RRO package and target declaration
├── res/values/config.xml     Two IMS package resource overrides
├── build.sh                  Build plus structural/signature/resource verification
├── README.md                 This document
└── README.zh-CN.md           Chinese counterpart
```

`build.sh` is intentionally the only RRO build entry point. It performs verification after building, so there is no separate `verify.sh`.

## Prerequisites

Use WSL or another POSIX-compatible Bash environment. Supply local, untracked inputs:

1. Android SDK Build-Tools **33.0.3**: `aapt2`, `aapt`, `zipalign`, and `apksigner`.
2. A `framework-res.apk` compatible with the intended target ROM and release.
3. A private key (`.pk8`) and certificate (`.x509.pem`) accepted by that ROM's overlay/signature policy.

After loading the project environment, tools default to `${SDK_HOME}/build-tools/33.0.3`. Without that environment, the script falls back to the local ignored cache under `tools/android-sdk/build-tools/33.0.3`. You may override individual paths with `AAPT2`, `AAPT`, `ZIPALIGN`, `APKSIGNER`, or set `RRO_BUILD_TOOLS`.

Do not commit `framework-res.apk`, SDK contents, private keys, certificates, temporary `.flat` files, unsigned/aligned APKs, or `.idsig` files. The repository's [`.gitignore`](../.gitignore) and [tools guide](../tools/README.md) define this local-input boundary.

## Build an experimental APK

Build to a new external output first. The script refuses to overwrite an existing output unless `--force` is supplied.

```bash
bash rro/build.sh \
  --framework-res /path/to/target/system/framework/framework-res.apk \
  --key /path/to/platform.pk8 \
  --cert /path/to/platform.x509.pem \
  --output out/S20VoLTEImsOverlay.apk
```

The supplied `framework-res.apk` must contain both target resource names. The script stops before building if either is absent:

```text
config_ims_mmtel_package
config_ims_rcs_package
```

An input framework or signing identity that works for the documented S20 target is not automatically compatible with another ROM.

## What `build.sh` verifies

Before reporting success, the script verifies:

- the source manifest/resources, framework resource APK, key, certificate, and build tools exist;
- `framework-res.apk` declares both overridden resource names;
- the output is aligned to 4 bytes;
- APK signature verification succeeds;
- the package is `com.s20volte.imsoverlay`;
- min SDK is 30 and target SDK is 33;
- the manifest targets `com.android.phone`, declares a static overlay, and uses priority `9999`;
- the compiled resource table contains both IMS resource names and `com.sec.imsservice`;
- the APK has no `classes*.dex` entry;
- output SHA-256 and signer information are printed.

The checks establish artifact structure only. They do **not** prove that the target framework accepts the overlay, chooses the intended IMS package, or registers IMS. Verify those on-device conditions separately.

## Refreshing the canonical module payload

The tracked canonical overlay is consumed by the Magisk payload manifest:

```text
proprietary_vendor_samsung_ims/proprietary/system/product/overlay/S20VoLTEImsOverlay.apk
```

Do not replace this APK by hand. When an intentional source change needs to become the baseline:

1. Build and inspect an external experimental APK first.
2. Rebuild explicitly to the canonical payload path, using `--force` only after review:

   ```bash
   bash rro/build.sh \
     --framework-res /path/to/framework-res.apk \
     --key /path/to/platform.pk8 \
     --cert /path/to/platform.x509.pem \
     --output proprietary_vendor_samsung_ims/proprietary/system/product/overlay/S20VoLTEImsOverlay.apk \
     --force
   ```

3. Update **only** the corresponding `project-added` SHA-256 entry for `product/overlay/S20VoLTEImsOverlay.apk` in [`magisk-module/payload-manifest.tsv`](../magisk-module/payload-manifest.tsv), if the hash changed.
4. Run the existing payload/module validation workflow from [magisk-module/README.md](../magisk-module/README.md).

The payload manifest remains the package authority. `magisk-module/build_module.sh` must remain responsible for staging and validating the final module ZIP; `rro/build.sh` never copies an APK into a Magisk staging directory automatically.

## Deployment and competing overlays

The module installs this artifact at `/system/product/overlay/S20VoLTEImsOverlay.apk`, and `post-fs-data.sh` applies owner `root:root` and mode `0644`.

On the documented LineageOS-derived target, a mutable IMS overlay such as `flossims_telephony` can select another package and prevent `com.sec.imsservice` from being used. Determine the actual selected overlay/package on the target device before debugging bridge, daemon, or radio behavior. Static RRO behavior and `cmd overlay` control are policy-dependent; do not assume a static overlay can be toggled at runtime.

See [README.md](../README.md) for the supported S20 scope, [BUILD.md](../BUILD.md) for the final artifact workflow, and [magisk-module/README.md](../magisk-module/README.md) for module packaging.
