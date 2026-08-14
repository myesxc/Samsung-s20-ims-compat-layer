.class public final Lcom/sec/internal/google/ApEpsOnlyDiag;
.super Ljava/lang/Object;
.source "ApEpsOnlyDiag.java"

.field private final static OVERRIDE_PROP:Ljava/lang/String; = "persist.vendor.ims.ap_eps_only_override"

.field private final static TAG:Ljava/lang/String; = "AP_EPS_ONLY"

.field private static lastCallType:I

.field private static lastEffective:Z

.field private static lastEmergency:Z

.field private static lastEnabled:Z

.field private static lastOriginal:Z

.field private static lastOverrideElapsedMs:J

.field private static lastPhoneId:I

.field private static overrideCalls:I

.field private static serviceDataNetwork:I

.field private static serviceDataReg:I

.field private static servicePhoneId:I

.field private static servicePsOnly:Z

.method static constructor <clinit>()V
  .registers 2
  .line 11
    const/4 v0, -1
    sput v0, Lcom/sec/internal/google/ApEpsOnlyDiag;->servicePhoneId:I
  .line 12
    sput v0, Lcom/sec/internal/google/ApEpsOnlyDiag;->serviceDataReg:I
  .line 13
    sput v0, Lcom/sec/internal/google/ApEpsOnlyDiag;->serviceDataNetwork:I
  .line 18
    sput v0, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastPhoneId:I
  .line 19
    sput v0, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastCallType:I
  .line 22
    const-wide/16 v0, -1
    sput-wide v0, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastOverrideElapsedMs:J
    return-void
.end method

