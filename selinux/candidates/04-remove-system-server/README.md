# Candidate 04 — remove system_server permissive

Builds on dynamically validated Candidate 03. Active module policy retains only `permissive system_app`.

No system_server allow is added. Module framework JARs are relabelled `system_file` in post-fs-data to prevent the earlier magic-mount `adb_data_file` denial. Generic extcon/sysfs denials are not granted by this IMS module.

Validate two boots, registration, outgoing and incoming call, media/DTMF, SMS, second call, and TEST emergency. Roll back on framework/UI or IMS binding regression.
