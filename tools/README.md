# Tools & Environment Requirements

This directory is intentionally **empty of binaries**. Do not commit the Android SDK,
build tools, or signing keys here — `.gitignore` blocks `tools/keys/` and all key
material by design.

Everything below is downloaded by you, once, before running `build.sh`.

## Four-DEX build inputs

The complete APK build is documented in [BUILD.md](../BUILD.md). In addition to the public
SDK tools, it requires local, git-ignored inputs under `build-inputs/`:

- `classes2.dex`: the historical Gson compatibility payload (its original build provenance is
  not yet fully reconstructed; its required SHA-256 is checked);
- `classes3.dex`: Samsung IMS framework APIs, derived locally from the matching proprietary
  Samsung `framework.jar` and never committed as project-authored code;
- `classes4.dex`: VSIM compatibility stubs, reproducibly built from the tracked `vsim_stub/`
  sources.

`build/build_apk.sh` validates the exact supported stock APK, runs the same JDK 17 / D8 /
dex-tools Java bridge pipeline as `build.sh` in a private temporary directory, and refuses to
create the former broken single-DEX output. It can sign only with a locally supplied platform key.
`SMALI_OUT` may override `build.sh`'s default tracked output directory for this private assembly
step; normal users do not need to set it.

---

## Reference build environment

The project was developed and verified on:

| | |
|---|---|
| Host OS | Windows 11 + **WSL2 Ubuntu 22.04 LTS** |
| Alternative | Native Linux (any distro with the packages below) or macOS |
| Disk space | ≥ 12 GB free (apktool decompiles the stock APK into a large tree) |
| RAM | ≥ 8 GB (16 GB recommended) |

WSL2 is not required — it is simply what was used. Any Linux environment with the
packages below works. Building natively on Windows (cmd/PowerShell) is **not**
supported; the scripts are POSIX shell.

---

## Step 1 — Base OS packages (Ubuntu / WSL / Debian)

```bash
sudo apt update
sudo apt install -y \
    openjdk-17-jdk \
    build-essential \
    binutils \
    file \
    unzip zip \
    wget curl \
    git \
    python3 \
    patch \
    coreutils
```

What each is for:

| Package | Needed by |
|---|---|
| `openjdk-17-jdk` | `javac` + `java` for `build.sh` (a JRE alone is **not** enough) |
| `binutils` | `readelf` — `c/build_ims_sock_launch.sh` verifies the AArch64/PIE output |
| `file` | same script, ELF sanity check |
| `unzip` / `zip` | extracting the SDK, dex-tools, apktool; repacking the Magisk module |
| `wget` / `curl` | downloading the SDK and tools |
| `patch` | applying `smali_patch.diff` to the decompiled stock APK |
| `git` | cloning this repository |
| `python3` | optional helper scripts |
| `build-essential` | provides `make` and common build utilities |

`coreutils` supplies `sha256sum`, `install`, `mktemp` — present on essentially every
distro, listed only for completeness.

On **macOS**, install the equivalents with Homebrew (`brew install openjdk@17 binutils
wget`) and set `NDK_HOST=darwin-x86_64` before running the NDK build script.

---

## Step 2 — Android SDK

### platform-33 (Android 13, API 33)

Required file: `platforms/android-33/android.jar` — the compile-time classpath.

### build-tools 33.0.3

Required binaries: `d8` (dex), `zipalign`, `apksigner`.
Use **33.0.3 exactly**; `d8` flags differ between versions.

```bash
# Command-line tools (no Android Studio needed)
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
mkdir -p ~/android-sdk/cmdline-tools
unzip commandlinetools-linux-*.zip -d ~/android-sdk/cmdline-tools
mv ~/android-sdk/cmdline-tools/cmdline-tools ~/android-sdk/cmdline-tools/latest

export ANDROID_HOME=~/android-sdk
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

yes | sdkmanager --licenses
sdkmanager "platforms;android-33" "build-tools;33.0.3"

export SDK_HOME=$ANDROID_HOME       # build.sh reads SDK_HOME
```

---

## Step 3 — dex-tools v2.4

Provides `BaksmaliCmd` (dex → smali). Version **2.4 exactly**.

