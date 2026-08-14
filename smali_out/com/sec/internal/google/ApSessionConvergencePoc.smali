.class public final Lcom/sec/internal/google/ApSessionConvergencePoc;
.super Ljava/lang/Object;
.source "ApSessionConvergencePoc.java"

.annotation system Ldalvik/annotation/MemberClasses;
  value = {
    Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;
  }
.end annotation

.field private final static PENDING:Ljava/util/concurrent/ConcurrentHashMap;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "Ljava/util/concurrent/ConcurrentHashMap<",
      "Ljava/lang/Integer;",
      "Ljava/lang/Long;",
      ">;"
    }
  .end annotation
.end field

.field private final static TAG:Ljava/lang/String; = "AP_SESSION_CONVERGENCE"

.field private final static TOKENS:Ljava/util/concurrent/atomic/AtomicLong;

.method static constructor <clinit>()V
  .registers 1
  .line 10
    new-instance v0, Ljava/util/concurrent/atomic/AtomicLong;
    invoke-direct { v0 }, Ljava/util/concurrent/atomic/AtomicLong;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApSessionConvergencePoc;->TOKENS:Ljava/util/concurrent/atomic/AtomicLong;
  .line 11
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;
    invoke-direct { v0 }, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApSessionConvergencePoc;->PENDING:Ljava/util/concurrent/ConcurrentHashMap;
    return-void
.end method

.method private constructor <init>()V
  .registers 1
  .line 12
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method static synthetic access$000()Ljava/util/concurrent/ConcurrentHashMap;
  .registers 1
  .line 8
    sget-object v0, Lcom/sec/internal/google/ApSessionConvergencePoc;->PENDING:Ljava/util/concurrent/ConcurrentHashMap;
    return-object v0
.end method

.method public static onEnded(I)V
  .registers 4
  .line 18
    sget-object v0, Lcom/sec/internal/google/ApSessionConvergencePoc;->PENDING:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    invoke-virtual { v0, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/Long;
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "ENDED_CANCEL callId="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v1, " pending="
    invoke-virtual { p0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    if-eqz v0, :L0
    const/4 v0, 1
    goto :L1
  :L0
    const/4 v0, 0
  :L1
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string v0, "AP_SESSION_CONVERGENCE"
    invoke-static { v0, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

.method public static onError(Ljava/lang/Object;II)V
  .registers 8
  .line 14
    sget-object v0, Lcom/sec/internal/google/ApSessionConvergencePoc;->TOKENS:Ljava/util/concurrent/atomic/AtomicLong;
    invoke-virtual { v0 }, Ljava/util/concurrent/atomic/AtomicLong;->incrementAndGet()J
    move-result-wide v0
    sget-object v2, Lcom/sec/internal/google/ApSessionConvergencePoc;->PENDING:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static { p1 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    invoke-static { v0, v1 }, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;
    move-result-object v4
    invoke-virtual { v2, v3, v4 }, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
  .line 15
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "ERROR_ARM callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " error="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    const-string v2, " token="
    invoke-virtual { p2, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, v0, v1 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p2
    const-string v2, " timeoutMs=2000"
    invoke-virtual { p2, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    const-string v2, "AP_SESSION_CONVERGENCE"
    invoke-static { v2, p2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 16
    new-instance p2, Ljava/lang/Thread;
    new-instance v2, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;
    invoke-direct { v2, p0, p1, v0, v1 }, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;-><init>(Ljava/lang/Object;IJ)V
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "ap-session-close-"
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-direct { p2, v2, p0 }, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V
    const/4 p0, 1
    invoke-virtual { p2, p0 }, Ljava/lang/Thread;->setDaemon(Z)V
    invoke-virtual { p2 }, Ljava/lang/Thread;->start()V
  .line 17
    return-void
.end method
