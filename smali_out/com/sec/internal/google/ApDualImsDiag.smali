.class public final Lcom/sec/internal/google/ApDualImsDiag;
.super Ljava/lang/Object;
.source "ApDualImsDiag.java"

.field private final static FEATURE:Ljava/lang/String; = "SEC_FLOATING_FEATURE_COMMON_CONFIG_DUAL_IMS"

.field private final static FLOATING:Ljava/lang/String; = "com.samsung.android.feature.SemFloatingFeature"

.field private final static OVERRIDE_PROP:Ljava/lang/String; = "persist.vendor.ims.ap_dual_ims_override"

.field private final static SIM_UTIL:Ljava/lang/String; = "com.sec.internal.helper.SimUtil"

.field private final static TAG:Ljava/lang/String; = "AP_DUAL_IMS"

.field private static lastUaEffective:I

.field private static lastUaElapsedMs:J

.field private static lastUaOriginal:I

.field private static lastUaWritten:I

.field private static overrideEnabledAtUa:Z

.field private static uaConfigCalls:I

.method static constructor <clinit>()V
  .registers 2
  .line 14
    const/4 v0, -1
    sput v0, Lcom/sec/internal/google/ApDualImsDiag;->lastUaOriginal:I
  .line 15
    sput v0, Lcom/sec/internal/google/ApDualImsDiag;->lastUaEffective:I
  .line 16
    sput v0, Lcom/sec/internal/google/ApDualImsDiag;->lastUaWritten:I
  .line 19
    const-wide/16 v0, -1
    sput-wide v0, Lcom/sec/internal/google/ApDualImsDiag;->lastUaElapsedMs:J
    return-void
.end method

