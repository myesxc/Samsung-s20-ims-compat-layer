.class final Lcom/sec/internal/google/ApRtpReceivePoc$Probe;
.super Ljava/lang/Object;
.source "ApRtpReceivePoc.java"

.annotation system Ldalvik/annotation/EnclosingClass;
  value = Lcom/sec/internal/google/ApRtpReceivePoc;
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 26
  name = "Probe"
.end annotation

.field volatile amrNb:Z

.field badRtp:J

.field baseExtSeq:J

.field final callId:I

.field volatile capture:Ljava/io/BufferedOutputStream;

.field final captureMax:I

.field capturedBytes:J

.field final cleanupComplete:Ljava/util/concurrent/atomic/AtomicBoolean;

.field final cleanupStarted:Ljava/util/concurrent/atomic/AtomicBoolean;

.field final cname:Ljava/lang/String;

.field volatile codec:Landroid/media/MediaCodec;

.field volatile codecMime:Ljava/lang/String;

.field volatile codecProfile:Ljava/lang/String;

.field final completionLock:Ljava/lang/Object;

.field final decodeEnabled:Z

.field volatile decodeThread:Ljava/lang/Thread;

.field decodedBytes:J

.field final downlinkCmr:[J

.field final downlinkFt:[J

.field downlinkMarkers:J

.field downlinkPayloadBytes:J

.field downlinkQ0:J

.field downlinkQ1:J

.field downlinkTimestampStep:J

.field dropped:J

.field endpointChanges:J

.field expectedPrior:J

.field volatile expectedPt:I

.field expectedSeq:I

.field firstRtcpElapsedMs:J

.field volatile firstRtcpSource:Ljava/lang/String;

.field firstRtpElapsedMs:J

.field volatile firstRtpSource:Ljava/lang/String;

.field frames:J

.field final generation:J

.field final jitterMax:I

.field jitterQ4:J

.field lastRrMs:J

.field lastSrArrivalMs:J

.field lastSrMiddle32:J

.field volatile mainThread:Ljava/lang/Thread;

.field malformed:J

.field maxExtSeq:J

.field volatile mediaMilestoneThread:Ljava/lang/Thread;

.field volatile mediaResolved:Z

.field final mode:Ljava/lang/String;

.field final network:Landroid/net/Network;

.field volatile networkBound:Z

.field playedBytes:J

.field previousRtpTimestamp:J

.field previousTransit:J

.field volatile profileCandidateAddress:Ljava/net/InetAddress;

.field volatile profileCandidateCount:I

.field volatile profileCandidateNb:Z

.field volatile profileCandidatePort:I

.field volatile profileCandidatePt:I

.field volatile profileCandidateSeq:I

.field volatile profileCandidateSsrc:J

.field volatile profileCandidateTimestamp:J

.field final queue:Ljava/util/TreeMap;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "Ljava/util/TreeMap<",
      "Ljava/lang/Integer;",
      "Ljava/util/ArrayList<",
      "Lcom/sec/internal/google/ApRtpReceivePoc$Frame;",
      ">;>;"
    }
  .end annotation
.end field

.field final queueLock:Ljava/lang/Object;

.field final randomReceiverSsrc:J

.field received:J

.field receivedPrior:J

.field volatile remoteRtcpAddress:Ljava/net/InetAddress;

.field volatile remoteRtcpPort:I

.field volatile remoteRtpAddress:Ljava/net/InetAddress;

.field volatile remoteRtpPort:I

.field remoteSsrc:J

.field reordered:J

.field final rrEnabled:Z

.field rrErrors:J

.field final rrIntervalSec:I

.field rrSent:J

.field rtcpBytes:J

.field rtcpPackets:J

.field final rtcpPort:I

.field volatile rtcpSocket:Ljava/net/DatagramSocket;

.field volatile rtcpSocketAddress:Ljava/lang/String;

.field volatile rtcpThread:Ljava/lang/Thread;

.field rtpBytes:J

.field volatile rtpCandidateAddress:Ljava/net/InetAddress;

.field rtpCandidateCount:I

.field volatile rtpCandidatePort:I

.field rtpCandidateSsrc:J

.field volatile rtpEndpointLocked:Z

.field rtpPackets:J

.field final rtpPort:I

.field volatile rtpSocket:Ljava/net/DatagramSocket;

.field volatile rtpSocketAddress:Ljava/lang/String;

.field final running:Ljava/util/concurrent/atomic/AtomicBoolean;

.field volatile sampleRate:I

.field startElapsedMs:J

.field final summarized:Ljava/util/concurrent/atomic/AtomicBoolean;

.field volatile timestampStep:I

.field volatile track:Landroid/media/AudioTrack;

.field final trackEnabled:Z

.field transitValid:Z

.field volatile txPtSource:Ljava/lang/String;

.field volatile uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;

.field volatile uplinkPt:I

.field volatile wireRelockArmed:Z

.field wrongPt:J

.method constructor <init>(IJIIIILjava/lang/String;Landroid/net/Network;)V
  .registers 21
  .line 238
    move-object v0, p0
    move/from16 v1, p6
    move-object/from16 v2, p8
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
  .line 205
    const-string v3, "ap_rtcp_rr"
    const/4 v4, 1
    invoke-static { v3, v4 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result v3
    iput-boolean v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrEnabled:Z
  .line 206
    const-string v3, "ap_rtcp_rr_interval"
    const/4 v5, 5
    const/4 v6, 3
    const/16 v7, 10
    invoke-static { v3, v5, v6, v7 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v3
    iput v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrIntervalSec:I
  .line 207
    new-instance v3, Ljava/security/SecureRandom;
    invoke-direct { v3 }, Ljava/security/SecureRandom;-><init>()V
    invoke-virtual { v3 }, Ljava/security/SecureRandom;->nextInt()I
    move-result v3
    int-to-long v7, v3
    const-wide v9, 4294967295L
    and-long/2addr v7, v9
    iput-wide v7, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->randomReceiverSsrc:J
  .line 208
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    new-instance v5, Ljava/security/SecureRandom;
    invoke-direct { v5 }, Ljava/security/SecureRandom;-><init>()V
    invoke-virtual { v5 }, Ljava/security/SecureRandom;->nextLong()J
    move-result-wide v7
    invoke-static { v7, v8 }, Ljava/lang/Long;->toHexString(J)Ljava/lang/String;
    move-result-object v5
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v5, "@android"
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->cname:Ljava/lang/String;
  .line 209
    const-string v3, "persist.vendor.ims.ap_rtp_mode"
    const-string v5, "play"
    invoke-static { v3, v5 }, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mode:Ljava/lang/String;
  .line 210
    const-string v7, "capture"
    invoke-virtual { v7, v3 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v7
    xor-int/2addr v7, v4
    iput-boolean v7, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->decodeEnabled:Z
  .line 211
    invoke-virtual { v5, v3 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    iput-boolean v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->trackEnabled:Z
  .line 212
    const v3, 1048575
    const-string v5, "persist.vendor.ims.ap_rtp_capture_bytes"
    invoke-static { v5, v3 }, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I
    move-result v3
    const v5, 8388607
    const/4 v7, 0
    invoke-static { v3, v7, v5 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->clamp(III)I
    move-result v3
    iput v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->captureMax:I
  .line 213
    const/16 v3, 12
    const-string v5, "persist.vendor.ims.ap_rtp_jitter"
    invoke-static { v5, v3 }, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I
    move-result v3
    const/16 v5, 50
    invoke-static { v3, v6, v5 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->clamp(III)I
    move-result v3
    iput v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->jitterMax:I
  .line 214
    new-instance v3, Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-direct { v3, v4 }, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    new-instance v3, Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-direct { v3, v7 }, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->cleanupStarted:Ljava/util/concurrent/atomic/AtomicBoolean;
    new-instance v3, Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-direct { v3, v7 }, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->cleanupComplete:Ljava/util/concurrent/atomic/AtomicBoolean;
  .line 215
    new-instance v3, Ljava/lang/Object;
    invoke-direct { v3 }, Ljava/lang/Object;-><init>()V
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->completionLock:Ljava/lang/Object;
  .line 216
    new-instance v3, Ljava/lang/Object;
    invoke-direct { v3 }, Ljava/lang/Object;-><init>()V
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    new-instance v3, Ljava/util/TreeMap;
    invoke-direct { v3 }, Ljava/util/TreeMap;-><init>()V
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
  .line 220
    const-wide/16 v5, -1
    iput-wide v5, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtpElapsedMs:J
    iput-wide v5, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtcpElapsedMs:J
  .line 221
    const-string v3, "unbound"
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocketAddress:Ljava/lang/String;
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocketAddress:Ljava/lang/String;
  .line 222
    const-string v3, "none"
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtpSource:Ljava/lang/String;
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtcpSource:Ljava/lang/String;
  .line 226
    iput-wide v5, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteSsrc:J
    iput-wide v5, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->baseExtSeq:J
    iput-wide v5, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->maxExtSeq:J
  .line 227
    const/16 v3, 16
    new-array v8, v3, [J
    iput-object v8, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkFt:[J
    new-array v3, v3, [J
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkCmr:[J
    iput-wide v5, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkTimestampStep:J
    iput-wide v5, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->previousRtpTimestamp:J
  .line 230
    iput-wide v5, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidateSsrc:J
  .line 232
    const/4 v3, -1
    iput v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePort:I
    iput v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePt:I
  .line 233
    iput-wide v5, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSsrc:J
    iput-wide v5, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateTimestamp:J
  .line 234
    iput v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSeq:I
  .line 236
    iput v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedSeq:I
  .line 518
    new-instance v3, Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-direct { v3, v7 }, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V
    iput-object v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->summarized:Ljava/util/concurrent/atomic/AtomicBoolean;
  .line 239
    move v3, p1
    iput v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
  .line 240
    move-wide v5, p2
    iput-wide v5, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->generation:J
  .line 241
    move v3, p4
    iput v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpPort:I
  .line 242
    move/from16 v3, p5
    iput v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpPort:I
  .line 243
    iput v1, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
  .line 244
    move/from16 v3, p7
    iput v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplinkPt:I
  .line 245
    if-eqz v2, :L0
    move v3, v4
    goto :L1
  :L0
    move v3, v7
  :L1
    iput-boolean v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaResolved:Z
  .line 246
    iget-boolean v3, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaResolved:Z
    if-eqz v3, :L5
  .line 247
    const-string v3, "AMR"
    invoke-virtual { v3, v2 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v3
    if-nez v3, :L3
  .line 248
    const-string v3, "AMR-NB"
    invoke-virtual { v3, v2 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :L2
    goto :L3
  :L2
    move v4, v7
    goto :L4
  :L3
    nop
  :L4
  .line 247
    invoke-virtual { p0, v4, v1, v7 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->commitProfile(ZIZ)V
  .line 249
    const-string v1, "negotiated"
    iput-object v1, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->txPtSource:Ljava/lang/String;
    goto :L6
  :L5
  .line 251
    const-string v1, "unresolved"
    iput-object v1, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecProfile:Ljava/lang/String;
  .line 252
    iput-object v1, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecMime:Ljava/lang/String;
  .line 253
    iput v7, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->sampleRate:I
  .line 254
    iput v7, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->timestampStep:I
  .line 255
    const-string v1, "pending"
    iput-object v1, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->txPtSource:Ljava/lang/String;
  :L6
  .line 257
    move-object/from16 v1, p9
    iput-object v1, v0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->network:Landroid/net/Network;
  .line 258
    return-void
.end method

.method static alive(Ljava/lang/Thread;)Z
  .registers 2
  .line 513
    if-eqz p0, :L0
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v0
    if-eq p0, v0, :L0
    invoke-virtual { p0 }, Ljava/lang/Thread;->isAlive()Z
    move-result p0
    if-eqz p0, :L0
    const/4 p0, 1
    goto :L1
  :L0
    const/4 p0, 0
  :L1
    return p0
.end method

.method static clamp(III)I
  .registers 3
  .line 307
    invoke-static { p2, p0 }, Ljava/lang/Math;->min(II)I
    move-result p0
    invoke-static { p1, p0 }, Ljava/lang/Math;->max(II)I
    move-result p0
    return p0
.end method

.method static distribution([J)Ljava/lang/String;
  .registers 7
  .line 484
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const/4 v1, 0
  :L0
    array-length v2, p0
    if-ge v1, v2, :L3
    aget-wide v2, p0, v1
    const-wide/16 v4, 0
    cmp-long v2, v2, v4
    if-eqz v2, :L2
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->length()I
    move-result v2
    if-eqz v2, :L1
    const/16 v2, 44
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;
  :L1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const/16 v3, 58
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;
    move-result-object v2
    aget-wide v3, p0, v1
    invoke-virtual { v2, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
  :L2
    add-int/lit8 v1, v1, 1
    goto :L0
  :L3
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->length()I
    move-result p0
    if-nez p0, :L4
    const-string p0, "none"
    goto :L5
  :L4
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  :L5
    return-object p0
.end method

.method private declared-synchronized observeWireRelock(IIJJLjava/net/DatagramPacket;[BII)Z
  .catchall { :L0 .. :L2 } :L26
  .catchall { :L5 .. :L10 } :L26
  .catchall { :L11 .. :L20 } :L26
  .catchall { :L20 .. :L21 } :L23
  .catchall { :L21 .. :L22 } :L26
  .catchall { :L24 .. :L25 } :L23
  .catchall { :L25 .. :L26 } :L26
  .registers 28
    move-object/from16 v1, p0
    move/from16 v0, p1
    move/from16 v2, p2
    move-wide/from16 v3, p3
    move-wide/from16 v5, p5
    move-object/from16 v7, p8
    move/from16 v8, p9
    move/from16 v9, p10
    monitor-enter p0
  .line 414
    const/4 v10, 0
    if-ltz v0, :L27
    const/16 v11, 127
    if-gt v0, v11, :L27
  :L0
    invoke-virtual/range { p7 .. p7 }, Ljava/net/DatagramPacket;->getAddress()Ljava/net/InetAddress;
    move-result-object v11
    if-nez v11, :L1
    goto/16 :L27
  :L1
  .line 415
    const/4 v11, 1
    invoke-virtual { v1, v7, v8, v9, v11 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->validAmrAcquisitionPayload([BIIZ)Z
    move-result v12
  .line 416
    invoke-virtual { v1, v7, v8, v9, v10 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->validAmrAcquisitionPayload([BIIZ)Z
    move-result v7
  .line 417
    if-ne v12, v7, :L3
  .line 418
    iput v10, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
  :L2
  .line 419
    monitor-exit p0
    return v10
  :L3
  .line 421
    nop
  .line 422
    if-eqz v12, :L4
    const/16 v9, 160
    goto :L5
  :L4
    const/16 v9, 320
  :L5
  .line 423
    iget v13, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePt:I
    if-ne v0, v13, :L6
    iget-boolean v13, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateNb:Z
    if-ne v12, v13, :L6
    iget-wide v13, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSsrc:J
    cmp-long v13, v5, v13
    if-nez v13, :L6
  .line 425
    invoke-virtual/range { p7 .. p7 }, Ljava/net/DatagramPacket;->getPort()I
    move-result v13
    iget v14, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePort:I
    if-ne v13, v14, :L6
  .line 426
    invoke-virtual/range { p7 .. p7 }, Ljava/net/DatagramPacket;->getAddress()Ljava/net/InetAddress;
    move-result-object v13
    iget-object v14, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateAddress:Ljava/net/InetAddress;
    invoke-virtual { v13, v14 }, Ljava/net/InetAddress;->equals(Ljava/lang/Object;)Z
    move-result v13
    if-eqz v13, :L6
    iget v13, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSeq:I
    if-ltz v13, :L6
    iget v13, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSeq:I
    add-int/2addr v13, v11
    const v14, 65535
    and-int/2addr v13, v14
    if-ne v2, v13, :L6
    iget-wide v13, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateTimestamp:J
    const-wide/16 v15, 0
    cmp-long v13, v13, v15
    if-ltz v13, :L6
    iget-wide v13, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateTimestamp:J
    sub-long v13, v3, v13
    const-wide v15, 4294967295L
    and-long/2addr v13, v15
    int-to-long v7, v9
    cmp-long v7, v13, v7
    if-nez v7, :L6
    move v7, v11
    goto :L7
  :L6
    move v7, v10
  :L7
  .line 430
    if-eqz v7, :L8
    iget v5, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
    add-int/2addr v5, v11
    iput v5, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
    goto :L9
  :L8
  .line 432
    iput v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePt:I
  .line 433
    iput-boolean v12, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateNb:Z
  .line 434
    invoke-virtual/range { p7 .. p7 }, Ljava/net/DatagramPacket;->getAddress()Ljava/net/InetAddress;
    move-result-object v7
    iput-object v7, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateAddress:Ljava/net/InetAddress;
  .line 435
    invoke-virtual/range { p7 .. p7 }, Ljava/net/DatagramPacket;->getPort()I
    move-result v7
    iput v7, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePort:I
  .line 436
    iput-wide v5, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSsrc:J
  .line 437
    iput v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
  :L9
  .line 439
    iput v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSeq:I
  .line 440
    iput-wide v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateTimestamp:J
  .line 441
    iget v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
  :L10
    const/16 v3, 10
    if-ge v2, v3, :L11
    monitor-exit p0
    return v10
  :L11
  .line 442
    iget v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
  .line 443
    iput-boolean v12, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->amrNb:Z
  .line 444
    if-eqz v12, :L12
    const-string v3, "amr-nb"
    goto :L13
  :L12
    const-string v3, "amr-wb"
  :L13
    iput-object v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecProfile:Ljava/lang/String;
  .line 445
    if-eqz v12, :L14
    const/16 v3, 8000
    goto :L15
  :L14
    const/16 v3, 16000
  :L15
    iput v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->sampleRate:I
  .line 446
    if-eqz v12, :L16
    const/16 v7, 160
    goto :L17
  :L16
    const/16 v7, 320
  :L17
    iput v7, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->timestampStep:I
  .line 447
    if-eqz v12, :L18
    const-string v3, "audio/3gpp"
    goto :L19
  :L18
    const-string v3, "audio/amr-wb"
  :L19
    iput-object v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecMime:Ljava/lang/String;
  .line 448
    iput v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
  .line 449
    iput v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplinkPt:I
  .line 450
    const-string v0, "wire-relock-symmetric-assumption"
    iput-object v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->txPtSource:Ljava/lang/String;
  .line 451
    iput-boolean v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaResolved:Z
  .line 452
    iget-object v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    monitor-enter v3
  :L20
    iget-object v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    invoke-virtual { v0 }, Ljava/lang/Object;->notifyAll()V
    monitor-exit v3
  :L21
  .line 453
    iput-boolean v10, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->wireRelockArmed:Z
  .line 454
    const-string v0, "AP_RTP_PLAYBACK"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "WIRE_PROFILE_RELOCK callId="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget v4, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " oldPt="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " newPt="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " codec="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget-object v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecProfile:Ljava/lang/String;
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " packets=10 validation=rfc4867-seq-ts-ssrc-source"
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v0, v2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L22
  .line 457
    monitor-exit p0
    return v11
  :L23
  .line 452
    move-exception v0
  :L24
    monitor-exit v3
  :L25
    throw v0
  :L26
  .line 413
    move-exception v0
    monitor-exit p0
    throw v0
  :L27
  .line 414
    monitor-exit p0
    return v10
.end method

.method static put16([BIJ)V
  .registers 6
  .line 338
    const/16 v0, 8
    ushr-long v0, p2, v0
    long-to-int v0, v0
    int-to-byte v0, v0
    aput-byte v0, p0, p1
    add-int/lit8 p1, p1, 1
    long-to-int p2, p2
    int-to-byte p2, p2
    aput-byte p2, p0, p1
    return-void
.end method

.method static put32([BIJ)V
  .registers 7
  .line 339
    const/16 v0, 24
    ushr-long v0, p2, v0
    long-to-int v0, v0
    int-to-byte v0, v0
    aput-byte v0, p0, p1
    add-int/lit8 v0, p1, 1
    const/16 v1, 16
    ushr-long v1, p2, v1
    long-to-int v1, v1
    int-to-byte v1, v1
    aput-byte v1, p0, v0
    add-int/lit8 v0, p1, 2
    const/16 v1, 8
    ushr-long v1, p2, v1
    long-to-int v1, v1
    int-to-byte v1, v1
    aput-byte v1, p0, v0
    add-int/lit8 p1, p1, 3
    long-to-int p2, p2
    int-to-byte p2, p2
    aput-byte p2, p0, p1
    return-void
.end method

.method static u32([BI)J
  .registers 7
  .line 337
    aget-byte v0, p0, p1
    and-int/lit16 v0, v0, 255
    int-to-long v0, v0
    const/16 v2, 24
    shl-long/2addr v0, v2
    add-int/lit8 v2, p1, 1
    aget-byte v2, p0, v2
    and-int/lit16 v2, v2, 255
    int-to-long v2, v2
    const/16 v4, 16
    shl-long/2addr v2, v4
    or-long/2addr v0, v2
    add-int/lit8 v2, p1, 2
    aget-byte v2, p0, v2
    and-int/lit16 v2, v2, 255
    int-to-long v2, v2
    const/16 v4, 8
    shl-long/2addr v2, v4
    or-long/2addr v0, v2
    add-int/lit8 p1, p1, 3
    aget-byte p0, p0, p1
    and-int/lit16 p0, p0, 255
    int-to-long p0, p0
    or-long/2addr p0, v0
    return-wide p0
.end method

.method declared-synchronized armWireRelock()V
  .catchall { :L0 .. :L1 } :L2
  .registers 4
    monitor-enter p0
  .line 260
    const/4 v0, 1
  :L0
    iput-boolean v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->wireRelockArmed:Z
  .line 261
    const/4 v0, 0
    iput v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
  .line 262
    const/4 v0, -1
    iput v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePt:I
  .line 263
    iput v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSeq:I
  .line 264
    const-wide/16 v1, -1
    iput-wide v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateTimestamp:J
  .line 265
    iput-wide v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSsrc:J
  .line 266
    const/4 v1, 0
    iput-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateAddress:Ljava/net/InetAddress;
  .line 267
    iput v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePort:I
  .line 268
    const-string v0, "AP_RTP_PLAYBACK"
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "EARLY_MEDIA_REFRESH_ARMED callId="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " oldPt="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " codec="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget-object v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecProfile:Ljava/lang/String;
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v0, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L1
  .line 270
    monitor-exit p0
    return-void
  :L2
  .line 259
    move-exception v0
    monitor-exit p0
    throw v0
.end method

.method awaitCleanup(J)V
  .catchall { :L0 .. :L1 } :L7
  .catch Ljava/lang/InterruptedException; { :L2 .. :L3 } :L4
  .catchall { :L2 .. :L3 } :L7
  .catchall { :L5 .. :L8 } :L7
  .registers 9
  .line 512
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    add-long/2addr v0, p1
    iget-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->completionLock:Ljava/lang/Object;
    monitor-enter p1
  :L0
    iget-object p2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->cleanupComplete:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { p2 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result p2
    if-nez p2, :L6
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v2
  :L1
    sub-long v2, v0, v2
    const-wide/16 v4, 0
    cmp-long p2, v2, v4
    if-gtz p2, :L2
    goto :L6
  :L2
    iget-object p2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->completionLock:Ljava/lang/Object;
    invoke-virtual { p2, v2, v3 }, Ljava/lang/Object;->wait(J)V
  :L3
    goto :L0
  :L4
    move-exception p2
  :L5
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/Thread;->interrupt()V
  :L6
    monitor-exit p1
    return-void
  :L7
    move-exception p2
    monitor-exit p1
  :L8
    throw p2
.end method

.method bind(I)Ljava/net/DatagramSocket;
  .annotation system Ldalvik/annotation/Throws;
    value = {
      Ljava/lang/Exception;
    }
  .end annotation
  .registers 4
  .line 309
    new-instance v0, Ljava/net/DatagramSocket;
    const/4 v1, 0
    invoke-direct { v0, v1 }, Ljava/net/DatagramSocket;-><init>(Ljava/net/SocketAddress;)V
    const/4 v1, 0
    invoke-virtual { v0, v1 }, Ljava/net/DatagramSocket;->setReuseAddress(Z)V
    new-instance v1, Ljava/net/InetSocketAddress;
    invoke-direct { v1, p1 }, Ljava/net/InetSocketAddress;-><init>(I)V
    invoke-virtual { v0, v1 }, Ljava/net/DatagramSocket;->bind(Ljava/net/SocketAddress;)V
    const/16 p1, 500
    invoke-virtual { v0, p1 }, Ljava/net/DatagramSocket;->setSoTimeout(I)V
    return-object v0
.end method

.method bindNetwork(Ljava/net/DatagramSocket;Ljava/net/DatagramSocket;)V
  .catchall { :L0 .. :L1 } :L2
  .registers 6
  .line 310
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->network:Landroid/net/Network;
    const-string v1, " rr disabled"
    const-string v2, "AP_RTP_PLAYBACK"
    if-nez v0, :L0
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p2, "NETWORK_UNAVAILABLE callId="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget p2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { v2, p1 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    return-void
  :L0
    invoke-virtual { v0, p1 }, Landroid/net/Network;->bindSocket(Ljava/net/DatagramSocket;)V
    iget-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->network:Landroid/net/Network;
    invoke-virtual { p1, p2 }, Landroid/net/Network;->bindSocket(Ljava/net/DatagramSocket;)V
    const/4 p1, 1
    iput-boolean p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->networkBound:Z
  :L1
    goto :L3
  :L2
    move-exception p1
    const/4 p2, 0
    iput-boolean p2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->networkBound:Z
    new-instance p2, Ljava/lang/StringBuilder;
    invoke-direct { p2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "NETWORK_BIND_FAIL callId="
    invoke-virtual { p2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    iget v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { p2, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    invoke-static { v2, p2, p1 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L3
    return-void
.end method

.method declared-synchronized buildReceiverReportCompound(J)[B
  .catchall { :L0 .. :L9 } :L10
  .registers 23
    move-object/from16 v1, p0
    move-wide/from16 v2, p1
    monitor-enter p0
  :L0
  .line 344
    iget-object v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->cname:Ljava/lang/String;
    sget-object v4, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;
    invoke-virtual { v0, v4 }, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B
    move-result-object v0
    array-length v4, v0
    const/4 v5, 2
    add-int/2addr v4, v5
    const/4 v6, 1
    add-int/2addr v4, v6
    add-int/lit8 v4, v4, 3
    and-int/lit8 v4, v4, -4
    const/16 v7, 8
    add-int/2addr v4, v7
    add-int/lit8 v8, v4, 32
    new-array v8, v8, [B
    const/16 v9, -127
    const/4 v10, 0
    aput-byte v9, v8, v10
    const/16 v11, -55
    aput-byte v11, v8, v6
    const-wide/16 v11, 7
    invoke-static { v8, v5, v11, v12 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->put16([BIJ)V
    const/4 v5, 4
    invoke-static { v8, v5, v2, v3 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->put32([BIJ)V
    iget-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteSsrc:J
    invoke-static { v8, v7, v11, v12 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->put32([BIJ)V
    iget-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->maxExtSeq:J
    iget-wide v13, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->baseExtSeq:J
    cmp-long v15, v11, v13
    const-wide/16 v16, 0
    if-ltz v15, :L1
    sub-long/2addr v11, v13
    const-wide/16 v13, 1
    add-long/2addr v11, v13
    goto :L2
  :L1
    move-wide/from16 v11, v16
  :L2
    const-wide/32 v13, -8388608
    const-wide/32 v5, 8388607
    iget-wide v9, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->received:J
    sub-long v9, v11, v9
    invoke-static { v5, v6, v9, v10 }, Ljava/lang/Math;->min(JJ)J
    move-result-wide v5
    invoke-static { v13, v14, v5, v6 }, Ljava/lang/Math;->max(JJ)J
    move-result-wide v5
    iget-wide v9, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPrior:J
    sub-long v9, v11, v9
    iget-wide v13, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->received:J
    move-object/from16 v19, v8
    iget-wide v7, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->receivedPrior:J
    sub-long/2addr v13, v7
    sub-long v7, v9, v13
    cmp-long v13, v9, v16
    if-lez v13, :L4
    cmp-long v13, v7, v16
    if-gtz v13, :L3
    goto :L4
  :L3
    const-wide/16 v13, 255
    const/16 v18, 8
    shl-long v7, v7, v18
    div-long/2addr v7, v9
    invoke-static { v13, v14, v7, v8 }, Ljava/lang/Math;->min(JJ)J
    move-result-wide v7
    long-to-int v7, v7
    goto :L5
  :L4
    const/4 v7, 0
  :L5
    iput-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPrior:J
    iget-wide v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->received:J
    iput-wide v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->receivedPrior:J
    const/16 v8, 12
    int-to-byte v7, v7
    aput-byte v7, v19, v8
    const/16 v7, 13
    const/16 v8, 16
    ushr-long v9, v5, v8
    long-to-int v9, v9
    int-to-byte v9, v9
    aput-byte v9, v19, v7
    const/16 v7, 14
    const/16 v9, 8
    ushr-long v9, v5, v9
    long-to-int v9, v9
    int-to-byte v9, v9
    aput-byte v9, v19, v7
    const/16 v7, 15
    long-to-int v5, v5
    int-to-byte v5, v5
    aput-byte v5, v19, v7
    iget-wide v5, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->maxExtSeq:J
    move-object/from16 v7, v19
    invoke-static { v7, v8, v5, v6 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->put32([BIJ)V
    const/16 v5, 20
    iget-wide v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->jitterQ4:J
    const-wide/16 v10, 16
    div-long/2addr v8, v10
    invoke-static { v7, v5, v8, v9 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->put32([BIJ)V
    const/16 v5, 24
    iget-wide v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->lastSrMiddle32:J
    invoke-static { v7, v5, v8, v9 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->put32([BIJ)V
    iget-wide v5, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->lastSrArrivalMs:J
    cmp-long v5, v5, v16
    if-nez v5, :L7
  :L6
    move-wide/from16 v5, v16
    goto :L8
  :L7
    const-wide v5, 4294967295L
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v8
    iget-wide v10, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->lastSrArrivalMs:J
    sub-long/2addr v8, v10
    const-wide/32 v10, 65536
    mul-long/2addr v8, v10
    const-wide/16 v10, 1000
    div-long/2addr v8, v10
    invoke-static { v5, v6, v8, v9 }, Ljava/lang/Math;->min(JJ)J
    move-result-wide v16
    goto :L6
  :L8
    const/16 v8, 28
    invoke-static { v7, v8, v5, v6 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->put32([BIJ)V
    const/16 v5, 32
    const/16 v6, -127
    aput-byte v6, v7, v5
    const/16 v5, 33
    const/16 v6, -54
    aput-byte v6, v7, v5
    const/16 v5, 34
    const/4 v6, 4
    div-int/2addr v4, v6
    const/4 v6, 1
    sub-int/2addr v4, v6
    int-to-long v8, v4
    invoke-static { v7, v5, v8, v9 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->put16([BIJ)V
    const/16 v4, 36
    invoke-static { v7, v4, v2, v3 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->put32([BIJ)V
    const/16 v2, 40
    aput-byte v6, v7, v2
    const/16 v2, 41
    array-length v3, v0
    int-to-byte v3, v3
    aput-byte v3, v7, v2
    const/16 v2, 42
    array-length v3, v0
    const/4 v4, 0
    invoke-static { v0, v4, v7, v2, v3 }, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
  :L9
    monitor-exit p0
    return-object v7
  :L10
  .line 344
    move-exception v0
    monitor-exit p0
    throw v0
.end method

.method capturePacket([BI)V
  .catchall { :L1 .. :L2 } :L3
  .catchall { :L4 .. :L5 } :L6
  .registers 11
  .line 331
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->capture:Ljava/io/BufferedOutputStream;
    if-eqz v0, :L8
    iget-wide v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->capturedBytes:J
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->captureMax:I
    int-to-long v4, v3
    cmp-long v4, v1, v4
    if-ltz v4, :L0
    goto :L8
  :L0
    int-to-long v4, p2
    int-to-long v6, v3
    sub-long/2addr v6, v1
  :L1
    invoke-static { v4, v5, v6, v7 }, Ljava/lang/Math;->min(JJ)J
    move-result-wide v1
    long-to-int p2, v1
    ushr-int/lit8 v1, p2, 8
    and-int/lit16 v1, v1, 255
    invoke-virtual { v0, v1 }, Ljava/io/BufferedOutputStream;->write(I)V
    and-int/lit16 v1, p2, 255
    invoke-virtual { v0, v1 }, Ljava/io/BufferedOutputStream;->write(I)V
    const/4 v1, 0
    invoke-virtual { v0, p1, v1, p2 }, Ljava/io/BufferedOutputStream;->write([BII)V
    iget-wide v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->capturedBytes:J
    add-int/lit8 p2, p2, 2
    int-to-long p1, p2
    add-long/2addr v1, p1
    iput-wide v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->capturedBytes:J
  :L2
    goto :L8
  :L3
    move-exception p1
    new-instance p2, Ljava/lang/StringBuilder;
    invoke-direct { p2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "CAPTURE_FAIL callId="
    invoke-virtual { p2, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    iget v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { p2, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    const-string v1, "AP_RTP_PLAYBACK"
    invoke-static { v1, p2, p1 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L4
    invoke-virtual { v0 }, Ljava/io/BufferedOutputStream;->close()V
  :L5
    goto :L7
  :L6
    move-exception p1
  :L7
    const/4 p1, 0
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->capture:Ljava/io/BufferedOutputStream;
  :L8
    return-void
.end method

.method cleanup(Ljava/lang/String;)V
  .catchall { :L0 .. :L1 } :L7
  .catchall { :L8 .. :L9 } :L7
  .registers 8
  .line 511
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->cleanupStarted:Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v1, 0
    const/4 v2, 1
    invoke-virtual { v0, v1, v2 }, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z
    move-result v0
    if-eqz v0, :L10
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v0, v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->closeSockets()V
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->wakeQueue()V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpThread:Ljava/lang/Thread;
    const-wide/16 v3, 1500
    invoke-virtual { p0, v0, v3, v4 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->join(Ljava/lang/Thread;J)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->decodeThread:Ljava/lang/Thread;
    invoke-virtual { p0, v0, v3, v4 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->join(Ljava/lang/Thread;J)V
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->releaseMedia()V
    invoke-static { }, Lcom/sec/internal/google/ApRtpReceivePoc;->access$100()Ljava/util/concurrent/ConcurrentHashMap;
    move-result-object v0
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-static { v3 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    invoke-virtual { v0, v3, p0 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;Ljava/lang/Object;)Z
    invoke-virtual { p0, p1 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->summary(Ljava/lang/String;)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->cleanupComplete:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v0, v2 }, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->completionLock:Ljava/lang/Object;
    monitor-enter v0
  :L0
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->completionLock:Ljava/lang/Object;
    invoke-virtual { v3 }, Ljava/lang/Object;->notifyAll()V
    monitor-exit v0
  :L1
    const-string v0, "AP_RTP_PLAYBACK"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "TEARDOWN_COMPLETE callId="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " generation="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->generation:J
    invoke-virtual { v3, v4, v5 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " reason="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " mapSize="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-static { }, Lcom/sec/internal/google/ApRtpReceivePoc;->access$100()Ljava/util/concurrent/ConcurrentHashMap;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/util/concurrent/ConcurrentHashMap;->size()I
    move-result v3
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " mainAlive="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mainThread:Ljava/lang/Thread;
    invoke-static { v3 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->alive(Ljava/lang/Thread;)Z
    move-result v3
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " rtcpAlive="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpThread:Ljava/lang/Thread;
    invoke-static { v3 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->alive(Ljava/lang/Thread;)Z
    move-result v3
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " decodeAlive="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->decodeThread:Ljava/lang/Thread;
    invoke-static { v3 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->alive(Ljava/lang/Thread;)Z
    move-result v3
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " socketsClosed="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocket:Ljava/net/DatagramSocket;
    if-nez v3, :L2
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocket:Ljava/net/DatagramSocket;
    if-nez v3, :L2
    move v3, v2
    goto :L3
  :L2
    move v3, v1
  :L3
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " mediaReleased="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    if-nez v3, :L4
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->track:Landroid/media/AudioTrack;
    if-nez v3, :L4
    move v3, v2
    goto :L5
  :L4
    move v3, v1
  :L5
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " uplinkReleased="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    if-nez v3, :L6
    move v1, v2
  :L6
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { v0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    goto :L11
  :L7
    move-exception p1
  :L8
    monitor-exit v0
  :L9
    throw p1
  :L10
    const-wide/16 v0, 2000
    invoke-virtual { p0, v0, v1 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->awaitCleanup(J)V
  :L11
    return-void
.end method

.method closeSockets()V
  .catchall { :L4 .. :L5 } :L6
  .registers 4
  .line 515
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaMilestoneThread:Ljava/lang/Thread;
    if-eqz v0, :L0
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v1
    if-eq v0, v1, :L0
    invoke-virtual { v0 }, Ljava/lang/Thread;->interrupt()V
  :L0
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    const/4 v1, 0
    iput-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    if-eqz v0, :L1
    const-string v2, "socket_close"
    invoke-virtual { v0, v2 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->stop(Ljava/lang/String;)V
  :L1
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocket:Ljava/net/DatagramSocket;
    if-eqz v0, :L2
    invoke-virtual { v0 }, Ljava/net/DatagramSocket;->close()V
    iput-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocket:Ljava/net/DatagramSocket;
  :L2
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocket:Ljava/net/DatagramSocket;
    if-eqz v0, :L3
    invoke-virtual { v0 }, Ljava/net/DatagramSocket;->close()V
    iput-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocket:Ljava/net/DatagramSocket;
  :L3
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->capture:Ljava/io/BufferedOutputStream;
    iput-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->capture:Ljava/io/BufferedOutputStream;
    if-eqz v0, :L7
  :L4
    invoke-virtual { v0 }, Ljava/io/BufferedOutputStream;->flush()V
    invoke-virtual { v0 }, Ljava/io/BufferedOutputStream;->close()V
  :L5
    goto :L7
  :L6
    move-exception v0
  :L7
    return-void
.end method

.method declared-synchronized commitProfile(ZIZ)V
  .catchall { :L0 .. :L1 } :L17
  .catchall { :L2 .. :L13 } :L17
  .catchall { :L13 .. :L15 } :L14
  .catchall { :L15 .. :L16 } :L17
  .registers 5
    monitor-enter p0
  :L0
  .line 287
    iget-boolean v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaResolved:Z
  :L1
    if-eqz v0, :L2
    if-eqz p3, :L2
    monitor-exit p0
    return-void
  :L2
  .line 288
    iput-boolean p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->amrNb:Z
  .line 289
    if-eqz p1, :L3
    const-string v0, "amr-nb"
    goto :L4
  :L3
    const-string v0, "amr-wb"
  :L4
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecProfile:Ljava/lang/String;
  .line 290
    if-eqz p1, :L5
    const/16 v0, 8000
    goto :L6
  :L5
    const/16 v0, 16000
  :L6
    iput v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->sampleRate:I
  .line 291
    if-eqz p1, :L7
    const/16 v0, 160
    goto :L8
  :L7
    const/16 v0, 320
  :L8
    iput v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->timestampStep:I
  .line 292
    if-eqz p1, :L9
    const-string p1, "audio/3gpp"
    goto :L10
  :L9
    const-string p1, "audio/amr-wb"
  :L10
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecMime:Ljava/lang/String;
  .line 293
    iput p2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
  .line 294
    if-eqz p3, :L16
  .line 295
    invoke-static { }, Lcom/sec/internal/google/ApMediaConfigPoc;->voicePtOverride()I
    move-result p1
  .line 296
    const/16 p3, 96
    if-lt p1, p3, :L11
    const/16 p3, 127
    if-gt p1, p3, :L11
  .line 297
    iput p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplinkPt:I
  .line 298
    const-string p1, "diagnostic-override"
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->txPtSource:Ljava/lang/String;
    goto :L12
  :L11
  .line 300
    iput p2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplinkPt:I
  .line 301
    const-string p1, "wire-symmetric-assumption"
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->txPtSource:Ljava/lang/String;
  :L12
  .line 303
    const/4 p1, 1
    iput-boolean p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaResolved:Z
  .line 304
    iget-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    monitor-enter p1
  :L13
    iget-object p2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    invoke-virtual { p2 }, Ljava/lang/Object;->notifyAll()V
    monitor-exit p1
    goto :L16
  :L14
    move-exception p2
    monitor-exit p1
  :L15
    throw p2
  :L16
  .line 306
    monitor-exit p0
    return-void
  :L17
  .line 286
    move-exception p1
    monitor-exit p0
    throw p1
.end method

.method decodeLoop()V
  .catchall { :L0 .. :L1 } :L14
  .catchall { :L1 .. :L3 } :L11
  .catchall { :L3 .. :L4 } :L14
  .catchall { :L5 .. :L10 } :L14
  .catchall { :L12 .. :L13 } :L11
  .catchall { :L13 .. :L14 } :L14
  .catchall { :L15 .. :L16 } :L17
  .registers 15
  :L0
  .line 504
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    monitor-enter v0
  :L1
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v1
    if-eqz v1, :L2
    iget-boolean v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaResolved:Z
    if-nez v1, :L2
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    const-wide/16 v2, 200
    invoke-virtual { v1, v2, v3 }, Ljava/lang/Object;->wait(J)V
    goto :L1
  :L2
    monitor-exit v0
  :L3
  .line 505
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v0 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v0
  :L4
    if-nez v0, :L5
  .line 509
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->releaseMedia()V
  .line 505
    return-void
  :L5
  .line 506
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->initMedia()V
    new-instance v0, Landroid/media/MediaCodec$BufferInfo;
    invoke-direct { v0 }, Landroid/media/MediaCodec$BufferInfo;-><init>()V
    const-wide/16 v1, 0
    move-wide v10, v1
  :L6
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v3 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v3
    if-eqz v3, :L16
  .line 507
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->takeFrame()Lcom/sec/internal/google/ApRtpReceivePoc$Frame;
    move-result-object v3
    if-eqz v3, :L7
    iget-object v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    const-wide/16 v5, 10000
    invoke-virtual { v4, v5, v6 }, Landroid/media/MediaCodec;->dequeueInputBuffer(J)I
    move-result v4
    if-ltz v4, :L7
    iget-object v5, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v5, v4 }, Landroid/media/MediaCodec;->getInputBuffer(I)Ljava/nio/ByteBuffer;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/nio/ByteBuffer;->clear()Ljava/nio/Buffer;
    move-result-object v6
    check-cast v6, Ljava/nio/ByteBuffer;
    iget-object v6, v3, Lcom/sec/internal/google/ApRtpReceivePoc$Frame;->au:[B
    invoke-virtual { v5, v6 }, Ljava/nio/ByteBuffer;->put([B)Ljava/nio/ByteBuffer;
    iget-object v5, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    const/4 v6, 0
    iget-object v3, v3, Lcom/sec/internal/google/ApRtpReceivePoc$Frame;->au:[B
    array-length v7, v3
    const/4 v9, 0
    move-object v3, v5
    move v5, v6
    move v6, v7
    move-wide v7, v10
    invoke-virtual/range { v3 .. v9 }, Landroid/media/MediaCodec;->queueInputBuffer(IIIJI)V
    const-wide/16 v3, 20000
    add-long/2addr v10, v3
  :L7
  .line 508
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v3, v0, v1, v2 }, Landroid/media/MediaCodec;->dequeueOutputBuffer(Landroid/media/MediaCodec$BufferInfo;J)I
    move-result v3
    if-gez v3, :L8
  .line 509
    goto :L6
  :L8
  .line 508
    iget-object v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v4, v3 }, Landroid/media/MediaCodec;->getOutputBuffer(I)Ljava/nio/ByteBuffer;
    move-result-object v4
    const/4 v5, 0
    if-eqz v4, :L9
    iget v6, v0, Landroid/media/MediaCodec$BufferInfo;->size:I
    if-lez v6, :L9
    iget v6, v0, Landroid/media/MediaCodec$BufferInfo;->size:I
    new-array v7, v6, [B
    iget v8, v0, Landroid/media/MediaCodec$BufferInfo;->offset:I
    invoke-virtual { v4, v8 }, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;
    move-result-object v8
    check-cast v8, Ljava/nio/ByteBuffer;
    invoke-virtual { v4, v7 }, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;
    iget-wide v8, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->decodedBytes:J
    int-to-long v12, v6
    add-long/2addr v8, v12
    iput-wide v8, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->decodedBytes:J
    iget-object v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->track:Landroid/media/AudioTrack;
    if-eqz v4, :L9
    iget-object v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->track:Landroid/media/AudioTrack;
    invoke-virtual { v4, v7, v5, v6, v5 }, Landroid/media/AudioTrack;->write([BIII)I
    move-result v4
    if-lez v4, :L9
    iget-wide v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->playedBytes:J
    int-to-long v8, v4
    add-long/2addr v6, v8
    iput-wide v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->playedBytes:J
  :L9
    iget-object v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v4, v3, v5 }, Landroid/media/MediaCodec;->releaseOutputBuffer(IZ)V
  :L10
    goto :L7
  :L11
  .line 504
    move-exception v1
  :L12
    monitor-exit v0
  :L13
    throw v1
  :L14
  .line 509
    move-exception v0
  :L15
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v1
    if-eqz v1, :L16
    const-string v1, "AP_RTP_PLAYBACK"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "DECODE_FAIL callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v1, v2, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L16
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->releaseMedia()V
    return-void
  :L17
    move-exception v0
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->releaseMedia()V
    throw v0
.end method

.method depacketize([BII)Ljava/util/ArrayList;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "([BII)",
      "Ljava/util/ArrayList<",
      "[B>;"
    }
  .end annotation
  .registers 6
  .line 486
    new-instance v0, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;
    invoke-direct { v0, p1, p2, p3 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;-><init>([BII)V
    const/4 p1, 4
    invoke-virtual { v0, p1 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    const/4 p2, 1
    invoke-virtual { v0, p2 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result p3
    invoke-virtual { v0, p1 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result p1
    invoke-virtual { v0, p2 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result p2
    if-nez p3, :L4
    iget-boolean p3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->amrNb:Z
    if-eqz p3, :L0
    const/16 p3, 8
    if-gt p1, p3, :L1
  :L0
    iget-boolean p3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->amrNb:Z
    if-nez p3, :L2
    const/16 p3, 9
    if-gt p1, p3, :L1
    goto :L2
  :L1
    new-instance p2, Ljava/lang/IllegalArgumentException;
    new-instance p3, Ljava/lang/StringBuilder;
    invoke-direct { p3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "unsupported FT="
    invoke-virtual { p3, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p3
    invoke-virtual { p3, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-direct { p2, p1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw p2
  :L2
  .line 487
    iget-boolean p3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->amrNb:Z
    invoke-static { p1, p3 }, Lcom/sec/internal/google/ApRtpReceivePoc;->access$000(IZ)I
    move-result p3
    invoke-virtual { v0 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->remaining()I
    move-result v1
    if-lt v1, p3, :L3
  .line 488
    new-instance v1, Ljava/util/ArrayList;
    invoke-direct { v1 }, Ljava/util/ArrayList;-><init>()V
    invoke-virtual { v0, p1, p2, p3 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->readStorage(III)[B
    move-result-object p1
    invoke-virtual { v1, p1 }, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    return-object v1
  :L3
  .line 487
    new-instance p1, Ljava/lang/IllegalArgumentException;
    new-instance p2, Ljava/lang/StringBuilder;
    invoke-direct { p2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "speech bits "
    invoke-virtual { p2, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { v0 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->remaining()I
    move-result v0
    invoke-virtual { p2, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    const-string v0, "<"
    invoke-virtual { p2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, p3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    invoke-direct { p1, p2 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw p1
  :L4
  .line 486
    new-instance p1, Ljava/lang/IllegalArgumentException;
    const-string p2, "multi-frame unsupported"
    invoke-direct { p1, p2 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw p1
.end method

.method initMedia()V
  .annotation system Ldalvik/annotation/Throws;
    value = {
      Ljava/lang/Exception;
    }
  .end annotation
  .registers 9
  .line 491
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecMime:Ljava/lang/String;
    invoke-static { v0 }, Landroid/media/MediaCodec;->createDecoderByType(Ljava/lang/String;)Landroid/media/MediaCodec;
    move-result-object v0
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecMime:Ljava/lang/String;
    iget v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->sampleRate:I
    const/4 v2, 1
    invoke-static { v0, v1, v2 }, Landroid/media/MediaFormat;->createAudioFormat(Ljava/lang/String;II)Landroid/media/MediaFormat;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    const/4 v3, 0
    const/4 v4, 0
    invoke-virtual { v1, v0, v3, v3, v4 }, Landroid/media/MediaCodec;->configure(Landroid/media/MediaFormat;Landroid/view/Surface;Landroid/media/MediaCrypto;I)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v0 }, Landroid/media/MediaCodec;->start()V
  .line 492
    iget-boolean v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->trackEnabled:Z
    if-eqz v0, :L2
    iget v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->sampleRate:I
    const/4 v1, 4
    const/4 v3, 2
    invoke-static { v0, v1, v3 }, Landroid/media/AudioTrack;->getMinBufferSize(III)I
    move-result v0
    new-instance v5, Landroid/media/AudioTrack$Builder;
    invoke-direct { v5 }, Landroid/media/AudioTrack$Builder;-><init>()V
    new-instance v6, Landroid/media/AudioAttributes$Builder;
    invoke-direct { v6 }, Landroid/media/AudioAttributes$Builder;-><init>()V
    invoke-virtual { v6, v3 }, Landroid/media/AudioAttributes$Builder;->setUsage(I)Landroid/media/AudioAttributes$Builder;
    move-result-object v6
    invoke-virtual { v6, v2 }, Landroid/media/AudioAttributes$Builder;->setContentType(I)Landroid/media/AudioAttributes$Builder;
    move-result-object v6
    invoke-virtual { v6 }, Landroid/media/AudioAttributes$Builder;->build()Landroid/media/AudioAttributes;
    move-result-object v6
    invoke-virtual { v5, v6 }, Landroid/media/AudioTrack$Builder;->setAudioAttributes(Landroid/media/AudioAttributes;)Landroid/media/AudioTrack$Builder;
    move-result-object v5
    new-instance v6, Landroid/media/AudioFormat$Builder;
    invoke-direct { v6 }, Landroid/media/AudioFormat$Builder;-><init>()V
    iget v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->sampleRate:I
    invoke-virtual { v6, v7 }, Landroid/media/AudioFormat$Builder;->setSampleRate(I)Landroid/media/AudioFormat$Builder;
    move-result-object v6
    invoke-virtual { v6, v1 }, Landroid/media/AudioFormat$Builder;->setChannelMask(I)Landroid/media/AudioFormat$Builder;
    move-result-object v1
    invoke-virtual { v1, v3 }, Landroid/media/AudioFormat$Builder;->setEncoding(I)Landroid/media/AudioFormat$Builder;
    move-result-object v1
    invoke-virtual { v1 }, Landroid/media/AudioFormat$Builder;->build()Landroid/media/AudioFormat;
    move-result-object v1
    invoke-virtual { v5, v1 }, Landroid/media/AudioTrack$Builder;->setAudioFormat(Landroid/media/AudioFormat;)Landroid/media/AudioTrack$Builder;
    move-result-object v1
    iget-boolean v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->amrNb:Z
    if-eqz v3, :L0
    const/16 v3, 3200
    goto :L1
  :L0
    const/16 v3, 6400
  :L1
    invoke-static { v0, v3 }, Ljava/lang/Math;->max(II)I
    move-result v0
    invoke-virtual { v1, v0 }, Landroid/media/AudioTrack$Builder;->setBufferSizeInBytes(I)Landroid/media/AudioTrack$Builder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Landroid/media/AudioTrack$Builder;->setTransferMode(I)Landroid/media/AudioTrack$Builder;
    move-result-object v0
    invoke-virtual { v0 }, Landroid/media/AudioTrack$Builder;->build()Landroid/media/AudioTrack;
    move-result-object v0
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->track:Landroid/media/AudioTrack;
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->track:Landroid/media/AudioTrack;
    invoke-virtual { v0 }, Landroid/media/AudioTrack;->play()V
  :L2
  .line 493
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "MEDIA_READY callId="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " codec="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v1 }, Landroid/media/MediaCodec;->getName()Ljava/lang/String;
    move-result-object v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " track="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->track:Landroid/media/AudioTrack;
    if-eqz v1, :L3
    goto :L4
  :L3
    move v2, v4
  :L4
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    const-string v1, "AP_RTP_PLAYBACK"
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 494
    return-void
.end method

.method join(Ljava/lang/Thread;J)V
  .catch Ljava/lang/InterruptedException; { :L0 .. :L1 } :L2
  .registers 5
  .line 516
    if-eqz p1, :L3
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v0
    if-eq p1, v0, :L3
  :L0
    invoke-virtual { p1, p2, p3 }, Ljava/lang/Thread;->join(J)V
  :L1
    goto :L3
  :L2
    move-exception p1
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/Thread;->interrupt()V
  :L3
    return-void
.end method

.method learnEndpoint(Ljava/net/DatagramPacket;)V
  .registers 7
  .line 341
    invoke-virtual { p1 }, Ljava/net/DatagramPacket;->getAddress()Ljava/net/InetAddress;
    move-result-object v0
    invoke-virtual { p1 }, Ljava/net/DatagramPacket;->getPort()I
    move-result p1
    if-eqz v0, :L2
    const/4 v1, 1
    if-lt p1, v1, :L2
    const v1, 65535
    if-gt p1, v1, :L2
    invoke-virtual { v0 }, Ljava/net/InetAddress;->isAnyLocalAddress()Z
    move-result v1
    if-nez v1, :L2
    invoke-virtual { v0 }, Ljava/net/InetAddress;->isMulticastAddress()Z
    move-result v1
    if-eqz v1, :L0
    goto :L2
  :L0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteRtcpAddress:Ljava/net/InetAddress;
    invoke-virtual { v0, v1 }, Ljava/net/InetAddress;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :L1
    iget v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteRtcpPort:I
    if-eq p1, v1, :L2
  :L1
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteRtcpAddress:Ljava/net/InetAddress;
    iput p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteRtcpPort:I
    iget-wide v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->endpointChanges:J
    const-wide/16 v3, 1
    add-long/2addr v1, v3
    iput-wide v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->endpointChanges:J
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "RTCP_ENDPOINT callId="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " address="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v0 }, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;
    move-result-object v0
    invoke-virtual { v1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " port="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    const-string v0, "AP_RTP_PLAYBACK"
    invoke-static { v0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L2
    return-void
.end method

.method logMediaMilestone()V
  .catch Ljava/lang/InterruptedException; { :L0 .. :L1 } :L3
  .registers 5
  .line 327
    const-wide/16 v0, 3000
  :L0
    invoke-static { v0, v1 }, Ljava/lang/Thread;->sleep(J)V
  :L1
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v0 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v0
    if-eqz v0, :L2
    iget-wide v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtpElapsedMs:J
    const-wide/16 v2, 0
    cmp-long v0, v0, v2
    if-gez v0, :L2
    iget-wide v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtcpElapsedMs:J
    cmp-long v0, v0, v2
    if-gez v0, :L2
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "AP_MEDIA_LEDGER NO_UDP_AFTER_3S callId="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " generation="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->generation:J
    invoke-virtual { v0, v1, v2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rtpListen="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocketAddress:Ljava/lang/String;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rtcpListen="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocketAddress:Ljava/lang/String;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " network="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->network:Landroid/net/Network;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " networkBound="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-boolean v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->networkBound:Z
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " pt="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " codec="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecProfile:Ljava/lang/String;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    const-string v1, "AP_RTP_PLAYBACK"
    invoke-static { v1, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L2
    return-void
  :L3
    move-exception v0
    return-void
.end method

.method maybeSendReceiverReport()V
  .registers 10
  .line 345
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v0
    iget-boolean v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrEnabled:Z
    if-eqz v2, :L2
    iget-boolean v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->networkBound:Z
    if-eqz v2, :L2
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->lastRrMs:J
    sub-long v2, v0, v2
    iget v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrIntervalSec:I
    int-to-long v4, v4
    const-wide/16 v6, 1000
    mul-long/2addr v4, v6
    cmp-long v2, v2, v4
    if-gez v2, :L0
    goto :L2
  :L0
    iget-object v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocket:Ljava/net/DatagramSocket;
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteRtcpAddress:Ljava/net/InetAddress;
    iget v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteRtcpPort:I
    if-eqz v2, :L2
    if-eqz v3, :L2
    iget-wide v5, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteSsrc:J
    const-wide/16 v7, 0
    cmp-long v5, v5, v7
    if-gez v5, :L1
    goto :L2
  :L1
    iput-wide v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->lastRrMs:J
    invoke-virtual { p0, v2, v3, v4 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->sendReceiverReport(Ljava/net/DatagramSocket;Ljava/net/InetAddress;I)V
  :L2
    return-void
.end method

.method nearestAhead()I
  .registers 7
  .line 495
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    invoke-virtual { v0 }, Ljava/util/TreeMap;->keySet()Ljava/util/Set;
    move-result-object v0
    invoke-interface { v0 }, Ljava/util/Set;->iterator()Ljava/util/Iterator;
    move-result-object v0
    const v1, 65535
    const/4 v2, -1
    move v3, v1
  :L0
    invoke-interface { v0 }, Ljava/util/Iterator;->hasNext()Z
    move-result v4
    if-eqz v4, :L2
    invoke-interface { v0 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Ljava/lang/Integer;
    invoke-virtual { v4 }, Ljava/lang/Integer;->intValue()I
    move-result v4
    iget v5, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedSeq:I
    sub-int v5, v4, v5
    and-int/2addr v5, v1
    if-ltz v2, :L1
    if-ge v5, v3, :L0
  :L1
    move v2, v4
    move v3, v5
    goto :L0
  :L2
    return v2
.end method

.method declared-synchronized observeRtpEndpoint(Ljava/net/DatagramPacket;J)V
  .catchall { :L0 .. :L4 } :L10
  .catchall { :L5 .. :L9 } :L10
  .registers 12
    monitor-enter p0
  :L0
  .line 347
    invoke-virtual { p1 }, Ljava/net/DatagramPacket;->getAddress()Ljava/net/InetAddress;
    move-result-object v2
    invoke-virtual { p1 }, Ljava/net/DatagramPacket;->getPort()I
    move-result v3
    if-eqz v2, :L4
    const/4 p1, 1
    if-lt v3, p1, :L4
    const v0, 65535
    if-gt v3, v0, :L4
    invoke-virtual { v2 }, Ljava/net/InetAddress;->isAnyLocalAddress()Z
    move-result v0
    if-nez v0, :L4
    invoke-virtual { v2 }, Ljava/net/InetAddress;->isMulticastAddress()Z
    move-result v0
    if-eqz v0, :L1
    goto :L4
  :L1
    iget-boolean v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpEndpointLocked:Z
    if-eqz v0, :L5
    iget-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteRtpAddress:Ljava/net/InetAddress;
    invoke-virtual { v2, p1 }, Ljava/net/InetAddress;->equals(Ljava/lang/Object;)Z
    move-result p1
    if-eqz p1, :L2
    iget p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteRtpPort:I
    if-ne v3, p1, :L2
    iget-wide v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidateSsrc:J
    cmp-long p1, p2, v0
    if-eqz p1, :L4
  :L2
    iget-wide v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->endpointChanges:J
    const-wide/16 v4, 1
    add-long/2addr v0, v4
    iput-wide v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->endpointChanges:J
    iget-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    const/4 v0, 0
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    if-eqz p1, :L3
    const-string v0, "endpoint_change"
    invoke-virtual { p1, v0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->stop(Ljava/lang/String;)V
  :L3
    const-string p1, "AP_RTP_PLAYBACK"
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "UPLINK_ENDPOINT_CHANGE callId="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " address="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v2 }, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;
    move-result-object v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, ":"
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " ssrc="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p2, p3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    invoke-static { p1, p2 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  :L4
    monitor-exit p0
    return-void
  :L5
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidateAddress:Ljava/net/InetAddress;
    invoke-virtual { v2, v0 }, Ljava/net/InetAddress;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :L6
    iget v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidatePort:I
    if-ne v3, v0, :L6
    iget-wide v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidateSsrc:J
    cmp-long v0, p2, v0
    if-nez v0, :L6
    iget v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidateCount:I
    add-int/2addr v0, p1
    iput v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidateCount:I
    goto :L7
  :L6
    iput-object v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidateAddress:Ljava/net/InetAddress;
    iput v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidatePort:I
    iput-wide p2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidateSsrc:J
    iput p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidateCount:I
  :L7
    iget v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpCandidateCount:I
    const/16 v1, 10
    if-ne v0, v1, :L4
    iput-object v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteRtpAddress:Ljava/net/InetAddress;
    iput v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteRtpPort:I
    iput-boolean p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpEndpointLocked:Z
    const-string v0, "AP_RTP_PLAYBACK"
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "UPLINK_ENDPOINT_LOCK callId="
    invoke-virtual { v1, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v1, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v4, " address="
    invoke-virtual { v1, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v2 }, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;
    move-result-object v4
    invoke-virtual { v1, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v4, ":"
    invoke-virtual { v1, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v4, " remoteSsrc="
    invoke-virtual { v1, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p2, p3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    invoke-static { v0, p2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    const-string p2, "ap_uplink_rtp"
    invoke-static { p2, p1 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result p2
    if-eqz p2, :L8
    iget-boolean p2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->networkBound:Z
    if-eqz p2, :L8
    invoke-static { }, Lcom/sec/internal/google/ApMediaConfigPoc;->source()Ljava/lang/String;
    move-result-object p1
    const-string p2, "AP_RTP_PLAYBACK"
    new-instance p3, Ljava/lang/StringBuilder;
    invoke-direct { p3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "UPLINK_GATE callId="
    invoke-virtual { p3, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p3
    iget v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { p3, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p3
    const-string v0, " enabled=true source="
    invoke-virtual { p3, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p3
    invoke-virtual { p3, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { p2, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    iget p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->sampleRate:I
    invoke-static { p1 }, Lcom/sec/internal/google/ApMediaConfigPoc;->logSnapshot(I)V
    new-instance p1, Lcom/sec/internal/google/ApRtpUplinkPoc;
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocket:Ljava/net/DatagramSocket;
    iget v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplinkPt:I
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrSenderSsrc()J
    move-result-wide v5
    iget-boolean v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->amrNb:Z
    move-object v0, p1
    invoke-direct/range { v0 .. v7 }, Lcom/sec/internal/google/ApRtpUplinkPoc;-><init>(Ljava/net/DatagramSocket;Ljava/net/InetAddress;IIJZ)V
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    iget-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplink:Lcom/sec/internal/google/ApRtpUplinkPoc;
    invoke-virtual { p1 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->start()V
    goto/16 :L4
  :L8
    const-string p2, "AP_RTP_PLAYBACK"
    new-instance p3, Ljava/lang/StringBuilder;
    invoke-direct { p3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "UPLINK_GATE callId="
    invoke-virtual { p3, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p3
    iget v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { p3, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p3
    const-string v0, " enabled="
    invoke-virtual { p3, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p3
    const-string v0, "ap_uplink_rtp"
    invoke-static { v0, p1 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result p1
    invoke-virtual { p3, p1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p3, " networkBound="
    invoke-virtual { p1, p3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-boolean p3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->networkBound:Z
    invoke-virtual { p1, p3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { p2, p1 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L9
    goto/16 :L4
  :L10
  .line 347
    move-exception p1
    monitor-exit p0
    throw p1
.end method

.method observeWireProfile([BIIZJ)V
  .catchall { :L0 .. :L7 } :L8
  .registers 24
  .line 482
    move-object/from16 v1, p0
    move/from16 v0, p3
    move/from16 v2, p4
    move-wide/from16 v3, p5
    const-string v5, "AP_RTP_PLAYBACK"
  :L0
    new-instance v6, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;
    move-object/from16 v7, p1
    move/from16 v8, p2
    invoke-direct { v6, v7, v8, v0 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;-><init>([BII)V
    const/4 v7, 4
    invoke-virtual { v6, v7 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result v8
    const/4 v9, 1
    invoke-virtual { v6, v9 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result v10
    invoke-virtual { v6, v7 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result v7
    invoke-virtual { v6, v9 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result v6
    iget-object v9, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkCmr:[J
    aget-wide v11, v9, v8
    const-wide/16 v13, 1
    add-long/2addr v11, v13
    aput-wide v11, v9, v8
    iget-object v9, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkFt:[J
    aget-wide v11, v9, v7
    add-long/2addr v11, v13
    aput-wide v11, v9, v7
    if-nez v6, :L1
    iget-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkQ0:J
    add-long/2addr v11, v13
    iput-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkQ0:J
    goto :L2
  :L1
    iget-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkQ1:J
    add-long/2addr v11, v13
    iput-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkQ1:J
  :L2
    if-eqz v2, :L3
    iget-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkMarkers:J
    add-long/2addr v11, v13
    iput-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkMarkers:J
  :L3
    iget-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkPayloadBytes:J
    int-to-long v13, v0
    add-long/2addr v11, v13
    iput-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkPayloadBytes:J
    iget-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->previousRtpTimestamp:J
    const-wide/16 v13, 0
    cmp-long v9, v11, v13
    if-ltz v9, :L5
    sub-long v11, v3, v11
    const-wide v15, 4294967295L
    and-long/2addr v11, v15
    cmp-long v9, v11, v13
    if-lez v9, :L5
    const-wide v15, 2147483648L
    cmp-long v9, v11, v15
    if-gez v9, :L5
    iget-wide v13, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkTimestampStep:J
    const-wide/16 v15, 0
    cmp-long v9, v13, v15
    if-ltz v9, :L4
    cmp-long v9, v11, v13
    if-gez v9, :L5
  :L4
    iput-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkTimestampStep:J
  :L5
    iput-wide v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->previousRtpTimestamp:J
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpPackets:J
    const-wide/16 v11, 5
    cmp-long v9, v3, v11
    if-lez v9, :L6
    const-wide/16 v11, 500
    rem-long/2addr v3, v11
    const-wide/16 v11, 0
    cmp-long v3, v3, v11
    if-nez v3, :L9
  :L6
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "WIRE_PROFILE callId="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget v4, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " count="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpPackets:J
    invoke-virtual { v3, v11, v12 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " cmr="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v8 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " ft="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v7 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " q="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v6 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " follow="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v10 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " payloadBytes="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " marker="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " tsStep="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkTimestampStep:J
    invoke-virtual { v0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v5, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L7
    goto :L9
  :L8
    move-exception v0
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "WIRE_PROFILE_FAIL callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v1, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v2, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v5, v1, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L9
  .line 483
    return-void
.end method

.method declared-synchronized observeWireProfile(IIJJLjava/net/DatagramPacket;[BII)Z
  .catchall { :L0 .. :L1 } :L19
  .catchall { :L2 .. :L3 } :L19
  .catchall { :L5 .. :L7 } :L19
  .catchall { :L10 .. :L15 } :L19
  .catchall { :L16 .. :L17 } :L19
  .registers 27
    move-object/from16 v1, p0
    move/from16 v0, p1
    move/from16 v2, p2
    move-wide/from16 v3, p3
    move-wide/from16 v5, p5
    move-object/from16 v7, p8
    move/from16 v8, p9
    move/from16 v9, p10
    monitor-enter p0
  :L0
  .line 370
    iget-boolean v10, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->wireRelockArmed:Z
    if-eqz v10, :L2
    iget v10, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
    if-eq v0, v10, :L2
  .line 371
    invoke-direct/range { p0 .. p10 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->observeWireRelock(IIJJLjava/net/DatagramPacket;[BII)Z
    move-result v0
  :L1
    monitor-exit p0
    return v0
  :L2
  .line 373
    iget-boolean v10, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaResolved:Z
    const/4 v11, 0
    const/4 v12, 1
    if-eqz v10, :L5
    iget v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
  :L3
    if-ne v0, v2, :L4
    move v11, v12
  :L4
    monitor-exit p0
    return v11
  :L5
  .line 374
    const-string v10, "ap_dtmf_pt"
    const/16 v13, 111
    const/16 v14, 96
    const/16 v15, 127
    invoke-static { v10, v13, v14, v15 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v10
  .line 375
    if-eq v0, v10, :L18
    if-ltz v0, :L18
    if-gt v0, v15, :L18
    invoke-virtual/range { p7 .. p7 }, Ljava/net/DatagramPacket;->getAddress()Ljava/net/InetAddress;
    move-result-object v10
    if-nez v10, :L6
    goto/16 :L18
  :L6
  .line 376
    invoke-virtual { v1, v7, v8, v9, v12 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->validAmrAcquisitionPayload([BIIZ)Z
    move-result v10
  .line 377
    invoke-virtual { v1, v7, v8, v9, v11 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->validAmrAcquisitionPayload([BIIZ)Z
    move-result v7
  .line 378
    if-ne v10, v7, :L8
  .line 379
    iput v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
  :L7
  .line 380
    monitor-exit p0
    return v11
  :L8
  .line 382
    nop
  .line 383
    if-eqz v10, :L9
    const/16 v7, 160
    goto :L10
  :L9
    const/16 v7, 320
  :L10
  .line 384
    iget v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePt:I
    if-ne v0, v8, :L11
    iget-boolean v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateNb:Z
    if-ne v10, v8, :L11
    iget-wide v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSsrc:J
    cmp-long v8, v5, v8
    if-nez v8, :L11
  .line 386
    invoke-virtual/range { p7 .. p7 }, Ljava/net/DatagramPacket;->getPort()I
    move-result v8
    iget v9, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePort:I
    if-ne v8, v9, :L11
  .line 387
    invoke-virtual/range { p7 .. p7 }, Ljava/net/DatagramPacket;->getAddress()Ljava/net/InetAddress;
    move-result-object v8
    iget-object v9, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateAddress:Ljava/net/InetAddress;
    invoke-virtual { v8, v9 }, Ljava/net/InetAddress;->equals(Ljava/lang/Object;)Z
    move-result v8
    if-eqz v8, :L11
    iget v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSeq:I
    if-ltz v8, :L11
    iget v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSeq:I
    add-int/2addr v8, v12
    const v9, 65535
    and-int/2addr v8, v9
    if-ne v2, v8, :L11
    iget-wide v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateTimestamp:J
    const-wide/16 v13, 0
    cmp-long v8, v8, v13
    if-ltz v8, :L11
    iget-wide v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateTimestamp:J
    sub-long v8, v3, v8
    const-wide v13, 4294967295L
    and-long/2addr v8, v13
    int-to-long v13, v7
    cmp-long v7, v8, v13
    if-nez v7, :L11
    move v7, v12
    goto :L12
  :L11
    move v7, v11
  :L12
  .line 391
    if-eqz v7, :L13
  .line 392
    iget v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
    add-int/2addr v0, v12
    iput v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
    goto :L14
  :L13
  .line 394
    iput v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePt:I
  .line 395
    iput-boolean v10, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateNb:Z
  .line 396
    invoke-virtual/range { p7 .. p7 }, Ljava/net/DatagramPacket;->getAddress()Ljava/net/InetAddress;
    move-result-object v0
    iput-object v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateAddress:Ljava/net/InetAddress;
  .line 397
    invoke-virtual/range { p7 .. p7 }, Ljava/net/DatagramPacket;->getPort()I
    move-result v0
    iput v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePort:I
  .line 398
    iput-wide v5, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSsrc:J
  .line 399
    iput v12, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
  :L14
  .line 401
    iput v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateSeq:I
  .line 402
    iput-wide v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateTimestamp:J
  .line 403
    iget v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
  :L15
    const/16 v2, 10
    if-ge v0, v2, :L16
    monitor-exit p0
    return v11
  :L16
  .line 404
    iget v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidatePt:I
    invoke-virtual { v1, v10, v0, v12 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->commitProfile(ZIZ)V
  .line 405
    const-string v0, "AP_RTP_PLAYBACK"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "WIRE_PROFILE_LOCK callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " codec="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget-object v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecProfile:Ljava/lang/String;
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " pt="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " step="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->timestampStep:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " packets="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->profileCandidateCount:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " txPt="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplinkPt:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " txPtSource="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget-object v3, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->txPtSource:Ljava/lang/String;
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " validation=rfc4867-seq-ts-ssrc-source"
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v0, v2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L17
  .line 410
    monitor-exit p0
    return v12
  :L18
  .line 375
    monitor-exit p0
    return v11
  :L19
  .line 369
    move-exception v0
    monitor-exit p0
    throw v0
.end method

.method declared-synchronized parseCompoundRtcp([BI)Z
  .catchall { :L1 .. :L7 } :L8
  .catchall { :L10 .. :L11 } :L8
  .registers 15
    monitor-enter p0
  .line 342
    const/4 v0, 1
    const/4 v1, 0
    move v2, v1
    move v3, v2
  :L0
    add-int/lit8 v4, v2, 4
    const-wide/16 v5, 1
    if-gt v4, p2, :L9
    add-int/lit8 v3, v2, 2
  :L1
    aget-byte v3, p1, v3
    and-int/lit16 v3, v3, 255
    shl-int/lit8 v3, v3, 8
    add-int/lit8 v7, v2, 3
    aget-byte v7, p1, v7
    and-int/lit16 v7, v7, 255
    or-int/2addr v3, v7
    add-int/2addr v3, v0
    const/4 v7, 4
    mul-int/2addr v3, v7
    add-int/lit8 v8, v2, 1
    aget-byte v8, p1, v8
    and-int/lit16 v8, v8, 255
    aget-byte v9, p1, v2
    const/16 v10, 192
    and-int/2addr v9, v10
    const/16 v11, 128
    if-ne v9, v11, :L5
    if-lt v8, v10, :L5
    const/16 v9, 223
    if-gt v8, v9, :L5
    if-lt v3, v7, :L5
    add-int v7, v2, v3
    if-le v7, p2, :L2
    goto :L5
  :L2
    const/16 v5, 200
    if-ne v8, v5, :L4
    const/16 v5, 28
    if-lt v3, v5, :L4
    invoke-static { p1, v4 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->u32([BI)J
    move-result-wide v3
    iget-wide v5, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteSsrc:J
    const-wide/16 v8, 0
    cmp-long v8, v5, v8
    if-ltz v8, :L3
    cmp-long v5, v5, v3
    if-nez v5, :L4
  :L3
    iput-wide v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteSsrc:J
    add-int/lit8 v3, v2, 8
    invoke-static { p1, v3 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->u32([BI)J
    move-result-wide v3
    const-wide/32 v5, 65535
    and-long/2addr v3, v5
    const/16 v5, 16
    shl-long/2addr v3, v5
    add-int/lit8 v2, v2, 12
    invoke-static { p1, v2 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->u32([BI)J
    move-result-wide v8
    ushr-long v5, v8, v5
    or-long v2, v3, v5
    iput-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->lastSrMiddle32:J
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v2
    iput-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->lastSrArrivalMs:J
  :L4
    move v3, v0
    move v2, v7
    goto :L0
  :L5
    iget-wide p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->malformed:J
  :L6
    add-long/2addr p1, v5
    iput-wide p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->malformed:J
  :L7
    monitor-exit p0
    return v1
  :L8
  .line 342
    move-exception p1
    goto :L12
  :L9
  .line 342
    if-eq v2, p2, :L13
  :L10
    iget-wide p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->malformed:J
  :L11
    goto :L6
  :L12
  .line 342
    monitor-exit p0
    throw p1
  :L13
  .line 342
    monitor-exit p0
    return v3
.end method

.method parseRtp([BILjava/net/DatagramPacket;)V
  .catchall { :L0 .. :L16 } :L33
  .catchall { :L16 .. :L24 } :L27
  .catchall { :L24 .. :L26 } :L33
  .catchall { :L28 .. :L29 } :L27
  .catchall { :L29 .. :L33 } :L33
  .registers 26
    move-object/from16 v12, p0
    move-object/from16 v0, p1
    move/from16 v1, p2
  .line 462
    const/16 v2, 12
    if-lt v1, v2, :L32
    const/16 v17, 0
  :L0
    aget-byte v3, v0, v17
    and-int/lit16 v4, v3, 192
    const/16 v11, 128
    if-ne v4, v11, :L32
  .line 463
    and-int/lit8 v4, v3, 15
    and-int/lit8 v5, v3, 16
    const/4 v10, 1
    if-eqz v5, :L1
    move v5, v10
    goto :L2
  :L1
    move/from16 v5, v17
  :L2
    and-int/lit8 v3, v3, 32
    if-eqz v3, :L3
    move v3, v10
    goto :L4
  :L3
    move/from16 v3, v17
  :L4
    aget-byte v6, v0, v10
    and-int/lit8 v6, v6, 127
  .line 464
    const/4 v7, 2
    aget-byte v7, v0, v7
    and-int/lit16 v7, v7, 255
    const/16 v8, 8
    shl-int/2addr v7, v8
    const/4 v9, 3
    aget-byte v9, v0, v9
    and-int/lit16 v9, v9, 255
    or-int/2addr v9, v7
    invoke-static { v0, v8 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->u32([BI)J
    move-result-wide v13
    const/4 v7, 4
    aget-byte v11, v0, v7
    and-int/lit16 v11, v11, 255
    int-to-long v10, v11
    const/16 v19, 24
    shl-long v10, v10, v19
    const/16 v19, 5
    aget-byte v15, v0, v19
    and-int/lit16 v15, v15, 255
    move/from16 v19, v3
    int-to-long v2, v15
    const/16 v15, 16
    shl-long/2addr v2, v15
    or-long/2addr v2, v10
    const/4 v10, 6
    aget-byte v10, v0, v10
    and-int/lit16 v10, v10, 255
    int-to-long v10, v10
    shl-long/2addr v10, v8
    or-long/2addr v2, v10
    const/4 v10, 7
    aget-byte v10, v0, v10
    and-int/lit16 v10, v10, 255
    int-to-long v10, v10
    or-long/2addr v10, v2
  .line 465
    mul-int/2addr v4, v7
    const/16 v2, 12
    add-int/2addr v4, v2
    if-gt v4, v1, :L31
  .line 466
    if-eqz v5, :L8
    add-int/lit8 v2, v4, 4
    if-gt v2, v1, :L7
    add-int/lit8 v2, v4, 2
    aget-byte v2, v0, v2
    and-int/lit16 v2, v2, 255
    shl-int/2addr v2, v8
    add-int/lit8 v3, v4, 3
    aget-byte v3, v0, v3
    and-int/lit16 v3, v3, 255
    or-int/2addr v2, v3
    mul-int/2addr v2, v7
    add-int/2addr v2, v7
    add-int/2addr v4, v2
    if-gt v4, v1, :L5
    goto :L8
  :L5
    new-instance v0, Ljava/lang/IllegalArgumentException;
    const-string v1, "extension size"
    invoke-direct { v0, v1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
  :L6
    throw v0
  :L7
    new-instance v0, Ljava/lang/IllegalArgumentException;
    const-string v1, "extension"
    invoke-direct { v0, v1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    goto :L6
  :L8
    move v15, v4
  .line 467
    if-eqz v19, :L10
    add-int/lit8 v2, v1, -1
    aget-byte v2, v0, v2
    and-int/lit16 v2, v2, 255
    const/4 v8, 1
    if-lt v2, v8, :L9
    sub-int v3, v1, v15
    if-gt v2, v3, :L9
    sub-int/2addr v1, v2
    goto :L11
  :L9
    new-instance v0, Ljava/lang/IllegalArgumentException;
    const-string v1, "padding"
    invoke-direct { v0, v1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw v0
  :L10
    const/4 v8, 1
  :L11
    move v7, v1
  .line 468
    if-le v7, v15, :L30
  .line 469
    iget v1, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
    if-eq v6, v1, :L12
    sub-int v16, v7, v15
    move-object/from16 v1, p0
    move v2, v6
    move v3, v9
    move-wide v4, v10
    move/from16 v18, v7
    move-wide v6, v13
    move/from16 v19, v8
    move-object/from16 v8, p3
    move/from16 p2, v9
    move-object/from16 v9, p1
    move-wide/from16 v20, v10
    move v10, v15
    move/from16 v11, v16
    invoke-virtual/range { v1 .. v11 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->observeWireProfile(IIJJLjava/net/DatagramPacket;[BII)Z
    move-result v1
    if-nez v1, :L13
  .line 470
    iget-wide v0, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->wrongPt:J
    const-wide/16 v2, 1
    add-long/2addr v0, v2
    iput-wide v0, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->wrongPt:J
  .line 471
    return-void
  :L12
  .line 469
    move/from16 v18, v7
    move/from16 v19, v8
    move/from16 p2, v9
    move-wide/from16 v20, v10
  :L13
  .line 473
    move-object/from16 v1, p0
    move/from16 v2, p2
    move-wide/from16 v3, v20
    move-wide v5, v13
    invoke-virtual/range { v1 .. v6 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->updateReception(IJJ)V
    sub-int v8, v18, v15
    aget-byte v1, v0, v19
    const/16 v2, 128
    and-int/2addr v1, v2
    if-eqz v1, :L14
    move/from16 v5, v19
    goto :L15
  :L14
    move/from16 v5, v17
  :L15
    move-object/from16 v1, p0
    move-object/from16 v2, p1
    move v3, v15
    move v4, v8
    move-wide/from16 v6, v20
    invoke-virtual/range { v1 .. v7 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->observeWireProfile([BIIZJ)V
    invoke-virtual { v12, v0, v15, v8 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->depacketize([BII)Ljava/util/ArrayList;
    move-result-object v0
    move-object/from16 v1, p3
    invoke-virtual { v12, v1, v13, v14 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->observeRtpEndpoint(Ljava/net/DatagramPacket;J)V
  .line 474
    iget-object v1, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    monitor-enter v1
  :L16
  .line 475
    invoke-virtual { v0 }, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;
    move-result-object v2
    move/from16 v3, v17
  :L17
    invoke-interface { v2 }, Ljava/util/Iterator;->hasNext()Z
    move-result v4
    const v5, 65535
    if-eqz v4, :L19
    invoke-interface { v2 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v4
    check-cast v4, [B
    move/from16 v6, p2
    add-int v9, v6, v3
    and-int/2addr v5, v9
    iget-object v7, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    invoke-static { v5 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v9
    invoke-virtual { v7, v9 }, Ljava/util/TreeMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v7
    check-cast v7, Ljava/util/ArrayList;
    if-nez v7, :L18
    new-instance v7, Ljava/util/ArrayList;
    invoke-direct { v7 }, Ljava/util/ArrayList;-><init>()V
    iget-object v9, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    invoke-static { v5 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v10
    invoke-virtual { v9, v10, v7 }, Ljava/util/TreeMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
  :L18
    new-instance v9, Lcom/sec/internal/google/ApRtpReceivePoc$Frame;
    int-to-long v10, v3
    iget v13, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->timestampStep:I
    int-to-long v13, v13
    mul-long/2addr v10, v13
    move-wide/from16 v13, v20
    add-long/2addr v10, v13
    invoke-direct { v9, v5, v10, v11, v4 }, Lcom/sec/internal/google/ApRtpReceivePoc$Frame;-><init>(IJ[B)V
    invoke-virtual { v7, v9 }, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    add-int/lit8 v3, v3, 1
    iget-wide v4, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->frames:J
    const-wide/16 v9, 1
    add-long/2addr v4, v9
    iput-wide v4, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->frames:J
    move/from16 p2, v6
    move-wide/from16 v20, v13
    goto :L17
  :L19
    move/from16 v6, p2
    move-wide/from16 v13, v20
  :L20
  .line 476
    iget-object v2, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    invoke-virtual { v2 }, Ljava/util/TreeMap;->size()I
    move-result v2
    iget v3, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->jitterMax:I
    if-le v2, v3, :L23
    iget-object v2, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    invoke-virtual { v2 }, Ljava/util/TreeMap;->firstKey()Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Ljava/lang/Integer;
    invoke-virtual { v2 }, Ljava/lang/Integer;->intValue()I
    move-result v2
    iget v3, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedSeq:I
    if-ltz v3, :L22
    const/4 v3, -1
    iget-object v4, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    invoke-virtual { v4 }, Ljava/util/TreeMap;->keySet()Ljava/util/Set;
    move-result-object v4
    invoke-interface { v4 }, Ljava/util/Set;->iterator()Ljava/util/Iterator;
    move-result-object v4
  :L21
    invoke-interface { v4 }, Ljava/util/Iterator;->hasNext()Z
    move-result v7
    if-eqz v7, :L22
    invoke-interface { v4 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v7
    check-cast v7, Ljava/lang/Integer;
    invoke-virtual { v7 }, Ljava/lang/Integer;->intValue()I
    move-result v7
    iget v9, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedSeq:I
    sub-int v9, v7, v9
    and-int/2addr v9, v5
    if-le v9, v3, :L21
    const v10, 32768
    if-ge v9, v10, :L21
    move v2, v7
    move v3, v9
    goto :L21
  :L22
    iget-object v3, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    invoke-static { v2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v2
    invoke-virtual { v3, v2 }, Ljava/util/TreeMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    iget-wide v2, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->dropped:J
    const-wide/16 v9, 1
    add-long/2addr v2, v9
    iput-wide v2, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->dropped:J
    goto :L20
  :L23
    iget-object v2, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    invoke-virtual { v2 }, Ljava/lang/Object;->notifyAll()V
  .line 477
    monitor-exit v1
  :L24
  .line 478
    iget-wide v1, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpPackets:J
    const-wide/16 v3, 5
    cmp-long v5, v1, v3
    if-lez v5, :L25
    const-wide/16 v3, 100
    rem-long/2addr v1, v3
    const-wide/16 v3, 0
    cmp-long v1, v1, v3
    if-nez v1, :L34
  :L25
    const-string v1, "AP_RTP_PLAYBACK"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "RTP_RX callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " count="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget-wide v3, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpPackets:J
    invoke-virtual { v2, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " seq="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v6 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " ts="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v13, v14 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " payload="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v8 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " frames="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v0 }, Ljava/util/ArrayList;->size()I
    move-result v0
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L26
    goto :L34
  :L27
  .line 477
    move-exception v0
  :L28
    monitor-exit v1
  :L29
    throw v0
  :L30
  .line 468
    new-instance v0, Ljava/lang/IllegalArgumentException;
    const-string v1, "empty"
    invoke-direct { v0, v1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw v0
  :L31
  .line 465
    new-instance v0, Ljava/lang/IllegalArgumentException;
    const-string v1, "csrc"
    invoke-direct { v0, v1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw v0
  :L32
  .line 462
    new-instance v0, Ljava/lang/IllegalArgumentException;
    const-string v1, "version/header"
    invoke-direct { v0, v1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw v0
  :L33
  .line 479
    move-exception v0
    iget-wide v1, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->badRtp:J
    const-wide/16 v3, 1
    add-long/2addr v1, v3
    iput-wide v1, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->badRtp:J
    const-wide/16 v3, 5
    cmp-long v1, v1, v3
    if-gtz v1, :L34
    const-string v1, "AP_RTP_PLAYBACK"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "RTP_DROP callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, v12, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " "
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    goto :L35
  :L34
    nop
  :L35
  .line 480
    return-void
.end method

.method receiveRtcp()V
  .catch Ljava/net/SocketTimeoutException; { :L1 .. :L2 } :L11
  .catchall { :L1 .. :L2 } :L10
  .catch Ljava/net/SocketTimeoutException; { :L3 .. :L9 } :L11
  .catchall { :L3 .. :L9 } :L10
  .registers 13
  .line 332
    const-string v0, "AP_RTP_PLAYBACK"
    const/16 v1, 2048
    new-array v2, v1, [B
    new-instance v3, Ljava/net/DatagramPacket;
    invoke-direct { v3, v2, v1 }, Ljava/net/DatagramPacket;-><init>([BI)V
  :L0
    iget-object v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v4 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v4
    if-eqz v4, :L12
  :L1
  .line 333
    invoke-virtual { v3, v1 }, Ljava/net/DatagramPacket;->setLength(I)V
    iget-object v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocket:Ljava/net/DatagramSocket;
    invoke-virtual { v4, v3 }, Ljava/net/DatagramSocket;->receive(Ljava/net/DatagramPacket;)V
    iget-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpPackets:J
    const-wide/16 v6, 1
    add-long/2addr v4, v6
    iput-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpPackets:J
    iget-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpBytes:J
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getLength()I
    move-result v6
    int-to-long v6, v6
    add-long/2addr v4, v6
    iput-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpBytes:J
    iget-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtcpElapsedMs:J
  :L2
    const-wide/16 v6, 0
    cmp-long v4, v4, v6
    const-string v5, " bytes="
    if-gez v4, :L4
  :L3
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v8
    iget-wide v10, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->startElapsedMs:J
    sub-long/2addr v8, v10
    iput-wide v8, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtcpElapsedMs:J
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getAddress()Ljava/net/InetAddress;
    move-result-object v8
    invoke-virtual { v8 }, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;
    move-result-object v8
    invoke-virtual { v4, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v8, ":"
    invoke-virtual { v4, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getPort()I
    move-result v8
    invoke-virtual { v4, v8 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    iput-object v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtcpSource:Ljava/lang/String;
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "AP_MEDIA_LEDGER FIRST_RTCP callId="
    invoke-virtual { v4, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    iget v8, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v4, v8 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v8, " generation="
    invoke-virtual { v4, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    iget-wide v8, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->generation:J
    invoke-virtual { v4, v8, v9 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v8, " source="
    invoke-virtual { v4, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    iget-object v8, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtcpSource:Ljava/lang/String;
    invoke-virtual { v4, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v8, " elapsedMs="
    invoke-virtual { v4, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    iget-wide v8, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtcpElapsedMs:J
    invoke-virtual { v4, v8, v9 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getLength()I
    move-result v8
    invoke-virtual { v4, v8 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    invoke-static { v0, v4 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L4
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getLength()I
    move-result v4
    invoke-virtual { p0, v2, v4 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->parseCompoundRtcp([BI)Z
    move-result v4
    if-eqz v4, :L5
    invoke-virtual { p0, v3 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->learnEndpoint(Ljava/net/DatagramPacket;)V
  :L5
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->maybeSendReceiverReport()V
  .line 334
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getLength()I
    move-result v4
    const/4 v8, 2
    if-lt v4, v8, :L6
    const/4 v4, 1
    aget-byte v4, v2, v4
    and-int/lit16 v4, v4, 255
    goto :L7
  :L6
    const/4 v4, -1
  :L7
  .line 335
    iget-wide v8, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpPackets:J
    const-wide/16 v10, 5
    cmp-long v10, v8, v10
    if-lez v10, :L8
    const-wide/16 v10, 100
    rem-long/2addr v8, v10
    cmp-long v6, v8, v6
    if-nez v6, :L9
  :L8
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct { v6 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "RTCP_RX callId="
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    iget v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v6
    const-string v7, " count="
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    iget-wide v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpPackets:J
    invoke-virtual { v6, v7, v8 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getLength()I
    move-result v6
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v6, " type="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    invoke-static { v0, v4 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L9
  .line 336
    goto/16 :L0
  :L10
    move-exception v1
    iget-object v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v2 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v2
    if-eqz v2, :L12
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "RTCP_FAIL callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v0, v2, v1 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    goto :L12
  :L11
    move-exception v4
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->maybeSendReceiverReport()V
    goto/16 :L0
  :L12
    return-void
.end method

.method receiveRtp()V
  .catch Ljava/net/SocketTimeoutException; { :L1 .. :L3 } :L5
  .catchall { :L1 .. :L3 } :L4
  .registers 9
  .line 328
    const-string v0, "AP_RTP_PLAYBACK"
    const/16 v1, 4096
    new-array v2, v1, [B
    new-instance v3, Ljava/net/DatagramPacket;
    invoke-direct { v3, v2, v1 }, Ljava/net/DatagramPacket;-><init>([BI)V
  :L0
    iget-object v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v4 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v4
    if-eqz v4, :L7
  :L1
  .line 329
    invoke-virtual { v3, v1 }, Ljava/net/DatagramPacket;->setLength(I)V
    iget-object v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocket:Ljava/net/DatagramSocket;
    invoke-virtual { v4, v3 }, Ljava/net/DatagramSocket;->receive(Ljava/net/DatagramPacket;)V
    iget-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpPackets:J
    const-wide/16 v6, 1
    add-long/2addr v4, v6
    iput-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpPackets:J
    iget-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpBytes:J
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getLength()I
    move-result v6
    int-to-long v6, v6
    add-long/2addr v4, v6
    iput-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpBytes:J
    iget-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtpElapsedMs:J
    const-wide/16 v6, 0
    cmp-long v4, v4, v6
    if-gez v4, :L2
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v4
    iget-wide v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->startElapsedMs:J
    sub-long/2addr v4, v6
    iput-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtpElapsedMs:J
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getAddress()Ljava/net/InetAddress;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;
    move-result-object v5
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v5, ":"
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getPort()I
    move-result v5
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    iput-object v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtpSource:Ljava/lang/String;
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "AP_MEDIA_LEDGER FIRST_RTP callId="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    iget v5, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v5, " generation="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    iget-wide v5, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->generation:J
    invoke-virtual { v4, v5, v6 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v5, " source="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    iget-object v5, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtpSource:Ljava/lang/String;
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v5, " elapsedMs="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    iget-wide v5, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtpElapsedMs:J
    invoke-virtual { v4, v5, v6 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v5, " bytes="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getLength()I
    move-result v5
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    invoke-static { v0, v4 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L2
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getLength()I
    move-result v4
    invoke-virtual { p0, v2, v4 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->capturePacket([BI)V
    invoke-virtual { v3 }, Ljava/net/DatagramPacket;->getLength()I
    move-result v4
    invoke-virtual { p0, v2, v4, v3 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->parseRtp([BILjava/net/DatagramPacket;)V
  :L3
    goto :L6
  :L4
  .line 330
    move-exception v1
    iget-object v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v2 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v2
    if-eqz v2, :L7
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "RTP_FAIL callId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v0, v2, v1 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    goto :L7
  :L5
    move-exception v4
  :L6
    goto/16 :L0
  :L7
    return-void
.end method

.method declared-synchronized refreshNegotiation(Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;)V
  .catchall { :L0 .. :L6 } :L11
  .catchall { :L6 .. :L7 } :L8
  .catchall { :L9 .. :L10 } :L8
  .catchall { :L10 .. :L11 } :L11
  .registers 5
    monitor-enter p0
  .line 273
    if-eqz p1, :L12
  :L0
    iget-object v0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->codec:Ljava/lang/String;
    if-eqz v0, :L12
    iget v0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->rxPt:I
    if-ltz v0, :L12
    iget v0, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->txPt:I
    if-gez v0, :L1
    goto :L12
  :L1
  .line 274
    invoke-virtual { p1 }, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->amrNb()Z
    move-result v0
  .line 275
    iget v1, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->rxPt:I
    iput v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
  .line 276
    iget v1, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->txPt:I
    iput v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->uplinkPt:I
  .line 277
    const-string v1, "early-media-refresh"
    iput-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->txPtSource:Ljava/lang/String;
  .line 278
    if-eqz v0, :L2
    const-string v1, "amr-nb"
    goto :L3
  :L2
    const-string v1, "amr-wb"
  :L3
  .line 279
    iget-boolean v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaResolved:Z
    if-eqz v2, :L4
    iget-object v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecProfile:Ljava/lang/String;
    invoke-virtual { v1, v2 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :L5
  :L4
  .line 280
    iget p1, p1, Lcom/sec/internal/google/ApMediaNegotiationPoc$Snapshot;->rxPt:I
    const/4 v1, 0
    invoke-virtual { p0, v0, p1, v1 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->commitProfile(ZIZ)V
  .line 281
    const/4 p1, 1
    iput-boolean p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaResolved:Z
  :L5
  .line 283
    iget-object p1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    monitor-enter p1
  :L6
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    invoke-virtual { v0 }, Ljava/lang/Object;->notifyAll()V
    monitor-exit p1
  :L7
  .line 284
    monitor-exit p0
    return-void
  :L8
  .line 283
    move-exception v0
  :L9
    monitor-exit p1
  :L10
    throw v0
  :L11
  .line 272
    move-exception p1
    monitor-exit p0
    throw p1
  :L12
  .line 273
    monitor-exit p0
    return-void
.end method

.method declared-synchronized releaseMedia()V
  .catchall { :L0 .. :L1 } :L17
  .catchall { :L2 .. :L3 } :L4
  .catchall { :L5 .. :L6 } :L7
  .catchall { :L8 .. :L9 } :L17
  .catchall { :L10 .. :L11 } :L12
  .catchall { :L13 .. :L14 } :L15
  .registers 4
    monitor-enter p0
  :L0
  .line 517
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->track:Landroid/media/AudioTrack;
    const/4 v1, 0
    iput-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->track:Landroid/media/AudioTrack;
  :L1
    if-eqz v0, :L8
  :L2
    invoke-virtual { v0 }, Landroid/media/AudioTrack;->pause()V
    invoke-virtual { v0 }, Landroid/media/AudioTrack;->flush()V
    invoke-virtual { v0 }, Landroid/media/AudioTrack;->stop()V
  :L3
    goto :L5
  :L4
    move-exception v2
  :L5
    invoke-virtual { v0 }, Landroid/media/AudioTrack;->release()V
  :L6
    goto :L8
  :L7
    move-exception v0
  :L8
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
    iput-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codec:Landroid/media/MediaCodec;
  :L9
    if-eqz v0, :L16
  :L10
    invoke-virtual { v0 }, Landroid/media/MediaCodec;->stop()V
  :L11
    goto :L13
  :L12
    move-exception v1
  :L13
    invoke-virtual { v0 }, Landroid/media/MediaCodec;->release()V
  :L14
    goto :L16
  :L15
    move-exception v0
  :L16
    monitor-exit p0
    return-void
  :L17
  .line 517
    move-exception v0
    monitor-exit p0
    throw v0
.end method

.method rrSenderSsrc()J
  .catchall { :L1 .. :L6 } :L7
  .registers 5
  .line 343
    const-string v0, "persist.vendor.ims.ap_rtcp_rr_ssrc"
    const-string v1, ""
    invoke-static { v0, v1 }, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/String;->isEmpty()Z
    move-result v1
    if-eqz v1, :L1
  :L0
    iget-wide v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->randomReceiverSsrc:J
    return-wide v0
  :L1
    const-string v1, "0x"
    invoke-virtual { v0, v1 }, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :L3
    const-string v1, "0X"
    invoke-virtual { v0, v1 }, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :L2
    goto :L3
  :L2
    invoke-static { v0 }, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v0
    goto :L4
  :L3
    const/4 v1, 2
    invoke-virtual { v0, v1 }, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v0
    const/16 v1, 16
    invoke-static { v0, v1 }, Ljava/lang/Long;->parseLong(Ljava/lang/String;I)J
    move-result-wide v0
  :L4
    const-wide/16 v2, 0
    cmp-long v2, v0, v2
    if-ltz v2, :L5
    const-wide v2, 4294967295L
    cmp-long v2, v0, v2
    if-gtz v2, :L5
    goto :L6
  :L5
    iget-wide v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->randomReceiverSsrc:J
  :L6
    return-wide v0
  :L7
    move-exception v0
    goto :L0
.end method

.method run()V
  .catchall { :L0 .. :L3 } :L13
  .catchall { :L4 .. :L7 } :L8
  .catchall { :L9 .. :L12 } :L13
  .catchall { :L14 .. :L15 } :L16
  .registers 11
  .line 313
    const-string v0, " pt="
    const-string v1, " networkBound="
    const-string v2, " network="
    const-string v3, " generation="
    const-string v4, "exit"
    const-string v5, "AP_RTP_PLAYBACK"
  :L0
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v6
    iput-wide v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->startElapsedMs:J
  .line 314
    iget v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpPort:I
    invoke-virtual { p0, v6 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->bind(I)Ljava/net/DatagramSocket;
    move-result-object v6
    iput-object v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocket:Ljava/net/DatagramSocket;
    iget v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpPort:I
    invoke-virtual { p0, v6 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->bind(I)Ljava/net/DatagramSocket;
    move-result-object v6
    iput-object v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocket:Ljava/net/DatagramSocket;
    iget-object v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocket:Ljava/net/DatagramSocket;
    iget-object v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocket:Ljava/net/DatagramSocket;
    invoke-virtual { p0, v6, v7 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->bindNetwork(Ljava/net/DatagramSocket;Ljava/net/DatagramSocket;)V
  .line 315
    iget-object v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocket:Ljava/net/DatagramSocket;
    invoke-virtual { v6 }, Ljava/net/DatagramSocket;->getLocalSocketAddress()Ljava/net/SocketAddress;
    move-result-object v6
    invoke-static { v6 }, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object v6
    iput-object v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocketAddress:Ljava/lang/String;
  .line 316
    iget-object v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocket:Ljava/net/DatagramSocket;
    invoke-virtual { v6 }, Ljava/net/DatagramSocket;->getLocalSocketAddress()Ljava/net/SocketAddress;
    move-result-object v6
    invoke-static { v6 }, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object v6
    iput-object v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocketAddress:Ljava/lang/String;
  .line 317
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct { v6 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "AP_MEDIA_LEDGER START callId="
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    iget v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    iget-wide v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->generation:J
    invoke-virtual { v6, v7, v8 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v6
    const-string v7, " rtpListen="
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    iget-object v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocketAddress:Ljava/lang/String;
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    const-string v7, " rtcpListen="
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    iget-object v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocketAddress:Ljava/lang/String;
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    iget-object v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->network:Landroid/net/Network;
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    iget-boolean v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->networkBound:Z
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    iget v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v6
    const-string v7, " codec="
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    iget-object v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecProfile:Ljava/lang/String;
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-static { v5, v6 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 318
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct { v6 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "START callId="
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    iget v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget-wide v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->generation:J
    invoke-virtual { v3, v6, v7 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v6, " rtp="
    invoke-virtual { v3, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpPort:I
    invoke-virtual { v3, v6 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v6, " rtcp="
    invoke-virtual { v3, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget v6, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpPort:I
    invoke-virtual { v3, v6 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedPt:I
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " codecProfile="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->codecProfile:Ljava/lang/String;
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " sampleRate="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->sampleRate:I
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " mode="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mode:Ljava/lang/String;
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " decode="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-boolean v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->decodeEnabled:Z
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " track="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-boolean v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->trackEnabled:Z
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " captureMax="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->captureMax:I
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->network:Landroid/net/Network;
    const/4 v3, 0
    const/4 v6, 1
    if-eqz v2, :L1
    move v2, v6
    goto :L2
  :L1
    move v2, v3
  :L2
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-boolean v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->networkBound:Z
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rr="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-boolean v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrEnabled:Z
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rrInterval="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrIntervalSec:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " txPtSource="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->txPtSource:Ljava/lang/String;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rtpSend=false rtcpFeedbackOnly=true"
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v5, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 319
    new-instance v0, Ljava/lang/Thread;
    new-instance v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe$$ExternalSyntheticLambda0;
    invoke-direct { v1, p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe$$ExternalSyntheticLambda0;-><init>(Lcom/sec/internal/google/ApRtpReceivePoc$Probe;)V
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "ap-media-ledger-"
    invoke-virtual { v2, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v7, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v2, v7 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-direct { v0, v1, v2 }, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaMilestoneThread:Ljava/lang/Thread;
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaMilestoneThread:Ljava/lang/Thread;
    invoke-virtual { v0, v6 }, Ljava/lang/Thread;->setDaemon(Z)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mediaMilestoneThread:Ljava/lang/Thread;
    invoke-virtual { v0 }, Ljava/lang/Thread;->start()V
  .line 320
    iget v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->captureMax:I
  :L3
    if-lez v0, :L10
  :L4
    new-instance v0, Ljava/io/File;
    const-string v1, "/data/vendor/ims"
    invoke-direct { v0, v1 }, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual { v0 }, Ljava/io/File;->exists()Z
    move-result v1
    if-nez v1, :L6
    invoke-virtual { v0 }, Ljava/io/File;->mkdirs()Z
    move-result v1
    if-eqz v1, :L5
    goto :L6
  :L5
    new-instance v1, Ljava/lang/IllegalStateException;
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "mkdir failed: "
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-direct { v1, v0 }, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V
    throw v1
  :L6
    new-instance v1, Ljava/io/BufferedOutputStream;
    new-instance v2, Ljava/io/FileOutputStream;
    new-instance v7, Ljava/io/File;
    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct { v8 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v9, "desem22_call_"
    invoke-virtual { v8, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v8
    iget v9, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v8, v9 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v8
    const-string v9, ".rtpdump"
    invoke-virtual { v8, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v8
    invoke-virtual { v8 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8
    invoke-direct { v7, v0, v8 }, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-direct { v2, v7, v3 }, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;Z)V
    invoke-direct { v1, v2 }, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;)V
    iput-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->capture:Ljava/io/BufferedOutputStream;
  :L7
    goto :L10
  :L8
    move-exception v0
  :L9
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "CAPTURE_DISABLED callId="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v5, v1, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    const/4 v0, 0
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->capture:Ljava/io/BufferedOutputStream;
  :L10
  .line 321
    new-instance v0, Ljava/lang/Thread;
    new-instance v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe$$ExternalSyntheticLambda1;
    invoke-direct { v1, p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe$$ExternalSyntheticLambda1;-><init>(Lcom/sec/internal/google/ApRtpReceivePoc$Probe;)V
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "ap-rtcp-rx-"
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-direct { v0, v1, v2 }, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpThread:Ljava/lang/Thread;
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpThread:Ljava/lang/Thread;
    invoke-virtual { v0, v6 }, Ljava/lang/Thread;->setDaemon(Z)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpThread:Ljava/lang/Thread;
    invoke-virtual { v0 }, Ljava/lang/Thread;->start()V
  .line 322
    iget-boolean v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->decodeEnabled:Z
    if-eqz v0, :L11
    new-instance v0, Ljava/lang/Thread;
    new-instance v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe$$ExternalSyntheticLambda2;
    invoke-direct { v1, p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe$$ExternalSyntheticLambda2;-><init>(Lcom/sec/internal/google/ApRtpReceivePoc$Probe;)V
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "ap-amrwb-dec-"
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-direct { v0, v1, v2 }, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->decodeThread:Ljava/lang/Thread;
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->decodeThread:Ljava/lang/Thread;
    invoke-virtual { v0, v6 }, Ljava/lang/Thread;->setDaemon(Z)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->decodeThread:Ljava/lang/Thread;
    invoke-virtual { v0 }, Ljava/lang/Thread;->start()V
  :L11
  .line 323
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->receiveRtp()V
  :L12
    goto :L15
  :L13
  .line 324
    move-exception v0
  :L14
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v1
    if-eqz v1, :L15
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "FAIL callId="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v5, v1, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L15
  .line 325
    invoke-virtual { p0, v4 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->cleanup(Ljava/lang/String;)V
  .line 326
    return-void
  :L16
  .line 325
    move-exception v0
    invoke-virtual { p0, v4 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->cleanup(Ljava/lang/String;)V
    throw v0
.end method

.method sendReceiverReport(Ljava/net/DatagramSocket;Ljava/net/InetAddress;I)V
  .catchall { :L0 .. :L2 } :L3
  .registers 20
  .line 346
    move-object/from16 v1, p0
    move/from16 v0, p3
    const-string v2, " count="
    const-string v3, "AP_RTP_PLAYBACK"
    const-wide/16 v4, 3
    const-wide/16 v6, 1
  :L0
    invoke-virtual/range { p0 .. p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrSenderSsrc()J
    move-result-wide v8
    invoke-virtual { v1, v8, v9 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->buildReceiverReportCompound(J)[B
    move-result-object v10
    new-instance v11, Ljava/net/DatagramPacket;
    array-length v12, v10
    move-object/from16 v13, p2
    invoke-direct { v11, v10, v12, v13, v0 }, Ljava/net/DatagramPacket;-><init>([BILjava/net/InetAddress;I)V
    move-object/from16 v12, p1
    invoke-virtual { v12, v11 }, Ljava/net/DatagramSocket;->send(Ljava/net/DatagramPacket;)V
    iget-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrSent:J
    add-long/2addr v11, v6
    iput-wide v11, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrSent:J
    cmp-long v14, v11, v4
    if-lez v14, :L1
    const-wide/16 v14, 12
    rem-long/2addr v11, v14
    const-wide/16 v14, 0
    cmp-long v11, v11, v14
    if-nez v11, :L4
  :L1
    new-instance v11, Ljava/lang/StringBuilder;
    invoke-direct { v11 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v12, "RTCP_RR_TX callId="
    invoke-virtual { v11, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v11
    iget v12, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v11, v12 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v11
    invoke-virtual { v11, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v11
    iget-wide v14, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrSent:J
    invoke-virtual { v11, v14, v15 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v11
    const-string v12, " bytes="
    invoke-virtual { v11, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v11
    array-length v10, v10
    invoke-virtual { v11, v10 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v10
    const-string v11, " rrSenderSsrc="
    invoke-virtual { v10, v11 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v10
    invoke-virtual { v10, v8, v9 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v8
    const-string v9, " remoteReportSsrc="
    invoke-virtual { v8, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v8
    iget-wide v9, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteSsrc:J
    invoke-virtual { v8, v9, v10 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v8
    const-string v9, " endpoint="
    invoke-virtual { v8, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v8
    invoke-virtual/range { p2 .. p2 }, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;
    move-result-object v9
    invoke-virtual { v8, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v8
    const-string v9, ":"
    invoke-virtual { v8, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v8
    invoke-virtual { v8, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v3, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L2
    goto :L4
  :L3
    move-exception v0
    iget-wide v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrErrors:J
    add-long/2addr v8, v6
    iput-wide v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrErrors:J
    cmp-long v4, v8, v4
    if-gtz v4, :L4
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "RTCP_RR_FAIL callId="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    iget v5, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget-wide v4, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrErrors:J
    invoke-virtual { v2, v4, v5 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v3, v1, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L4
    return-void
.end method

.method start()V
  .registers 5
  .line 308
    new-instance v0, Ljava/lang/Thread;
    new-instance v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe$$ExternalSyntheticLambda3;
    invoke-direct { v1, p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe$$ExternalSyntheticLambda3;-><init>(Lcom/sec/internal/google/ApRtpReceivePoc$Probe;)V
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "ap-rtp-rx-"
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-direct { v0, v1, v2 }, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mainThread:Ljava/lang/Thread;
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mainThread:Ljava/lang/Thread;
    const/4 v1, 1
    invoke-virtual { v0, v1 }, Ljava/lang/Thread;->setDaemon(Z)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mainThread:Ljava/lang/Thread;
    invoke-virtual { v0 }, Ljava/lang/Thread;->start()V
    return-void
.end method

.method stop(Ljava/lang/String;)V
  .registers 7
  .line 510
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v1, 0
    invoke-virtual { v0, v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->closeSockets()V
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->wakeQueue()V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->mainThread:Ljava/lang/Thread;
    const-wide/16 v1, 2000
    if-eqz v0, :L0
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v3
    if-eq v0, v3, :L0
    invoke-virtual { p0, v0, v1, v2 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->join(Ljava/lang/Thread;J)V
    invoke-virtual { v0 }, Ljava/lang/Thread;->isAlive()Z
    move-result v3
    if-eqz v3, :L0
    invoke-virtual { v0 }, Ljava/lang/Thread;->interrupt()V
    const-wide/16 v3, 1500
    invoke-virtual { p0, v0, v3, v4 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->join(Ljava/lang/Thread;J)V
  :L0
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v3
    if-ne v0, v3, :L2
  :L1
    invoke-virtual { p0, p1 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->cleanup(Ljava/lang/String;)V
    goto :L3
  :L2
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->cleanupComplete:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v0 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v0
    if-nez v0, :L3
    goto :L1
  :L3
    invoke-virtual { p0, v1, v2 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->awaitCleanup(J)V
    return-void
.end method

.method summary(Ljava/lang/String;)V
  .registers 10
  .line 519
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->summarized:Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v1, 0
    const/4 v2, 1
    invoke-virtual { v0, v1, v2 }, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z
    move-result v0
    if-eqz v0, :L3
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "AP_MEDIA_LEDGER STOP callId="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " generation="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->generation:J
    invoke-virtual { v0, v4, v5 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v4, " rtpSeen="
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtpElapsedMs:J
    const-wide/16 v6, 0
    cmp-long v4, v4, v6
    if-ltz v4, :L0
    move v4, v2
    goto :L1
  :L0
    move v4, v1
  :L1
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v4, " rtcpSeen="
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v4, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtcpElapsedMs:J
    cmp-long v4, v4, v6
    if-ltz v4, :L2
    move v1, v2
  :L2
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " firstRtpMs="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtpElapsedMs:J
    invoke-virtual { v0, v1, v2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " firstRtpSource="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtpSource:Ljava/lang/String;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " firstRtcpMs="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtcpElapsedMs:J
    invoke-virtual { v0, v1, v2 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " firstRtcpSource="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->firstRtcpSource:Ljava/lang/String;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rtpListen="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpSocketAddress:Ljava/lang/String;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rtcpListen="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpSocketAddress:Ljava/lang/String;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " network="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->network:Landroid/net/Network;
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " networkBound="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-boolean v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->networkBound:Z
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    const-string v1, "AP_RTP_PLAYBACK"
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "STOP callId="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->callId:I
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->generation:J
    invoke-virtual { v0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " reason="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " rtpPackets="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpPackets:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " rtpBytes="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtpBytes:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " rtcpPackets="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpPackets:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " rtcpBytes="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rtcpBytes:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " rrSent="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrSent:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " rrErrors="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->rrErrors:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " remoteSsrc="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteSsrc:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " jitter="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->jitterQ4:J
    const-wide/16 v4, 16
    div-long/2addr v2, v4
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " endpointChanges="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->endpointChanges:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " badRtp="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->badRtp:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " wrongPt="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->wrongPt:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " frames="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->frames:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " capturedBytes="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->capturedBytes:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " decodedBytes="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->decodedBytes:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " playedBytes="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->playedBytes:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " dropped="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->dropped:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " reordered="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->reordered:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " dlFt="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkFt:[J
    invoke-static { v0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->distribution([J)Ljava/lang/String;
    move-result-object v0
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " dlCmr="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkCmr:[J
    invoke-static { v0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->distribution([J)Ljava/lang/String;
    move-result-object v0
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " dlQ0="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkQ0:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " dlQ1="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkQ1:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " dlMarkers="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkMarkers:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " dlPayloadBytes="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkPayloadBytes:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " dlTimestampStep="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->downlinkTimestampStep:J
    invoke-virtual { p1, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { v1, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L3
    return-void
.end method

.method takeFrame()Lcom/sec/internal/google/ApRtpReceivePoc$Frame;
  .annotation system Ldalvik/annotation/Throws;
    value = {
      Ljava/lang/InterruptedException;
    }
  .end annotation
  .catchall { :L0 .. :L7 } :L6
  .registers 7
  .line 497
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    monitor-enter v0
  :L0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v1
    if-eqz v1, :L1
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    invoke-virtual { v1 }, Ljava/util/TreeMap;->size()I
    move-result v1
    const/4 v2, 3
    if-ge v1, v2, :L1
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    const-wide/16 v2, 200
    invoke-virtual { v1, v2, v3 }, Ljava/lang/Object;->wait(J)V
    goto :L0
  :L1
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    invoke-virtual { v1 }, Ljava/util/TreeMap;->isEmpty()Z
    move-result v1
    const/4 v2, 0
    if-eqz v1, :L2
    monitor-exit v0
    return-object v2
  :L2
  .line 498
    iget v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedSeq:I
    if-gez v1, :L3
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    invoke-virtual { v1 }, Ljava/util/TreeMap;->firstKey()Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Ljava/lang/Integer;
    invoke-virtual { v1 }, Ljava/lang/Integer;->intValue()I
    move-result v1
    iput v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedSeq:I
  :L3
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedSeq:I
    invoke-static { v3 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    invoke-virtual { v1, v3 }, Ljava/util/TreeMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Ljava/util/ArrayList;
  .line 499
    if-nez v1, :L5
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    const-wide/16 v3, 40
    invoke-virtual { v1, v3, v4 }, Ljava/lang/Object;->wait(J)V
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    iget v3, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedSeq:I
    invoke-static { v3 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    invoke-virtual { v1, v3 }, Ljava/util/TreeMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Ljava/util/ArrayList;
    if-nez v1, :L5
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->nearestAhead()I
    move-result v1
    if-gez v1, :L4
    monitor-exit v0
    return-object v2
  :L4
    iput v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedSeq:I
    iget-object v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queue:Ljava/util/TreeMap;
    invoke-static { v1 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    invoke-virtual { v2, v1 }, Ljava/util/TreeMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Ljava/util/ArrayList;
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->dropped:J
    const-wide/16 v4, 1
    add-long/2addr v2, v4
    iput-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->dropped:J
    iget-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->reordered:J
    add-long/2addr v2, v4
    iput-wide v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->reordered:J
  :L5
  .line 500
    iget v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedSeq:I
    add-int/lit8 v2, v2, 1
    const v3, 65535
    and-int/2addr v2, v3
    iput v2, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->expectedSeq:I
    const/4 v2, 0
    invoke-virtual { v1, v2 }, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Lcom/sec/internal/google/ApRtpReceivePoc$Frame;
    monitor-exit v0
    return-object v1
  :L6
  .line 501
    move-exception v1
    monitor-exit v0
  :L7
    throw v1
.end method

.method declared-synchronized updateReception(IJJ)V
  .catchall { :L0 .. :L3 } :L11
  .catchall { :L5 .. :L10 } :L11
  .registers 22
    move-object/from16 v1, p0
    move/from16 v0, p1
    move-wide/from16 v2, p4
    monitor-enter p0
  :L0
  .line 340
    iget-wide v4, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteSsrc:J
    const-wide/16 v6, 0
    cmp-long v6, v4, v6
    const/4 v7, 1
    const-wide/32 v8, 62500
    const-wide/16 v10, 1
    if-gez v6, :L4
    iput-wide v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->remoteSsrc:J
    int-to-long v2, v0
    iput-wide v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->baseExtSeq:J
    iput-wide v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->maxExtSeq:J
    iput-wide v10, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->received:J
    invoke-static { }, Ljava/lang/System;->nanoTime()J
    move-result-wide v2
    iget-boolean v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->amrNb:Z
    if-eqz v0, :L1
    const-wide/32 v8, 125000
  :L1
    div-long/2addr v2, v8
    sub-long v2, v2, p2
    iput-wide v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->previousTransit:J
  :L2
    iput-boolean v7, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->transitValid:Z
  :L3
    monitor-exit p0
    return-void
  :L4
    cmp-long v2, v4, v2
    if-eqz v2, :L5
    goto :L3
  :L5
    iget-wide v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->maxExtSeq:J
    const-wide/32 v4, -65536
    and-long/2addr v4, v2
    int-to-long v12, v0
    or-long/2addr v4, v12
    const-wide/32 v12, 32768
    add-long v14, v4, v12
    cmp-long v0, v14, v2
    const-wide/32 v14, 65536
    if-gez v0, :L6
    add-long/2addr v4, v14
    goto :L7
  :L6
    sub-long v12, v4, v12
    cmp-long v0, v12, v2
    if-lez v0, :L7
    sub-long/2addr v4, v14
  :L7
    cmp-long v0, v4, v2
    if-lez v0, :L8
    iput-wide v4, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->maxExtSeq:J
  :L8
    iget-wide v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->received:J
    add-long/2addr v2, v10
    iput-wide v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->received:J
    invoke-static { }, Ljava/lang/System;->nanoTime()J
    move-result-wide v2
    div-long/2addr v2, v8
    sub-long v2, v2, p2
    iget-boolean v0, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->transitValid:Z
    if-eqz v0, :L9
    iget-wide v4, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->previousTransit:J
    sub-long v4, v2, v4
    invoke-static { v4, v5 }, Ljava/lang/Math;->abs(J)J
    move-result-wide v4
    iget-wide v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->jitterQ4:J
    const-wide/16 v10, 16
    div-long v10, v8, v10
    sub-long/2addr v4, v10
    add-long/2addr v8, v4
    iput-wide v8, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->jitterQ4:J
  :L9
    iput-wide v2, v1, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->previousTransit:J
  :L10
    goto :L2
  :L11
  .line 340
    move-exception v0
    monitor-exit p0
    throw v0
.end method

.method validAmrAcquisitionPayload([BIIZ)Z
  .catchall { :L0 .. :L9 } :L13
  .registers 13
  .line 350
    const/4 v0, 0
  :L0
    new-instance v1, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;
    invoke-direct { v1, p1, p2, p3 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;-><init>([BII)V
  .line 351
    const/4 p1, 4
    invoke-virtual { v1, p1 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result p2
  .line 352
    const/4 v2, 1
    invoke-virtual { v1, v2 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result v3
  .line 353
    invoke-virtual { v1, p1 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result p1
  .line 354
    invoke-virtual { v1, v2 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result v4
  .line 355
    const/4 v5, 7
    const/16 v6, 8
    if-eqz p4, :L1
    move v7, v5
    goto :L2
  :L1
    move v7, v6
  :L2
  .line 356
    if-ltz p2, :L3
    if-le p2, v7, :L4
  :L3
    const/16 v7, 15
    if-ne p2, v7, :L12
  :L4
    if-nez v3, :L12
    if-ltz p1, :L12
    if-gt p1, v6, :L12
    if-eq v4, v2, :L5
    goto :L12
  :L5
  .line 358
    invoke-static { p1, p4 }, Lcom/sec/internal/google/ApRtpReceivePoc;->access$000(IZ)I
    move-result p1
  .line 359
    add-int/lit8 p2, p1, 10
    add-int/2addr p2, v5
    div-int/2addr p2, v6
  .line 360
    if-ne p3, p2, :L11
    invoke-virtual { v1 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->remaining()I
    move-result p2
    if-ge p2, p1, :L6
    goto :L11
  :L6
  .line 361
    move p2, v0
  :L7
    if-ge p2, p1, :L8
    invoke-virtual { v1, v2 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    add-int/lit8 p2, p2, 1
    goto :L7
  :L8
  .line 362
    invoke-virtual { v1 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->remaining()I
    move-result p1
    if-lez p1, :L10
    invoke-virtual { v1, v2 }, Lcom/sec/internal/google/ApRtpReceivePoc$BitReader;->read(I)I
    move-result p1
  :L9
    if-eqz p1, :L8
    return v0
  :L10
  .line 363
    return v2
  :L11
  .line 360
    return v0
  :L12
  .line 357
    return v0
  :L13
  .line 364
    move-exception p1
  .line 365
    return v0
.end method

.method wakeQueue()V
  .catchall { :L0 .. :L2 } :L1
  .registers 3
  .line 514
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    monitor-enter v0
  :L0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpReceivePoc$Probe;->queueLock:Ljava/lang/Object;
    invoke-virtual { v1 }, Ljava/lang/Object;->notifyAll()V
    monitor-exit v0
    return-void
  :L1
    move-exception v1
    monitor-exit v0
  :L2
    throw v1
.end method
