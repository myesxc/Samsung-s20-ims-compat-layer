# Evidence-Driven Cross-Device Samsung IMS Porting Guide

> 中文版：[基于证据的跨设备三星 IMS 移植指南](CROSS_DEVICE_PORTING_GUIDE.zh-CN.md)
>
> **Reference implementation, not a transplant kit.** This repository validates one Samsung Snapdragon S20 reference case. It does not establish that its APK, DEX files, JAR changes, native libraries, daemon configuration, SELinux labels, Magisk module, signatures, or carrier behavior work on any other device.

This guide is for developers and AI-assisted coding workflows investigating whether a Samsung device can expose its stock IMS stack to an AOSP-based ROM or GSI. It explains how to build evidence, identify the real integration boundary, make one reversible change at a time, and stop when the target lacks a safe or supportable path.

It is **not** an instruction to flash the S20 module on another device. It is also not a guarantee that an IMS port is possible. Samsung firmware, Android platform APIs, SoC/radio stacks, SELinux policies, carrier provisioning, and platform-signing arrangements vary substantially between devices and releases.

## Read this first

| Need | Authoritative reference in this repository |
|---|---|
| Verified S20 architecture and current boundaries | [Architecture and compatibility model](ARCHITECTURE.md) |
| Verified S20 four-DEX build contract | [BUILD.md](../BUILD.md) |
| Local toolchain and ignored inputs | [tools/README.md](../tools/README.md) |
| S20 framework-JAR compatibility override | [imsmanager-compat/README.md](../imsmanager-compat/README.md) |
| S20 Magisk payload and packaging rules | [magisk-module/README.md](../magisk-module/README.md) |
| S20 runtime startup implementation | [post-fs-data.sh](../magisk-module/post-fs-data.sh) and [ims_sock_launch.c](../c/ims_sock_launch.c) |
| S20 SELinux evidence, experiments, and residual risk | [selinux/README.md](../selinux/README.md) |
| Supported S20 baseline, limitations, and licensing | [README.md](../README.md) |

`BUILD.md` is deliberately specific to the documented S20 firmware. Use it as an example of a reproducible artifact contract; do not reinterpret its hashes, DEX counts, patch names, or payload list as requirements for another target.

## Safety, legal, and support boundary

Before collecting firmware or changing a device, accept these constraints:

- **Do not rely on an experimental port for emergency calling.** Even a feature that appears to work in a limited test can fail because of network state, provisioning, location, routing, device recovery, or an untested carrier path. Keep another way to contact emergency services.
- **Keep a recovery route before every flash.** Know how to disable or remove the newest Magisk module, restore a known-good boot path, and reinstall an ordinary telephony-capable baseline. Do not begin if recovery depends on the candidate being tested.
- **Use firmware and proprietary components lawfully.** Obtain donor firmware legitimately; respect copyright, licenses, redistribution limits, carrier terms, and local law. A public source tree should contain project-authored code, scripts, manifests, hashes, and documentation—not unreviewed firmware extraction, signing keys, or confidential carrier material.
- **Treat captured evidence as sensitive.** Logcat, kernel audit records, modem/IMS traces, PCAPs, package dumps, and screenshots can contain IMSI, IMEI, telephone numbers, SIP identifiers, registration data, certificates, or location-related information. Keep raw captures local, redact excerpts, and do not commit them by default. The S20 evidence policy in [selinux/README.md](../selinux/README.md) follows this rule.
- **Do not lower the global SELinux enforcing state.** The S20 project observed Samsung RKP-triggered reboots after `setenforce 0`. That result is S20-specific evidence, but the operation is dangerous enough that global permissive mode is not an acceptable default diagnostic technique on a new target.
- **Do not copy private platform keys.** A system/shared-UID package must be signed according to the target ROM's platform-signature rules. Test keys work only when the target ROM is actually built and configured for them. Never publish a private key.
- **Do not claim support from a successful build.** Compilation, apktool rebuild, installation, service binding, IMS registration, call setup, audio, SMS, and recovery are independent milestones.

## Evidence labels used by this guide

Every design note, source comment, experiment record, and AI-generated proposal should distinguish fact from inference.

| Label | Meaning | Required behavior |
|---|---|---|
| **[S20-validated]** | Verified only on the documented S20 baseline. | Cite the S20 implementation/evidence and retain its narrow scope. |
| **[Portable method]** | A reusable investigation technique. | State what data must be collected before applying it to a new target. |
| **[Target-dependent]** | A value or contract that must be rediscovered per device/firmware/ROM. | Use a template field, not an S20 default. |
| **[Hypothesis]** | A plausible explanation or candidate change that lacks new-target validation. | State the experiment, expected observation, failure interpretation, and rollback. |
| **[Unsupported / do not copy]** | A known S20-specific artifact, rejected path, or unsafe shortcut. | Explain why direct reuse would be unsound. |

A change does not “fix” anything until the record names all of the following:

1. target profile and artifact hash;
2. one intended variable;
3. bounded workload;
4. evidence source and collection window;
5. expected versus observed result;
6. regression and rollback result.

“No AVC appeared” is not success without liveness and workload evidence. “The APK installed” is not success without framework binding and functional evidence.

---

# Part I — Core model

## 1. The port is a layered integration problem

A Samsung IMS package usually depends on more than Java code inside an APK. A useful model is:

```text
AOSP/GSI framework selection and Telephony IMS contract
        |
        v
IMS package declaration, RRO selection, privilege/signing identity
        |
        v
APK DEX code, Samsung framework JAR symbols, Binder/AIDL contracts
        |
        v
Samsung IMS services, daemons, sockets, native libraries, EPDG data
        |
        v
init lifecycle, UID/GID/groups/capabilities, SELinux labels/domains
        |
        v
existing vendor RIL, radio HAL, IMS PDN, modem, carrier provisioning
        |
        v
signaling, bearer, SDP/codec, RTP/audio, SMS, recovery behavior
```

A fault in an upper layer can look like a fault below it. For example:

