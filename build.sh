#!/usr/bin/env bash
# Build the S20 IMS Service bridge — Java -> dex -> smali -> smali_out/
#
# REQUIREMENTS (see tools/README.md for exact versions and apt packages):
#   - JDK 17 (java + javac in PATH)
#   - Android SDK platform-33   (android.jar)
#   - Android build-tools 33.0.3 (d8)
#   - dex-tools v2.4             (baksmali)
#
# USAGE:
#   export JAVA_HOME=<path to JDK17>
#   export SDK_HOME=<path to Android SDK, e.g. ~/Android/Sdk>
#   export DEX_TOOLS_LIB=<path to dex-tools-v2.4/lib>
#   bash ./build.sh
#
# OUTPUT:
#   smali_out/   — compiled bridge smali, ready to copy into a decompiled APK's smali/
#
# This script only compiles the bridge classes. Patching and repacking the APK is a
# separate manual step (see "How to Apply the Patch" in README.md) because it needs the
# stock imsservice.apk, which cannot be redistributed here.
set -euo pipefail

if [ "${1:-}" = "release" ]; then
    shift
    REPO=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
    STOCK_APK=
    STOCK_SYSTEM=
    OUTPUT_DIR=
    SIGN=0

    release_usage() {
        cat >&2 <<EOF
Usage: $0 release --stock-apk <imsservice.apk> --stock-system <system-root> --output-dir <directory> --sign

Builds the final four-DEX imsservice.apk, derives the imsmanager.jar compatibility override,
and packages a validated Magisk module ZIP. --sign is required because a system-UID APK cannot
be deployed unsigned.
EOF
        exit 2
    }

    while [ "$#" -gt 0 ]; do
        case "$1" in
            --stock-apk) STOCK_APK=${2:-}; shift 2 ;;
            --stock-system) STOCK_SYSTEM=${2:-}; shift 2 ;;
            --output-dir) OUTPUT_DIR=${2:-}; shift 2 ;;
            --sign) SIGN=1; shift ;;
            -h|--help) release_usage ;;
            *) release_usage ;;
        esac
    done
    [ -n "$STOCK_APK" ] && [ -n "$STOCK_SYSTEM" ] && [ -n "$OUTPUT_DIR" ] && [ "$SIGN" -eq 1 ] || release_usage
    [ -f "$STOCK_APK" ] || { echo "ERROR: stock APK not found: $STOCK_APK" >&2; exit 2; }
    [ -f "$STOCK_SYSTEM/framework/imsmanager.jar" ] || {
        echo "ERROR: stock system root lacks framework/imsmanager.jar: $STOCK_SYSTEM" >&2
        exit 2
    }

    mkdir -p -- "$OUTPUT_DIR"
    OUTPUT_DIR=$(CDPATH= cd -- "$OUTPUT_DIR" && pwd -P)
    APK_OUT="$OUTPUT_DIR/imsservice.apk"
    JAR_OUT="$OUTPUT_DIR/imsmanager.jar"
    MODULE_OUT="$OUTPUT_DIR/S20_VoLTE_IMS.zip"
    for artifact in "$APK_OUT" "$JAR_OUT" "$MODULE_OUT"; do
        [ ! -e "$artifact" ] || { echo "ERROR: refusing to overwrite existing artifact: $artifact" >&2; exit 2; }
    done

    echo "==> Verifying stock inputs and committed module payload"
    "$REPO/build/verify_input.sh" "$STOCK_APK"
    "$REPO/magisk-module/verify_payload.sh" "$STOCK_SYSTEM"

    echo "==> Building and signing final four-DEX IMS APK"
    "$REPO/build/build_apk.sh" --stage final --sign "$STOCK_APK" "$APK_OUT"

    echo "==> Building imsmanager.jar compatibility override"
    "$REPO/imsmanager-compat/build.sh" --input "$STOCK_SYSTEM/framework/imsmanager.jar" --output "$JAR_OUT"

    echo "==> Packaging validated Magisk module"
    "$REPO/magisk-module/build_module.sh" --apk "$APK_OUT" --imsmanager "$JAR_OUT" \
        --stock-root "$STOCK_SYSTEM" "$MODULE_OUT"

    printf '%s\n' "Release build complete:" \
        "  APK:    $APK_OUT" \
        "  JAR:    $JAR_OUT" \
        "  Module: $MODULE_OUT" \
        "  APK SHA-256:    $(sha256sum "$APK_OUT" | cut -d' ' -f1)" \
        "  JAR SHA-256:    $(sha256sum "$JAR_OUT" | cut -d' ' -f1)" \
        "  Module SHA-256: $(sha256sum "$MODULE_OUT" | cut -d' ' -f1)"
    exit 0
