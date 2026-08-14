.class final Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.source "ApRtpUplinkPoc.java"

.annotation system Ldalvik/annotation/EnclosingClass;
  value = Lcom/sec/internal/google/ApRtpUplinkPoc;
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 26
  name = "PulseStopper"
.end annotation

.field final owner:Lcom/sec/internal/google/ApRtpUplinkPoc;

.method constructor <init>(Lcom/sec/internal/google/ApRtpUplinkPoc;)V
  .registers 2
  .line 37
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    return-void
.end method

.method public run()V
  .catch Ljava/lang/InterruptedException; { :L0 .. :L1 } :L4
  .catchall { :L0 .. :L1 } :L2
  .registers 5
  .line 37
    const-wide/16 v0, 160
    const/4 v2, 0
  :L0
    invoke-static { v0, v1 }, Ljava/lang/Thread;->sleep(J)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-static { v0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->access$200(Lcom/sec/internal/google/ApRtpUplinkPoc;)Ljava/util/concurrent/atomic/AtomicBoolean;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v0
    if-eqz v0, :L1
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-virtual { v0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->stopDtmf()Z
  :L1
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-static { v0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->access$300(Lcom/sec/internal/google/ApRtpUplinkPoc;)Ljava/lang/Thread;
    move-result-object v0
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v1
    if-ne v0, v1, :L6
    goto :L5
  :L2
    move-exception v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-static { v1 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->access$300(Lcom/sec/internal/google/ApRtpUplinkPoc;)Ljava/lang/Thread;
    move-result-object v1
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v3
    if-ne v1, v3, :L3
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-static { v1, v2 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->access$302(Lcom/sec/internal/google/ApRtpUplinkPoc;Ljava/lang/Thread;)Ljava/lang/Thread;
  :L3
    throw v0
  :L4
    move-exception v0
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-static { v0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->access$300(Lcom/sec/internal/google/ApRtpUplinkPoc;)Ljava/lang/Thread;
    move-result-object v0
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v1
    if-ne v0, v1, :L6
  :L5
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-static { v0, v2 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->access$302(Lcom/sec/internal/google/ApRtpUplinkPoc;Ljava/lang/Thread;)Ljava/lang/Thread;
  :L6
    return-void
.end method
