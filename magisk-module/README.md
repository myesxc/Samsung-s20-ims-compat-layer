# Magisk module packaging

`build_module.sh` produces the installable Magisk ZIP from the exact payload declared in
[`payload-manifest.tsv`](payload-manifest.tsv). The manifest is the packaging authority; do not
try to derive a module solely from `vendor-ims.mk` or `Android.bp`, because those ROM-tree files
do not include the RRO overlay or Magisk runtime scaffold.

## Payload provenance

The module stages exactly **61** files below `system/`:

- **55 stock-identical** G981NKSU1HVJG extractions;
- **3 project additions**: `ims_sock_launch`, `libapims_signaling.so`, and the IMS RRO overlay;
- **2 known non-stock compatibility overrides**: [`imsmanager.jar`](../imsmanager-compat/README.md)
  (unaltered Samsung primary DEX plus a five-stub secondary DEX) and radio bridge `@2.1`;
- **1 four-DEX patched `imsservice.apk`**.

The EPDG certificates for `VAU`, `VDF`, and `XME` are documented intentional exclusions from the
stock source; they were absent from the verified historical module as well.

## Verify the source payload

In WSL, with the stock system image mounted read-only or normally under the supplied mount point:

```bash
bash magisk-module/verify_payload.sh /home/myesxc/mount_system/system
```

Expected summary:

```text
stock-identical:       55
project additions:     3
compatibility overrides: 2
patched APKs:          1
intentional omissions: 3
```

The verifier is read-only. It rejects any system root whose `imsservice.apk` does not match the
supported G981NKSU1HVJG stock hash.

## Build the module

Build from the committed, known-device baseline APK:

```bash
bash magisk-module/build_module.sh --stock-root /home/myesxc/mount_system/system out/S20_VoLTE_IMS.zip
```

To package a locally regenerated `imsmanager.jar` compatibility override, build and verify it
through [`imsmanager-compat/`](../imsmanager-compat/README.md), then pass it explicitly:

```bash
bash magisk-module/build_module.sh --imsmanager out/imsmanager.jar out/S20_VoLTE_IMS_imsmanager-local.zip
```

To package a newly rebuilt APK, first ensure it passes the final four-DEX verifier, then pass it
explicitly. The builder verifies it again before and after ZIP creation:

```bash
bash magisk-module/build_module.sh --apk out/imsservice.apk --stock-root /home/myesxc/mount_system/system out/S20_VoLTE_IMS_rebuilt.zip
```

The builder creates a fresh temporary module root and does not modify the proprietary payload,
provided APK, stock mount, signing keys, or `out/` inputs. It rejects `.idsig` files and omits all
host-side source, build, logs, keys, OAT/VDEX, and helper-script files.

Before flashing, retain the last known-good ZIP. Flash only the test ZIP, reboot twice, confirm IMS
registration, then run the established calls and IMS SMS smoke tests. Do not use `setenforce 0`.
