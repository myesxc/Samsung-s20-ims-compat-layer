.class public final Lcom/sec/internal/google/ApDedicatedBearerPoc;
.super Ljava/lang/Object;
.source "ApDedicatedBearerPoc.java"

.field private final static SEQ:Ljava/util/concurrent/atomic/AtomicLong;

.field private final static TAG:Ljava/lang/String; = "AP_QCI_LEDGER"

.method static constructor <clinit>()V
  .registers 1
  .line 10
    new-instance v0, Ljava/util/concurrent/atomic/AtomicLong;
    invoke-direct { v0 }, Ljava/util/concurrent/atomic/AtomicLong;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApDedicatedBearerPoc;->SEQ:Ljava/util/concurrent/atomic/AtomicLong;
    return-void
.end method

.method private constructor <init>()V
  .registers 1
  .line 11
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method private static integer(Ljava/lang/Object;Ljava/lang/String;)I
  .annotation system Ldalvik/annotation/Throws;
    value = {
      Ljava/lang/Exception;
    }
  .end annotation
  .registers 5
  .line 25
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    const/4 v1, 0
    new-array v2, v1, [Ljava/lang/Class;
    invoke-virtual { v0, p1, v2 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object p1
    new-array v0, v1, [Ljava/lang/Object;
    invoke-virtual { p1, p0, v0 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
    check-cast p0, Ljava/lang/Integer;
    invoke-virtual { p0 }, Ljava/lang/Integer;->intValue()I
    move-result p0
    return p0
.end method

.method public static onModule(Ljava/lang/Object;Ljava/lang/Object;)V
  .catchall { :L0 .. :L1 } :L2
  .registers 9
  .line 17
    const-string v0, "AP_QCI_LEDGER"
  :L0
    const-string v1, "getBearerSessionId"
    invoke-static { p1, v1 }, Lcom/sec/internal/google/ApDedicatedBearerPoc;->integer(Ljava/lang/Object;Ljava/lang/String;)I
    move-result v1
  .line 18
    const-string v2, "getQci"
    invoke-static { p1, v2 }, Lcom/sec/internal/google/ApDedicatedBearerPoc;->integer(Ljava/lang/Object;Ljava/lang/String;)I
    move-result v2
  .line 19
    const-string v3, "getBearerState"
    invoke-static { p1, v3 }, Lcom/sec/internal/google/ApDedicatedBearerPoc;->integer(Ljava/lang/Object;Ljava/lang/String;)I
    move-result p1
  .line 20
    const-string v3, "getPhoneId"
    const/4 v4, -1
    invoke-static { p0, v3, v4 }, Lcom/sec/internal/google/ApDedicatedBearerPoc;->optionalInteger(Ljava/lang/Object;Ljava/lang/String;I)I
    move-result v3
  .line 21
    const-string v5, "getCallStateOrdinal"
    invoke-static { p0, v5, v4 }, Lcom/sec/internal/google/ApDedicatedBearerPoc;->optionalInteger(Ljava/lang/Object;Ljava/lang/String;I)I
    move-result p0
  .line 22
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "QCI_EVENT seq="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    sget-object v5, Lcom/sec/internal/google/ApDedicatedBearerPoc;->SEQ:Ljava/util/concurrent/atomic/AtomicLong;
    invoke-virtual { v5 }, Ljava/util/concurrent/atomic/AtomicLong;->incrementAndGet()J
    move-result-wide v5
    invoke-virtual { v4, v5, v6 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v5, " stage=MODULE phoneId="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " sessionId="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, " qci="
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " state="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v1, " callState="
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " elapsedMs="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v1
    invoke-virtual { p0, v1, v2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " thread="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/Thread;->getName()Ljava/lang/String;
    move-result-object p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v0, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L1
  .line 23
    goto :L3
  :L2
    move-exception p0
    const-string p1, "QCI_EVENT_FAIL stage=MODULE"
    invoke-static { v0, p1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L3
  .line 24
    return-void
.end method

.method public static onRaw(III)V
  .registers 6
  .line 13
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "QCI_EVENT seq="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    sget-object v1, Lcom/sec/internal/google/ApDedicatedBearerPoc;->SEQ:Ljava/util/concurrent/atomic/AtomicLong;
    invoke-virtual { v1 }, Ljava/util/concurrent/atomic/AtomicLong;->incrementAndGet()J
    move-result-wide v1
    invoke-virtual { v0, v1, v2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " stage=RAW sessionId="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    const-string v0, " qci="
    invoke-virtual { p2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p2, " state="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " elapsedMs="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide p1
    invoke-virtual { p0, p1, p2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " thread="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/Thread;->getName()Ljava/lang/String;
    move-result-object p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string p1, "AP_QCI_LEDGER"
    invoke-static { p1, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 14
    return-void
.end method

.method private static optionalInteger(Ljava/lang/Object;Ljava/lang/String;I)I
  .catchall { :L0 .. :L1 } :L2
  .registers 3
  :L0
  .line 26
    invoke-static { p0, p1 }, Lcom/sec/internal/google/ApDedicatedBearerPoc;->integer(Ljava/lang/Object;Ljava/lang/String;)I
    move-result p0
  :L1
    return p0
  :L2
    move-exception p0
    return p2
.end method
