.class public final Lcom/sec/internal/google/ApStuckCallFix;
.super Ljava/lang/Object;
.source "ApStuckCallFix.java"

.field private final static GATE:Ljava/lang/String; = "persist.vendor.ims.ap_stuck_call_fix"

.field private final static TAG:Ljava/lang/String; = "AP_STUCK_CALL_FIX"

.method private constructor <init>()V
  .registers 1
  .line 29
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static shouldSynthesiseTerminated(Ljava/lang/String;Z)Z
  .registers 6
  .line 35
    const-string v0, "persist.vendor.ims.ap_stuck_call_fix"
    const/4 v1, 1
    invoke-static { v0, v1 }, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
  .line 36
    const/4 v2, 0
    const-string v3, "AP_STUCK_CALL_FIX"
    if-nez v0, :L0
  .line 37
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "DISABLED gate=false event="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v3, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 38
    return v2
  :L0
  .line 40
    const-string v0, "callSessionInitiatingFailed"
    invoke-virtual { v0, p0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-nez v0, :L1
  .line 41
    return v2
  :L1
  .line 43
    if-eqz p1, :L2
  .line 44
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "SKIP session already closing event="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v3, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 45
    return v2
  :L2
  .line 47
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "SYNTHESISE callSessionTerminated after "
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    const-string p1, " - framework would otherwise strand the call in DISCONNECTING"
    invoke-virtual { p0, p1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v3, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  .line 49
    return v1
.end method

.method public static terminalReason(Landroid/telephony/ims/ImsReasonInfo;)Landroid/telephony/ims/ImsReasonInfo;
  .registers 4
  .line 54
    const-string v0, "AP_STUCK_CALL_FIX"
    if-eqz p0, :L0
  .line 55
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "REASON reusing code="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { p0 }, Landroid/telephony/ims/ImsReasonInfo;->getCode()I
    move-result v2
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " extra="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
  .line 56
    invoke-virtual { p0 }, Landroid/telephony/ims/ImsReasonInfo;->getExtraCode()I
    move-result v2
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
  .line 55
    invoke-static { v0, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 57
    return-object p0
  :L0
  .line 59
    const-string p0, "REASON original=null, using CODE_UNSPECIFIED"
    invoke-static { v0, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 60
    new-instance p0, Landroid/telephony/ims/ImsReasonInfo;
    const/4 v0, 0
    const-string v1, "synthesised terminal"
    invoke-direct { p0, v0, v0, v1 }, Landroid/telephony/ims/ImsReasonInfo;-><init>(IILjava/lang/String;)V
    return-object p0
.end method