fi

REPO=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

JAVA_HOME=${JAVA_HOME:-$(dirname "$(dirname "$(command -v javac)")")}
SDK_HOME=${SDK_HOME:-$REPO/tools/android-sdk}
BUILD_TOOLS_VERSION=${BUILD_TOOLS_VERSION:-33.0.3}
D8=${D8:-$SDK_HOME/build-tools/$BUILD_TOOLS_VERSION/d8}
ANDROID_JAR=${ANDROID_JAR:-$SDK_HOME/platforms/android-33/android.jar}

# dex-tools is downloaded by the user (see tools/README.md); tools/ ships no binaries.
DEX_TOOLS_LIB=${DEX_TOOLS_LIB:-$REPO/tools/dex-tools-v2.4/lib}

SRC_DIR="$REPO/java"
# Defaults to the tracked reviewed snapshot. build/build_apk.sh overrides this
# with a private temporary directory so Java sources are the APK injection authority.
SMALI_OUT=${SMALI_OUT:-$REPO/smali_out}

for cmd in javac java; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "ERROR: $cmd not found (set JAVA_HOME)" >&2; exit 2; }
done
[ -f "$ANDROID_JAR" ] || { echo "ERROR: android.jar not found: $ANDROID_JAR (sdkmanager 'platforms;android-33')" >&2; exit 2; }
[ -x "$D8" ]          || { echo "ERROR: d8 not found: $D8 (sdkmanager 'build-tools;$BUILD_TOOLS_VERSION')" >&2; exit 2; }
[ -d "$DEX_TOOLS_LIB" ] || {
    echo "ERROR: dex-tools lib not found: $DEX_TOOLS_LIB" >&2
    echo "       Download dex-tools v2.4 and either extract it to tools/dex-tools-v2.4/" >&2
    echo "       or set DEX_TOOLS_LIB to its lib/ directory. See tools/README.md." >&2
    exit 2
}

