# `imsmanager.jar` GSI 兼容性覆盖

> English documentation: [README.md](README.md)

---

Samsung 的原厂 `imsmanager.jar` 期望目标 Android 13 GSI 上不存在的框架 API。恢复原厂 JAR 会导致 IMS 注册失败。本目录在不修改 Samsung 原始主 DEX 的情况下复现最小兼容性修改。

```text
原厂 imsmanager.jar
├── classes.dex       未改的 Samsung 主 DEX
└── classes2.dex      本项目添加：五个兼容性 stub
```

注入的类为：

```text
android.os.SemSystemProperties
com.samsung.android.emergencymode.SemEmergencyConstants
com.samsung.android.feature.SemCscFeature
com.samsung.android.feature.SemFloatingFeature
com.samsung.android.wifi.SemWifiManager
```

## 在本地构建

输入 JAR 必须从支持的 G981NKSU1HVJG 系统镜像在本地提取。原始 Samsung JAR 和新派生的 JAR 都不属于此源目录或 Git。

```bash
bash imsmanager-compat/build.sh --input /path/to/your/imsmanager.jar --output out/imsmanager.jar
```

```bash
bash imsmanager-compat/verify.sh out/imsmanager.jar
```

构建器验证源 JAR 哈希、从 `stub-apk/` 构建五 stub DEX、将输入复制到请求的输出路径、仅注入 `classes2.dex`。验证器要求原厂 `classes.dex` 保持字节一致并验证确切的五类 payload。

全 JAR 哈希可能与历史输出不同，因为 ZIP 元数据可能有所不同；两个 DEX payload 哈希和类描述符是兼容性契约。

## 在 Magisk 模块中打包

使用派生的本地 JAR 显式；不要覆盖 `proprietary_vendor_samsung_ims/` 下提交的已知良好基线：

```bash
bash magisk-module/build_module.sh --imsmanager out/imsmanager.jar out/S20_VoLTE_IMS.zip
```

模块构建器在暂存前验证本地 JAR 并在从最终 ZIP 提取后再次验证。
