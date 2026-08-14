#!/system/bin/sh
# S20 VoLTE — launch imsd ourselves, because Magisk can't inject /system/etc/init/*.rc
# (init parses /system/etc/init before Magisk's post-fs-data magic-mount, so it never
# registers `imsd` and never creates the /dev/socket/imsd control socket).
#
# Confirmed on-device: `ctl.start imsd` -> "init: Could not find 'imsd'"; running imsd by
# hand prints "Imsd 1.0 starting" then dies on "Obtaining file descriptor socket 'imsd'".
# So we recreate init's socket via ims_sock_launch, then exec imsd, and keep it alive.
#
# This script runs as full root. Neither daemon stays that way: ims_sock_launch drops each
# one to the identity its stock .rc file declares before exec (imsd -> system/1000 with only
# NET_RAW+NET_ADMIN, multiclientd -> radio/1001 with no capabilities at all). The
# /dev/socket/imsd node is chown'd system:system (1000) so the imsservice APK
# (android.uid.system) can connect. RIL is left to the device's own vendor rild (already
# running — data + IMS PDN are up), so we do NOT start smdexe/connfwexe here.
MODDIR=${0%/*}
BIN="$MODDIR/system/bin"
#S20VOLTE_MULTICLIENTD_ROOT Changing to 0 will allow multiclientd to run as radio, 
#which will help improve security, but may prevent some applications from running
S20VOLTE_MULTICLIENTD_ROOT=1

chown 0:0 "$MODDIR/system/product/overlay/S20VoLTEImsOverlay.apk"
chmod 644 "$MODDIR/system/product/overlay/S20VoLTEImsOverlay.apk"

chown 0:0 "$MODDIR/system/priv-app/imsservice/imsservice.apk"
chmod 644 "$MODDIR/system/priv-app/imsservice/imsservice.apk"

# Magic-mounted files carry adb_data_file, which no framework domain can read — that is what
# kept system_server needing permissive. Restore the label each path has in the stock image:
# everything is system_file EXCEPT /system/lib{,64}, which stock labels system_lib_file. That
# distinction matters beyond this module: /system/lib64 is scanned by every app's linker, and
# labelling those .so files system_file broke dlopen for native-heavy apps (navigation apps
# stopped launching). Stock's per-daemon *_exec types for bin/ (imsd_exec, eris_exec, ...) do
# not exist in this GSI's policy, so those binaries stay system_file — imsd has run that way
# since candidate03.
chcon -R u:object_r:system_file:s0     "$MODDIR/system"
chcon -R u:object_r:system_lib_file:s0 "$MODDIR/system/lib" "$MODDIR/system/lib64"

# The IMS call-record logger (CriticalLogger -> LogFileManager) writes /data/log/imscr/imscr.log.N
# with 1MB rotation x5, so it needs dir{create,add_name,remove_name} and file{create,append,
# rename,unlink} — none of which system_app has on the inherited system_data_file label.
# rdxdump_data_file is a Samsung diagnostic-dump type the loaded policy already grants system_app
# in full, is reachable only by init and system_app, and nothing else on this GSI uses it.
mkdir -p /data/log/imscr
chown 1000:1000 /data/log /data/log/imscr
chcon -R u:object_r:rdxdump_data_file:s0 /data/log/imscr

[ -x "$BIN/ims_sock_launch" ] || { log -t S20VOLTE "post-fs-data: ims_sock_launch missing/not-exec — build it first (see ims_sock_launch.c)"; exit 0; }
[ -x "$BIN/imsd" ]            || { log -t S20VOLTE "post-fs-data: imsd missing/not-exec"; exit 0; }

# Relabel the control socket to the Samsung type the loaded policy already carries:
# `allow system_app imsd_socket sock_file { write }` plus
# `allow system_app magisk unix_stream_socket { getopt connectto }`. ims_sock_launch binds the
# node as generic socket_device, which system_app cannot write to once permissive is removed,
# so labelling the node is all that is needed — no new rule.
#
# This runs as an independent watcher, NOT inside the supervisor loop. It must never unlink or
# recreate the node: ims_sock_launch already unlink()s before bind(), and deleting a live socket
# breaks any imsservice connection made since the last restart. Re-label in place, every time the
# inode changes, and otherwise stay out of the daemon's way.
(
    last_inode=
    while true; do
        if [ -e /dev/socket/imsd ]; then
            inode=$(stat -c %i /dev/socket/imsd 2>/dev/null)
            ctx=$(ls -ldZ /dev/socket/imsd 2>/dev/null | awk '{print $4}')
            case "$ctx" in
                *imsd_socket*) : ;;
                *)
                    if chcon u:object_r:imsd_socket:s0 /dev/socket/imsd 2>/data/local/tmp/s20volte_ims_sock_chcon.err; then
                        log -t S20VOLTE "imsd socket relabelled to imsd_socket (inode=$inode)"
                    else
                        log -t S20VOLTE "imsd socket relabel FAILED: $(cat /data/local/tmp/s20volte_ims_sock_chcon.err 2>/dev/null)"
                    fi
                    ;;
            esac
            last_inode=$inode
        fi
        sleep 2
    done
) &

# Background supervisor so we never block boot.
(
    until [ -d /dev/socket ]; do sleep 1; done
    # Start imsd as early as possible. imsservice may try to connect during boot; if the
    # /dev/socket/imsd control socket appears after that first attempt, registration can stay
    # down until the app is restarted. Do not fixed-sleep here.
    log -t S20VOLTE "starting imsd supervisor (rild=$(pidof rild))"
    while true; do
        # Foreground: ims_sock_launch execv()s imsd in place (it does not fork), so this call
        # blocks for the daemon's whole lifetime and returns its exit code. Do not background it
        # and do not delete the socket node here.
        "$BIN/ims_sock_launch" imsd 0660 1000 1000 /system/bin/imsd 2>/data/local/tmp/s20volte_ims_sock_launch.err
        rc=$?
        if [ -s /data/local/tmp/s20volte_ims_sock_launch.err ]; then
            while IFS= read -r line; do
                log -t S20VOLTE "ims_sock_launch: $line"
            done < /data/local/tmp/s20volte_ims_sock_launch.err
        fi
        log -t S20VOLTE "imsd exited (rc=$rc); restart in 5s"
        sleep 5
    done
) &

# multiclientd.rc is magic-mounted too late for init to register its service. Stock starts
# /system/bin/multiclientd -s 2 for DSDS. This GSI exposes only slot1, so launch exactly one
# instance with -s 1 after rild and the slot1 radio HAL are ready. Unlike imsd, multiclientd
# makes its own abstract sockets, so no control socket is created for it.
#
# Launched through ims_sock_launch --no-socket purely to shed privileges: post-fs-data runs as
# full root, so a direct exec left multiclientd at uid 0 with all 38 capabilities. Stock
# multiclientd.rc asks for `user radio / group radio cache inet misc log readproc sdcard_rw`
# and declares no capabilities at all, which is what the flags below reproduce.
# Set S20VOLTE_MULTICLIENTD_ROOT=1 (or IMS_SOCK_LAUNCH_NO_DROP=1) to fall back to the old
# root launch if a regression ever needs bisecting.
#
# The drop path execs /system/bin/multiclientd — the magic-mounted copy — NOT
# "$BIN/multiclientd" under /data/adb/modules. /data/adb is 0700 root:root, so once
# ims_sock_launch has dropped to uid 1001 it can no longer traverse that path and execv fails
# with EACCES ("Permission denied"), leaving outgoing calls broken. The root fallback below
# still runs as uid 0, so it may keep using "$BIN". imsd never hit this because it already
# execs /system/bin/imsd.
(
    [ -x "$BIN/multiclientd" ] || {
        log -t S20VOLTE "multiclientd missing/not-exec; not launching"
        exit 0
    }

    tries=0
    while [ "$tries" -lt 60 ]; do
        rild_pid=$(pidof rild)
        slot1=$(getprop ril.halservice.registered.slot1)
        if [ -n "$rild_pid" ] && [ "$slot1" = "true" ]; then
            break
        fi
        tries=$((tries + 1))
        sleep 2
    done

    if [ -z "$(pidof rild)" ] || [ "$(getprop ril.halservice.registered.slot1)" != "true" ]; then
        log -t S20VOLTE "multiclientd prerequisites timed out: rild=$(pidof rild) slot1=$(getprop ril.halservice.registered.slot1)"
        exit 0
    fi

    # radio=1001 cache=2001 inet=3003 misc=9998 log=1007 readproc=3009 sdcard_rw=1015
    MC_GROUPS=1001,2001,3003,9998,1007,3009,1015
    if [ "${S20VOLTE_MULTICLIENTD_ROOT:-0}" = "1" ] || [ ! -x "$BIN/ims_sock_launch" ]; then
        log -t S20VOLTE "starting multiclientd -s 1 as ROOT (fallback; rild=$(pidof rild))"
        "$BIN/multiclientd" -s 1
    else
        log -t S20VOLTE "starting multiclientd -s 1 as radio/1001 (rild=$(pidof rild))"
        "$BIN/ims_sock_launch" --no-socket --uid 1001 --gid 1001 --groups "$MC_GROUPS" \
            /system/bin/multiclientd -s 1 2>/data/local/tmp/s20volte_multiclientd_drop.err
    fi
    rc=$?
    if [ -s /data/local/tmp/s20volte_multiclientd_drop.err ]; then
        while IFS= read -r line; do
            log -t S20VOLTE "multiclientd launch: $line"
        done < /data/local/tmp/s20volte_multiclientd_drop.err
    fi
    log -t S20VOLTE "multiclientd exited (rc=$rc); diagnostic launch will not retry"
) &
