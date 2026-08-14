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

# Installer-time set_perm assigns imsd_exec before Magisk mounts the module. Do not relabel
# the visible /system path here: phase-one evidence showed that post-fs-data chcon left it as
# adb_data_file and imsd remained in the Magisk domain.

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

