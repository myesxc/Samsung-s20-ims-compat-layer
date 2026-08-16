# `imsmanager.jar` GSI compatibility override

> 中文文档：[README.zh-CN.md](README.zh-CN.md)

---

Samsung’s stock `imsmanager.jar` expects framework APIs that do not exist on the target Android 13
GSI. Restoring the stock JAR causes IMS registration to fail. This directory reproduces the
minimal compatibility change without modifying Samsung’s original primary DEX.

```text
stock imsmanager.jar
├── classes.dex       unchanged Samsung primary DEX
└── classes2.dex      added by this project: five compatibility stubs
```

The injected classes are:

```text
android.os.SemSystemProperties
com.samsung.android.emergencymode.SemEmergencyConstants
com.samsung.android.feature.SemCscFeature
com.samsung.android.feature.SemFloatingFeature
com.samsung.android.wifi.SemWifiManager
```

## Build locally

The input JAR must be extracted locally from the supported G981NKSU1HVJG system image. Neither
the original Samsung JAR nor a newly derived JAR belongs in this source directory or in Git.

```bash
bash imsmanager-compat/build.sh --input /path/to/your/imsmanager.jar --output out/imsmanager.jar
```

```bash
bash imsmanager-compat/verify.sh out/imsmanager.jar
```

The builder verifies the source JAR hash, builds the five-stub DEX from `stub-apk/`, copies the
input to the requested output path, and injects only `classes2.dex`. The verifier requires the
stock `classes.dex` to remain byte-identical and validates the exact five-class payload.

A whole-JAR hash can differ from the historical output because ZIP metadata may differ; the two
DEX payload hashes and class descriptors are the compatibility contract.

## Package in a Magisk module

Use the derived local JAR explicitly; do not overwrite the committed known-good baseline under
`proprietary_vendor_samsung_ims/`:

```bash
bash magisk-module/build_module.sh --imsmanager out/imsmanager.jar out/S20_VoLTE_IMS.zip
```

The module builder validates the local JAR before staging and again after extracting the final ZIP.
