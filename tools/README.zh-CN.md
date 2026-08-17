# 工具与环境要求

> English documentation: [README.md](README.md)

---

本目录故意**没有二进制文件**。不要在此提交 Android SDK、构建工具或签名密钥 —— `.gitignore` 设计上阻止 `tools/keys/` 及所有密钥材料。

下面的一切都由你下载一次，在运行 `build.sh` 前完成。

## 四 DEX 构建输入

完整的 APK 构建在 [BUILD.md](../BUILD.md) 中描述。除了公开 SDK 工具，它还需要 `build-inputs/` 下的本地、git 忽略的输入：

- `classes2.dex`：历史 Gson 兼容性 payload（其原始构建出处尚未完全重建；其必需的 SHA-256 被检查）；
- `classes3.dex`：Samsung IMS 框架 API，从匹配的专有 Samsung `framework.jar` 在本地派生，从不作为项目编著代码提交；
- `classes4.dex`：VSIM 兼容性 stub，从跟踪的 `vsim_stub/` 源可复现地构建。

`build/build_apk.sh` 验证确切支持的原厂 APK、在私有临时目录运行与 `build.sh` 相同的 JDK 17 / D8 / dex-tools Java 桥接流水线，并拒绝创建之前那个破坏的单 DEX 输出。它只能用本地提供的平台密钥签名。`SMALI_OUT` 可能为此私有汇编步骤覆盖 `build.sh` 的默认跟踪输出目录；普通用户不需要设置它。

---

## 参考构建环境

该项目在以下环境上开发和验证：

| | |
|---|---|
| 主机 OS | Windows 11 + **WSL2 Ubuntu 22.04 LTS** |
| 替代方案 | 原生 Linux（任何带下面软件包的发行版）或 macOS |
| 磁盘空间 | ≥ 12 GB 可用（apktool 将原厂 APK 解压到一个大树） |
| RAM | ≥ 8 GB（建议 16 GB） |

不需要 WSL2 —— 它只是被使用的。任何带下面软件包的 Linux 环境都能用。原生在 Windows 上构建（cmd/PowerShell）**不受支持**；脚本是 POSIX shell。

---

## 第 1 步 —— 基础 OS 软件包（Ubuntu / WSL / Debian）

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

每个的用途：

| 软件包 | 需要用于 |
|---|---|
| `openjdk-17-jdk` | `build.sh` 的 `javac` + `java`（仅 JRE **不够**） |
| `binutils` | `readelf` —— `c/build_ims_sock_launch.sh` 验证 AArch64/PIE 输出 |
| `file` | 同一脚本，ELF 合理性检查 |
| `unzip` / `zip` | 提取 SDK、dex-tools、apktool；重新打包 Magisk 模块 |
| `wget` / `curl` | 下载 SDK 和工具 |
| `patch` | 对解压的原厂 APK 应用 `smali_patch.diff` |
| `git` | 克隆此仓库 |
| `python3` | 可选辅助脚本 |
| `build-essential` | 提供 `make` 和常见构建工具 |

`coreutils` 提供 `sha256sum`、`install`、`mktemp` —— 在本质上每个发行版都存在，仅为完整性列出。

在 **macOS** 上，用 Homebrew 安装等价物（`brew install openjdk@17 binutils wget`），并在运行 NDK 构建脚本前设置 `NDK_HOST=darwin-x86_64`。

---

## 第 2 步 —— Android SDK

### platform-33（Android 13，API 33）

必需文件：`platforms/android-33/android.jar` —— 编译时类路径。

### build-tools 33.0.3

必需二进制：`d8`（dex）、`zipalign`、`apksigner`。
使用**恰好 33.0.3**；`d8` 标志在版本间有所不同。

```bash
# 命令行工具（不需要 Android Studio）
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
mkdir -p ~/android-sdk/cmdline-tools
unzip commandlinetools-linux-*.zip -d ~/android-sdk/cmdline-tools
mv ~/android-sdk/cmdline-tools/cmdline-tools ~/android-sdk/cmdline-tools/latest

export ANDROID_HOME=~/android-sdk
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

yes | sdkmanager --licenses
sdkmanager "platforms;android-33" "build-tools;33.0.3"

export SDK_HOME=$ANDROID_HOME       # build.sh 读取 SDK_HOME
```

---

## 第 3 步 —— dex-tools v2.4

提供 `BaksmaliCmd`（dex → smali）。版本**恰好 2.4**。

```bash
wget https://github.com/pxb1988/dex2jar/releases/download/v2.4/dex-tools-v2.4.zip
mkdir -p ~/tools
unzip dex-tools-v2.4.zip -d ~/tools/
export DEX_TOOLS_LIB=~/tools/dex-tools-v2.4/lib
```

