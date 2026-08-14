#!/usr/bin/env bash
# Validate a staged APK structurally. This checks semantic layout, not ZIP byte identity.
set -euo pipefail

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
# shellcheck source=artifacts.env
. "$REPO/build/artifacts.env"
APKTOOL_JAR_PATH=${APKTOOL_JAR_PATH:-$REPO/tools/apktool.jar}

usage() {
    echo "Usage: $0 <desem5|final> <imsservice.apk>" >&2
    exit 2
}

[ "$#" -eq 2 ] || usage
STAGE=$1
APK=$2
case "$STAGE" in desem5|final) ;; *) usage ;; esac
[ -f "$APK" ] || { echo "ERROR: APK not found: $APK" >&2; exit 2; }
[ -f "$APKTOOL_JAR_PATH" ] || { echo "ERROR: apktool.jar not found: $APKTOOL_JAR_PATH" >&2; exit 2; }

mapfile -t dex_entries < <(unzip -Z1 "$APK" | grep -E '^classes([0-9]+)?\.dex$' || true)
expected=(classes.dex classes2.dex classes3.dex classes4.dex)
if [ "${dex_entries[*]}" != "${expected[*]}" ]; then
    echo "ERROR: expected four DEX entries: ${expected[*]}" >&2
    echo "       actual: ${dex_entries[*]:-none}" >&2
    exit 3
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
for dex in classes2.dex classes3.dex classes4.dex; do
    unzip -p "$APK" "$dex" > "$TMP/$dex"
done
for item in "classes2:$CLASSES2_SHA256" "classes3:$CLASSES3_SHA256" "classes4:$CLASSES4_SHA256"; do
    name=${item%%:*}
    expected_hash=${item#*:}
    actual_hash=$(sha256sum "$TMP/$name.dex" | cut -d' ' -f1)
    [ "$actual_hash" = "$expected_hash" ] || {
        echo "ERROR: $name.dex hash mismatch: $actual_hash" >&2
        exit 3
    }
done

java -jar "$APKTOOL_JAR_PATH" d -f -r "$APK" -o "$TMP/decoded" >/dev/null
primary=$(find "$TMP/decoded/smali" -name '*.smali' | wc -l)
secondary2=$(find "$TMP/decoded/smali_classes2" -name '*.smali' | wc -l)
secondary3=$(find "$TMP/decoded/smali_classes3" -name '*.smali' | wc -l)
secondary4=$(find "$TMP/decoded/smali_classes4" -name '*.smali' | wc -l)
[ "$secondary2" -eq "$CLASSES2_CLASS_COUNT" ] || { echo "ERROR: classes2 has $secondary2 classes" >&2; exit 3; }
[ "$secondary3" -eq "$CLASSES3_CLASS_COUNT" ] || { echo "ERROR: classes3 has $secondary3 classes" >&2; exit 3; }
[ "$secondary4" -eq "$CLASSES4_CLASS_COUNT" ] || { echo "ERROR: classes4 has $secondary4 classes" >&2; exit 3; }

if [ "$STAGE" = desem5 ]; then
    [ "$primary" -eq "$DESEM5_PRIMARY_CLASS_COUNT" ] || { echo "ERROR: desem5 primary class count is $primary" >&2; exit 3; }
    total=$((primary + secondary2 + secondary3 + secondary4))
    [ "$total" -eq "$DESEM5_TOTAL_CLASS_COUNT" ] || { echo "ERROR: desem5 total class count is $total" >&2; exit 3; }
else
    for class in GoogleModernImsService GoogleModernMmTelFeature GoogleModernRegistration ModernImsCallSession; do
        test -f "$TMP/decoded/smali/com/sec/internal/google/$class.smali" || {
            echo "ERROR: final APK is missing $class" >&2; exit 3;
        }
    done
    if grep -Rqs 'Lcom/android/internal/telephony/ISemTelephony;' "$TMP/decoded/smali"; then
        echo "ERROR: final primary DEX still references ISemTelephony" >&2
        exit 3
    fi
    AAPT=${AAPT:-${SDK_HOME:-$REPO/tools/android-sdk}/build-tools/33.0.3/aapt}
    [ -x "$AAPT" ] || { echo "ERROR: aapt not found: $AAPT" >&2; exit 2; }
    "$AAPT" dump xmltree "$APK" AndroidManifest.xml > "$TMP/manifest.xmltree"
    grep -q 'GoogleModernImsService' "$TMP/manifest.xmltree" || {
        echo "ERROR: final manifest does not declare GoogleModernImsService" >&2; exit 3;
    }
    grep -q 'android.telephony.ims.ImsService' "$TMP/manifest.xmltree" || {
        echo "ERROR: final manifest lacks modern ImsService action" >&2; exit 3;
    }
    while IFS= read -r -d '' bridge; do
        relative=${bridge#"$REPO/smali_out/"}
        test -f "$TMP/decoded/smali/$relative" || {
            echo "ERROR: final APK is missing Java-generated bridge class: $relative" >&2
            exit 3
        }
    done < <(find "$REPO/smali_out" -type f -name '*.smali' -print0)
fi

echo "OK $STAGE APK"
echo "  primary classes: $primary"
echo "  secondary:       $secondary2 / $secondary3 / $secondary4"