- a missing manifest declaration can look like “IMS never registers”;
- a missing framework symbol can look like a daemon initialization failure;
- a missing init-created socket can look like a native binary incompatibility;
- an incorrect SELinux label can look like an app permission issue;
- an RRO choosing a different IMS package can make a correct bridge appear unused;
- a registered service can still have no audio because the media/bearer path differs.

Therefore, do not begin by copying all proprietary blobs or writing broad SELinux policy. First identify which boundary is absent and prove it with target evidence.

## 2. Why stock Samsung IMS normally does not directly work on AOSP

[S20-validated] The S20 stock integration assumed Samsung framework APIs, privileged identity, matched proprietary runtime components, init-managed daemons and sockets, Samsung-oriented SELinux types, and a compatible vendor radio environment. AOSP GSI Telephony instead expects a package selected for the framework and exposing the standard IMS service contract. The S20 project retained matching Samsung components and added adapters only where its GSI lacked a required contract. See [ARCHITECTURE.md](ARCHITECTURE.md).

[Portable method] Apply the same question set to every target:

1. **Discovery:** Which package does the target AOSP framework select as its IMS implementation? How is that selection configured?
2. **Binding:** Which `ImsService` API generation and metadata does that framework require? Is it modern `android.telephony.ims.ImsService`, a compat API, or a ROM-specific integration path?
3. **Privilege:** Does the package need a platform certificate, a shared UID, priv-app permissions, privileged permissions, an allowlist, or a partition-specific installation location?
4. **Internal APIs:** Which Samsung classes, JAR methods, properties, AIDL interfaces, providers, or resources are missing on the GSI?
5. **Native/runtime:** Which processes, sockets, native libraries, configurations, certificates, and carrier data does the APK assume already exist?
6. **Radio:** Which vendor RIL, HAL service, slot, property, IMS PDN, and modem state must be ready first?
7. **Policy:** Which file labels, socket labels, process identities, capabilities, and SELinux domains are assumed by stock firmware?
8. **Media:** After signaling works, where do RTP, codec negotiation, bearer indications, and audio routing occur on this target?

The answer is a target profile, not a guess. If several answers remain unknown, the correct next step is discovery—not a patch.

## 3. S20 reference cases that must not become defaults

| S20 reference case | What it demonstrates | What a new target must rediscover |
|---|---|---|
| `GoogleModernImsService` with `BIND_IMS_SERVICE`, MMTEL metadata, emergency-MMTEL metadata, and `android.telephony.ims.ImsService` action | An AOSP-visible IMS endpoint may be missing from stock Samsung integration. | Framework API generation, selected package, service class, action, required metadata, permissions, export/single-user rules, and Binder behavior. |
| RRO assigns `config_ims_mmtel_package` to `com.sec.imsservice` | Package selection can be separate from APK installation. | Resource name, overlay policy, package name, competing overlays, whether the overlay is mutable, and how the target framework resolves it. |
| Four-DEX S20 APK | A primary-DEX-only rebuild can be functionally incomplete even when installable. | All archive entries, their roles/hashes, class-loader expectations, native libraries, assets, manifest/resource changes, and whether multidex is necessary. |
| Five stubs added to `imsmanager.jar!classes2.dex` | A minimal framework augmentation can repair absent symbols while retaining vendor primary DEX. | Exact missing symbols, semantics, call sites, stock JAR layout, secondary DEX loading, and whether a stub is sufficient or a real implementation is required. |
| `imsd`, `multiclientd`, native libraries, EPDG configuration | Samsung APK functionality may depend on a matched runtime suite. | Exact process graph, executable paths, shared-library ABI/dependencies, configs, certificates, init definitions, and whether donor artifacts match the target SoC/firmware. |
| `ims_sock_launch` recreates an init socket | Magisk may mount init files too late for init to register a stock service. | Whether init timing is actually the cause, socket name/mode/owner/context, required environment variables, daemon args, restart policy, and service responsibility. |
| AP-side RTP code | Registration/call signaling and media can use different paths. | Whether CP-side media fires, bearer callbacks arrive, SDP ownership, RTP endpoint placement, audio routing, and codec requirements. |
| `multiclientd -s 1` and SIM 1 limitation | A GSI port can expose fewer slots than stock firmware. | Slot topology, subscription mapping, HAL properties, daemon slot arguments, DSDS behavior, and whether a multi-SIM solution is feasible. |
| S20 RKP response to global permissive | Policy changes can trigger device-specific security behavior. | Target boot/reboot behavior, available labels/rules/types, audit source, and safe narrowly scoped policy experiments. |

---

# Part II — Gated porting workflow

Each stage below has a hard purpose: avoid producing a “working” artifact whose required runtime dependencies have not been understood. Do not skip a gate because an earlier S20 experiment happened to skip it.

## Stage 0 — Safety, legal, and recovery readiness

### Objective

Create a lab environment where a failed candidate is recoverable and evidence remains attributable to exactly one experiment.

### Required inputs

- a supported unlocked/rooted target device, or a test device that can be restored;
- donor firmware acquired lawfully and a target ROM/GSI image with known provenance;
- a known-good boot/recovery route and a documented module-disable/remove method;
- a last-known-good module ZIP or baseline image;
- separate local directories for immutable source artifacts, derived artifacts, sensitive captures, and source-controlled project files;
- an out-of-band emergency-contact method.

### Actions

1. Record the current working phone state: ordinary calls, data, SMS, carrier, SIM slot, ROM build, root/Magisk version, and recovery method.
2. Copy—not move—the original donor APK/JAR/configuration files into an immutable local input store.
3. Hash every input before decompiling, mounting, or patching it.
4. Create an experiment ledger and reserve one row per candidate.
5. Decide one rollback trigger before modifying anything: boot loop, repeated reboot, no ordinary telephony, daemon crash loop, unsafe thermal/battery behavior, persistent signal loss, or unbounded policy denial.
6. Make each candidate module/output directory new. Never overwrite the known-good artifact.

### Minimum experiment ledger

