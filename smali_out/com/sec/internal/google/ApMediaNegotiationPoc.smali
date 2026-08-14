.class public final Lcom/sec/internal/google/ApMediaNegotiationPoc;
.super Ljava/lang/Object;
.source "ApMediaNegotiationPoc.java"

.annotation system Ldalvik/annotation/MemberClasses;
  value = {
    Lcom/sec/internal/google/ApMediaNegotiationPoc$State;,
    Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;
  }
.end annotation

.field private final static CHANNELS:Ljava/util/concurrent/ConcurrentHashMap;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "Ljava/util/concurrent/ConcurrentHashMap<",
      "Ljava/lang/Integer;",
      "Lcom/sec/internal/google/ApMediaNegotiationPoc$State;",
      ">;"
    }
  .end annotation
.end field

.field private final static GENERATIONS:Ljava/util/concurrent/atomic/AtomicLong;

.field private final static OPERATIONS:Ljava/util/concurrent/atomic/AtomicLong;

.field private final static TAG:Ljava/lang/String; = "AP_MEDIA_NEGOTIATION"

.method static constructor <clinit>()V
  .registers 1
  .line 11
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;
    invoke-direct { v0 }, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApMediaNegotiationPoc;->CHANNELS:Ljava/util/concurrent/ConcurrentHashMap;
  .line 12
    new-instance v0, Ljava/util/concurrent/atomic/AtomicLong;
    invoke-direct { v0 }, Ljava/util/concurrent/atomic/AtomicLong;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApMediaNegotiationPoc;->GENERATIONS:Ljava/util/concurrent/atomic/AtomicLong;
  .line 13
    new-instance v0, Ljava/util/concurrent/atomic/AtomicLong;
    invoke-direct { v0 }, Ljava/util/concurrent/atomic/AtomicLong;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApMediaNegotiationPoc;->OPERATIONS:Ljava/util/concurrent/atomic/AtomicLong;
    return-void
.end method

.method private constructor <init>()V
  .registers 1
  .line 15
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method static synthetic access$000()Ljava/util/concurrent/atomic/AtomicLong;
  .registers 1
  .line 9
    sget-object v0, Lcom/sec/internal/google/ApMediaNegotiationPoc;->GENERATIONS:Ljava/util/concurrent/atomic/AtomicLong;
    return-object v0
.end method

