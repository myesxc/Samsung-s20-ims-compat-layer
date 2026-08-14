.class final Lcom/sec/internal/google/ModernImsSms$SamsungListener;
.super Landroid/telephony/ims/aidl/IImsSmsListener$Stub;
.source "ModernImsSms.java"

.annotation system Ldalvik/annotation/EnclosingClass;
  value = Lcom/sec/internal/google/ModernImsSms;
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 18
  name = "SamsungListener"
.end annotation

.field final synthetic this$0:Lcom/sec/internal/google/ModernImsSms;

.method private constructor <init>(Lcom/sec/internal/google/ModernImsSms;)V
  .registers 2
  .line 191
    iput-object p1, p0, Lcom/sec/internal/google/ModernImsSms$SamsungListener;->this$0:Lcom/sec/internal/google/ModernImsSms;
    invoke-direct { p0 }, Landroid/telephony/ims/aidl/IImsSmsListener$Stub;-><init>()V
    return-void
.end method

.method synthetic constructor <init>(Lcom/sec/internal/google/ModernImsSms;Lcom/sec/internal/google/ModernImsSms$1;)V
  .registers 3
  .line 191
    invoke-direct { p0, p1 }, Lcom/sec/internal/google/ModernImsSms$SamsungListener;-><init>(Lcom/sec/internal/google/ModernImsSms;)V
    return-void
.end method

.method public onMemoryAvailableResult(III)V
  .registers 5
  .line 231
    iget-object v0, p0, Lcom/sec/internal/google/ModernImsSms$SamsungListener;->this$0:Lcom/sec/internal/google/ModernImsSms;
    invoke-static { v0, p1, p2, p3 }, Lcom/sec/internal/google/ModernImsSms;->access$600(Lcom/sec/internal/google/ModernImsSms;III)V
  .line 232
    return-void
.end method

.method public onReceiveSmsDeliveryReportAck(II)V
  .registers 5
  .line 225
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "DELIVERY_ACK slot="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ModernImsSms$SamsungListener;->this$0:Lcom/sec/internal/google/ModernImsSms;
    invoke-static { v1 }, Lcom/sec/internal/google/ModernImsSms;->access$300(Lcom/sec/internal/google/ModernImsSms;)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " ref="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " reason="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    const-string p2, "MODERN_IMS_SMS"
    invoke-static { p2, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 227
    return-void
.end method

.method public onSendSmsResponse(IIIIII)V
  .registers 7
  .line 207
    invoke-virtual/range { p0 .. p5 }, Lcom/sec/internal/google/ModernImsSms$SamsungListener;->onSendSmsResult(IIIII)V
  .line 208
    return-void
.end method

.method public onSendSmsResult(IIIII)V
  .registers 13
  .line 195
    const/4 v0, 1
    if-ne p3, v0, :L0
  .line 196
    iget-object v0, p0, Lcom/sec/internal/google/ModernImsSms$SamsungListener;->this$0:Lcom/sec/internal/google/ModernImsSms;
    invoke-static { v0, p1, p2 }, Lcom/sec/internal/google/ModernImsSms;->access$100(Lcom/sec/internal/google/ModernImsSms;II)V
    goto :L1
  :L0
  .line 198
    iget-object v1, p0, Lcom/sec/internal/google/ModernImsSms$SamsungListener;->this$0:Lcom/sec/internal/google/ModernImsSms;
    move v2, p1
    move v3, p2
    move v4, p3
    move v5, p4
    move v6, p5
    invoke-static/range { v1 .. v6 }, Lcom/sec/internal/google/ModernImsSms;->access$200(Lcom/sec/internal/google/ModernImsSms;IIIII)V
  :L1
  .line 200
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "SEND_RESULT slot="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ModernImsSms$SamsungListener;->this$0:Lcom/sec/internal/google/ModernImsSms;
    invoke-static { v1 }, Lcom/sec/internal/google/ModernImsSms;->access$300(Lcom/sec/internal/google/ModernImsSms;)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " token="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " ref="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p2, " status="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p3 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p2, " reason="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p2, " network="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    const-string p2, "MODERN_IMS_SMS"
    invoke-static { p2, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 203
    return-void
.end method

.method public onSmsReceived(ILjava/lang/String;[B)V
  .registers 6
  .line 219
    iget-object v0, p0, Lcom/sec/internal/google/ModernImsSms$SamsungListener;->this$0:Lcom/sec/internal/google/ModernImsSms;
    invoke-static { v0, p1, p2, p3 }, Lcom/sec/internal/google/ModernImsSms;->access$500(Lcom/sec/internal/google/ModernImsSms;ILjava/lang/String;[B)V
  .line 220
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "RECEIVED slot="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ModernImsSms$SamsungListener;->this$0:Lcom/sec/internal/google/ModernImsSms;
    invoke-static { v1 }, Lcom/sec/internal/google/ModernImsSms;->access$300(Lcom/sec/internal/google/ModernImsSms;)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " token="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " format="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p2, " bytes="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
  .line 221
    if-nez p3, :L0
    const/4 p2, -1
    goto :L1
  :L0
    array-length p2, p3
  :L1
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
  .line 220
    const-string p2, "MODERN_IMS_SMS"
    invoke-static { p2, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 222
    return-void
.end method

.method public onSmsStatusReportReceived(ILjava/lang/String;[B)V
  .registers 6
  .line 212
    iget-object v0, p0, Lcom/sec/internal/google/ModernImsSms$SamsungListener;->this$0:Lcom/sec/internal/google/ModernImsSms;
    invoke-static { v0, p1, p2, p3 }, Lcom/sec/internal/google/ModernImsSms;->access$400(Lcom/sec/internal/google/ModernImsSms;ILjava/lang/String;[B)V
  .line 213
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "STATUS_REPORT slot="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    iget-object v1, p0, Lcom/sec/internal/google/ModernImsSms$SamsungListener;->this$0:Lcom/sec/internal/google/ModernImsSms;
    invoke-static { v1 }, Lcom/sec/internal/google/ModernImsSms;->access$300(Lcom/sec/internal/google/ModernImsSms;)I
    move-result v1
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, " token="
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string v0, " format="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    const-string p2, " bytes="
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
  .line 214
    if-nez p3, :L0
    const/4 p2, -1
    goto :L1
  :L0
    array-length p2, p3
  :L1
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
  .line 213
    const-string p2, "MODERN_IMS_SMS"
    invoke-static { p2, p1 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 215
    return-void
.end method
