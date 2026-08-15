#!/usr/bin/env bash
# Build and structurally verify the S20 static IMS package-selection overlay.
set -euo pipefail

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SOURCE_DIR="$REPO/rro"
MANIFEST="$SOURCE_DIR/AndroidManifest.xml"
CONFIG="$SOURCE_DIR/res/values/config.xml"
BUILD_TOOLS=${RRO_BUILD_TOOLS:-${SDK_HOME:+$SDK_HOME/build-tools/33.0.3}}
BUILD_TOOLS=${BUILD_TOOLS:-$REPO/tools/android-sdk/build-tools/33.0.3}
AAPT2=${AAPT2:-$BUILD_TOOLS/aapt2}
AAPT=${AAPT:-$BUILD_TOOLS/aapt}
ZIPALIGN=${ZIPALIGN:-$BUILD_TOOLS/zipalign}
APKSIGNER=${APKSIGNER:-$BUILD_TOOLS/apksigner}
EXPECTED_PACKAGE=com.s20volte.imsoverlay
EXPECTED_TARGET=com.android.phone
EXPECTED_PRIORITY=9999
EXPECTED_PRIORITY_HEX=0000270f
EXPECTED_IMS_PACKAGE=com.sec.imsservice
EXPECTED_NAME=S20VoLTEImsOverlay.apk

usage() {
    cat >&2 <<EOF
Usage: $0 --framework-res <framework-res.apk> --key <key.pk8> --cert <cert.x509.pem> \\
          --output <path/$EXPECTED_NAME> [--force]

Builds, aligns, signs, and verifies the static S20 IMS RRO. The supplied framework-res.apk
and signing identity must be accepted by the target ROM's resource and overlay policy.

Local tool overrides:
  AAPT2, AAPT, ZIPALIGN, APKSIGNER, RRO_BUILD_TOOLS
EOF
    exit 2
}

FRAMEWORK_RES=
KEY=
CERT=
OUTPUT=
FORCE=0
while [ "$#" -gt 0 ]; do
    case "$1" in
        --framework-res) FRAMEWORK_RES=${2:-}; shift 2 ;;
        --key) KEY=${2:-}; shift 2 ;;
        --cert) CERT=${2:-}; shift 2 ;;
        --output) OUTPUT=${2:-}; shift 2 ;;
        --force) FORCE=1; shift ;;
        -h|--help) usage ;;
        *) usage ;;
    esac
done

[ -n "$FRAMEWORK_RES" ] && [ -n "$KEY" ] && [ -n "$CERT" ] && [ -n "$OUTPUT" ] || usage
[ -f "$FRAMEWORK_RES" ] || { echo "ERROR: framework-res.apk not found: $FRAMEWORK_RES" >&2; exit 2; }
[ -f "$KEY" ] || { echo "ERROR: signing key not found: $KEY" >&2; exit 2; }
[ -f "$CERT" ] || { echo "ERROR: signing certificate not found: $CERT" >&2; exit 2; }
[ -f "$MANIFEST" ] || { echo "ERROR: missing overlay manifest: $MANIFEST" >&2; exit 2; }
[ -f "$CONFIG" ] || { echo "ERROR: missing overlay resources: $CONFIG" >&2; exit 2; }
for tool in "$AAPT2" "$AAPT" "$ZIPALIGN" "$APKSIGNER"; do
    [ -x "$tool" ] || { echo "ERROR: required build tool is not executable: $tool" >&2; exit 2; }
done

case "$(basename -- "$OUTPUT")" in
    "$EXPECTED_NAME") ;;
    *) echo "ERROR: output filename must be $EXPECTED_NAME" >&2; exit 2 ;;
esac
case "$OUTPUT" in
    *.idsig) echo "ERROR: output must be an APK, not an .idsig sidecar" >&2; exit 2 ;;
esac
OUTPUT_DIR=$(dirname -- "$OUTPUT")
mkdir -p -- "$OUTPUT_DIR"
OUTPUT_DIR=$(CDPATH= cd -- "$OUTPUT_DIR" && pwd -P)
OUTPUT="$OUTPUT_DIR/$(basename -- "$OUTPUT")"
if [ -e "$OUTPUT" ] && [ "$FORCE" -ne 1 ]; then
    echo "ERROR: refusing to overwrite existing output: $OUTPUT" >&2
    echo "       Pass --force only when intentionally replacing a verified artifact." >&2
    exit 2
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
COMPILED="$TMP/compiled"
UNSIGNED="$TMP/unsigned.apk"
ALIGNED="$TMP/aligned.apk"
BADGING="$TMP/badging.txt"
MANIFEST_DUMP="$TMP/manifest.xmltree"
RESOURCES="$TMP/resources.txt"
FRAMEWORK_RESOURCES="$TMP/framework-resources.txt"
mkdir -p "$COMPILED"

