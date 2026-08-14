.class public final Lcom/sec/internal/google/ApBearerLatchProbe;
.super Ljava/lang/Object;
.source "ApBearerLatchProbe.java"

.field private final static ALL_CALLS_DEBOUNCE_MS:I = 1000

.field private final static DEFAULT_PDN_TYPE:I = 11

.field private final static DELAY_PROP:Ljava/lang/String; = "persist.vendor.ims.ap_latch_probe_delay_ms"

.field private final static MIN_RADIO_DWELL_MS:I = 200

.field private final static PDN_GAP_PROP:Ljava/lang/String; = "persist.vendor.ims.ap_latch_probe_pdn_gap_ms"

.field private final static PDN_TYPE_PROP:Ljava/lang/String; = "persist.vendor.ims.ap_latch_probe_pdn_type"

.field private final static RADIO_DWELL_PROP:Ljava/lang/String; = "persist.vendor.ims.ap_latch_probe_radio_dwell_ms"

.field private final static REREG_DELAY_PROP:Ljava/lang/String; = "persist.vendor.ims.ap_latch_probe_rereg_delay_ms"

.field private final static RUNG_PROP:Ljava/lang/String; = "persist.vendor.ims.ap_latch_probe_rung"

.field private final static TAG:Ljava/lang/String; = "AP_LATCH_PROBE"

.field private static fireCount:I

.field private static formalCallEntered:Z

.field private static formalSessionId:I

.field private static guardGeneration:J

.field private static lastFireElapsed:J

.field private static quiet:Z

.method static constructor <clinit>()V
  .registers 2
  .line 61
    const-wide/16 v0, -1
    sput-wide v0, Lcom/sec/internal/google/ApBearerLatchProbe;->lastFireElapsed:J
  .line 64
    const/4 v0, -1
    sput v0, Lcom/sec/internal/google/ApBearerLatchProbe;->formalSessionId:I
    return-void
.end method

.method private constructor <init>()V
  .registers 1
  .line 67
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method static synthetic access$000(Ljava/lang/Object;IIIJ)V
  .registers 6
  .line 40
    invoke-static/range { p0 .. p5 }, Lcom/sec/internal/google/ApBearerLatchProbe;->waitForAllCallsEnded(Ljava/lang/Object;IIIJ)V
    return-void
.end method

