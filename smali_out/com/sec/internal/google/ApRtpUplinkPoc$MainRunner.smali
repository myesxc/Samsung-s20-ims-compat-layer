.class final Lcom/sec/internal/google/ApRtpUplinkPoc$MainRunner;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.source "ApRtpUplinkPoc.java"

.annotation system Ldalvik/annotation/EnclosingClass;
  value = Lcom/sec/internal/google/ApRtpUplinkPoc;
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 26
  name = "MainRunner"
.end annotation

.field final owner:Lcom/sec/internal/google/ApRtpUplinkPoc;

.method constructor <init>(Lcom/sec/internal/google/ApRtpUplinkPoc;)V
  .registers 2
  .line 23
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$MainRunner;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    return-void
.end method

.method public run()V
  .registers 2
  .line 23
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc$MainRunner;->owner:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-static { v0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->access$000(Lcom/sec/internal/google/ApRtpUplinkPoc;)V
    return-void
.end method