"$AAPT2" dump resources "$FRAMEWORK_RES" > "$FRAMEWORK_RESOURCES"
for resource in config_ims_mmtel_package config_ims_rcs_package; do
    grep -Fq "$resource" "$FRAMEWORK_RESOURCES" || {
        echo "ERROR: framework resources do not declare required target resource: $resource" >&2
        exit 3
    }
done

echo "==> Compiling overlay resources"
"$AAPT2" compile "$CONFIG" -o "$COMPILED"

echo "==> Linking static RRO against supplied framework resources"
"$AAPT2" link \
    -I "$FRAMEWORK_RES" \
    --manifest "$MANIFEST" \
    --min-sdk-version 30 \
    --target-sdk-version 33 \
    -o "$UNSIGNED" \
    "$COMPILED"/*.flat

echo "==> Aligning and signing overlay"
"$ZIPALIGN" -p -f 4 "$UNSIGNED" "$ALIGNED"
"$APKSIGNER" sign \
    --key "$KEY" \
    --cert "$CERT" \
    --v1-signing-enabled true \
    --v2-signing-enabled true \
    --out "$OUTPUT" \
    "$ALIGNED"
rm -f "$OUTPUT.idsig"

echo "==> Verifying APK structure, resources, alignment, and signature"
"$ZIPALIGN" -c -v 4 "$OUTPUT" >/dev/null
"$APKSIGNER" verify --verbose --print-certs "$OUTPUT"
"$AAPT" dump badging "$OUTPUT" > "$BADGING"
"$AAPT" dump xmltree "$OUTPUT" AndroidManifest.xml > "$MANIFEST_DUMP"
"$AAPT2" dump resources "$OUTPUT" > "$RESOURCES"

grep -Fq "package: name='$EXPECTED_PACKAGE'" "$BADGING" || {
    echo "ERROR: unexpected overlay package name" >&2
    exit 3
}
grep -Eq "sdkVersion:'30'|sdkVersion:'30'" "$BADGING" || {
    echo "ERROR: expected min SDK 30 in overlay badging" >&2
    exit 3
}
grep -Eq "targetSdkVersion:'33'" "$BADGING" || {
    echo "ERROR: expected target SDK 33 in overlay badging" >&2
    exit 3
}
grep -Fq "$EXPECTED_TARGET" "$MANIFEST_DUMP" || {
    echo "ERROR: manifest does not target $EXPECTED_TARGET" >&2
    exit 3
}
grep -Eq 'isStatic.*true' "$MANIFEST_DUMP" || {
    echo "ERROR: manifest does not declare a static overlay" >&2
    exit 3
}
grep -Eq "priority.*($EXPECTED_PRIORITY|$EXPECTED_PRIORITY_HEX)" "$MANIFEST_DUMP" || {
    echo "ERROR: manifest does not declare priority $EXPECTED_PRIORITY" >&2
    exit 3
}
for resource in config_ims_mmtel_package config_ims_rcs_package; do
    grep -Fq "$resource" "$RESOURCES" || {
        echo "ERROR: output resources omit $resource" >&2
        exit 3
    }
done
grep -Fq "$EXPECTED_IMS_PACKAGE" "$RESOURCES" || {
    echo "ERROR: output resources omit value $EXPECTED_IMS_PACKAGE" >&2
    exit 3
}
if jar tf "$OUTPUT" | grep -Eq '(^|/)classes[0-9]*\.dex$'; then
    echo "ERROR: static RRO unexpectedly contains DEX code" >&2
    exit 3
fi

echo "OK static IMS RRO"
echo "  output:  $OUTPUT"
echo "  SHA-256: $(sha256sum "$OUTPUT" | cut -d ' ' -f 1)"
echo "  package: $EXPECTED_PACKAGE"
echo "  target:  $EXPECTED_TARGET (static priority $EXPECTED_PRIORITY)"
echo "  values:  config_ims_mmtel_package/config_ims_rcs_package -> $EXPECTED_IMS_PACKAGE"