.method public static awaitUniqueReady(J)Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;
  .catch Ljava/lang/InterruptedException; { :L7 .. :L8 } :L9
  .registers 12
  .line 216
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    const-wide/16 v2, 0
    invoke-static { v2, v3, p0, p1 }, Ljava/lang/Math;->max(JJ)J
    move-result-wide p0
    add-long/2addr v0, p0
  :L0
  .line 218
    new-instance p0, Ljava/util/ArrayList;
    invoke-direct { p0 }, Ljava/util/ArrayList;-><init>()V
  .line 219
    sget-object p1, Lcom/sec/internal/google/ApMediaNegotiationPoc;->CHANNELS:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-virtual { p1 }, Ljava/util/concurrent/ConcurrentHashMap;->values()Ljava/util/Collection;
    move-result-object p1
    invoke-interface { p1 }, Ljava/util/Collection;->iterator()Ljava/util/Iterator;
    move-result-object p1
  :L1
    invoke-interface { p1 }, Ljava/util/Iterator;->hasNext()Z
    move-result v2
    if-eqz v2, :L3
    invoke-interface { p1 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
  .line 220
    invoke-virtual { v2 }, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->downlinkReady()Z
    move-result v3
    if-eqz v3, :L2
    invoke-virtual { p0, v2 }, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
  :L2
  .line 221
    goto :L1
  :L3
  .line 222
    invoke-virtual { p0 }, Ljava/util/ArrayList;->size()I
    move-result p1
    const-string v2, " total="
    const/4 v3, 1
    const/4 v4, 0
    const-string v5, "AP_MEDIA_NEGOTIATION"
    if-ne p1, v3, :L4
  .line 223
    const/4 p1, 0
    invoke-virtual { p0, p1 }, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object p1
    check-cast p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
  .line 224
    new-instance v3, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;
    invoke-direct { v3, p1 }, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;-><init>(Lcom/sec/internal/google/ApMediaNegotiationPoc$State;)V
  .line 225
    sget-object v6, Lcom/sec/internal/google/ApMediaNegotiationPoc;->CHANNELS:Ljava/util/concurrent/ConcurrentHashMap;
    iget v7, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->channel:I
    invoke-static { v7 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v7
    invoke-virtual { v6, v7 }, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v6
    if-ne v6, p1, :L5
    iget-wide v6, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->generation:J
    iget-wide v8, v3, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->generation:J
    cmp-long v6, v6, v8
    if-nez v6, :L5
  .line 226
    invoke-virtual { p1 }, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->downlinkReady()Z
    move-result p1
    if-eqz p1, :L5
  .line 227
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p1, "MEDIA_CORRELATION_READY channel="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    iget p1, v3, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->channel:I
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " generation="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    iget-wide v0, v3, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->generation:J
    invoke-virtual { p0, v0, v1 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " codec="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    iget-object p1, v3, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->codec:Ljava/lang/String;
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " txPt="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    iget p1, v3, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->txPt:I
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " rxPt="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    iget p1, v3, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->rxPt:I
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v5, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 231
    return-object v3
  :L4
  .line 233
    invoke-virtual { p0 }, Ljava/util/ArrayList;->size()I
    move-result p1
    if-le p1, v3, :L5
  .line 234
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "MEDIA_CORRELATION_REJECT reason=ambiguous readyCount="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
  .line 235
    invoke-virtual { p0 }, Ljava/util/ArrayList;->size()I
    move-result p0
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget-object p1, Lcom/sec/internal/google/ApMediaNegotiationPoc;->CHANNELS:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-virtual { p1 }, Ljava/util/concurrent/ConcurrentHashMap;->size()I
    move-result p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 234
    invoke-static { v5, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 236
    return-object v4
  :L5
  .line 233
    nop
  .line 238
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v6
    cmp-long p1, v6, v0
    if-ltz p1, :L6
  .line 239
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "MEDIA_CORRELATION_REJECT reason=timeout readyCount="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
  .line 240
    invoke-virtual { p0 }, Ljava/util/ArrayList;->size()I
    move-result p0
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget-object p1, Lcom/sec/internal/google/ApMediaNegotiationPoc;->CHANNELS:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-virtual { p1 }, Ljava/util/concurrent/ConcurrentHashMap;->size()I
    move-result p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 239
    invoke-static { v5, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 241
    return-object v4
  :L6
  .line 244
    const-wide/16 p0, 25
  :L7
    invoke-static { p0, p1 }, Ljava/lang/Thread;->sleep(J)V
  :L8
  .line 249
    nop
  .line 250
    goto/16 :L0
  :L9
  .line 245
    move-exception p0
  .line 246
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Thread;->interrupt()V
  .line 247
    const-string p0, "MEDIA_CORRELATION_REJECT reason=interrupted"
    invoke-static { v5, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 248
    return-object v4
.end method

.method private static log(Ljava/lang/String;Lcom/sec/internal/google/ApMediaNegotiationPoc$State;)V
  .registers 5
  .line 111
    iput-object p0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->lastOp:Ljava/lang/String;
  .line 112
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    iput-wide v0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->updatedMs:J
  .line 113
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "SVE_LIFECYCLE seq="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    sget-object v1, Lcom/sec/internal/google/ApMediaNegotiationPoc;->OPERATIONS:Ljava/util/concurrent/atomic/AtomicLong;
    invoke-virtual { v1 }, Ljava/util/concurrent/atomic/AtomicLong;->incrementAndGet()J
    move-result-wide v1
    invoke-virtual { v0, v1, v2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " op="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " thread="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 114
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/Thread;->getName()Ljava/lang/String;
    move-result-object v0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " "
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 115
    invoke-virtual { p1 }, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->describe()Ljava/lang/String;
    move-result-object p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " active="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget-object p1, Lcom/sec/internal/google/ApMediaNegotiationPoc;->CHANNELS:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-virtual { p1 }, Ljava/util/concurrent/ConcurrentHashMap;->size()I
    move-result p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 113
    const-string p1, "AP_MEDIA_NEGOTIATION"
    invoke-static { p1, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 116
    return-void
.end method

.method public static onCodec(ILjava/lang/String;IIIIIIZI)V
  .registers 10
  .line 168
    invoke-static { p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->state(I)Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
    move-result-object p0
  .line 169
    iput-object p1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->codec:Ljava/lang/String;
  .line 170
    iput p2, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->txPt:I
  .line 171
    iput p3, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->rxPt:I
  .line 172
    iput p4, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->clock:I
  .line 173
    iput p5, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->bitrate:I
  .line 174
    iput p6, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->ptime:I
  .line 175
    iput p7, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->maxPtime:I
  .line 176
    iput-boolean p8, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->octetAligned:Z
  .line 177
    iput p9, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->modeSet:I
  .line 178
    const-string p1, "CODEC"
    invoke-static { p1, p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->log(Ljava/lang/String;Lcom/sec/internal/google/ApMediaNegotiationPoc$State;)V
  .line 179
    return-void
.end method

.method public static onCodecFull(ILjava/lang/String;IIIIIIZI)V
  .registers 10
  .line 131
    invoke-static/range { p0 .. p9 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->onCodec(ILjava/lang/String;IIIIIIZI)V
  .line 132
    return-void
.end method

.method public static onCreate(ILjava/lang/String;ILjava/lang/String;III)V
  .registers 10
  .line 140
    sget-object v0, Lcom/sec/internal/google/ApMediaNegotiationPoc;->CHANNELS:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    invoke-virtual { v0, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
  .line 141
    if-eqz v1, :L0
    const-string v2, "CREATE_REPLACE"
    invoke-static { v2, v1 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->log(Ljava/lang/String;Lcom/sec/internal/google/ApMediaNegotiationPoc$State;)V
  :L0
  .line 142
    new-instance v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
    invoke-direct { v1, p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;-><init>(I)V
  .line 143
    iput-object p1, v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->localIp:Ljava/lang/String;
  .line 144
    iput p2, v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->localRtp:I
  .line 145
    iput-object p3, v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->remoteIp:Ljava/lang/String;
  .line 146
    iput p4, v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->remoteRtp:I
  .line 147
    iput p5, v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->localRtcp:I
  .line 148
    iput p6, v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->remoteRtcp:I
  .line 149
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p0
    invoke-virtual { v0, p0, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
  .line 150
    const-string p0, "CREATE"
    invoke-static { p0, v1 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->log(Ljava/lang/String;Lcom/sec/internal/google/ApMediaNegotiationPoc$State;)V
  .line 151
    return-void
.end method

.method public static onCreateFull(IILjava/lang/String;ILjava/lang/String;IIILjava/lang/String;ZZ)V
  .registers 18
  .line 121
    move v0, p0
    move-object v1, p2
    move v2, p3
    move-object v3, p4
    move v4, p5
    move v5, p6
    move v6, p7
    invoke-static/range { v0 .. v6 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->onCreate(ILjava/lang/String;ILjava/lang/String;III)V
  .line 122
    return-void
.end method

.method public static onDelete(I)V
  .registers 3
  .line 197
    sget-object v0, Lcom/sec/internal/google/ApMediaNegotiationPoc;->CHANNELS:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    invoke-virtual { v0, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
  .line 198
    const/4 v1, 1
    if-nez v0, :L0
  .line 199
    new-instance v0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
    invoke-direct { v0, p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;-><init>(I)V
  .line 200
    iput-boolean v1, v0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->deleted:Z
  .line 201
    const-string p0, "DELETE_MISSING"
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->log(Ljava/lang/String;Lcom/sec/internal/google/ApMediaNegotiationPoc$State;)V
    goto :L1
  :L0
  .line 203
    iput-boolean v1, v0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->deleted:Z
  .line 204
    const-string p0, "DELETE"
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->log(Ljava/lang/String;Lcom/sec/internal/google/ApMediaNegotiationPoc$State;)V
  :L1
  .line 206
    return-void
.end method

.method public static onGlobal(Ljava/lang/String;II)V
  .registers 6
  .line 209
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "SAE_GLOBAL seq="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    sget-object v1, Lcom/sec/internal/google/ApMediaNegotiationPoc;->OPERATIONS:Ljava/util/concurrent/atomic/AtomicLong;
    invoke-virtual { v1 }, Ljava/util/concurrent/atomic/AtomicLong;->incrementAndGet()J
    move-result-wide v1
    invoke-virtual { v0, v1, v2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " op="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " phoneId="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " status="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " thread="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 211
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/Thread;->getName()Ljava/lang/String;
    move-result-object p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " active="
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget-object p1, Lcom/sec/internal/google/ApMediaNegotiationPoc;->CHANNELS:Ljava/util/concurrent/ConcurrentHashMap;
  .line 212
    invoke-virtual { p1 }, Ljava/util/concurrent/ConcurrentHashMap;->size()I
    move-result p1
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 209
    const-string p1, "AP_MEDIA_NEGOTIATION"
    invoke-static { p1, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 213
    return-void
.end method

.method public static onStart(II)V
  .registers 2
  .line 182
    invoke-static { p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->state(I)Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
    move-result-object p0
  .line 183
    iput p1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->direction:I
  .line 184
    const/4 p1, 1
    iput-boolean p1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->started:Z
  .line 185
    const/4 p1, 0
    iput-boolean p1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->stopped:Z
  .line 186
    const-string p1, "START"
    invoke-static { p1, p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->log(Ljava/lang/String;Lcom/sec/internal/google/ApMediaNegotiationPoc$State;)V
  .line 187
    return-void
.end method

.method public static onStartFull(IIZ)V
  .registers 3
  .line 135
    invoke-static { p0, p1 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->onStart(II)V
  .line 136
    return-void
.end method

.method public static onStop(I)V
  .registers 2
  .line 190
    invoke-static { p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->state(I)Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
    move-result-object p0
  .line 191
    const/4 v0, 0
    iput-boolean v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->started:Z
  .line 192
    const/4 v0, 1
    iput-boolean v0, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->stopped:Z
  .line 193
    const-string v0, "STOP"
    invoke-static { v0, p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->log(Ljava/lang/String;Lcom/sec/internal/google/ApMediaNegotiationPoc$State;)V
  .line 194
    return-void
.end method

.method public static onUpdate(IILjava/lang/String;ILjava/lang/String;III)V
  .registers 8
  .line 155
    invoke-static { p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->state(I)Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
    move-result-object p0
  .line 156
    iput p1, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->direction:I
  .line 157
    iput-object p2, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->localIp:Ljava/lang/String;
  .line 158
    iput p3, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->localRtp:I
  .line 159
    iput-object p4, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->remoteIp:Ljava/lang/String;
  .line 160
    iput p5, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->remoteRtp:I
  .line 161
    iput p6, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->localRtcp:I
  .line 162
    iput p7, p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;->remoteRtcp:I
  .line 163
    const-string p1, "UPDATE"
    invoke-static { p1, p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->log(Ljava/lang/String;Lcom/sec/internal/google/ApMediaNegotiationPoc$State;)V
  .line 164
    return-void
.end method

.method public static onUpdateFull(IILjava/lang/String;ILjava/lang/String;III)V
  .registers 8
  .line 126
    invoke-static/range { p0 .. p7 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->onUpdate(IILjava/lang/String;ILjava/lang/String;III)V
  .line 127
    return-void
.end method

.method private static state(I)Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
  .registers 3
  .line 101
    sget-object v0, Lcom/sec/internal/google/ApMediaNegotiationPoc;->CHANNELS:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    invoke-virtual { v0, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
  .line 102
    if-nez v1, :L1
  .line 103
    new-instance v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
    invoke-direct { v1, p0 }, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;-><init>(I)V
  .line 104
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p0
    invoke-virtual { v0, p0, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->putIfAbsent(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
    check-cast p0, Lcom/sec/internal/google/ApMediaNegotiationPoc$State;
  .line 105
    if-nez p0, :L0
    goto :L1
  :L0
    move-object v1, p0
  :L1
  .line 107
    return-object v1
.end method

.method public static uniqueReady()Ljava/lang/String;
  .registers 4
  .line 254
    const-wide/16 v0, 0
    invoke-static { v0, v1 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->awaitUniqueReady(J)Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;
    move-result-object v0
  .line 255
    if-nez v0, :L0
    const/4 v0, 0
    goto :L1
  :L0
  .line 257
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "generation="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget-wide v2, v0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->generation:J
    invoke-virtual { v1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " channel="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v2, v0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->channel:I
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " codec="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget-object v2, v0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->codec:Ljava/lang/String;
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " txPt="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v2, v0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->txPt:I
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " rxPt="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v0, v0, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->rxPt:I
    invoke-virtual { v1, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
  :L1
  .line 255
    return-object v0
.end method
