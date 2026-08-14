#!/usr/bin/env bash
# Regenerate the two canonical primary-smali stage patches from decoded reference trees.
# Maintenance-only: reference trees are local historical artifacts and are not committed.
set -euo pipefail

usage() {
    cat >&2 <<EOF
Usage: $0 <stock-smali-dir> <desem5-smali-dir> <desem81-smali-dir> [output-dir]

Each argument must be the primary smali root (the directory containing com/).
The generated patches are relative to an apktool decoded smali/ directory.
EOF
    exit 2
}

[ "$#" -ge 3 ] && [ "$#" -le 4 ] || usage
STOCK=$1
DESEM5=$2
DESEM81=$3
OUT=${4:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)/patches}
for tree in "$STOCK" "$DESEM5" "$DESEM81"; do
    [ -d "$tree" ] || { echo "ERROR: smali tree not found: $tree" >&2; exit 2; }
done
mkdir -p "$OUT"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
ln -s "$STOCK" "$TMP/stock"
ln -s "$DESEM5" "$TMP/desem5"
ln -s "$DESEM81" "$TMP/desem81"
(
    cd "$TMP"
    diff -ruN stock desem5 | sed -E 's#^--- stock/#--- a/#; s#^\+\+\+ desem5/#+++ b/#' > "$OUT/stock-to-desem5.patch" || test "${PIPESTATUS[0]}" -eq 1
    diff -ruN desem5 desem81 | sed -E 's#^--- desem5/#--- a/#; s#^\+\+\+ desem81/#+++ b/#' > "$OUT/desem5-to-desem81.patch" || test "${PIPESTATUS[0]}" -eq 1
)
printf 'stock-to-desem5 primary paths: '
grep -c '^--- a/' "$OUT/stock-to-desem5.patch"
printf 'desem5-to-desem81 primary paths: '
grep -c '^--- a/' "$OUT/desem5-to-desem81.patch"
