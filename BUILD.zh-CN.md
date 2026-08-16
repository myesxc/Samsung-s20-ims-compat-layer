# 四 DEX APK 构建

> English documentation: [BUILD.md](BUILD.md)

---

历史上 S20 移植是一个**四 DEX 应用**。之前的公开构建流程只重建了原厂主 DEX，生成了可以安装并正确签名的 APK，但无法注册 IMS。不要将 `smali_patch.diff` 加 `smali_out/` 用作独立的 APK 构建流程。

构建脚本在内部应用两个阶段、把跟踪的 Java 桥接编译到私有临时 smali 树、注入到主 DEX，最后只输出最终的 desem81 兼容 APK：

```text
原厂 APK → stock-to-desem5 兼容性修改 → desem5-to-desem81 修改 → 编译并注入 Java 桥接 smali → 最终 APK
```

`desem5` 是一个补丁边界和验证参考，**不是**普通构建者需要创建、保留、安装或签名的输出物。最终构建在其私有临时解码树内部经过这个状态。

本目录包含有序的标准主 smali 阶段：

1. `patches/stock-to-desem5.patch` —— 应用历史性的原厂兼容性工作。
2. `patches/desem5-to-desem81.patch` —— 应用验证过的现代 IMS、通话、媒体、短信、紧急以及更晚期的修复。

次级 DEX payload 在后期构建中保持不变：

| 输入 | 用途 | SHA-256 | 源策略 |
|---|---|---|---|
| `classes2.dex` | Gson 兼容性 payload（204 个类） | `a7c3fc1efd5bb8d00bbce9937cd79c51a8d9d417e347caff81de849d8bf57132` | 历史本地兼容性输入；其确切的原始 Gson 构建尚未重建。 |
| `classes3.dex` | Samsung IMS 框架 API（120 个类） | `3dbe49e57ace872dd49281bf0d22a84067aedb468898031998e88f572f608b54` | 从匹配的 Samsung `framework.jar` 在本地派生；不要以项目编著代码的名义提交或发布它。 |
| `classes4.dex` | VSIM/softphone stub（12 个类） | `8936e2be6b023191fc9c309b07655b66f009ff55d470798441a049109d99da79` | 从跟踪的 [`vsim_stub/`](vsim_stub/) 构建。 |

所有本地依赖都属于 `build-inputs/`，已被 git 忽略。

## 完整的 WSL 构建流程

下面的命令只创建最终的 `out/imsservice.apk`；所有解码和补丁目录都在临时目录下创建并自动删除。

### 1. 进入仓库并加载本地工具

```bash
cd Samsung-s20-ims-compat-layer
```

```bash
source tools/env.sh
```

下面的 Java 桥接编译是一个维护者可复现性检查：它重新生成跟踪的 `smali_out/` 快照并必须仍然产生 32 个 smali 文件。普通的最终 APK 构建在私有临时目录中运行相同的编译，并在注入前验证它与该快照匹配。

```bash
bash build.sh
```

### 2. 准备本地的、被忽略的兼容性输入

```bash
mkdir -p build-inputs out
```

把已知的历史 Gson payload 放在 `build-inputs/classes2.dex`。从跟踪的源构建 VSIM payload：

```bash
bash build/deps/build_classes4.sh build-inputs/classes4.dex
```

`classes3.dex` 必须是标准的 Samsung 框架 payload。在历史 `dx` 工具链被打包并锁定之前，把本地验证过的历史 payload 复制到 `build-inputs/classes3.dex`；汇编脚本会在使用前验证其 SHA-256。

### 3. 验证原厂 APK

```bash
bash build/verify_input.sh /path/to/imsservice.apk
```

这必须报告文档记录的 G981NKSU1HVJG SHA-256 和恰好一个 `classes.dex`。如果失败，停在这里；不要使用另一个 Samsung 构建、A21 artifact 或之前打过补丁的 APK。

### 4. 用一条命令汇编和签名最终 APK

```bash
bash build/build_apk.sh --sign /path/to/imsservice.apk out/imsservice.apk
```

脚本在其私有临时目录中应用两个补丁阶段、在该处编译 Java 桥接源并将结果 smali 注入主 DEX、注入并哈希三个稳定次级 DEX payload、zipalign、用本地 `tools/keys/platform.{pk8,x509.pem}` 签名，然后删除中间文件。

若要在签名前检查构建，省略 `--sign`；输出是未签名的，绝不能作为系统包安装。

### 5. 再次验证最终 artifact

```bash
bash build/verify_apk.sh final out/imsservice.apk
```

预期属性：

