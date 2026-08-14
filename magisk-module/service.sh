#!/system/bin/sh
# S20 VoLTE module — late-boot bring-up.
#
# SELinux strategy: per-domain permissive via sepolicy.rule; GLOBAL SELinux stays ENFORCING.
# We deliberately DO NOT run `setenforce 0`. On Samsung, flipping the global enforce bit
# trips RKP (Real-time Kernel Protection, in the EL2 hypervisor) and force-reboots the device
# — reproduced across Lineage/DerpFest/Pixel GSIs. sepolicy.rule is applied by magiskpolicy at
# boot (same path Magisk uses for itself), which does NOT touch the global enforce bit.
MODDIR=${0%/*}

until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 2; done
sleep 5

log -t S20VOLTE "boot_completed; global SELinux=$(getenforce) (expected: Enforcing)"

# Snapshot IMS-related denials so we can tighten sepolicy.rule -> explicit allow next iteration.
{ dmesg 2>/dev/null | grep 'avc: *denied'; } | grep -Ei 'imsd|GoogleImsService|imsservice|sec_|radio|system_app' \
    > /data/local/tmp/s20volte_denials.txt 2>/dev/null
log -t S20VOLTE "denial snapshot -> /data/local/tmp/s20volte_denials.txt"

# NOTE: config_ims_mmtel_package is a framework RESOURCE (RRO), not a prop/setting — see README.
