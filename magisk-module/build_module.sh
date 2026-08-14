#!/usr/bin/env bash
# Create a self-validating Magisk module ZIP from the declared 61-file payload.
set -euo pipefail

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SCAFFOLD="$REPO/magisk-module"
PAYLOAD="$REPO/proprietary_vendor_samsung_ims/proprietary/system"
MANIFEST="$SCAFFOLD/payload-manifest.tsv"
APK_PATH="priv-app/imsservice/imsservice.apk"

usage() {
    cat >&2 <<EOF
Usage: $0 [--apk <verified-imsservice.apk>] [--imsmanager <derived-imsmanager.jar>] [--stock-root <system-root>] <output-module.zip>

Without --apk, packages the committed known-device baseline APK. --apk accepts only
an APK that passes build/verify_apk.sh final. --imsmanager accepts only a JAR that
passes imsmanager-compat/verify.sh. --stock-root runs the read-only payload
comparison before staging.
EOF
    exit 2
}

APK=
IMSMANAGER=
STOCK_ROOT=
while [ "$#" -gt 0 ]; do
    case "$1" in
        --apk) APK=${2:-}; shift 2 ;;
        --imsmanager) IMSMANAGER=${2:-}; shift 2 ;;
        --stock-root) STOCK_ROOT=${2:-}; shift 2 ;;
        -h|--help) usage ;;
        --*) usage ;;
        *) break ;;
    esac
done
[ "$#" -eq 1 ] || usage
OUT=$1

[ -f "$MANIFEST" ] || { echo "ERROR: payload manifest not found: $MANIFEST" >&2; exit 2; }
[ -d "$PAYLOAD" ] || { echo "ERROR: proprietary payload tree not found: $PAYLOAD" >&2; exit 2; }
[ -f "$SCAFFOLD/module.prop" ] || { echo "ERROR: module scaffold is incomplete" >&2; exit 2; }

if [ -n "$STOCK_ROOT" ]; then
    "$SCAFFOLD/verify_payload.sh" "$STOCK_ROOT"
fi

if [ -z "$APK" ]; then
    APK="$PAYLOAD/$APK_PATH"
fi
[ -f "$APK" ] || { echo "ERROR: APK not found: $APK" >&2; exit 2; }
case "$APK" in *.idsig) echo "ERROR: .idsig is not an APK module payload" >&2; exit 2 ;; esac
"$REPO/build/verify_apk.sh" final "$APK"
if [ -n "$IMSMANAGER" ]; then
    [ -f "$IMSMANAGER" ] || { echo "ERROR: imsmanager compatibility JAR not found: $IMSMANAGER" >&2; exit 2; }
    "$REPO/imsmanager-compat/verify.sh" "$IMSMANAGER"
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
ROOT="$TMP/module"
mkdir -p "$ROOT"

# Copy only the install-time module scaffold. Packaging helpers and manifests remain host-side.
for item in module.prop customize.sh post-fs-data.sh service.sh sepolicy.rule META-INF; do
    [ -e "$SCAFFOLD/$item" ] || { echo "ERROR: scaffold item missing: $item" >&2; exit 2; }
    cp -a "$SCAFFOLD/$item" "$ROOT/"
done

payload_count=0
while IFS=$'\t' read -r path category expected; do
    case "$path" in ''|'#'*|'!'*) continue ;; esac
    source="$PAYLOAD/$path"
    [ -f "$source" ] || { echo "ERROR: payload file missing: $path" >&2; exit 2; }
    actual=$(sha256sum "$source" | cut -d' ' -f1)
    [ "$actual" = "$expected" ] || { echo "ERROR: payload hash mismatch: $path" >&2; exit 3; }
    target="$ROOT/system/$path"
    mkdir -p "$(dirname -- "$target")"
    if [ "$path" = "$APK_PATH" ]; then
        cp -a "$APK" "$target"
    elif [ "$path" = "framework/imsmanager.jar" ] && [ -n "$IMSMANAGER" ]; then
        cp -a "$IMSMANAGER" "$target"
    else
        cp -a "$source" "$target"
    fi
    payload_count=$((payload_count + 1))
done < "$MANIFEST"
[ "$payload_count" -eq 61 ] || { echo "ERROR: expected 61 payload files, staged $payload_count" >&2; exit 3; }

# Validate staging before compression. The chosen APK is allowed to differ from its manifest hash,
# but it must remain a structurally verified final four-DEX artifact.
"$REPO/build/verify_apk.sh" final "$ROOT/system/$APK_PATH" >/dev/null
staged_count=$(find "$ROOT/system" -type f | wc -l)
[ "$staged_count" -eq "$payload_count" ] || { echo "ERROR: staged unexpected system file count: $staged_count" >&2; exit 3; }

mkdir -p "$(dirname -- "$OUT")"
OUT=$(CDPATH= cd -- "$(dirname -- "$OUT")" && pwd)/$(basename -- "$OUT")
rm -f "$OUT"
( cd "$ROOT" && jar cf "$OUT" . )

# Extract and validate the emitted ZIP rather than trusting the staging tree.
VERIFY="$TMP/verify"
mkdir -p "$VERIFY"
unzip -q "$OUT" -d "$VERIFY"
[ -f "$VERIFY/module.prop" ] || { echo "ERROR: ZIP missing module.prop" >&2; exit 3; }
[ -d "$VERIFY/META-INF" ] || { echo "ERROR: ZIP missing META-INF" >&2; exit 3; }
[ ! -e "$VERIFY/build_module.sh" ] && [ ! -e "$VERIFY/verify_payload.sh" ] && [ ! -e "$VERIFY/payload-manifest.tsv" ] || {
    echo "ERROR: ZIP contains host-only packaging helpers" >&2; exit 3;
}
zip_system_count=$(find "$VERIFY/system" -type f | wc -l)
[ "$zip_system_count" -eq 61 ] || { echo "ERROR: ZIP system payload count is $zip_system_count, expected 61" >&2; exit 3; }

while IFS=$'\t' read -r path category expected; do
    case "$path" in ''|'#'*|'!'*) continue ;; esac
    staged="$VERIFY/system/$path"
    [ -f "$staged" ] || { echo "ERROR: ZIP missing payload path: system/$path" >&2; exit 3; }
    if [ "$path" = "$APK_PATH" ]; then
        "$REPO/build/verify_apk.sh" final "$VERIFY/system/$path" >/dev/null
    elif [ "$path" = "framework/imsmanager.jar" ] && [ -n "$IMSMANAGER" ]; then
        "$REPO/imsmanager-compat/verify.sh" "$VERIFY/system/$path" >/dev/null
    else
        actual=$(sha256sum "$VERIFY/system/$path" | cut -d' ' -f1)
        [ "$actual" = "$expected" ] || { echo "ERROR: ZIP payload hash mismatch: $path" >&2; exit 3; }
    fi
done < "$MANIFEST"
"$REPO/build/verify_apk.sh" final "$VERIFY/system/$APK_PATH" >/dev/null

printf '%s\n' "OK Magisk module: $OUT" \
    "  payload files: $payload_count" \
    "  imsservice.apk: $(sha256sum "$APK" | cut -d' ' -f1)" \
    "  module SHA-256: $(sha256sum "$OUT" | cut -d' ' -f1)"
