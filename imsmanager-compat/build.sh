#!/usr/bin/env bash
# Add the five-class GSI compatibility payload as classes2.dex to stock imsmanager.jar.
set -euo pipefail

COMPAT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO=$(CDPATH= cd -- "$COMPAT/.." && pwd)
# shellcheck source=expected.env
. "$COMPAT/expected.env"
APKTOOL_JAR_PATH=${APKTOOL_JAR_PATH:-$REPO/tools/apktool.jar}

usage() {
    echo "Usage: $0 --input <stock-imsmanager.jar> --output <derived-imsmanager.jar>" >&2
    exit 2
}

INPUT=
OUTPUT=
while [ "$#" -gt 0 ]; do
    case "$1" in
        --input) INPUT=${2:-}; shift 2 ;;
        --output) OUTPUT=${2:-}; shift 2 ;;
        -h|--help) usage ;;
        *) usage ;;
    esac
done
[ -n "$INPUT" ] && [ -n "$OUTPUT" ] || usage
[ -f "$INPUT" ] || { echo "ERROR: stock imsmanager.jar not found: $INPUT" >&2; exit 2; }
[ -f "$APKTOOL_JAR_PATH" ] || { echo "ERROR: apktool.jar not found: $APKTOOL_JAR_PATH" >&2; exit 2; }

input_hash=$(sha256sum "$INPUT" | cut -d' ' -f1)
[ "$input_hash" = "$STOCK_IMSMANAGER_JAR_SHA256" ] || {
    echo "ERROR: unsupported stock imsmanager.jar" >&2
    echo "  actual:   $input_hash" >&2
    echo "  expected: $STOCK_IMSMANAGER_JAR_SHA256" >&2
    echo "Extract system/framework/imsmanager.jar from G981NKSU1HVJG." >&2
    exit 3
}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
java -jar "$APKTOOL_JAR_PATH" b "$COMPAT/stub-apk" -o "$TMP/stub.apk" >/dev/null
unzip -p "$TMP/stub.apk" classes.dex > "$TMP/classes2.dex"
stub_hash=$(sha256sum "$TMP/classes2.dex" | cut -d' ' -f1)
[ "$stub_hash" = "$STUB_CLASSES2_DEX_SHA256" ] || {
    echo "ERROR: generated stub classes2.dex differs from the pinned compatibility payload" >&2
    echo "  actual:   $stub_hash" >&2
    echo "  expected: $STUB_CLASSES2_DEX_SHA256" >&2
    echo "Use the documented apktool version; do not silently substitute a different DEX." >&2
    exit 3
}

OUTPUT_DIR=$(dirname -- "$OUTPUT")
mkdir -p -- "$OUTPUT_DIR"
OUTPUT=$(CDPATH= cd -- "$OUTPUT_DIR" && pwd -P)/$(basename -- "$OUTPUT")
[ ! -e "$OUTPUT" ] || { echo "ERROR: output already exists: $OUTPUT" >&2; exit 2; }
cp "$INPUT" "$OUTPUT"
( cd "$TMP" && jar uf "$OUTPUT" classes2.dex )
"$COMPAT/verify.sh" "$OUTPUT"
