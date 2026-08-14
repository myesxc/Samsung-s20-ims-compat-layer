#!/usr/bin/env bash
# Compare the module payload to a read-only extracted G981NKSU1HVJG system tree.
set -euo pipefail

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PAYLOAD="$REPO/proprietary_vendor_samsung_ims/proprietary/system"
MANIFEST="$REPO/magisk-module/payload-manifest.tsv"
# shellcheck source=../build/artifacts.env
. "$REPO/build/artifacts.env"

usage() {
    echo "Usage: $0 <mounted-or-extracted-system-root>" >&2
    exit 2
}

[ "$#" -eq 1 ] || usage
STOCK=$1
[ -d "$STOCK" ] || { echo "ERROR: stock system root not found: $STOCK" >&2; exit 2; }
[ -f "$STOCK/priv-app/imsservice/imsservice.apk" ] || {
    echo "ERROR: expected priv-app/imsservice/imsservice.apk under: $STOCK" >&2
    exit 2
}

stock_apk_hash=$(sha256sum "$STOCK/priv-app/imsservice/imsservice.apk" | cut -d' ' -f1)
[ "$stock_apk_hash" = "$STOCK_APK_SHA256" ] || {
    echo "ERROR: stock system root does not contain the supported G981NKSU1HVJG imsservice.apk" >&2
    echo "  actual:   $stock_apk_hash" >&2
    echo "  expected: $STOCK_APK_SHA256" >&2
    exit 3
}

stock_matches=0
project_added=0
compatibility_overrides=0
patched_apks=0
errors=0
while IFS=$'\t' read -r path category expected; do
    case "$path" in ''|'#'*|'!'*) continue ;; esac
    [ -f "$PAYLOAD/$path" ] || { echo "ERROR: payload file missing: $path" >&2; errors=$((errors + 1)); continue; }
    actual=$(sha256sum "$PAYLOAD/$path" | cut -d' ' -f1)
    [ "$actual" = "$expected" ] || { echo "ERROR: payload hash differs from manifest: $path" >&2; errors=$((errors + 1)); continue; }
    case "$category" in
        stock-identical)
            [ -f "$STOCK/$path" ] || { echo "ERROR: stock file missing: $path" >&2; errors=$((errors + 1)); continue; }
            stock_hash=$(sha256sum "$STOCK/$path" | cut -d' ' -f1)
            [ "$actual" = "$stock_hash" ] || { echo "ERROR: expected stock-identical file differs: $path" >&2; errors=$((errors + 1)); continue; }
            stock_matches=$((stock_matches + 1))
            ;;
        project-added)
            [ ! -e "$STOCK/$path" ] || { echo "ERROR: project-added path unexpectedly exists in stock: $path" >&2; errors=$((errors + 1)); continue; }
            project_added=$((project_added + 1))
            ;;
        compatibility-override)
            [ -f "$STOCK/$path" ] || { echo "ERROR: stock compatibility path missing: $path" >&2; errors=$((errors + 1)); continue; }
            stock_hash=$(sha256sum "$STOCK/$path" | cut -d' ' -f1)
            [ "$actual" != "$stock_hash" ] || { echo "ERROR: compatibility override unexpectedly equals stock: $path" >&2; errors=$((errors + 1)); continue; }
            compatibility_overrides=$((compatibility_overrides + 1))
            ;;
        patched-apk)
            [ "$path" = "priv-app/imsservice/imsservice.apk" ] || { echo "ERROR: unexpected patched APK path: $path" >&2; errors=$((errors + 1)); continue; }
            "$REPO/build/verify_apk.sh" final "$PAYLOAD/$path" >/dev/null
            patched_apks=$((patched_apks + 1))
            ;;
        *) echo "ERROR: unknown payload category for $path: $category" >&2; errors=$((errors + 1)); ;;
    esac
done < "$MANIFEST"

omitted=0
while IFS=$'\t' read -r path expected; do
    case "$path" in '!'*) path=${path#!} ;; *) continue ;; esac
    [ -f "$STOCK/$path" ] || { echo "ERROR: declared omitted stock certificate absent: $path" >&2; errors=$((errors + 1)); continue; }
    actual=$(sha256sum "$STOCK/$path" | cut -d' ' -f1)
    [ "$actual" = "$expected" ] || { echo "ERROR: omitted certificate hash mismatch: $path" >&2; errors=$((errors + 1)); continue; }
    [ ! -e "$PAYLOAD/$path" ] || { echo "ERROR: declared omitted certificate is present in payload: $path" >&2; errors=$((errors + 1)); continue; }
    omitted=$((omitted + 1))
done < "$MANIFEST"

[ "$errors" -eq 0 ] || exit 3
printf '%s\n' "OK module payload against supported stock system" \
    "  stock-identical:       $stock_matches" \
    "  project additions:     $project_added" \
    "  compatibility overrides: $compatibility_overrides" \
    "  patched APKs:          $patched_apks" \
    "  intentional omissions: $omitted"
