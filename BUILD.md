# Four-DEX APK Build

The historical S20 port is a **four-DEX** application. A previous public build procedure rebuilt only the stock primary DEX, producing an installable and correctly signed APK that could not register IMS. Do not use `smali_patch.diff` plus `smali_out/` as a standalone APK build procedure.

The build script applies both stages internally, compiles the tracked Java bridge into a private temporary smali tree, injects it into the primary DEX, and emits only the final desem81-compatible APK:

```text
stock APK → stock-to-desem5 compatibility changes → desem5-to-desem81 changes → compile and inject Java bridge smali → final APK
```

`desem5` is a patch boundary and validation reference, **not** an output that an ordinary
builder needs to create, retain, install, or sign. The final build proceeds through this state
inside its private temporary decode tree.

This directory contains the ordered, canonical primary-smali stages:

1. `patches/stock-to-desem5.patch` — applies the historical stock compatibility work.
2. `patches/desem5-to-desem81.patch` — applies the verified modern IMS, call, media, SMS, emergency, and later fixes.

The secondary DEX payloads remain unchanged through the later builds:

| Input | Purpose | SHA-256 | Source policy |
|---|---|---|---|
| `classes2.dex` | Gson compatibility payload (204 classes) | `a7c3fc1efd5bb8d00bbce9937cd79c51a8d9d417e347caff81de849d8bf57132` | Historical local compatibility input; its exact original Gson build is not yet reconstructed. |
| `classes3.dex` | Samsung IMS framework APIs (120 classes) | `3dbe49e57ace872dd49281bf0d22a84067aedb468898031998e88f572f608b54` | Derive locally from the matching Samsung `framework.jar`; do not commit or publish it as project-authored code. |
| `classes4.dex` | VSIM/softphone stubs (12 classes) | `8936e2be6b023191fc9c309b07655b66f009ff55d470798441a049109d99da79` | Built from tracked [`vsim_stub/`](vsim_stub/). |

All local dependencies belong in `build-inputs/`, which is git-ignored.

## Complete WSL build procedure

The commands below create only the final `out/imsservice.apk`; all decode and patch directories
are created beneath a temporary directory and removed automatically.

### 1. Enter the repository and load the local tools

```bash
cd /mnt/d/s20-imsservice/s20-imsservice-oss
```

```bash
source tools/env.sh
```

The Java bridge compilation below is a maintainer reproducibility check: it regenerates the
tracked `smali_out/` snapshot and must still yield 32 smali files. A normal final APK build runs
the same compilation automatically into a private temporary directory and verifies it matches
that snapshot before injection.

```bash
bash build.sh
```

### 2. Prepare the local, ignored compatibility inputs

```bash
mkdir -p build-inputs out
```

Put the known historical Gson payload at `build-inputs/classes2.dex`. Build the VSIM payload
from tracked source:

```bash
bash build/deps/build_classes4.sh build-inputs/classes4.dex
```

`classes3.dex` must be the canonical Samsung-framework payload. Until the historical `dx`
toolchain is packaged and pinned, copy the locally verified historical payload to
`build-inputs/classes3.dex`; the assembly script verifies its SHA-256 before it uses it.

### 3. Verify the stock APK

```bash
bash build/verify_input.sh /path/to/imsservice.apk
```

This must report the documented G981NKSU1HVJG SHA-256 and exactly one `classes.dex`. Stop here
if it fails; do not use another Samsung build, an A21 artifact, or a previously patched APK.

### 4. Assemble and sign the final APK in one command

```bash
bash build/build_apk.sh --sign /path/to/imsservice.apk out/imsservice.apk
```

The script applies both patch stages in its private temporary directory, compiles Java bridge
sources there and injects the resulting smali into the primary DEX, injects and hashes all three
stable secondary DEX payloads, zipaligns, signs with local `tools/keys/platform.{pk8,x509.pem}`,
and deletes intermediates.

To inspect a build before signing, omit `--sign`; the output is unsigned and must not be
installed as the system package.

