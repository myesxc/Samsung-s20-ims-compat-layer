.class final Lcom/sec/internal/google/ApRtpReceivePoc$Frame;
.super Ljava/lang/Object;
.source "ApRtpReceivePoc.java"

.annotation system Ldalvik/annotation/EnclosingClass;
  value = Lcom/sec/internal/google/ApRtpReceivePoc;
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 26
  name = "Frame"
.end annotation

.field final au:[B

.field final seq:I

.field final timestamp:J

.method constructor <init>(IJ[B)V
  .registers 5
  .line 180
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    iput p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Frame;->seq:I
    iput-wide p2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Frame;->timestamp:J
    iput-object p4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Frame;->au:[B
    return-void
.end method
