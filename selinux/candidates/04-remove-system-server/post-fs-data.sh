#!/system/bin/sh
# S20 VoLTE — launch imsd ourselves, because Magisk can't inject /system/etc/init/*.rc
# (init parses /system/etc/init before Magisk's post-fs-data magic-mount, so it never
# registers `imsd` and never creates the /dev/socket/imsd control socket).
#
# Confirmed on-device: `ctl.start imsd` -> "init: Could not find 'imsd'"; running imsd by
# hand prints "Imsd 1.0 starting" then dies on "Obtaining file descriptor socket 'imsd'".
# So we recreate init's socket via ims_sock_launch, then exec imsd, and keep it alive.
#
# NOTE: imsd is launched as ROOT here (post-fs-data context) — fine for bring-up under the
# permissive IMS domains. The /dev/socket/imsd node is chown'd system:system (1000) so the
# imsservice APK (android.uid.system) can connect. RIL is left to the device's own vendor
# rild (already running — data + IMS PDN are up), so we do NOT start smdexe/connfwexe here.
MODDIR=${0%/*}
BIN="$MODDIR/system/bin"

chown 0:0 "$MODDIR/system/product/overlay/S20VoLTEImsOverlay.apk"
chmod 644 "$MODDIR/system/product/overlay/S20VoLTEImsOverlay.apk"

chcon u:object_r:system_file:s0 "$MODDIR/system/product/overlay/S20VoLTEImsOverlay.apk"

chown 0:0 "$MODDIR/system/priv-app/imsservice/imsservice.apk"
chmod 644 "$MODDIR/system/priv-app/imsservice/imsservice.apk"


chcon u:object_r:system_file:s0 "$MODDIR/system/priv-app/imsservice/imsservice.apk"

# Magic-mounted framework jars must look like ordinary /system framework files. Phase-one
# evidence showed system_server denials when rcsopenapi.jar remained adb_data_file.
for jar in EpdgManager.jar imsmanager.jar rcsopenapi.jar; do
    chcon u:object_r:system_file:s0 "$MODDIR/system/framework/$jar"
done

chcon u:object_r:system_file:s0 "$MODDIR/system/etc/init/multiclientd.rc"


[ -x "$BIN/ims_sock_launch" ] || { log -t S20VOLTE "post-fs-data: ims_sock_launch missing/not-exec — build it first (see ims_sock_launch.c)"; exit 0; }
[ -x "$BIN/imsd" ]            || { log -t S20VOLTE "post-fs-data: imsd missing/not-exec"; exit 0; }

# Background supervisor so we never block boot.
(
    until [ -d /dev/socket ]; do sleep 1; done
    # Start imsd as early as possible. imsservice may try to connect during boot; if the
    # /dev/socket/imsd control socket appears after that first attempt, registration can stay
    # down until the app is restarted. Do not fixed-sleep here.
    log -t S20VOLTE "starting imsd supervisor (rild=$(pidof rild))"
    while true; do
        # Launch asynchronously so the socket can be relabelled before imsservice connects.
        # The helper remains the owner of the socket and execs imsd in the child process.
        "$BIN/ims_sock_launch" imsd 0660 1000 1000 /system/bin/imsd 2>/data/local/tmp/s20volte_ims_sock_launch.err &
        launcher_pid=$!
        relabel_tries=0
        while [ "$relabel_tries" -lt 50 ] && kill -0 "$launcher_pid" 2>/dev/null; do
            if [ -S /dev/socket/imsd ] || [ -e /dev/socket/imsd ]; then
                if chcon u:object_r:imsd_socket:s0 /dev/socket/imsd 2>/data/local/tmp/s20volte_ims_sock_chcon.err; then
                    log -t S20VOLTE "imsd socket relabelled to imsd_socket"
                else
                    log -t S20VOLTE "imsd socket relabel failed: $(cat /data/local/tmp/s20volte_ims_sock_chcon.err 2>/dev/null)"
                fi
                break
            fi
            relabel_tries=$((relabel_tries + 1))
            sleep 0.1
        done
        wait "$launcher_pid"
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
# diagnostic instance with -s 1 after rild and the slot1 radio HAL are ready. Unlike imsd,
# multiclientd creates its own abstract sockets; do not use ims_sock_launch or create sockets.
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

    log -t S20VOLTE "starting diagnostic multiclientd -s 1 (rild=$(pidof rild))"
    "$BIN/multiclientd" -s 1
    log -t S20VOLTE "multiclientd exited (rc=$?); diagnostic launch will not retry"
) &