.method private static appContext()Ljava/lang/Object;
  .catchall { :L0 .. :L1 } :L3
  .catchall { :L4 .. :L5 } :L6
  .registers 6
  .line 988
    const-string v0, "AP_LATCH_PROBE"
    const/4 v1, 0
    const/4 v2, 0
  :L0
    const-string v3, "android.app.ActivityThread"
    invoke-static { v3 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v3
  .line 989
    const-string v4, "currentApplication"
    new-array v5, v2, [Ljava/lang/Class;
    invoke-virtual { v3, v4, v5 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v3
    new-array v4, v2, [Ljava/lang/Object;
    invoke-virtual { v3, v1, v4 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v3
  :L1
  .line 990
    if-eqz v3, :L2
  .line 991
    return-object v3
  :L2
  .line 995
    goto :L4
  :L3
  .line 993
    move-exception v3
  .line 994
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "RUNG4_CTX ActivityThread.currentApplication unavailable: "
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static { v0, v3 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L4
  .line 997
    const-string v3, "android.app.AppGlobals"
    invoke-static { v3 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v3
  .line 998
    const-string v4, "getInitialApplication"
    new-array v5, v2, [Ljava/lang/Class;
    invoke-virtual { v3, v4, v5 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v3
    new-array v2, v2, [Ljava/lang/Object;
    invoke-virtual { v3, v1, v2 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
  :L5
    return-object v0
  :L6
  .line 999
    move-exception v2
  .line 1000
    const-string v3, "RUNG4_CTX AppGlobals.getInitialApplication unavailable"
    invoke-static { v0, v3, v2 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 1001
    return-object v1
.end method

.method private static call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
  .catchall { :L0 .. :L2 } :L3
  .registers 6
  .line 1166
    const/4 v0, 0
  :L0
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v1
    const/4 v2, 0
    new-array v3, v2, [Ljava/lang/Class;
    invoke-static { v1, p1, v3 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object p1
  .line 1167
    if-nez p1, :L1
  .line 1168
    return-object v0
  :L1
  .line 1170
    new-array v1, v2, [Ljava/lang/Object;
    invoke-virtual { p1, p0, v1 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  :L2
    return-object p0
  :L3
  .line 1171
    move-exception p0
  .line 1172
    return-object v0
.end method

.method private static call(Ljava/lang/Object;Ljava/lang/String;I)Ljava/lang/Object;
  .catchall { :L0 .. :L1 } :L2
  .registers 8
  :L0
  .line 1225
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    const/4 v1, 1
    new-array v2, v1, [Ljava/lang/Class;
    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v4, 0
    aput-object v3, v2, v4
    invoke-virtual { v0, p1, v2 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object p1
  .line 1226
    invoke-virtual { p1, v1 }, Ljava/lang/reflect/Method;->setAccessible(Z)V
  .line 1227
    new-array v0, v1, [Ljava/lang/Object;
    invoke-static { p2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p2
    aput-object p2, v0, v4
    invoke-virtual { p1, p0, v0 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  :L1
    return-object p0
  :L2
  .line 1228
    move-exception p0
  .line 1229
    const/4 p0, 0
    return-object p0
.end method

.method private static callStatic(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;
  .catchall { :L0 .. :L1 } :L2
  .registers 5
  .line 1246
    const/4 v0, 0
  :L0
    invoke-static { p0 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object p0
  .line 1247
    const/4 v1, 0
    new-array v2, v1, [Ljava/lang/Class;
    invoke-virtual { p0, p1, v2 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object p0
  .line 1248
    const/4 p1, 1
    invoke-virtual { p0, p1 }, Ljava/lang/reflect/Method;->setAccessible(Z)V
  .line 1249
    new-array p1, v1, [Ljava/lang/Object;
    invoke-virtual { p0, v0, p1 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  :L1
    return-object p0
  :L2
  .line 1250
    move-exception p0
  .line 1251
    return-object v0
.end method

.method private static callStatic(Ljava/lang/String;Ljava/lang/String;I)Ljava/lang/Object;
  .catchall { :L0 .. :L1 } :L2
  .registers 8
  .line 1235
    const/4 v0, 0
  :L0
    invoke-static { p0 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object p0
  .line 1236
    const/4 v1, 1
    new-array v2, v1, [Ljava/lang/Class;
    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v4, 0
    aput-object v3, v2, v4
    invoke-virtual { p0, p1, v2 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object p0
  .line 1237
    invoke-virtual { p0, v1 }, Ljava/lang/reflect/Method;->setAccessible(Z)V
  .line 1238
    new-array p1, v1, [Ljava/lang/Object;
    invoke-static { p2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p2
    aput-object p2, p1, v4
    invoke-virtual { p0, v0, p1 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  :L1
    return-object p0
  :L2
  .line 1239
    move-exception p0
  .line 1240
    return-object v0
.end method

.method private static callStaticDeclared(Ljava/lang/String;Ljava/lang/String;I)Ljava/lang/Object;
  .catchall { :L0 .. :L2 } :L3
  .registers 11
  .line 1179
    const-string v0, "."
    const-string v1, "AP_LATCH_PROBE"
    const/4 v2, 0
  :L0
    invoke-static { p0 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v3
  .line 1180
    const/4 v4, 1
    new-array v5, v4, [Ljava/lang/Class;
    sget-object v6, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v7, 0
    aput-object v6, v5, v7
    invoke-static { v3, p1, v5 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v3
  .line 1181
    if-nez v3, :L1
  .line 1182
    new-instance p2, Ljava/lang/StringBuilder;
    invoke-direct { p2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "REFLECT_MISS "
    invoke-virtual { p2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    const-string v3, "(int) not found at all"
    invoke-virtual { p2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    invoke-static { v1, p2 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 1183
    return-object v2
  :L1
  .line 1185
    new-array v4, v4, [Ljava/lang/Object;
    invoke-static { p2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p2
    aput-object p2, v4, v7
    invoke-virtual { v3, v2, v4 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  :L2
    return-object p0
  :L3
  .line 1186
    move-exception p2
  .line 1187
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "REFLECT_THROW "
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, ": "
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 1188
    return-object v2
.end method

.method private static collectMethods(Ljava/lang/Class;)Ljava/util/List;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "(",
      "Ljava/lang/Class<",
      "*>;)",
      "Ljava/util/List<",
      "Ljava/lang/reflect/Method;",
      ">;"
    }
  .end annotation
  .registers 6
  .line 494
    new-instance v0, Ljava/util/ArrayList;
    invoke-direct { v0 }, Ljava/util/ArrayList;-><init>()V
  .line 495
    nop
  :L0
  .line 496
    if-eqz p0, :L3
  .line 497
    invoke-virtual { p0 }, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;
    move-result-object v1
    array-length v2, v1
    const/4 v3, 0
  :L1
    if-ge v3, v2, :L2
    aget-object v4, v1, v3
  .line 498
    invoke-interface { v0, v4 }, Ljava/util/List;->add(Ljava/lang/Object;)Z
  .line 497
    add-int/lit8 v3, v3, 1
    goto :L1
  :L2
  .line 500
    invoke-virtual { p0 }, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;
    move-result-object p0
    goto :L0
  :L3
  .line 502
    return-object v0
.end method

.method private static countLogMatches(Ljava/lang/String;)I
  .catchall { :L0 .. :L1 } :L10
  .catchall { :L2 .. :L3 } :L9
  .catch Ljava/io/IOException; { :L5 .. :L6 } :L7
  .catch Ljava/io/IOException; { :L12 .. :L13 } :L14
  .registers 9
  .line 328
    nop
  .line 330
    const/4 v0, 0
  :L0
    new-instance v1, Ljava/lang/ProcessBuilder;
    const-string v2, "logcat"
    const-string v3, "-b"
    const-string v4, "all"
    const-string v5, "-d"
    const-string v6, "-t"
    const-string v7, "600"
    filled-new-array/range { v2 .. v7 }, [Ljava/lang/String;
    move-result-object v2
    invoke-direct { v1, v2 }, Ljava/lang/ProcessBuilder;-><init>([Ljava/lang/String;)V
  .line 331
    const/4 v2, 1
    invoke-virtual { v1, v2 }, Ljava/lang/ProcessBuilder;->redirectErrorStream(Z)Ljava/lang/ProcessBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/ProcessBuilder;->start()Ljava/lang/Process;
    move-result-object v1
  .line 332
    new-instance v2, Ljava/io/BufferedReader;
    new-instance v3, Ljava/io/InputStreamReader;
    invoke-virtual { v1 }, Ljava/lang/Process;->getInputStream()Ljava/io/InputStream;
    move-result-object v1
    invoke-direct { v3, v1 }, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V
    invoke-direct { v2, v3 }, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
  :L1
  .line 334
    const/4 v0, 0
  :L2
  .line 335
    invoke-virtual { v2 }, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :L4
  .line 336
    invoke-virtual { v1, p0 }, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
  :L3
    if-eqz v1, :L2
  .line 337
    add-int/lit8 v0, v0, 1
    goto :L2
  :L4
  .line 340
    nop
  .line 344
    nop
  :L5
  .line 346
    invoke-virtual { v2 }, Ljava/io/BufferedReader;->close()V
  :L6
  .line 349
    goto :L8
  :L7
  .line 347
    move-exception p0
  :L8
  .line 340
    return v0
  :L9
  .line 341
    move-exception p0
    move-object v0, v2
    goto :L11
  :L10
    move-exception p0
  :L11
  .line 342
    const/4 p0, -1
  .line 344
    if-eqz v0, :L15
  :L12
  .line 346
    invoke-virtual { v0 }, Ljava/io/BufferedReader;->close()V
  :L13
  .line 349
    goto :L15
  :L14
  .line 347
    move-exception v0
  :L15
  .line 342
    return p0
.end method

.method private static countRegisterSends()I
  .catchall { :L0 .. :L1 } :L10
  .catchall { :L2 .. :L3 } :L9
  .catch Ljava/io/IOException; { :L5 .. :L6 } :L7
  .catchall { :L11 .. :L12 } :L17
  .catch Ljava/io/IOException; { :L13 .. :L14 } :L15
  .catch Ljava/io/IOException; { :L18 .. :L19 } :L20
  .registers 10
  .line 360
    nop
  .line 362
    const/4 v0, 0
  :L0
    new-instance v1, Ljava/lang/ProcessBuilder;
    const-string v2, "logcat"
    const-string v3, "-b"
    const-string v4, "all"
    const-string v5, "-d"
    const-string v6, "-t"
    const-string v7, "400"
    const-string v8, "-s"
    const-string v9, "SIPMSG[0]"
    filled-new-array/range { v2 .. v9 }, [Ljava/lang/String;
    move-result-object v2
    invoke-direct { v1, v2 }, Ljava/lang/ProcessBuilder;-><init>([Ljava/lang/String;)V
  .line 364
    const/4 v2, 1
    invoke-virtual { v1, v2 }, Ljava/lang/ProcessBuilder;->redirectErrorStream(Z)Ljava/lang/ProcessBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/ProcessBuilder;->start()Ljava/lang/Process;
    move-result-object v1
  .line 365
    new-instance v2, Ljava/io/BufferedReader;
    new-instance v3, Ljava/io/InputStreamReader;
    invoke-virtual { v1 }, Ljava/lang/Process;->getInputStream()Ljava/io/InputStream;
    move-result-object v1
    invoke-direct { v3, v1 }, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V
    invoke-direct { v2, v3 }, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
  :L1
  .line 367
    const/4 v0, 0
  :L2
  .line 368
    invoke-virtual { v2 }, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :L4
  .line 369
    const-string v3, "[-->] REGISTER sip:"
    invoke-virtual { v1, v3 }, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
  :L3
    if-eqz v1, :L2
  .line 370
    add-int/lit8 v0, v0, 1
    goto :L2
  :L4
  .line 373
    nop
  .line 378
    nop
  :L5
  .line 380
    invoke-virtual { v2 }, Ljava/io/BufferedReader;->close()V
  :L6
  .line 383
    goto :L8
  :L7
  .line 381
    move-exception v1
  :L8
  .line 373
    return v0
  :L9
  .line 374
    move-exception v0
    goto :L11
  :L10
    move-exception v1
    move-object v2, v0
    move-object v0, v1
  :L11
  .line 375
    const-string v1, "AP_LATCH_PROBE"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "VERIFY_NOTE cannot read logcat ("
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, "), falling back to handle only"
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L12
  .line 376
    const/4 v0, -1
  .line 378
    if-eqz v2, :L16
  :L13
  .line 380
    invoke-virtual { v2 }, Ljava/io/BufferedReader;->close()V
  :L14
  .line 383
    goto :L16
  :L15
  .line 381
    move-exception v1
  :L16
  .line 376
    return v0
  :L17
  .line 378
    move-exception v0
    if-eqz v2, :L21
  :L18
  .line 380
    invoke-virtual { v2 }, Ljava/io/BufferedReader;->close()V
  :L19
  .line 383
    goto :L21
  :L20
  .line 381
    move-exception v1
  :L21
  .line 385
    throw v0
.end method

.method private static field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
  .catchall { :L0 .. :L1 } :L7
  .catch Ljava/lang/NoSuchFieldException; { :L2 .. :L3 } :L4
  .catchall { :L2 .. :L3 } :L7
  .catchall { :L5 .. :L6 } :L7
  .registers 5
  :L0
  .line 182
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
  :L1
    if-eqz v0, :L8
  :L2
  .line 184
    invoke-virtual { v0, p1 }, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;
    move-result-object v1
  .line 185
    const/4 v2, 1
    invoke-virtual { v1, v2 }, Ljava/lang/reflect/Field;->setAccessible(Z)V
  .line 186
    invoke-virtual { v1, p0 }, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  :L3
    return-object p0
  :L4
  .line 187
    move-exception v1
  :L5
  .line 182
    invoke-virtual { v0 }, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;
    move-result-object v0
  :L6
    goto :L1
  :L7
  .line 189
    move-exception p0
  :L8
    nop
  .line 190
    const/4 p0, 0
    return-object p0
.end method

.method private static varargs findMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "(",
      "Ljava/lang/Class<",
      "*>;",
      "Ljava/lang/String;",
      "[",
      "Ljava/lang/Class<",
      "*>;)",
      "Ljava/lang/reflect/Method;"
    }
  .end annotation
  .catchall { :L0 .. :L1 } :L2
  .catch Ljava/lang/NoSuchMethodException; { :L4 .. :L5 } :L7
  .catchall { :L4 .. :L5 } :L6
  .registers 6
  .line 1140
    const/4 v0, 1
  :L0
    invoke-virtual { p0, p1, p2 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v1
  .line 1141
    invoke-virtual { v1, v0 }, Ljava/lang/reflect/Method;->setAccessible(Z)V
  :L1
  .line 1142
    return-object v1
  :L2
  .line 1143
    move-exception v1
  .line 1147
    nop
  :L3
  .line 1148
    const/4 v1, 0
    if-eqz p0, :L8
  :L4
  .line 1150
    invoke-virtual { p0, p1, p2 }, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v2
  .line 1151
    invoke-virtual { v2, v0 }, Ljava/lang/reflect/Method;->setAccessible(Z)V
  :L5
  .line 1152
    return-object v2
  :L6
  .line 1155
    move-exception p0
  .line 1156
    return-object v1
  :L7
  .line 1153
    move-exception v1
  .line 1154
    invoke-virtual { p0 }, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;
    move-result-object p0
  .line 1157
    goto :L3
  :L8
  .line 1159
    return-object v1
.end method

.method private static findMethodByName(Ljava/lang/Class;Ljava/lang/String;I)Ljava/lang/reflect/Method;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "(",
      "Ljava/lang/Class<",
      "*>;",
      "Ljava/lang/String;",
      "I)",
      "Ljava/lang/reflect/Method;"
    }
  .end annotation
  .registers 8
  .line 1194
    nop
  :L0
  .line 1195
    if-eqz p0, :L4
  .line 1196
    invoke-virtual { p0 }, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;
    move-result-object v0
    array-length v1, v0
    const/4 v2, 0
  :L1
    if-ge v2, v1, :L3
    aget-object v3, v0, v2
  .line 1197
    invoke-virtual { v3 }, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;
    move-result-object v4
    invoke-virtual { v4, p1 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-eqz v4, :L2
    invoke-virtual { v3 }, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;
    move-result-object v4
    array-length v4, v4
    if-ne v4, p2, :L2
  .line 1198
    const/4 p0, 1
    invoke-virtual { v3, p0 }, Ljava/lang/reflect/Method;->setAccessible(Z)V
  .line 1199
    return-object v3
  :L2
  .line 1196
    add-int/lit8 v2, v2, 1
    goto :L1
  :L3
  .line 1202
    invoke-virtual { p0 }, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;
    move-result-object p0
    goto :L0
  :L4
  .line 1204
    const/4 p0, 0
    return-object p0
.end method

.method private static findPdnController(I)Ljava/lang/Object;
  .registers 4
  .line 880
    const/4 v0, 0
    invoke-static { v0, p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findRegisterTask(Ljava/lang/Object;I)Ljava/lang/Object;
    move-result-object p0
  .line 881
    if-nez p0, :L0
  .line 882
    return-object v0
  :L0
  .line 884
    const-string v0, "mRegHandler"
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p0
  .line 885
    const-string v0, "AP_LATCH_PROBE"
    if-eqz p0, :L2
  .line 886
    const-string v1, "mPdnController"
    invoke-static { p0, v1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v2
  .line 887
    if-eqz v2, :L1
  .line 888
    const-string p0, "RUNG5_PDN_VIA handler.mPdnController"
    invoke-static { v0, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 889
    return-object v2
  :L1
  .line 891
    const-string v2, "mRegMan"
    invoke-static { p0, v2 }, Lcom/sec/internal/google/ApBearerLatchProbe;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p0
  .line 892
    if-eqz p0, :L2
  .line 893
    invoke-static { p0, v1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p0
  .line 894
    if-eqz p0, :L2
  .line 895
    const-string v1, "RUNG5_PDN_VIA mRegMan.mPdnController"
    invoke-static { v0, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 896
    return-object p0
  :L2
  .line 900
    const-string p0, "com.sec.internal.ims.core.ImsRegistry"
    const-string v1, "getPdnController"
    invoke-static { p0, v1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->callStatic(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p0
  .line 902
    if-eqz p0, :L3
  .line 903
    const-string v1, "RUNG5_PDN_VIA ImsRegistry.getPdnController()"
    invoke-static { v0, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L3
  .line 905
    return-object p0
.end method

.method private static findRegisterTask(Ljava/lang/Object;I)Ljava/lang/Object;
  .registers 5
  .line 1066
    const-string p0, "com.sec.internal.ims.core.SlotBasedConfig"
    const-string v0, "getInstance"
    invoke-static { p0, v0, p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->callStatic(Ljava/lang/String;Ljava/lang/String;I)Ljava/lang/Object;
    move-result-object p0
  .line 1068
    const-string v0, "AP_LATCH_PROBE"
    if-nez p0, :L0
  .line 1069
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "TASK_FAIL SlotBasedConfig.getInstance("
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, ") unavailable"
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v0, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    goto :L5
  :L0
  .line 1071
    const-string v1, "getRegistrationTasks"
    invoke-static { p0, v1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p0
  .line 1072
    instance-of v1, p0, Ljava/lang/Iterable;
    if-eqz v1, :L2
  .line 1073
    check-cast p0, Ljava/lang/Iterable;
    invoke-static { p0, p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->pickRegisteredTask(Ljava/lang/Iterable;I)Ljava/lang/Object;
    move-result-object p0
  .line 1074
    if-eqz p0, :L1
  .line 1075
    return-object p0
  :L1
  .line 1077
    const-string p0, "TASK_FAIL getRegistrationTasks had no usable entry"
    invoke-static { v0, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 1078
    goto :L5
  :L2
  .line 1079
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "TASK_FAIL getRegistrationTasks returned "
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
  .line 1080
    if-nez p0, :L3
    const-string p0, "null"
    goto :L4
  :L3
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object p0
  :L4
    invoke-virtual { v1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 1079
    invoke-static { v0, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  :L5
  .line 1086
    const-string p0, "com.sec.internal.ims.core.RegistrationUtils"
    const-string v1, "getPendingRegistrationInternal"
    invoke-static { p0, v1, p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->callStaticDeclared(Ljava/lang/String;Ljava/lang/String;I)Ljava/lang/Object;
    move-result-object p0
  .line 1088
    instance-of v1, p0, Ljava/lang/Iterable;
    if-eqz v1, :L7
  .line 1089
    check-cast p0, Ljava/lang/Iterable;
    invoke-static { p0, p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->pickRegisteredTask(Ljava/lang/Iterable;I)Ljava/lang/Object;
    move-result-object p0
  .line 1090
    if-eqz p0, :L6
  .line 1091
    const-string p1, "TASK_VIA getPendingRegistrationInternal (fallback)"
    invoke-static { v0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 1092
    return-object p0
  :L6
  .line 1094
    const-string p0, "TASK_FAIL fallback list had no usable entry"
    invoke-static { v0, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  :L7
  .line 1096
    const/4 p0, 0
    return-object p0
.end method

.method private static findRegistrationManager(Ljava/lang/Object;I)Ljava/lang/Object;
  .registers 8
  .line 1023
    const/4 p0, 0
    invoke-static { p0, p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findRegisterTask(Ljava/lang/Object;I)Ljava/lang/Object;
    move-result-object v0
  .line 1024
    const-string v1, "AP_LATCH_PROBE"
    if-nez v0, :L0
  .line 1025
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "REGIMGR_FAIL no RegisterTask for phoneId="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { v1, p1 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 1026
    return-object p0
  :L0
  .line 1028
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "REGIMGR_STEP1 task="
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { v0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { v1, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 1030
    const-string p1, "mRegHandler"
    invoke-static { v0, p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p1
  .line 1031
    if-nez p1, :L1
  .line 1032
    const-string p1, "REGIMGR_FAIL task has no mRegHandler"
    invoke-static { v1, p1 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 1033
    return-object p0
  :L1
  .line 1035
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "REGIMGR_STEP2 handler="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { p1 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 1037
    const-string v0, "mRegMan"
    invoke-static { p1, v0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p1
  .line 1038
    if-nez p1, :L2
  .line 1039
    const-string p1, "REGIMGR_FAIL handler has no mRegMan"
    invoke-static { v1, p1 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 1040
    return-object p0
  :L2
  .line 1042
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "REGIMGR_STEP3 mgr="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { p1 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 1046
    invoke-virtual { p1 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    const/4 v2, 2
    new-array v2, v2, [Ljava/lang/Class;
    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v4, 0
    aput-object v3, v2, v4
    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v5, 1
    aput-object v3, v2, v5
    const-string v3, "sendReRegister"
    invoke-static { v0, v3, v2 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
    if-eqz v0, :L3
    move v4, v5
  :L3
  .line 1047
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "REGIMGR_VERIFY sendReRegister present="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 1048
    if-nez v4, :L4
  .line 1049
    const-string p1, "REGIMGR_FAIL resolved object lacks sendReRegister - wrong class"
    invoke-static { v1, p1 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 1050
    return-object p0
  :L4
  .line 1052
    return-object p1
.end method

.method private static fire(Ljava/lang/Object;III)V
  .catch Ljava/lang/InterruptedException; { :L0 .. :L1 } :L2
  .registers 7
  .line 194
    const-string p2, "ap_latch_probe_delay_ms"
    const/16 v0, 1500
    const/4 v1, 0
    const v2, 60000
    invoke-static { p2, v0, v1, v2 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result p2
  .line 195
    if-lez p2, :L3
  .line 197
    int-to-long v0, p2
  :L0
    invoke-static { v0, v1 }, Ljava/lang/Thread;->sleep(J)V
  :L1
  .line 200
    goto :L3
  :L2
  .line 198
    move-exception p2
  .line 199
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/Thread;->interrupt()V
  :L3
  .line 203
    invoke-static { p0, p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findRegistrationManager(Ljava/lang/Object;I)Ljava/lang/Object;
    move-result-object p0
  .line 204
    const-string p2, "AP_LATCH_PROBE"
    if-nez p0, :L4
  .line 205
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p1, "ABORT could not resolve registration manager - rung "
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " not attempted"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { p2, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 206
    return-void
  :L4
  .line 208
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "REGIMGR class="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { p2, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 210
    sget v0, Lcom/sec/internal/google/ApBearerLatchProbe;->fireCount:I
    add-int/lit8 v0, v0, 1
    sput v0, Lcom/sec/internal/google/ApBearerLatchProbe;->fireCount:I
  .line 211
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    sput-wide v0, Lcom/sec/internal/google/ApBearerLatchProbe;->lastFireElapsed:J
  .line 212
    const/16 v0, 11
    const-string v1, "persist.vendor.ims.ap_latch_probe_pdn_type"
    invoke-static { v1, v0 }, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I
    move-result v0
  .line 213
    const/4 v1, 4
    if-lt p3, v1, :L5
    const-string v1, "SETUP_DATA_CALL"
    invoke-static { v1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->countLogMatches(Ljava/lang/String;)I
    move-result v1
    goto :L6
  :L5
    const/4 v1, -1
  :L6
  .line 215
    packed-switch p3, :L14
  .line 235
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "UNKNOWN rung="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { p2, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    goto :L13
  :L7
  .line 232
    invoke-static { p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->rungDirectRadioCycle(I)V
  .line 233
    goto :L13
  :L8
  .line 229
    invoke-static { p1, v0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->rungPdnRebuild(II)V
  .line 230
    goto :L13
  :L9
  .line 226
    invoke-static { p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->rungRadioCycle(I)V
  .line 227
    goto :L13
  :L10
  .line 223
    invoke-static { p0, p1, v0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->rungStopPdn(Ljava/lang/Object;II)V
  .line 224
    goto :L13
  :L11
  .line 220
    invoke-static { p0, p1, v0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->rungDeregisterProfile(Ljava/lang/Object;II)V
  .line 221
    goto :L13
  :L12
  .line 217
    invoke-static { p0, p1, v0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->rungReRegister(Ljava/lang/Object;II)V
  .line 218
    nop
  :L13
  .line 239
    invoke-static { p1, p3, v1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->verifyRegistrationMoved(III)V
  .line 240
    return-void
  :L14
  .packed-switch 1
    :L12
    :L11
    :L10
    :L9
    :L8
    :L7
  .end packed-switch
.end method

.method private static liveRegistrationHandle(I)I
  .catch Ljava/lang/NumberFormatException; { :L3 .. :L4 } :L5
  .registers 3
  .line 610
    const/4 v0, 0
    invoke-static { v0, p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findRegisterTask(Ljava/lang/Object;I)Ljava/lang/Object;
    move-result-object p0
  .line 611
    const/4 v0, -1
    if-nez p0, :L0
  .line 612
    return v0
  :L0
  .line 614
    const-string v1, "getImsRegistration"
    invoke-static { p0, v1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p0
  .line 615
    if-nez p0, :L1
  .line 616
    return v0
  :L1
  .line 618
    const-string v1, "getHandle"
    invoke-static { p0, v1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
  .line 619
    if-nez v1, :L2
  .line 620
    const-string v1, "mHandle"
    invoke-static { p0, v1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
  :L2
  .line 622
    instance-of p0, v1, Ljava/lang/Integer;
    if-eqz p0, :L3
  .line 623
    check-cast v1, Ljava/lang/Integer;
    invoke-virtual { v1 }, Ljava/lang/Integer;->intValue()I
    move-result p0
    return p0
  :L3
  .line 626
    invoke-static { v1 }, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object p0
    invoke-static { p0 }, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result p0
  :L4
    return p0
  :L5
  .line 627
    move-exception p0
  .line 628
    return v0
.end method

.method private static liveSessionCount(Ljava/lang/Object;)I
  .catchall { :L0 .. :L7 } :L10
  .registers 4
  :L0
  .line 163
    const-string v0, "mImsCallSessionManager"
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p0
  .line 164
    if-nez p0, :L1
    const/4 p0, 0
    goto :L2
  :L1
    const-string v0, "mSessionMap"
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p0
  :L2
  .line 165
    instance-of v0, p0, Ljava/util/Map;
    const/4 v1, 0
    if-nez v0, :L3
    return v1
  :L3
  .line 166
    nop
  .line 167
    check-cast p0, Ljava/util/Map;
    invoke-interface { p0 }, Ljava/util/Map;->values()Ljava/util/Collection;
    move-result-object p0
    invoke-interface { p0 }, Ljava/util/Collection;->iterator()Ljava/util/Iterator;
    move-result-object p0
  :L4
    invoke-interface { p0 }, Ljava/util/Iterator;->hasNext()Z
    move-result v0
    if-eqz v0, :L9
    invoke-interface { p0 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v0
  .line 168
    const-string v2, "getCallState"
    invoke-static { v0, v2 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
  .line 169
    if-nez v0, :L5
    const-string v0, ""
    goto :L6
  :L5
    invoke-static { v0 }, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object v0
  :L6
  .line 170
    const-string v2, "EndedCall"
    invoke-virtual { v2, v0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :L8
    const-string v2, "EndingCall"
    invoke-virtual { v2, v0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :L8
    const-string v2, "Idle"
  .line 171
    invoke-virtual { v2, v0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
  :L7
    if-nez v0, :L8
    add-int/lit8 v1, v1, 1
  :L8
  .line 172
    goto :L4
  :L9
  .line 173
    return v1
  :L10
  .line 174
    move-exception p0
  .line 175
    const-string v0, "AP_LATCH_PROBE"
    const-string v1, "RUNG4_SESSION_SCAN_FAILED"
    invoke-static { v0, v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 176
    const/4 p0, 1
    return p0
.end method

.method public static declared-synchronized onCallEstablished(I)V
  .catchall { :L0 .. :L1 } :L2
  .registers 5
    const-class v0, Lcom/sec/internal/google/ApBearerLatchProbe;
    monitor-enter v0
  .line 70
    const/4 v1, 1
  :L0
    sput-boolean v1, Lcom/sec/internal/google/ApBearerLatchProbe;->formalCallEntered:Z
  .line 71
    sput p0, Lcom/sec/internal/google/ApBearerLatchProbe;->formalSessionId:I
  .line 72
    const-string v1, "AP_LATCH_PROBE"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "FORMAL_CALL_ENTERED sessionId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L1
  .line 73
    monitor-exit v0
    return-void
  :L2
  .line 69
    move-exception p0
    monitor-exit v0
    throw p0
.end method

.method public static declared-synchronized onCallEstablished(Ljava/lang/Object;I)V
  .catchall { :L0 .. :L1 } :L2
  .registers 2
    const-class p0, Lcom/sec/internal/google/ApBearerLatchProbe;
    monitor-enter p0
  :L0
  .line 76
    invoke-static { p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->onCallEstablished(I)V
  :L1
  .line 77
    monitor-exit p0
    return-void
  :L2
  .line 75
    move-exception p1
    monitor-exit p0
    throw p1
.end method

.method public static declared-synchronized onLastCallEnded(Ljava/lang/Object;II)V
  .catchall { :L0 .. :L2 } :L13
  .catchall { :L3 .. :L4 } :L13
  .catchall { :L6 .. :L7 } :L13
  .catchall { :L7 .. :L8 } :L10
  .catchall { :L8 .. :L9 } :L13
  .catchall { :L11 .. :L12 } :L10
  .catchall { :L12 .. :L13 } :L13
  .registers 15
    const-class v0, Lcom/sec/internal/google/ApBearerLatchProbe;
    monitor-enter v0
  :L0
  .line 82
    const-string v1, "ap_latch_probe_rung"
    const/4 v2, 0
    const/4 v3, 6
    invoke-static { v1, v3, v2, v3 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v1
  .line 83
    const/4 v11, 1
    if-eq v1, v3, :L1
    move v2, v11
  :L1
  .line 84
    if-eqz v2, :L3
    sget-boolean v2, Lcom/sec/internal/google/ApBearerLatchProbe;->formalCallEntered:Z
    if-nez v2, :L3
  .line 85
    const-string p0, "AP_LATCH_PROBE"
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "RUNG4_SKIP reason=no_formal_call sessionId="
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { p0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L2
  .line 86
    monitor-exit v0
    return-void
  :L3
  .line 88
    const-string v2, "AP_LATCH_PROBE"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "CHECK rung="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " phoneId="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " sessionId="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " fireCount="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    sget v4, Lcom/sec/internal/google/ApBearerLatchProbe;->fireCount:I
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " formalSessionId="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    sget v4, Lcom/sec/internal/google/ApBearerLatchProbe;->formalSessionId:I
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static { v2, v3 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 90
    if-gtz v1, :L5
  .line 91
    const-string p0, "AP_LATCH_PROBE"
    const-string p1, "DISABLED rung=0 - control run, no reset attempted"
    invoke-static { p0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L4
  .line 92
    monitor-exit v0
    return-void
  :L5
  .line 98
    nop
  :L6
  .line 100
    monitor-enter v0
  :L7
  .line 101
    sget-wide v2, Lcom/sec/internal/google/ApBearerLatchProbe;->guardGeneration:J
    const-wide/16 v4, 1
    add-long v9, v2, v4
    sput-wide v9, Lcom/sec/internal/google/ApBearerLatchProbe;->guardGeneration:J
  .line 102
    monitor-exit v0
  :L8
  .line 103
    new-instance v2, Ljava/lang/Thread;
    new-instance v3, Lcom/sec/internal/google/ApBearerLatchProbe$1;
    move-object v4, v3
    move-object v5, p0
    move v6, p1
    move v7, p2
    move v8, v1
    invoke-direct/range { v4 .. v10 }, Lcom/sec/internal/google/ApBearerLatchProbe$1;-><init>(Ljava/lang/Object;IIIJ)V
    const-string p0, "desem48-latch-guard"
    invoke-direct { v2, v3, p0 }, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V
  .line 109
    invoke-virtual { v2, v11 }, Ljava/lang/Thread;->setDaemon(Z)V
  .line 110
    invoke-virtual { v2 }, Ljava/lang/Thread;->start()V
  .line 111
    const-string p0, "AP_LATCH_PROBE"
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "DISPATCHED rung="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p2, " to worker thread"
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { p0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L9
  .line 112
    monitor-exit v0
    return-void
  :L10
  .line 102
    move-exception p0
  :L11
    monitor-exit v0
  :L12
    throw p0
  :L13
  .line 81
    move-exception p0
    monitor-exit v0
    throw p0
.end method

.method private static phoneIdForStartConnectivity(Ljava/lang/Object;I)I
  .catchall { :L0 .. :L2 } :L5
  .registers 9
  :L0
  .line 914
    const-string v0, "com.sec.internal.ims.core.RegistrationUtils"
    invoke-static { v0 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v0
  .line 915
    invoke-virtual { v0 }, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;
    move-result-object v0
    array-length v1, v0
    const/4 v2, 0
    move v3, v2
  :L1
    if-ge v3, v1, :L4
    aget-object v4, v0, v3
  .line 916
    invoke-virtual { v4 }, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;
    move-result-object v5
    const-string v6, "getPhoneIdForStartConnectivity"
    invoke-virtual { v5, v6 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    if-eqz v5, :L3
  .line 917
    invoke-virtual { v4 }, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;
    move-result-object v5
    array-length v5, v5
    const/4 v6, 1
    if-ne v5, v6, :L3
  .line 918
    invoke-virtual { v4, v6 }, Ljava/lang/reflect/Method;->setAccessible(Z)V
  .line 919
    const/4 v5, 0
    new-array v6, v6, [Ljava/lang/Object;
    aput-object p0, v6, v2
    invoke-virtual { v4, v5, v6 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v4
  .line 920
    instance-of v5, v4, Ljava/lang/Integer;
    if-eqz v5, :L3
  .line 921
    check-cast v4, Ljava/lang/Integer;
    invoke-virtual { v4 }, Ljava/lang/Integer;->intValue()I
    move-result p0
  :L2
    return p0
  :L3
  .line 915
    add-int/lit8 v3, v3, 1
    goto :L1
  :L4
  .line 927
    goto :L6
  :L5
  .line 925
    move-exception p0
  .line 926
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "RUNG5_NOTE getPhoneIdForStartConnectivity unavailable: "
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string v0, "AP_LATCH_PROBE"
    invoke-static { v0, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L6
  .line 928
    return p1
.end method

.method private static pickRegisteredTask(Ljava/lang/Iterable;I)Ljava/lang/Object;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "(",
      "Ljava/lang/Iterable<",
      "*>;I)",
      "Ljava/lang/Object;"
    }
  .end annotation
  .registers 9
  .line 1106
    nop
  .line 1107
    nop
  .line 1108
    invoke-interface { p0 }, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;
    move-result-object p0
    const/4 p1, 0
    const/4 v0, 0
  :L0
    invoke-interface { p0 }, Ljava/util/Iterator;->hasNext()Z
    move-result v1
    const-string v2, "AP_LATCH_PROBE"
    if-eqz v1, :L6
    invoke-interface { p0 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v1
  .line 1109
    if-nez v1, :L1
  .line 1110
    goto :L0
  :L1
  .line 1112
    add-int/lit8 v0, v0, 1
  .line 1113
    if-nez p1, :L2
  .line 1114
    move-object p1, v1
  :L2
  .line 1116
    const-string v3, "getState"
    invoke-static { v1, v3 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v3
    invoke-static { v3 }, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object v3
  .line 1117
    const-string v4, "getProfile"
    invoke-static { v1, v4 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v4
    invoke-static { v4 }, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object v4
  .line 1118
    sget-boolean v5, Lcom/sec/internal/google/ApBearerLatchProbe;->quiet:Z
    if-nez v5, :L3
  .line 1119
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "TASK_CANDIDATE #"
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v6, " state="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v6, " class="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
  .line 1120
    invoke-virtual { v1 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v6
    invoke-virtual { v6 }, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;
    move-result-object v6
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
  .line 1119
    invoke-static { v2, v5 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L3
  .line 1122
    invoke-virtual { v3 }, Ljava/lang/String;->toUpperCase()Ljava/lang/String;
    move-result-object v5
    const-string v6, "REGISTERED"
    invoke-virtual { v5, v6 }, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v5
    if-eqz v5, :L5
  .line 1123
    invoke-virtual { v3 }, Ljava/lang/String;->toUpperCase()Ljava/lang/String;
    move-result-object v3
    const-string v5, "DEREGISTERED"
    invoke-virtual { v3, v5 }, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v3
    if-nez v3, :L5
  .line 1124
    sget-boolean p0, Lcom/sec/internal/google/ApBearerLatchProbe;->quiet:Z
    if-nez p0, :L4
  .line 1125
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p1, "TASK_PICK registered task, profile="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v2, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L4
  .line 1127
    return-object v1
  :L5
  .line 1129
    goto/16 :L0
  :L6
  .line 1130
    if-eqz p1, :L7
  .line 1131
    sget-boolean p0, Lcom/sec/internal/google/ApBearerLatchProbe;->quiet:Z
    if-nez p0, :L7
  .line 1132
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "TASK_PICK falling back to first of "
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " task(s)"
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v2, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L7
  .line 1135
    return-object p1
.end method

.method private static reRegisterProfile(Ljava/lang/Object;Ljava/lang/Object;II)V
  .catch Ljava/lang/InterruptedException; { :L0 .. :L1 } :L2
  .catchall { :L5 .. :L6 } :L7
  .registers 10
  .line 575
    const-string v0, "persist.vendor.ims.ap_latch_probe_rereg_delay_ms"
    const/16 v1, 2000
    invoke-static { v0, v1 }, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I
    move-result v0
  .line 576
    if-lez v0, :L3
  .line 578
    int-to-long v0, v0
  :L0
    invoke-static { v0, v1 }, Ljava/lang/Thread;->sleep(J)V
  :L1
  .line 582
    goto :L3
  :L2
  .line 579
    move-exception p0
  .line 580
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Thread;->interrupt()V
  .line 581
    return-void
  :L3
  .line 585
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    const-string v1, "registerProfile"
    const/4 v2, 2
    invoke-static { v0, v1, v2 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findMethodByName(Ljava/lang/Class;Ljava/lang/String;I)Ljava/lang/reflect/Method;
    move-result-object v0
  .line 586
    const-string v1, "AP_LATCH_PROBE"
    if-nez v0, :L4
  .line 587
    const-string p0, "RUNG2_REREG_UNAVAILABLE registerProfile/2 not found - the phone is left DEREGISTERED, treat this run as void"
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 589
    return-void
  :L4
  .line 591
    invoke-virtual { v0 }, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;
    move-result-object v3
  .line 592
    const/4 v4, 0
    aget-object v5, v3, v4
    invoke-virtual { v5, p1 }, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z
    move-result v5
    if-nez v5, :L5
  .line 593
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "RUNG2_REREG_SKIP registerProfile expects "
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    aget-object p2, v3, v4
    invoke-virtual { p2 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object p2
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p2, ", have "
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 594
    invoke-virtual { p1 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 593
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 595
    return-void
  :L5
  .line 598
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "RUNG2_REREG_FIRE registerProfile profileId="
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p3
    const-string v3, " phoneId="
    invoke-virtual { p3, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p3
    invoke-virtual { p3, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p3
    invoke-virtual { p3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p3
    invoke-static { v1, p3 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 600
    new-array p3, v2, [Ljava/lang/Object;
    aput-object p1, p3, v4
    const/4 p1, 1
    invoke-static { p2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p2
    aput-object p2, p3, p1
    invoke-virtual { v0, p0, p3 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  .line 601
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "RUNG2_REREG_COMPLETE registerProfile returned "
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " - expect a fresh 401-challenged REGISTER"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L6
  .line 605
    goto :L8
  :L7
  .line 603
    move-exception p0
  .line 604
    const-string p1, "RUNG2_REREG_FAIL registerProfile threw"
    invoke-static { v1, p1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L8
  .line 606
    return-void
.end method

.method private static readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
  .catch Ljava/lang/NoSuchFieldException; { :L1 .. :L2 } :L4
  .catchall { :L1 .. :L2 } :L3
  .registers 6
  .line 1208
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
  :L0
  .line 1209
    const/4 v1, 0
    if-eqz v0, :L5
  :L1
  .line 1211
    invoke-virtual { v0, p1 }, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;
    move-result-object v2
  .line 1212
    const/4 v3, 1
    invoke-virtual { v2, v3 }, Ljava/lang/reflect/Field;->setAccessible(Z)V
  .line 1213
    invoke-virtual { v2, p0 }, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  :L2
    return-object p0
  :L3
  .line 1216
    move-exception p0
  .line 1217
    return-object v1
  :L4
  .line 1214
    move-exception v1
  .line 1215
    invoke-virtual { v0 }, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;
    move-result-object v0
  .line 1218
    goto :L0
  :L5
  .line 1220
    return-object v1
.end method

.method private static registeredPdnListener(Ljava/lang/Object;I)Ljava/lang/Object;
  .registers 11
  .line 833
    const-string v0, "mNetworkCallbacks"
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p0
  .line 834
    instance-of v0, p0, Ljava/util/Map;
    const/4 v1, 0
    const-string v2, "AP_LATCH_PROBE"
    if-nez v0, :L2
  .line 835
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "RUNG5_LISTENER mNetworkCallbacks is "
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
  .line 836
    if-nez p0, :L0
    const-string p0, "null"
    goto :L1
  :L0
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object p0
  :L1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 835
    invoke-static { v2, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 837
    return-object v1
  :L2
  .line 839
    check-cast p0, Ljava/util/Map;
  .line 840
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "RUNG5_LISTENER mNetworkCallbacks has "
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-interface { p0 }, Ljava/util/Map;->size()I
    move-result v3
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " entry(s)"
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v2, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 842
    invoke-static { v1, p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findRegisterTask(Ljava/lang/Object;I)Ljava/lang/Object;
    move-result-object p1
  .line 843
    nop
  .line 844
    nop
  .line 845
    invoke-interface { p0 }, Ljava/util/Map;->entrySet()Ljava/util/Set;
    move-result-object p0
    invoke-interface { p0 }, Ljava/util/Set;->iterator()Ljava/util/Iterator;
    move-result-object p0
    const/4 v0, 0
    move v3, v0
    move-object v4, v1
  :L3
    invoke-interface { p0 }, Ljava/util/Iterator;->hasNext()Z
    move-result v5
    const/4 v6, 1
    if-eqz v5, :L9
    invoke-interface { p0 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v5
    check-cast v5, Ljava/util/Map$Entry;
  .line 846
    invoke-interface { v5 }, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;
    move-result-object v7
  .line 847
    if-nez v7, :L4
  .line 848
    goto :L3
  :L4
  .line 850
    invoke-interface { v5 }, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;
    move-result-object v5
    if-eqz v5, :L5
    goto :L6
  :L5
    move v6, v0
  :L6
  .line 851
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "RUNG5_LISTENER candidate "
    invoke-virtual { v5, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v7 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v8
    invoke-virtual { v8 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v8
    invoke-virtual { v5, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v8, " callback="
    invoke-virtual { v5, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static { v2, v5 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 853
    if-nez v6, :L7
  .line 854
    goto :L3
  :L7
  .line 856
    if-ne v7, p1, :L8
  .line 857
    const-string p0, "RUNG5_LISTENER exact match with the live RegisterTask"
    invoke-static { v2, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 858
    return-object v7
  :L8
  .line 860
    add-int/lit8 v3, v3, 1
  .line 861
    nop
  .line 862
    move-object v4, v7
    goto :L3
  :L9
  .line 863
    if-ne v3, v6, :L10
  .line 864
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p1, "RUNG5_LISTENER task not registered; using the only listener that holds a callback: "
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 865
    invoke-virtual { v4 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 864
    invoke-static { v2, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 866
    return-object v4
  :L10
  .line 868
    if-le v3, v6, :L11
  .line 869
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p1, "RUNG5_LISTENER ambiguous: "
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " non-task listeners hold callbacks; refusing to guess"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v2, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  :L11
  .line 872
    return-object v1
.end method

.method private static registrationFingerprint(I)Ljava/lang/String;
  .catchall { :L0 .. :L1 } :L6
  .catchall { :L2 .. :L5 } :L6
  .registers 5
  .line 391
    const/4 v0, 1
    sput-boolean v0, Lcom/sec/internal/google/ApBearerLatchProbe;->quiet:Z
  .line 393
    const/4 v0, 0
    const/4 v1, 0
  :L0
    invoke-static { v0, p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findRegisterTask(Ljava/lang/Object;I)Ljava/lang/Object;
    move-result-object p0
  .line 394
    if-nez p0, :L2
  .line 395
    const-string p0, "task=null"
  :L1
  .line 409
    sput-boolean v1, Lcom/sec/internal/google/ApBearerLatchProbe;->quiet:Z
  .line 395
    return-object p0
  :L2
  .line 397
    const-string v0, "getState"
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
  .line 398
    const-string v2, "getImsRegistration"
    invoke-static { p0, v2 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object p0
  .line 399
    const-string v2, "?"
  .line 400
    if-eqz p0, :L4
  .line 401
    const-string v2, "getHandle"
    invoke-static { p0, v2 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v2
  .line 402
    if-nez v2, :L3
  .line 403
    const-string v2, "mHandle"
    invoke-static { p0, v2 }, Lcom/sec/internal/google/ApBearerLatchProbe;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v2
  :L3
  .line 405
    invoke-static { v2 }, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object v2
  :L4
  .line 407
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "state="
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " handle="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  :L5
  .line 409
    sput-boolean v1, Lcom/sec/internal/google/ApBearerLatchProbe;->quiet:Z
  .line 407
    return-object p0
  :L6
  .line 409
    move-exception p0
    sput-boolean v1, Lcom/sec/internal/google/ApBearerLatchProbe;->quiet:Z
  .line 410
    throw p0
.end method

.method private static rungDeregisterProfile(Ljava/lang/Object;II)V
  .catchall { :L6 .. :L7 } :L8
  .registers 12
  .line 523
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object p2
    const/4 v0, 2
    new-array v1, v0, [Ljava/lang/Class;
    sget-object v2, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v3, 0
    aput-object v2, v1, v3
    sget-object v2, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v4, 1
    aput-object v2, v1, v4
    const-string v2, "deregisterProfile"
    invoke-static { p2, v2, v1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object p2
  .line 524
    const-string v1, "AP_LATCH_PROBE"
    if-nez p2, :L0
  .line 525
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "RUNG2_UNAVAILABLE deregisterProfile(int,int) not found on "
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
  .line 526
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object p0
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 525
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 527
    return-void
  :L0
  .line 530
    const/4 v2, 0
    invoke-static { v2, p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findRegisterTask(Ljava/lang/Object;I)Ljava/lang/Object;
    move-result-object v2
  .line 531
    if-nez v2, :L1
  .line 532
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "RUNG2_ABORT no RegisterTask for phoneId="
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 533
    return-void
  :L1
  .line 535
    const-string v5, "getProfile"
    invoke-static { v2, v5 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v2
  .line 536
    if-nez v2, :L2
  .line 537
    const-string p0, "RUNG2_ABORT task has no ImsProfile"
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 538
    return-void
  :L2
  .line 540
    const-string v5, "getId"
    invoke-static { v2, v5 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v5
  .line 541
    instance-of v6, v5, Ljava/lang/Integer;
    if-nez v6, :L5
  .line 542
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p1, "RUNG2_ABORT ImsProfile.getId() returned "
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 543
    if-nez v5, :L3
    const-string p1, "null"
    goto :L4
  :L3
    invoke-virtual { v5 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object p1
  :L4
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " - refusing to call with a guessed id"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 542
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 545
    return-void
  :L5
  .line 547
    check-cast v5, Ljava/lang/Integer;
    invoke-virtual { v5 }, Ljava/lang/Integer;->intValue()I
    move-result v5
  .line 548
    invoke-static { p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->liveRegistrationHandle(I)I
    move-result v6
  .line 549
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct { v7 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "RUNG2_IDS profileId="
    invoke-virtual { v7, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v7
    invoke-virtual { v7, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v7
    const-string v8, " handle="
    invoke-virtual { v7, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v7
    invoke-virtual { v7, v6 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v6
    const-string v7, " (the call takes profileId; handle is logged only for correlation)"
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-static { v1, v6 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L6
  .line 553
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct { v6 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "RUNG2_FIRE deregisterProfile profileId="
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v6
    const-string v7, " phoneId="
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-static { v1, v6 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 555
    new-array v0, v0, [Ljava/lang/Object;
    invoke-static { v5 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v6
    aput-object v6, v0, v3
    invoke-static { p1 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    aput-object v3, v0, v4
    invoke-virtual { p2, p0, v0 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
  .line 556
    const-string p2, "RUNG2_COMPLETE deregisterProfile returned - expect the handle to move"
    invoke-static { v1, p2 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L7
  .line 560
    nop
  .line 566
    invoke-static { p0, v2, p1, v5 }, Lcom/sec/internal/google/ApBearerLatchProbe;->reRegisterProfile(Ljava/lang/Object;Ljava/lang/Object;II)V
  .line 567
    return-void
  :L8
  .line 557
    move-exception p0
  .line 558
    const-string p1, "RUNG2_FAIL deregisterProfile threw"
    invoke-static { v1, p1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 559
    return-void
.end method

.method private static rungDirectRadioCycle(I)V
  .catch Ljava/lang/InterruptedException; { :L1 .. :L2 } :L4
  .registers 5
  .line 708
    const-string v0, "ap_latch_probe_radio_dwell_ms"
    const/16 v1, 400
    const/16 v2, 200
    const/16 v3, 10000
    invoke-static { v0, v1, v2, v3 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v0
  .line 710
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "RUNG6_FIRE direct radio power cycle dwell="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, "ms phoneId="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, " airplane_setting_untouched=true"
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string v1, "AP_LATCH_PROBE"
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 712
    const/4 p0, 0
    invoke-static { p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->setDirectRadioPower(Z)Z
    move-result p0
    if-nez p0, :L0
  .line 713
    const-string p0, "RUNG6_FAIL radio off request unavailable or rejected"
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 714
    return-void
  :L0
  .line 716
    int-to-long v2, v0
  :L1
    invoke-static { v2, v3 }, Ljava/lang/Thread;->sleep(J)V
  :L2
  .line 719
    nop
  .line 720
    const/4 p0, 1
    invoke-static { p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->setDirectRadioPower(Z)Z
    move-result p0
    if-nez p0, :L3
  .line 721
    const-string p0, "RUNG6_ABORT radio on request failed; manual recovery may be required"
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 722
    return-void
  :L3
  .line 724
    const-string p0, "RUNG6_COMPLETE direct radio cycled - airplane_mode_on was not written"
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 725
    return-void
  :L4
  .line 716
    move-exception p0
  .line 717
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Thread;->interrupt()V
  .line 718
    return-void
.end method

.method private static rungPdnRebuild(II)V
  .catchall { :L4 .. :L5 } :L15
  .catch Ljava/lang/InterruptedException; { :L6 .. :L7 } :L8
  .catchall { :L11 .. :L12 } :L13
  .registers 15
  .line 766
    invoke-static { p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findPdnController(I)Ljava/lang/Object;
    move-result-object v0
  .line 767
    const-string v1, "AP_LATCH_PROBE"
    if-nez v0, :L0
  .line 768
    const-string p0, "RUNG5_ABORT could not resolve PdnController"
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 769
    return-void
  :L0
  .line 771
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "RUNG5_PDNCTL "
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v3
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v1, v2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 773
    invoke-static { v0, p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->registeredPdnListener(Ljava/lang/Object;I)Ljava/lang/Object;
    move-result-object v2
  .line 774
    if-nez v2, :L1
  .line 775
    const-string p0, "RUNG5_ABORT no unique registered PdnEventListener found in mNetworkCallbacks - a teardown would be ambiguous or a silent no-op, so it is not attempted"
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 778
    return-void
  :L1
  .line 781
    const/4 v3, 0
    invoke-static { v3, p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findRegisterTask(Ljava/lang/Object;I)Ljava/lang/Object;
    move-result-object v3
  .line 782
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "RUNG5_BEFORE pdnType="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v5, " phoneId="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v6, " listener="
    invoke-virtual { v4, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
  .line 783
    invoke-virtual { v2 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v7
    invoke-virtual { v7 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v7
    invoke-virtual { v4, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v7, " taskState="
    invoke-virtual { v4, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
  .line 784
    if-nez v3, :L2
    const-string v7, "null"
    goto :L3
  :L2
    const-string v7, "getState"
    invoke-static { v3, v7 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v7
  :L3
    invoke-virtual { v4, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v7, " registration="
    invoke-virtual { v4, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
  .line 785
    invoke-static { p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->registrationFingerprint(I)Ljava/lang/String;
    move-result-object v7
    invoke-virtual { v4, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
  .line 782
    invoke-static { v1, v4 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 787
    invoke-virtual { v0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v4
    const-string v7, "stopPdnConnectivity"
    const/4 v8, 3
    invoke-static { v4, v7, v8 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findMethodByName(Ljava/lang/Class;Ljava/lang/String;I)Ljava/lang/reflect/Method;
    move-result-object v4
  .line 788
    invoke-virtual { v0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v7
    const-string v9, "startPdnConnectivity"
    invoke-static { v7, v9, v8 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findMethodByName(Ljava/lang/Class;Ljava/lang/String;I)Ljava/lang/reflect/Method;
    move-result-object v7
  .line 789
    const/4 v9, 1
    const/4 v10, 0
    if-eqz v4, :L16
    if-nez v7, :L4
    goto/16 :L16
  :L4
  .line 795
    new-instance v11, Ljava/lang/StringBuilder;
    invoke-direct { v11 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v12, "RUNG5_FIRE stopPdnConnectivity pdnType="
    invoke-virtual { v11, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v11
    invoke-virtual { v11, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v11
    invoke-virtual { v11, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
  .line 796
    invoke-virtual { v2 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v6
    invoke-virtual { v6 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v6
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
  .line 795
    invoke-static { v1, v5 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 797
    new-array v5, v8, [Ljava/lang/Object;
    invoke-static { p1 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v6
    aput-object v6, v5, v10
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v6
    aput-object v6, v5, v9
    const/4 v6, 2
    aput-object v2, v5, v6
    invoke-virtual { v4, v0, v5 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v4
  .line 798
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v11, "RUNG5_STOPPED returned "
    invoke-virtual { v5, v11 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v5, " (return value is not proof - watch for SETUP_DATA_CALL)"
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    invoke-static { v1, v4 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L5
  .line 803
    nop
  .line 805
    const/16 v4, 1200
    const-string v5, "persist.vendor.ims.ap_latch_probe_pdn_gap_ms"
    invoke-static { v5, v4 }, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I
    move-result v4
  .line 807
    int-to-long v11, v4
  :L6
    invoke-static { v11, v12 }, Ljava/lang/Thread;->sleep(J)V
  :L7
  .line 810
    goto :L9
  :L8
  .line 808
    move-exception v5
  .line 809
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/lang/Thread;->interrupt()V
  :L9
  .line 815
    if-eqz v3, :L10
    goto :L11
  :L10
    move-object v3, v2
  :L11
    invoke-static { v3, p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->phoneIdForStartConnectivity(Ljava/lang/Object;I)I
    move-result p0
  .line 816
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "RUNG5_REBUILD startPdnConnectivity pdnType="
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v5, " startPhoneId="
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v5, " after "
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, "ms"
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static { v1, v3 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 818
    new-array v3, v8, [Ljava/lang/Object;
    invoke-static { p1 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p1
    aput-object p1, v3, v10
    aput-object v2, v3, v9
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p0
    aput-object p0, v3, v6
    invoke-virtual { v7, v0, v3 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  .line 819
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "RUNG5_COMPLETE startPdnConnectivity returned "
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L12
  .line 824
    goto :L14
  :L13
  .line 820
    move-exception p0
  .line 821
    const-string p1, "RUNG5_FAIL startPdnConnectivity threw"
    invoke-static { v1, p1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 822
    const-string p0, "RUNG5_RECOVERY_REQUIRED IMS PDN may be down; use the verified explicit rung-4 recovery, and do not count this run as rung-5 success"
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  :L14
  .line 825
    return-void
  :L15
  .line 800
    move-exception p0
  .line 801
    const-string p1, "RUNG5_FAIL stopPdnConnectivity threw"
    invoke-static { v1, p1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 802
    return-void
  :L16
  .line 790
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p1, "RUNG5_UNAVAILABLE stop="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    if-eqz v4, :L17
    move p1, v9
    goto :L18
  :L17
    move p1, v10
  :L18
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " start="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    if-eqz v7, :L19
    goto :L20
  :L19
    move v9, v10
  :L20
    invoke-virtual { p0, v9 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 791
    return-void
.end method

.method private static rungRadioCycle(I)V
  .catch Ljava/lang/InterruptedException; { :L3 .. :L4 } :L5
  .registers 6
  .line 680
    const-string v0, "ap_latch_probe_radio_dwell_ms"
    const/16 v1, 400
    const/16 v2, 200
    const/16 v3, 10000
    invoke-static { v0, v1, v2, v3 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v0
  .line 681
    const-string v1, "AP_LATCH_PROBE"
    if-ge v0, v2, :L0
  .line 682
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "RUNG4_DWELL raising "
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, "ms to the "
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, "ms floor - too short a dwell desynchronises the call UI"
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 684
    goto :L1
  :L0
  .line 681
    move v2, v0
  :L1
  .line 687
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "RUNG4_FIRE airplane cycle dwell="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, "ms phoneId="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 688
    const/4 p0, 1
    invoke-static { p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->setAirplaneMode(Z)Z
    move-result p0
    if-nez p0, :L2
  .line 689
    const-string p0, "RUNG4_FAIL could not enable airplane mode - radio not cycled"
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 690
    return-void
  :L2
  .line 693
    int-to-long v2, v2
  :L3
    invoke-static { v2, v3 }, Ljava/lang/Thread;->sleep(J)V
  :L4
  .line 696
    goto :L6
  :L5
  .line 694
    move-exception p0
  .line 695
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Thread;->interrupt()V
  :L6
  .line 697
    const/4 p0, 0
    invoke-static { p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->setAirplaneMode(Z)Z
    move-result p0
    if-nez p0, :L7
  .line 698
    const-string p0, "RUNG4_ABORT airplane mode is still ON - the device has no radio. Turn it off manually."
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 700
    return-void
  :L7
  .line 702
    const-string p0, "RUNG4_COMPLETE radio cycled - expect a fresh registration and a new bearer/flow base"
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 704
    return-void
.end method

.method private static rungReRegister(Ljava/lang/Object;II)V
  .catchall { :L3 .. :L4 } :L5
  .catchall { :L9 .. :L10 } :L11
  .registers 12
  .line 424
    const/4 v0, 0
    invoke-static { v0, p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findRegisterTask(Ljava/lang/Object;I)Ljava/lang/Object;
    move-result-object v0
  .line 428
    const-string v1, "sendReRegister"
    const/4 v2, 0
    const/4 v3, 1
    const-string v4, "AP_LATCH_PROBE"
    if-eqz v0, :L7
  .line 429
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v5
    new-array v6, v3, [Ljava/lang/Class;
    invoke-virtual { v0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v7
    aput-object v7, v6, v2
    invoke-static { v5, v1, v6 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v5
  .line 430
    if-nez v5, :L2
  .line 431
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v6
    invoke-static { v6 }, Lcom/sec/internal/google/ApBearerLatchProbe;->collectMethods(Ljava/lang/Class;)Ljava/util/List;
    move-result-object v6
    invoke-interface { v6 }, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v6
  :L0
    invoke-interface { v6 }, Ljava/util/Iterator;->hasNext()Z
    move-result v7
    if-eqz v7, :L2
    invoke-interface { v6 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v7
    check-cast v7, Ljava/lang/reflect/Method;
  .line 432
    invoke-virtual { v7 }, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;
    move-result-object v8
    invoke-virtual { v8, v1 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v8
    if-eqz v8, :L1
  .line 433
    invoke-virtual { v7 }, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;
    move-result-object v8
    array-length v8, v8
    if-ne v8, v3, :L1
  .line 434
    invoke-virtual { v7 }, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;
    move-result-object v8
    aget-object v8, v8, v2
    invoke-virtual { v8, v0 }, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z
    move-result v8
    if-eqz v8, :L1
  .line 435
    invoke-virtual { v7, v3 }, Ljava/lang/reflect/Method;->setAccessible(Z)V
  .line 436
    nop
  .line 437
    move-object v5, v7
    goto :L2
  :L1
  .line 439
    goto :L0
  :L2
  .line 441
    if-eqz v5, :L6
  :L3
  .line 443
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct { v6 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "RUNG1_FIRE sendReRegister(task) phoneId="
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v6
    const-string v7, " task="
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
  .line 444
    invoke-virtual { v0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v7
    invoke-virtual { v7 }, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;
    move-result-object v7
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
  .line 443
    invoke-static { v4, v6 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 445
    new-array v6, v3, [Ljava/lang/Object;
    aput-object v0, v6, v2
    invoke-virtual { v5, p0, v6 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
  .line 446
    const-string v5, "RUNG1_COMPLETE sendReRegister(task) returned - expect an outbound REGISTER within ~1s"
    invoke-static { v4, v5 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L4
  .line 448
    return-void
  :L5
  .line 449
    move-exception v5
  .line 450
    const-string v6, "RUNG1_FAIL sendReRegister(task) threw, falling back"
    invoke-static { v4, v6, v5 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 451
    goto :L7
  :L6
  .line 453
    const-string v5, "RUNG1_NOTE no sendReRegister(RegisterTask) overload, using (int,int)"
    invoke-static { v4, v5 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L7
  .line 461
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v5
    const/4 v6, 2
    new-array v7, v6, [Ljava/lang/Class;
    sget-object v8, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    aput-object v8, v7, v2
    sget-object v8, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    aput-object v8, v7, v3
    invoke-static { v5, v1, v7 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v1
  .line 462
    if-nez v1, :L8
  .line 463
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "RUNG1_UNAVAILABLE no usable sendReRegister on "
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
  .line 464
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object p0
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 463
    invoke-static { v4, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 465
    return-void
  :L8
  .line 468
    nop
  .line 469
    if-eqz v0, :L9
  .line 470
    const-string v5, "getPdnType"
    invoke-static { v0, v5 }, Lcom/sec/internal/google/ApBearerLatchProbe;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
  .line 471
    instance-of v5, v0, Ljava/lang/Integer;
    if-eqz v5, :L9
  .line 472
    check-cast v0, Ljava/lang/Integer;
    invoke-virtual { v0 }, Ljava/lang/Integer;->intValue()I
    move-result v0
  .line 473
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "RUNG1_PDN configured="
    invoke-virtual { v5, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v7, " liveTask="
    invoke-virtual { v5, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static { v4, v5 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 474
    if-eq v0, p2, :L9
  .line 475
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "RUNG1_PDN_OVERRIDE using live task pdnType="
    invoke-virtual { v5, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v7, " (configured "
    invoke-virtual { v5, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    const-string v5, " would match no task)"
    invoke-virtual { p2, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    invoke-static { v4, p2 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 477
    move p2, v0
  :L9
  .line 483
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "RUNG1_FIRE sendReRegister phoneId="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v5, " pdnType="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 484
    new-array v0, v6, [Ljava/lang/Object;
    invoke-static { p1 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p1
    aput-object p1, v0, v2
    invoke-static { p2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p1
    aput-object p1, v0, v3
    invoke-virtual { v1, p0, v0 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
  .line 485
    const-string p0, "RUNG1_COMPLETE sendReRegister returned - check for an outbound REGISTER in the next second to confirm it was not a filter miss"
    invoke-static { v4, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L10
  .line 489
    goto :L12
  :L11
  .line 487
    move-exception p0
  .line 488
    const-string p1, "RUNG1_FAIL sendReRegister threw"
    invoke-static { v4, p1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L12
  .line 490
    return-void
.end method

.method private static rungStopPdn(Ljava/lang/Object;II)V
  .catchall { :L1 .. :L2 } :L3
  .registers 9
  .line 638
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    const-string v1, "stopPdnConnectivity"
    const/4 v2, 2
    invoke-static { v0, v1, v2 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findMethodByName(Ljava/lang/Class;Ljava/lang/String;I)Ljava/lang/reflect/Method;
    move-result-object v0
  .line 639
    const-string v1, "AP_LATCH_PROBE"
    if-nez v0, :L0
  .line 640
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "RUNG3_UNAVAILABLE stopPdnConnectivity/2 not found on "
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
  .line 641
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object p0
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 640
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 642
    return-void
  :L0
  .line 644
    const/4 v3, 0
    invoke-static { v3, p1 }, Lcom/sec/internal/google/ApBearerLatchProbe;->findRegisterTask(Ljava/lang/Object;I)Ljava/lang/Object;
    move-result-object v3
  .line 645
    if-nez v3, :L1
  .line 646
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "RUNG3_ABORT no IRegisterTask resolved for phoneId="
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 647
    return-void
  :L1
  .line 650
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "RUNG3_FIRE stopPdnConnectivity phoneId="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v4, " pdnType="
    invoke-virtual { p1, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v4, " task="
    invoke-virtual { p1, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
  .line 651
    invoke-virtual { v3 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v4
    invoke-virtual { v4 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v4
    invoke-virtual { p1, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
  .line 650
    invoke-static { v1, p1 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 652
    new-array p1, v2, [Ljava/lang/Object;
    const/4 v2, 0
    invoke-static { p2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p2
    aput-object p2, p1, v2
    const/4 p2, 1
    aput-object v3, p1, p2
    invoke-virtual { v0, p0, p1 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
  .line 653
    const-string p0, "RUNG3_COMPLETE stopPdnConnectivity returned normally"
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L2
  .line 656
    goto :L4
  :L3
  .line 654
    move-exception p0
  .line 655
    const-string p1, "RUNG3_FAIL stopPdnConnectivity threw"
    invoke-static { v1, p1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L4
  .line 657
    return-void
.end method

.method private static setAirplaneMode(Z)Z
  .catchall { :L1 .. :L3 } :L8
  .catchall { :L4 .. :L5 } :L6
  .registers 12
  .line 942
    invoke-static { }, Lcom/sec/internal/google/ApBearerLatchProbe;->appContext()Ljava/lang/Object;
    move-result-object v0
  .line 943
    const-string v1, "AP_LATCH_PROBE"
    const/4 v2, 0
    if-nez v0, :L0
  .line 944
    const-string p0, "RUNG4_CTX no application context - cannot toggle airplane mode"
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 945
    return v2
  :L0
  .line 948
    nop
  :L1
  .line 950
    invoke-virtual { v0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v3
    const-string v4, "getContentResolver"
    new-array v5, v2, [Ljava/lang/Class;
  .line 951
    invoke-virtual { v3, v4, v5 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v3
    new-array v4, v2, [Ljava/lang/Object;
    invoke-virtual { v3, v0, v4 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v3
  .line 952
    const-string v4, "android.provider.Settings$Global"
    invoke-static { v4 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v4
  .line 953
    const-string v5, "putInt"
    const/4 v6, 3
    new-array v7, v6, [Ljava/lang/Class;
    const-string v8, "android.content.ContentResolver"
  .line 954
    invoke-static { v8 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v8
    aput-object v8, v7, v2
    const-class v8, Ljava/lang/String;
    const/4 v9, 1
    aput-object v8, v7, v9
    sget-object v8, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v10, 2
    aput-object v8, v7, v10
  .line 953
    invoke-virtual { v4, v5, v7 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v4
  .line 955
    const/4 v5, 0
    new-array v6, v6, [Ljava/lang/Object;
    aput-object v3, v6, v2
    const-string v3, "airplane_mode_on"
    aput-object v3, v6, v9
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    aput-object v3, v6, v10
    invoke-virtual { v4, v5, v6 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v3
  .line 956
    sget-object v4, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;
    invoke-virtual { v4, v3 }, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :L2
  .line 957
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "RUNG4_SETTING putInt(airplane_mode_on,"
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, ") returned false - the write was rejected"
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 959
    return v2
  :L2
  .line 961
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "RUNG4_AIRPLANE airplane_mode_on="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " written via Settings.Global"
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static { v1, v3 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L3
  .line 965
    nop
  :L4
  .line 971
    const-string v3, "android.content.Intent"
    invoke-static { v3 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v3
  .line 972
    new-array v4, v9, [Ljava/lang/Class;
    const-class v5, Ljava/lang/String;
    aput-object v5, v4, v2
    invoke-virtual { v3, v4 }, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;
    move-result-object v4
    new-array v5, v9, [Ljava/lang/Object;
    const-string v6, "android.intent.action.AIRPLANE_MODE"
    aput-object v6, v5, v2
  .line 973
    invoke-virtual { v4, v5 }, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v4
  .line 974
    const-string v5, "putExtra"
    new-array v6, v10, [Ljava/lang/Class;
    const-class v7, Ljava/lang/String;
    aput-object v7, v6, v2
    sget-object v7, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;
    aput-object v7, v6, v9
    invoke-virtual { v3, v5, v6 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v5
    new-array v6, v10, [Ljava/lang/Object;
    const-string v7, "state"
    aput-object v7, v6, v2
  .line 975
    invoke-static { p0 }, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;
    move-result-object v7
    aput-object v7, v6, v9
    invoke-virtual { v5, v4, v6 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
  .line 976
    invoke-virtual { v0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v5
    const-string v6, "sendBroadcast"
    new-array v7, v9, [Ljava/lang/Class;
    aput-object v3, v7, v2
    invoke-virtual { v5, v6, v7 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v3
    new-array v5, v9, [Ljava/lang/Object;
    aput-object v4, v5, v2
  .line 977
    invoke-virtual { v3, v0, v5 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
  .line 978
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "RUNG4_BROADCAST AIRPLANE_MODE state="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L5
  .line 981
    goto :L7
  :L6
  .line 979
    move-exception p0
  .line 980
    const-string v0, "RUNG4_BROADCAST failed (setting was written, radio may still cycle)"
    invoke-static { v1, v0, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L7
  .line 982
    return v9
  :L8
  .line 962
    move-exception v0
  .line 963
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "RUNG4_SETTING failed to write airplane_mode_on="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 964
    return v2
.end method

.method private static setDirectRadioPower(Z)Z
  .catchall { :L0 .. :L3 } :L6
  .registers 10
  .line 729
    const-string v0, "AP_LATCH_PROBE"
    const/4 v1, 0
  :L0
    const-string v2, "android.telephony.TelephonyManager"
    invoke-static { v2 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v2
  .line 730
    invoke-static { }, Lcom/sec/internal/google/ApBearerLatchProbe;->appContext()Ljava/lang/Object;
    move-result-object v3
  .line 731
    if-nez v3, :L1
    return v1
  :L1
  .line 732
    invoke-virtual { v3 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v4
    const-string v5, "getSystemService"
    const/4 v6, 1
    new-array v7, v6, [Ljava/lang/Class;
    const-class v8, Ljava/lang/String;
    aput-object v8, v7, v1
    invoke-virtual { v4, v5, v7 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v4
    new-array v5, v6, [Ljava/lang/Object;
    const-string v7, "phone"
    aput-object v7, v5, v1
  .line 733
    invoke-virtual { v4, v3, v5 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v3
  .line 734
    if-nez v3, :L2
    return v1
  :L2
  .line 735
    const-string v4, "setRadioPower"
    new-array v5, v6, [Ljava/lang/Class;
    sget-object v7, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;
    aput-object v7, v5, v1
    invoke-virtual { v2, v4, v5 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v2
  .line 736
    new-array v4, v6, [Ljava/lang/Object;
    invoke-static { p0 }, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;
    move-result-object v5
    aput-object v5, v4, v1
    invoke-virtual { v2, v3, v4 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v2
  .line 737
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "RUNG6_RADIO_POWER on="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p0 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " result="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " method=TelephonyManager.setRadioPower(Z)"
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static { v0, v3 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 739
    instance-of v3, v2, Ljava/lang/Boolean;
    if-eqz v3, :L4
    check-cast v2, Ljava/lang/Boolean;
    invoke-virtual { v2 }, Ljava/lang/Boolean;->booleanValue()Z
    move-result p0
  :L3
    if-eqz p0, :L5
  :L4
    move v1, v6
  :L5
    return v1
  :L6
  .line 740
    move-exception v2
  .line 741
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "RUNG6_RADIO_POWER unavailable on="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p0 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v0, p0, v2 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 742
    return v1
.end method

.method private static verifyPdnRebuilt(II)V
  .catch Ljava/lang/InterruptedException; { :L2 .. :L3 } :L5
  .registers 7
  .line 303
    const-string v0, "VERIFY_NO_PDN rung="
    const-string v1, "AP_LATCH_PROBE"
    if-gez p1, :L0
  .line 304
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " could not establish the pre-fire SETUP_DATA_CALL baseline"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 306
    return-void
  :L0
  .line 308
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "VERIFY_BEFORE setupDataCalls="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v1, v2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 309
    const/4 v2, 0
  :L1
    const/16 v3, 20
    if-ge v2, v3, :L6
  .line 311
    const-wide/16 v3, 500
  :L2
    invoke-static { v3, v4 }, Ljava/lang/Thread;->sleep(J)V
  :L3
  .line 315
    nop
  .line 316
    const-string v3, "SETUP_DATA_CALL"
    invoke-static { v3 }, Lcom/sec/internal/google/ApBearerLatchProbe;->countLogMatches(Ljava/lang/String;)I
    move-result v3
  .line 317
    if-le v3, p1, :L4
  .line 318
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "VERIFY_PDN_REBUILT rung="
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " after "
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    add-int/lit8 v2, v2, 1
    mul-int/lit16 v2, v2, 500
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, "ms: "
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sub-int/2addr v3, p1
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " new SETUP_DATA_CALL - the rung DID execute"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 320
    return-void
  :L4
  .line 309
    add-int/lit8 v2, v2, 1
    goto :L1
  :L5
  .line 312
    move-exception p0
  .line 313
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Thread;->interrupt()V
  .line 314
    return-void
  :L6
  .line 323
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " no SETUP_DATA_CALL in 10s - the request never reached the RIL, the same failure mode as rung 3"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 325
    return-void
.end method

.method private static verifyRegistrationMoved(III)V
  .catch Ljava/lang/InterruptedException; { :L2 .. :L3 } :L6
  .registers 11
  .line 261
    const/4 v0, 4
    if-lt p1, v0, :L0
  .line 262
    invoke-static { p1, p2 }, Lcom/sec/internal/google/ApBearerLatchProbe;->verifyPdnRebuilt(II)V
  .line 263
    return-void
  :L0
  .line 265
    invoke-static { p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->registrationFingerprint(I)Ljava/lang/String;
    move-result-object p2
  .line 266
    invoke-static { }, Lcom/sec/internal/google/ApBearerLatchProbe;->countRegisterSends()I
    move-result v0
  .line 267
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "VERIFY_BEFORE "
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " registerSends="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    const-string v2, "AP_LATCH_PROBE"
    invoke-static { v2, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 269
    const/4 v1, 0
  :L1
    const/16 v3, 12
    if-ge v1, v3, :L7
  .line 271
    const-wide/16 v3, 500
  :L2
    invoke-static { v3, v4 }, Ljava/lang/Thread;->sleep(J)V
  :L3
  .line 275
    nop
  .line 276
    add-int/lit8 v1, v1, 1
    mul-int/lit16 v3, v1, 500
  .line 280
    invoke-static { }, Lcom/sec/internal/google/ApBearerLatchProbe;->countRegisterSends()I
    move-result v4
  .line 281
    const-string v5, "ms: "
    const-string v6, " after "
    if-le v4, v0, :L4
  .line 282
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "VERIFY_REGISTER_SENT rung="
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sub-int/2addr v4, v0
    invoke-virtual { p0, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " outbound REGISTER(s) - the rung DID execute"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v2, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 285
    return-void
  :L4
  .line 289
    invoke-static { p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->registrationFingerprint(I)Ljava/lang/String;
    move-result-object v4
  .line 290
    invoke-virtual { v4, p2 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v7
    if-nez v7, :L5
  .line 291
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "VERIFY_MOVED rung="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " -> "
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v2, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 293
    return-void
  :L5
  .line 269
    goto/16 :L1
  :L6
  .line 272
    move-exception p0
  .line 273
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Thread;->interrupt()V
  .line 274
    return-void
  :L7
  .line 296
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "VERIFY_NO_CHANGE rung="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " no REGISTER sent and registration unchanged after 6s ("
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, ") - the rung was a NO-OP, not a negative result"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v2, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 299
    return-void
.end method

.method private static waitForAllCallsEnded(Ljava/lang/Object;IIIJ)V
  .catchall { :L1 .. :L3 } :L26
  .catch Ljava/lang/InterruptedException; { :L4 .. :L5 } :L21
  .catchall { :L6 .. :L8 } :L18
  .catchall { :L10 .. :L15 } :L12
  .catchall { :L16 .. :L17 } :L12
  .catchall { :L19 .. :L20 } :L18
  .catch Ljava/lang/InterruptedException; { :L23 .. :L24 } :L25
  .catchall { :L27 .. :L28 } :L26
  .registers 11
  .line 118
    const-class v0, Lcom/sec/internal/google/ApBearerLatchProbe;
  :L0
    monitor-enter v0
  :L1
  .line 119
    sget-wide v1, Lcom/sec/internal/google/ApBearerLatchProbe;->guardGeneration:J
    cmp-long v1, p4, v1
    if-eqz v1, :L2
  .line 120
    const-string p0, "AP_LATCH_PROBE"
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "RUNG4_DEFER stale_generation="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p4, p5 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { p0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 121
    monitor-exit v0
    return-void
  :L2
  .line 123
    monitor-exit v0
  :L3
  .line 124
    invoke-static { p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->liveSessionCount(Ljava/lang/Object;)I
    move-result v1
  .line 125
    if-nez v1, :L22
  .line 132
    const-string v1, "AP_LATCH_PROBE"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "RUNG4_ALL_CALLS_ENDED sessionId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v1, v2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 133
    const-wide/16 v1, 1000
  :L4
    invoke-static { v1, v2 }, Ljava/lang/Thread;->sleep(J)V
  :L5
  .line 136
    nop
  .line 137
    monitor-enter v0
  :L6
  .line 138
    sget-wide v1, Lcom/sec/internal/google/ApBearerLatchProbe;->guardGeneration:J
    cmp-long v1, p4, v1
    if-eqz v1, :L7
  .line 139
    const-string p0, "AP_LATCH_PROBE"
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "RUNG4_DEFER stale_after_debounce="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p4, p5 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { p0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 140
    monitor-exit v0
    return-void
  :L7
  .line 142
    monitor-exit v0
  :L8
  .line 143
    invoke-static { p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->liveSessionCount(Ljava/lang/Object;)I
    move-result p4
    if-eqz p4, :L9
  .line 144
    const-string p0, "AP_LATCH_PROBE"
    const-string p1, "RUNG4_DEFER call_returned_during_debounce"
    invoke-static { p0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 145
    return-void
  :L9
  .line 147
    const-string p4, "AP_LATCH_PROBE"
    const-string p5, "RUNG4_FIRE_ALLOWED all_calls_ended=true"
    invoke-static { p4, p5 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 148
    monitor-enter v0
  .line 149
    const/4 p4, 6
    if-eq p3, p4, :L13
  :L10
    sget-boolean p5, Lcom/sec/internal/google/ApBearerLatchProbe;->formalCallEntered:Z
    if-eqz p5, :L11
    invoke-static { p0 }, Lcom/sec/internal/google/ApBearerLatchProbe;->liveSessionCount(Ljava/lang/Object;)I
    move-result p5
    if-eqz p5, :L13
  :L11
  .line 150
    const-string p0, "AP_LATCH_PROBE"
    const-string p1, "RUNG4_DEFER formal_or_sessions_changed"
    invoke-static { p0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 151
    monitor-exit v0
    return-void
  :L12
  .line 157
    move-exception p0
    goto :L16
  :L13
  .line 153
    if-eq p3, p4, :L14
  .line 154
    const/4 p4, 0
    sput-boolean p4, Lcom/sec/internal/google/ApBearerLatchProbe;->formalCallEntered:Z
  .line 155
    const-string p4, "AP_LATCH_PROBE"
    new-instance p5, Ljava/lang/StringBuilder;
    invoke-direct { p5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "FORMAL_CALL_EXITED sessionId="
    invoke-virtual { p5, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p5
    sget v1, Lcom/sec/internal/google/ApBearerLatchProbe;->formalSessionId:I
    invoke-virtual { p5, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p5
    invoke-virtual { p5 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p5
    invoke-static { p4, p5 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L14
  .line 157
    monitor-exit v0
  :L15
  .line 158
    invoke-static { p0, p1, p2, p3 }, Lcom/sec/internal/google/ApBearerLatchProbe;->fire(Ljava/lang/Object;III)V
  .line 159
    return-void
  :L16
  .line 157
    monitor-exit v0
  :L17
    throw p0
  :L18
  .line 142
    move-exception p0
  :L19
    monitor-exit v0
  :L20
    throw p0
  :L21
  .line 133
    move-exception p0
  .line 134
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Thread;->interrupt()V
  .line 135
    return-void
  :L22
  .line 126
    const-string v2, "AP_LATCH_PROBE"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "RUNG4_WAIT activeSessions="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, " sessionId="
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v2, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 127
    const-wide/16 v1, 500
  :L23
    invoke-static { v1, v2 }, Ljava/lang/Thread;->sleep(J)V
  :L24
  .line 130
    goto/16 :L0
  :L25
  .line 127
    move-exception p0
  .line 128
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Thread;->interrupt()V
  .line 129
    return-void
  :L26
  .line 123
    move-exception p0
  :L27
    monitor-exit v0
  :L28
    throw p0
.end method
