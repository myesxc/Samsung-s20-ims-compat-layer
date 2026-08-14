.class final Lcom/sec/internal/google/ApRtpUplinkPoc$DtmfRunner;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.source "ApRtpUplinkPoc.java"

.annotation system Ldalvik/annotation/EnclosingClass;
  value = Lcom/sec/internal/google/ApRtpUplinkPoc;
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 26
  name = "DtmfRunner"
.end annotation

.field final event:I

.field final owner:Lcom/sec/internal/google/ApRtpUplinkPoc;

.method constructor <init>(Lcom/sec/internal/google/ApRtpUplinkPoc;I)V
  .registers 3
  .line 36
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$DtmfRunner;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    iput p2, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$DtmfRunner;->event:I
    return-void
.end method

.method public run()V
  .registers 3
  .line 36
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$DtmfRunner;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    iget v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$DtmfRunner;->event:I
    invoke-static { v0, v1 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->access$100(Lcom/sec/internal/google/ApRtpUplinkPoc;I)V
    return-void
.end method
