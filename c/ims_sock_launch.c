// ims_sock_launch.c
//
// Why this exists:
//   Magisk mounts a module's /system/etc/init/*.rc AFTER init has already parsed
//   /system/etc/init, so init never registers Samsung's `imsd` service and never
//   creates its control socket. imsd then dies with:
//       "Obtaining file descriptor socket 'imsd' failed: No such file or directory"
//   because it calls android_get_control_socket("imsd"), which reads the fd from the
//   env var ANDROID_SOCKET_imsd that init normally sets.
//
//   This tiny helper replicates what init does for a
//       `socket imsd stream <mode> <uid> <gid>`
//   line: create an AF_UNIX/SOCK_STREAM socket at /dev/socket/<name>, bind, chmod/chown,
//   listen, export ANDROID_SOCKET_<name>=<fd>, then exec the daemon (fd is inherited,
//   not close-on-exec).
//
//   In addition it reproduces the *process identity* init would give the daemon from its
//   stock .rc file. post-fs-data.sh runs as full root, so a daemon launched directly from
//   there inherits uid 0 and every capability — far more than init would ever grant it.
//
//   Stock imsd.rc:
//       user system / group system radio net_raw inet net_admin
//       capabilities NET_RAW NET_ADMIN
//   Stock multiclientd.rc:
//       user radio / group radio cache inet misc log readproc sdcard_rw
//       (no capabilities line -> no capabilities at all)
//
//   NOTE: this helper does NOT change the SELinux domain: on this GSI the binaries are
//   labelled system_file and no imsd_exec / imsd domain transition exists in the loaded
//   policy, so the daemons stay in the magisk domain (a documented GSI-specific difference).
//   Set IMS_SOCK_LAUNCH_NO_DROP=1 in the environment to skip the identity drop (rollback /
//   A-B without swapping the binary) — the daemon then runs as root, as before.
//
// Build (pick one):
//   NDK (preferred):      $NDK/toolchains/llvm/prebuilt/*/bin/aarch64-linux-android30-clang \
//                             -O2 ims_sock_launch.c -o ims_sock_launch
//   On device (Termux):   pkg install clang && clang -O2 ims_sock_launch.c -o ims_sock_launch
//
// Usage:
//   Socket mode (unchanged, used by imsd):
//     ims_sock_launch <sockname> <octal_mode> <sock_uid> <sock_gid> <daemon> [args...]
//     e.g.  ims_sock_launch imsd 0660 1000 1000 /system/bin/imsd
//
//   No-socket mode (drop privileges only, used by multiclientd):
//     ims_sock_launch --no-socket --uid <uid> --gid <gid> [--groups g1,g2,...]
//                     [--caps NET_RAW,NET_ADMIN] <daemon> [args...]
//     e.g.  ims_sock_launch --no-socket --uid 1001 --gid 1001 \
//               --groups 1001,2001,3003,9998,1007,3009,1015 /system/bin/multiclientd -s 1
//
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <grp.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/stat.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <linux/capability.h>

/* Android AID constants (stock imsd.rc: group system radio net_raw inet net_admin). */
#define AID_SYSTEM     1000
#define AID_RADIO      1001
#define AID_INET       3003
#define AID_NET_RAW    3004
#define AID_NET_ADMIN  3005

/* Capability bit numbers (imsd.rc: capabilities NET_RAW NET_ADMIN). */
#ifndef CAP_NET_ADMIN
#define CAP_NET_ADMIN 12
#endif
#ifndef CAP_NET_RAW
#define CAP_NET_RAW 13
#endif

#define MAX_GROUPS 32

/* Put the requested caps into inheritable while we still have full root capabilities.
   This must happen before setuid(): after PR_SET_KEEPCAPS + setuid, the kernel clears
   effective caps; adding new inheritable caps at that point can fail with EPERM. */
static int seed_caps_inheritable(unsigned mask) {
    struct __user_cap_header_struct hdr;
    struct __user_cap_data_struct   data[2];
    memset(&hdr, 0, sizeof(hdr));
    memset(data, 0, sizeof(data));
    hdr.version = _LINUX_CAPABILITY_VERSION_3;
    hdr.pid     = 0; /* self */
    if (syscall(SYS_capget, &hdr, data) < 0) {
        fprintf(stderr, "capget: %s\n", strerror(errno));
        return -1;
    }
    data[0].inheritable |= mask;
    if (syscall(SYS_capset, &hdr, data) < 0) {
        fprintf(stderr, "capset inheritable: %s\n", strerror(errno));
        return -1;
    }
    return 0;
}