```bash
wget https://github.com/pxb1988/dex2jar/releases/download/v2.4/dex-tools-v2.4.zip
mkdir -p ~/tools
unzip dex-tools-v2.4.zip -d ~/tools/
export DEX_TOOLS_LIB=~/tools/dex-tools-v2.4/lib
```

`build.sh` looks for `tools/dex-tools-v2.4/lib` inside the repo by default; setting
`DEX_TOOLS_LIB` overrides that and keeps the repo clean.

---

## Step 4 — apktool 2.9+

Decompiles and rebuilds the stock APK. Tested with **2.9.3**.
Not used by `build.sh` itself — only by the manual patch steps in the main README.

```bash
mkdir -p ~/tools
wget https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar \
     -O ~/tools/apktool.jar
export APKTOOL_JAR_PATH=~/tools/apktool.jar
```

---

### `imsmanager-compat/` local JAR input

Rebuilding the framework compatibility override requires the matching stock
`system/framework/imsmanager.jar` extracted locally from G981NKSU1HVJG. The helper builds its
five-stub secondary DEX with apktool and validates DEX hashes. Use **apktool 3.0.1** (the local
pinned tool used by this repository) for this hash-reproducing step, along with `zip`, `unzip`,
OpenJDK 17, and standard POSIX utilities.


Only needed if you modify `c/ims_sock_launch.c`. A pre-built binary is already committed
at `proprietary_vendor_samsung_ims/proprietary/system/bin/ims_sock_launch`.

The helper must be linked against **bionic**, so a host `gcc` will not work.

```bash
wget https://dl.google.com/android/repository/android-ndk-r26d-linux.zip
unzip android-ndk-r26d-linux.zip -d ~/ndk-cache/
export NDK=~/ndk-cache/android-ndk-r26d

bash c/build_ims_sock_launch.sh
```

---

## Step 6 — Platform signing key *(you must supply this)*

**No signing keys are distributed with this repository.**

`imsservice.apk` declares `android:sharedUserId="android.uid.system"`, so it must be
signed with the **platform key of the exact ROM you install it on**. A key from a
different ROM makes the package fail to install ("App not installed") or fail to gain
the system UID.

- **LineageOS 20 official builds** are signed with the public AOSP `testkey`, which
  lives in the LineageOS/AOSP source tree at
  `build/target/product/security/testkey.{pk8,x509.pem}`.
- **Self-built ROMs**: use your own `platform.pk8` / `platform.x509.pem`.
- **Other GSIs**: check `getprop ro.build.tags`. If it reports `release-keys`, you
  cannot sign a system-UID app for that build without the vendor's private key.

Place your key at:

```
tools/keys/platform.pk8
tools/keys/platform.x509.pem
```

Both paths are git-ignored. Verify a signed APK with:

```bash
apksigner verify --print-certs imsservice_aligned.apk
```

The printed certificate must match the ROM's platform certificate.

---

## Version summary

| Tool | Version | Purpose |
|---|---|---|
| OpenJDK | 17.x | Compile bridge Java sources |
| Android SDK platform-33 | API 33 | `android.jar` compile classpath |
| build-tools | 33.0.3 (exact) | `d8`, `zipalign`, `apksigner` |
| dex-tools | 2.4 (exact) | `BaksmaliCmd` (dex → smali) |
| apktool | 2.9.3 (2.9+) | Decompile / rebuild stock APK |
| NDK | r26d | Cross-compile `ims_sock_launch` (optional) |
| Platform signing key | ROM-specific | Sign the final APK (**you supply**) |

## Environment variables read by the scripts

| Variable | Default | Used by |
|---|---|---|
| `JAVA_HOME` | derived from `javac` | `build.sh` |
| `SDK_HOME` | `~/Android/Sdk` | `build.sh` |
| `BUILD_TOOLS_VERSION` | `33.0.3` | `build.sh` |
| `ANDROID_JAR` | `$SDK_HOME/platforms/android-33/android.jar` | `build.sh` |
| `DEX_TOOLS_LIB` | `tools/dex-tools-v2.4/lib` | `build.sh` |
| `APKTOOL_JAR_PATH` | `~/tools/apktool.jar` | manual patch steps |
| `NDK` | `~/ndk-cache/android-ndk-r26d` | `c/build_ims_sock_launch.sh` |
| `NDK_HOST` | `linux-x86_64` | `c/build_ims_sock_launch.sh` (macOS: `darwin-x86_64`) |