```text
experiment_id:           target-YYYYMMDD-NN
intent:                  one sentence; exactly one conceptual variable
operator:                local developer or reviewed AI-assisted procedure
target_profile_id:       device/firmware/ROM/carrier tuple
donor_profile_id:        source firmware tuple
baseline_artifact_hash:  SHA-256
candidate_artifact_hash: SHA-256
changed_files:           exact list
commands_run:            saved locally
workload:                boot / registration / call duration / SMS etc.
evidence_window:         start/end timestamp and kernel audit serial if available
expected_result:         observable, falsifiable
observed_result:         pass/fail/partial/blocked
rollback_trigger:        predefined condition
rollback_result:         verified ordinary telephony/data state
next_action:             evidence-driven only
```

### Exit criteria

- A known-good recovery path has been tested or is credibly documented for this exact device.
- Input and baseline hashes are recorded.
- A candidate can be removed without relying on the candidate itself.
- The experiment ledger exists before the first flash.

### Stop conditions

Stop before porting if the target cannot be restored, the donor cannot be identified precisely, necessary platform signing cannot legally be performed, or private artifacts would need to be published to proceed.

---

## Stage 1 — Build a donor and target discovery matrix

### Objective

Replace “this is a Samsung phone” with a precise compatibility profile. Device family names are too broad: a regional variant, SoC, firmware revision, Android API level, modem stack, carrier configuration, and GSI can each change the relevant contracts.

### Target profile template

```markdown
## Target profile

| Field | Value | Evidence / command / source | Confidence |
|---|---|---|---|
| Target model / codename |  |  |  |
| Board / SoC / ABI |  |  |  |
| Device variant / CSC / region |  |  |  |
| Bootloader / root / recovery route |  |  |  |
| Target ROM or GSI name/version |  |  |  |
| Android API / security patch |  |  |  |
| `ro.build.tags` and platform-signing condition |  |  |  |
| Vendor firmware build / baseband |  |  |  |
| Carrier / SIM slot / provisioning state |  |  |  |
| Stock IMS package path/name/version/certificate |  |  |  |
| APK archive entries / DEX list |  |  |  |
| Framework JAR paths / DEX lists |  |  |  |
| Native binaries / libraries / ABI dependencies |  |  |  |
| Init service definitions / sockets |  |  |  |
| UID/GID/groups/capabilities |  |  |  |
| Relevant RIL/HAL services/properties |  |  |  |
| AOSP IMS selection / RRO path |  |  |  |
| SELinux live contexts / policy declarations |  |  |  |
| Baseline IMS/call/SMS state |  |  |  |
| Restore method / known-good artifact |  |  |  |
```

Create a separate **donor profile** with the same fields. Do not collapse donor and target merely because the model name is similar.

### Safe discovery methods

- Mount firmware images read-only where possible. Work on copies of APK/JAR artifacts.
- Use a Linux/WSL environment for recursive archive/decompiled-tree inspection. The S20 investigation found that host-side recursive search mistakes can produce false conclusions; confirm actual paths and permissions.
- Use archive-aware tools (`jar tf`, `aapt`, `apksigner`, `readelf`, `nm`, `strings`, `baksmali`, `apktool`) appropriate to the format.
- When inspecting protected system directories, account for traversal permissions. A non-root enumeration can report a false negative.
- Capture command output and input hashes alongside the resulting inventory.

### Values that must never be inherited from S20

- firmware build and APK SHA-256;
- APK/JAR DEX count or class count;
- package name and service class;
- service action/metadata/API generation;
- overlay package/resource;
- daemon names/arguments/slot count;
- user/group/capability set;
- SELinux types or allow rules;
- library list and ABI;
- signing certificate;
- carrier profile and emergency test number;
- audio/RTP ports/codecs;
- build-tool versions unless independently compatible.

### Exit criteria

You can answer the eight core questions in section 2 with evidence, or can state which exact one is blocked and why. Do not begin a runtime patch with an unknown stock APK identity or unknown platform-signing path.

---

## Stage 2 — Establish unmodified baselines and bounded comparative evidence

### Objective

Know what stock firmware does, what the unmodified GSI does, and which behavior changes after each candidate. This makes later logs interpretable.

### Required baseline runs

Where lawful and practical, collect the same bounded workload on:

1. matching stock/donor firmware;
2. target GSI before the port;
3. each candidate after a clean reboot;
4. the restored baseline after a failed candidate.

A bounded workload should record the start/end time and include only safe, authorized actions, for example:

- boot completion and package/service discovery;
- IMS registration observation;
- one ordinary outgoing call to a safe test contact;
- one incoming call where feasible;
- a short call with confirmation of both directions of audio;
- DTMF only where appropriate;
- IMS SMS test only with consent;
- one reboot persistence check.

Do not repeatedly call real emergency numbers. If an operator has a lawful emergency test route, keep it separately authorized, time-bounded, and never use it as the sole proof of safety.

### Evidence packet for each run

- target/donor profile identifier;
- exact artifact hashes;
- device time and collection-window start/end;
- package dumps/service dumps relevant to IMS selection;
- process list with UID and SELinux context;
- daemon state/restart count;
- relevant system properties/HAL readiness state;
- redacted logcat excerpt;
- bounded kernel audit/dmesg excerpt when policy is in scope;
- workload counters: calls attempted, calls connected, inbound event received, SMS segments sent/received, RTP/audio observation, etc.;
- result classification: pass, fail, partial, blocked, regressed, untested, or not applicable.

### Why log collection needs discipline

[S20-validated] The S20 SELinux work found that Android 13 AVCs of interest appeared in the kernel audit buffer/dmesg rather than reliably in logcat. A logcat-only “clean” capture was therefore unsound. `dontaudit` can also hide denials while enforcement continues. See [selinux/README.md](../selinux/README.md).

[Portable method] On a new target, prove where relevant audit events appear before using absence of a log line as evidence. Arm collection before the workload, bound it by time or audit serial, and capture liveness/workload counters. Do not infer success from an idle or boot-looping process that produced no logs.

### Exit criteria

