#!/usr/bin/env bash
# Build and verify classes3.dex from a locally supplied matching Samsung framework.jar.
set -euo pipefail

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
# shellcheck source=../artifacts.env
. "$REPO/build/artifacts.env"

usage() {
    echo "Usage: $0 <Samsung-framework.jar> [output/classes3.dex]" >&2
    exit 2
}

[ "$#" -ge 1 ] && [ "$#" -le 2 ] || usage
FWJAR=$1
OUT=${2:-$REPO/build-inputs/classes3.dex}
SDK_HOME=${SDK_HOME:-$REPO/tools/android-sdk}
D8=${D8:-$SDK_HOME/build-tools/33.0.3/d8}
ANDROID_JAR=${ANDROID_JAR:-$SDK_HOME/platforms/android-33/android.jar}

[ -f "$FWJAR" ] || { echo "ERROR: framework.jar not found: $FWJAR" >&2; exit 2; }
[ -x "$D8" ] || { echo "ERROR: d8 not found: $D8" >&2; exit 2; }
[ -f "$ANDROID_JAR" ] || { echo "ERROR: android.jar not found: $ANDROID_JAR" >&2; exit 2; }

framework_hash=$(sha256sum "$FWJAR" | cut -d' ' -f1)
if [ "$framework_hash" != "$FRAMEWORK_JAR_SHA256" ]; then
    cat >&2 <<EOF
ERROR: framework.jar does not match the historical S20 input
  actual:   $framework_hash
  expected: $FRAMEWORK_JAR_SHA256
Use the Samsung framework.jar extracted from the documented G981NKSU1HVJG firmware.
EOF
    exit 3
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
python3 - "$FWJAR" "$TMP/classes" <<'PY'
import sys, zipfile
jar, out = sys.argv[1:]
with zipfile.ZipFile(jar) as archive:
    names = [name for name in archive.namelist()
             if name.startswith('com/samsung/android/ims/') and name.endswith('.class')]
    for name in names:
        archive.extract(name, out)
print(len(names))
PY
class_count=$(find "$TMP/classes" -name '*.class' | wc -l)
[ "$class_count" -eq "$CLASSES3_CLASS_COUNT" ] || {
    echo "ERROR: expected $CLASSES3_CLASS_COUNT Samsung IMS classes, got $class_count" >&2
    exit 3
}
( cd "$TMP/classes" && jar cf "$TMP/ims-framework-api.jar" com )
mkdir -p "$TMP/dex" "$(dirname -- "$OUT")"
"$D8" --lib "$ANDROID_JAR" --min-api 33 --output "$TMP/dex" "$TMP/ims-framework-api.jar"
cp "$TMP/dex/classes.dex" "$OUT"

actual=$(sha256sum "$OUT" | cut -d' ' -f1)
[ "$actual" = "$CLASSES3_SHA256" ] || {
    echo "ERROR: classes3.dex hash mismatch" >&2
    echo "  actual:   $actual" >&2
    echo "  expected: $CLASSES3_SHA256" >&2
    echo "The original byte stream used dx; this D8 result may be semantically valid but is not an interchangeable historical payload." >&2
    exit 3
}

echo "OK classes3.dex: $OUT"
echo "  SHA-256: $actual"
echo "  Classes:  $class_count"
