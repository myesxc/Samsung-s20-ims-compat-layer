#!/system/bin/sh
set -u

STAGE=${1:-manual}
MODE=${2:-collect}
OUT_BASE=${3:-/sdcard/s20volte_selinux}
STATE=/data/local/tmp/s20volte_selinux_arm_state

last_audit_serial() {
    dmesg 2>/dev/null \
        | grep -E 'audit\([^)]*:[0-9]+\)' \
        | sed -E 's/.*audit\([^)]*:([0-9]+)\).*/\1/' \
        | sort -n \
        | tail -1
}

if [ "$MODE" = "arm" ]; then
    serial=$(last_audit_serial)
    [ -n "$serial" ] || serial=0
    dontaudit=unavailable
    if command -v magiskpolicy >/dev/null 2>&1; then
        if magiskpolicy --live --strip-dontaudit >/dev/null 2>&1; then
            dontaudit=stripped
        else
            dontaudit=strip-failed
        fi
    fi
    # logcat -T takes "MM-DD HH:MM:SS.mmm", so record the arm instant in exactly that shape.
    # Bounding the log by time (not by a line count) is what keeps the workload inside the
    # window: a fixed -t N covered only the last few seconds when the log was busy, which
    # previously made a real two-call workload look like it never happened.
    logcat_since=$(date '+%m-%d %H:%M:%S.000')
    {
        printf 'stage=%s\n' "$STAGE"
        printf 'audit_serial=%s\n' "$serial"
        printf 'dontaudit=%s\n' "$dontaudit"
        printf 'logcat_since=%s\n' "$logcat_since"
        printf 'armed_at=%s\n' "$(date -Ins)"
    } > "$STATE"
    log -t S20VOLTE "S20VOLTE_SELINUX_${STAGE}_ARM serial=$serial dontaudit=$dontaudit"
    printf 'SELinux audit armed: stage=%s serial=%s dontaudit=%s\n' "$STAGE" "$serial" "$dontaudit"
    printf 'Run the workload now, then collect. Log window starts at %s\n' "$logcat_since"
    # Some shipped Magisk builds do not implement --strip-dontaudit. Do not fail arming:
    # kernel AVCs remain useful, but the evidence must be marked incomplete below.
    exit 0
fi

[ "$MODE" = "collect" ] || {
    printf 'Usage: %s STAGE [arm|collect] [OUT_BASE]\n' "$0" >&2
    exit 2
}
[ -f "$STATE" ] || {
    printf 'ERROR: audit is not armed; run %s %s arm before the workload\n' "$0" "$STAGE" >&2
    exit 4
}

ARM_STAGE=$(sed -n 's/^stage=//p' "$STATE")
ARM_SERIAL=$(sed -n 's/^audit_serial=//p' "$STATE")
ARM_DONTAUDIT=$(sed -n 's/^dontaudit=//p' "$STATE")
ARM_LOGCAT_SINCE=$(sed -n 's/^logcat_since=//p' "$STATE")
ARM_AT=$(sed -n 's/^armed_at=//p' "$STATE")
[ "$ARM_STAGE" = "$STAGE" ] || {
    printf 'ERROR: armed stage %s does not match requested stage %s\n' "$ARM_STAGE" "$STAGE" >&2
    exit 4
}
[ "$ARM_DONTAUDIT" = "stripped" ] || {
    printf 'WARNING: dontaudit was not stripped (%s); AVC evidence is incomplete\n' "$ARM_DONTAUDIT" >&2
}

STAMP=$(date +%Y%m%d_%H%M%S)
OUT="$OUT_BASE/${STAMP}_${STAGE}"
MARKER="S20VOLTE_SELINUX_${STAGE}_${STAMP}"
mkdir -p "$OUT" || exit 2

log -t S20VOLTE "$MARKER BEGIN"
printf '%s\n' "$MARKER" > "$OUT/MARKER.txt"
cp "$STATE" "$OUT/arm_state.txt"
date -Ins > "$OUT/date.txt" 2>&1
getenforce > "$OUT/getenforce.txt" 2>&1
id > "$OUT/collector_id.txt" 2>&1

ps -AZ > "$OUT/ps_AZ.txt" 2>&1
ps -A -o LABEL,USER,PID,PPID,NAME,ARGS > "$OUT/ps_detail.txt" 2>&1

for name in imsd ims_sock_launch multiclientd rild com.sec.imsservice; do
    pids=$(pidof "$name" 2>/dev/null)
    printf '%s=%s\n' "$name" "$pids" >> "$OUT/pids.txt"
    for pid in $pids; do
        dir="$OUT/proc_${name}_${pid}"
        mkdir -p "$dir"
        cat "/proc/$pid/attr/current" > "$dir/attr_current.txt" 2>&1
        cat "/proc/$pid/status" > "$dir/status.txt" 2>&1
        cat "/proc/$pid/cgroup" > "$dir/cgroup.txt" 2>&1
        readlink "/proc/$pid/exe" > "$dir/exe.txt" 2>&1
        tr '\000' ' ' < "/proc/$pid/cmdline" > "$dir/cmdline.txt" 2>&1
    done