### 5. Verify the final artifact again

```bash
bash build/verify_apk.sh final out/imsservice.apk
```

Expected properties:

```text
classes.dex
classes2.dex
classes3.dex
classes4.dex
GoogleModernImsService / GoogleModernMmTelFeature / GoogleModernRegistration present
204 / 120 / 12 classes in the secondary DEX files
```

### 6. Deploy safely

Replace only the IMS APK in a copy of the Magisk module, preserve the last verified module ZIP,
flash the test ZIP, and reboot twice. Do not use `setenforce 0`; Samsung RKP force-reboots when
the global SELinux enforce bit is cleared. After the second boot, confirm IMS registration before
placing any emergency call. Use only the documented test emergency route and retain another way
to reach emergency services.

## Required stock input

Only the IMS APK extracted from Samsung `G981NKSU1HVJG` for SM-G981N is supported:

```text
SHA-256: c1cbb451cbbfdb967fa8fb98ef35aea545eff13ea546e4b09c936b690308db3c
DEX:     classes.dex only
```

Validate it before building:

```bash
source tools/env.sh
bash build/verify_input.sh /path/to/imsservice.apk
```

## Local dependency reference

The complete commands are in the procedure above. This section is retained as a short reference:

- `build-inputs/classes2.dex` is a validated historical Gson compatibility payload.
- `build-inputs/classes3.dex` is the validated Samsung framework compatibility payload.
- `build-inputs/classes4.dex` is built from `vsim_stub/` by `build/deps/build_classes4.sh`.
- `build/build_apk.sh [--sign] <stock-imsservice.apk> <output.apk>` always produces the final
  four-DEX desem81-compatible output directly from stock.

## `imsmanager.jar` compatibility override

This is separate from the APK's 204-class Gson `classes2.dex`: `imsmanager.jar` retains its
original Samsung `classes.dex` and receives a five-class `classes2.dex` containing the GSI
compatibility stubs `SemSystemProperties`, `SemEmergencyConstants`, `SemCscFeature`,
`SemFloatingFeature`, and `SemWifiManager`. Restoring the pure stock JAR breaks IMS registration
on the verified Android 13 target.

Build the derived JAR only from a local stock firmware extraction:

```bash
bash imsmanager-compat/build.sh --input /home/myesxc/mount_system/system/framework/imsmanager.jar --output out/imsmanager.jar
```

```bash
bash imsmanager-compat/verify.sh out/imsmanager.jar
```

Pass it to the module builder with `--imsmanager out/imsmanager.jar`; do not overwrite the
tracked baseline JAR under `proprietary_vendor_samsung_ims/`.

## Magisk module package

The module payload is not hand-assembled. It is defined by
[`magisk-module/payload-manifest.tsv`](magisk-module/payload-manifest.tsv): 55 stock-identical
files, three project additions, two known compatibility overrides, and the patched four-DEX APK.
Build and validate it with:

```bash
bash magisk-module/verify_payload.sh /home/myesxc/mount_system/system
```

```bash
bash magisk-module/build_module.sh --stock-root /home/myesxc/mount_system/system out/S20_VoLTE_IMS.zip
```

Use `--apk out/imsservice.apk` only for an explicitly rebuilt artifact that already passes
`build/verify_apk.sh final`. The builder verifies it again, stages exactly 61 `system/` files,
checks the emitted ZIP, and excludes `.idsig`, keys, captures, build source and host tools.

## Reproducibility scope

The scripts verify **functional structure**: ordered patches, all four DEX files, stable secondary DEX hashes, expected class sets, modern manifest binding, and key compatibility removals. They do not claim byte-identical APK output because apktool/D8/ZIP compression/signing metadata can change bytes.

`build/maintenance/generate_stage_patches.sh` is maintenance-only. It regenerates the canonical patches from locally available decoded stock, desem5, and desem81 reference trees; those proprietary reference trees are not part of the public repository.