.method private constructor <init>()V
  .registers 1
  .line 24
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method private static bool(Ljava/lang/Object;Ljava/lang/String;)Z
  .catchall { :L0 .. :L1 } :L2
  .registers 6
  .line 115
    const/4 v0, 0
  :L0
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v1
    new-array v2, v0, [Ljava/lang/Class;
    invoke-virtual { v1, p1, v2 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v1
    new-array v2, v0, [Ljava/lang/Object;
    invoke-virtual { v1, p0, v2 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Ljava/lang/Boolean;
    invoke-virtual { v1 }, Ljava/lang/Boolean;->booleanValue()Z
    move-result p0
  :L1
    return p0
  :L2
  .line 116
    move-exception v1
  .line 117
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "READ_FAIL method="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v2, " type="
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-static { p0 }, Lcom/sec/internal/google/ApEpsOnlyDiag;->type(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object p0
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string p1, "AP_EPS_ONLY"
    invoke-static { p1, p0, v1 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 118
    return v0
.end method

.method public static declared-synchronized effectiveCallSetup(IZIZ)Z
  .catchall { :L0 .. :L9 } :L10
  .registers 14
    const-class v0, Lcom/sec/internal/google/ApEpsOnlyDiag;
    monitor-enter v0
  :L0
  .line 50
    const-string v1, "persist.vendor.ims.ap_eps_only_override"
    const/4 v2, 0
    invoke-static { v1, v2 }, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1
  .line 51
    sget v3, Lcom/sec/internal/google/ApEpsOnlyDiag;->servicePhoneId:I
    const/4 v4, 1
    if-ne p0, v3, :L1
    move v3, v4
    goto :L2
  :L1
    move v3, v2
  :L2
  .line 52
    const/4 v5, -1
    if-eqz v3, :L3
    sget v6, Lcom/sec/internal/google/ApEpsOnlyDiag;->serviceDataReg:I
    goto :L4
  :L3
    move v6, v5
  :L4
  .line 53
    if-eqz v3, :L5
    sget v5, Lcom/sec/internal/google/ApEpsOnlyDiag;->serviceDataNetwork:I
  :L5
  .line 55
    if-eqz v1, :L6
    if-nez p1, :L6
    if-ne p2, v4, :L6
    if-nez p3, :L6
    if-nez v6, :L6
    const/16 v3, 13
    if-ne v5, v3, :L6
    move v3, v4
    goto :L7
  :L6
    move v3, p1
  :L7
  .line 56
    sput-boolean p1, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastOriginal:Z
  .line 57
    sput-boolean v3, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastEffective:Z
  .line 58
    sput-boolean v1, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastEnabled:Z
  .line 59
    sput p0, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastPhoneId:I
  .line 60
    sput p2, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastCallType:I
  .line 61
    sput-boolean p3, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastEmergency:Z
  .line 62
    sget v7, Lcom/sec/internal/google/ApEpsOnlyDiag;->overrideCalls:I
    add-int/2addr v7, v4
    sput v7, Lcom/sec/internal/google/ApEpsOnlyDiag;->overrideCalls:I
  .line 63
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v7
    sput-wide v7, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastOverrideElapsedMs:J
  .line 64
    const-string v7, "AP_EPS_ONLY"
    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct { v8 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v9, "OVERRIDE phoneId="
    invoke-virtual { v8, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v8
    invoke-virtual { v8, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v8
    const-string v9, " original="
    invoke-virtual { v8, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v8
    invoke-virtual { v8, p1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v8, " effective="
    invoke-virtual { p1, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v8, " enabled="
    invoke-virtual { p1, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v1, " callType="
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p2, " emergency="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p2, " dataReg="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v6 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p2, " dataNetwork="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p2, " psOnly="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    sget p2, Lcom/sec/internal/google/ApEpsOnlyDiag;->servicePhoneId:I
    if-ne p0, p2, :L8
    sget-boolean p0, Lcom/sec/internal/google/ApEpsOnlyDiag;->servicePsOnly:Z
    if-eqz p0, :L8
    move v2, v4
  :L8
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " calls="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget p1, Lcom/sec/internal/google/ApEpsOnlyDiag;->overrideCalls:I
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " elapsedMs="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget-wide p1, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastOverrideElapsedMs:J
    invoke-virtual { p0, p1, p2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v7, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L9
  .line 75
    monitor-exit v0
    return v3
  :L10
  .line 49
    move-exception p0
    monitor-exit v0
    throw p0
.end method

.method private static integer(Ljava/lang/Object;Ljava/lang/String;)I
  .catchall { :L0 .. :L1 } :L2
  .registers 5
  :L0
  .line 96
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    const/4 v1, 0
    new-array v2, v1, [Ljava/lang/Class;
    invoke-virtual { v0, p1, v2 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
    new-array v1, v1, [Ljava/lang/Object;
    invoke-virtual { v0, p0, v1 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/Number;
    invoke-virtual { v0 }, Ljava/lang/Number;->intValue()I
    move-result p0
  :L1
    return p0
  :L2
  .line 97
    move-exception v0
  .line 98
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "READ_FAIL method="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v1, " type="
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-static { p0 }, Lcom/sec/internal/google/ApEpsOnlyDiag;->type(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object p0
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string p1, "AP_EPS_ONLY"
    invoke-static { p1, p0, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 99
    const/4 p0, -1
    return p0
.end method

.method private static integerArg(Ljava/lang/Object;Ljava/lang/String;I)I
  .catchall { :L0 .. :L1 } :L2
  .registers 8
  :L0
  .line 105
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    const/4 v1, 1
    new-array v2, v1, [Ljava/lang/Class;
    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v4, 0
    aput-object v3, v2, v4
    invoke-virtual { v0, p1, v2 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
  .line 106
    new-array v1, v1, [Ljava/lang/Object;
    invoke-static { p2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p2
    aput-object p2, v1, v4
    invoke-virtual { v0, p0, v1 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p2
    check-cast p2, Ljava/lang/Number;
    invoke-virtual { p2 }, Ljava/lang/Number;->intValue()I
    move-result p0
  :L1
    return p0
  :L2
  .line 107
    move-exception p2
  .line 108
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "READ_FAIL method="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " type="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-static { p0 }, Lcom/sec/internal/google/ApEpsOnlyDiag;->type(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object p0
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string p1, "AP_EPS_ONLY"
    invoke-static { p1, p0, p2 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 109
    const/4 p0, -1
    return p0
.end method

.method public static declared-synchronized onCallSetup(IZ)V
  .catchall { :L0 .. :L6 } :L7
  .registers 6
    const-class v0, Lcom/sec/internal/google/ApEpsOnlyDiag;
    monitor-enter v0
  :L0
  .line 79
    const-string v1, "AP_EPS_ONLY"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "CALL_SETUP phoneId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " written="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v2, " original="
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    sget-boolean v2, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastOriginal:Z
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v2, " effective="
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    sget-boolean v2, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastEffective:Z
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v2, " enabled="
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    sget-boolean v2, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastEnabled:Z
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v2, " callType="
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    sget v2, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastCallType:I
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v2, " emergency="
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    sget-boolean v2, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastEmergency:Z
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v2, " dataReg="
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
  .line 86
    sget v2, Lcom/sec/internal/google/ApEpsOnlyDiag;->servicePhoneId:I
    const/4 v3, -1
    if-ne p0, v2, :L1
    sget v2, Lcom/sec/internal/google/ApEpsOnlyDiag;->serviceDataReg:I
    goto :L2
  :L1
    move v2, v3
  :L2
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v2, " dataNetwork="
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
  .line 87
    sget v2, Lcom/sec/internal/google/ApEpsOnlyDiag;->servicePhoneId:I
    if-ne p0, v2, :L3
    sget v3, Lcom/sec/internal/google/ApEpsOnlyDiag;->serviceDataNetwork:I
  :L3
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v2, " psOnly="
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    sget v2, Lcom/sec/internal/google/ApEpsOnlyDiag;->servicePhoneId:I
    if-ne p0, v2, :L4
    sget-boolean p0, Lcom/sec/internal/google/ApEpsOnlyDiag;->servicePsOnly:Z
    if-eqz p0, :L4
    const/4 p0, 1
    goto :L5
  :L4
    const/4 p0, 0
  :L5
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " calls="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget p1, Lcom/sec/internal/google/ApEpsOnlyDiag;->overrideCalls:I
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " overrideElapsedMs="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget-wide v2, Lcom/sec/internal/google/ApEpsOnlyDiag;->lastOverrideElapsedMs:J
    invoke-virtual { p0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " elapsedMs="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 91
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v2
    invoke-virtual { p0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 79
    invoke-static { v1, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L6
  .line 92
    monitor-exit v0
    return-void
  :L7
  .line 78
    move-exception p0
    monitor-exit v0
    throw p0
.end method

.method public static declared-synchronized onServiceState(Ljava/lang/Object;IZ)V
  .catchall { :L0 .. :L1 } :L2
  .registers 12
    const-class v0, Lcom/sec/internal/google/ApEpsOnlyDiag;
    monitor-enter v0
  :L0
  .line 27
    const-string v1, "getDataRegState"
    invoke-static { p0, v1 }, Lcom/sec/internal/google/ApEpsOnlyDiag;->integer(Ljava/lang/Object;Ljava/lang/String;)I
    move-result v1
  .line 28
    const-string v2, "getDataNetworkType"
    invoke-static { p0, v2 }, Lcom/sec/internal/google/ApEpsOnlyDiag;->integer(Ljava/lang/Object;Ljava/lang/String;)I
    move-result v2
  .line 29
    const-string v3, "getVoiceRegState"
    invoke-static { p0, v3 }, Lcom/sec/internal/google/ApEpsOnlyDiag;->integer(Ljava/lang/Object;Ljava/lang/String;)I
    move-result v3
  .line 30
    const-string v4, "getVoiceNetworkType"
    invoke-static { p0, v4 }, Lcom/sec/internal/google/ApEpsOnlyDiag;->integer(Ljava/lang/Object;Ljava/lang/String;)I
    move-result v4
  .line 31
    const-string v5, "getAccessNetworkTechnology"
    const/4 v6, 1
    invoke-static { p0, v5, v6 }, Lcom/sec/internal/google/ApEpsOnlyDiag;->integerArg(Ljava/lang/Object;Ljava/lang/String;I)I
    move-result v5
  .line 32
    const-string v6, "isPsOnlyReg"
    invoke-static { p0, v6 }, Lcom/sec/internal/google/ApEpsOnlyDiag;->bool(Ljava/lang/Object;Ljava/lang/String;)Z
    move-result p0
  .line 33
    sput p1, Lcom/sec/internal/google/ApEpsOnlyDiag;->servicePhoneId:I
  .line 34
    sput v1, Lcom/sec/internal/google/ApEpsOnlyDiag;->serviceDataReg:I
  .line 35
    sput v2, Lcom/sec/internal/google/ApEpsOnlyDiag;->serviceDataNetwork:I
  .line 36
    sput-boolean p0, Lcom/sec/internal/google/ApEpsOnlyDiag;->servicePsOnly:Z
  .line 37
    const-string v6, "AP_EPS_ONLY"
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct { v7 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "SERVICE_STATE phoneId="
    invoke-virtual { v7, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v7
    invoke-virtual { v7, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v7, " dataReg="
    invoke-virtual { p1, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v1, " dataNetwork="
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v1, " voiceReg="
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v1, " voiceNetwork="
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v1, " psOnly="
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " accessNetwork="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " epsOnly="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " elapsedMs="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 45
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide p1
    invoke-virtual { p0, p1, p2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 37
    invoke-static { v6, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L1
  .line 46
    monitor-exit v0
    return-void
  :L2
  .line 26
    move-exception p0
    monitor-exit v0
    throw p0
.end method

.method private static type(Ljava/lang/Object;)Ljava/lang/String;
  .registers 1
  .line 123
    if-nez p0, :L0
    const-string p0, "null"
    goto :L1
  :L0
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object p0
  :L1
    return-object p0
.end method