.method private constructor <init>()V
  .registers 1
  .line 21
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static declared-synchronized effectiveConfig(I)I
  .catchall { :L0 .. :L3 } :L4
  .registers 7
    const-class v0, Lcom/sec/internal/google/ApDualImsDiag;
    monitor-enter v0
  :L0
  .line 50
    const-string v1, "persist.vendor.ims.ap_dual_ims_override"
    const/4 v2, 0
    invoke-static { v1, v2 }, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1
  .line 51
    if-eqz v1, :L1
    if-nez p0, :L1
    const/4 v2, 3
    goto :L2
  :L1
    move v2, p0
  :L2
  .line 52
    sput p0, Lcom/sec/internal/google/ApDualImsDiag;->lastUaOriginal:I
  .line 53
    sput v2, Lcom/sec/internal/google/ApDualImsDiag;->lastUaEffective:I
  .line 54
    sput-boolean v1, Lcom/sec/internal/google/ApDualImsDiag;->overrideEnabledAtUa:Z
  .line 55
    sget v3, Lcom/sec/internal/google/ApDualImsDiag;->uaConfigCalls:I
    add-int/lit8 v3, v3, 1
    sput v3, Lcom/sec/internal/google/ApDualImsDiag;->uaConfigCalls:I
  .line 56
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v3
    sput-wide v3, Lcom/sec/internal/google/ApDualImsDiag;->lastUaElapsedMs:J
  .line 57
    const-string v3, "AP_DUAL_IMS"
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "OVERRIDE original="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v4, " effective="
    invoke-virtual { p0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v4, " enabled="
    invoke-virtual { p0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, " uaConfigCalls="
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget v1, Lcom/sec/internal/google/ApDualImsDiag;->uaConfigCalls:I
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, " phoneCount="
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, "com.sec.internal.helper.SimUtil"
    const-string v4, "getPhoneCount"
  .line 61
    invoke-static { v1, v4 }, Lcom/sec/internal/google/ApDualImsDiag;->staticInt(Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, " config="
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, "com.sec.internal.helper.SimUtil"
    const-string v4, "getConfigDualIMS"
  .line 62
    invoke-static { v1, v4 }, Lcom/sec/internal/google/ApDualImsDiag;->staticString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-static { v1 }, Lcom/sec/internal/google/ApDualImsDiag;->safe(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, " elapsedMs="
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget-wide v4, Lcom/sec/internal/google/ApDualImsDiag;->lastUaElapsedMs:J
    invoke-virtual { p0, v4, v5 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 57
    invoke-static { v3, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L3
  .line 64
    monitor-exit v0
    return v2
  :L4
  .line 49
    move-exception p0
    monitor-exit v0
    throw p0
.end method

.method private static floatingFeature()Ljava/lang/String;
  .catchall { :L0 .. :L2 } :L3
  .registers 7
  :L0
  .line 111
    const-string v0, "com.samsung.android.feature.SemFloatingFeature"
    invoke-static { v0 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v0
  .line 112
    const-string v1, "getInstance"
    const/4 v2, 0
    new-array v3, v2, [Ljava/lang/Class;
    invoke-virtual { v0, v1, v3 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v1
    const/4 v3, 0
    new-array v4, v2, [Ljava/lang/Object;
    invoke-virtual { v1, v3, v4 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v1
  .line 113
    const-string v3, "getString"
    const/4 v4, 1
    new-array v5, v4, [Ljava/lang/Class;
    const-class v6, Ljava/lang/String;
    aput-object v6, v5, v2
    invoke-virtual { v0, v3, v5 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
  .line 114
    new-array v3, v4, [Ljava/lang/Object;
    const-string v4, "SEC_FLOATING_FEATURE_COMMON_CONFIG_DUAL_IMS"
    aput-object v4, v3, v2
    invoke-virtual { v0, v1, v3 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
  .line 115
    if-nez v0, :L1
    const-string v0, "<null>"
    goto :L2
  :L1
    invoke-static { v0 }, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object v0
  :L2
    return-object v0
  :L3
  .line 116
    move-exception v0
  .line 117
    const-string v1, "AP_DUAL_IMS"
    const-string v2, "READ_FAIL floatingFeature"
    invoke-static { v1, v2, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 118
    const-string v0, "<error>"
    return-object v0
.end method

.method private static logConfig(Ljava/lang/String;I)V
  .registers 8
  .line 35
    const-string v0, "com.sec.internal.helper.SimUtil"
    const-string v1, "getPhoneCount"
    invoke-static { v0, v1 }, Lcom/sec/internal/google/ApDualImsDiag;->staticInt(Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
  .line 36
    const-string v2, "getConfigDualIMS"
    invoke-static { v0, v2 }, Lcom/sec/internal/google/ApDualImsDiag;->staticString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
  .line 37
    invoke-static { }, Lcom/sec/internal/google/ApDualImsDiag;->floatingFeature()Ljava/lang/String;
    move-result-object v2
  .line 38
    const-string v3, "persist.radio.multisim.config"
    const-string v4, ""
    invoke-static { v3, v4 }, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
  .line 39
    const-string v5, "persist.ims.mock.multisim"
    invoke-static { v5, v4 }, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
  .line 40
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { v5, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v5, " phoneCount="
    invoke-virtual { p0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, " floating="
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 41
    invoke-static { v2 }, Lcom/sec/internal/google/ApDualImsDiag;->safe(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, " config="
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 42
    invoke-static { v0 }, Lcom/sec/internal/google/ApDualImsDiag;->safe(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " translated="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " radioMultisim="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 44
    invoke-static { v3 }, Lcom/sec/internal/google/ApDualImsDiag;->safe(Ljava/lang/String;)Ljava/lang/String;
    move-result-object p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " mockMultisim="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 45
    invoke-static { v4 }, Lcom/sec/internal/google/ApDualImsDiag;->safe(Ljava/lang/String;)Ljava/lang/String;
    move-result-object p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " elapsedMs="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 46
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    invoke-virtual { p0, v0, v1 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 40
    const-string p1, "AP_DUAL_IMS"
    invoke-static { p1, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 47
    return-void
.end method

.method private static logLedger(Ljava/lang/String;)V
  .registers 3
  .line 68
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " lastUaOriginal="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget v0, Lcom/sec/internal/google/ApDualImsDiag;->lastUaOriginal:I
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " lastUaEffective="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget v0, Lcom/sec/internal/google/ApDualImsDiag;->lastUaEffective:I
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " lastUaWritten="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget v0, Lcom/sec/internal/google/ApDualImsDiag;->lastUaWritten:I
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " overrideEnabledAtUa="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget-boolean v0, Lcom/sec/internal/google/ApDualImsDiag;->overrideEnabledAtUa:Z
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " uaConfigCalls="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget v0, Lcom/sec/internal/google/ApDualImsDiag;->uaConfigCalls:I
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " uaElapsedMs="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget-wide v0, Lcom/sec/internal/google/ApDualImsDiag;->lastUaElapsedMs:J
    invoke-virtual { p0, v0, v1 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " nowElapsedMs="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 75
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    invoke-virtual { p0, v0, v1 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 68
    const-string v0, "AP_DUAL_IMS"
    invoke-static { v0, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 76
    return-void
.end method

.method public static declared-synchronized onCallSnapshot()V
  .catchall { :L0 .. :L1 } :L2
  .registers 3
    const-class v0, Lcom/sec/internal/google/ApDualImsDiag;
    monitor-enter v0
  :L0
  .line 30
    const-string v1, "CALL_CONFIG"
    invoke-static { }, Lcom/sec/internal/google/ApDualImsDiag;->translated()I
    move-result v2
    invoke-static { v1, v2 }, Lcom/sec/internal/google/ApDualImsDiag;->logConfig(Ljava/lang/String;I)V
  .line 31
    const-string v1, "CALL_LEDGER"
    invoke-static { v1 }, Lcom/sec/internal/google/ApDualImsDiag;->logLedger(Ljava/lang/String;)V
  :L1
  .line 32
    monitor-exit v0
    return-void
  :L2
  .line 29
    move-exception v1
    monitor-exit v0
    throw v1
.end method

.method public static declared-synchronized onUaConfig(I)V
  .catchall { :L0 .. :L1 } :L2
  .registers 3
    const-class v0, Lcom/sec/internal/google/ApDualImsDiag;
    monitor-enter v0
  :L0
  .line 24
    sput p0, Lcom/sec/internal/google/ApDualImsDiag;->lastUaWritten:I
  .line 25
    const-string v1, "UA_CONFIG"
    invoke-static { v1, p0 }, Lcom/sec/internal/google/ApDualImsDiag;->logConfig(Ljava/lang/String;I)V
  .line 26
    const-string p0, "UA_LEDGER"
    invoke-static { p0 }, Lcom/sec/internal/google/ApDualImsDiag;->logLedger(Ljava/lang/String;)V
  :L1
  .line 27
    monitor-exit v0
    return-void
  :L2
  .line 23
    move-exception p0
    monitor-exit v0
    throw p0
.end method

.method private static safe(Ljava/lang/String;)Ljava/lang/String;
  .registers 3
  .line 123
    if-nez p0, :L0
    const-string p0, "<null>"
    return-object p0
  :L0
  .line 124
    const/16 v0, 32
    const/16 v1, 95
    invoke-virtual { p0, v0, v1 }, Ljava/lang/String;->replace(CC)Ljava/lang/String;
    move-result-object p0
    return-object p0
.end method

.method private static staticInt(Ljava/lang/String;Ljava/lang/String;)I
  .catchall { :L0 .. :L1 } :L2
  .registers 5
  :L0
  .line 92
    invoke-static { p0 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v0
    const/4 v1, 0
    new-array v2, v1, [Ljava/lang/Class;
    invoke-virtual { v0, p1, v2 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
    const/4 v2, 0
    new-array v1, v1, [Ljava/lang/Object;
    invoke-virtual { v0, v2, v1 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/Number;
    invoke-virtual { v0 }, Ljava/lang/Number;->intValue()I
    move-result p0
  :L1
    return p0
  :L2
  .line 93
    move-exception v0
  .line 94
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "READ_FAIL class="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, " method="
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string p1, "AP_DUAL_IMS"
    invoke-static { p1, p0, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 95
    const/4 p0, -1
    return p0
.end method

.method private static staticString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
  .catchall { :L0 .. :L2 } :L3
  .registers 5
  :L0
  .line 101
    invoke-static { p0 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v0
    const/4 v1, 0
    new-array v2, v1, [Ljava/lang/Class;
    invoke-virtual { v0, p1, v2 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
    const/4 v2, 0
    new-array v1, v1, [Ljava/lang/Object;
    invoke-virtual { v0, v2, v1 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
  .line 102
    if-nez v0, :L1
    const-string p0, "<null>"
    goto :L2
  :L1
    invoke-static { v0 }, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object p0
  :L2
    return-object p0
  :L3
  .line 103
    move-exception v0
  .line 104
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "READ_FAIL class="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, " method="
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string p1, "AP_DUAL_IMS"
    invoke-static { p1, p0, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 105
    const-string p0, "<error>"
    return-object p0
.end method

.method private static translated()I
  .catchall { :L0 .. :L1 } :L2
  .registers 4
  :L0
  .line 80
    const-string v0, "com.sec.internal.ims.core.handler.secims.StackRequestBuilderUtil"
    invoke-static { v0 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v0
  .line 81
    const-string v1, "translateConfigDualIms"
    const/4 v2, 0
    new-array v3, v2, [Ljava/lang/Class;
    invoke-virtual { v0, v1, v3 }, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
  .line 82
    const/4 v1, 1
    invoke-virtual { v0, v1 }, Ljava/lang/reflect/Method;->setAccessible(Z)V
  .line 83
    const/4 v1, 0
    new-array v2, v2, [Ljava/lang/Object;
    invoke-virtual { v0, v1, v2 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/Number;
    invoke-virtual { v0 }, Ljava/lang/Number;->intValue()I
    move-result v0
  :L1
    return v0
  :L2
  .line 84
    move-exception v0
  .line 85
    const-string v1, "AP_DUAL_IMS"
    const-string v2, "READ_FAIL translateConfigDualIms"
    invoke-static { v1, v2, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 86
    const/4 v0, -1
    return v0
.end method
