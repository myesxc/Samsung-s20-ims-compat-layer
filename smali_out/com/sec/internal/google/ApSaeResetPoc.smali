.class public final Lcom/sec/internal/google/ApSaeResetPoc;
.super Ljava/lang/Object;
.source "ApSaeResetPoc.java"

.field private final static GATE:Ljava/lang/String; = "persist.vendor.ims.ap_sae_reset_on_last_call"

.field private final static TAG:Ljava/lang/String; = "AP_SAE_RESET"

.method private constructor <init>()V
  .registers 1
  .line 11
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method private static findField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "(",
      "Ljava/lang/Class<",
      "*>;",
      "Ljava/lang/String;",
      ")",
      "Ljava/lang/reflect/Field;"
    }
  .end annotation
  .annotation system Ldalvik/annotation/Throws;
    value = {
      Ljava/lang/Exception;
    }
  .end annotation
  .catch Ljava/lang/NoSuchFieldException; { :L1 .. :L2 } :L3
  .registers 4
  .line 28
    nop
  :L0
  .line 29
    if-eqz p0, :L4
  :L1
    invoke-virtual { p0, p1 }, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;
    move-result-object v0
    const/4 v1, 1
    invoke-virtual { v0, v1 }, Ljava/lang/reflect/Field;->setAccessible(Z)V
  :L2
    return-object v0
  :L3
    move-exception v0
    invoke-virtual { p0 }, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;
    move-result-object p0
    goto :L0
  :L4
  .line 30
    new-instance p0, Ljava/lang/NoSuchFieldException;
    invoke-direct { p0, p1 }, Ljava/lang/NoSuchFieldException;-><init>(Ljava/lang/String;)V
    throw p0
.end method

.method public static onSessionRemoved(Ljava/lang/Object;II)V
  .catchall { :L0 .. :L3 } :L5
  .registers 10
  .line 13
    const-string v0, " sessionId="
    const-string v1, "AP_SAE_RESET"
    const-string v2, "persist.vendor.ims.ap_sae_reset_on_last_call"
    const/4 v3, 0
    invoke-static { v2, v3 }, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
  :L0
  .line 15
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v4
    const-string v5, "getSessionCount"
    new-array v6, v3, [Ljava/lang/Class;
    invoke-virtual { v4, v5, v6 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v4
  .line 16
    new-array v5, v3, [Ljava/lang/Object;
    invoke-virtual { v4, p0, v5 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Ljava/lang/Integer;
    invoke-virtual { v4 }, Ljava/lang/Integer;->intValue()I
    move-result v4
  .line 17
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "CHECK enabled="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v2 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v6, " phoneId="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    const-string v6, " globalSessions="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v4 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static { v1, v5 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 18
    if-eqz v2, :L4
    if-eqz v4, :L1
    goto :L4
  :L1
  .line 19
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v2
    const-string v4, "mMediaSvcIntf"
    invoke-static { v2, v4 }, Lcom/sec/internal/google/ApSaeResetPoc;->findField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;
    move-result-object v2
  .line 20
    invoke-virtual { v2, p0 }, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  .line 21
    if-nez p0, :L2
    const-string p0, "SKIP media=null"
    invoke-static { v1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    return-void
  :L2
  .line 22
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v2
    const-string v4, "saeTerminate"
    new-array v5, v3, [Ljava/lang/Class;
    invoke-virtual { v2, v4, v5 }, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v2
  .line 23
    new-array v3, v3, [Ljava/lang/Object;
    invoke-virtual { v2, p0, v3 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
  .line 24
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "SAE_TERMINATE_COMPLETE phoneId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v2
    const-string v3, " mediaClass="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object p0
    invoke-virtual { v2, p0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    invoke-static { v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L3
  .line 25
    goto :L6
  :L4
  .line 18
    return-void
  :L5
  .line 25
    move-exception p0
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct { v2 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "SAE_TERMINATE_FAIL phoneId="
    invoke-virtual { v2, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v2
    invoke-virtual { v2, p1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p1
    invoke-static { v1, p1, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L6
  .line 26
    return-void
.end method