- Baseline behavior is described, not assumed.
- Every future candidate can be compared against the same workload.
- Sensitive raw data remains outside the publishable tree.

---

## Stage 3 — Map dependencies and locate the actual missing boundary

### Objective

Classify every required component before deciding whether the port needs an APK bridge, a framework compatibility shim, a runtime payload, a startup adaptation, a policy change, or no change at all.

### Dependency ledger template

```markdown
| Dependency | Stock source/path | Target availability | Classification | Evidence | Decision | Owner / next experiment |
|---|---|---|---|---|---|---|
| AOSP IMS package selection |  | existing / absent / unknown | target capability / generated adaptation / unknown |  |  |  |
| Manifest service contract |  |  |  |  |  |  |
| Samsung framework symbol |  |  |  |  | stub / implementation / not needed |  |
| Framework JAR |  |  | donor artifact / target replacement |  |  |  |
| APK DEX entry |  |  | preserved / rebuilt / generated |  |  |  |
| Native library |  |  | matched donor artifact / target capability |  |  |  |
| Daemon/init service/socket |  |  | existing / startup adaptation |  |  |  |
| RIL/HAL/property |  |  | target capability |  |  |  |
| SELinux type/rule |  |  | existing label / candidate policy / unknown |  |  |  |
| Carrier/EPDG config |  |  | matched donor artifact / unknown |  |  |  |
| Media/bearer path |  |  | target-dependent hypothesis |  |  |  |
```

### Classifications

- **Existing target capability:** Already provided by the target ROM/vendor; do not replace it without evidence.
- **Matched donor artifact:** Must come from the matching donor firmware and stay compatible with its surrounding stack.
- **Generated adaptation:** Project-authored bridge, stub, overlay, launcher, or build output that exists to satisfy one demonstrated missing contract.
- **Target replacement:** A component deliberately supplied by the target ROM rather than donor firmware. Verify ABI and semantic compatibility.
- **Deliberate exclusion:** A stock component intentionally omitted, with a reason and regression evidence.
- **Unknown:** A dependency not yet mapped. This blocks broad packaging decisions.

### Important diagnostic distinction: internal initialization vs framework binding

[S20 historical lesson] Adding missing Samsung framework stubs allowed more internal Samsung initialization, but it did not create an AOSP-visible IMS service. A private singleton or private AIDL binder can be initialized while `ImsResolver` still has no usable standard endpoint.

[Portable method] Treat these as separate tests:

1. Does the stock/internal Samsung graph initialize without missing symbols?
2. Does the AOSP framework select the intended package?
3. Does the framework bind the declared IMS service?
4. Does the service create a non-null MMTEL/registration feature through the target API?
5. Does that feature actually reflect Samsung registration/capabilities/call events?

A failure at step 2 cannot be repaired by adding more native blobs. A failure at step 1 cannot be repaired by changing an RRO. Keep the boundary clear.

### API signature discipline

[S20 historical lesson] An earlier reference device exposed a similar `GoogleImsService` concept but different method signatures and return types. Replacing the S20 implementation wholesale would have broken the Android 13 target. The workable strategy was to adapt a bridge to target signatures and minimally patch the target implementation where justified.

[Portable method] For every copied or referenced class, verify at least:

- `.class` and `.super` descriptors;
- implemented interfaces;
- method names, parameter descriptors, return descriptors, and thrown exceptions;
- access flags and static/instance behavior;
- referenced target framework/JAR classes;
- field types and initialization order;
- Binder/AIDL transaction expectations where relevant;
- Android API level availability.

Class-name similarity is not evidence of compatibility. Never replace a target service implementation with one from another device until every ABI and behavioral assumption has been proved.

### Exit criteria

A written dependency ledger identifies the first missing boundary to address. If the ledger says “copy all files,” it is incomplete.

---

## Stage 4 — Controlled build and artifact reproducibility

### Objective

Produce artifacts that can be traced back to immutable donor inputs and inspected before they reach a device.

### Reusable practices from the S20 build

The S20 build is a useful pattern, not a template:

```text
hash-verified stock input
  -> ordered, reviewable transformation stages
  -> generated bridge compiled in a private directory
  -> checked against a reviewed snapshot
  -> inject only defined generated/preserved payloads
  -> align/sign when appropriate
  -> structural verification
  -> separately packaged/verified module
```

The corresponding S20 scripts are [build/verify_input.sh](../build/verify_input.sh), [build/build_apk.sh](../build/build_apk.sh), [build/verify_apk.sh](../build/verify_apk.sh), and [BUILD.md](../BUILD.md).

Adopt these controls on a new target:

1. **Pin input identity.** Hash the donor APK/JAR and record archive entries before alteration.
2. **Use ordered stages.** Give each conceptual state a name; a stage must have a known input, known patch/transform, and validation result.
3. **Keep generated and in-place modifications separate.** A patch edits an existing stock class; generated source creates a complete new class. Do not let the same class come from both without a deliberate override rule.
4. **Verify transformed structure.** Decode/reinspect output; check DEX entries, expected classes, manifest declarations, package/signing metadata, and forbidden stale references.
5. **Keep local dependencies local.** Tool JARs, proprietary inputs, framework dumps, cache DEX files, and signing keys belong in ignored directories, not the public repository.
6. **Distinguish reproducibility scopes.** Functional structure can be reproducible while final ZIP bytes differ because of tool versions, compression, alignment, or signing metadata.
7. **Refuse mismatches.** A verifier should fail early when input hash, DEX layout, required class, or patch precondition differs. Do not weaken a verifier merely to make an unknown input pass.

### Multi-DEX is an artifact contract, not an optimization detail

[S20-validated] The documented S20 stock APK begins with one DEX, while the final working output contains four DEX files. A previous primary-DEX-only rebuild installed and signed but could not register IMS because it omitted functional compatibility payloads.

[Target-dependent] Inventory the exact target APK/JAR archive before rebuilding:

```bash
# Template only: replace the input path and use a tool available in the target lab.
jar tf /path/to/target-ims.apk | grep -E '(^|/)classes[0-9]*\.dex$'
```

