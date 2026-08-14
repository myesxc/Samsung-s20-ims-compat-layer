.class public final Lcom/sec/internal/google/ModernImsSms;
.super Landroid/telephony/ims/stub/ImsSmsImplBase;
.source "ModernImsSms.java"

.annotation system Ldalvik/annotation/MemberClasses;
  value = {
    Lcom/sec/internal/google/ModernImsSms$SamsungListener;
  }
.end annotation

.field private final static TAG:Ljava/lang/String; = "MODERN_IMS_SMS"

.field private final context:Landroid/content/Context;

.field private final phoneId:I

.field private volatile ready:Z

.field private final samsung:Lcom/sec/internal/google/ImsSmsImpl;

.method public constructor <init>(Landroid/content/Context;I)V
  .registers 6
  .line 18
    invoke-direct { p0 }, Landroid/telephony/ims/stub/ImsSmsImplBase;-><init>()V
  .line 19
    iput-object p1, p0, Lcom/sec/internal/google/ModernImsSms;->context:Landroid/content/Context;
  .line 20
    iput p2, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
  .line 21
    new-instance v0, Lcom/sec/internal/google/ImsSmsImpl;
    new-instance v1, Lcom/sec/internal/google/ModernImsSms$SamsungListener;
    const/4 v2, 0
    invoke-direct { v1, p0, v2 }, Lcom/sec/internal/google/ModernImsSms$SamsungListener;-><init>(Lcom/sec/internal/google/ModernImsSms;Lcom/sec/internal/google/ModernImsSms$1;)V
    invoke-direct { v0, p1, p2, v1 }, Lcom/sec/internal/google/ImsSmsImpl;-><init>(Landroid/content/Context;ILandroid/telephony/ims/aidl/IImsSmsListener;)V
    iput-object v0, p0, Lcom/sec/internal/google/ModernImsSms;->samsung:Lcom/sec/internal/google/ImsSmsImpl;
  .line 22
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "CREATE slot="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    const-string p2, "MODERN_IMS_SMS"
    invoke-static { p2, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 23
    return-void
.end method

.method static synthetic access$100(Lcom/sec/internal/google/ModernImsSms;II)V
  .registers 3
  .line 11
    invoke-virtual { p0, p1, p2 }, Lcom/sec/internal/google/ModernImsSms;->onSendSmsResultSuccess(II)V
    return-void
.end method

.method static synthetic access$200(Lcom/sec/internal/google/ModernImsSms;IIIII)V
  .registers 6
  .line 11
    invoke-virtual/range { p0 .. p5 }, Lcom/sec/internal/google/ModernImsSms;->onSendSmsResultError(IIIII)V
    return-void
.end method

.method static synthetic access$300(Lcom/sec/internal/google/ModernImsSms;)I
  .registers 1
  .line 11
    iget p0, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    return p0
.end method

.method static synthetic access$400(Lcom/sec/internal/google/ModernImsSms;ILjava/lang/String;[B)V
  .registers 4
  .line 11
    invoke-virtual { p0, p1, p2, p3 }, Lcom/sec/internal/google/ModernImsSms;->onSmsStatusReportReceived(ILjava/lang/String;[B)V
    return-void
.end method

.method static synthetic access$500(Lcom/sec/internal/google/ModernImsSms;ILjava/lang/String;[B)V
  .registers 4
  .line 11
    invoke-virtual { p0, p1, p2, p3 }, Lcom/sec/internal/google/ModernImsSms;->onSmsReceived(ILjava/lang/String;[B)V
    return-void
.end method

.method static synthetic access$600(Lcom/sec/internal/google/ModernImsSms;III)V
  .registers 4
  .line 11
    invoke-virtual { p0, p1, p2, p3 }, Lcom/sec/internal/google/ModernImsSms;->onMemoryAvailableResult(III)V
    return-void
.end method

.method private profileSmsc()Ljava/lang/String;
  .catchall { :L0 .. :L7 } :L10
  .registers 11
  .line 89
    const-string v0, "MODERN_IMS_SMS"
    const/4 v1, 0
  :L0
    const-string v2, "com.sec.internal.ims.registry.ImsRegistry"
    invoke-static { v2 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v2
  .line 90
    const-string v3, "getRegistrationInfoByPhoneId"
    const/4 v4, 1
    new-array v5, v4, [Ljava/lang/Class;
    sget-object v6, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v7, 0
    aput-object v6, v5, v7
    invoke-virtual { v2, v3, v5 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v2
    new-array v3, v4, [Ljava/lang/Object;
    iget v4, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
  .line 91
    invoke-static { v4 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v4
    aput-object v4, v3, v7
    invoke-virtual { v2, v1, v3 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v2
  .line 92
    instance-of v3, v2, [Ljava/lang/Object;
    if-nez v3, :L1
    return-object v1
  :L1
  .line 93
    check-cast v2, [Ljava/lang/Object;
    array-length v3, v2
    move v4, v7
  :L2
    if-ge v4, v3, :L9
    aget-object v5, v2, v4
  .line 94
    if-nez v5, :L3
    goto :L8
  :L3
  .line 95
    invoke-virtual { v5 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v6
    const-string v8, "getImsProfile"
    new-array v9, v7, [Ljava/lang/Class;
    invoke-virtual { v6, v8, v9 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v6
    new-array v8, v7, [Ljava/lang/Object;
  .line 96
    invoke-virtual { v6, v5, v8 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v5
  .line 97
    if-nez v5, :L4
    goto :L8
  :L4
  .line 98
    invoke-virtual { v5 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v6
    const-string v8, "getSmsPsi"
    new-array v9, v7, [Ljava/lang/Class;
    invoke-virtual { v6, v8, v9 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v6
    new-array v8, v7, [Ljava/lang/Object;
    invoke-virtual { v6, v5, v8 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v5
  .line 99
    if-nez v5, :L5
    move-object v5, v1
    goto :L6
  :L5
    invoke-virtual { v5 }, Ljava/lang/Object;->toString()Ljava/lang/String;
    move-result-object v5
  :L6
    invoke-static { v5 }, Lcom/sec/internal/google/ModernImsSms;->scaHex(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
  .line 100
    if-eqz v5, :L8
  .line 101
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "SMSC_RESOLVED slot="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " source=ims_profile"
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v0, v2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L7
  .line 102
    return-object v5
  :L8
  .line 93
    add-int/lit8 v4, v4, 1
    goto :L2
  :L9
  .line 107
    goto :L11
  :L10
  .line 105
    move-exception v2
  .line 106
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "SMSC_PROFILE_FAILED slot="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget v4, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static { v0, v3, v2 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L11
  .line 108
    return-object v1
.end method

.method private resolveSmsc(Ljava/lang/String;)Ljava/lang/String;
  .registers 5
  .line 112
    const-string v0, "MODERN_IMS_SMS"
    if-eqz p1, :L0
    invoke-virtual { p1 }, Ljava/lang/String;->length()I
    move-result v1
    const/4 v2, 2
    if-le v1, v2, :L0
    const-string v1, "00"
    invoke-virtual { v1, p1 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :L0
  .line 113
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "SMSC_RESOLVED slot="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v2, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    const-string v2, " source=framework"
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v0, v1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 114
    return-object p1
  :L0
  .line 116
    invoke-direct { p0 }, Lcom/sec/internal/google/ModernImsSms;->simSmsc()Ljava/lang/String;
    move-result-object p1
  .line 117
    if-nez p1, :L1
    invoke-direct { p0 }, Lcom/sec/internal/google/ModernImsSms;->profileSmsc()Ljava/lang/String;
    move-result-object p1
  :L1
  .line 118
    if-nez p1, :L2
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "SMSC_UNAVAILABLE slot="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v2, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v0, v1 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  :L2
  .line 119
    return-object p1
.end method

.method private static scaHex(Ljava/lang/String;)Ljava/lang/String;
  .registers 10
  .line 42
    const/4 v0, 0
    if-nez p0, :L0
    return-object v0
  :L0
  .line 43
    invoke-virtual { p0 }, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object p0
  .line 44
    const/16 v1, 58
    invoke-virtual { p0, v1 }, Ljava/lang/String;->indexOf(I)I
    move-result v7
  .line 45
    const/4 v8, 1
    if-ltz v7, :L2
    const/4 v2, 1
    const/4 v3, 0
    const/4 v5, 0
    const/4 v6, 4
    const-string v4, "sip:"
    move-object v1, p0
    invoke-virtual/range { v1 .. v6 }, Ljava/lang/String;->regionMatches(ZILjava/lang/String;II)Z
    move-result v1
    if-nez v1, :L1
    const/4 v2, 1
    const/4 v3, 0
    const/4 v5, 0
    const/4 v6, 4
  .line 46
    const-string v4, "tel:"
    move-object v1, p0
    invoke-virtual/range { v1 .. v6 }, Ljava/lang/String;->regionMatches(ZILjava/lang/String;II)Z
    move-result v1
    if-eqz v1, :L2
  :L1
    add-int/2addr v7, v8
    invoke-virtual { p0, v7 }, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object p0
  :L2
  .line 47
    invoke-virtual { p0 }, Ljava/lang/String;->length()I
    move-result v1
  .line 48
    const/16 v2, 64
    invoke-virtual { p0, v2 }, Ljava/lang/String;->indexOf(I)I
    move-result v2
  .line 49
    const/16 v3, 59
    invoke-virtual { p0, v3 }, Ljava/lang/String;->indexOf(I)I
    move-result v3
  .line 50
    if-ltz v2, :L3
    if-ge v2, v1, :L3
    move v1, v2
  :L3
  .line 51
    if-ltz v3, :L4
    if-ge v3, v1, :L4
    goto :L5
  :L4
  .line 52
    move v3, v1
  :L5
    const/4 v1, 0
    invoke-virtual { p0, v1, v3 }, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object p0
  .line 53
    const-string v2, "+"
    invoke-virtual { p0, v2 }, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
  .line 54
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
  .line 55
    move v4, v1
  :L6
    invoke-virtual { p0 }, Ljava/lang/String;->length()I
    move-result v5
    if-ge v4, v5, :L8
  .line 56
    invoke-virtual { p0, v4 }, Ljava/lang/String;->charAt(I)C
    move-result v5
  .line 57
    const/16 v6, 48
    if-lt v5, v6, :L7
    const/16 v6, 57
    if-gt v5, v6, :L7
    invoke-virtual { v3, v5 }, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;
  :L7
  .line 55
    add-int/lit8 v4, v4, 1
    goto :L6
  :L8
  .line 59
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->length()I
    move-result p0
    const/4 v4, 3
    if-lt p0, v4, :L16
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->length()I
    move-result p0
    const/16 v4, 20
    if-le p0, v4, :L9
    goto :L16
  :L9
  .line 60
    new-instance p0, Ljava/lang/StringBuilder;
    invoke-direct { p0 }, Ljava/lang/StringBuilder;-><init>()V
  .line 61
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->length()I
    move-result v0
    add-int/2addr v0, v8
    const/4 v4, 2
    div-int/2addr v0, v4
    add-int/2addr v0, v8
  .line 62
    new-array v4, v4, [Ljava/lang/Object;
    invoke-static { v0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v0
    aput-object v0, v4, v1
    if-eqz v2, :L10
    const/16 v0, 145
    goto :L11
  :L10
    const/16 v0, 129
  :L11
    invoke-static { v0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v0
    aput-object v0, v4, v8
    const-string v0, "%02X%02X"
    invoke-static { v0, v4 }, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;
    move-result-object v0
    invoke-virtual { p0, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
  .line 63
    nop
  :L12
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->length()I
    move-result v0
    if-ge v1, v0, :L15
  .line 64
    invoke-virtual { v3, v1 }, Ljava/lang/StringBuilder;->charAt(I)C
    move-result v0
  .line 65
    add-int/lit8 v2, v1, 1
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->length()I
    move-result v4
    if-ge v2, v4, :L13
    invoke-virtual { v3, v2 }, Ljava/lang/StringBuilder;->charAt(I)C
    move-result v2
    goto :L14
  :L13
    const/16 v2, 70
  :L14
  .line 66
    invoke-virtual { p0, v2 }, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;
  .line 63
    add-int/lit8 v1, v1, 2
    goto :L12
  :L15
  .line 68
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    return-object p0
  :L16
  .line 59
    return-object v0
.end method

.method private simSmsc()Ljava/lang/String;
  .catchall { :L0 .. :L4 } :L5
  .registers 6
  .line 73
    const-string v0, "MODERN_IMS_SMS"
    const/4 v1, 0
  :L0
    iget-object v2, p0, Lcom/sec/internal/google/ModernImsSms;->context:Landroid/content/Context;
    const-class v3, Landroid/telephony/SubscriptionManager;
    invoke-virtual { v2, v3 }, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Landroid/telephony/SubscriptionManager;
  .line 74
    if-nez v2, :L1
    move-object v2, v1
    goto :L2
  :L1
  .line 75
    iget v3, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v2, v3 }, Landroid/telephony/SubscriptionManager;->getActiveSubscriptionInfoForSimSlotIndex(I)Landroid/telephony/SubscriptionInfo;
    move-result-object v2
  :L2
  .line 76
    if-nez v2, :L3
    return-object v1
  :L3
  .line 77
    nop
  .line 78
    invoke-virtual { v2 }, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I
    move-result v2
  .line 77
    invoke-static { v2 }, Landroid/telephony/SmsManager;->getSmsManagerForSubscriptionId(I)Landroid/telephony/SmsManager;
    move-result-object v2
  .line 78
    invoke-virtual { v2 }, Landroid/telephony/SmsManager;->getSmscAddress()Ljava/lang/String;
    move-result-object v2
  .line 77
    invoke-static { v2 }, Lcom/sec/internal/google/ModernImsSms;->scaHex(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
  .line 79
    if-eqz v2, :L4
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "SMSC_RESOLVED slot="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget v4, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    const-string v4, " source=sim"
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static { v0, v3 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L4
  .line 80
    return-object v2
  :L5
  .line 81
    move-exception v2
  .line 82
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct { v3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "SMSC_SIM_FAILED slot="
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v3
    iget v4, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v3, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v3
    invoke-virtual { v3 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static { v0, v3, v2 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 83
    return-object v1
.end method

.method public acknowledgeSms(III)V
  .catchall { :L0 .. :L1 } :L2
  .registers 8
  .line 155
    const-string v0, " token="
    const-string v1, "MODERN_IMS_SMS"
  :L0
    iget-object v2, p0, Lcom/sec/internal/google/ModernImsSms;->samsung:Lcom/sec/internal/google/ImsSmsImpl;
    iget v3, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v2, v3, p1, p1, p3 }, Lcom/sec/internal/google/ImsSmsImpl;->acknowledgeSms(IIII)V
  .line 156
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "ACK slot="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " ref="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    const-string v2, " result="
    invoke-virtual { p2, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, p3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    invoke-static { v1, p2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L1
  .line 160
    goto :L3
  :L2
  .line 158
    move-exception p2
  .line 159
    new-instance p3, Ljava/lang/StringBuilder;
    invoke-direct { p3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "ACK_FAILED slot="
    invoke-virtual { p3, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p3
    iget v2, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { p3, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p3
    invoke-virtual { p3, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p3
    invoke-virtual { p3, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { v1, p1, p2 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L3
  .line 161
    return-void
.end method

.method public acknowledgeSmsReport(III)V
  .catchall { :L0 .. :L1 } :L2
  .registers 8
  .line 166
    const-string v0, " token="
    const-string v1, "MODERN_IMS_SMS"
  :L0
    iget-object v2, p0, Lcom/sec/internal/google/ModernImsSms;->samsung:Lcom/sec/internal/google/ImsSmsImpl;
    iget v3, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v2, v3, p1, p2, p3 }, Lcom/sec/internal/google/ImsSmsImpl;->acknowledgeSmsReport(IIII)V
  .line 167
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "REPORT_ACK slot="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " ref="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    const-string v2, " result="
    invoke-virtual { p2, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2, p3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p2
    invoke-virtual { p2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p2
    invoke-static { v1, p2 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L1
  .line 171
    goto :L3
  :L2
  .line 169
    move-exception p2
  .line 170
    new-instance p3, Ljava/lang/StringBuilder;
    invoke-direct { p3 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "REPORT_ACK_FAILED slot="
    invoke-virtual { p3, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p3
    iget v2, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { p3, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p3
    invoke-virtual { p3, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p3
    invoke-virtual { p3, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { v1, p1, p2 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L3
  .line 172
    return-void
.end method

.method public close()V
  .registers 3
  .line 187
    const/4 v0, 0
    iput-boolean v0, p0, Lcom/sec/internal/google/ModernImsSms;->ready:Z
  .line 188
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "CLOSE slot="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    const-string v1, "MODERN_IMS_SMS"
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 189
    return-void
.end method

.method public getSmsFormat()Ljava/lang/String;
  .catchall { :L0 .. :L1 } :L2
  .registers 4
  :L0
  .line 34
    iget-object v0, p0, Lcom/sec/internal/google/ModernImsSms;->samsung:Lcom/sec/internal/google/ImsSmsImpl;
    iget v1, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v0, v1 }, Lcom/sec/internal/google/ImsSmsImpl;->getSmsFormat(I)Ljava/lang/String;
    move-result-object v0
  :L1
    return-object v0
  :L2
  .line 35
    move-exception v0
  .line 36
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct { v1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "FORMAT_FAILED slot="
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    iget v2, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    const-string v2, "MODERN_IMS_SMS"
    invoke-static { v2, v1, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 37
    const-string v0, "3gpp"
    return-object v0
.end method

.method public onMemoryAvailable(I)V
  .catchall { :L0 .. :L1 } :L2
  .registers 6
  .line 177
    const/4 v0, -1
  :L0
    iget-object v1, p0, Lcom/sec/internal/google/ModernImsSms;->samsung:Lcom/sec/internal/google/ImsSmsImpl;
    iget v2, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    const-string v3, "3gpp"
    invoke-virtual { v1, v2, v3 }, Lcom/sec/internal/google/ImsSmsImpl;->sendRpSmma(ILjava/lang/String;)V
  .line 178
    const/4 v1, 1
    invoke-virtual { p0, p1, v1, v0 }, Lcom/sec/internal/google/ModernImsSms;->onMemoryAvailableResult(III)V
  :L1
  .line 183
    goto :L3
  :L2
  .line 179
    move-exception v1
  .line 180
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "MEMORY_FAILED slot="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v3, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " token="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    const-string v3, "MODERN_IMS_SMS"
    invoke-static { v3, v2, v1 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 181
    const/4 v1, 2
    invoke-virtual { p0, p1, v1, v0 }, Lcom/sec/internal/google/ModernImsSms;->onMemoryAvailableResult(III)V
  :L3
  .line 184
    return-void
.end method

.method public onReady()V
  .registers 3
  .line 27
    const/4 v0, 1
    iput-boolean v0, p0, Lcom/sec/internal/google/ModernImsSms;->ready:Z
  .line 28
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "READY slot="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v1, p0, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    const-string v1, "MODERN_IMS_SMS"
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 29
    return-void
.end method

.method public sendSms(IILjava/lang/String;Ljava/lang/String;Z[B)V
  .catchall { :L0 .. :L4 } :L11
  .catchall { :L5 .. :L6 } :L10
  .catchall { :L7 .. :L8 } :L9
  .registers 23
  .line 125
    move-object/from16 v7, p0
    move/from16 v15, p1
    move/from16 v14, p2
    move-object/from16 v0, p3
    move/from16 v1, p5
    move-object/from16 v2, p6
    iget-boolean v3, v7, Lcom/sec/internal/google/ModernImsSms;->ready:Z
    const-string v4, " bytes="
    const-string v13, " ref="
    const-string v12, " token="
    const-string v11, "MODERN_IMS_SMS"
    if-eqz v3, :L14
    const-string v3, "3gpp"
    invoke-virtual { v3, v0 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :L14
    if-nez v2, :L0
    move-object v1, v11
    move-object v6, v12
    move-object v5, v13
    move v3, v14
    goto/16 :L15
  :L0
  .line 134
    iget-object v3, v7, Lcom/sec/internal/google/ModernImsSms;->samsung:Lcom/sec/internal/google/ImsSmsImpl;
    iget v5, v7, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    if-eqz v1, :L1
    const/4 v6, 1
    goto :L2
  :L1
    const/4 v6, 0
  :L2
    invoke-virtual { v3, v5, v15, v6 }, Lcom/sec/internal/google/ImsSmsImpl;->setRetryCount(III)V
  .line 135
    move-object/from16 v3, p4
    invoke-direct { v7, v3 }, Lcom/sec/internal/google/ModernImsSms;->resolveSmsc(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
  .line 136
    if-nez v3, :L3
  .line 137
    const/4 v4, 2
    const/16 v5, 19
    const/4 v6, -1
    move-object/from16 v1, p0
    move/from16 v2, p1
    move/from16 v3, p2
    invoke-virtual/range { v1 .. v6 }, Lcom/sec/internal/google/ModernImsSms;->onSendSmsResultError(IIIII)V
  .line 139
    return-void
  :L3
  .line 141
    iget-object v8, v7, Lcom/sec/internal/google/ModernImsSms;->samsung:Lcom/sec/internal/google/ImsSmsImpl;
    iget v9, v7, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
  :L4
    move/from16 v10, p1
    move-object v5, v11
    move/from16 v11, p2
    move-object v6, v12
    move-object/from16 v12, p3
    move-object/from16 p4, v5
    move-object v5, v13
    move-object v13, v3
    move v3, v14
    move-object/from16 v14, p6
  :L5
    invoke-virtual/range { v8 .. v14 }, Lcom/sec/internal/google/ImsSmsImpl;->sendSms(IIILjava/lang/String;Ljava/lang/String;[B)V
  .line 142
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "SEND_DELEGATED slot="
    invoke-virtual { v0, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget v8, v7, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v0, v8 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v15 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v8, " retry="
    invoke-virtual { v0, v8 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    array-length v1, v2
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
  :L6
    move-object/from16 v1, p4
  :L7
    invoke-static { v1, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L8
  .line 149
    goto :L13
  :L9
  .line 144
    move-exception v0
    goto :L12
  :L10
    move-exception v0
    move-object/from16 v1, p4
    goto :L12
  :L11
    move-exception v0
    move-object v1, v11
    move-object v6, v12
    move-object v5, v13
    move v3, v14
  :L12
  .line 145
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "SEND_FAILED slot="
    invoke-virtual { v2, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    iget v4, v7, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v2, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v15 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static { v1, v2, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  .line 147
    const/4 v4, 3
    const/4 v5, 1
    const/4 v6, -1
    move-object/from16 v1, p0
    move/from16 v2, p1
    move/from16 v3, p2
    invoke-virtual/range { v1 .. v6 }, Lcom/sec/internal/google/ModernImsSms;->onSendSmsResultError(IIIII)V
  :L13
  .line 150
    return-void
  :L14
  .line 125
    move-object v1, v11
    move-object v6, v12
    move-object v5, v13
    move v3, v14
  :L15
  .line 126
    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct { v8 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v9, "SEND_REJECT slot="
    invoke-virtual { v8, v9 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v8
    iget v9, v7, Lcom/sec/internal/google/ModernImsSms;->phoneId:I
    invoke-virtual { v8, v9 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v8
    invoke-virtual { v8, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, v15 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v6, " ready="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    iget-boolean v6, v7, Lcom/sec/internal/google/ModernImsSms;->ready:Z
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v6, " format="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v4 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
  .line 128
    if-nez v2, :L16
    const/4 v2, -1
    goto :L17
  :L16
    array-length v2, v2
  :L17
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
  .line 126
    invoke-static { v1, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 129
    const/4 v4, 2
    const/16 v5, 14
    const/4 v6, -1
    move-object/from16 v1, p0
    move/from16 v2, p1
    move/from16 v3, p2
    invoke-virtual/range { v1 .. v6 }, Lcom/sec/internal/google/ModernImsSms;->onSendSmsResultError(IIIII)V
  .line 131
    return-void
.end method
