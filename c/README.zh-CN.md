# `ims_sock_launch` 辅助工具

> English documentation: [README.md](README.md)

---

## 目的

`ims_sock_launch.c` 是一个小的 init 替代辅助工具，解决 Magisk 魔法挂载和 Android init socket 注册之间的时序冲突。它执行两个相关任务：

### 1. Socket 创建和设置（默认模式）

Magisk 魔法挂载一个模块的 `/system/etc/init/*.rc` 文件**之后** init 已经解析了 `/system/etc/init`，所以 init 从不注册 `imsd` 服务，也不创建其控制 socket。`imsd` 守护进程随即立即以下面的消息退出：

```
Obtaining file descriptor socket 'imsd' failed: No such file or directory
```

这是因为 `imsd` 调用 `android_get_control_socket("imsd")`，从环境变量 `ANDROID_SOCKET_imsd` 读 fd，init 本应已设置它。

`ims_sock_launch` 复制 init 为一行如下的工作：

```
socket imsd stream 0660 system system
```

它：
- 在 `/dev/socket/imsd` 创建一个 AF_UNIX/SOCK_STREAM socket
- 绑定 socket
- 设置权限（chmod）和所有者（chown）
- 在 socket 上监听
- 导出 `ANDROID_SOCKET_imsd=<fd>` 到子进程的环境
- `exec` 守护进程，fd 被继承（不 close-on-exec）

### 2. 权限降低（两种模式）

Post-fs-data 以全 root 运行，所以直接从那里启动的守护进程继承 uid 0 和所有 38 个能力 —— 远超过 init 会授予的。`ims_sock_launch` 降到原厂 `.rc` 文件指定的精确身份：

**从原厂 `imsd.rc`：**
```
user system
group system radio net_raw inet net_admin
capabilities NET_RAW NET_ADMIN
```

**从原厂 `multiclientd.rc`：**
```
user radio
group radio cache inet misc log readproc sdcard_rw
(没有 capabilities 行 —— 零能力)
```

## 构建

需要 **NDK r26d** 来针对 bionic 链接（主机 `gcc` 不行）。

```bash
export NDK=~/ndk-cache/android-ndk-r26d
bash c/build_ims_sock_launch.sh
```

在 macOS 上，还要设置：
```bash
export NDK_HOST=darwin-x86_64
```

预构建的二进制已经提交在 `proprietary_vendor_samsung_ims/proprietary/system/bin/ims_sock_launch`。

## 用法

### Socket 模式（用于 `imsd`）

```bash
ims_sock_launch <sockname> <octal_mode> <sock_uid> <sock_gid> <daemon> [args...]
```

示例（来自 `post-fs-data.sh`）：
```bash
ims_sock_launch imsd 0660 1000 1000 /system/bin/imsd
```

这创建 `/dev/socket/imsd`，模式为 `0660`，由 uid 1000（system）和 gid 1000（system）所有，然后 `exec` `/system/bin/imsd`。

### 不使用 socket 模式（用于 `multiclientd`）

```bash
ims_sock_launch --no-socket --uid <uid> --gid <gid> [--groups g1,g2,...]
                [--caps CAP_NAME1,CAP_NAME2,...] <daemon> [args...]
```

示例（来自 `post-fs-data.sh`）：
```bash
ims_sock_launch --no-socket --uid 1001 --gid 1001 \
    --groups 1001,2001,3003,9998,1007,3009,1015 \
    /system/bin/multiclientd -s 1
```

这降低权限（uid、gid、groups、能力）而不创建 socket，然后 `exec` `/system/bin/multiclientd -s 1`。

## SELinux 行为

**重要：** 此辅助工具**不会**改变 SELinux 域。在此 GSI 上二进制被标记为 `system_file`，加载的策略中不存在 `imsd_exec` 或 `multiclientd_exec` 类型，所以守护进程停留在 `magisk` 域。

Unix 身份（uid/gid/groups/能力）和 SELinux 域是独立的层。此工具在 GSI 策略上下文中能被硬化的层上硬化。

## 调试和备选方案

设置环境变量 `IMS_SOCK_LAUNCH_NO_DROP=1` 来跳过权限降低并以 root 身份运行守护进程：

```bash
IMS_SOCK_LAUNCH_NO_DROP=1 ims_sock_launch imsd 0660 1000 1000 /system/bin/imsd
```

这可用于诊断或不交换二进制的回滚。

## 执行路径约束

辅助工具必须从 `/system/bin/` `execv` 守护进程，**而不是**从 `/data/adb/`。原因是：

在 `ims_sock_launch` 从 root 降到无特权 uid（例如 1001 代表 `radio`）后，它无法再遍历 `/data/adb`，因为那个目录由 root 所有，权限为 `0700`。任何尝试从 `/data/adb` 内某路径 `exec` 二进制都失败，错误为 `EACCES`。

签入的 `post-fs-data.sh` 正确使用 `/system/bin/imsd` 和 `/system/bin/multiclientd`。如果你需要使用自定义二进制进行测试，把它复制到 `/system/` 下某个位置，其中无特权 uid 有执行权限。

## 配置变量

### `S20VOLTE_MULTICLIENTD_ROOT`（默认：1）

在 `post-fs-data.sh` 中设置以为 `multiclientd` 选择权限降低模式：

```bash
S20VOLTE_MULTICLIENTD_ROOT=1
ims_sock_launch --no-socket --uid 1001 --gid 1001 --groups ... /system/bin/multiclientd -s 1
```

这选择无特权 `radio`（uid 1001，零能力）路径，如文档记录的。

值为 `0` 会以 root 身份运行 `multiclientd`（所有 38 个能力） —— 一个安全性较低的备选方案：

```bash
S20VOLTE_MULTICLIENTD_ROOT=0
# 可能使用：exec /system/bin/multiclientd -s 1
```

签入的模块设置 `S20VOLTE_MULTICLIENTD_ROOT=1` 作为硬化默认。

## 源

- **源代码：** `c/ims_sock_launch.c`（Apache-2.0）
- **构建脚本：** `c/build_ims_sock_launch.sh`
- **编译输出：** `proprietary_vendor_samsung_ims/proprietary/system/bin/ims_sock_launch`

此辅助工具**不是**从 Samsung 固件提取的；它是为本项目编写的原创代码。
