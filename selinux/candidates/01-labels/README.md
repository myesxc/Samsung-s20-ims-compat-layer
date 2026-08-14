# Candidate 01 — dedicated executable labels

This candidate changes only file labeling in `post-fs-data.sh`; it deliberately retains the rollback policy until live evidence proves the Magisk launcher source domain and resulting process transitions.

Expected labels:

```text
/system/bin/imsd          u:object_r:imsd_exec:s0
/system/bin/multiclientd  u:object_r:multiclientd_exec:s0
```

Before installing this candidate, build and retain the baseline rollback ZIP. After boot, run `COLLECT_SELINUX_WINDOWS.cmd boot-labels` and verify:

- global SELinux is Enforcing;
- executable labels match above;
- `/proc/<imsd>/attr/current` and `/proc/<multiclientd>/attr/current` are captured;
- `/dev/socket/imsd` type is captured;
- no automatic call or service restart occurs.

Do not remove a permissive domain based solely on static stock policy. The stock transition is `init -> imsd`/`multiclientd`; the actual Magisk script domain may differ.