/* After setuid(), PR_SET_KEEPCAPS preserves permitted caps but clears effective caps.
   Reduce permitted/effective/inheritable to exactly `mask` (may be 0 = drop everything). */
static int set_caps(unsigned mask) {
    struct __user_cap_header_struct hdr;
    struct __user_cap_data_struct   data[2];
    memset(&hdr, 0, sizeof(hdr));
    memset(data, 0, sizeof(data));
    hdr.version = _LINUX_CAPABILITY_VERSION_3;
    hdr.pid     = 0; /* self */
    data[0].effective   = mask;
    data[0].permitted   = mask;
    data[0].inheritable = mask;
    if (syscall(SYS_capset, &hdr, data) < 0) {
        fprintf(stderr, "capset: %s\n", strerror(errno));
        return -1;
    }
    return 0;
}

/* Reproduce a stock init service identity. Called while still root (has CAP_SETUID/SETGID/
   SETPCAP). Returns 0 on success; on failure prints errno and returns -1 (fatal to caller).
   caps_mask may be 0, which drops every capability — that is what a stock .rc with no
   `capabilities` line gives the service. */
static int drop_to_identity(uid_t uid, gid_t gid,
                            const gid_t* groups, size_t ngroups,
                            unsigned caps_mask) {
    if (setgroups(ngroups, groups) < 0) {
        fprintf(stderr, "setgroups: %s\n", strerror(errno));
        return -1;
    }
    if (caps_mask != 0 && seed_caps_inheritable(caps_mask) < 0) {
        return -1;
    }
    /* Keep permitted caps across the setuid() to non-root. */
    if (prctl(PR_SET_KEEPCAPS, 1, 0, 0, 0) < 0) {
        fprintf(stderr, "PR_SET_KEEPCAPS: %s\n", strerror(errno));
        return -1;
    }
    if (setresgid(gid, gid, gid) < 0) {
        fprintf(stderr, "setresgid: %s\n", strerror(errno));
        return -1;
    }
    if (setresuid(uid, uid, uid) < 0) {
        fprintf(stderr, "setresuid: %s\n", strerror(errno));
        return -1;
    }
    /* After setuid() to non-root, effective caps are cleared; re-assert permitted/effective
       and set inheritable so we can raise them into the ambient set. */
    if (set_caps(caps_mask) < 0) {
        return -1;
    }
    /* Ambient caps survive execve of a non-root binary that has no file capabilities;
       without this, the daemon would start with empty effective/permitted caps. Requires
       each cap to be in both permitted and inheritable (set above). */
    if (caps_mask & (1u << CAP_NET_RAW)) {
        if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_NET_RAW, 0, 0) < 0) {
            fprintf(stderr, "PR_CAP_AMBIENT_RAISE NET_RAW: %s\n", strerror(errno));
            return -1;
        }
    }
    if (caps_mask & (1u << CAP_NET_ADMIN)) {
        if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_NET_ADMIN, 0, 0) < 0) {
            fprintf(stderr, "PR_CAP_AMBIENT_RAISE NET_ADMIN: %s\n", strerror(errno));
            return -1;
        }
    }
    return 0;
}

/* Stock imsd.rc identity, kept as a named wrapper so the socket path below reads the same
   as it always has. */
static int drop_to_stock_imsd_identity(void) {
    gid_t groups[] = { AID_SYSTEM, AID_RADIO, AID_INET, AID_NET_RAW, AID_NET_ADMIN };
    unsigned mask = (1u << CAP_NET_RAW) | (1u << CAP_NET_ADMIN); /* 0x3000 */
    return drop_to_identity(AID_SYSTEM, AID_SYSTEM,
                            groups, sizeof(groups) / sizeof(groups[0]), mask);
}

static int parse_group_list(const char* s, gid_t* out, size_t max, size_t* n) {
    size_t count = 0;
    const char* p = s;
    while (*p) {
        char* end = NULL;
        long v = strtol(p, &end, 10);
        if (end == p) {
            fprintf(stderr, "bad group list near '%s'\n", p);
            return -1;
        }
        if (count >= max) {
            fprintf(stderr, "too many groups (max %zu)\n", max);
            return -1;
        }
        out[count++] = (gid_t)v;
        p = end;
        if (*p == ',') p++;
        else if (*p) {
            fprintf(stderr, "bad separator in group list near '%s'\n", p);
            return -1;
        }
    }
    *n = count;
    return 0;
}

/* --no-socket: drop privileges to an arbitrary stock identity and exec. No socket is created
   and no ANDROID_SOCKET_* is exported — for daemons like multiclientd that make their own
   (abstract) sockets but would otherwise inherit post-fs-data's full root. */