done

for path in \
    /system/bin/imsd \
    /system/bin/ims_sock_launch \
    /system/bin/multiclientd \
    /dev/socket \
    /dev/socket/imsd \
    /system/priv-app/imsservice/imsservice.apk \
    /system/product/overlay/S20VoLTEImsOverlay.apk; do
    name=$(printf '%s' "$path" | tr '/' '_')
    ls -ldZ "$path" > "$OUT/label${name}.txt" 2>&1
    stat "$path" > "$OUT/stat${name}.txt" 2>&1
done

if command -v magiskpolicy >/dev/null 2>&1; then
    magiskpolicy --live --print-rules 2>/dev/null \
        | grep -E '(^| )(permissive|imsd|imsd_exec|imsd_socket|multiclientd|multiclientd_exec|system_app|system_server|radio|init)( |$)' \
        > "$OUT/live_policy_excerpt.txt"
    magiskpolicy --live --print-rules 2>/dev/null \
        | grep -E '^dontaudit' > "$OUT/live_policy_dontaudit_after_arm.txt"
fi

# Kernel audit is the authoritative AVC source on A13, so gather it first and keep it cheap.
dmesg > "$OUT/dmesg_full.txt" 2>&1
cat /proc/last_kmsg > "$OUT/last_kmsg.txt" 2>/dev/null || true

# Bound logcat by the arm TIME, not by a line count. `-t N` walks the ring buffer and both
# (a) takes minutes when something is crash-looping and (b) silently truncates to the last few
# seconds when the log is busy — which once hid a real two-call workload entirely and led to the
# wrong conclusion that the window had no traffic. `-T "<time>"` returns exactly the test window.
if [ -n "$ARM_LOGCAT_SINCE" ]; then
    timeout 60 logcat -b all -d -v threadtime -T "$ARM_LOGCAT_SINCE" > "$OUT/logcat_recent.txt" 2>&1 \
        || printf 'logcat capture timed out or was truncated\n' >> "$OUT/logcat_recent.txt"
else
    timeout 45 logcat -b all -d -v threadtime -t 2000 > "$OUT/logcat_recent.txt" 2>&1 \
        || printf 'logcat capture timed out or was truncated\n' >> "$OUT/logcat_recent.txt"
fi

# Crash-loop detector. A persistent app that keeps dying restarts faster than any AVC appears,
# and it is the single most likely reason a capture looks "clean" while IMS is broken.
grep -cE 'FATAL EXCEPTION|has crashed too many times|ClassLoader referenced unknown path' \
    "$OUT/logcat_recent.txt" 2>/dev/null > "$OUT/crash_loop_hits.txt" || echo 0 > "$OUT/crash_loop_hits.txt"
grep -E 'FATAL EXCEPTION|has crashed too many times|ClassLoader referenced unknown path' \
    "$OUT/logcat_recent.txt" 2>/dev/null | head -40 > "$OUT/crash_loop_excerpt.txt" || true

# Workload attestation. "Zero module denials" only means something if the workload actually ran;
# these counters let a later reader tell "nothing was denied" apart from "nothing happened".
# Counting notes: grep exits 1 on zero matches, so the count must be taken without an `|| echo 0`
# fallback (that appends a second line). Toybox grep also lacks \b, so use plain substrings.
count_ci() { grep -icE "$1" "$2" 2>/dev/null | head -1; }

{
    printf 'registration=%s\n' "$(count_ci 'IMS_REGISTERED|onImsConnected|onRegistered' "$OUT/logcat_recent.txt")"
    printf 'sip_invite=%s\n'   "$(count_ci 'INVITE' "$OUT/logcat_recent.txt")"
    printf 'sip_message=%s\n'  "$(count_ci 'SIP MESSAGE|sendSMSOverIMS|ModernImsSms' "$OUT/logcat_recent.txt")"
    printf 'call_session=%s\n' "$(count_ci 'ImsCallSession|onCallStart|DIALING' "$OUT/logcat_recent.txt")"
    printf 'call_active=%s\n'  "$(count_ci 'ACTIVE' "$OUT/logcat_recent.txt")"
    printf 'imscr_writes=%s\n' "$(grep -c 'comm="IMSCR"' "$OUT/dmesg_full.txt" 2>/dev/null | head -1)"
} > "$OUT/workload_activity.txt"

grep -iE 'avc: *denied|selinux' "$OUT/logcat_recent.txt" \
    > "$OUT/logcat_recent_all_avc.txt" 2>/dev/null || true
