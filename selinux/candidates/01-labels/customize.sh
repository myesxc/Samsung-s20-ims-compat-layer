#!/system/bin/sh
##########################################################################################
# S20 VoLTE (Samsung IMS on GSI) — install-time setup
##########################################################################################
ui_print "- S20 VoLTE (Samsung IMS on GSI) v0.2-mvp-sepolicy"
ui_print "- SELinux: GLOBAL stays ENFORCING; IMS domains permissive via sepolicy.rule"
ui_print "- (No 'setenforce 0' — that trips Samsung RKP and reboots the device)"

# Default perms (root:root, dirs 0755 / files 0644)
set_perm_recursive "$MODPATH" 0 0 0755 0644

# Magisk startup script must be executable.
if [ -f "$MODPATH/post-fs-data.sh" ]; then
    set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
    ui_print "  exec: post-fs-data.sh"
fi

# Native daemons / binaries MUST be executable, or imsd/eris/... never start.
for b in imsd eris multiclientd smdexe connfwexe  ims_sock_launch; do
  if [ -f "$MODPATH/system/bin/$b" ]; then
    set_perm "$MODPATH/system/bin/$b" 0 2000 0755
    ui_print "  exec: system/bin/$b"
  fi
done

ui_print "- Reboot to apply. After boot, verify: 'getenforce' should still print 'Enforcing'."
