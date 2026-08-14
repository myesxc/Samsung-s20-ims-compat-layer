# Candidate 03 — remove init/radio permissive only

Restores the proven runtime architecture after rejected candidate 02:

- imsd launched through ims_sock_launch and remains in Magisk domain with stock UID/GID/groups and NET_RAW+NET_ADMIN.
- multiclientd -s 1 is restored because A/B evidence showed registration works without it but outgoing calls fail after START OUTGOING with internal error 210.
- ineffective imsd_exec labeling and Magisk-to-imsd transition are removed.

Policy change is intentionally limited to deleting:

```text
permissive init
permissive radio
```

The module retains system_app and system_server permissive while mounted-file, IMS socket, and property requirements are narrowed in later candidates.

Acceptance: two boots, registration, normal outgoing call, incoming call, DTMF, SMS, second call, and TEST emergency. Roll back immediately on boot/registration/outgoing-call regression.
