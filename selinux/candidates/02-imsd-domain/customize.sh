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

# Only the module launcher and imsd are started by this module.
set_perm "$MODPATH/system/bin/ims_sock_launch" 0 2000 0755
set_perm "$MODPATH/system/bin/imsd" 0 2000 0755 "u:object_r:imsd_exec:s0"
ui_print "  exec: ims_sock_launch"
ui_print "  exec+label: imsd -> imsd_exec"
ui_print "- multiclientd is shipped for provenance but is not auto-started."

ui_print "- Reboot to apply. After boot, verify: 'getenforce' should still print 'Enforcing'."
