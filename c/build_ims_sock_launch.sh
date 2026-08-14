#!/usr/bin/env bash
# Cross-compile ims_sock_launch for the S20 module (aarch64 / bionic / PIE).
#
# The helper reproduces what init would do for a Samsung IMS daemon: create its control
# socket (imsd) and/or drop from post-fs-data's full root to the stock .rc identity.
# It must be built against bionic, so a host gcc will not do — NDK r26d is used.
#
# USAGE:
#   export NDK=<path to android-ndk-r26d>
#   bash c/build_ims_sock_launch.sh
#
# OUTPUT:
#   proprietary_vendor_samsung_ims/proprietary/system/bin/ims_sock_launch
#
# You only need to run this if you modify ims_sock_launch.c — a pre-built binary is
# already committed at the output path above.
set -eu

NDK=${NDK:-$HOME/ndk-cache/android-ndk-r26d}
NDK_HOST=${NDK_HOST:-linux-x86_64}
API=${API:-30}
CC=${CC:-$NDK/toolchains/llvm/prebuilt/$NDK_HOST/bin/aarch64-linux-android$API-clang}

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO=$(CDPATH= cd -- "$HERE/.." && pwd)
SRC="$HERE/ims_sock_launch.c"
OUT="$REPO/proprietary_vendor_samsung_ims/proprietary/system/bin/ims_sock_launch"

[ -x "$CC" ] || {
    echo "ERROR: NDK clang not found: $CC" >&2
    echo "       Set NDK to your android-ndk-r26d root (see tools/README.md)." >&2
    echo "       On macOS also set NDK_HOST=darwin-x86_64." >&2
    exit 2
}
[ -f "$SRC" ] || { echo "ERROR: source not found: $SRC" >&2; exit 2; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo "compiling $SRC"
"$CC" -O2 -Wall -Wextra -o "$TMP/ims_sock_launch" "$SRC"

# Verify the product is actually a bionic aarch64 PIE before letting it near the module.
file "$TMP/ims_sock_launch" || true
if ! readelf -h "$TMP/ims_sock_launch" | grep -qE 'Machine:.*AArch64'; then
    echo "ERROR: not an AArch64 binary" >&2; exit 3
fi
if ! readelf -h "$TMP/ims_sock_launch" | grep -qE 'Type:.*(DYN|Position-Independent)'; then
    echo "ERROR: not a PIE binary" >&2; exit 3
fi

# Usage smoke tests on the host are impossible (aarch64), so at least confirm both usage
# strings are present in the binary — a cheap guard against building the wrong source.
for s in "--no-socket" "ANDROID_SOCKET_"; do
    grep -q -- "$s" "$TMP/ims_sock_launch" || { echo "ERROR: missing marker '$s'" >&2; exit 3; }
done

mkdir -p "$(dirname "$OUT")"
if [ -f "$OUT" ]; then
    echo "previous: $(sha256sum "$OUT" | cut -d' ' -f1)  $(stat -c%s "$OUT") bytes"
fi

install -m 0755 "$TMP/ims_sock_launch" "$OUT"
echo "installed: $OUT"
echo "new:      $(sha256sum "$OUT" | cut -d' ' -f1)  $(stat -c%s "$OUT") bytes"
echo
echo "Deploy to a running device with:"
echo "  adb push proprietary_vendor_samsung_ims/proprietary/system/bin/ims_sock_launch /sdcard/ims_sock_launch"
echo "  adb shell su -c \"cp /sdcard/ims_sock_launch /data/adb/modules/s20volte_ims/system/bin/ims_sock_launch && chmod 0755 /data/adb/modules/s20volte_ims/system/bin/ims_sock_launch\""
