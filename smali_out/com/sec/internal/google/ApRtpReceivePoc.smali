.class public final Lcom/sec/internal/google/ApRtpReceivePoc;
.super Ljava/lang/Object;
.source "ApRtpReceivePoc.java"

.annotation system Ldalvik/annotation/MemberClasses;
  value = {
    Lcom/sec/internal/google/ApRtpReceivePoc$Probe;,
    Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;,
    Lcom/sec/internal/google/ApRtpReceivePoc$Frame;
  }
.end annotation

.field private final static GATE:Ljava/lang/String; = "persist.vendor.ims.ap_rtp_playback"

.field private final static GENERATION:Ljava/util/concurrent/atomic/AtomicLong;

.field private final static LIFECYCLE_LOCK:Ljava/lang/Object;

.field private final static PROBES:Ljava/util/concurrent/ConcurrentHashMap;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "Ljava/util/concurrent/ConcurrentHashMap<",
      "Ljava/lang/Integer;",
      "Lcom/sec/internal/google/ApRtpReceivePoc$Probe;",
      ">;"
    }
  .end annotation
.end field

.field private final static TAG:Ljava/lang/String; = "AP_RTP_PLAYBACK"

.method static constructor <clinit>()V
  .registers 1
  .line 35
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;
    invoke-direct { v0 }, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApRtpReceivePoc;->PROBES:Ljava/util/concurrent/ConcurrentHashMap;
  .line 36
    new-instance v0, Ljava/util/concurrent/atomic/AtomicLong;
    invoke-direct { v0 }, Ljava/util/concurrent/atomic/AtomicLong;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApRtpReceivePoc;->GENERATION:Ljava/util/concurrent/atomic/AtomicLong;
  .line 37
    new-instance v0, Ljava/lang/Object;
    invoke-direct { v0 }, Ljava/lang/Object;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApRtpReceivePoc;->LIFECYCLE_LOCK:Ljava/lang/Object;
    return-void
.end method

.method private constructor <init>()V
  .registers 1
  .line 38
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method static synthetic access$000(IZ)I
  .registers 2
  .line 32
    invoke-static { p0, p1 }, Lcom/sec/internal/google/ApRtpReceivePoc;->amrBits(IZ)I
    move-result p0
    return p0
.end method

.method static synthetic access$100()Ljava/util/concurrent/ConcurrentHashMap;
  .registers 1
  .line 32
    sget-object v0, Lcom/sec/internal/google/ApRtpReceivePoc;->PROBES:Ljava/util/concurrent/ConcurrentHashMap;
    return-object v0
.end method

