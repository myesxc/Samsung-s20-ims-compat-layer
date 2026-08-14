# Candidate 02 — imsd dedicated-domain transition

Changes relative to candidate 01:

- Stops the diagnostic module-side `multiclientd -s 1` launch. Phase-one evidence showed it ran as root in `u:r:magisk:s0` with full capabilities; IMS registration remained normal, so no policy is added for it.
- Applies `imsd_exec` to the module source file during Magisk installation via `set_perm`.
- Adds an exact `magisk + imsd_exec -> imsd` process transition using existing stock types.
- Keeps the four original permissive declarations during this domain-validation phase.
- Uses pure-shell marker-bounded AVC extraction.

Acceptance evidence after installation/reboot:

- `/system/bin/imsd` label is `u:object_r:imsd_exec:s0`.
- `imsd` process is `u:r:imsd:s0`.
- imsd UID/GID remains system; effective capabilities remain NET_RAW+NET_ADMIN only.
- module does not launch `multiclientd`.
- global SELinux is Enforcing and IMS registers normally.

If the executable remains `adb_data_file`, do not add broad access; stop and inspect Magisk mount labeling. If executable label is correct but process remains Magisk, inspect transition load/denials.