static int run_no_socket(int argc, char** argv) {
    uid_t uid = 0;
    gid_t gid = 0;
    int have_uid = 0, have_gid = 0;
    gid_t groups[MAX_GROUPS];
    size_t ngroups = 0;
    unsigned caps_mask = 0; /* default: no capabilities, matching an .rc with no caps line */
    int i = 2;              /* argv[1] == "--no-socket" */

    for (; i < argc; i++) {
        if (strcmp(argv[i], "--uid") == 0 && i + 1 < argc) {
            uid = (uid_t)atoi(argv[++i]); have_uid = 1;
        } else if (strcmp(argv[i], "--gid") == 0 && i + 1 < argc) {
            gid = (gid_t)atoi(argv[++i]); have_gid = 1;
        } else if (strcmp(argv[i], "--groups") == 0 && i + 1 < argc) {
            if (parse_group_list(argv[++i], groups, MAX_GROUPS, &ngroups) < 0) return 2;
        } else if (strcmp(argv[i], "--caps") == 0 && i + 1 < argc) {
            const char* c = argv[++i];
            if (strstr(c, "NET_RAW"))   caps_mask |= (1u << CAP_NET_RAW);
            if (strstr(c, "NET_ADMIN")) caps_mask |= (1u << CAP_NET_ADMIN);
        } else {
            break; /* first non-option is the daemon path */
        }
    }

    if (!have_uid || !have_gid || i >= argc) {
        fprintf(stderr,
                "usage: %s --no-socket --uid <uid> --gid <gid> [--groups g1,g2,...] "
                "[--caps NET_RAW,NET_ADMIN] <daemon> [args...]\n", argv[0]);
        return 2;
    }
    /* With no --groups, fall back to the primary gid so setgroups() still clears root's. */
    if (ngroups == 0) { groups[0] = gid; ngroups = 1; }

    if (getenv("IMS_SOCK_LAUNCH_NO_DROP") == NULL) {
        if (drop_to_identity(uid, gid, groups, ngroups, caps_mask) < 0) {
            fprintf(stderr, "identity drop failed; not exec'ing %s\n", argv[i]);
            return 1; /* fatal: let the supervisor retry rather than run half-privileged */
        }
    }

    execv(argv[i], &argv[i]);
    perror("execv"); /* only reached on failure */
    return 1;
}

int main(int argc, char** argv) {
    if (argc >= 2 && strcmp(argv[1], "--no-socket") == 0) {
        return run_no_socket(argc, argv);
    }

    if (argc < 6) {
        fprintf(stderr, "usage: %s <sockname> <octal_mode> <uid> <gid> <daemon> [args...]\n", argv[0]);
        fprintf(stderr, "       %s --no-socket --uid <uid> --gid <gid> [--groups g1,g2,...] "
                        "[--caps NET_RAW,NET_ADMIN] <daemon> [args...]\n", argv[0]);
        return 2;
    }
    const char* name = argv[1];
    long  mode = strtol(argv[2], NULL, 8);
    int   uid  = atoi(argv[3]);
    int   gid  = atoi(argv[4]);

    char path[108];
    snprintf(path, sizeof(path), "/dev/socket/%s", name);
    unlink(path); /* clear any stale node */

    int fd = socket(AF_UNIX, SOCK_STREAM, 0); /* not SOCK_CLOEXEC -> survives exec */
    if (fd < 0) { perror("socket"); return 1; }

    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, path, sizeof(addr.sun_path) - 1);
    if (bind(fd, (struct sockaddr*)&addr, sizeof(addr)) < 0) { perror("bind"); return 1; }

    chmod(path, (mode_t)mode);
    if (chown(path, uid, gid) < 0) perror("chown"); /* non-fatal */

    if (listen(fd, 8) < 0) { perror("listen"); return 1; }

    char key[128], val[16];
    snprintf(key, sizeof(key), "ANDROID_SOCKET_%s", name);
    snprintf(val, sizeof(val), "%d", fd);
    setenv(key, val, 1);

    /* Drop from root to stock imsd identity unless explicitly disabled. Do this AFTER the
       socket is created/owned (needs root for chown) and the env var is exported, but
       BEFORE exec so imsd inherits the correct uid/gid/groups/caps. */
    if (getenv("IMS_SOCK_LAUNCH_NO_DROP") == NULL) {
        if (drop_to_stock_imsd_identity() < 0) {
            fprintf(stderr, "identity drop failed; not exec'ing %s\n", argv[5]);
            return 1; /* fatal: let the supervisor retry rather than run half-privileged */
        }
    }

    execv(argv[5], &argv[5]);
    perror("execv"); /* only reached on failure */
    return 1;
}
