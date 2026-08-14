.class final Lcom/sec/internal/google/ApMediaConfigPoc;
.super Ljava/lang/Object;
.source "ApMediaConfigPoc.java"

.field private final static PREFIX:Ljava/lang/String; = "persist.vendor.ims."

.field private final static TAG:Ljava/lang/String; = "AP_MEDIA_CONFIG"

.method private constructor <init>()V
  .registers 1
  .line 10
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method static bool(Ljava/lang/String;Z)Z
  .registers 7
  .line 13
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "persist.vendor.ims."
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 14
    const-string v0, ""
    invoke-static { p0, v0 }, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v0
  .line 15
    invoke-virtual { v0 }, Ljava/lang/String;->length()I
    move-result v1
    if-nez v1, :L0
    return p1
  :L0
  .line 16
    const-string v1, "1"
    invoke-virtual { v1, v0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    const-string v2, "CONFIG_OVERRIDE property="
    const-string v3, " raw="
    const-string v4, "AP_MEDIA_CONFIG"
    if-nez v1, :L4
    const-string v1, "true"
    invoke-virtual { v1, v0 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :L4
  .line 17
    const-string v1, "on"
    invoke-virtual { v1, v0 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :L4
    const-string v1, "yes"
    invoke-virtual { v1, v0 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :L1
    goto :L4
  :L1
  .line 21
    const-string v1, "0"
    invoke-virtual { v1, v0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :L3
    const-string v1, "false"
    invoke-virtual { v1, v0 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :L3
  .line 22
    const-string v1, "off"
    invoke-virtual { v1, v0 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :L3
    const-string v1, "no"
    invoke-virtual { v1, v0 }, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :L2
    goto :L3
  :L2
  .line 26
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "CONFIG_REJECT property="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " fallback="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v4, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 27
    return p1
  :L3
  .line 23
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " effective=false"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v4, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 24
    const/4 p0, 0
    return p0
  :L4
  .line 18
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { p1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " effective=true"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v4, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 19
    const/4 p0, 1
    return p0
.end method

.method static dtmfClock(I)I
  .catchall { :L0 .. :L2 } :L3
  .registers 8
  .line 91
    const-string v0, " raw="
    const-string v1, "AP_MEDIA_CONFIG"
  .line 92
    const-string v2, "persist.vendor.ims.ap_dtmf_clock"
    const-string v3, ""
    invoke-static { v2, v3 }, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v3
  .line 93
    invoke-virtual { v3 }, Ljava/lang/String;->length()I
    move-result v4
    if-nez v4, :L0
    return p0
  :L0
  .line 95
    invoke-static { v3 }, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v4
  .line 96
    const/16 v5, 8000
    if-eq v4, v5, :L1
    const/16 v5, 16000
    if-ne v4, v5, :L4
  :L1
    if-ne v4, p0, :L4
  .line 97
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "CONFIG_OVERRIDE property="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v6, " effective="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static { v1, v5 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L2
  .line 98
    return v4
  :L3
  .line 100
    move-exception v4
  :L4
    nop
  .line 101
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct { v4 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "CONFIG_REJECT property="
    invoke-virtual { v4, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v4
    invoke-virtual { v4, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " mediaClock="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " fallback="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v1, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 103
    return p0
.end method

.method static dtmfPt(Z)I
  .registers 4
  .line 86
    if-eqz p0, :L0
    const-string v0, "ap_dtmf_nb_pt"
    goto :L1
  :L0
    const-string v0, "ap_dtmf_wb_pt"
  :L1
  .line 87
    if-eqz p0, :L2
    const/16 p0, 110
    goto :L3
  :L2
    const/16 p0, 111
  :L3
    const/16 v1, 96
    const/16 v2, 127
  .line 86
    invoke-static { v0, p0, v1, v2 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result p0
    return p0
.end method

.method static integer(Ljava/lang/String;III)I
  .catchall { :L0 .. :L1 } :L2
  .registers 8
  .line 31
    const-string v0, " raw="
    const-string v1, "AP_MEDIA_CONFIG"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "persist.vendor.ims."
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 32
    const-string v2, ""
    invoke-static { p0, v2 }, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v2
  .line 33
    invoke-virtual { v2 }, Ljava/lang/String;->length()I
    move-result v3
    if-nez v3, :L0
    return p1
  :L0
  .line 35
    invoke-static { v2 }, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v3
  .line 36
    if-lt v3, p2, :L3
    if-gt v3, p3, :L3
  .line 37
    new-instance p2, Ljava/lang/StringBuilder;
    invoke-direct { p2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p3, "CONFIG_OVERRIDE property="
    invoke-virtual { p2, p3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    const-string p3, " effective="
    invoke-virtual { p2, p3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    invoke-static { v1, p2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L1
  .line 38
    return v3
  :L2
  .line 40
    move-exception p2
  :L3
    nop
  .line 41
    new-instance p2, Ljava/lang/StringBuilder;
    invoke-direct { p2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string p3, "CONFIG_REJECT property="
    invoke-virtual { p2, p3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p2, " fallback="
    invoke-virtual { p0, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 42
    return p1
.end method

.method static logSnapshot(I)V
  .registers 8
  .line 107
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "SNAPSHOT latchRung="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, "ap_latch_probe_rung"
    const/4 v2, 4
    const/4 v3, 0
    const/4 v4, 5
    invoke-static { v1, v2, v3, v4 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " latchDelayMs="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 108
    const-string v1, "ap_latch_probe_delay_ms"
    const/16 v2, 1500
    const v5, 60000
    invoke-static { v1, v2, v3, v5 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " radioDwellMs="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 109
    const-string v1, "ap_latch_probe_radio_dwell_ms"
    const/16 v2, 400
    const/16 v5, 200
    const/16 v6, 10000
    invoke-static { v1, v2, v5, v6 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rotate="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 110
    const-string v1, "ap_media_rotate_ports"
    invoke-static { v1, v3 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rtp="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 111
    const-string v1, "ap_rtp_port"
    const/16 v2, 1234
    const/4 v5, 1
    const v6, 65535
    invoke-static { v1, v2, v5, v6 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " rtcp="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 112
    const-string v1, "ap_rtcp_port"
    const/16 v2, 1235
    invoke-static { v1, v2, v5, v6 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " playback="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 113
    const-string v1, "ap_rtp_playback"
    invoke-static { v1, v5 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " uplink="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 114
    const-string v1, "ap_uplink_rtp"
    invoke-static { v1, v5 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " source="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 115
    invoke-static { }, Lcom/sec/internal/google/ApMediaConfigPoc;->source()Ljava/lang/String;
    move-result-object v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " seconds="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 116
    invoke-static { }, Lcom/sec/internal/google/ApMediaConfigPoc;->uplinkSeconds()I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " voicePtOverride="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 117
    invoke-static { }, Lcom/sec/internal/google/ApMediaConfigPoc;->voicePtOverride()I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " nbBitrate="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 118
    invoke-static { v5 }, Lcom/sec/internal/google/ApMediaConfigPoc;->uplinkBitrate(Z)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " wbBitrate="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 119
    invoke-static { v3 }, Lcom/sec/internal/google/ApMediaConfigPoc;->uplinkBitrate(Z)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " dtmf="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 120
    const-string v1, "ap_dtmf_rtp"
    invoke-static { v1, v5 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " nbDtmfPt="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 121
    invoke-static { v5 }, Lcom/sec/internal/google/ApMediaConfigPoc;->dtmfPt(Z)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " wbDtmfPt="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 122
    invoke-static { v3 }, Lcom/sec/internal/google/ApMediaConfigPoc;->dtmfPt(Z)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " mediaClock="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " rtcpRr="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 124
    const-string v0, "ap_rtcp_rr"
    invoke-static { v0, v5 }, Lcom/sec/internal/google/ApMediaConfigPoc;->bool(Ljava/lang/String;Z)Z
    move-result v0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " rtcpRrInterval="
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
  .line 125
    const-string v0, "ap_rtcp_rr_interval"
    const/4 v1, 3
    const/16 v2, 10
    invoke-static { v0, v4, v1, v2 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
  .line 107
    const-string v0, "AP_MEDIA_CONFIG"
    invoke-static { v0, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 126
    return-void
.end method

.method static source()Ljava/lang/String;
  .registers 7
  .line 46
    nop
  .line 47
    const-string v0, "persist.vendor.ims.ap_uplink_source"
    const-string v1, ""
    invoke-static { v0, v1 }, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v1
  .line 48
    invoke-virtual { v1 }, Ljava/lang/String;->length()I
    move-result v2
    const-string v3, "voice_uplink"
    if-nez v2, :L0
    return-object v3
  :L0
  .line 49
    const-string v2, "mic"
    invoke-virtual { v2, v1 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    const-string v4, " raw="
    const-string v5, "AP_MEDIA_CONFIG"
    if-nez v2, :L2
    const-string v2, "voice_communication"
    invoke-virtual { v2, v1 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :L2
    invoke-virtual { v3, v1 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :L1
    goto :L2
  :L1
  .line 53
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "CONFIG_REJECT property="
    invoke-virtual { v2, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " fallback=voice_uplink"
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v5, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 54
    return-object v3
  :L2
  .line 50
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "CONFIG_OVERRIDE property="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " effective="
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v5, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 51
    return-object v1
.end method

.method static uplinkBitrate(Z)I
  .catchall { :L1 .. :L3 } :L4
  .registers 8
  .line 69
    const-string v0, " raw="
    const-string v1, "AP_MEDIA_CONFIG"
    if-nez p0, :L0
    const-string p0, "ap_uplink_wb_bitrate"
    const/16 v0, 12650
    invoke-static { p0, v0, v0, v0 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result p0
    return p0
  :L0
  .line 70
    const-string p0, "persist.vendor.ims.ap_uplink_nb_bitrate"
  .line 71
    const-string v2, ""
    invoke-static { p0, v2 }, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v2
  .line 72
    invoke-virtual { v2 }, Ljava/lang/String;->length()I
    move-result v3
    const/16 v4, 12200
    if-nez v3, :L1
    return v4
  :L1
  .line 74
    invoke-static { v2 }, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v3
  .line 75
    const/16 v5, 4750
    if-eq v3, v5, :L2
    const/16 v5, 5150
    if-eq v3, v5, :L2
    const/16 v5, 5900
    if-eq v3, v5, :L2
    const/16 v5, 6700
    if-eq v3, v5, :L2
    const/16 v5, 7400
    if-eq v3, v5, :L2
    const/16 v5, 7950
    if-eq v3, v5, :L2
    const/16 v5, 10200
    if-eq v3, v5, :L2
    if-ne v3, v4, :L5
  :L2
  .line 77
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "CONFIG_OVERRIDE property="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v6, " effective="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static { v1, v5 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L3
  .line 78
    return v3
  :L4
  .line 80
    move-exception v3
  :L5
    nop
  .line 81
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "CONFIG_REJECT property="
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string v0, " fallback=12200"
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 82
    return v4
.end method

.method static uplinkSeconds()I
  .registers 3
  .line 65
    const-string v0, "ap_uplink_rtp_seconds"
    const/16 v1, 32766
    const/4 v2, 0
    invoke-static { v0, v1, v2, v1 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v0
    return v0
.end method

.method static voicePtOverride()I
  .registers 4
  .line 58
    const-string v0, "ap_uplink_pt_override"
    const/4 v1, -1
    const/16 v2, 127
    invoke-static { v0, v1, v1, v2 }, Lcom/sec/internal/google/ApMediaConfigPoc;->integer(Ljava/lang/String;III)I
    move-result v0
  .line 59
    if-eq v0, v1, :L1
    const/16 v2, 96
    if-lt v0, v2, :L0
    goto :L1
  :L0
  .line 60
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "CONFIG_REJECT property=persist.vendor.ims.ap_uplink_pt_override raw="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v2, " fallback=-1"
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    const-string v2, "AP_MEDIA_CONFIG"
    invoke-static { v2, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 61
    return v1
  :L1
  .line 59
    return v0
.end method
