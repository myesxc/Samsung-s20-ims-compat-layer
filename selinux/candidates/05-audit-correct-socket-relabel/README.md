# Candidate 05 — kernel-audit evidence, and the socket label fix

Candidate 05 came out of a review that found the minimization loop had been running on evidence
that could not observe what it was being used to judge. It fixes the tooling first, then applies
the one policy fix that tooling makes visible, and re-derives candidate 04's removal from
evidence that can actually support it.

## Why the previous loop was not sound

1. **The collector could not see the denials it was used to rule out.** It extracted AVCs from
   `logcat` only. On Android 13 they land in the kernel audit buffer. Measured on
   `20260806_010033_candidate03-boot`:

   | source | total AVC lines | `system_app` | `system_server` |
   |---|---|---|---|
   | `logcat_recent_all_avc.txt` | 14 | 0 | 0 |
   | `dmesg_full.txt` (same capture) | 245 | 2 | 9 |

   "No AVC in the marker window" meant the collector was blind, not that the domain was
   unneeded. Candidate 04's stated rationale for dropping `permissive system_server` rested on
   exactly this, while the same capture's dmesg held nine `system_server` denials.

2. **Candidate 03 removed two lines that covered nothing.** `ps_AZ.txt` shows `u:r:init:s0`
   holding one process and `u:r:radio:s0` holding only `com.android.phone`. Every module process
   runs in `magisk`, `system_app`, or `rild`. Removing `permissive init` / `permissive radio`
   could not regress anything and improved nothing — a clean checkpoint, but not evidence that
   the method works.

3. **`dontaudit` hides denials.** The live policy carries 392 `dontaudit` rules, 11 naming
   `system_app`. An audit that ignores them can report a false all-clear.

4. **Candidates 01–02 chased a domain that does not exist here.** `magiskpolicy --live
   --print-rules` has zero declarations of `imsd`, `imsd_exec`, `multiclientd`, or
   `multiclientd_exec` — the GSI replaced Samsung's platform sepolicy, so the transition could
   never activate. The only real variable in candidate 02 was the removal of `multiclientd`,
   which broke outgoing calls with internal error 210.

## What candidate 05 changes

**Collector** — two-phase, kernel-sourced:
- `collect_selinux_ims.sh STAGE arm` before the workload records the last kernel audit serial
  and strips `dontaudit`; `... STAGE collect` after keeps only records newer than that serial.
  An audit serial bounds kernel records correctly, which a logcat marker cannot do.
- Emits `kernel_window_avc.txt`, `kernel_module_avc.txt`, `kernel_module_avc_summary.txt`
  (normalized tuples for diffing candidates), and `avc_coverage.txt`, which prints the logcat
  and kernel line counts side by side so the blind spot cannot silently return.
- `collect` refuses to run unarmed, and marks the evidence incomplete when the strip failed.

**Module** (`post-fs-data.sh`):
- relabels `/dev/socket/imsd` to `imsd_socket` once `ims_sock_launch` has bound it;
- removes any stale node before launch. `ims_sock_launch` calls `unlink()` then `bind()`, so
  each restart creates a fresh node carrying `/dev/socket`'s generic label. Without the cleanup
  the relabel loop can match a leftover node, break early, and leave the live socket unlabelled
  after any imsd restart — the denial would return silently.

**Policy** (`sepolicy.rule`): `permissive system_app` only. Candidate 04's removal of
`permissive system_server` is **kept**, but its justification is replaced. The original one was
unsound; re-derived from kernel evidence, the nine `system_server` denials are sysfs/extcon
cable probing plus one `adb_data_file getattr` that the framework-jar relabel removes. None are
IMS-specific — those sysfs accesses are enforced on stock LineageOS anyway, so our permissive
line was masking generic GSI behaviour as a side effect. Dropping it restores stock behaviour.

## Why the relabel needs no new rule

The loaded policy already contains both halves of the connect path:

```text
allow system_app imsd_socket sock_file { write }
allow system_app magisk unix_stream_socket { getopt connectto }
```

`ims_sock_launch` was creating the node as generic `socket_device`, which no rule covers, so the
write survived only because `system_app` is permissive. Labelling the node routes the access
onto a grant the ROM already ships. This is the principle the ledger already states for
`FILE-001` — fix the label rather than grant the wrong type — applied to the socket.

## Build

```text
module ZIP  9673f405505f865d0629fa53fe6b7fdb8a737c2032f055e79f7259ea00682b57  (9,952,767 bytes, 69 entries)
APK         6025d969663bdc75f4494b6760847b6141e63bb80ed6202104c643d2b83c2c03  (8,746,210 bytes)
cert        c8a2e9bccf597c2fb6dc66bee293fc13f2fc47ec77bc6b2b0d52c11f51192ab8
```

zipalign and v3 signature verified. All 11 policy contracts in `test_sepolicy_minimal.py` pass.
The APK differs from the device-validated `b2f84ef9…` baseline: the build is not byte
deterministic, so this ZIP does not inherit that APK's on-device verification.

## Acceptance

Functional bar — no regression against candidate 03: two boots, registration, outgoing call,
incoming call, media/DTMF, SMS, second call, TEST emergency.

Evidence bar — this is the actual point of the candidate. Arm before each workload, collect
after, then check:

- `avc_coverage.txt` shows `kernel_window_avc_lines` populated and `dontaudit_stripped=stripped`;
- `kernel_module_avc.txt` no longer contains `system_app -> socket_device : sock_file { write }`;
- no `imsd_socket` denial appears in its place;
- no new `system_server` denial appears now that its permissive line is gone;
- `S20VOLTE: imsd socket relabelled to imsd_socket` appears in logcat;
- `label_dev_socket_imsd.txt` reads `u:object_r:imsd_socket:s0`.

If the socket denial persists, capture `/data/local/tmp/s20volte_ims_sock_chcon.err` before
rolling back — a `chcon` failure and a race on node creation are different faults with different
fixes.

Roll back to candidate 03 on any boot, registration, or call regression.

## After this

`permissive system_app` is the last line, and the only one whose removal buys real security:
8 processes share that domain (Settings, keychain, dynsystem, localtransport, lineageparts,
qcrilam). It is blocked on one evidenced denial, `FILE-003`:

```text
system_app -> system_data_file : file { append }   (imscr.log.0)
```

Prefer relocating that log into module-owned storage over granting append.