`build.sh` 默认在仓库内查找 `tools/dex-tools-v2.4/lib`；设置 `DEX_TOOLS_LIB` 覆盖它并保持仓库清洁。

---

## 第 4 步 —— apktool 2.9+

解压和重建原厂 APK。用 **2.9.3** 测试。
不被 `build.sh` 本身使用 —— 仅被主 README 中的手工补丁步骤使用。

```bash
mkdir -p ~/tools
wget https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar \
     -O ~/tools/apktool.jar
export APKTOOL_JAR_PATH=~/tools/apktool.jar
```

---

### `imsmanager-compat/` 本地 JAR 输入

重建框架兼容性覆盖需要从 G981NKSU1HVJG 本地提取的匹配原厂 `system/framework/imsmanager.jar`。辅助工具用 apktool 构建其五 stub 次级 DEX 并验证 DEX 哈希。对此哈希再现步骤使用**apktool 3.0.1**（该仓库使用的本地锁定工具）、`zip`、`unzip`、OpenJDK 17 和标准 POSIX 工具。

根 `build.sh release` 协调器还需要本地提供的原厂系统根，包含 `framework/imsmanager.jar`、三个忽略的 `build-inputs/classes{2,3,4}.dex` payload 及 `tools/keys/` 下的平台签名密钥。它仅创建请求的发布 artifact，从不将这些本地输入复制到输出目录。

仅在修改 `c/ims_sock_launch.c` 时需要。一个预构建的二进制已经提交在 `proprietary_vendor_samsung_ims/proprietary/system/bin/ims_sock_launch`。

辅助工具必须针对 **bionic** 链接，所以主机 `gcc` 不行。

```bash
wget https://dl.google.com/android/repository/android-ndk-r26d-linux.zip
unzip android-ndk-r26d-linux.zip -d ~/ndk-cache/
export NDK=~/ndk-cache/android-ndk-r26d

bash c/build_ims_sock_launch.sh
```

---

## 第 6 步 —— 平台签名密钥 *(你必须提供)*

**此仓库不随附任何签名密钥。**

`imsservice.apk` 声明 `android:sharedUserId="android.uid.system"`，所以它必须用你安装它的 ROM 的**平台密钥**签名。来自不同 ROM 的密钥使包安装失败（"App not installed"）或无法获取系统 UID。

- **LineageOS 20 官方构建**用公开 AOSP `testkey` 签名，它存在于 LineageOS/AOSP 源树的 `build/target/product/security/testkey.{pk8,x509.pem}` 中。
- **自构建 ROM**：使用你自己的 `platform.pk8` / `platform.x509.pem`。
- **其他 GSI**：检查 `getprop ro.build.tags`。如果它报告 `release-keys`，在没有供应商私钥的情况下无法为该构建签名系统 UID 应用。

把你的密钥放在：

```
tools/keys/platform.pk8
tools/keys/platform.x509.pem
```

两个路径都被 git 忽略。用以下命令验证已签名的 APK：

```bash
apksigner verify --print-certs imsservice_aligned.apk
```

打印的证书必须匹配 ROM 的平台证书。

---

## 版本摘要

| 工具 | 版本 | 用途 |
|---|---|---|
| OpenJDK | 17.x | 编译桥接 Java 源 |
| Android SDK platform-33 | API 33 | `android.jar` 编译类路径 |
| build-tools | 33.0.3（精确） | `d8`、`zipalign`、`apksigner` |
| dex-tools | 2.4（精确） | `BaksmaliCmd`（dex → smali） |
| apktool | 2.9.3（2.9+） | 解压/重建原厂 APK |
| NDK | r26d | 交叉编译 `ims_sock_launch`（可选） |
| 平台签名密钥 | 特定于 ROM | 签名最终 APK（**你提供**） |

## 脚本读取的环境变量

| 变量 | 默认 | 使用者 |
|---|---|---|
| `JAVA_HOME` | 从 `javac` 派生 | `build.sh` |
| `SDK_HOME` | `~/Android/Sdk` | `build.sh` |
| `BUILD_TOOLS_VERSION` | `33.0.3` | `build.sh` |
| `ANDROID_JAR` | `$SDK_HOME/platforms/android-33/android.jar` | `build.sh` |
| `DEX_TOOLS_LIB` | `tools/dex-tools-v2.4/lib` | `build.sh` |
| `APKTOOL_JAR_PATH` | `~/tools/apktool.jar` | 手工补丁步骤 |
| `NDK` | `~/ndk-cache/android-ndk-r26d` | `c/build_ims_sock_launch.sh` |
| `NDK_HOST` | `linux-x86_64` | `c/build_ims_sock_launch.sh`（macOS：`darwin-x86_64`） |
