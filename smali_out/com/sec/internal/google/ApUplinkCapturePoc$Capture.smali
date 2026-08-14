.class final Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;
.super Ljava/lang/Object;
.source "ApUplinkCapturePoc.java"

.annotation system Ldalvik/annotation/EnclosingClass;
  value = Lcom/sec/internal/google/ApUplinkCapturePoc;
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 24
  name = "Capture"
.end annotation

.field final callId:I

.field volatile record:Landroid/media/AudioRecord;

.field final running:Ljava/util/concurrent/atomic/AtomicBoolean;

.field volatile thread:Ljava/lang/Thread;

.method constructor <init>(I)V
  .registers 4
  .line 29
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
  .line 28
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v1, 1
    invoke-direct { v0, v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V
    iput-object v0, p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
  .line 29
    iput p1, p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    return-void
.end method

.method run()V
  .catchall { :L0 .. :L1 } :L86
  .catchall { :L2 .. :L3 } :L85
  .catchall { :L4 .. :L5 } :L81
  .catchall { :L6 .. :L7 } :L11
  .catchall { :L8 .. :L9 } :L10
  .catchall { :L14 .. :L16 } :L81
  .catchall { :L16 .. :L17 } :L18
  .catchall { :L20 .. :L23 } :L24
  .catchall { :L25 .. :L26 } :L30
  .catchall { :L27 .. :L28 } :L29
  .catchall { :L33 .. :L34 } :L76
  .catchall { :L36 .. :L37 } :L72
  .catchall { :L38 .. :L39 } :L55
  .catchall { :L40 .. :L45 } :L54
  .catchall { :L47 .. :L49 } :L52
  .catchall { :L59 .. :L60 } :L61
  .catchall { :L62 .. :L63 } :L64
  .catchall { :L66 .. :L67 } :L68
  .catchall { :L74 .. :L75 } :L75
  .catchall { :L79 .. :L80 } :L80
  .catchall { :L83 .. :L84 } :L84
  .catchall { :L90 .. :L91 } :L91
  .catchall { :L94 .. :L95 } :L110
  .catchall { :L96 .. :L97 } :L98
  .catchall { :L99 .. :L100 } :L101
  .catchall { :L103 .. :L104 } :L105
  .catchall { :L111 .. :L112 } :L113
  .catchall { :L114 .. :L115 } :L116
  .catchall { :L118 .. :L119 } :L120
  .registers 61
  .line 31
    move-object/from16 v1, p0
    const-string v0, "currentApplication"
    const-string v2, "android.app.ActivityThread"
    const-string v3, "persist.vendor.ims.ap_uplink_source"
    const-string v4, "mic"
    invoke-static { v3, v4 }, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-static { v3 }, Lcom/sec/internal/google/ApUplinkCapturePoc;->source(Ljava/lang/String;)I
    move-result v10
    const-string v4, "persist.vendor.ims.ap_uplink_seconds"
    const/16 v5, 10
    invoke-static { v4, v5 }, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I
    move-result v4
    const/4 v11, 1
    const/16 v5, 30
    invoke-static { v4, v11, v5 }, Lcom/sec/internal/google/ApUplinkCapturePoc;->clamp(III)I
    move-result v12
    const-string v4, "persist.vendor.ims.ap_uplink_bytes"
    const v5, 320000
    invoke-static { v4, v5 }, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I
    move-result v4
    const/16 v5, 3200
    const v6, 960000
    invoke-static { v4, v5, v6 }, Lcom/sec/internal/google/ApUplinkCapturePoc;->clamp(III)I
    move-result v13
    const-string v4, "persist.vendor.ims.ap_uplink_file"
    const/4 v14, 0
    invoke-static { v4, v14 }, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z
    move-result v15
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v16
  .line 32
    const-string v9, " rtpSend=false"
    const-string v8, " errors="
    const-string v7, " firstNonzeroMs="
    const-string v6, " rms="
    const-string v5, " peak="
    const-string v4, " nonzeroSamples="
    const-string v14, " zeroSamples="
    const-string v11, " bytes="
    move-object/from16 v19, v8
    const-string v8, " reads="
    move-object/from16 v20, v8
    const-string v8, "STOP callId="
    move-object/from16 v21, v8
    const-string v8, "AP_UPLINK_CAPTURE"
    move-object/from16 v22, v8
    const-wide/16 v23, 0
    const-wide/16 v25, -1
    if-ltz v10, :L89
  :L0
  .line 33
    invoke-static { }, Lcom/sec/internal/google/ApMediaNegotiationPoc;->uniqueReady()Ljava/lang/String;
    move-result-object v8
  :L1
  .line 34
    move-object/from16 v28, v4
    const/16 v4, 16000
    move-object/from16 v29, v5
    const/16 v5, 16
    move-object/from16 v30, v6
    const/4 v6, 2
  :L2
    invoke-static { v4, v5, v6 }, Landroid/media/AudioRecord;->getMinBufferSize(III)I
    move-result v4
    if-lez v4, :L82
    const/16 v5, 6400
    mul-int/2addr v4, v6
    invoke-static { v5, v4 }, Ljava/lang/Math;->max(II)I
    move-result v6
  .line 35
    new-instance v5, Landroid/media/AudioRecord;
  :L3
    const/16 v31, 16000
    const/16 v32, 16
    const/16 v33, 2
    move-object/from16 v34, v28
    move-object v4, v5
    move-object/from16 v35, v5
    move-object/from16 v36, v29
    move v5, v10
    move/from16 v28, v6
    move-object/from16 v37, v30
    move/from16 v6, v31
    move-object/from16 v38, v7
    move/from16 v7, v32
    move-object/from16 v39, v8
    move-object/from16 v40, v19
    move-object/from16 v41, v20
    move-object/from16 v42, v21
    move-object/from16 v43, v22
    move/from16 v8, v33
    move-object/from16 v44, v9
    move/from16 v9, v28
  :L4
    invoke-direct/range { v4 .. v9 }, Landroid/media/AudioRecord;-><init>(IIIII)V
    move-object/from16 v4, v35
    iput-object v4, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    iget-object v4, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    invoke-virtual { v4 }, Landroid/media/AudioRecord;->getState()I
    move-result v4
  :L5
    const/4 v5, 1
    if-ne v4, v5, :L78
  :L6
  .line 36
    invoke-static { v2 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v4
    const/4 v5, 0
    new-array v6, v5, [Ljava/lang/Class;
    invoke-virtual { v4, v0, v6 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v4
    new-array v6, v5, [Ljava/lang/Object;
  :L7
    const/4 v5, 0
  :L8
    invoke-virtual { v4, v5, v6 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v4
    invoke-virtual { v4 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v4
    const-string v6, "getSystemService"
    const/4 v7, 1
    new-array v8, v7, [Ljava/lang/Class;
    const-class v7, Ljava/lang/String;
    const/4 v9, 0
    aput-object v7, v8, v9
    invoke-virtual { v4, v6, v8 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v4
    invoke-static { v2 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v2
    const/4 v6, 0
    new-array v7, v6, [Ljava/lang/Class;
    invoke-virtual { v2, v0, v7 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
    new-array v2, v6, [Ljava/lang/Object;
    invoke-virtual { v0, v5, v2 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    const/4 v2, 1
    new-array v2, v2, [Ljava/lang/Object;
    const-string v6, "audio"
    const/4 v7, 0
    aput-object v6, v2, v7
    invoke-virtual { v4, v0, v2 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    move-object v8, v0
    check-cast v8, Landroid/media/AudioManager;
  :L9
    goto :L13
  :L10
    move-exception v0
    goto :L12
  :L11
    move-exception v0
    const/4 v5, 0
  :L12
    move-object v8, v5
  :L13
  .line 37
    if-nez v8, :L14
    const/4 v0, -1
    goto :L15
  :L14
    invoke-virtual { v8 }, Landroid/media/AudioManager;->getMode()I
    move-result v0
  :L15
    move v2, v0
    const-string v4, "null"
  :L16
    iget-object v0, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    invoke-virtual { v0 }, Landroid/media/AudioRecord;->getRoutedDevice()Landroid/media/AudioDeviceInfo;
    move-result-object v0
    invoke-static { v0 }, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;
    move-result-object v4
  :L17
    goto :L19
  :L18
    move-exception v0
  :L19
  .line 38
    if-eqz v15, :L32
  :L20
    new-instance v0, Ljava/io/File;
    const-string v6, "/data/vendor/ims"
    invoke-direct { v0, v6 }, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual { v0 }, Ljava/io/File;->exists()Z
    move-result v6
    if-nez v6, :L22
    invoke-virtual { v0 }, Ljava/io/File;->mkdirs()Z
    move-result v6
    if-eqz v6, :L21
    goto :L22
  :L21
    new-instance v6, Ljava/lang/IllegalStateException;
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct { v7 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "mkdir "
    invoke-virtual { v7, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v7
    invoke-virtual { v7, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-direct { v6, v0 }, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V
    throw v6
  :L22
    new-instance v8, Ljava/io/BufferedOutputStream;
    new-instance v6, Ljava/io/FileOutputStream;
    new-instance v7, Ljava/io/File;
    new-instance v9, Ljava/lang/StringBuilder;
    invoke-direct { v9 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "desem26_call_"
    invoke-virtual { v9, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    iget v9, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-virtual { v5, v9 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v9, "_"
    invoke-virtual { v5, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v9, ".pcm"
    invoke-virtual { v5, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-direct { v7, v0, v5 }, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    const/4 v5, 0
    invoke-direct { v6, v7, v5 }, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;Z)V
    invoke-direct { v8, v6 }, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;)V
  :L23
    move-object/from16 v6, v43
    goto :L33
  :L24
    move-exception v0
  :L25
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "FILE_DISABLED callId="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    iget v6, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v6, " path=/data/vendor/ims"
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
  :L26
    move-object/from16 v6, v43
  :L27
    invoke-static { v6, v5, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L28
    const/4 v8, 0
    const/4 v15, 0
    goto :L33
  :L29
  .line 42
    move-exception v0
    goto :L31
  :L30
    move-exception v0
    move-object/from16 v6, v43
  :L31
    move-object v13, v11
    move-object/from16 v21, v14
    move-wide/from16 v2, v23
    move-wide v4, v2
    move-wide v7, v4
    move-wide v9, v7
    move-wide v14, v9
    move-wide/from16 v49, v25
    move-object/from16 v12, v41
    move-object/from16 v11, v42
    goto/16 :L88
  :L32
  .line 38
    move-object/from16 v6, v43
    const/4 v8, 0
  :L33
  .line 39
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "START callId="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v5, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v5, " source="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " sourceId="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v10 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " seconds="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v12 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " maxBytes="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v13 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v3, " buffer="
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move/from16 v3, v28
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v5, " mode="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " routed="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " file="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v15 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " rtpSend=false negotiated="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v39
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v6, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 40
    iget-object v0, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    invoke-virtual { v0 }, Landroid/media/AudioRecord;->startRecording()V
    iget-object v0, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    invoke-virtual { v0 }, Landroid/media/AudioRecord;->getRecordingState()I
    move-result v0
    const/4 v2, 3
    if-ne v0, v2, :L73
    new-array v0, v3, [B
  :L34
    int-to-long v4, v12
    const-wide/16 v9, 1000
    mul-long/2addr v4, v9
    add-long v4, v16, v4
    move-object/from16 v20, v11
    move-object/from16 v21, v14
    move-wide/from16 v9, v23
    move-wide v11, v9
    move-wide v14, v11
    move-wide/from16 v45, v14
    move-wide/from16 v47, v45
    move-wide/from16 v18, v25
    const/4 v2, 0
    const/4 v7, 0
  :L35
  .line 41
    move/from16 v22, v2
  :L36
    iget-object v2, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    invoke-virtual { v2 }, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z
    move-result v2
  :L37
    if-eqz v2, :L58
  :L38
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v25
  :L39
    cmp-long v2, v25, v4
    if-gez v2, :L58
    move-wide/from16 v27, v4
    int-to-long v4, v13
    cmp-long v2, v9, v4
    if-gez v2, :L58
    move-wide/from16 v25, v11
    int-to-long v11, v3
    sub-long/2addr v4, v9
  :L40
    invoke-static { v11, v12, v4, v5 }, Ljava/lang/Math;->min(JJ)J
    move-result-wide v4
    long-to-int v2, v4
    iget-object v4, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    const/4 v5, 0
    invoke-virtual { v4, v0, v5, v2 }, Landroid/media/AudioRecord;->read([BII)I
    move-result v2
    if-gez v2, :L41
    add-int/lit8 v7, v7, 1
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "READ_ERROR callId="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    iget v5, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    const-string v5, " code="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v6, v2 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    goto :L42
  :L41
    if-nez v2, :L44
  :L42
    move/from16 v2, v22
  :L43
    move-wide/from16 v11, v25
    move-wide/from16 v4, v27
    goto :L35
  :L44
    const-wide/16 v4, 1
    add-long/2addr v14, v4
    int-to-long v11, v2
    add-long/2addr v9, v11
    if-eqz v8, :L45
    const/4 v11, 0
    invoke-virtual { v8, v0, v11, v2 }, Ljava/io/BufferedOutputStream;->write([BII)V
  :L45
    move/from16 v11, v22
    const/4 v12, 0
  :L46
    add-int/lit8 v4, v12, 1
    if-ge v4, v2, :L53
  :L47
    aget-byte v5, v0, v12
    and-int/lit16 v5, v5, 255
    aget-byte v4, v0, v4
    shl-int/lit8 v4, v4, 8
    or-int/2addr v4, v5
    int-to-short v4, v4
    invoke-static { v4 }, Ljava/lang/Math;->abs(I)I
    move-result v5
    if-nez v5, :L48
    const-wide/16 v29, 1
    add-long v25, v25, v29
    goto :L50
  :L48
    const-wide/16 v29, 1
    add-long v45, v45, v29
    cmp-long v22, v18, v23
    if-gez v22, :L50
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v18
  :L49
    sub-long v18, v18, v16
  :L50
    if-le v5, v11, :L51
    move v11, v5
  :L51
    int-to-long v4, v4
    mul-long/2addr v4, v4
    add-long v47, v47, v4
    add-int/lit8 v12, v12, 2
    move-wide/from16 v4, v29
    goto :L46
  :L52
  .line 42
    move-exception v0
    move/from16 v16, v7
    move-object/from16 v28, v8
    move/from16 v17, v11
    move-wide v2, v14
    move-wide/from16 v49, v18
    move-object/from16 v13, v20
    goto :L57
  :L53
  .line 41
    move v2, v11
    goto :L43
  :L54
  .line 42
    move-exception v0
    goto :L56
  :L55
    move-exception v0
    move-wide/from16 v25, v11
  :L56
    move/from16 v16, v7
    move-object/from16 v28, v8
    move-wide v2, v14
    move-wide/from16 v49, v18
    move-object/from16 v13, v20
    move/from16 v17, v22
  :L57
    move-wide/from16 v4, v25
    move-object/from16 v12, v41
    move-object/from16 v11, v42
    move-wide/from16 v7, v45
    move-wide v14, v9
    move-wide/from16 v9, v47
    goto/16 :L93
  :L58
  .line 41
    move-wide/from16 v25, v11
  .line 42
    iget-object v0, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v2, 0
    invoke-virtual { v0, v2 }, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V
    iget-object v2, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    const/4 v3, 0
    iput-object v3, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    if-eqz v2, :L65
  :L59
    invoke-virtual { v2 }, Landroid/media/AudioRecord;->stop()V
  :L60
    goto :L62
  :L61
    move-exception v0
  :L62
    invoke-virtual { v2 }, Landroid/media/AudioRecord;->release()V
  :L63
    goto :L65
  :L64
    move-exception v0
  :L65
    if-eqz v8, :L69
  :L66
    invoke-virtual { v8 }, Ljava/io/BufferedOutputStream;->flush()V
    invoke-virtual { v8 }, Ljava/io/BufferedOutputStream;->close()V
  :L67
    goto :L69
  :L68
    move-exception v0
  :L69
    move-wide/from16 v2, v45
    add-long v11, v25, v2
    cmp-long v0, v11, v23
    if-nez v0, :L70
    move-wide/from16 v4, v23
    goto :L71
  :L70
    move-wide/from16 v4, v47
    long-to-double v4, v4
    long-to-double v11, v11
    div-double/2addr v4, v11
    invoke-static { v4, v5 }, Ljava/lang/Math;->sqrt(D)D
    move-result-wide v4
    double-to-long v4, v4
  :L71
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    move-object/from16 v11, v42
    invoke-virtual { v0, v11 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v8, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-virtual { v0, v8 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v12, v41
    invoke-virtual { v0, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v14, v15 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v13, v20
    invoke-virtual { v0, v13 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v9, v10 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v8, v21
    invoke-virtual { v0, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move-wide/from16 v8, v25
    invoke-virtual { v0, v8, v9 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v8, v34
    invoke-virtual { v0, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v36
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move/from16 v2, v22
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v37
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v4, v5 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v38
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move-wide/from16 v2, v18
    invoke-virtual { v0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v40
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v7 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    goto/16 :L109
  :L72
    move-exception v0
    move/from16 v27, v7
    move-object/from16 v28, v8
    move-wide/from16 v29, v9
    move-wide/from16 v25, v11
    move-object/from16 v13, v20
    move-object/from16 v9, v21
    move-object/from16 v12, v41
    move-object/from16 v11, v42
    move-wide/from16 v16, v45
    move-wide/from16 v20, v47
    move-wide v2, v14
    move-wide/from16 v7, v16
    move-wide/from16 v49, v18
    move/from16 v17, v22
    move-wide/from16 v4, v25
    move/from16 v16, v27
    move-wide/from16 v14, v29
    move-wide/from16 v58, v20
    move-object/from16 v21, v9
    move-wide/from16 v9, v58
    goto/16 :L93
  :L73
  .line 40
    move-object/from16 v28, v8
    move-object v13, v11
    move-object v9, v14
    move-object/from16 v8, v34
    move-object/from16 v7, v36
    move-object/from16 v4, v37
    move-object/from16 v5, v38
    move-object/from16 v3, v40
    move-object/from16 v12, v41
    move-object/from16 v11, v42
    move-object/from16 v2, v44
  :L74
    new-instance v0, Ljava/lang/IllegalStateException;
    const-string v10, "not recording"
    invoke-direct { v0, v10 }, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V
    throw v0
  :L75
  .line 42
    move-exception v0
    move-object/from16 v44, v2
    move-object/from16 v40, v3
    move-object/from16 v37, v4
    move-object/from16 v38, v5
    move-object/from16 v36, v7
    move-object/from16 v34, v8
    move-object/from16 v21, v9
    goto :L77
  :L76
    move-exception v0
    move-object/from16 v28, v8
    move-object v13, v11
    move-object/from16 v12, v41
    move-object/from16 v11, v42
    move-object/from16 v21, v14
  :L77
    move-wide/from16 v2, v23
    move-wide v4, v2
    move-wide v7, v4
    move-wide v9, v7
    move-wide v14, v9
    move-wide/from16 v49, v25
    const/16 v16, 0
    const/16 v17, 0
    goto/16 :L93
  :L78
  .line 35
    move-object v13, v11
    move-object v9, v14
    move-object/from16 v8, v34
    move-object/from16 v7, v36
    move-object/from16 v4, v37
    move-object/from16 v5, v38
    move-object/from16 v3, v40
    move-object/from16 v12, v41
    move-object/from16 v11, v42
    move-object/from16 v6, v43
    move-object/from16 v2, v44
  :L79
    new-instance v0, Ljava/lang/IllegalStateException;
    const-string v10, "uninitialized"
    invoke-direct { v0, v10 }, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V
    throw v0
  :L80
  .line 42
    move-exception v0
    move-object/from16 v44, v2
    move-object/from16 v40, v3
    move-object/from16 v37, v4
    move-object/from16 v38, v5
    move-object/from16 v36, v7
    move-object/from16 v34, v8
    move-object/from16 v21, v9
    goto/16 :L87
  :L81
    move-exception v0
    move-object v13, v11
    move-object/from16 v12, v41
    move-object/from16 v11, v42
    move-object/from16 v6, v43
    move-object/from16 v21, v14
    goto/16 :L87
  :L82
  .line 34
    move-object v5, v7
    move-object v2, v9
    move-object v13, v11
    move-object v9, v14
    move-object/from16 v3, v19
    move-object/from16 v12, v20
    move-object/from16 v11, v21
    move-object/from16 v6, v22
    move-object/from16 v8, v28
    move-object/from16 v7, v29
    move-object/from16 v10, v30
  :L83
    new-instance v0, Ljava/lang/IllegalStateException;
    new-instance v14, Ljava/lang/StringBuilder;
    invoke-direct { v14 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v15, "minBuffer="
    invoke-virtual { v14, v15 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v14
    invoke-virtual { v14, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    invoke-direct { v0, v4 }, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V
    throw v0
  :L84
  .line 42
    move-exception v0
    move-object/from16 v44, v2
    move-object/from16 v40, v3
    goto/16 :L92
  :L85
    move-exception v0
    move-object v5, v7
    move-object v2, v9
    move-object v13, v11
    move-object/from16 v12, v20
    move-object/from16 v11, v21
    move-object/from16 v6, v22
    move-object/from16 v44, v2
    move-object/from16 v38, v5
    move-object/from16 v21, v14
    move-object/from16 v40, v19
    move-wide/from16 v2, v23
    move-wide v4, v2
    move-wide v7, v4
    move-wide v9, v7
    move-wide v14, v9
    move-wide/from16 v49, v25
    move-object/from16 v34, v28
    move-object/from16 v36, v29
    move-object/from16 v37, v30
    goto :L88
  :L86
    move-exception v0
    move-object v10, v6
    move-object v2, v9
    move-object v13, v11
    move-object/from16 v12, v20
    move-object/from16 v11, v21
    move-object/from16 v6, v22
    move-object/from16 v58, v7
    move-object v7, v5
    move-object/from16 v5, v58
    move-object/from16 v44, v2
    move-object/from16 v34, v4
    move-object/from16 v38, v5
    move-object/from16 v36, v7
    move-object/from16 v37, v10
    move-object/from16 v21, v14
    move-object/from16 v40, v19
  :L87
    move-wide/from16 v2, v23
    move-wide v4, v2
    move-wide v7, v4
    move-wide v9, v7
    move-wide v14, v9
    move-wide/from16 v49, v25
  :L88
    const/16 v16, 0
    const/16 v17, 0
    const/16 v28, 0
    goto :L93
  :L89
  .line 32
    move-object v8, v4
    move-object v10, v6
    move-object v2, v9
    move-object v13, v11
    move-object v9, v14
    move-object/from16 v4, v19
    move-object/from16 v12, v20
    move-object/from16 v11, v21
    move-object/from16 v6, v22
    move-object/from16 v58, v7
    move-object v7, v5
    move-object/from16 v5, v58
  :L90
    new-instance v0, Ljava/lang/IllegalArgumentException;
    new-instance v14, Ljava/lang/StringBuilder;
    invoke-direct { v14 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v15, "unsupported source="
    invoke-virtual { v14, v15 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v14
    invoke-virtual { v14, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-direct { v0, v3 }, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V
    throw v0
  :L91
  .line 42
    move-exception v0
    move-object/from16 v44, v2
    move-object/from16 v40, v4
  :L92
    move-object/from16 v38, v5
    move-object/from16 v36, v7
    move-object/from16 v34, v8
    move-object/from16 v21, v9
    move-object/from16 v37, v10
    goto :L87
  :L93
    move-wide/from16 v18, v14
  :L94
    new-instance v14, Ljava/lang/StringBuilder;
    invoke-direct { v14 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v15, "FAIL callId="
    invoke-virtual { v14, v15 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v14
    iget v15, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-virtual { v14, v15 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v14
    invoke-virtual { v14 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v14
    invoke-static { v6, v14, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L95
    iget-object v0, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v14, 0
    invoke-virtual { v0, v14 }, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V
    iget-object v14, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    const/4 v15, 0
    iput-object v15, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    if-eqz v14, :L102
  :L96
    invoke-virtual { v14 }, Landroid/media/AudioRecord;->stop()V
  :L97
    goto :L99
  :L98
    move-exception v0
  :L99
    invoke-virtual { v14 }, Landroid/media/AudioRecord;->release()V
  :L100
    goto :L102
  :L101
    move-exception v0
  :L102
    if-eqz v28, :L106
  :L103
    invoke-virtual/range { v28 .. v28 }, Ljava/io/BufferedOutputStream;->flush()V
    invoke-virtual/range { v28 .. v28 }, Ljava/io/BufferedOutputStream;->close()V
  :L104
    goto :L106
  :L105
    move-exception v0
  :L106
    add-long v14, v4, v7
    cmp-long v0, v14, v23
    if-nez v0, :L107
    move-wide/from16 v9, v23
    goto :L108
  :L107
    long-to-double v9, v9
    long-to-double v14, v14
    div-double/2addr v9, v14
    invoke-static { v9, v10 }, Ljava/lang/Math;->sqrt(D)D
    move-result-wide v9
    double-to-long v9, v9
  :L108
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { v0, v11 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v11, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-virtual { v0, v11 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v13 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move-wide/from16 v14, v18
    invoke-virtual { v0, v14, v15 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v21
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v4, v5 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v34
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v7, v8 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v36
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move/from16 v2, v17
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v37
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v9, v10 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v38
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move-wide/from16 v2, v49
    invoke-virtual { v0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v40
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move/from16 v2, v16
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
  :L109
    move-object/from16 v2, v44
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v6, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    invoke-static { }, Lcom/sec/internal/google/ApUplinkCapturePoc;->access$000()Ljava/util/concurrent/ConcurrentHashMap;
    move-result-object v0
    iget v2, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-static { v2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v2
    invoke-virtual { v0, v2, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;Ljava/lang/Object;)Z
    return-void
  :L110
    move-exception v0
    move-object/from16 v43, v6
    move/from16 v53, v16
    move/from16 v16, v17
    move-wide/from16 v14, v18
    move-object/from16 v6, v21
    move-object/from16 v57, v37
    move-object/from16 v56, v38
    move-object/from16 v55, v40
    move-object/from16 v54, v44
    move-wide/from16 v51, v49
    move-object/from16 v17, v0
    iget-object v0, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    move-object/from16 v21, v6
    const/4 v6, 0
    invoke-virtual { v0, v6 }, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V
    iget-object v6, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    move-wide/from16 v18, v14
    const/4 v14, 0
    iput-object v14, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    if-eqz v6, :L117
  :L111
    invoke-virtual { v6 }, Landroid/media/AudioRecord;->stop()V
  :L112
    goto :L114
  :L113
    move-exception v0
  :L114
    invoke-virtual { v6 }, Landroid/media/AudioRecord;->release()V
  :L115
    goto :L117
  :L116
    move-exception v0
  :L117
    if-eqz v28, :L121
  :L118
    invoke-virtual/range { v28 .. v28 }, Ljava/io/BufferedOutputStream;->flush()V
    invoke-virtual/range { v28 .. v28 }, Ljava/io/BufferedOutputStream;->close()V
  :L119
    goto :L121
  :L120
    move-exception v0
  :L121
    add-long v14, v4, v7
    cmp-long v0, v14, v23
    if-nez v0, :L122
    move-wide/from16 v9, v23
    goto :L123
  :L122
    long-to-double v9, v9
    long-to-double v14, v14
    div-double/2addr v9, v14
    invoke-static { v9, v10 }, Ljava/lang/Math;->sqrt(D)D
    move-result-wide v9
    double-to-long v9, v9
  :L123
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { v0, v11 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v6, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-virtual { v0, v6 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v13 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move-wide/from16 v2, v18
    invoke-virtual { v0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v21
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v4, v5 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v34
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v7, v8 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v36
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move/from16 v11, v16
    invoke-virtual { v0, v11 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v57
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v9, v10 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v56
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move-wide/from16 v2, v51
    invoke-virtual { v0, v2, v3 }, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v55
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    move/from16 v7, v53
    invoke-virtual { v0, v7 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    move-object/from16 v2, v54
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    move-object/from16 v2, v43
    invoke-static { v2, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    invoke-static { }, Lcom/sec/internal/google/ApUplinkCapturePoc;->access$000()Ljava/util/concurrent/ConcurrentHashMap;
    move-result-object v0
    iget v2, v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-static { v2 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v2
    invoke-virtual { v0, v2, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;Ljava/lang/Object;)Z
    throw v17
.end method

.method start()V
  .registers 5
  .line 30
    new-instance v0, Ljava/lang/Thread;
    new-instance v1, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture$$ExternalSyntheticLambda0;
    invoke-direct { v1, p0 }, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture$$ExternalSyntheticLambda0;-><init>(Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;)V
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "ap-uplink-capture-"
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-direct { v0, v1, v2 }, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V
    iput-object v0, p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->thread:Ljava/lang/Thread;
    iget-object v0, p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->thread:Ljava/lang/Thread;
    const/4 v1, 1
    invoke-virtual { v0, v1 }, Ljava/lang/Thread;->setDaemon(Z)V
    iget-object v0, p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->thread:Ljava/lang/Thread;
    invoke-virtual { v0 }, Ljava/lang/Thread;->start()V
    return-void
.end method

.method stop(Ljava/lang/String;)V
  .catchall { :L0 .. :L1 } :L2
  .catch Ljava/lang/InterruptedException; { :L4 .. :L5 } :L6
  .registers 5
  .line 43
    iget-object v0, p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->running:Ljava/util/concurrent/atomic/AtomicBoolean;
    const/4 v1, 0
    invoke-virtual { v0, v1 }, Ljava/util/concurrent/atomic/AtomicBoolean;->getAndSet(Z)Z
    move-result v0
    if-eqz v0, :L8
    iget-object v0, p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->record:Landroid/media/AudioRecord;
    if-eqz v0, :L3
  :L0
    invoke-virtual { v0 }, Landroid/media/AudioRecord;->stop()V
  :L1
    goto :L3
  :L2
    move-exception v0
  :L3
    iget-object v0, p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->thread:Ljava/lang/Thread;
    if-eqz v0, :L7
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v1
    if-eq v0, v1, :L7
    const-wide/16 v1, 1500
  :L4
    invoke-virtual { v0, v1, v2 }, Ljava/lang/Thread;->join(J)V
  :L5
    goto :L7
  :L6
    move-exception v0
    invoke-static { }, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/Thread;->interrupt()V
  :L7
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "STOP_REQUEST callId="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ApUplinkCapturePoc$Capture;->callId:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " reason="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    const-string v0, "AP_UPLINK_CAPTURE"
    invoke-static { v0, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L8
    return-void
.end method
