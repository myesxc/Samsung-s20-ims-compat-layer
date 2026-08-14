.class final Lcom/sec/internal/google/ApRtpUplinkPoc;
.super Ljava/lang/Object;
.source "ApRtpUplinkPoc.java"

.annotation system Ldalvik/annotation/MemberClasses;
  value = {
    Lcom/sec/internal/google/ApRtpUplinkPoc$MainRunner;,
    Lcom/sec/internal/google/ApRtpUplinkPoc$DtmfRunner;,
    Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;
  }
.end annotation

.field private final static TAG:Ljava/lang/String; = "AP_UPLINK_RTP"

.field private final address:Ljava/net/InetAddress;

.field private final amrNb:Z

.field private final bitRate:I

.field private bytes:J

.field private volatile codec:Landroid/media/MediaCodec;

.field private final codecMime:Ljava/lang/String;

.field private final dtmfClock:I

.field private dtmfErrors:J

.field private dtmfEvent:I

.field private final dtmfLock:Ljava/lang/Object;

.field private dtmfPackets:J

.field private final dtmfPt:I

.field private dtmfStop:Z

.field private volatile dtmfThread:Ljava/lang/Thread;

.field private encodedFrames:J

.field private errors:J

.field private final ftCounts:[J

.field private marker:Z

.field private packets:J

.field private pcmBytes:J

.field private final port:I

.field private final pt:I

.field private volatile pulseThread:Ljava/lang/Thread;

.field private volatile record:Landroid/media/AudioRecord;

.field private final running:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private final sampleRate:I

.field private final sendLock:Ljava/lang/Object;

.field private seq:I

.field private final socket:Ljava/net/DatagramSocket;

.field private final ssrc:J

.field private final stopStarted:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private volatile thread:Ljava/lang/Thread;

.field private timestamp:J

.field private final timestampStep:I

.method constructor <init>(Ljava/net/DatagramSocket;Ljava/net/InetAddress;IIJZ)V
  .registers 11
  .line 21
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
  .line 20
    const/16 v0, 16
    new-array v0, v0, [J
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->ftCounts:[J
    new-instance v0, Ljava/lang/Object;
    invoke-direct { v0 }, Ljava/lang/Object;-><init>()V
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->sendLock:Ljava/lang/Object;
    new-instance v0, Ljava/lang/Object;
    invoke-direct { v0 }, Ljava/lang/Object;-><init>()V
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v1, 1
    invoke-direct { v0, v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v2, 0
    invoke-direct { v0, v2 }, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->stopStarted:Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v0, -1
    iput v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfEvent:I
    iput-boolean v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->marker:Z
  .line 21
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->socket:Ljava/net/DatagramSocket;
    iput-object p2, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->address:Ljava/net/InetAddress;
    iput p3, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->port:I
    if-ltz p4, :L6
    const/16 p1, 127
    if-gt p4, p1, :L6
    iput p4, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->pt:I
    iput-wide p5, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->ssrc:J
    iput-boolean p7, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->amrNb:Z
    if-eqz p7, :L0
    const/16 p1, 8000
    goto :L1
  :L0
    const/16 p1, 16000
  :L1
    iput p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->sampleRate:I
    if-eqz p7, :L2
    const/16 p2, 160
    goto :L3
  :L2
    const/16 p2, 320
  :L3
    iput p2, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->timestampStep:I
    invoke-static { p7 }, Lcom/sec/internal/google/ApMediaConfigPoc;->uplinkBitrate(Z)I
    move-result p2
    iput p2, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->bitRate:I
    invoke-static { p7 }, Lcom/sec/internal/google/ApMediaConfigPoc;->dtmfPt(Z)I
    move-result p2
    iput p2, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfPt:I
    iput p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfClock:I
    if-eqz p7, :L4
    const-string p1, "audio/3gpp"
    goto :L5
  :L4
    const-string p1, "audio/amr-wb"
  :L5
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->codecMime:Ljava/lang/String;
    new-instance p1, Ljava/security/SecureRandom;
    invoke-direct { p1 }, Ljava/security/SecureRandom;-><init>()V
    invoke-virtual { p1 }, Ljava/security/SecureRandom;->nextInt()I
    move-result p2
    const p3, 65535
    and-int/2addr p2, p3
    iput p2, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->seq:I
    invoke-virtual { p1 }, Ljava/security/SecureRandom;->nextInt()I
    move-result p1
    int-to-long p1, p1
    const-wide p3, 4294967295L
    and-long/2addr p1, p3
    iput-wide p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->timestamp:J
    return-void
  :L6
    new-instance p1, Ljava/lang/IllegalArgumentException;
    new-instance p2, Ljava/lang/StringBuilder;
    invoke-direct { p2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p3, "uplink pt="
    invoke-virtual { p2, p3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, p4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    invoke-direct { p1, p2 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw p1
.end method

.method static synthetic access$000(Lcom/sec/internal/google/ApRtpUplinkPoc;)V
  .registers 1
  .line 18
    invoke-direct { p0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->run()V
    return-void
.end method

.method static synthetic access$100(Lcom/sec/internal/google/ApRtpUplinkPoc;I)V
  .registers 2
  .line 18
    invoke-direct { p0, p1 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->runDtmf(I)V
    return-void
.end method

.method static synthetic access$200(Lcom/sec/internal/google/ApRtpUplinkPoc;)Ljava/util/concurrent/atomic/AtomicBoolean;
  .registers 1
  .line 18
    iget-object p0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    return-object p0
.end method

.method static synthetic access$300(Lcom/sec/internal/google/ApRtpUplinkPoc;)Ljava/lang/Thread;
  .registers 1
  .line 18
    iget-object p0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->pulseThread:Ljava/lang/Thread;
    return-object p0
.end method

.method static synthetic access$302(Lcom/sec/internal/google/ApRtpUplinkPoc;Ljava/lang/Thread;)Ljava/lang/Thread;
  .registers 2
  .line 18
    iput-object p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->pulseThread:Ljava/lang/Thread;
    return-object p1
.end method

.method private static await(Ljava/lang/Thread;J)Z
  .catch Ljava/lang/InterruptedException; { :L0 .. :L1 } :L2
  .registers 5
  .line 25
    const/4 v0, 1
    if-eqz p0, :L4
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v1
    if-ne p0, v1, :L0
    goto :L4
  :L0
    invoke-virtual { p0, p1, p2 }, Ljava/lang/Thread;->join(J)V
  :L1
    goto :L3
  :L2
    move-exception p1
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/Thread;->interrupt()V
  :L3
    invoke-virtual { p0 }, Ljava/lang/Thread;->isAlive()Z
    move-result p0
    xor-int/2addr p0, v0
    return p0
  :L4
    return v0
.end method

.method private static bit([BI)I
  .registers 3
  .line 30
    shr-int/lit8 v0, p1, 3
    aget-byte p0, p0, v0
    and-int/lit8 p1, p1, 7
    rsub-int/lit8 p1, p1, 7
    shr-int/2addr p0, p1
    and-int/lit8 p0, p0, 1
    return p0
.end method

.method private bits(I)I
  .registers 5
  .line 29
    iget-boolean v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->amrNb:Z
    if-eqz v0, :L9
    packed-switch p1, :L20
    new-instance v0, Ljava/lang/IllegalArgumentException;
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "unsupported AMR-NB FT="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-direct { v0, p1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw v0
  :L0
    const/16 p1, 39
    return p1
  :L1
    const/16 p1, 244
    return p1
  :L2
    const/16 p1, 204
    return p1
  :L3
    const/16 p1, 159
    return p1
  :L4
    const/16 p1, 148
    return p1
  :L5
    const/16 p1, 134
    return p1
  :L6
    const/16 p1, 118
    return p1
  :L7
    const/16 p1, 103
    return p1
  :L8
    const/16 p1, 95
    return p1
  :L9
    packed-switch p1, :L21
    new-instance v0, Ljava/lang/IllegalArgumentException;
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "unsupported AMR-WB FT="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-direct { v0, p1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw v0
  :L10
    const/16 p1, 40
    return p1
  :L11
    const/16 p1, 477
    return p1
  :L12
    const/16 p1, 461
    return p1
  :L13
    const/16 p1, 397
    return p1
  :L14
    const/16 p1, 365
    return p1
  :L15
    const/16 p1, 317
    return p1
  :L16
    const/16 p1, 285
    return p1
  :L17
    const/16 p1, 253
    return p1
  :L18
    const/16 p1, 177
    return p1
  :L19
    const/16 p1, 132
    return p1
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

.method private static distribution([J)Ljava/lang/String;
  .registers 7
  .line 28
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

.method private drain(Landroid/media/MediaCodec$BufferInfo;)V
  .annotation system Ldalvik/annotation/Throws;
    value = {
      Ljava/lang/Exception;
    }
  .end annotation
  .registers 9
  :L0
  .line 44
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    iget-wide v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->packets:J
    const-wide/16 v3, 0
    cmp-long v1, v1, v3
    if-nez v1, :L1
    const-wide/16 v3, 10000
  :L1
    invoke-virtual { v0, p1, v3, v4 }, Landroid/media/MediaCodec;->dequeueOutputBuffer(Landroid/media/MediaCodec$BufferInfo;J)I
    move-result v0
    const/4 v1, -2
    if-ne v0, v1, :L2
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "FORMAT "
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v1 }, Landroid/media/MediaCodec;->getOutputFormat()Landroid/media/MediaFormat;
    move-result-object v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    const-string v1, "AP_UPLINK_RTP"
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    goto :L0
  :L2
    if-gez v0, :L3
    return-void
  :L3
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v1, v0 }, Landroid/media/MediaCodec;->getOutputBuffer(I)Ljava/nio/ByteBuffer;
    move-result-object v1
    const/4 v2, 0
    if-eqz v1, :L6
    iget v3, p1, Landroid/media/MediaCodec$BufferInfo;->size:I
    if-lez v3, :L6
    iget v3, p1, Landroid/media/MediaCodec$BufferInfo;->size:I
    new-array v4, v3, [B
    iget v5, p1, Landroid/media/MediaCodec$BufferInfo;->offset:I
    invoke-virtual { v1, v5 }, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;
    move-result-object v5
    check-cast v5, Ljava/nio/ByteBuffer;
    invoke-virtual { v1, v4 }, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;
    move v1, v2
  :L4
    if-ge v1, v3, :L6
    aget-byte v5, v4, v1
    shr-int/lit8 v5, v5, 3
    and-int/lit8 v5, v5, 15
    invoke-direct { p0, v5 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->bits(I)I
    move-result v5
    add-int/lit8 v5, v5, 7
    div-int/lit8 v5, v5, 8
    add-int/lit8 v5, v5, 1
    add-int v6, v1, v5
    if-gt v6, v3, :L5
    invoke-direct { p0, v4, v1, v5 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->sendFrame([BII)V
    move v1, v6
    goto :L4
  :L5
    new-instance p1, Ljava/lang/IllegalArgumentException;
    const-string v0, "concatenated frame short"
    invoke-direct { p1, v0 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw p1
  :L6
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v1, v0, v2 }, Landroid/media/MediaCodec;->releaseOutputBuffer(IZ)V
    goto :L0
.end method

.method private static put32([BIJ)V
  .registers 7
  .line 42
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

.method private run()V
  .catchall { :L0 .. :L1 } :L43
  .catchall { :L2 .. :L3 } :L42
  .catchall { :L4 .. :L5 } :L41
  .catchall { :L6 .. :L9 } :L39
  .catchall { :L10 .. :L20 } :L35
  .catchall { :L21 .. :L22 } :L23
  .catchall { :L24 .. :L25 } :L26
  .catchall { :L28 .. :L29 } :L30
  .catchall { :L31 .. :L32 } :L33
  .catchall { :L37 .. :L46 } :L46
  .catchall { :L48 .. :L49 } :L65
  .catchall { :L50 .. :L51 } :L52
  .catchall { :L53 .. :L54 } :L55
  .catchall { :L57 .. :L58 } :L59
  .catchall { :L60 .. :L61 } :L62
  .catchall { :L66 .. :L67 } :L68
  .catchall { :L69 .. :L70 } :L71
  .catchall { :L73 .. :L74 } :L75
  .catchall { :L76 .. :L77 } :L78
  .registers 39
  .line 45
    move-object/from16 v1, p0
    invoke-static { }, Lcom/sec/internal/google/ApMediaConfigPoc;->source()Ljava/lang/String;
    move-result-object v0
    invoke-static { v0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->source(Ljava/lang/String;)I
    move-result v3
    invoke-static { }, Lcom/sec/internal/google/ApMediaConfigPoc;->uplinkSeconds()I
    move-result v8
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v9
    const-string v11, " rtpSend=true"
    const-string v12, " dtmfErrors="
    const-string v13, " dtmfPackets="
    const-string v14, " ftDist="
    const-string v15, " encodedFrames="
    const-string v7, " pcmBytes="
    const-string v6, " errors="
    const-string v5, " bytes="
    const-string v4, "STOP packets="
    const-string v2, " bitRate="
    move-object/from16 v16, v6
    const-string v6, "AP_UPLINK_RTP"
    move-object/from16 v17, v6
    move-object/from16 v18, v5
    if-ltz v3, :L45
  :L0
    iget-object v5, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codecMime:Ljava/lang/String;
    iget v6, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->sampleRate:I
  :L1
    move-object/from16 v20, v11
    const/4 v11, 1
  :L2
    invoke-static { v5, v6, v11 }, Landroid/media/MediaFormat;->createAudioFormat(Ljava/lang/String;II)Landroid/media/MediaFormat;
    move-result-object v5
    const-string v6, "bitrate"
    iget v11, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->bitRate:I
    invoke-virtual { v5, v6, v11 }, Landroid/media/MediaFormat;->setInteger(Ljava/lang/String;I)V
    const-string v6, "priority"
    const/4 v11, 0
    invoke-virtual { v5, v6, v11 }, Landroid/media/MediaFormat;->setInteger(Ljava/lang/String;I)V
    iget-object v6, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codecMime:Ljava/lang/String;
    invoke-static { v6 }, Landroid/media/MediaCodec;->createEncoderByType(Ljava/lang/String;)Landroid/media/MediaCodec;
    move-result-object v6
    iput-object v6, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    iget-object v6, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
  :L3
    move-object/from16 v19, v7
    const/4 v7, 0
    const/4 v11, 1
  :L4
    invoke-virtual { v6, v5, v7, v7, v11 }, Landroid/media/MediaCodec;->configure(Landroid/media/MediaFormat;Landroid/view/Surface;Landroid/media/MediaCrypto;I)V
    iget-object v5, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v5 }, Landroid/media/MediaCodec;->start()V
    iget v5, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->sampleRate:I
    const/16 v6, 16
    const/4 v11, 2
    invoke-static { v5, v6, v11 }, Landroid/media/AudioRecord;->getMinBufferSize(III)I
    move-result v5
    if-lez v5, :L40
    const/16 v6, 6400
    mul-int/2addr v5, v11
    invoke-static { v6, v5 }, Ljava/lang/Math;->max(II)I
    move-result v11
    new-instance v6, Landroid/media/AudioRecord;
    iget v5, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->sampleRate:I
  :L5
    const/16 v21, 16
    const/16 v22, 2
    move-object/from16 v23, v12
    move-object v12, v2
    move-object v2, v6
    move-object/from16 v24, v4
    move v4, v5
    move-object/from16 v37, v13
    move-object v13, v7
    move-object/from16 v7, v18
    move-object/from16 v18, v37
    move/from16 v5, v21
    move-object v13, v6
    move-object/from16 v25, v16
    move-object/from16 v26, v17
    move/from16 v6, v22
    move-object/from16 v16, v14
    move-object/from16 v17, v15
    move-object/from16 v14, v19
    move-object v15, v7
    move v7, v11
  :L6
    invoke-direct/range { v2 .. v7 }, Landroid/media/AudioRecord;-><init>(IIIII)V
    iput-object v13, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    iget-object v2, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    invoke-virtual { v2 }, Landroid/media/AudioRecord;->getState()I
    move-result v2
    const/4 v3, 1
    if-ne v2, v3, :L36
    iget-object v2, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    invoke-virtual { v2 }, Landroid/media/AudioRecord;->startRecording()V
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "START source="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " seconds="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    if-lez v8, :L7
    invoke-static { v8 }, Ljava/lang/Integer;->toString(I)Ljava/lang/String;
    move-result-object v2
    goto :L8
  :L7
    const-string v2, "unbounded"
  :L8
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " codec="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v2, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v2 }, Landroid/media/MediaCodec;->getName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " codecMime="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v2, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codecMime:Ljava/lang/String;
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " sampleRate="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v2, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->sampleRate:I
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " timestampStep="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v2, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->timestampStep:I
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v2, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->bitRate:I
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " pt="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v2, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->pt:I
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " ssrc="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v2, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->ssrc:J
    invoke-virtual { v0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " endpoint="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v2, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->address:Ljava/net/InetAddress;
    invoke-virtual { v2 }, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;
    move-result-object v2
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, ":"
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v2, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->port:I
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " duplicateCpUplink=true rtpSend=true"
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
  :L9
    move-object/from16 v2, v26
  :L10
    invoke-static { v2, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    new-array v0, v11, [B
    new-instance v3, Landroid/media/MediaCodec$BufferInfo;
    invoke-direct { v3 }, Landroid/media/MediaCodec$BufferInfo;-><init>()V
  :L11
    iget-object v4, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v4 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v4
    if-eqz v4, :L20
    const-wide/16 v4, 1000
    if-lez v8, :L12
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v6
    sub-long/2addr v6, v9
    move-wide/from16 v26, v9
    int-to-long v9, v8
    mul-long/2addr v9, v4
    cmp-long v6, v6, v9
    if-gez v6, :L20
    goto :L13
  :L12
    move-wide/from16 v26, v9
  :L13
    const-string v6, "ap_uplink_rtp"
    const/4 v7, 1
    invoke-static { v6, v7 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result v6
    if-eqz v6, :L20
    iget-object v6, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    const/4 v9, 0
    invoke-virtual { v6, v0, v9, v11 }, Landroid/media/AudioRecord;->read([BII)I
    move-result v6
    if-ltz v6, :L19
    if-nez v6, :L15
  :L14
    move-wide/from16 v9, v26
    goto :L11
  :L15
    iget-wide v9, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->pcmBytes:J
    move v13, v8
    int-to-long v7, v6
    add-long/2addr v9, v7
    iput-wide v9, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->pcmBytes:J
    const/4 v7, 0
  :L16
    if-ge v7, v6, :L18
    iget-object v8, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    const-wide/16 v9, 10000
    invoke-virtual { v8, v9, v10 }, Landroid/media/MediaCodec;->dequeueInputBuffer(J)I
    move-result v8
    if-gez v8, :L17
    invoke-direct { v1, v3 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->drain(Landroid/media/MediaCodec$BufferInfo;)V
    goto :L16
  :L17
    iget-object v9, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    invoke-virtual { v9, v8 }, Landroid/media/MediaCodec;->getInputBuffer(I)Ljava/nio/ByteBuffer;
    move-result-object v9
    invoke-virtual { v9 }, Ljava/nio/ByteBuffer;->clear()Ljava/nio/Buffer;
    move-result-object v10
    check-cast v10, Ljava/nio/ByteBuffer;
    invoke-virtual { v9 }, Ljava/nio/ByteBuffer;->remaining()I
    move-result v10
    sub-int v4, v6, v7
    invoke-static { v10, v4 }, Ljava/lang/Math;->min(II)I
    move-result v4
    invoke-virtual { v9, v0, v7, v4 }, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;
    iget-object v5, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    const/16 v30, 0
    invoke-static { }, Ljava/lang/System;->nanoTime()J
    move-result-wide v9
    const-wide/16 v35, 1000
    div-long v32, v9, v35
    const/16 v34, 0
    move-object/from16 v28, v5
    move/from16 v29, v8
    move/from16 v31, v4
    invoke-virtual/range { v28 .. v34 }, Landroid/media/MediaCodec;->queueInputBuffer(IIIJI)V
    add-int/2addr v7, v4
    invoke-direct { v1, v3 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->drain(Landroid/media/MediaCodec$BufferInfo;)V
    move-wide/from16 v4, v35
    goto :L16
  :L18
    move v8, v13
    goto :L14
  :L19
    new-instance v0, Ljava/lang/IllegalStateException;
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "read="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v6 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-direct { v0, v3 }, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V
    throw v0
  :L20
    iget-object v0, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v3, 0
    invoke-virtual { v0, v3 }, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V
    iget-object v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    const/4 v4, 0
    iput-object v4, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    if-eqz v3, :L27
  :L21
    invoke-virtual { v3 }, Landroid/media/AudioRecord;->stop()V
  :L22
    goto :L24
  :L23
    move-exception v0
  :L24
    invoke-virtual { v3 }, Landroid/media/AudioRecord;->release()V
  :L25
    goto :L27
  :L26
    move-exception v0
  :L27
    iget-object v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    const/4 v4, 0
    iput-object v4, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    if-eqz v3, :L34
  :L28
    invoke-virtual { v3 }, Landroid/media/MediaCodec;->stop()V
  :L29
    goto :L31
  :L30
    move-exception v0
  :L31
    invoke-virtual { v3 }, Landroid/media/MediaCodec;->release()V
  :L32
    goto :L34
  :L33
    move-exception v0
  :L34
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    move-object/from16 v3, v24
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->packets:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v15 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->bytes:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v4, v25
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->errors:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v14 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->pcmBytes:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v6, v17
    invoke-virtual { v0, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->encodedFrames:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->bitRate:I
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v7, v16
    invoke-virtual { v0, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->ftCounts:[J
    invoke-static { v3 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->distribution([J)Ljava/lang/String;
    move-result-object v3
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v8, v18
    invoke-virtual { v0, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfPackets:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v9, v23
    invoke-virtual { v0, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfErrors:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v10, v20
    invoke-virtual { v0, v10 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    goto/16 :L64
  :L35
    move-exception v0
    move-object/from16 v7, v16
    move-object/from16 v6, v17
    move-object/from16 v8, v18
    move-object/from16 v10, v20
    move-object/from16 v9, v23
    move-object/from16 v3, v24
    move-object/from16 v4, v25
    goto/16 :L47
  :L36
    move-object/from16 v7, v16
    move-object/from16 v6, v17
    move-object/from16 v8, v18
    move-object/from16 v10, v20
    move-object/from16 v9, v23
    move-object/from16 v3, v24
    move-object/from16 v4, v25
    move-object/from16 v2, v26
  :L37
    new-instance v0, Ljava/lang/IllegalStateException;
    const-string v5, "uninitialized"
    invoke-direct { v0, v5 }, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V
  :L38
    throw v0
  :L39
    move-exception v0
    move-object/from16 v7, v16
    move-object/from16 v6, v17
    move-object/from16 v8, v18
    move-object/from16 v10, v20
    move-object/from16 v9, v23
    move-object/from16 v3, v24
    move-object/from16 v4, v25
    move-object/from16 v2, v26
    goto/16 :L47
  :L40
    move-object v3, v4
    move-object v9, v12
    move-object v8, v13
    move-object v7, v14
    move-object v6, v15
    move-object/from16 v4, v16
    move-object/from16 v15, v18
    move-object/from16 v14, v19
    move-object/from16 v10, v20
    move-object v12, v2
    move-object/from16 v2, v17
    new-instance v0, Ljava/lang/IllegalStateException;
    new-instance v11, Ljava/lang/StringBuilder;
    invoke-direct { v11 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v13, "minBuffer="
    invoke-virtual { v11, v13 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v11
    invoke-virtual { v11, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-direct { v0, v5 }, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V
    goto :L38
  :L41
    move-exception v0
    move-object v3, v4
    move-object v9, v12
    move-object v8, v13
    move-object v7, v14
    move-object v6, v15
    move-object/from16 v4, v16
    move-object/from16 v15, v18
    move-object/from16 v14, v19
    move-object/from16 v10, v20
    move-object v12, v2
    move-object/from16 v2, v17
    goto/16 :L47
  :L42
    move-exception v0
    move-object v3, v4
    move-object v9, v12
    move-object v8, v13
    move-object v6, v15
    move-object/from16 v4, v16
    move-object/from16 v15, v18
    move-object/from16 v10, v20
    goto :L44
  :L43
    move-exception v0
    move-object v3, v4
    move-object v10, v11
    move-object v9, v12
    move-object v8, v13
    move-object v6, v15
    move-object/from16 v4, v16
    move-object/from16 v15, v18
  :L44
    move-object v12, v2
    move-object/from16 v2, v17
    move-object/from16 v37, v14
    move-object v14, v7
    move-object/from16 v7, v37
    goto :L47
  :L45
    move-object v3, v4
    move-object v10, v11
    move-object v9, v12
    move-object v8, v13
    move-object v6, v15
    move-object/from16 v4, v16
    move-object/from16 v15, v18
    move-object v12, v2
    move-object/from16 v2, v17
    move-object/from16 v37, v14
    move-object v14, v7
    move-object/from16 v7, v37
    new-instance v5, Ljava/lang/IllegalArgumentException;
    new-instance v11, Ljava/lang/StringBuilder;
    invoke-direct { v11 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v13, "source="
    invoke-virtual { v11, v13 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v11
    invoke-virtual { v11, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-direct { v5, v0 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw v5
  :L46
    move-exception v0
  :L47
    move-object/from16 v20, v10
  :L48
    iget-wide v10, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->errors:J
    const-wide/16 v16, 1
    add-long v10, v10, v16
    iput-wide v10, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->errors:J
    const-string v5, "FAIL"
    invoke-static { v2, v5, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L49
    iget-object v0, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v5, 0
    invoke-virtual { v0, v5 }, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V
    iget-object v5, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    const/4 v10, 0
    iput-object v10, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    if-eqz v5, :L56
  :L50
    invoke-virtual { v5 }, Landroid/media/AudioRecord;->stop()V
  :L51
    goto :L53
  :L52
    move-exception v0
  :L53
    invoke-virtual { v5 }, Landroid/media/AudioRecord;->release()V
  :L54
    goto :L56
  :L55
    move-exception v0
  :L56
    iget-object v5, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    const/4 v10, 0
    iput-object v10, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    if-eqz v5, :L63
  :L57
    invoke-virtual { v5 }, Landroid/media/MediaCodec;->stop()V
  :L58
    goto :L60
  :L59
    move-exception v0
  :L60
    invoke-virtual { v5 }, Landroid/media/MediaCodec;->release()V
  :L61
    goto :L63
  :L62
    move-exception v0
  :L63
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v10, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->packets:J
    invoke-virtual { v0, v10, v11 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v15 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v10, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->bytes:J
    invoke-virtual { v0, v10, v11 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->errors:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v14 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->pcmBytes:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->encodedFrames:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->bitRate:I
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->ftCounts:[J
    invoke-static { v3 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->distribution([J)Ljava/lang/String;
    move-result-object v3
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfPackets:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v3, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfErrors:J
    invoke-virtual { v0, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v5, v20
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  :L64
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v2, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return-void
  :L65
    move-exception v0
    move-object/from16 v5, v20
    move-object v10, v0
    iget-object v0, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v11, 0
    invoke-virtual { v0, v11 }, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V
    iget-object v11, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    const/4 v13, 0
    iput-object v13, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    if-eqz v11, :L72
  :L66
    invoke-virtual { v11 }, Landroid/media/AudioRecord;->stop()V
  :L67
    goto :L69
  :L68
    move-exception v0
  :L69
    invoke-virtual { v11 }, Landroid/media/AudioRecord;->release()V
  :L70
    goto :L72
  :L71
    move-exception v0
  :L72
    iget-object v11, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    const/4 v13, 0
    iput-object v13, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    if-eqz v11, :L79
  :L73
    invoke-virtual { v11 }, Landroid/media/MediaCodec;->stop()V
  :L74
    goto :L76
  :L75
    move-exception v0
  :L76
    invoke-virtual { v11 }, Landroid/media/MediaCodec;->release()V
  :L77
    goto :L79
  :L78
    move-exception v0
  :L79
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object v3, v10
    iget-wide v10, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->packets:J
    invoke-virtual { v0, v10, v11 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v15 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v10, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->bytes:J
    invoke-virtual { v0, v10, v11 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v10, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->errors:J
    invoke-virtual { v0, v10, v11 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v14 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v10, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->pcmBytes:J
    invoke-virtual { v0, v10, v11 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v10, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->encodedFrames:J
    invoke-virtual { v0, v10, v11 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v4, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->bitRate:I
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v4, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->ftCounts:[J
    invoke-static { v4 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->distribution([J)Ljava/lang/String;
    move-result-object v4
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v6, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfPackets:J
    invoke-virtual { v0, v6, v7 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v6, v1, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfErrors:J
    invoke-virtual { v0, v6, v7 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v2, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    throw v3
.end method

.method private runDtmf(I)V
  .catchall { :L0 .. :L1 } :L36
  .catchall { :L2 .. :L3 } :L23
  .catchall { :L4 .. :L5 } :L12
  .catchall { :L6 .. :L7 } :L21
  .catchall { :L7 .. :L11 } :L10
  .catchall { :L11 .. :L17 } :L21
  .catchall { :L18 .. :L20 } :L19
  .catchall { :L24 .. :L25 } :L30
  .catchall { :L26 .. :L29 } :L28
  .catchall { :L31 .. :L32 } :L33
  .catchall { :L34 .. :L35 } :L33
  .catchall { :L37 .. :L38 } :L36
  .registers 25
  .line 38
    move-object/from16 v9, p0
    move/from16 v10, p1
    iget v0, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfPt:I
    iget v11, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfClock:I
    div-int/lit16 v12, v11, 1000
    div-int/lit8 v13, v11, 50
    mul-int/lit16 v1, v11, 160
    div-int/lit16 v14, v1, 1000
    iget-object v1, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->sendLock:Ljava/lang/Object;
    monitor-enter v1
  :L0
    iget-wide v7, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->timestamp:J
    monitor-exit v1
  :L1
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v15
    const-string v1, "AP_DTMF_RTP"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "START event="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v10 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " pt="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " clock="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v11 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " voicePt="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->pt:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " ssrc="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget-wide v3, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->ssrc:J
    invoke-virtual { v2, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " timestamp="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v7, v8 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " endpoint="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget-object v3, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->address:Ljava/net/InetAddress;
    invoke-virtual { v3 }, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;
    move-result-object v3
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, ":"
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->port:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v1, v2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    const/4 v1, 1
    move/from16 v17, v1
  :L2
    iget-object v1, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v1
  :L3
    const-wide/32 v2, 65535
    if-eqz v1, :L13
  :L4
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v18
    sub-long v18, v18, v15
    int-to-long v4, v13
    move-wide/from16 v21, v7
    int-to-long v6, v12
    mul-long v6, v6, v18
    invoke-static { v4, v5, v6, v7 }, Ljava/lang/Math;->max(JJ)J
    move-result-wide v4
    invoke-static { v2, v3, v4, v5 }, Ljava/lang/Math;->min(JJ)J
    move-result-wide v4
  :L5
    long-to-int v6, v4
    const/4 v7, 0
    move-object/from16 v1, p0
    move-wide v4, v2
    move v2, v0
    move/from16 v3, p1
    move-wide/from16 v4, v21
    const/4 v8, 0
    move-wide/from16 v20, v21
    move/from16 v22, v13
    move v13, v8
    move/from16 v8, v17
  :L6
    invoke-direct/range { v1 .. v8 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->sendDtmfPacket(IIJIZZ)V
    iget-object v1, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    monitor-enter v1
  :L7
    iget-boolean v2, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfStop:Z
    if-eqz v2, :L8
    const-wide/16 v2, 160
    cmp-long v2, v18, v2
    if-ltz v2, :L8
    monitor-exit v1
    goto :L14
  :L8
    iget-object v2, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    const-wide/16 v3, 50
    invoke-virtual { v2, v3, v4 }, Ljava/lang/Object;->wait(J)V
    monitor-exit v1
    const-wide/16 v1, 5000
    cmp-long v1, v18, v1
    if-ltz v1, :L9
    goto :L14
  :L9
    move/from16 v17, v13
    move-wide/from16 v7, v20
    move/from16 v13, v22
    goto :L2
  :L10
    move-exception v0
    monitor-exit v1
  :L11
    throw v0
  :L12
    move-exception v0
    const/4 v13, 0
    goto/16 :L22
  :L13
    move-wide/from16 v20, v7
    const/4 v13, 0
  :L14
    int-to-long v1, v14
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v3
    sub-long/2addr v3, v15
    int-to-long v5, v12
    mul-long/2addr v3, v5
    invoke-static { v1, v2, v3, v4 }, Ljava/lang/Math;->max(JJ)J
    move-result-wide v1
    const-wide/32 v3, 65535
    invoke-static { v3, v4, v1, v2 }, Ljava/lang/Math;->min(JJ)J
    move-result-wide v1
    long-to-int v12, v1
    move v14, v13
  :L15
    const/4 v1, 3
    if-ge v14, v1, :L16
    const/4 v7, 1
    const/4 v8, 0
    move-object/from16 v1, p0
    move v2, v0
    move/from16 v3, p1
    move-wide/from16 v4, v20
    move v6, v12
    invoke-direct/range { v1 .. v8 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->sendDtmfPacket(IIJIZZ)V
    add-int/lit8 v14, v14, 1
    goto :L15
  :L16
    const-string v1, "AP_DTMF_RTP"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "END event="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v10 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " pt="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " clock="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v11 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " duration="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v12 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " packets="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-wide v2, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfPackets:J
    invoke-virtual { v0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " endRepeats=3"
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L17
    iget-object v1, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    monitor-enter v1
    const/4 v2, -1
  :L18
    iput v2, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfEvent:I
    iput-boolean v13, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfStop:Z
    monitor-exit v1
    goto :L27
  :L19
    move-exception v0
    monitor-exit v1
  :L20
    throw v0
  :L21
    move-exception v0
  :L22
    const/4 v2, -1
    goto :L24
  :L23
    move-exception v0
    const/4 v2, -1
    const/4 v13, 0
  :L24
    iget-wide v3, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfErrors:J
    const-wide/16 v5, 1
    add-long/2addr v3, v5
    iput-wide v3, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfErrors:J
    const-string v1, "AP_DTMF_RTP"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "FAIL event="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, v10 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static { v1, v3, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L25
    iget-object v1, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    monitor-enter v1
  :L26
    iput v2, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfEvent:I
    iput-boolean v13, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfStop:Z
    monitor-exit v1
  :L27
    return-void
  :L28
    move-exception v0
    monitor-exit v1
  :L29
    throw v0
  :L30
    move-exception v0
    iget-object v3, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    monitor-enter v3
  :L31
    iput v2, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfEvent:I
    iput-boolean v13, v9, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfStop:Z
    monitor-exit v3
  :L32
    throw v0
  :L33
    move-exception v0
  :L34
    monitor-exit v3
  :L35
    throw v0
  :L36
    move-exception v0
  :L37
    monitor-exit v1
  :L38
    throw v0
.end method

.method private sendDtmfPacket(IIJIZZ)V
  .annotation system Ldalvik/annotation/Throws;
    value = {
      Ljava/lang/Exception;
    }
  .end annotation
  .catchall { :L3 .. :L4 } :L7
  .catchall { :L8 .. :L9 } :L7
  .registers 25
  .line 40
    move-object/from16 v0, p0
    move/from16 v1, p1
    move/from16 v2, p2
    move-wide/from16 v3, p3
    move/from16 v5, p5
    move/from16 v6, p6
    move/from16 v7, p7
    const/16 v8, 16
    new-array v9, v8, [B
    const/16 v10, -128
    const/4 v11, 0
    aput-byte v10, v9, v11
    const/16 v10, 128
    if-eqz v7, :L0
    move v12, v10
    goto :L1
  :L0
    move v12, v11
  :L1
    or-int/2addr v12, v1
    int-to-byte v12, v12
    const/4 v13, 1
    aput-byte v12, v9, v13
    const/4 v12, 4
    const/16 v14, 24
    ushr-long v14, v3, v14
    long-to-int v14, v14
    int-to-byte v14, v14
    aput-byte v14, v9, v12
    const/4 v12, 5
    ushr-long v14, v3, v8
    long-to-int v8, v14
    int-to-byte v8, v8
    aput-byte v8, v9, v12
    const/4 v8, 6
    const/16 v12, 8
    ushr-long v14, v3, v12
    long-to-int v14, v14
    int-to-byte v14, v14
    aput-byte v14, v9, v8
    const/4 v8, 7
    long-to-int v14, v3
    int-to-byte v14, v14
    aput-byte v14, v9, v8
    iget-wide v14, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->ssrc:J
    invoke-static { v9, v12, v14, v15 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->put32([BIJ)V
    const/16 v8, 12
    int-to-byte v14, v2
    aput-byte v14, v9, v8
    const/16 v8, 13
    if-eqz v6, :L2
    move v11, v10
  :L2
    or-int/lit8 v10, v11, 10
    int-to-byte v10, v10
    aput-byte v10, v9, v8
    const/16 v8, 14
    ushr-int/lit8 v10, v5, 8
    int-to-byte v10, v10
    aput-byte v10, v9, v8
    const/16 v8, 15
    int-to-byte v10, v5
    aput-byte v10, v9, v8
    iget-object v8, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->sendLock:Ljava/lang/Object;
    monitor-enter v8
  :L3
    iget v10, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->seq:I
    ushr-int/lit8 v11, v10, 8
    int-to-byte v11, v11
    const/4 v14, 2
    aput-byte v11, v9, v14
    int-to-byte v10, v10
    const/4 v11, 3
    aput-byte v10, v9, v11
    invoke-direct { v0, v9 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->sendPacketRaw([B)V
    iget v10, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->seq:I
    add-int/2addr v10, v13
    const v13, 65535
    and-int/2addr v10, v13
    iput v10, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->seq:I
    monitor-exit v8
  :L4
    iget-wide v11, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfPackets:J
    const-wide/16 v15, 1
    add-long/2addr v11, v15
    iput-wide v11, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfPackets:J
    const-wide/16 v15, 5
    cmp-long v0, v11, v15
    if-lez v0, :L5
    if-eqz v6, :L6
  :L5
    const-string v0, "AP_DTMF_RTP"
    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct { v8 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v11, "TX event="
    invoke-virtual { v8, v11 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v8
    invoke-virtual { v8, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v8, " pt="
    invoke-virtual { v2, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " seq="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    aget-byte v2, v9, v14
    and-int/lit16 v2, v2, 255
    const/16 v8, 8
    shl-int/2addr v2, v8
    const/4 v8, 3
    aget-byte v8, v9, v8
    and-int/lit16 v8, v8, 255
    or-int/2addr v2, v8
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " timestamp="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " duration="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " end="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v6 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " marker="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v7 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v0, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L6
    return-void
  :L7
    move-exception v0
  :L8
    monitor-exit v8
  :L9
    throw v0
.end method

.method private sendFrame([BII)V
  .annotation system Ldalvik/annotation/Throws;
    value = {
      Ljava/lang/Exception;
    }
  .end annotation
  .catchall { :L0 .. :L1 } :L4
  .catchall { :L5 .. :L6 } :L4
  .registers 23
  .line 43
    move-object/from16 v0, p0
    aget-byte v1, p1, p2
    shr-int/lit8 v1, v1, 3
    and-int/lit8 v12, v1, 15
    invoke-direct { v0, v12 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->bits(I)I
    move-result v1
    add-int/lit8 v1, v1, 7
    div-int/lit8 v1, v1, 8
    add-int/lit8 v4, v1, 1
    move/from16 v1, p3
    if-lt v1, v4, :L7
    iget-object v13, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->sendLock:Ljava/lang/Object;
    monitor-enter v13
  :L0
    iget v14, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->seq:I
    iget-wide v10, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->timestamp:J
    iget v5, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->pt:I
    iget-boolean v6, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->marker:Z
    iget-wide v8, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->ssrc:J
    move-object/from16 v1, p0
    move-object/from16 v2, p1
    move/from16 v3, p2
    move v7, v14
    move-wide v15, v8
    move-wide v8, v10
    move-wide/from16 v17, v10
    move-wide v10, v15
    invoke-virtual/range { v1 .. v11 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->packet([BIIIZIJJ)[B
    move-result-object v1
    invoke-direct { v0, v1 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->sendPacketRaw([B)V
    const/4 v2, 0
    iput-boolean v2, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->marker:Z
    iget v2, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->seq:I
    add-int/lit8 v2, v2, 1
    const v3, 65535
    and-int/2addr v2, v3
    iput v2, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->seq:I
    iget-wide v2, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->timestamp:J
    iget v4, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->timestampStep:I
    int-to-long v4, v4
    add-long/2addr v2, v4
    const-wide v4, 4294967295L
    and-long/2addr v2, v4
    iput-wide v2, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->timestamp:J
    monitor-exit v13
  :L1
    iget-wide v2, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->packets:J
    const-wide/16 v4, 1
    add-long/2addr v2, v4
    iput-wide v2, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->packets:J
    iget-wide v6, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->bytes:J
    array-length v8, v1
    int-to-long v8, v8
    add-long/2addr v6, v8
    iput-wide v6, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->bytes:J
    iget-wide v6, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->encodedFrames:J
    add-long/2addr v6, v4
    iput-wide v6, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->encodedFrames:J
    iget-object v6, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->ftCounts:[J
    aget-wide v7, v6, v12
    add-long/2addr v7, v4
    aput-wide v7, v6, v12
    const-wide/16 v4, 3
    cmp-long v4, v2, v4
    if-lez v4, :L2
    const-wide/16 v4, 100
    rem-long/2addr v2, v4
    const-wide/16 v4, 0
    cmp-long v2, v2, v4
    if-nez v2, :L3
  :L2
    const-string v2, "AP_UPLINK_RTP"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "TX count="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget-wide v4, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->packets:J
    invoke-virtual { v3, v4, v5 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " bytes="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    array-length v1, v1
    invoke-virtual { v3, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, " ft="
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v12 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, " seq="
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v14 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, " ts="
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    move-wide/from16 v3, v17
    invoke-virtual { v1, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, " ssrc="
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget-wide v3, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->ssrc:J
    invoke-virtual { v1, v3, v4 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, " endpoint="
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget-object v3, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->address:Ljava/net/InetAddress;
    invoke-virtual { v3 }, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;
    move-result-object v3
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v3, ":"
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v0, v0, Lcom/sec/internal/google/ApRtpUplinkPoc;->port:I
    invoke-virtual { v1, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v2, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L3
    return-void
  :L4
    move-exception v0
  :L5
    monitor-exit v13
  :L6
    throw v0
  :L7
    new-instance v0, Ljava/lang/IllegalArgumentException;
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "encoder short FT="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v12 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-direct { v0, v1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw v0
.end method

.method private sendPacketRaw([B)V
  .annotation system Ldalvik/annotation/Throws;
    value = {
      Ljava/lang/Exception;
    }
  .end annotation
  .registers 7
  .line 39
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->socket:Ljava/net/DatagramSocket;
    new-instance v1, Ljava/net/DatagramPacket;
    array-length v2, p1
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->address:Ljava/net/InetAddress;
    iget v4, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->port:I
    invoke-direct { v1, p1, v2, v3, v4 }, Ljava/net/DatagramPacket;-><init>([BILjava/net/InetAddress;I)V
    invoke-virtual { v0, v1 }, Ljava/net/DatagramSocket;->send(Ljava/net/DatagramPacket;)V
    return-void
.end method

.method private static setBit([BII)V
  .registers 5
  .line 31
    if-eqz p2, :L0
    shr-int/lit8 p2, p1, 3
    aget-byte v0, p0, p2
    const/16 v1, 128
    and-int/lit8 p1, p1, 7
    shr-int p1, v1, p1
    int-to-byte p1, p1
    or-int/2addr p1, v0
    int-to-byte p1, p1
    aput-byte p1, p0, p2
  :L0
    return-void
.end method

.method private static source(Ljava/lang/String;)I
  .registers 2
  .line 26
    const-string v0, "mic"
    invoke-virtual { v0, p0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :L0
    const/4 p0, 1
    return p0
  :L0
    const-string v0, "voice_communication"
    invoke-virtual { v0, p0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :L1
    const/4 p0, 7
    return p0
  :L1
    const-string v0, "voice_uplink"
    invoke-virtual { v0, p0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result p0
    if-eqz p0, :L2
    const/4 p0, 2
    return p0
  :L2
    const/4 p0, -1
    return p0
.end method

.method private static validNbBitrate(I)Z
  .registers 2
  .line 27
    const/16 v0, 4750
    if-eq p0, v0, :L1
    const/16 v0, 5150
    if-eq p0, v0, :L1
    const/16 v0, 5900
    if-eq p0, v0, :L1
    const/16 v0, 6700
    if-eq p0, v0, :L1
    const/16 v0, 7400
    if-eq p0, v0, :L1
    const/16 v0, 7950
    if-eq p0, v0, :L1
    const/16 v0, 10200
    if-eq p0, v0, :L1
    const/16 v0, 12200
    if-ne p0, v0, :L0
    goto :L1
  :L0
    const/4 p0, 0
    goto :L2
  :L1
    const/4 p0, 1
  :L2
    return p0
.end method

.method isVoiceActive()Z
  .registers 3
  .line 32
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->thread:Ljava/lang/Thread;
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v1
    if-eqz v1, :L0
    if-eqz v0, :L0
    invoke-virtual { v0 }, Ljava/lang/Thread;->isAlive()Z
    move-result v0
    if-eqz v0, :L0
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->socket:Ljava/net/DatagramSocket;
    if-eqz v0, :L0
    invoke-virtual { v0 }, Ljava/net/DatagramSocket;->isClosed()Z
    move-result v0
    if-nez v0, :L0
    const/4 v0, 1
    goto :L1
  :L0
    const/4 v0, 0
  :L1
    return v0
.end method

.method packet([BIIIZIJJ)[B
  .registers 24
  .line 41
    move-object v0, p1
    move/from16 v1, p3
    move/from16 v2, p6
    const/4 v3, 2
    if-lt v1, v3, :L7
    aget-byte v4, v0, p2
    shr-int/lit8 v5, v4, 3
    and-int/lit8 v5, v5, 15
    shr-int/2addr v4, v3
    const/4 v6, 1
    and-int/2addr v4, v6
    move-object v7, p0
    invoke-direct { p0, v5 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->bits(I)I
    move-result v7
    add-int/lit8 v8, v7, 7
    const/16 v9, 8
    div-int/2addr v8, v9
    add-int/2addr v8, v6
    if-lt v1, v8, :L6
    add-int/lit8 v1, v7, 10
    add-int/lit8 v1, v1, 7
    div-int/2addr v1, v9
    add-int/lit8 v1, v1, 12
    new-array v1, v1, [B
    const/16 v8, -128
    const/4 v10, 0
    aput-byte v8, v1, v10
    if-eqz p5, :L0
    const/16 v8, 128
    goto :L1
  :L0
    move v8, v10
  :L1
    and-int/lit8 v11, p4, 127
    or-int/2addr v8, v11
    int-to-byte v8, v8
    aput-byte v8, v1, v6
    ushr-int/lit8 v8, v2, 8
    int-to-byte v8, v8
    aput-byte v8, v1, v3
    int-to-byte v2, v2
    const/4 v3, 3
    aput-byte v2, v1, v3
    const/4 v2, 4
    move-wide/from16 v11, p7
    invoke-static { v1, v2, v11, v12 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->put32([BIJ)V
    move-wide/from16 v11, p9
    invoke-static { v1, v9, v11, v12 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->put32([BIJ)V
    const/16 v3, 96
    move v8, v10
  :L2
    if-ge v8, v2, :L3
    add-int v11, v3, v8
    invoke-static { v1, v11, v6 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->setBit([BII)V
    add-int/lit8 v8, v8, 1
    goto :L2
  :L3
    const/16 v2, 101
    shr-int/lit8 v3, v5, 3
    and-int/2addr v3, v6
    invoke-static { v1, v2, v3 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->setBit([BII)V
    const/16 v2, 102
    shr-int/lit8 v3, v5, 2
    and-int/2addr v3, v6
    invoke-static { v1, v2, v3 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->setBit([BII)V
    const/16 v2, 103
    shr-int/lit8 v3, v5, 1
    and-int/2addr v3, v6
    invoke-static { v1, v2, v3 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->setBit([BII)V
    const/16 v2, 104
    and-int/lit8 v3, v5, 1
    invoke-static { v1, v2, v3 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->setBit([BII)V
    const/16 v2, 105
    invoke-static { v1, v2, v4 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->setBit([BII)V
  :L4
    if-ge v10, v7, :L5
    const/16 v2, 106
    add-int/2addr v2, v10
    add-int/lit8 v3, p2, 1
    mul-int/2addr v3, v9
    add-int/2addr v3, v10
    invoke-static { p1, v3 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->bit([BI)I
    move-result v3
    invoke-static { v1, v2, v3 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->setBit([BII)V
    add-int/lit8 v10, v10, 1
    goto :L4
  :L5
    return-object v1
  :L6
    new-instance v0, Ljava/lang/IllegalArgumentException;
    const-string v1, "short frame"
    invoke-direct { v0, v1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw v0
  :L7
    new-instance v0, Ljava/lang/IllegalArgumentException;
    const-string v1, "short storage"
    invoke-direct { v0, v1 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw v0
.end method

.method pulseDtmf(I)Z
  .catchall { :L1 .. :L4 } :L3
  .registers 5
  .line 35
    invoke-virtual { p0, p1 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->startDtmf(I)Z
    move-result p1
    if-nez p1, :L0
    const/4 p1, 0
    return p1
  :L0
    iget-object p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    monitor-enter p1
  :L1
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->pulseThread:Ljava/lang/Thread;
    if-eqz v0, :L2
    invoke-virtual { v0 }, Ljava/lang/Thread;->interrupt()V
  :L2
    new-instance v0, Ljava/lang/Thread;
    new-instance v1, Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;
    invoke-direct { v1, p0 }, Lcom/sec/internal/google/ApRtpUplinkPoc$PulseStopper;-><init>(Lcom/sec/internal/google/ApRtpUplinkPoc;)V
    const-string v2, "ap-dtmf-pulse"
    invoke-direct { v0, v1, v2 }, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->pulseThread:Ljava/lang/Thread;
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->pulseThread:Ljava/lang/Thread;
    const/4 v1, 1
    invoke-virtual { v0, v1 }, Ljava/lang/Thread;->setDaemon(Z)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->pulseThread:Ljava/lang/Thread;
    invoke-virtual { v0 }, Ljava/lang/Thread;->start()V
    monitor-exit p1
    return v1
  :L3
    move-exception v0
    monitor-exit p1
  :L4
    throw v0
.end method

.method start()V
  .registers 4
  .line 22
    new-instance v0, Ljava/lang/Thread;
    new-instance v1, Lcom/sec/internal/google/ApRtpUplinkPoc$MainRunner;
    invoke-direct { v1, p0 }, Lcom/sec/internal/google/ApRtpUplinkPoc$MainRunner;-><init>(Lcom/sec/internal/google/ApRtpUplinkPoc;)V
    const-string v2, "ap-amrwb-uplink"
    invoke-direct { v0, v1, v2 }, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->thread:Ljava/lang/Thread;
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->thread:Ljava/lang/Thread;
    const/4 v1, 1
    invoke-virtual { v0, v1 }, Ljava/lang/Thread;->setDaemon(Z)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->thread:Ljava/lang/Thread;
    invoke-virtual { v0 }, Ljava/lang/Thread;->start()V
    return-void
.end method

.method startDtmf(I)Z
  .catchall { :L1 .. :L4 } :L3
  .registers 5
  .line 33
    const/4 v0, 0
    if-ltz p1, :L5
    const/16 v1, 15
    if-gt p1, v1, :L5
    invoke-virtual { p0 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->isVoiceActive()Z
    move-result v1
    if-nez v1, :L0
    goto :L5
  :L0
    iget-object v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    monitor-enter v1
  :L1
    iget v2, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfEvent:I
    if-ltz v2, :L2
    monitor-exit v1
    return v0
  :L2
    iput p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfEvent:I
    iput-boolean v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfStop:Z
    new-instance v0, Ljava/lang/Thread;
    new-instance v2, Lcom/sec/internal/google/ApRtpUplinkPoc$DtmfRunner;
    invoke-direct { v2, p0, p1 }, Lcom/sec/internal/google/ApRtpUplinkPoc$DtmfRunner;-><init>(Lcom/sec/internal/google/ApRtpUplinkPoc;I)V
    const-string p1, "ap-dtmf-rtp"
    invoke-direct { v0, v2, p1 }, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V
    iput-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfThread:Ljava/lang/Thread;
    iget-object p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfThread:Ljava/lang/Thread;
    const/4 v0, 1
    invoke-virtual { p1, v0 }, Ljava/lang/Thread;->setDaemon(Z)V
    iget-object p1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfThread:Ljava/lang/Thread;
    invoke-virtual { p1 }, Ljava/lang/Thread;->start()V
    monitor-exit v1
    return v0
  :L3
    move-exception p1
    monitor-exit v1
  :L4
    throw p1
  :L5
    return v0
.end method

.method stop(Ljava/lang/String;)V
  .catchall { :L0 .. :L1 } :L21
  .catchall { :L2 .. :L3 } :L4
  .catchall { :L10 .. :L11 } :L12
  .catchall { :L13 .. :L14 } :L12
  .catchall { :L22 .. :L23 } :L21
  .registers 12
  .line 24
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->stopStarted:Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v1, 0
    const/4 v2, 1
    invoke-virtual { v0, v1, v2 }, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z
    move-result v0
    if-eqz v0, :L24
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v0, v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    monitor-enter v0
  :L0
    iput-boolean v2, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfStop:Z
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    invoke-virtual { v3 }, Ljava/lang/Object;->notifyAll()V
    monitor-exit v0
  :L1
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    if-eqz v0, :L5
  :L2
    invoke-virtual { v0 }, Landroid/media/AudioRecord;->stop()V
  :L3
    goto :L5
  :L4
    move-exception v0
  :L5
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->pulseThread:Ljava/lang/Thread;
    if-eqz v0, :L6
    invoke-virtual { v0 }, Ljava/lang/Thread;->interrupt()V
  :L6
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->thread:Ljava/lang/Thread;
    const-wide/16 v4, 1500
    invoke-static { v3, v4, v5 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->await(Ljava/lang/Thread;J)Z
    move-result v3
    iget-object v6, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfThread:Ljava/lang/Thread;
    invoke-static { v6, v4, v5 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->await(Ljava/lang/Thread;J)Z
    move-result v6
    const-wide/16 v7, 500
    invoke-static { v0, v7, v8 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->await(Ljava/lang/Thread;J)Z
    move-result v9
    if-nez v3, :L8
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->thread:Ljava/lang/Thread;
    if-eqz v3, :L7
    invoke-virtual { v3 }, Ljava/lang/Thread;->interrupt()V
  :L7
    invoke-static { v3, v4, v5 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->await(Ljava/lang/Thread;J)Z
    move-result v3
  :L8
    if-nez v6, :L15
    iget-object v4, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfThread:Ljava/lang/Thread;
    if-eqz v4, :L9
    invoke-virtual { v4 }, Ljava/lang/Thread;->interrupt()V
  :L9
    iget-object v5, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    monitor-enter v5
  :L10
    iget-object v6, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    invoke-virtual { v6 }, Ljava/lang/Object;->notifyAll()V
    monitor-exit v5
  :L11
    const-wide/16 v5, 1000
    invoke-static { v4, v5, v6 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->await(Ljava/lang/Thread;J)Z
    move-result v6
    goto :L15
  :L12
    move-exception p1
  :L13
    monitor-exit v5
  :L14
    throw p1
  :L15
    if-nez v9, :L17
    if-eqz v0, :L16
    invoke-virtual { v0 }, Ljava/lang/Thread;->interrupt()V
  :L16
    invoke-static { v0, v7, v8 }, Lcom/sec/internal/google/ApRtpUplinkPoc;->await(Ljava/lang/Thread;J)Z
    move-result v9
  :L17
    const-string v0, "AP_UPLINK_RTP"
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "STOP_REQUEST reason="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v4, " mainStopped="
    invoke-virtual { p1, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " dtmfStopped="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v6 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " pulseStopped="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v9 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " recordReleased="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->record:Landroid/media/AudioRecord;
    if-nez v3, :L18
    move v3, v2
    goto :L19
  :L18
    move v3, v1
  :L19
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v3, " codecReleased="
    invoke-virtual { p1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    iget-object v3, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->codec:Landroid/media/MediaCodec;
    if-nez v3, :L20
    move v1, v2
  :L20
    invoke-virtual { p1, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { v0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    goto :L24
  :L21
    move-exception p1
  :L22
    monitor-exit v0
  :L23
    throw p1
  :L24
    return-void
.end method

.method stopDtmf()Z
  .catchall { :L0 .. :L3 } :L2
  .registers 4
  .line 34
    iget-object v0, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    monitor-enter v0
  :L0
    iget v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfEvent:I
    if-gez v1, :L1
    const/4 v1, 0
    monitor-exit v0
    return v1
  :L1
    const/4 v1, 1
    iput-boolean v1, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfStop:Z
    iget-object v2, p0, Lcom/sec/internal/google/ApRtpUplinkPoc;->dtmfLock:Ljava/lang/Object;
    invoke-virtual { v2 }, Ljava/lang/Object;->notifyAll()V
    monitor-exit v0
    return v1
  :L2
    move-exception v1
    monitor-exit v0
  :L3
    throw v1
.end method
