#!/usr/bin/env bash
# Build classes4.dex from the maintained VSIM compatibility smali source.
set -euo pipefail

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
APKTOOL_JAR_PATH=${APKTOOL_JAR_PATH:-$REPO/tools/apktool.jar}
OUT=${1:-$REPO/build-inputs/classes4.dex}

[ -f "$APKTOOL_JAR_PATH" ] || { echo "ERROR: apktool.jar not found: $APKTOOL_JAR_PATH" >&2; exit 2; }
mkdir -p "$(dirname -- "$OUT")"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

java -jar "$APKTOOL_JAR_PATH" b "$REPO/vsim_stub" -o "$TMP/vsim.apk"
unzip -p "$TMP/vsim.apk" classes.dex > "$OUT"

# shellcheck source=../artifacts.env
. "$REPO/build/artifacts.env"
class_count=$(java -jar "$APKTOOL_JAR_PATH" d -f -r "$TMP/vsim.apk" -o "$TMP/decoded" >/dev/null 2>&1 && find "$TMP/decoded/smali" -name '*.smali' | wc -l)
[ "$class_count" -eq "$CLASSES4_CLASS_COUNT" ] || { echo "ERROR: expected $CLASSES4_CLASS_COUNT VSIM classes, got $class_count" >&2; exit 3; }
actual=$(sha256sum "$OUT" | cut -d' ' -f1)
[ "$actual" = "$CLASSES4_SHA256" ] || {
    echo "ERROR: classes4.dex hash mismatch" >&2
    echo "  actual:   $actual" >&2
    echo "  expected: $CLASSES4_SHA256" >&2
    echo "Use the documented apktool version; do not substitute this output silently." >&2
    exit 3
}

echo "OK classes4.dex: $OUT"
echo "  SHA-256: $actual"
echo "  Classes:  $class_count"