For each DEX, record source, hash, class count, role, class-loader expectation, and whether it is stock-preserved, generated, or derived. Do not assume that all secondary DEX files are safe to copy, or that a single DEX means no external dependency exists.

### Build decision tree

```text
Input hash/layout mismatch
  -> stop; update the target profile or choose the correct donor

Patch cannot apply cleanly
  -> stop; compare the exact target class/tree; do not force patch offsets

Build fails
  -> verify target API JARs, classpath, tool versions, descriptors, and resources

Structural verifier fails
  -> do not flash; repair the artifact contract first

Install/signature failure
  -> inspect package identity, alignment, certificate, shared UID, priv-app placement

Install succeeds but service is unused
  -> inspect selection/manifest/RRO/framework binding before editing call code

Service binds but registration fails
  -> inspect target framework symbols, internal initialization, runtime daemons, sockets, vendor dependencies, and policy
```

### Signing and package identity

A system IMS package may run as a privileged/shared UID and need the target ROM platform signature. Confirm:

- package name and `sharedUserId`/UID behavior;
- target ROM certificate lineage and whether test keys are actually accepted;
- installation partition and priv-app allowlists;
- package-manager cache behavior after manifest-only changes;
- whether signing strips/changes relevant APK entries;
- ZIP alignment requirements for the target Android version.

[S20 historical lesson] An unaligned APK could fail to install on Android R+, and stale package cache could mask a manifest-only change. These are useful checks, not evidence that every target behaves identically.

### Exit criteria

The candidate artifact has a source/input manifest, hash, structural verification record, and a rollback artifact. A successful compile alone is not an exit criterion.

---

## Stage 5 — AOSP selection, bridge design, and runtime startup

This stage separates four frequently conflated problems: package selection, service binding, internal service adaptation, and daemon startup.

### 5.1 Prove framework package selection first

The target framework cannot call a bridge it does not select.

#### Investigate

- `ImsResolver`/Telephony behavior on the target API level;
- installed IMS-capable packages and service declarations;
- package enablement and package-manager state;
- resource overlays controlling an IMS package, including mutable overlays;
- package priority/subscription/slot association;
- framework logs/dumps that show selected package and binding attempts.

[S20-validated] The S20 module uses an RRO to set `config_ims_mmtel_package` to `com.sec.imsservice`; another mutable IMS overlay can take that selection away. This is a target-specific solution. A new target must identify the actual resource and policy rather than copying the S20 overlay.

#### Exit criteria

You can show target evidence that the intended package is selected for the intended slot/subscription before debugging registration or media.

### 5.2 Design the AOSP-visible bridge from the target contract

The bridge may need to expose standard registration, MMTEL feature, call session, incoming call, SMS, emergency, capability, and configuration behavior while delegating to a private Samsung implementation.

#### Procedure

1. Inspect target framework and telephony-common JARs/classes for the required IMS API generation.
2. Inspect the stock Samsung service's public/private service declarations, Binder interfaces, singleton/module graph, and callback paths.
3. Define the smallest target-specific adapter boundary:
   - a service endpoint;
   - one or more feature wrappers;
   - registration/capability propagation;
   - call-session conversion;
   - SMS callback conversion;
   - incoming-call notification path.
4. Compile or write against target framework APIs, not reference-device JARs.
5. Add readiness accessors or internal hooks only when the target implementation proves they are required and safe.
6. Keep unimplemented interface paths explicit. A `null` return or no-op may be acceptable for a milestone, but it must be documented and not mistaken for support.

#### Required static checks

- manifest action, permission, metadata, exported/single-user settings, and service class agree with the target framework contract;
- bridge classes have target-compatible descriptors;
- all hidden/compile-only stub classes are excluded from final output unless deliberately needed at runtime;
- framework service creation reaches a non-null feature instance;
- registration and capability state are not merely stored internally but delivered via the target API callback path.

### 5.3 Distinguish registration from capability and call bridging

[S20 historical lesson] A Samsung private registration broadcast or internal “ready” state did not automatically make AOSP `isImsRegistered` true. The bridge had to connect the framework-visible registration/capability feature to the retained Samsung state.

[Portable method] Test these separately:

| Question | Evidence |
|---|---|
| Was the service selected and bound? | Package/framework dump plus service lifecycle log. |
| Was a feature object created? | Target API callback/method trace and non-null return. |
| Did framework registration become visible? | Telephony/IMS dumps and registration callback trace. |
| Did capabilities become visible? | MMTEL capability state and callback trace. |
| Can framework create a call session? | Outgoing-call API → bridge → vendor session trace. |
| Can vendor inbound state reach the dialer? | Vendor callback → bridge → framework incoming-call event. |

Do not use “SIP registration succeeds” as proof that AOSP dialer integration works.

### 5.4 Prove Magisk/init timing before recreating services

[S20-validated] Magisk magic-mount made module init `.rc` files visible after init had parsed `/system/etc/init`; init therefore did not register S20 `imsd` or create its control socket. The S20 project used `ims_sock_launch` to recreate that proven missing responsibility. See [post-fs-data.sh](../magisk-module/post-fs-data.sh).

[Portable method] Before adding a launcher on a new target, establish:

- Does stock init define the daemon service?
- Is the service actually registered/started on the target GSI?
- Does the binary fail because of a missing inherited socket, property trigger, environment variable, working directory, user/group, capability, label, or dependent service?
- Is a systemless mount too late for init parsing, or is another cause responsible?
- Which exact responsibility must be recreated?

A safe launcher should recreate only what stock init demonstrably provides: for example socket creation, mode/ownership, one environment variable, credential drop, and exec. It should not become a blanket replacement for init or manually start every donor binary.

### 5.5 Derive readiness order and privilege from stock definitions

Investigate stock `.rc` files, service manager state, process attributes, and live target behavior. Record:

- binary path and arguments;
- trigger conditions and dependencies;
- required properties/HAL service state;
- socket name/type/mode/owner/group/context;
- UID/GID/supplementary groups/capabilities;
- restart policy and crash behavior;
- SELinux process/file context;
- slot/subscription argument semantics.

[S20-validated] The S20 launcher waits for `rild` and `ril.halservice.registered.slot1=true` before starting one `multiclientd -s 1`. `imsd` runs through the launcher with reduced `system` identity. The checked-in S20 script currently selects a root fallback for `multiclientd`; its lower-privilege radio path is available but is not the default. None of this is a safe default for another target.

### Exit criteria

- The framework selects and binds the intended package.
- The bridge creates usable target API features without class/linkage errors.
- Required daemons start only after evidence-backed readiness conditions.
- Process identities, socket ownership, and basic liveness match the target plan.

---

## Stage 6 — SELinux minimization as an evidence loop

### Objective

Make the smallest defensible policy/label/identity change that supports a demonstrated workload, while preserving global enforcing and making residual risk explicit.

### Non-negotiable rules

1. Do not use `setenforce 0` as a porting method.
2. Do not assume stock Samsung SELinux types exist on a GSI.
3. Do not copy stock `allow` rules, permissive domains, or domain transitions without checking the loaded target policy.
4. Do not call a configuration “minimal” because it has fewer lines; call it minimal only when the evidence ledger explains why every remaining privilege is needed.
5. Do not use absence of logcat AVCs as permission evidence.
6. Keep Unix UID/GID/capability reduction separate from SELinux-domain confinement.

### Evidence-driven loop

```text
functional baseline
  -> arm kernel-audit/log collection
  -> run bounded workload with liveness counters
  -> collect and classify evidence
  -> propose one narrowly scoped candidate
  -> flash/apply candidate
  -> repeat full workload
  -> keep or revert with written rationale
```

### Data to capture before any policy proposal

- loaded policy declarations for candidate source/target types;
- live process contexts (`ps -AZ` or equivalent);
- live file, library, directory, device, property, and socket contexts;
- process UID/GID/groups/capabilities;
- kernel audit records around the workload;
- app/framework/native logs and restart count;
- exact workload/liveness counters;
- candidate-versus-baseline diff.

### Prefer relabel only when the policy proves it is appropriate

[S20-validated] The S20 work reused existing labels such as `system_file`, `system_lib_file`, `imsd_socket`, and `rdxdump_data_file` where the loaded GSI policy already granted the needed access. It did not add new allow rules. `radio_data_file` was rejected because required directory creation permissions were absent. The target GSI had no `imsd`/`imsd_exec` or `multiclientd`/`multiclientd_exec` types, so a Samsung-specific domain transition could not work.

[Portable method] On a new target, a relabel is valid only if all are true:

1. the target loaded policy declares the candidate type;
2. the relevant source domain already has the exact required operations on it;
3. the object semantics match the type's intended exposure;
4. the operation succeeds across the full workload;
5. no broader unintended clients gain access because of the relabel;
6. the result is recorded with pre/post context and audit evidence.

If any condition fails, treat it as a hypothesis failure. Do not relabel arbitrary paths to a “promising” Samsung type.

### Residual permissive state must be reported, not hidden

[S20-validated] The current S20 port retains `permissive system_app` because enforcing it blocks registration through framework-owned resource-cache/idmap access. The issue cannot be solved by relabeling a path owned by the framework; a broad new grant would affect multiple processes in the domain. Global enforcing therefore does not mean fully confined IMS.

[Portable method] If a new target requires a permissive domain, record:

- exact domain and processes sharing it;
- required workload and failure symptom when removed;
- bounded audit/evidence attempts;
- alternatives attempted and rejected;
- risk statement;
- rollback behavior;
- conditions that would justify revisiting it.

Never hide this behind “SELinux enforcing” language.

### Exit criteria

The candidate has survived the required workload with evidence. The SELinux ledger explains every label, policy rule, permissive setting, identity, and capability that remains. If this cannot be achieved, mark the port experimental and retain the known-good rollback route.

---

## Stage 7 — Signaling, media, repeat-call, and recovery validation

### Objective

Prove user-visible IMS behavior rather than stopping at registration.

### Required feature matrix

Use this matrix for each target/firmware/ROM/carrier combination. `Pass` requires a dated artifact/profile/evidence reference.

| Feature | Status | Evidence ID | Notes / regression condition |
|---|---|---|---|
| Package selected by framework | untested |  |  |
| IMS service bound | untested |  |  |
| Framework registration visible | untested |  |  |
| MMTEL capabilities visible | untested |  |  |
| Outgoing ordinary call setup | untested |  |  |
| Incoming ordinary call delivery | untested |  |  |
| Bidirectional audio | untested |  |  |
| Codec negotiation | untested |  |  |
| RFC 4733 DTMF, if applicable | not applicable |  |  |
| IMS SMS MO | untested |  |  |
| IMS SMS MT / multi-segment | untested |  |  |
| Repeated call after teardown | untested |  |  |
| Reboot persistence | untested |  |  |
| Network/radio transition | untested |  |  |
| Call waiting/hold/forwarding | untested |  |  |
| Video / RCS | unsupported |  |  |
| Authorized emergency-test route | untested |  | Must never be the sole safety proof. |
| Long-duration stability | untested |  |  |

Allowed statuses are **pass**, **fail**, **partial**, **blocked**, **untested**, **regressed**, and **not applicable**. Do not replace them with “works.”

### Separate signaling from media

A call can register and connect yet have one-way/no audio. Investigate in order:

1. framework selected/bound state;
2. registration and capability state;
3. outgoing/incoming call session creation;
4. SIP/IMS signaling and SDP offer/answer where evidence is lawful to inspect;
5. bearer/dedicated-bearer or equivalent vendor callback state;
6. codec/PT mapping and negotiated bitrate;
7. RTP endpoint ownership, bind address/port, socket routing, and packet direction;
8. Android audio routing and call-audio integration;
9. teardown and next-call state.

