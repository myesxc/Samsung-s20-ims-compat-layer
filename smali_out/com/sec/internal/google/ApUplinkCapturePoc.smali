.class public final Lcom/sec/internal/google/ApUplinkCapturePoc;
.super Ljava/lang/Object;
.source "ApUplinkCapturePoc.java"

.annotation system Ldalvik/annotation/MemberClasses;
  value = {
    Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;
  }
.end annotation

.field private final static ACTIVE:Ljava/util/concurrent/ConcurrentHashMap;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "Ljava/util/concurrent/ConcurrentHashMap<",
      "Ljava/lang/Integer;",
      "Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;",
      ">;"
    }
  .end annotation
.end field

.field private final static TAG:Ljava/lang/String; = "AP_UPLINK_CAPTURE"

.method static constructor <clinit>()V
  .registers 1
  .line 19
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;
    invoke-direct { v0 }, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApUplinkCapturePoc;->ACTIVE:Ljava/util/concurrent/ConcurrentHashMap;
    return-void
.end method

.method private constructor <init>()V
  .registers 1
  .line 20
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method static synthetic access$000()Ljava/util/concurrent/ConcurrentHashMap;
  .registers 1
  .line 17
    sget-object v0, Lcom/sec/internal/google/ApUplinkCapturePoc;->ACTIVE:Ljava/util/concurrent/ConcurrentHashMap;
    return-object v0
.end method

.method static clamp(III)I
  .registers 3
  .line 26
    invoke-static { p2, p0 }, Ljava/lang/Math;->min(II)I
    move-result p0
    invoke-static { p1, p0 }, Ljava/lang/Math;->max(II)I
    move-result p0
    return p0
.end method

.method public static onEnded(I)V
  .registers 2
  .line 22
    const-string v0, "ended"
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApUplinkCapturePoc;->stop(ILjava/lang/String;)V
    return-void
.end method

.method public static onError(I)V
  .registers 2
  .line 23
    const-string v0, "error"
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApUplinkCapturePoc;->stop(ILjava/lang/String;)V
    return-void
.end method

.method public static onEstablished(I)V
  .registers 3
  .line 21
    const-string v0, "persist.vendor.ims.ap_uplink_capture"
    const/4 v1, 0
    invoke-static { v0, v1 }, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    if-nez v0, :L0
    return-void
  :L0
    new-instance v0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;
    invoke-direct { v0, p0 }, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;-><init>(I)V
    sget-object v1, Lcom/sec/internal/google/ApUplinkCapturePoc;->ACTIVE:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p0
    invoke-virtual { v1, p0, v0 }, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
    check-cast p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;
    if-eqz p0, :L1
    const-string v1, "replace"
    invoke-virtual { p0, v1 }, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->stop(Ljava/lang/String;)V
  :L1
    invoke-virtual { v0 }, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->start()V
    return-void
.end method

.method static source(Ljava/lang/String;)I
  .registers 2
  .line 25
    const-string v0, "mic"
    invoke-virtual { v0, p0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :L0
    const/4 p0, 1
    return p0
  :L0
    const-string v0, "voice_communication"
    invoke-virtual { v0, p0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :L1
    const/4 p0, 7
    return p0
  :L1
    const-string v0, "voice_uplink"
    invoke-virtual { v0, p0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result p0
    if-eqz p0, :L2
    const/4 p0, 2
    return p0
  :L2
    const/4 p0, -1
    return p0
.end method

.method private static stop(ILjava/lang/String;)V
  .registers 3
  .line 24
    sget-object v0, Lcom/sec/internal/google/ApUplinkCapturePoc;->ACTIVE:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p0
    invoke-virtual { v0, p0 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
    check-cast p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;
    if-eqz p0, :L0
    invoke-virtual { p0, p1 }, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->stop(Ljava/lang/String;)V
  :L0
    return-void
.end method
