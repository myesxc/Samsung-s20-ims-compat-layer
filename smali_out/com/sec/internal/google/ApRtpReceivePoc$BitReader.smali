.class final Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;
.super Ljava/lang/Object;
.source "ApRtpReceivePoc.java"

.annotation system Ldalvik/annotation/EnclosingClass;
  value = Lcom/sec/internal/google/ApRtpReceivePoc;
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 26
  name = "BitReader"
.end annotation

.field bit:I

.field final data:[B

.field final endBit:I

.method constructor <init>([BII)V
  .registers 4
  .line 184
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->data:[B
    mul-int/lit8 p1, p2, 8
    iput p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->bit:I
    add-int/2addr p2, p3
    mul-int/lit8 p2, p2, 8
    iput p2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->endBit:I
    return-void
.end method

.method read(I)I
  .registers 6
  .line 187
    if-ltz p1, :L2
    const/16 v0, 31
    if-gt p1, v0, :L2
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->remaining()I
    move-result v0
    if-lt v0, p1, :L2
  .line 188
    const/4 v0, 0
  :L0
    add-int/lit8 v1, p1, -1
    if-lez p1, :L1
    shl-int/lit8 p1, v0, 1
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->data:[B
    iget v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->bit:I
    shr-int/lit8 v3, v2, 3
    aget-byte v0, v0, v3
    add-int/lit8 v3, v2, 1
    iput v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->bit:I
    and-int/lit8 v2, v2, 7
    rsub-int/lit8 v2, v2, 7
    shr-int/2addr v0, v2
    and-int/lit8 v0, v0, 1
    or-int/2addr v0, p1
    move p1, v1
    goto :L0
  :L1
    return v0
  :L2
  .line 187
    new-instance p1, Ljava/lang/IllegalArgumentException;
    const-string v0, "short payload"
    invoke-direct { p1, v0 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw p1
.end method

.method readStorage(III)[B
  .registers 9
  .line 191
    add-int/lit8 v0, p3, 7
    div-int/lit8 v0, v0, 8
    const/4 v1, 1
    add-int/2addr v0, v1
    new-array v0, v0, [B
    shl-int/lit8 p1, p1, 3
    and-int/2addr p2, v1
    shl-int/lit8 p2, p2, 2
    or-int/2addr p1, p2
    int-to-byte p1, p1
    const/4 p2, 0
    aput-byte p1, v0, p2
  .line 192
    nop
  :L0
    if-ge p2, p3, :L2
    invoke-virtual { p0, v1 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result p1
    if-eqz p1, :L1
    shr-int/lit8 p1, p2, 3
    add-int/2addr p1, v1
    aget-byte v2, v0, p1
    const/16 v3, 128
    and-int/lit8 v4, p2, 7
    shr-int/2addr v3, v4
    int-to-byte v3, v3
    or-int/2addr v2, v3
    int-to-byte v2, v2
    aput-byte v2, v0, p1
  :L1
    add-int/lit8 p2, p2, 1
    goto :L0
  :L2
  .line 193
    return-object v0
.end method

.method remaining()I
  .registers 3
  .line 185
    iget v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->endBit:I
    iget v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->bit:I
    sub-int/2addr v0, v1
    return v0
.end method
