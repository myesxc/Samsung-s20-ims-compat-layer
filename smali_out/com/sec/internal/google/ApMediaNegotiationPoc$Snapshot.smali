.class public final Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;
.super Ljava/lang/Object;
.source "ApMediaNegotiationPoc.java"

.annotation system Ldalvik/annotation/EnclosingClass;
  value = Lcom/sec/internal/google/ApMediaNegotiationPoc;
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 25
  name = "Snapshot"
.end annotation

.field public final channel:I

.field public final clock:I

.field public final codec:Ljava/lang/String;

.field public final generation:J

.field public final octetAligned:Z

.field public final ptime:I

.field public final rxPt:I

.field public final txPt:I

.method constructor <init>(Lcom/sec/internal/google/ApMediaNegotiationPoc$State;)V
  .registers 4
  .line 27
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
  .line 28
    iget v0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->channel:I
    iput v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->channel:I
  .line 29
    iget-wide v0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->generation:J
    iput-wide v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->generation:J
  .line 30
    iget-object v0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->codec:Ljava/lang/String;
    iput-object v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->codec:Ljava/lang/String;
  .line 31
    iget v0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->txPt:I
    iput v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->txPt:I
  .line 32
    iget v0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->rxPt:I
    iput v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->rxPt:I
  .line 33
    iget v0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->clock:I
    iput v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->clock:I
  .line 34
    iget v0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->ptime:I
    iput v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->ptime:I
  .line 35
    iget-boolean p1, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->octetAligned:Z
    iput-boolean p1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->octetAligned:Z
  .line 36
    return-void
.end method

.method public amrNb()Z
  .registers 3
  .line 39
    iget-object v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->codec:Ljava/lang/String;
    const-string v1, "AMR"
    invoke-virtual { v1, v0 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :L1
    iget-object v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->codec:Ljava/lang/String;
    const-string v1, "AMR-NB"
    invoke-virtual { v1, v0 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v0
    if-eqz v0, :L0
    goto :L1
  :L0
    const/4 v0, 0
    goto :L2
  :L1
    const/4 v0, 1
  :L2
    return v0
.end method
