.class final Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
.super Ljava/lang/Object;
.source "ApMediaNegotiationPoc.java"

.annotation system Ldalvik/annotation/EnclosingClass;
  value = Lcom/sec/internal/google/ApMediaNegotiationPoc;
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 24
  name = "State"
.end annotation

.field volatile bitrate:I

.field final channel:I

.field volatile clock:I

.field volatile codec:Ljava/lang/String;

.field final createdMs:J

.field volatile deleted:Z

.field volatile direction:I

.field final generation:J

.field volatile lastOp:Ljava/lang/String;

.field volatile localIp:Ljava/lang/String;

.field volatile localRtcp:I

.field volatile localRtp:I

.field volatile maxPtime:I

.field volatile modeSet:I

.field volatile octetAligned:Z

.field volatile ptime:I

.field volatile remoteIp:Ljava/lang/String;

.field volatile remoteRtcp:I

.field volatile remoteRtp:I

.field volatile rxPt:I

.field volatile started:Z

.field volatile stopped:Z

.field volatile txPt:I

.field volatile updatedMs:J

.method constructor <init>(I)V
  .registers 4
  .line 69
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
  .line 56
    const/4 v0, -1
    iput v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->txPt:I
  .line 57
    iput v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->rxPt:I
  .line 70
    iput p1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->channel:I
  .line 71
    invoke-static { }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->access$000()Ljava/util/concurrent/atomic/AtomicLong;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/util/concurrent/atomic/AtomicLong;->incrementAndGet()J
    move-result-wide v0
    iput-wide v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->generation:J
  .line 72
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    iput-wide v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->updatedMs:J
    iput-wide v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->createdMs:J
  .line 73
    return-void
.end method

.method describe()Ljava/lang/String;
  .registers 6
  .line 85
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "generation="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->generation:J
    invoke-virtual { v0, v1, v2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " channel="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->channel:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " local="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->localIp:Ljava/lang/String;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, ":"
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v2, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->localRtp:I
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " remote="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v2, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->remoteIp:Ljava/lang/String;
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->remoteRtp:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rtcp="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->localRtcp:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, "/"
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->remoteRtcp:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " codec="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->codec:Ljava/lang/String;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " txPt="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->txPt:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rxPt="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->rxPt:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " clock="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->clock:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " bitrate="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->bitrate:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " ptime="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->ptime:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " maxPtime="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->maxPtime:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " octetAligned="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-boolean v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->octetAligned:Z
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " modeSet="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->modeSet:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " direction="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->direction:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " started="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-boolean v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->started:Z
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " stopped="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-boolean v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->stopped:Z
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " deleted="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-boolean v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->deleted:Z
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " downlinkReady="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 95
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->downlinkReady()Z
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " ageMs="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 96
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v1
    iget-wide v3, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->createdMs:J
    sub-long/2addr v1, v3
    invoke-virtual { v0, v1, v2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
  .line 85
    return-object v0
.end method

.method downlinkReady()Z
  .registers 7
  .line 76
    iget-object v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->codec:Ljava/lang/String;
    const-string v1, "AMR-WB"
    invoke-virtual { v1, v0 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v0
  .line 77
    iget-object v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->codec:Ljava/lang/String;
    const-string v2, "AMR"
    invoke-virtual { v2, v1 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v1
    const/4 v2, 0
    const/4 v3, 1
    if-nez v1, :L1
    iget-object v1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->codec:Ljava/lang/String;
    const-string v4, "AMR-NB"
    invoke-virtual { v4, v1 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :L0
    goto :L1
  :L0
    move v1, v2
    goto :L2
  :L1
    move v1, v3
  :L2
  .line 78
    if-eqz v1, :L3
    const/16 v4, 8000
    goto :L4
  :L3
    const/16 v4, 16000
  :L4
  .line 79
    iget-boolean v5, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->started:Z
    if-eqz v5, :L6
    iget-boolean v5, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->stopped:Z
    if-nez v5, :L6
    iget-boolean v5, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->deleted:Z
    if-nez v5, :L6
    if-nez v0, :L5
    if-eqz v1, :L6
  :L5
    iget v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->txPt:I
    if-ltz v0, :L6
    iget v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->txPt:I
    const/16 v1, 127
    if-gt v0, v1, :L6
    iget v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->rxPt:I
    if-ltz v0, :L6
    iget v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->rxPt:I
    if-gt v0, v1, :L6
    iget v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->clock:I
    if-ne v0, v4, :L6
    iget v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->ptime:I
    const/16 v1, 20
    if-ne v0, v1, :L6
    iget-boolean v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->octetAligned:Z
    if-nez v0, :L6
    move v2, v3
  :L6
    return v2
.end method
