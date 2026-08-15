# S20 IMS 包选择 RRO

> English: [S20 IMS package-selection RRO](README.md)

此目录保存 `S20VoLTEImsOverlay.apk` 的**项目自研源码**。该 APK 是由 Magisk 模块打包的 static runtime resource overlay（RRO），不是三星固件，且不包含 Java、Kotlin、native code 或 DEX 文件。

## 作用

AOSP Telephony 通过 framework resource 选择 IMS 实现。在已记录的 S20 / Android 13 GSI 目标上，此 RRO overlay `com.android.phone`，使 `ImsResolver` 选择三星 `com.sec.imsservice`：

| 被覆盖资源 | 值 |
|---|---|
| `config_ims_mmtel_package` | `com.sec.imsservice` |
| `config_ims_rcs_package` | `com.sec.imsservice` |

该 overlay 不实现 IMS、不修改 `imsservice.apk`、不添加三星 API、不启动 daemon，也不放宽 SELinux。它只解决[架构与兼容性模型](../docs/ARCHITECTURE.zh-CN.md)中所述的 framework package-selection 边界。

## S20 专属 overlay 契约

| 属性 | 值 |
|---|---|
| APK package | `com.s20volte.imsoverlay` |
| Target package | `com.android.phone` |
| Overlay mode | Static runtime resource overlay |
| Priority | `9999` |
| Application code | 无（`android:hasCode="false"`） |
| API build 值 | min SDK 30；target SDK 33 |
| Canonical payload 路径 | `proprietary_vendor_samsung_ims/proprietary/system/product/overlay/S20VoLTEImsOverlay.apk` |
| Magisk 安装路径 | `/system/product/overlay/S20VoLTEImsOverlay.apk` |

此契约只在仓库已记录的 S20 Android 13 基线上验证。**不能因为另一台设备同样是三星设备，就把此 RRO 复制过去。** 其他目标可能使用不同 resource name、target package、overlay policy、API level、signing requirement、package name 或 IMS framework path。

若要为其他目标适配，应先遵循[跨设备三星 IMS 移植指南](../docs/CROSS_DEVICE_PORTING_GUIDE.zh-CN.md)：检查 target `framework-res.apk`、`ImsResolver` selection 行为、overlayable policy、已安装 overlay、target package 和被接受的 signing identity。

## 源码结构

```text
rro/
├── AndroidManifest.xml       Static RRO package 与 target 声明
├── res/values/config.xml     两个 IMS package resource override
├── build.sh                  构建以及结构/签名/resource 验证
├── README.md                 英文说明
└── README.zh-CN.md           本文
```

`build.sh` 有意作为唯一 RRO 构建入口；它会在构建后完成验证，因此没有独立的 `verify.sh`。

## 前置条件

请使用 WSL 或其他 POSIX 兼容 Bash 环境，并提供本地、未跟踪的输入：

1. Android SDK Build-Tools **33.0.3**：`aapt2`、`aapt`、`zipalign` 和 `apksigner`。
2. 与预期 target ROM/release 匹配的 `framework-res.apk`。
3. 该 ROM overlay/signature policy 接受的私钥（`.pk8`）和证书（`.x509.pem`）。

加载项目环境后，工具默认位于 `${SDK_HOME}/build-tools/33.0.3`。未加载环境时，脚本会回退到 `tools/android-sdk/build-tools/33.0.3` 下的本地 ignored cache。可通过 `AAPT2`、`AAPT`、`ZIPALIGN`、`APKSIGNER` 覆盖单个工具路径，或通过 `RRO_BUILD_TOOLS` 覆盖整个目录。

不要提交 `framework-res.apk`、SDK 内容、私钥、证书、临时 `.flat` 文件、unsigned/aligned APK 或 `.idsig` 文件。仓库的 [`.gitignore`](../.gitignore) 和[工具说明](../tools/README.md)定义了本地输入边界。

## 构建实验 APK

应先构建到新的外部输出路径。除非提供 `--force`，脚本会拒绝覆盖已有输出。

```bash
bash rro/build.sh \
  --framework-res /path/to/target/system/framework/framework-res.apk \
  --key /path/to/platform.pk8 \
  --cert /path/to/platform.x509.pem \
  --output out/S20VoLTEImsOverlay.apk
```

传入的 `framework-res.apk` 必须包含两个 target resource name。任何一个缺失时，脚本都会在构建前停止：

```text
config_ims_mmtel_package
config_ims_rcs_package
```

在已记录 S20 上可用的 framework 或 signing identity 不会自动适用于其他 ROM。

## `build.sh` 验证的内容

脚本只有在以下全部通过后才报告成功：

- source manifest/resource、framework resource APK、key、certificate 和 build tool 都存在；
- `framework-res.apk` 声明两个被覆盖 resource name；
- output 已按 4-byte 对齐；
- APK signature verification 成功；
- package 为 `com.s20volte.imsoverlay`；
- min SDK 为 30，target SDK 为 33；
- manifest target 为 `com.android.phone`，声明 static overlay，priority 为 `9999`；
- compiled resource table 包含两个 IMS resource name 与 `com.sec.imsservice`；
- APK 不含 `classes*.dex` entry；
- 输出 SHA-256 与 signer information 会打印出来。

这些检查只证明 artifact structure；它们不能证明 target framework 接受该 overlay、选择 intended IMS package 或完成 IMS registration。必须分别在设备上验证这些条件。

## 更新 canonical module payload

被跟踪的 canonical overlay 由 Magisk payload manifest 消费：

```text
proprietary_vendor_samsung_ims/proprietary/system/product/overlay/S20VoLTEImsOverlay.apk
```

不得手工替换该 APK。若有意将 source change 更新为 baseline：

1. 先构建并检查外部 experimental APK。
2. 审阅后，使用 `--force` 明确重建到 canonical payload path：

   ```bash
   bash rro/build.sh \
     --framework-res /path/to/framework-res.apk \
     --key /path/to/platform.pk8 \
     --cert /path/to/platform.x509.pem \
     --output proprietary_vendor_samsung_ims/proprietary/system/product/overlay/S20VoLTEImsOverlay.apk \
     --force
   ```

3. 若 hash 变化，只更新 [`magisk-module/payload-manifest.tsv`](../magisk-module/payload-manifest.tsv) 中 `product/overlay/S20VoLTEImsOverlay.apk` 对应的 `project-added` SHA-256 项。
4. 按 [magisk-module/README.md](../magisk-module/README.md) 执行既有 payload/module validation workflow。

payload manifest 仍是 package authority。`magisk-module/build_module.sh` 应继续负责 staging/validation final module ZIP；`rro/build.sh` 不会自动把 APK 复制到 Magisk staging directory。

## 部署与竞争 overlay

模块将该 artifact 安装到 `/system/product/overlay/S20VoLTEImsOverlay.apk`，`post-fs-data.sh` 会设定 owner 为 `root:root`、mode 为 `0644`。

在已记录的 LineageOS 派生目标上，`flossims_telephony` 这类 mutable IMS overlay 可能选择其他 package，从而阻止 `com.sec.imsservice` 被使用。在调试 bridge、daemon 或 radio 行为前，应先确定 target device 上实际选中的 overlay/package。static RRO 行为和 `cmd overlay` 控制取决于 policy；不能假设 static overlay 可以在运行时开关。

支持的 S20 范围见 [README.zh-CN.md](../README.zh-CN.md)，最终 artifact workflow 见 [BUILD.md](../BUILD.md)，module packaging 见 [magisk-module/README.md](../magisk-module/README.md)。
