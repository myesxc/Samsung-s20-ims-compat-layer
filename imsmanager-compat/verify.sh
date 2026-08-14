#!/usr/bin/env bash
# Verify a locally derived imsmanager.jar compatibility override.
set -euo pipefail

COMPAT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# shellcheck source=expected.env
. "$COMPAT/expected.env"

usage() {
    echo "Usage: $0 <derived-imsmanager.jar>" >&2
    exit 2
}

[ "$#" -eq 1 ] || usage
JAR=$1
[ -f "$JAR" ] || { echo "ERROR: imsmanager.jar not found: $JAR" >&2; exit 2; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mapfile -t entries < <(unzip -Z1 "$JAR" | grep -E '^classes([0-9]+)?\.dex$' || true)
[ "${entries[*]}" = "classes.dex classes2.dex" ] || {
    echo "ERROR: expected exactly classes.dex and classes2.dex; got: ${entries[*]:-none}" >&2
    exit 3
}
unzip -p "$JAR" classes.dex > "$TMP/classes.dex"
unzip -p "$JAR" classes2.dex > "$TMP/classes2.dex"
primary_hash=$(sha256sum "$TMP/classes.dex" | cut -d' ' -f1)
stub_hash=$(sha256sum "$TMP/classes2.dex" | cut -d' ' -f1)
[ "$primary_hash" = "$STOCK_PRIMARY_DEX_SHA256" ] || {
    echo "ERROR: classes.dex differs from the untouched supported stock primary DEX" >&2
    echo "  actual:   $primary_hash" >&2
    echo "  expected: $STOCK_PRIMARY_DEX_SHA256" >&2
    exit 3
}
[ "$stub_hash" = "$STUB_CLASSES2_DEX_SHA256" ] || {
    echo "ERROR: classes2.dex does not match the expected five-stub compatibility DEX" >&2
    echo "  actual:   $stub_hash" >&2
    echo "  expected: $STUB_CLASSES2_DEX_SHA256" >&2
    exit 3
}

REPO=$(CDPATH= cd -- "$COMPAT/.." && pwd)
DEX_TOOLS_LIB=${DEX_TOOLS_LIB:-$REPO/tools/dex-tools-v2.4/lib}
[ -d "$DEX_TOOLS_LIB" ] || { echo "ERROR: dex-tools lib not found: $DEX_TOOLS_LIB" >&2; exit 2; }
java -cp "$DEX_TOOLS_LIB/*" com.googlecode.d2j.smali.BaksmaliCmd -f -o "$TMP/smali" "$TMP/classes2.dex" >/dev/null
class_count=$(find "$TMP/smali" -name '*.smali' | wc -l)
[ "$class_count" -eq "$STUB_CLASS_COUNT" ] || { echo "ERROR: expected $STUB_CLASS_COUNT stubs, got $class_count" >&2; exit 3; }
for path in \
    android/os/SemSystemProperties.smali \
    com/samsung/android/emergencymode/SemEmergencyConstants.smali \
    com/samsung/android/feature/SemCscFeature.smali \
    com/samsung/android/feature/SemFloatingFeature.smali \
    com/samsung/android/wifi/SemWifiManager.smali; do
    [ -f "$TMP/smali/$path" ] || { echo "ERROR: missing compatibility stub: $path" >&2; exit 3; }
done

jar_hash=$(sha256sum "$JAR" | cut -d' ' -f1)
printf '%s\n' "OK imsmanager compatibility JAR: $JAR" \
    "  classes.dex:  $primary_hash" \
    "  classes2.dex: $stub_hash ($class_count stubs)" \
    "  jar SHA-256:  $jar_hash" \
    "  historical reference match: $([ "$jar_hash" = "$HISTORICAL_PATCHED_JAR_SHA256" ] && echo yes || echo no)"
