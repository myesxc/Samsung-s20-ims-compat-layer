#!/usr/bin/env bash
# Local build environment for s20-imsservice-oss.
# This file is tracked; the SDK, dex-tools, apktool and signing keys it points at are not.
# See tools/README.md for the versions to install into this directory.

TOOLS_DIR=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
export SDK_HOME="$TOOLS_DIR/android-sdk"
export ANDROID_HOME="$SDK_HOME"
export BUILD_TOOLS_VERSION=33.0.3
export ANDROID_JAR="$SDK_HOME/platforms/android-33/android.jar"
export D8="$SDK_HOME/build-tools/$BUILD_TOOLS_VERSION/d8"
export DEX_TOOLS_LIB="$TOOLS_DIR/dex-tools-v2.4/lib"
export APKTOOL_JAR_PATH="$TOOLS_DIR/apktool.jar"
export PATH="$TOOLS_DIR/bin:$SDK_HOME/build-tools/$BUILD_TOOLS_VERSION:$PATH"

# NDK r26d remains in WSL because copying its 2.1 GB tree into this repository is unnecessary.
export NDK=${NDK:-$HOME/ndk-cache/android-ndk-r26d}

printf '%s\n' \
    "S20 IMS build environment loaded:" \
    "  SDK_HOME=$SDK_HOME" \
    "  ANDROID_JAR=$ANDROID_JAR" \
    "  DEX_TOOLS_LIB=$DEX_TOOLS_LIB" \
    "  APKTOOL_JAR_PATH=$APKTOOL_JAR_PATH" \
    "  NDK=$NDK"
