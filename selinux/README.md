# SELinux privilege convergence

> 中文文档：[README.zh-CN.md](README.zh-CN.md)

---

How this module went from **four permissive domains plus two root daemons** down to
**one permissive domain and two unprivileged daemons — with zero new allow rules**.

Everything here is evidence-driven: each step was applied to a real device, verified
against kernel audit records, and either kept or reverted based on what the device
actually reported.

---

## Why not just `setenforce 0`

Samsung's RKP (Knox EL2 hypervisor) **force-reboots the device** when the global SELinux
enforce bit is cleared. This was reproduced on three different GSIs, so switching ROM does
not help. Magisk's `sepolicy.rule` patching, by contrast, does not touch the global bit
and does not trip RKP.

Everything in this directory follows from that constraint.

---

## Final state

| Item | Before | After | How |
|---|---|---|---|
| `permissive init` | present | **removed** | no module process ever ran in `init` |
| `permissive radio` | present | **removed** | no module process ever ran in `radio` |
| `permissive system_server` | present | **removed** | denials were generic GSI noise, not IMS |
| `permissive system_app` | present | **kept** | blocked on `resourcecache_data_file` |
| `/dev/socket/imsd` | `socket_device` → denied | `imsd_socket` | `chcon`, reusing an existing rule |
| `/data/log/imscr` | `system_data_file` → denied | `rdxdump_data_file` | `chcon`, reusing an existing rule |
| Module files | `adb_data_file` | `system_file` + `system_lib_file` | recursive `chcon` matching stock |
| `imsd` | root, 38 caps | uid/gid 1000, `NET_RAW`+`NET_ADMIN` | `ims_sock_launch` |
| `multiclientd` | root, 38 caps | uid/gid 1001, **zero** caps | `ims_sock_launch --no-socket` |

**No allow rule was added at any point.** Every fix relabels an object so that a rule the
GSI policy *already contained* applies to it.

---

## The guiding technique: relabel, don't grant

The GSI's policy already ships rules like:

```text
allow system_app imsd_socket sock_file { write }
allow system_app magisk unix_stream_socket { getopt connectto }
```

The `/dev/socket/imsd` denial was never a missing rule — `ims_sock_launch` created the
node as generic `socket_device`, which those rules do not cover. One `chcon` to
`imsd_socket` and the denial disappears with no policy change.

The same reasoning fixed the IMS call-record log. `system_app` has no file permissions on
`system_data_file`, but Samsung's `rdxdump_data_file` type grants `system_app` the full
`file { create append rename unlink }` + `dir { create add_name remove_name }` set, is
reachable only by `init` and `system_app`, and is unused elsewhere on this GSI. Relabelling
`/data/log/imscr` to it costs nothing in exposure.

> `radio_data_file` looks like a natural fit but is **unusable**: it is the one candidate
> lacking `create` / `add_name` / `rename`, so directory creation fails at boot.

---

## Contents

| Path | What it is |
|---|---|
| `sepolicy_requirements.csv` | The ledger. One row per rule considered, with status, evidence file and rationale — including the rejected ones and why. |
| `candidates/01-labels/` … `05-…/` | Each attempted step: its `post-fs-data.sh`, `sepolicy.rule`, checksums and a README explaining the outcome. |
| `sepolicy.rule.baseline-permissive` | The original all-permissive policy, kept for offline rollback. Not shipped in the module. |
| `tools/collect_selinux_ims.sh` | Two-phase on-device evidence collector (`arm` then `collect`). |
| `tools/COLLECT_SELINUX_WINDOWS.cmd` | Windows wrapper for the collector. |

Candidates 01 and 02 **failed** and are kept deliberately — they document a dead end worth
not repeating (see below).

---

## What is still blocked

`permissive system_app` cannot currently be removed. Doing so breaks IMS registration
while producing **zero `system_app` AVCs**: the failure surfaces as ~250×
`Failed to load asset path /system/priv-app/imsservice/imsservice.apk` and repeated failures
on `/data/resource-cache/…@idmap`. This GSI's policy grants `resourcecache_data_file`
access to `system_server` and `init` only — `system_app` has no rule at all, and no
relabelling trick applies because the path is owned by the framework, not by this module.

Fixing it requires genuinely new policy, which would widen access for all **8 processes**
in that domain: Settings, keychain, dynsystem (×2), localtransport, lineageparts,
qcrilam and imsservice. That trade was judged not worth making unilaterally.
**Contributions welcome.**

---

## Two dead ends worth knowing about

**1. There is no `imsd` domain to transition to.** Candidates 01 and 02 tried to label the
daemons `imsd_exec` and add a `magisk → imsd` domain transition. The GSI replaced Samsung's
platform sepolicy wholesale, so `imsd`, `imsd_exec`, `multiclientd` and `multiclientd_exec`
have **zero declarations** in the loaded policy. The label cannot be applied and the
transition can never activate. Both daemons necessarily stay in the `magisk` domain; only
their Unix identity can be reduced, which is what `ims_sock_launch` does.

**2. Removing `permissive init` and `permissive radio` bought no security.** `ps -AZ` shows
the `radio` domain held only `com.android.phone` and the `init` domain one unrelated
process. No module process ever ran in either. The lines were removed because they were
dead weight, not because they were protecting anything.

---

## Methodology note — read this before collecting evidence

**On Android 13, SELinux denials go to the kernel audit buffer, not to logcat.**

The original collector only scraped `logcat`. In one boot capture that yielded 14 AVC lines
with **zero** module-relevant entries, while `dmesg` for the same boot held 245 lines with
11 module-relevant ones. Every "no AVC, therefore this permission is unnecessary" conclusion
drawn before that discovery was unsound and had to be re-derived.

`tools/collect_selinux_ims.sh` is now two-phase: `arm` records the last kernel audit serial
and a logcat timestamp, then `collect` keeps only newer records. Other traps it works
around, each of which produced a wrong conclusion at least once:

- **Bound logcat by time, never by line count.** `logcat -t 1200` returned an 8-second
  window on a busy device and made two real phone calls look like they never happened.
  `logcat -T <timestamp>` returns the intended 80+ seconds.
- **toybox `grep` does not support `\b`.** `\bINVITE\b` matches nothing on-device while GNU
  grep on the build host reports 27 — an easy way to "prove" the wrong thing. Plain
  substrings only.
- **`grep -c … || echo 0` emits two lines** (grep exits 1 on zero matches, triggering the
  fallback *and* printing `0`). Use `| head -1`.
- **`ls -Z` column position varies by toybox version.** Match the context pattern instead
  of taking `$4`.
- **Zero denials means nothing without a workload count.** Always capture liveness and
  activity counters (calls placed, INVITEs seen, log writes) alongside. One "clean" capture
  turned out to be a boot loop where the process never started.

A `dontaudit` rule suppresses a denial from the audit log without affecting enforcement, and
this device's Magisk cannot strip them. Of 2142 live `dontaudit` rules, 11 name `system_app`
as source, none of which touch sockets, IMS files, IMS properties or telephony. Rather than
treat that as a blocker, the acceptance criterion became **a full functional regression** —
which is inherently immune to `dontaudit`, since broken functionality shows up whether or
not the denial was logged.

---

## Privacy

Device captures are **not** included here: they contain IMSI, phone numbers and IMEI. Only
scripts, policy files, checksums and written analysis are committed. `.gitignore` blocks
`logcat_*`, `dmesg*`, `*.pcap` and dated capture directories — keep it that way when adding
new evidence.