grep -iE 'avc: *denied' "$OUT/dmesg_full.txt" \
    > "$OUT/dmesg_full_avc.txt" 2>/dev/null || true

# Keep only AVC records whose kernel audit serial is newer than the arm point. This is the
# authoritative test window; logcat markers cannot bound kernel audit records.
awk -v baseline="$ARM_SERIAL" '
    {
        line=$0
        if (match(line, /audit\([^)]*:[0-9]+\)/)) {
            token=substr(line, RSTART, RLENGTH)
            sub(/^.*:/, "", token)
            sub(/\)$/, "", token)
            if ((token + 0) > (baseline + 0)) print line
        }
    }
' "$OUT/dmesg_full_avc.txt" > "$OUT/kernel_window_avc.txt"

grep -E 'scontext=u:r:(system_app|system_server|magisk|init|radio|vendor_init):' \
    "$OUT/kernel_window_avc.txt" > "$OUT/kernel_module_avc.txt" 2>/dev/null || true

sed -E 's/.*denied \{ *([^}]*[^ ]) *\}.*scontext=u:r:([a-zA-Z0-9_]+):s0 +tcontext=u:object_r:([a-zA-Z0-9_]+):s0 +tclass=([a-zA-Z0-9_]+) +permissive=([01]).*/\2 -> \3 : \4 { \1 } permissive=\5/' \
    "$OUT/kernel_module_avc.txt" 2>/dev/null | grep ' -> ' | sort | uniq -c | sort -rn \
    > "$OUT/kernel_module_avc_summary.txt" || true

count_lines() { wc -l < "$1" 2>/dev/null | tr -d ' ' || echo 0; }
count_match() { grep -c "$1" "$2" 2>/dev/null | head -1 || echo 0; }

{
    printf 'arm_audit_serial=%s\n' "$ARM_SERIAL"
    printf 'armed_at=%s\n' "$ARM_AT"
    printf 'collected_at=%s\n' "$(date -Ins)"
    printf 'logcat_window_start=%s\n' "$ARM_LOGCAT_SINCE"
    printf 'dontaudit_stripped=%s\n' "$ARM_DONTAUDIT"
    printf 'logcat_avc_lines=%s\n' "$(count_lines "$OUT/logcat_recent_all_avc.txt")"
    printf 'kernel_all_avc_lines=%s\n' "$(count_lines "$OUT/dmesg_full_avc.txt")"
    printf 'kernel_window_avc_lines=%s\n' "$(count_lines "$OUT/kernel_window_avc.txt")"
    printf 'kernel_module_avc_lines=%s\n' "$(count_lines "$OUT/kernel_module_avc.txt")"
    printf 'permissive_denials=%s\n' "$(count_match 'permissive=1' "$OUT/kernel_module_avc.txt")"
    printf 'enforcing_denials=%s\n' "$(count_match 'permissive=0' "$OUT/kernel_module_avc.txt")"
    printf 'dontaudit_rules_after_arm=%s\n' "$(count_lines "$OUT/live_policy_dontaudit_after_arm.txt")"
    printf 'dontaudit_rules_system_app=%s\n' "$(count_match '^dontaudit  *system_app ' "$OUT/live_policy_dontaudit_after_arm.txt")"
    # Liveness. Zero AVCs means nothing if the app never got far enough to need a permission:
    # in candidate05 the module domains were silent only because imsservice was crash-looping.
    printf 'imsservice_running=%s\n' "$([ -n "$(pidof com.sec.imsservice 2>/dev/null)" ] && echo yes || echo NO)"
    printf 'imsd_running=%s\n' "$([ -n "$(pidof imsd 2>/dev/null)" ] && echo yes || echo NO)"
    printf 'multiclientd_running=%s\n' "$([ -n "$(pidof multiclientd 2>/dev/null)" ] && echo yes || echo NO)"
    printf 'crash_loop_hits=%s\n' "$(cat "$OUT/crash_loop_hits.txt" 2>/dev/null || echo 0)"
    # ls -Z column position differs between toybox builds; match the context pattern instead.
    printf 'imsd_socket_context=%s\n' "$(ls -ldZ /dev/socket/imsd 2>/dev/null | grep -oE 'u:object_r:[a-zA-Z0-9_]+:s0' | head -1 || echo absent)"
} > "$OUT/avc_coverage.txt"

cat "$OUT/workload_activity.txt" >> "$OUT/avc_coverage.txt" 2>/dev/null || true

rm -f "$STATE"
log -t S20VOLTE "$MARKER END output=$OUT"
printf '%s\n' "$OUT" > /sdcard/s20volte_selinux_latest.txt
printf 'SELinux evidence saved to %s\n' "$OUT"