SRC_FILES=$(find "$SRC_DIR" -name '*.java' | tr '\n' ' ')
[ -n "$SRC_FILES" ] || { echo "ERROR: no .java files found in $SRC_DIR" >&2; exit 2; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# These APIs are hidden from the public SDK android.jar, but are present at runtime in
# system_server/telephony and in Samsung's imsservice.apk. Compile-only stubs provide their
# signatures to javac and d8; the generated stub classes are deliberately excluded from the
# output dex so they never replace the real platform/Samsung implementations on-device.
STUB_DIR="$TMP/stub"
mkdir -p "$STUB_DIR/android/os" \
         "$STUB_DIR/android/telephony/ims/aidl" \
         "$STUB_DIR/android/telephony/ims/stub" \
         "$STUB_DIR/com/sec/internal/google" \
         "$TMP/classes" "$TMP/program" "$TMP/dex" "$TMP/smali"

cat > "$STUB_DIR/android/os/SystemProperties.java" <<'JAVA'
package android.os;
public final class SystemProperties {
    public static boolean getBoolean(String key, boolean def) { return def; }
    public static int getInt(String key, int def) { return def; }
    public static String get(String key, String def) { return def; }
}
JAVA

cat > "$STUB_DIR/android/telephony/ims/aidl/IImsSmsListener.java" <<'JAVA'
package android.telephony.ims.aidl;
import android.os.Binder;
import android.os.IInterface;
public interface IImsSmsListener extends IInterface {
    void onSendSmsResult(int token, int messageRef, int status, int reason, int networkErrorCode);
    void onSmsStatusReportReceived(int token, String format, byte[] pdu);
    void onSmsReceived(int token, String format, byte[] pdu);
    void onMemoryAvailableResult(int token, int status, int networkErrorCode);
    abstract class Stub extends Binder implements IImsSmsListener {
        public android.os.IBinder asBinder() { return this; }
    }
}
JAVA

cat > "$STUB_DIR/android/telephony/ims/stub/ImsSmsImplBase.java" <<'JAVA'
package android.telephony.ims.stub;
public class ImsSmsImplBase {
    public static final int SEND_STATUS_OK = 1;
    public static final int SEND_STATUS_ERROR = 2;
    public static final int SEND_STATUS_ERROR_RETRY = 3;
    public static final int RESULT_NO_NETWORK_ERROR = -1;
    public void onReady() {}
    public String getSmsFormat() { return "3gpp"; }
    public void sendSms(int token, int messageRef, String format, String smsc,
                        boolean retry, byte[] pdu) {}
    public void acknowledgeSms(int token, int messageRef, int result) {}
    public void acknowledgeSmsReport(int token, int messageRef, int result) {}
    public void onMemoryAvailable(int token) {}
    protected final void onSendSmsResultSuccess(int token, int messageRef) {}
    protected final void onSendSmsResultError(int token, int messageRef, int status,
                                               int reason, int networkError) {}
    protected final void onSmsStatusReportReceived(int token, String format, byte[] pdu) {}
    protected final void onSmsReceived(int token, String format, byte[] pdu) {}
    protected final void onMemoryAvailableResult(int token, int status, int networkError) {}
}
JAVA

cat > "$STUB_DIR/com/sec/internal/google/ImsSmsImpl.java" <<'JAVA'
package com.sec.internal.google;
import android.content.Context;
import android.telephony.ims.aidl.IImsSmsListener;
public final class ImsSmsImpl {
    public ImsSmsImpl(Context context, int phoneId, IImsSmsListener listener) {}
    public String getSmsFormat(int phoneId) { return "3gpp"; }
    public void setRetryCount(int phoneId, int token, int count) {}
    public void sendSms(int phoneId, int token, int messageRef, String format,
                        String smsc, byte[] pdu) {}
    public void acknowledgeSms(int phoneId, int token, int messageRef, int result) {}
    public void acknowledgeSmsReport(int phoneId, int token, int messageRef, int result) {}
    public void sendRpSmma(int phoneId, String format) {}
}
JAVA

echo "==> Compiling Java sources (source/target 8)"
# shellcheck disable=SC2086
"$JAVA_HOME/bin/javac" -source 8 -target 8 -nowarn \
    -cp "$REPO/libs/*:$ANDROID_JAR" \
    -d "$TMP/classes" $(find "$STUB_DIR" -name '*.java' -print) $SRC_FILES

# ModernImsSms depends on the compile-only Samsung stub above. Keep its program classes
# separately, then remove every stub before invoking d8.
cp "$TMP"/classes/com/sec/internal/google/ModernImsSms*.class "$TMP/program/"
rm -rf "$TMP/classes/android"
rm -f "$TMP/classes/com/sec/internal/google/ImsSmsImpl.class" \
      "$TMP/classes/com/sec/internal/google/ModernImsSms"*.class

echo "==> Dexing with d8 (min-api 33)"
"$D8" --lib "$ANDROID_JAR" --classpath "$TMP/classes" --min-api 33 \
    --output "$TMP/dex" \
    $(find "$TMP/classes/com/sec/internal/google" -name 'Ap*.class' -print) \
    "$TMP"/program/ModernImsSms*.class

echo "==> Baksmali (dex -> smali)"
java -cp "$DEX_TOOLS_LIB/*" com.googlecode.d2j.smali.BaksmaliCmd \
    -f -o "$TMP/smali" "$TMP/dex/classes.dex"

# dex-tools emits `.parameter` directives when Java debug metadata is present; apktool's
# smali assembler rejects that spelling. javac intentionally runs without `-g` above, and
# this guard prevents a future flag change from producing an unrebuildable smali_out/.
if grep -Rqs '^[[:space:]]*\.parameter' "$TMP/smali"; then
    echo "ERROR: generated smali contains unsupported .parameter directives" >&2
    echo "       Keep javac debug metadata disabled, or use an assembler-compatible baksmali." >&2
    exit 3
fi

# Guard against accidentally shipping any compile-only stub in smali_out.
for stub in \
    android/os/SystemProperties.smali \
    android/telephony/ims/aidl/IImsSmsListener.smali \
    android/telephony/ims/stub/ImsSmsImplBase.smali \
    com/sec/internal/google/ImsSmsImpl.smali; do
    [ ! -e "$TMP/smali/$stub" ] || {
        echo "ERROR: compile-only stub leaked into generated smali: $stub" >&2
        exit 3
    }
done

echo "==> Updating $SMALI_OUT"
rm -rf "$SMALI_OUT"
cp -r "$TMP/smali" "$SMALI_OUT"

CLASS_COUNT=$(find "$SMALI_OUT" -name '*.smali' | wc -l)
echo
echo "Done. $CLASS_COUNT smali classes written to $SMALI_OUT"
echo
echo "Next: assemble the supported four-DEX APK (see README.md)"
echo "  1. Place verified local classes2.dex, classes3.dex and classes4.dex in build-inputs/"
echo "  2. bash build/build_apk.sh --sign <stock-imsservice.apk> <output.apk>"
echo "  3. bash build/verify_apk.sh final <output.apk>"
echo
echo "To rebuild the ims_sock_launch helper (needs NDK r26d):  bash c/build_ims_sock_launch.sh"