[S20-validated] The S20 project observed a GSI condition where the CP-side media path did not fire and added AP-side RTP/media adaptation. Later work found repeated-call port rotation and codec/DTMF details that required target-specific handling. This is evidence that media is its own subsystem—not a reason to preemptively transplant AP RTP code to another device.

### Trace lifecycle semantics before calling “reset” APIs

[S20 historical lesson] A deregistration experiment broke the next registration because the selected Samsung API performed a manual profile removal rather than a temporary network refresh. Earlier experiments also misread parameter semantics because logging strings did not match the ultimate consumer.

[Portable method] Before invoking a vendor “reset,” “deregister,” “remove,” “stop,” or “release” API:

- trace its parameter to the final consumer;
- determine whether it is manual versus network-triggered behavior;
- identify who recreates the profile/session afterward;
- prove idempotency and repeated-call behavior;
- pair destructive actions with their documented rebuild/re-register path;
- test a clean reboot and a repeat call separately.

Do not apply radio resets as a silent permanent fix. If a workaround interrupts service, state duration, effect, and unsupported scenarios prominently.

### Exit criteria

The target has a feature matrix with evidence-backed status. A port with registration only is a registration prototype, not a VoLTE/IMS release.

---

## Stage 8 — Release, rollback, and maintainership handoff

### Objective

Turn a successful lab result into a bounded, reproducible deliverable—or clearly state why it remains experimental.

### Release manifest

Every proposed release should include, at minimum:

```text
release_id:
source_revision:
target_profile_id:
donor_firmware_identity:
donor_artifact_hashes:
target_rom_gsi_identity:
platform-signing requirement:
toolchain versions:
input/proprietary source policy:
APK/JAR/module artifact hashes:
payload manifest hash:
validation matrix reference:
known limitations:
residual SELinux/privilege risks:
unsupported variants:
rollback artifact and instructions:
```

### Package only declared payload

[S20-validated] The S20 module uses `payload-manifest.tsv` as packaging authority and verifies selected inputs/final ZIP. This avoids silently shipping host tools, logs, keys, temporary files, old experiments, or arbitrary blobs.

[Portable method] Create a target-specific manifest with categories such as stock-identical, project addition, compatibility override, patched artifact, and intentional omission. Require each non-stock entry to have a reason, source, hash, and regression result. Do not bulk-copy a vendor/system tree.

### Rollback runbook

1. Stop testing when the predefined rollback trigger occurs.
2. Preserve safe, redacted evidence before changing the state further.
3. Disable/remove the newest candidate through the target's planned recovery route.
4. Restore the verified last-known-good module or stock baseline.
5. Reboot and verify ordinary telephony/data before resuming investigation.
6. Mark the candidate rejected with hashes, exact symptom, evidence window, and rollback result.
7. Do not carry unreviewed changes from a rejected candidate into the next one.

### Publishing rule

Publish only claims that the validation matrix supports. State model, SoC, firmware, ROM/GSI, Android version, carrier conditions, signing assumptions, known limitations, and residual policy risk. Do not describe a device-family port as working because one regional variant worked.

---

# Part III — AI and Developer Operating Protocol

## 1. What an AI coding tool may and may not do

An AI tool can help inventory files, compare interfaces, draft a hypothesis, propose a narrow diff, write a verifier, generate templates, summarize redacted evidence, and create documentation.

It must not:

- fabricate command output, hashes, class descriptors, policy declarations, successful tests, radio behavior, or carrier support;
- infer a target's compatibility from model name or reference-device source alone;
- automatically flash a module, mutate a rooted device, alter recovery assets, or test an emergency route;
- issue `setenforce 0` as a default troubleshooting step;
- extract, publish, or commit platform keys, proprietary blobs, PCAPs, raw IMS traces, or personal identifiers;
- weaken hash/structural verifiers to make an unknown artifact pass;
- replace vendor RIL/radio components or copy all donor blobs without a dependency ledger and human review;
- silently widen SELinux policy, add a permissive domain, or retain root daemon execution without explicit human approval and documented risk.

## 2. Read-before-write protocol

Before proposing a code or policy change, the AI must inspect:

1. target profile and donor profile;
2. baseline artifact hashes and archive layout;
3. current build/runtime/policy implementation;
4. nearest relevant historical experiment and whether it is active, rejected, or superseded;
5. actual target class/method descriptors and target framework API;
6. the current failure evidence and its collection window;
7. allowed files and the human-approved scope.

Before proposing a command, classify it:

| Command class | Examples | Requirement |
|---|---|---|
| Read-only host | archive listing, hashing, decoding to temp copy | State source path and expected observation. |
| Read-only device | dumps, process/context/property inspection | State privacy impact and collection window. |
| Derived artifact build | compile, patch copy, sign derived output | State inputs, output path, verification, and no-overwrite rule. |
| Device mutation | module install, policy/identity change, property change | Require explicit human approval, rollback, and success/failure criteria. |
| Recovery-affecting | boot/vendor/system modification, module removal during failure | Require a human-confirmed recovery plan. |

## 3. Required AI evidence packet

Give an AI tool a compact but complete packet rather than an unbounded log dump:

```markdown
## Goal
One falsifiable sentence.

## Single experiment variable
Exactly one conceptual change.

## Target profile
Device, SoC, firmware, ROM/GSI, Android API, carrier/slot, signing condition.

## Donor profile
Exact firmware/build and source artifact hashes.

## Baseline
Known-good artifact/hash and observable baseline behavior.

## Evidence
Redacted excerpts with timestamps/audit serials, workload counters, and source paths.

## Expected observation
What would support the hypothesis?

## Failure interpretation
What result would refute it or move triage to another layer?

## Rollback
Artifact/path/procedure and trigger.

## Allowed scope
Files/commands the AI may inspect or modify.
```

## 4. Required AI output contract

A proposal must contain:

1. hypothesis and confidence label;
2. cited local evidence/source paths;
3. affected layer from the dependency model;
4. minimal file list and reason for each change;
5. exact build/structural verification;
6. bounded on-device validation workload;
7. negative/regression tests;
8. rollback instructions;
9. assumptions and unknowns;
10. what the change explicitly does **not** prove.

