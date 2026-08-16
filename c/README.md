# `ims_sock_launch` Helper

> 中文文档：[README.zh-CN.md](README.zh-CN.md)

---

## Purpose

`ims_sock_launch.c` is a small init-replacement helper that solves a timing conflict between Magisk magic-mounts and Android's init socket registration. It performs two related tasks:

### 1. Socket Creation and Setup (default mode)

Magisk magic-mounts a module's `/system/etc/init/*.rc` files **after** init has already parsed `/system/etc/init`, so init never registers the `imsd` service and never creates its control socket. The `imsd` daemon then exits immediately with:

```
Obtaining file descriptor socket 'imsd' failed: No such file or directory
```

This is because `imsd` calls `android_get_control_socket("imsd")`, which reads an fd from the environment variable `ANDROID_SOCKET_imsd` that init should have set.

`ims_sock_launch` replicates what init does for a line like:

```
socket imsd stream 0660 system system
```

It:
- Creates an AF_UNIX/SOCK_STREAM socket at `/dev/socket/imsd`
- Binds the socket
- Sets permissions (chmod) and ownership (chown)
- Listens on the socket
- Exports `ANDROID_SOCKET_imsd=<fd>` to the child process's environment
- `exec`s the daemon with the fd inherited (not close-on-exec)

### 2. Privilege Reduction (both modes)

Post-fs-data runs as full root, so a daemon launched directly from there inherits uid 0 and all 38 capabilities — far more than init would grant. `ims_sock_launch` drops to the exact identity the stock `.rc` file specifies:

**From stock `imsd.rc`:**
```
user system
group system radio net_raw inet net_admin
capabilities NET_RAW NET_ADMIN
```

**From stock `multiclientd.rc`:**
```
user radio
group radio cache inet misc log readproc sdcard_rw
(no capabilities line — zero capabilities)
```

## Build

Requires **NDK r26d** to link against bionic (a host `gcc` will not work).

```bash
export NDK=~/ndk-cache/android-ndk-r26d
bash c/build_ims_sock_launch.sh
```

On macOS, also set:
```bash
export NDK_HOST=darwin-x86_64
```

A pre-built binary is already committed at `proprietary_vendor_samsung_ims/proprietary/system/bin/ims_sock_launch`.

## Usage

### Socket mode (for `imsd`)

```bash
ims_sock_launch <sockname> <octal_mode> <sock_uid> <sock_gid> <daemon> [args...]
```

Example (from `post-fs-data.sh`):
```bash
ims_sock_launch imsd 0660 1000 1000 /system/bin/imsd
```

This creates `/dev/socket/imsd` with mode `0660`, owned by uid 1000 (system) and gid 1000 (system), then `exec`s `/system/bin/imsd`.

### No-socket mode (for `multiclientd`)

```bash
ims_sock_launch --no-socket --uid <uid> --gid <gid> [--groups g1,g2,...]
                [--caps CAP_NAME1,CAP_NAME2,...] <daemon> [args...]
```

Example (from `post-fs-data.sh`):
```bash
ims_sock_launch --no-socket --uid 1001 --gid 1001 \
    --groups 1001,2001,3003,9998,1007,3009,1015 \
    /system/bin/multiclientd -s 1
```

This drops privileges (uid, gid, groups, capabilities) without creating a socket, then `exec`s `/system/bin/multiclientd -s 1`.

## SELinux Behavior

**Important:** This helper does **not** change the SELinux domain. On this GSI the binaries are labeled `system_file` and no `imsd_exec` or `multiclientd_exec` type exists in the loaded policy, so the daemons stay in the `magisk` domain.

Unix identity (uid/gid/groups/capabilities) and SELinux domain are independent layers. This tool hardens the layer that can be hardened in the GSI's policy context.

## Debugging and Fallback

Set the environment variable `IMS_SOCK_LAUNCH_NO_DROP=1` to skip the privilege drop and run the daemon as root:

```bash
IMS_SOCK_LAUNCH_NO_DROP=1 ims_sock_launch imsd 0660 1000 1000 /system/bin/imsd
```

This can be useful for diagnostics or to roll back without swapping the binary.

## Execution Path Constraint

The helper must `execv` the daemon from `/system/bin/`, **not** from `/data/adb/`. Here is why:

After `ims_sock_launch` drops from root to an unprivileged uid (e.g., 1001 for `radio`), it can no longer traverse `/data/adb` because that directory is owned by root with `0700` permissions. Any attempt to `exec` a binary from a path inside `/data/adb` fails with `EACCES`.

The checked-in `post-fs-data.sh` correctly uses `/system/bin/imsd` and `/system/bin/multiclientd`. If you need to use a custom binary for testing, copy it to a location under `/system/` where the unprivileged uid has execute permissions.

## Configuration Variables

### `S20VOLTE_MULTICLIENTD_ROOT` (default: 1)

Set in `post-fs-data.sh` to select the privilege-drop mode for `multiclientd`:

```bash
S20VOLTE_MULTICLIENTD_ROOT=1
ims_sock_launch --no-socket --uid 1001 --gid 1001 --groups ... /system/bin/multiclientd -s 1
```

This selects the unprivileged `radio` (uid 1001, zero capabilities) path, as documented.

A value of `0` would run `multiclientd` as root (all 38 capabilities) — a less-secure fallback:

```bash
S20VOLTE_MULTICLIENTD_ROOT=0
# might use: exec /system/bin/multiclientd -s 1
```

The checked-in module sets `S20VOLTE_MULTICLIENTD_ROOT=1` for the hardened default.

## Source

- **Source:** `c/ims_sock_launch.c` (Apache-2.0)
- **Build script:** `c/build_ims_sock_launch.sh`
- **Compiled output:** `proprietary_vendor_samsung_ims/proprietary/system/bin/ims_sock_launch`

This helper is **not** extracted from Samsung firmware; it is original code written for this project.