.method private static amrBits(IZ)I
  .registers 4
  .line 41
    if-eqz p1, :L9
  .line 42
    packed-switch p0, :L20
  .line 52
    new-instance p1, Ljava/lang/IllegalArgumentException;
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "unsupported AMR-NB FT="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-direct { p1, p0 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw p1
  :L0
  .line 51
    const/16 p0, 39
    return p0
  :L1
  .line 50
    const/16 p0, 244
    return p0
  :L2
  .line 49
    const/16 p0, 204
    return p0
  :L3
  .line 48
    const/16 p0, 159
    return p0
  :L4
  .line 47
    const/16 p0, 148
    return p0
  :L5
  .line 46
    const/16 p0, 134
    return p0
  :L6
  .line 45
    const/16 p0, 118
    return p0
  :L7
  .line 44
    const/16 p0, 103
    return p0
  :L8
  .line 43
    const/16 p0, 95
    return p0
  :L9
  .line 55
    packed-switch p0, :L21
  .line 66
    new-instance p1, Ljava/lang/IllegalArgumentException;
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "unsupported FT="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-direct { p1, p0 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw p1
  :L10
  .line 65
    const/16 p0, 40
    return p0
  :L11
  .line 64
    const/16 p0, 477
    return p0
  :L12
  .line 63
    const/16 p0, 461
    return p0
  :L13
  .line 62
    const/16 p0, 397
    return p0
  :L14
  .line 61
    const/16 p0, 365
    return p0
  :L15
  .line 60
    const/16 p0, 317
    return p0
  :L16
  .line 59
    const/16 p0, 285
    return p0
  :L17
  .line 58
    const/16 p0, 253
    return p0
  :L18
  .line 57
    const/16 p0, 177
    return p0
  :L19
  .line 56
    const/16 p0, 132
    return p0
  :L20
  .packed-switch 0
    :L8
    :L7
    :L6
    :L5
    :L4
    :L3
    :L2
    :L1
    :L0
  .end packed-switch
  :L21
  .packed-switch 0
    :L19
    :L18
    :L17
    :L16
    :L15
    :L14
    :L13
    :L12
    :L11
    :L10
  .end packed-switch
.end method

.method public static onDtmfPulse(C)Z
  .registers 2
  .line 76
    const/4 v0, 1
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApRtpReceivePoc;->routeDtmf(CZ)Z
    move-result p0
    return p0
.end method

.method public static onDtmfStart(C)Z
  .registers 2
  .line 70
    const/4 v0, 0
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApRtpReceivePoc;->routeDtmf(CZ)Z
    move-result p0
    return p0
.end method

.method public static onDtmfStop()Z
  .registers 6
  .line 72
    sget-object v0, Lcom/sec/internal/google/ApRtpReceivePoc;->PROBES:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-virtual { v0 }, Ljava/util/concurrent/ConcurrentHashMap;->values()Ljava/util/Collection;
    move-result-object v0
    invoke-interface { v0 }, Ljava/util/Collection;->iterator()Ljava/util/Iterator;
    move-result-object v0
    const/4 v1, 0
  :L0
    invoke-interface { v0 }, Ljava/util/Iterator;->hasNext()Z
    move-result v2
    const/4 v3, 0
    const-string v4, "AP_RTP_PLAYBACK"
    if-eqz v2, :L2
    invoke-interface { v0 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;
    iget-boolean v5, v2, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpEndpointLocked:Z
    if-eqz v5, :L0
    iget-object v5, v2, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    if-eqz v5, :L0
    iget-object v5, v2, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-virtual { v5 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->isVoiceActive()Z
    move-result v5
    if-eqz v5, :L0
    if-eqz v1, :L1
    const-string v0, "DTMF_FALLBACK reason=multiple_probes"
    invoke-static { v4, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return v3
  :L1
    move-object v1, v2
    goto :L0
  :L2
  .line 73
    if-nez v1, :L3
    const-string v0, "DTMF_FALLBACK reason=no_active_uplink"
    invoke-static { v4, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return v3
  :L3
  .line 74
    iget-object v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-virtual { v0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->stopDtmf()Z
    move-result v0
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "AP_DTMF_TAKEOVER action=stop result="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v0 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v4, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return v0
.end method

.method public static onEarlyMediaStarted(I)V
  .catchall { :L0 .. :L4 } :L5
  .catchall { :L6 .. :L7 } :L5
  .registers 6
  .line 142
    const-string v0, "AP_RTP_PLAYBACK"
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "EARLY_MEDIA_START callId="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v0, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 143
    sget-object v0, Lcom/sec/internal/google/ApRtpReceivePoc;->LIFECYCLE_LOCK:Ljava/lang/Object;
    monitor-enter v0
  :L0
  .line 144
    sget-object v1, Lcom/sec/internal/google/ApRtpReceivePoc;->PROBES:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v2
    invoke-virtual { v1, v2 }, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;
  .line 145
    if-eqz v1, :L3
  .line 146
    const-wide/16 v2, 750
    invoke-static { v2, v3 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->awaitUniqueReady(J)Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;
    move-result-object v2
  .line 147
    if-eqz v2, :L1
  .line 148
    invoke-virtual { v1, v2 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->refreshNegotiation(Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;)V
  .line 149
    const/4 v3, 1
    iput-boolean v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->wireRelockArmed:Z
  .line 150
    const-string v1, "AP_RTP_PLAYBACK"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "EARLY_MEDIA_REFRESH callId="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v3, " generation="
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    iget-wide v3, v2, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->generation:J
    invoke-virtual { p0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v3, " codec="
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    iget-object v3, v2, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->codec:Ljava/lang/String;
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v3, " rxPt="
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    iget v3, v2, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->rxPt:I
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v3, " txPt="
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    iget v2, v2, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->txPt:I
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    goto :L2
  :L1
  .line 154
    invoke-virtual { v1 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->armWireRelock()V
  .line 155
    const-string v1, "AP_RTP_PLAYBACK"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "EARLY_MEDIA_REFRESH_PENDING callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v2, " EARLY_MEDIA_REFRESH_ARMED=true"
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L2
  .line 158
    monitor-exit v0
    return-void
  :L3
  .line 160
    monitor-exit v0
  :L4
  .line 161
    const/4 v0, 0
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApRtpReceivePoc;->onEstablished(ILandroid/net/Network;)V
  .line 162
    return-void
  :L5
  .line 160
    move-exception p0
  :L6
    monitor-exit v0
  :L7
    throw p0
.end method

.method public static onEnded(I)V
  .registers 2
  .line 164
    invoke-static { p0 }, Lcom/sec/internal/google/ApUplinkCapturePoc;->onEnded(I)V
    const-string v0, "ended"
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApRtpReceivePoc;->stop(ILjava/lang/String;)V
    return-void
.end method

.method public static onError(I)V
  .registers 2
  .line 165
    invoke-static { p0 }, Lcom/sec/internal/google/ApUplinkCapturePoc;->onError(I)V
    const-string v0, "error"
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApRtpReceivePoc;->stop(ILjava/lang/String;)V
    return-void
.end method

.method public static onEstablished(I)V
  .registers 2
  .line 84
    const/4 v0, 0
    invoke-static { p0, v0 }, Lcom/sec/internal/google/ApRtpReceivePoc;->onEstablished(ILandroid/net/Network;)V
    return-void
.end method

.method public static onEstablished(ILandroid/net/Network;)V
  .catchall { :L2 .. :L4 } :L24
  .catchall { :L19 .. :L22 } :L21
  .catchall { :L25 .. :L26 } :L24
  .registers 19
  .line 86
    move/from16 v0, p0
    invoke-static/range { p0 .. p0 }, Lcom/sec/internal/google/ApUplinkCapturePoc;->onEstablished(I)V
  .line 87
    const-string v1, "persist.vendor.ims.ap_rtp_playback"
    const-string v2, ""
    invoke-static { v1, v2 }, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
  .line 88
    const-string v2, "ap_rtp_playback"
    const/4 v3, 1
    invoke-static { v2, v3 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result v2
  .line 89
    const-string v4, "AP_RTP_PLAYBACK"
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "MEDIA_GATE callId="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v6, " playbackRaw="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
  .line 90
    invoke-virtual { v1 }, Ljava/lang/String;->length()I
    move-result v6
    if-nez v6, :L0
    const-string v1, "<unset>"
  :L0
    invoke-virtual { v5, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v5, " playbackEnabled="
    invoke-virtual { v1, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
  .line 89
    invoke-static { v4, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 92
    if-nez v2, :L1
    return-void
  :L1
  .line 93
    sget-object v11, Lcom/sec/internal/google/ApRtpReceivePoc;->LIFECYCLE_LOCK:Ljava/lang/Object;
    monitor-enter v11
  :L2
  .line 94
    sget-object v12, Lcom/sec/internal/google/ApRtpReceivePoc;->PROBES:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static/range { p0 .. p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    invoke-virtual { v12, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->containsKey(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :L3
  .line 95
    const-string v1, "AP_RTP_PLAYBACK"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "ESTABLISHED_DUPLICATE callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 96
    monitor-exit v11
    return-void
  :L3
  .line 98
    monitor-exit v11
  :L4
  .line 99
    const-wide/16 v1, 750
  .line 100
    invoke-static { v1, v2 }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->awaitUniqueReady(J)Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;
    move-result-object v1
  .line 101
    if-nez v1, :L5
    const/4 v7, -1
    goto :L6
  :L5
    iget v4, v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->rxPt:I
    move v7, v4
  :L6
  .line 102
    if-nez v1, :L7
    const/4 v8, -1
    goto :L8
  :L7
    iget v4, v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->txPt:I
    move v8, v4
  :L8
  .line 103
    if-nez v1, :L9
    const/4 v4, 0
    goto :L10
  :L9
    iget-object v4, v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->codec:Ljava/lang/String;
  :L10
    move-object v9, v4
  .line 104
    if-nez v1, :L11
    const-string v4, "wire-profile-pending"
    goto :L12
  :L11
    const-string v4, "negotiated-rx"
  :L12
  .line 105
    const-string v5, "ap_rtp_port"
    const/16 v6, 1234
    const v10, 65535
    invoke-static { v5, v6, v3, v10 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v5
  .line 106
    const-string v6, "ap_rtcp_port"
    const/16 v13, 1235
    invoke-static { v6, v13, v3, v10 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v6
  .line 107
    const-string v13, "ap_media_rotate_ports"
    const/4 v14, 0
    invoke-static { v13, v14 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result v13
  .line 108
    if-eqz v13, :L13
    add-int/lit8 v15, v0, -1
    invoke-static { v14, v15 }, Ljava/lang/Math;->max(II)I
    move-result v14
  :L13
  .line 109
    mul-int/lit8 v15, v14, 2
    add-int v10, v5, v15
  .line 110
    add-int/2addr v15, v6
  .line 111
    const-string v2, "AP_RTP_PLAYBACK"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    move-object/from16 v16, v12
    const-string v12, "PORT_SELECT callId="
    invoke-virtual { v3, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v12, " rotate="
    invoke-virtual { v3, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v13 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v12, " slot="
    invoke-virtual { v3, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v14 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v12, " base="
    invoke-virtual { v3, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v5, "/"
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v6 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v5, " selected="
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v10 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v5, "/"
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v15 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static { v2, v3 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 114
    const-string v2, "AP_RTP_PLAYBACK"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "MEDIA_SELECT callId="
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v5, " channel="
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
  .line 115
    if-nez v1, :L14
    const/4 v5, -1
    goto :L15
  :L14
    iget v5, v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->channel:I
  :L15
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v5, " generation="
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
  .line 116
    if-nez v1, :L16
    const-wide/16 v5, -1
    goto :L17
  :L16
    iget-wide v5, v1, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->generation:J
  :L17
    invoke-virtual { v3, v5, v6 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, " codec="
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, " rxPt="
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v7 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, " txPt="
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v8 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, " ptSource="
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
  .line 114
    invoke-static { v2, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 119
    const/4 v1, 1
    if-lt v10, v1, :L23
    const v2, 65535
    if-gt v10, v2, :L23
    if-lt v15, v1, :L23
    if-gt v15, v2, :L23
    if-eq v10, v15, :L23
    const/16 v1, 127
    if-gt v7, v1, :L23
    if-le v8, v1, :L18
    goto/16 :L23
  :L18
  .line 125
    monitor-enter v11
  :L19
  .line 126
    invoke-static/range { p0 .. p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    move-object/from16 v12, v16
    invoke-virtual { v12, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->containsKey(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :L20
  .line 127
    const-string v1, "AP_RTP_PLAYBACK"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "ESTABLISHED_DUPLICATE callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 128
    monitor-exit v11
    return-void
  :L20
  .line 130
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "new_call_"
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v1 }, Lcom/sec/internal/google/ApRtpReceivePoc;->stopAllLocked(Ljava/lang/String;)V
  .line 131
    sget-object v1, Lcom/sec/internal/google/ApRtpReceivePoc;->GENERATION:Ljava/util/concurrent/atomic/AtomicLong;
    invoke-virtual { v1 }, Ljava/util/concurrent/atomic/AtomicLong;->incrementAndGet()J
    move-result-wide v13
  .line 132
    new-instance v6, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;
    move-object v1, v6
    move/from16 v2, p0
    move-wide v3, v13
    move v5, v10
    move-object v10, v6
    move v6, v15
    move-object v15, v10
    move-object/from16 v10, p1
    invoke-direct/range { v1 .. v10 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;-><init>(IJIIIILjava/lang/String;Landroid/net/Network;)V
  .line 134
    invoke-static/range { p0 .. p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    invoke-virtual { v12, v1, v15 }, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
  .line 135
    const-string v1, "AP_RTP_PLAYBACK"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "PROBE_CREATE callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " generation="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v13, v14 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " mapSize="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 136
    invoke-virtual { v12 }, Ljava/util/concurrent/ConcurrentHashMap;->size()I
    move-result v2
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
  .line 135
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 137
    invoke-virtual { v15 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->start()V
  .line 138
    monitor-exit v11
  .line 139
    return-void
  :L21
  .line 138
    move-exception v0
    monitor-exit v11
  :L22
    throw v0
  :L23
  .line 121
    const-string v1, "AP_RTP_PLAYBACK"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "START_REJECT callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " rtp="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v10 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " rtcp="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v15 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " rxPt="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v7 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " txPt="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v8 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 123
    return-void
  :L24
  .line 98
    move-exception v0
  :L25
    monitor-exit v11
  :L26
    throw v0
.end method

.method public static onTerminated(ILjava/lang/String;)V
  .registers 2
  .line 166
    invoke-static { p0, p1 }, Lcom/sec/internal/google/ApRtpReceivePoc;->stop(ILjava/lang/String;)V
    return-void
.end method

.method private static routeDtmf(CZ)Z
  .registers 8
  .line 78
    const-string v0, "ap_dtmf_rtp"
    const/4 v1, 1
    invoke-static { v0, v1 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result v0
    const/4 v1, 0
    if-nez v0, :L0
    return v1
  :L0
  .line 79
    const/16 v0, 48
    if-lt p0, v0, :L1
    const/16 v0, 57
    if-gt p0, v0, :L1
    add-int/lit8 v0, p0, -48
    goto :L4
  :L1
    const/16 v0, 42
    if-ne p0, v0, :L2
    const/16 v0, 10
    goto :L4
  :L2
    const/16 v0, 35
    if-ne p0, v0, :L3
    const/16 v0, 11
    goto :L4
  :L3
    const/4 v0, -1
  :L4
    const-string v2, "AP_RTP_PLAYBACK"
    if-gez v0, :L5
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "DTMF_FALLBACK reason=invalid_char char="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v2, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return v1
  :L5
  .line 80
    const/4 p0, 0
    sget-object v3, Lcom/sec/internal/google/ApRtpReceivePoc;->PROBES:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-virtual { v3 }, Ljava/util/concurrent/ConcurrentHashMap;->values()Ljava/util/Collection;
    move-result-object v3
    invoke-interface { v3 }, Ljava/util/Collection;->iterator()Ljava/util/Iterator;
    move-result-object v3
  :L6
    invoke-interface { v3 }, Ljava/util/Iterator;->hasNext()Z
    move-result v4
    if-eqz v4, :L8
    invoke-interface { v3 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;
    iget-object v5, v4, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v5 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v5
    if-eqz v5, :L6
    iget-boolean v5, v4, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaResolved:Z
    if-eqz v5, :L6
    iget-boolean v5, v4, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpEndpointLocked:Z
    if-eqz v5, :L6
    iget-object v5, v4, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    if-eqz v5, :L6
    iget-object v5, v4, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-virtual { v5 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->isVoiceActive()Z
    move-result v5
    if-eqz v5, :L6
    if-eqz p0, :L7
    const-string p0, "DTMF_FALLBACK reason=multiple_probes"
    invoke-static { v2, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return v1
  :L7
    move-object p0, v4
    goto :L6
  :L8
  .line 81
    if-nez p0, :L9
    const-string p0, "DTMF_FALLBACK reason=no_active_uplink"
    invoke-static { v2, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return v1
  :L9
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    if-eqz p1, :L10
    invoke-virtual { v1, v0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->pulseDtmf(I)Z
    move-result v1
    goto :L11
  :L10
    invoke-virtual { v1, v0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->startDtmf(I)Z
    move-result v1
  :L11
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "AP_DTMF_TAKEOVER action="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    if-eqz p1, :L12
    const-string p1, "pulse"
    goto :L13
  :L12
    const-string p1, "start"
  :L13
    invoke-virtual { v3, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " event="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " result="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " voicePt="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplinkPt:I
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " codec="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-object p0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecProfile:Ljava/lang/String;
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v2, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return v1
.end method

.method private static stop(ILjava/lang/String;)V
  .catchall { :L0 .. :L3 } :L2
  .registers 4
  .line 175
    sget-object v0, Lcom/sec/internal/google/ApRtpReceivePoc;->LIFECYCLE_LOCK:Ljava/lang/Object;
    monitor-enter v0
  :L0
    sget-object v1, Lcom/sec/internal/google/ApRtpReceivePoc;->PROBES:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object p0
    invoke-virtual { v1, p0 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
    check-cast p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;
    if-eqz p0, :L1
    invoke-virtual { p0, p1 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->stop(Ljava/lang/String;)V
  :L1
    monitor-exit v0
  .line 176
    return-void
  :L2
  .line 175
    move-exception p0
    monitor-exit v0
  :L3
    throw p0
.end method

.method public static stopAll(Ljava/lang/String;)V
  .catchall { :L0 .. :L2 } :L1
  .registers 2
  .line 167
    sget-object v0, Lcom/sec/internal/google/ApRtpReceivePoc;->LIFECYCLE_LOCK:Ljava/lang/Object;
    monitor-enter v0
  :L0
    invoke-static { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc;->stopAllLocked(Ljava/lang/String;)V
    monitor-exit v0
    return-void
  :L1
    move-exception p0
    monitor-exit v0
  :L2
    throw p0
.end method

.method private static stopAllLocked(Ljava/lang/String;)V
  .registers 10
  .line 169
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    sget-object v2, Lcom/sec/internal/google/ApRtpReceivePoc;->PROBES:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-virtual { v2 }, Ljava/util/concurrent/ConcurrentHashMap;->size()I
    move-result v3
  .line 170
    invoke-virtual { v2 }, Ljava/util/concurrent/ConcurrentHashMap;->values()Ljava/util/Collection;
    move-result-object v2
    const/4 v4, 0
    new-array v5, v4, [Lcom/sec/internal/google/ApRtpReceivePoc$Probe;
    invoke-interface { v2, v5 }, Ljava/util/Collection;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v2
    check-cast v2, [Lcom/sec/internal/google/ApRtpReceivePoc$Probe;
  .line 171
    array-length v5, v2
  :L0
    if-ge v4, v5, :L1
    aget-object v6, v2, v4
    sget-object v7, Lcom/sec/internal/google/ApRtpReceivePoc;->PROBES:Ljava/util/concurrent/ConcurrentHashMap;
    iget v8, v6, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-static { v8 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v8
    invoke-virtual { v7, v8, v6 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;Ljava/lang/Object;)Z
    invoke-virtual { v6, p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->stop(Ljava/lang/String;)V
    add-int/lit8 v4, v4, 1
    goto :L0
  :L1
  .line 172
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "STOP_ALL reason="
    invoke-virtual { v2, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v2, " before="
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v2, " after="
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    sget-object v2, Lcom/sec/internal/google/ApRtpReceivePoc;->PROBES:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-virtual { v2 }, Ljava/util/concurrent/ConcurrentHashMap;->size()I
    move-result v2
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v2, " elapsedMs="
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v2
    sub-long/2addr v2, v0
    invoke-virtual { p0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string v0, "AP_RTP_PLAYBACK"
    invoke-static { v0, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 173
    return-void
.end method