Reject vague output such as “add permissive,” “copy the blobs,” “replace the service,” “flash and see,” or “try the S20 patch” unless it is transformed into a narrow, reviewed experiment with evidence and rollback.

## 5. Symptom-first triage matrix

| Symptom | First evidence to collect | Do not assume |
|---|---|---|
| APK will not install | alignment, certificate, shared UID, partition placement, package-manager error | that DEX code is wrong |
| APK installs but IMS package is unused | manifest service, action/permission/metadata, overlay selection, package enablement | that modem/radio is broken |
| Package selected but framework binding fails | target API contract, service lifecycle, class/linkage error, feature creation | that extra blobs are required |
| Service binds but registration remains false | registration/capability callback bridge, missing framework symbols, internal readiness, daemon/socket state | that SIP registration alone is enough |
| Daemon exits immediately | stock init contract, socket FD/env, executable path, UID/GID/caps, SELinux context, missing library | that a restart loop fixes it |
| Registration works but outgoing call fails | session bridge, slot/radio readiness, daemon/vendor/RIL state, call logs | that audio/media code is relevant yet |
| Call connects without audio | SDP/codec/bearer/RTP path/audio routing, packet evidence where lawful | that registration is broken |
| Only repeated/second call fails | teardown/recovery state, port rotation, profile lifecycle, clean reboot comparison | that the initial call proves stability |
| AVC appears clean but feature fails | kernel audit source, `dontaudit`, workload completeness, process liveness | that policy is irrelevant |
| Boot loop/reboot/crash loop | execute rollback first; preserve safe evidence second | that more modifications are safe |

## 6. Human approval gates

Require explicit human confirmation before:

- flashing/installing a new candidate;
- changing daemon UID/GID/groups/capabilities;
- adding SELinux rules, labels, or permissive domains;
- modifying a package manifest or RRO that changes IMS selection;
- adding/removing a module payload entry;
- introducing a proprietary dependency into a distribution;
- running an emergency-related test;
- publishing a binary or support claim.

---

# Part IV — Reusable checklists and templates

## A. Donor extraction and provenance manifest

```markdown
# Donor provenance manifest

- donor_profile_id:
- lawful source/reference:
- model / board / SoC / region:
- firmware build / Android API / patch level:
- extraction image and partition:
- mount mode: read-only / other (explain)
- artifact path:
- SHA-256:
- archive entry inventory saved at:
- dependent JAR/library/binary/configuration inventory:
- license/redistribution classification:
- local storage location (not committed):
- extraction date/operator:
- verification reviewer:
```

## B. Artifact verification checklist

```markdown
- [ ] Input hash matches target profile.
- [ ] Input archive entries/DEX layout recorded before modification.
- [ ] Ordered patches/transforms apply cleanly to this exact input.
- [ ] Generated classes do not collide with patched/preserved classes.
- [ ] Output DEX entries and class sets match the declared target artifact contract.
- [ ] Manifest service/action/permission/metadata match target framework evidence.
- [ ] Hidden compile-only classes are absent unless explicitly required at runtime.
- [ ] Native libraries/assets/configuration are declared, not incidental.
- [ ] APK alignment is verified where required.
- [ ] Signature/certificate/shared-UID expectations match the target ROM.
- [ ] Output hash and build tool versions are recorded.
- [ ] A structural failure prevents flashing.
```

## C. Runtime readiness checklist

```markdown
- [ ] Intended package is selected by the target framework.
- [ ] Intended service is bound for the intended slot/subscription.
- [ ] Feature creation is observed and non-null.
- [ ] Registration and capabilities become visible through framework callbacks/dumps.
- [ ] Required donor daemons are identified and only necessary ones start.
- [ ] Every required socket has target-derived name/mode/owner/context.
- [ ] Required properties/HAL/radio state are ready before dependent daemon launch.
- [ ] Process path, UID/GID/groups/capabilities, and SELinux context are recorded.
- [ ] Crash/restart behavior has a bounded policy and is observable.
- [ ] Module does not block boot or leave unbounded retry loops.
```

## D. SELinux candidate ledger

```markdown
| Candidate ID | One change | Source/target types | Precondition evidence | Workload | AVC/audit result | Functional result | Exposure/risk | Keep or revert | Rollback verified |
|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |
```

## E. Failure and rollback report

```markdown
# Candidate failure report

- candidate artifact/hash:
- target profile:
- first bad boot/test timestamp:
- workload completed before failure:
- symptom and user-visible impact:
- process/daemon state:
- redacted evidence references:
- changed variable:
- hypothesis result: supported / refuted / inconclusive
- rollback trigger met:
- rollback procedure:
- post-rollback ordinary telephony/data verification:
- candidate disposition: rejected / needs narrower reproduction
- prohibition for future work (if applicable):
```

## F. Release and non-claim checklist

```markdown
- [ ] Exact target model, SoC, firmware, ROM/GSI, Android version, and carrier conditions are stated.
- [ ] Donor artifacts and derived outputs have hashes/provenance.
- [ ] Platform-signing requirement is stated without publishing a key.
- [ ] Module payload is manifest-defined and excludes host tools, logs, keys, and temporary artifacts.
- [ ] Build and module verifiers pass.
- [ ] Validation matrix is attached with pass/fail/partial/untested states.
- [ ] Known limitations and residual SELinux/privilege risks are visible.
- [ ] Emergency behavior is not guaranteed or marketed as safe.
- [ ] Unsupported variants are explicitly listed.
- [ ] Rollback artifact and recovery steps are available.
- [ ] No raw identifiers, PCAPs, private keys, or proprietary blobs are committed without legal review.
```

## Final principle

A reference port is valuable because it shows **how to ask and verify the right questions**. It is dangerous when treated as a box of interchangeable Samsung files.

For every new device, begin again with the target profile, immutable donor evidence, framework contract, dependency ledger, and one-variable experiments. Preserve what works, prove why it works, and document what remains unsupported.
