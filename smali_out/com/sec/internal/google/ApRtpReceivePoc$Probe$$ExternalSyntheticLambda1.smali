.class public final synthetic Lcom/sec/internal/google/ApRtpReceivePoc$Probe$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.source "D8$$SyntheticClass"

.field public final synthetic f$0:Lcom/sec/internal/google/ApRtpReceivePoc$Probe;

.method public synthetic constructor <init>(Lcom/sec/internal/google/ApRtpReceivePoc$Probe;)V
  .registers 2
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe$$ExternalSyntheticLambda1;->f$0:Lcom/sec/internal/google/ApRtpReceivePoc$Probe;
    return-void
.end method

.method public final run()V
  .registers 2
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe$$ExternalSyntheticLambda1;->f$0:Lcom/sec/internal/google/ApRtpReceivePoc$Probe;
    invoke-virtual { v0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->receiveRtcp()V
    return-void
.end method
