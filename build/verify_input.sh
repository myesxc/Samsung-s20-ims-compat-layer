#!/usr/bin/env bash
# Verify that an extracted stock APK is the supported G981NKSU1HVJG input.
set -euo pipefail

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
# shellcheck source=artifacts.env
. "$REPO/build/artifacts.env"

usage() {
    echo "Usage: $0 <stock-imsservice.apk>" >&2
    exit 2
}

[ "$#" -eq 1 ] || usage
APK=$1
[ -f "$APK" ] || { echo "ERROR: stock APK not found: $APK" >&2; exit 2; }

actual=$(sha256sum "$APK" | cut -d' ' -f1)
if [ "$actual" != "$STOCK_APK_SHA256" ]; then
    cat >&2 <<EOF
ERROR: unsupported stock imsservice.apk
  actual:   $actual
  expected: $STOCK_APK_SHA256
Extract imsservice.apk from Samsung firmware G981NKSU1HVJG for SM-G981N.
Do not use the A21s-derived APK or an already patched APK as build input.
EOF
    exit 3
fi

mapfile -t dex_entries < <(unzip -Z1 "$APK" | grep -E '^classes([0-9]+)?\.dex$' || true)
if [ "${#dex_entries[@]}" -ne "$STOCK_DEX_COUNT" ] || [ "${dex_entries[0]:-}" != "classes.dex" ]; then
    echo "ERROR: expected exactly one stock classes.dex, found ${#dex_entries[@]}: ${dex_entries[*]:-none}" >&2
    exit 3
fi

echo "OK supported stock APK"
echo "  SHA-256: $actual"
echo "  DEX:      ${dex_entries[*]}"