```text
classes.dex
classes2.dex
classes3.dex
classes4.dex
GoogleModernImsService / GoogleModernMmTelFeature / GoogleModernRegistration 存在
次级 DEX 文件中分别有 204 / 120 / 12 个类
```

### 6. 安全部署

仅替换 Magisk 模块副本中的 IMS APK，保留最后验证过的模块 ZIP，刷入测试 ZIP，并重启两次。不要使用 `setenforce 0`；Samsung RKP 会在全局 SELinux enforce 位被清除时强制重启。第二次开机后，在拨打任何紧急电话前确认 IMS 注册。仅使用文档记录的测试紧急路由，并保留另一种到达紧急服务的方式。

## 完整的发布构建

在准备好下面描述的本地四 DEX 输入和平台签名密钥后，根级协调器执行完整发布路径：原厂 APK 验证和转换、`imsmanager.jar` 兼容性派生及验证的 Magisk ZIP 打包。

```bash
bash build.sh release --stock-apk /path/to/mount_system/system/priv-app/imsservice/imsservice.apk --stock-system /path/to/mount_system/system --output-dir out/release --sign
```

它拒绝覆盖现有的发布 artifact。成功时，`out/release/` 仅包含：

```text
imsservice.apk
imsmanager.jar
S20_VoLTE_IMS.zip
```

普通的 `bash build.sh` 仍然是仅维护者的 Java 桥接快照命令；它重新生成 `smali_out/`，不构建 APK、JAR 或模块。


仅支持从 Samsung `G981NKSU1HVJG`（SM-G981N）提取的 IMS APK：

```text
SHA-256: c1cbb451cbbfdb967fa8fb98ef35aea545eff13ea546e4b09c936b690308db3c
DEX:     仅 classes.dex
```

构建前验证它：

```bash
source tools/env.sh
bash build/verify_input.sh /path/to/imsservice.apk
```

## 本地依赖参考

完整命令在上面的流程中。本节作为简短参考保留：

- `build-inputs/classes2.dex` 是一个验证过的历史 Gson 兼容性 payload。
- `build-inputs/classes3.dex` 是验证过的 Samsung 框架兼容性 payload。
- `build-inputs/classes4.dex` 由 `build/deps/build_classes4.sh` 从 `vsim_stub/` 构建。
- `build/build_apk.sh [--sign] <stock-imsservice.apk> <output.apk>` 总是直接从原厂生成最终四 DEX desem81 兼容输出。

## `imsmanager.jar` 兼容性覆盖

这与 APK 的 204 类 Gson `classes2.dex` 分开：`imsmanager.jar` 保留其原始 Samsung `classes.dex` 并接收一个包含五个 GSI 兼容性 stub 的 `classes2.dex`：`SemSystemProperties`、`SemEmergencyConstants`、`SemCscFeature`、`SemFloatingFeature` 和 `SemWifiManager`。在验证的 Android 13 目标上恢复纯原厂 JAR 会破坏 IMS 注册。

仅从本地原厂固件提取构建派生 JAR：

```bash
bash imsmanager-compat/build.sh --input /path/to/your/imsmanager.jar --output out/imsmanager.jar
```

```bash
bash imsmanager-compat/verify.sh out/imsmanager.jar
```

用 `--imsmanager out/imsmanager.jar` 传给模块构建器；不要覆盖 `proprietary_vendor_samsung_ims/` 下跟踪的基线 JAR。

## Magisk 模块包

模块 payload 不是手工汇编的。它由 [`magisk-module/payload-manifest.tsv`](magisk-module/payload-manifest.tsv) 定义：56 个原厂一致文件、两个项目附加、一个必需兼容性覆盖及打好补丁的四 DEX APK。用以下命令构建和验证：

```bash
bash magisk-module/verify_payload.sh /path/to/mounted/system
```

```bash
bash magisk-module/build_module.sh --stock-root /path/to/mounted/system out/S20_VoLTE_IMS.zip
```

仅对已经通过 `build/verify_apk.sh final` 的显式重建 artifact 使用 `--apk out/imsservice.apk`。构建器再次验证它、暂存恰好 payload-manifest `system/` 文件、检查发出的 ZIP，并排除 `.idsig`、密钥、采集、构建源和主机工具。

## 可复现性范围

脚本验证**功能结构**：有序补丁、全部四个 DEX 文件、稳定次级 DEX 哈希、预期类集、现代清单绑定及关键兼容性移除。由于 apktool/D8/ZIP 压缩/签名元数据可能改变字节，它们不声称字节一致的 APK 输出。

`build/maintenance/generate_stage_patches.sh` 仅用于维护。它从本地可用的解码原厂、desem5 和 desem81 参考树重新生成标准补丁；那些专有参考树不是公开仓库的一部分。
