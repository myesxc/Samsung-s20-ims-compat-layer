#!/usr/bin/env bash
# Assemble the supported S20 APK as a four-DEX package.
# It never modifies the input APK or an existing decoded directory.
set -euo pipefail

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
APKTOOL_JAR_PATH=${APKTOOL_JAR_PATH:-$REPO/tools/apktool.jar}
ZIPALIGN=${ZIPALIGN:-${SDK_HOME:-$REPO/tools/android-sdk}/build-tools/33.0.3/zipalign}
APKSIGNER=${APKSIGNER:-${SDK_HOME:-$REPO/tools/android-sdk}/build-tools/33.0.3/apksigner}
DEPS_DIR=${IMS_BUILD_INPUTS:-$REPO/build-inputs}
# shellcheck source=artifacts.env
. "$REPO/build/artifacts.env"
STAGE=final
SIGN=0

usage() {
    cat >&2 <<EOF
Usage: $0 [--stage desem5|final] [--deps DIR] [--sign] <stock-imsservice.apk> <output.apk>

Local dependency cache (git-ignored):
  DIR/classes2.dex  historical Gson compatibility DEX
  DIR/classes3.dex  Samsung framework API compatibility DEX
  DIR/classes4.dex  VSIM compatibility DEX
EOF
    exit 2
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --stage) STAGE=${2:-}; shift 2 ;;
        --deps) DEPS_DIR=${2:-}; shift 2 ;;
        --sign) SIGN=1; shift ;;
        -h|--help) usage ;;
        --*) usage ;;
        *) break ;;
    esac
done
[ "$#" -eq 2 ] || usage
case "$STAGE" in desem5|final) ;; *) usage ;; esac
STOCK=$1
OUT=$2

[ -f "$APKTOOL_JAR_PATH" ] || { echo "ERROR: apktool.jar not found: $APKTOOL_JAR_PATH" >&2; exit 2; }
[ -f "$REPO/patches/stock-to-desem5.patch" ] || { echo "ERROR: missing stock-to-desem5.patch" >&2; exit 2; }
[ -f "$REPO/patches/desem5-to-desem81.patch" ] || { echo "ERROR: missing desem5-to-desem81.patch" >&2; exit 2; }
[ -f "$REPO/AndroidManifest.xml" ] || { echo "ERROR: missing final AndroidManifest.xml" >&2; exit 2; }

"$REPO/build/verify_input.sh" "$STOCK"
for dex in classes2.dex classes3.dex classes4.dex; do
    [ -f "$DEPS_DIR/$dex" ] || {
        echo "ERROR: missing local dependency: $DEPS_DIR/$dex" >&2
        echo "See tools/README.md: these inputs are intentionally local and git-ignored." >&2
        exit 2
    }
done

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
DEC="$TMP/decoded"
GENERATED_SMALI="$TMP/generated-smali"
UNSIGNED="$TMP/unsigned.apk"
ALIGNED="$TMP/aligned.apk"

java -jar "$APKTOOL_JAR_PATH" d -f "$STOCK" -o "$DEC" >/dev/null
patch --batch --forward -p1 -d "$DEC/smali" < "$REPO/patches/stock-to-desem5.patch"
cp "$REPO/patches/AndroidManifest.desem5.xml" "$DEC/AndroidManifest.xml"

if [ "$STAGE" = final ]; then
    patch --batch --forward -p1 -d "$DEC/smali" < "$REPO/patches/desem5-to-desem81.patch"
    cp "$REPO/AndroidManifest.xml" "$DEC/AndroidManifest.xml"

    echo "==> Compiling Java bridge for primary-DEX injection"
    SMALI_OUT="$GENERATED_SMALI" bash "$REPO/build.sh"

    generated_count=$(find "$GENERATED_SMALI" -type f -name '*.smali' | wc -l)
    tracked_count=$(find "$REPO/smali_out" -type f -name '*.smali' | wc -l)
    [ "$generated_count" -eq "$BRIDGE_SMALI_CLASS_COUNT" ] || {
        echo "ERROR: expected $BRIDGE_SMALI_CLASS_COUNT generated bridge classes, got $generated_count" >&2
        exit 3
    }
    [ "$tracked_count" -eq "$BRIDGE_SMALI_CLASS_COUNT" ] || {
        echo "ERROR: expected $BRIDGE_SMALI_CLASS_COUNT tracked bridge classes, got $tracked_count" >&2
        exit 3
    }
    if ! diff -ruN "$REPO/smali_out" "$GENERATED_SMALI"; then
        cat >&2 <<'EOF'
ERROR: Java-generated bridge smali differs from tracked smali_out/.
       Run build.sh, review the generated diff, and update the reviewed snapshot
       before assembling an APK.
EOF
        exit 3
    fi

    while IFS= read -r -d '' source; do
        relative=${source#"$GENERATED_SMALI/"}
        [ ! -e "$DEC/smali/$relative" ] || {
            echo "ERROR: generated bridge class already exists after staged patches: $relative" >&2
            echo "       Remove the duplicate from desem5-to-desem81.patch; Java must be its only source." >&2
            exit 3
        }
    done < <(find "$GENERATED_SMALI" -type f -name '*.smali' -print0)

    echo "==> Injecting Java-generated bridge smali"
    cp -a "$GENERATED_SMALI"/. "$DEC/smali/"
fi

java -jar "$APKTOOL_JAR_PATH" b "$DEC" -o "$UNSIGNED"
for dex in classes2.dex classes3.dex classes4.dex; do
    cp "$DEPS_DIR/$dex" "$TMP/$dex"
done
( cd "$TMP" && jar uf "$UNSIGNED" classes2.dex classes3.dex classes4.dex )

mkdir -p "$(dirname -- "$OUT")"
if [ "$SIGN" -eq 1 ]; then
    [ -x "$ZIPALIGN" ] || { echo "ERROR: zipalign not found: $ZIPALIGN" >&2; exit 2; }
    [ -x "$APKSIGNER" ] || { echo "ERROR: apksigner not found: $APKSIGNER" >&2; exit 2; }
    KEY=${PLATFORM_KEY:-$REPO/tools/keys/platform.pk8}
    CERT=${PLATFORM_CERT:-$REPO/tools/keys/platform.x509.pem}
    [ -f "$KEY" ] && [ -f "$CERT" ] || { echo "ERROR: platform signing key/certificate not found" >&2; exit 2; }
    "$ZIPALIGN" -p -f 4 "$UNSIGNED" "$ALIGNED"
    "$APKSIGNER" sign --key "$KEY" --cert "$CERT" --out "$OUT" "$ALIGNED"
    "$ZIPALIGN" -c -v 4 "$OUT" >/dev/null
    "$APKSIGNER" verify --verbose "$OUT"
else
    cp "$UNSIGNED" "$OUT"
fi

"$REPO/build/verify_apk.sh" "$STAGE" "$OUT"
echo "Done: $OUT"
