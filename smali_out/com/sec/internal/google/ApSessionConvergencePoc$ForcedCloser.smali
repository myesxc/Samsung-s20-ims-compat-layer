.class final Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.source "ApSessionConvergencePoc.java"

.annotation system Ldalvik/annotation/EnclosingClass;
  value = Lcom/sec/internal/google/ApSessionConvergencePoc;
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 26
  name = "ForcedCloser"
.end annotation

.field final callId:I

.field final session:Ljava/lang/Object;

.field final token:J

.method constructor <init>(Ljava/lang/Object;IJ)V
  .registers 5
  .line 21
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->session:Ljava/lang/Object;
    iput p2, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->callId:I
    iput-wide p3, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->token:J
    return-void
.end method

.method public run()V
  .catch Ljava/lang/InterruptedException; { :L0 .. :L1 } :L9
  .catchall { :L2 .. :L3 } :L4
  .catchall { :L5 .. :L6 } :L7
  .registers 8
  .line 22
    const-wide/16 v0, 2000
  :L0
    invoke-static { v0, v1 }, Ljava/lang/Thread;->sleep(J)V
  :L1
    invoke-static { }, Lcom/sec/internal/google/ApSessionConvergencePoc;->access$000()Ljava/util/concurrent/ConcurrentHashMap;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->callId:I
    invoke-static { v1 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    invoke-virtual { v0, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/Long;
    const-string v1, " token="
    const-string v2, "AP_SESSION_CONVERGENCE"
    if-eqz v0, :L8
    invoke-virtual { v0 }, Ljava/lang/Long;->longValue()J
    move-result-wide v3
    iget-wide v5, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->token:J
    cmp-long v0, v3, v5
    if-eqz v0, :L2
    goto/16 :L8
  :L2
    iget-object v0, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->session:Ljava/lang/Object;
    invoke-virtual { v0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    const-string v3, "close"
    const/4 v4, 0
    new-array v5, v4, [Ljava/lang/Class;
    invoke-virtual { v0, v3, v5 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
    iget-object v3, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->session:Ljava/lang/Object;
    new-array v4, v4, [Ljava/lang/Object;
    invoke-virtual { v0, v3, v4 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "MODERN_TERMINATION_FORCED callId="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v3, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->callId:I
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->token:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " action=legacy_close"
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v2, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L3
    goto :L6
  :L4
    move-exception v0
  :L5
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "FORCE_CLOSE_FAIL callId="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget v4, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->callId:I
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget-wide v3, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->token:J
    invoke-virtual { v1, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v2, v1, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L6
    invoke-static { }, Lcom/sec/internal/google/ApSessionConvergencePoc;->access$000()Ljava/util/concurrent/ConcurrentHashMap;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->callId:I
    invoke-static { v1 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    iget-wide v2, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->token:J
    invoke-static { v2, v3 }, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;
    move-result-object v2
    invoke-virtual { v0, v1, v2 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;Ljava/lang/Object;)Z
    return-void
  :L7
    move-exception v0
    invoke-static { }, Lcom/sec/internal/google/ApSessionConvergencePoc;->access$000()Ljava/util/concurrent/ConcurrentHashMap;
    move-result-object v1
    iget v2, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->callId:I
    invoke-static { v2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v2
    iget-wide v3, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->token:J
    invoke-static { v3, v4 }, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;
    move-result-object v3
    invoke-virtual { v1, v2, v3 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;Ljava/lang/Object;)Z
    throw v0
  :L8
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "FORCE_SKIP callId="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v3, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->callId:I
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, p0, Lcom/sec/internal/google/ApSessionConvergencePoc$ForcedCloser;->token:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v2, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return-void
  :L9
    move-exception v0
    return-void
.end method
