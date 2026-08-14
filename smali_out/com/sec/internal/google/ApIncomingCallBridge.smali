.class public final Lcom/sec/internal/google/ApIncomingCallBridge;
.super Ljava/lang/Object;
.source "ApIncomingCallBridge.java"

.field private final static BUSY_REJECT_CAUSE:I = 2

.field private final static CALL_WAITING_GATE:Ljava/lang/String; = "persist.vendor.ims.ap_allow_call_waiting"

.field private final static DUPLICATE_WINDOW_MS:J = 5000L

.field private final static FEATURES:Ljava/util/concurrent/ConcurrentHashMap;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "Ljava/util/concurrent/ConcurrentHashMap<",
      "Ljava/lang/Integer;",
      "Ljava/lang/Object;",
      ">;"
    }
  .end annotation
.end field

.field private final static NOTIFIED:Ljava/util/concurrent/ConcurrentHashMap;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "Ljava/util/concurrent/ConcurrentHashMap<",
      "Ljava/lang/String;",
      "Ljava/lang/Long;",
      ">;"
    }
  .end annotation
.end field

.field private final static TAG:Ljava/lang/String; = "AP_INCOMING_BRIDGE"

.method static constructor <clinit>()V
  .registers 1
  .line 20
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;
    invoke-direct { v0 }, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApIncomingCallBridge;->FEATURES:Ljava/util/concurrent/ConcurrentHashMap;
  .line 22
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;
    invoke-direct { v0 }, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V
    sput-object v0, Lcom/sec/internal/google/ApIncomingCallBridge;->NOTIFIED:Ljava/util/concurrent/ConcurrentHashMap;
    return-void
.end method

.method private constructor <init>()V
  .registers 1
  .line 25
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method private static activeSessionCount(Ljava/lang/Object;I)I
  .catchall { :L0 .. :L10 } :L13
  .registers 6
  .line 143
    nop
  .line 145
    const/4 v0, 0
  :L0
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v1
    const-string v2, "mCallSessionList"
    invoke-static { v1, v2 }, Lcom/sec/internal/google/ApIncomingCallBridge;->findField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;
    move-result-object v1
  .line 146
    if-nez v1, :L1
    const/4 p0, 0
    goto :L2
  :L1
    invoke-virtual { v1, p0 }, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  :L2
  .line 147
    instance-of v1, p0, Ljava/util/Map;
    if-nez v1, :L3
    return v0
  :L3
  .line 148
    check-cast p0, Ljava/util/Map;
    invoke-interface { p0 }, Ljava/util/Map;->entrySet()Ljava/util/Set;
    move-result-object p0
    invoke-interface { p0 }, Ljava/util/Set;->iterator()Ljava/util/Iterator;
    move-result-object p0
  :L4
    invoke-interface { p0 }, Ljava/util/Iterator;->hasNext()Z
    move-result v1
    if-eqz v1, :L12
    invoke-interface { p0 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v1
  .line 149
    check-cast v1, Ljava/util/Map$Entry;
  .line 150
    invoke-interface { v1 }, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;
    move-result-object v2
  .line 151
    invoke-interface { v1 }, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;
    move-result-object v3
    instance-of v3, v3, Ljava/lang/Integer;
    if-eqz v3, :L5
  .line 152
    invoke-interface { v1 }, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Ljava/lang/Integer;
    invoke-virtual { v1 }, Ljava/lang/Integer;->intValue()I
    move-result v1
    if-ne v1, p1, :L5
    goto :L4
  :L5
  .line 153
    if-nez v2, :L6
    goto :L4
  :L6
  .line 154
    nop
  .line 155
    invoke-virtual { v2 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v1
    const-string v3, "mSession"
    invoke-static { v1, v3 }, Lcom/sec/internal/google/ApIncomingCallBridge;->findField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;
    move-result-object v1
  .line 156
    if-eqz v1, :L7
    invoke-virtual { v1, v2 }, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v2
  :L7
  .line 157
    if-nez v2, :L8
    goto :L4
  :L8
  .line 158
    const-string v1, "getCallId"
    invoke-static { v2, v1 }, Lcom/sec/internal/google/ApIncomingCallBridge;->invokeNoArgs(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
  .line 159
    instance-of v3, v1, Ljava/lang/Integer;
    if-eqz v3, :L9
    check-cast v1, Ljava/lang/Integer;
    invoke-virtual { v1 }, Ljava/lang/Integer;->intValue()I
    move-result v1
    if-ne v1, p1, :L9
    goto :L4
  :L9
  .line 160
    const-string v1, "getCallStateOrdinal"
    invoke-static { v2, v1 }, Lcom/sec/internal/google/ApIncomingCallBridge;->invokeNoArgs(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
  .line 161
    instance-of v2, v1, Ljava/lang/Integer;
    if-eqz v2, :L11
  .line 162
    check-cast v1, Ljava/lang/Integer;
    invoke-virtual { v1 }, Ljava/lang/Integer;->intValue()I
    move-result v1
  :L10
  .line 163
    const/4 v2, 3
    if-lt v1, v2, :L11
    const/16 v2, 11
    if-gt v1, v2, :L11
    add-int/lit8 v0, v0, 1
  :L11
  .line 165
    goto :L4
  :L12
  .line 168
    goto :L14
  :L13
  .line 166
    move-exception p0
  .line 167
    const-string p1, "AP_INCOMING_BRIDGE"
    const-string v1, "ACTIVE_SCAN_FAILED"
    invoke-static { p1, v1, p0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L14
  .line 169
    return v0
.end method

.method private static constructTwoArgs(Ljava/lang/Class;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "(",
      "Ljava/lang/Class<",
      "*>;",
      "Ljava/lang/Object;",
      "Ljava/lang/Object;",
      ")",
      "Ljava/lang/Object;"
    }
  .end annotation
  .catchall { :L0 .. :L2 } :L5
  .registers 10
  :L0
  .line 182
    invoke-virtual { p0 }, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;
    move-result-object p0
    array-length v0, p0
    const/4 v1, 0
    move v2, v1
  :L1
    if-ge v2, v0, :L4
    aget-object v3, p0, v2
  .line 183
    invoke-virtual { v3 }, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;
    move-result-object v4
  .line 184
    array-length v5, v4
    const/4 v6, 2
    if-ne v5, v6, :L3
    aget-object v5, v4, v1
    invoke-virtual { v5, p1 }, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z
    move-result v5
    if-eqz v5, :L3
    const/4 v5, 1
    aget-object v4, v4, v5
    invoke-virtual { v4, p2 }, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z
    move-result v4
    if-eqz v4, :L3
  .line 185
    invoke-virtual { v3, v5 }, Ljava/lang/reflect/Constructor;->setAccessible(Z)V
  .line 186
    new-array p0, v6, [Ljava/lang/Object;
    aput-object p1, p0, v1
    aput-object p2, p0, v5
    invoke-virtual { v3, p0 }, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object p0
  :L2
    return-object p0
  :L3
  .line 182
    add-int/lit8 v2, v2, 1
    goto :L1
  :L4
  .line 191
    goto :L6
  :L5
  .line 189
    move-exception p0
  .line 190
    const-string p1, "AP_INCOMING_BRIDGE"
    const-string p2, "CONSTRUCT_FAILED"
    invoke-static { p1, p2, p0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L6
  .line 192
    const/4 p0, 0
    return-object p0
.end method

.method private static findCompatibleTwoArg(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/reflect/Method;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "(",
      "Ljava/lang/Class<",
      "*>;",
      "Ljava/lang/String;",
      "Ljava/lang/Object;",
      "Ljava/lang/Object;",
      ")",
      "Ljava/lang/reflect/Method;"
    }
  .end annotation
  .registers 12
  .line 197
    nop
  :L0
    if-eqz p0, :L4
  .line 198
    invoke-virtual { p0 }, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;
    move-result-object v0
    array-length v1, v0
    const/4 v2, 0
    move v3, v2
  :L1
    if-ge v3, v1, :L3
    aget-object v4, v0, v3
  .line 199
    invoke-virtual { v4 }, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;
    move-result-object v5
  .line 200
    invoke-virtual { v4 }, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;
    move-result-object v6
    invoke-virtual { v6, p1 }, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v6
    if-eqz v6, :L2
    array-length v6, v5
    const/4 v7, 2
    if-ne v6, v7, :L2
    aget-object v6, v5, v2
  .line 201
    invoke-virtual { v6, p2 }, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z
    move-result v6
    if-eqz v6, :L2
    const/4 v6, 1
    aget-object v5, v5, v6
    invoke-virtual { v5, p3 }, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z
    move-result v5
    if-eqz v5, :L2
  .line 202
    invoke-virtual { v4, v6 }, Ljava/lang/reflect/Method;->setAccessible(Z)V
  .line 203
    return-object v4
  :L2
  .line 198
    add-int/lit8 v3, v3, 1
    goto :L1
  :L3
  .line 197
    invoke-virtual { p0 }, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;
    move-result-object p0
    goto :L0
  :L4
  .line 207
    const/4 p0, 0
    return-object p0
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
  .catch Ljava/lang/NoSuchFieldException; { :L1 .. :L2 } :L3
  .registers 4
  .line 223
    nop
  :L0
    if-eqz p0, :L4
  :L1
  .line 225
    invoke-virtual { p0, p1 }, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;
    move-result-object v0
  .line 226
    const/4 v1, 1
    invoke-virtual { v0, v1 }, Ljava/lang/reflect/Field;->setAccessible(Z)V
  :L2
  .line 227
    return-object v0
  :L3
  .line 228
    move-exception v0
  .line 223
    invoke-virtual { p0 }, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;
    move-result-object p0
    goto :L0
  :L4
  .line 231
    const/4 p0, 0
    return-object p0
.end method

.method private static varargs findMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "(",
      "Ljava/lang/Class<",
      "*>;",
      "Ljava/lang/String;",
      "[",
      "Ljava/lang/Class<",
      "*>;)",
      "Ljava/lang/reflect/Method;"
    }
  .end annotation
  .catch Ljava/lang/NoSuchMethodException; { :L1 .. :L2 } :L3
  .registers 5
  .line 211
    nop
  :L0
    if-eqz p0, :L4
  :L1
  .line 213
    invoke-virtual { p0, p1, p2 }, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v0
  .line 214
    const/4 v1, 1
    invoke-virtual { v0, v1 }, Ljava/lang/reflect/Method;->setAccessible(Z)V
  :L2
  .line 215
    return-object v0
  :L3
  .line 216
    move-exception v0
  .line 211
    invoke-virtual { p0 }, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;
    move-result-object p0
    goto :L0
  :L4
  .line 219
    const/4 p0, 0
    return-object p0
.end method

.method private static invokeNoArgs(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
  .catchall { :L0 .. :L3 } :L5
  .registers 6
  .line 236
    const/4 v0, 0
  :L0
    invoke-virtual { p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v1
    const/4 v2, 0
    new-array v3, v2, [Ljava/lang/Class;
    invoke-static { v1, p1, v3 }, Lcom/sec/internal/google/ApIncomingCallBridge;->findMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object p1
  .line 237
    if-nez p1, :L2
  :L1
    goto :L4
  :L2
    new-array v1, v2, [Ljava/lang/Object;
    invoke-virtual { p1, p0, v1 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
  :L3
    goto :L1
  :L4
    return-object v0
  :L5
  .line 238
    move-exception p0
  .line 239
    return-object v0
.end method

.method private static matchingServiceId(I)Ljava/lang/Integer;
  .annotation system Ldalvik/annotation/Throws;
    value = {
      Ljava/lang/Exception;
    }
  .end annotation
  .registers 6
  .line 123
    const-string v0, "com.sec.internal.google.GoogleImsService"
    invoke-static { v0 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v0
  .line 124
    const-string v1, "mServiceList"
    invoke-static { v0, v1 }, Lcom/sec/internal/google/ApIncomingCallBridge;->findField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;
    move-result-object v0
  .line 125
    const/4 v1, 0
    if-nez v0, :L0
    move-object v0, v1
    goto :L1
  :L0
    invoke-virtual { v0, v1 }, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
  :L1
  .line 126
    instance-of v2, v0, Ljava/util/Map;
    if-nez v2, :L2
  .line 127
    return-object v1
  :L2
  .line 129
    check-cast v0, Ljava/util/Map;
    invoke-interface { v0 }, Ljava/util/Map;->entrySet()Ljava/util/Set;
    move-result-object v0
    invoke-interface { v0 }, Ljava/util/Set;->iterator()Ljava/util/Iterator;
    move-result-object v0
  :L3
    invoke-interface { v0 }, Ljava/util/Iterator;->hasNext()Z
    move-result v2
    if-eqz v2, :L7
    invoke-interface { v0 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v2
  .line 130
    check-cast v2, Ljava/util/Map$Entry;
  .line 131
    invoke-interface { v2 }, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;
    move-result-object v3
  .line 132
    invoke-interface { v2 }, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;
    move-result-object v2
  .line 133
    if-nez v3, :L4
    move-object v3, v1
    goto :L5
  :L4
    const-string v4, "getPhoneId"
    invoke-static { v3, v4 }, Lcom/sec/internal/google/ApIncomingCallBridge;->invokeNoArgs(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v3
  :L5
  .line 134
    instance-of v4, v2, Ljava/lang/Integer;
    if-eqz v4, :L6
    instance-of v4, v3, Ljava/lang/Integer;
    if-eqz v4, :L6
    check-cast v3, Ljava/lang/Integer;
  .line 135
    invoke-virtual { v3 }, Ljava/lang/Integer;->intValue()I
    move-result v3
    if-ne v3, p0, :L6
  .line 136
    check-cast v2, Ljava/lang/Integer;
    return-object v2
  :L6
  .line 138
    goto :L3
  :L7
  .line 139
    return-object v1
.end method

.method public static notifyIncoming(Ljava/lang/Object;IILandroid/os/Bundle;)V
  .catchall { :L0 .. :L6 } :L22
  .catchall { :L7 .. :L15 } :L22
  .catchall { :L16 .. :L19 } :L21
  .catchall { :L20 .. :L22 } :L22
  .registers 22
  .line 44
    move-object/from16 v0, p0
    move/from16 v1, p1
    move/from16 v2, p2
    const-string v3, " callId="
    const-string v4, "AP_INCOMING_BRIDGE"
  :L0
    sget-object v5, Lcom/sec/internal/google/ApIncomingCallBridge;->FEATURES:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static/range { p1 .. p1 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v6
    invoke-virtual { v5, v6 }, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v5
  .line 45
    if-nez v5, :L1
  .line 46
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "NO_FEATURE slot="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 47
    return-void
  :L1
  .line 49
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct { v6 }, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual { v6, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v6
    const-string v7, ":"
    invoke-virtual { v6, v7 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v6
    invoke-virtual { v6 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
  .line 50
    invoke-static { }, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v7
  .line 51
    sget-object v9, Lcom/sec/internal/google/ApIncomingCallBridge;->NOTIFIED:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-virtual { v9, v6 }, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v10
    check-cast v10, Ljava/lang/Long;
  .line 52
    if-eqz v10, :L2
    invoke-virtual { v10 }, Ljava/lang/Long;->longValue()J
    move-result-wide v10
    sub-long v10, v7, v10
    const-wide/16 v12, 5000
    cmp-long v10, v10, v12
    if-gez v10, :L2
  .line 53
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "DUPLICATE slot="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 54
    return-void
  :L2
  .line 57
    invoke-static/range { p1 .. p1 }, Lcom/sec/internal/google/ApIncomingCallBridge;->matchingServiceId(I)Ljava/lang/Integer;
    move-result-object v10
  .line 58
    if-nez v10, :L3
  .line 59
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "NO_SERVICE slot="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 60
    return-void
  :L3
  .line 62
    invoke-virtual/range { p0 .. p0 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v11
    const-string v12, "getPendingCallSession"
    const/4 v13, 2
    new-array v14, v13, [Ljava/lang/Class;
    sget-object v15, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v13, 0
    aput-object v15, v14, v13
    const-class v15, Ljava/lang/String;
    const/4 v13, 1
    aput-object v15, v14, v13
    invoke-static { v11, v12, v14 }, Lcom/sec/internal/google/ApIncomingCallBridge;->findMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v11
  .line 64
    if-nez v11, :L4
  .line 65
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "NO_PENDING_METHOD slot="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 66
    return-void
  :L4
  .line 68
    const/4 v12, 2
    new-array v14, v12, [Ljava/lang/Object;
    invoke-virtual { v10 }, Ljava/lang/Integer;->intValue()I
    move-result v10
    invoke-static { v10 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v10
    const/4 v12, 0
    aput-object v10, v14, v12
  .line 69
    invoke-static/range { p2 .. p2 }, Ljava/lang/Integer;->toString(I)Ljava/lang/String;
    move-result-object v10
    aput-object v10, v14, v13
  .line 68
    invoke-virtual { v11, v0, v14 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v10
  .line 70
    if-nez v10, :L5
  .line 71
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "NO_PENDING_SESSION slot="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 72
    return-void
  :L5
  .line 74
    invoke-static { v0, v2 }, Lcom/sec/internal/google/ApIncomingCallBridge;->activeSessionCount(Ljava/lang/Object;I)I
    move-result v0
  .line 75
    const-string v11, "persist.vendor.ims.ap_allow_call_waiting"
    const/4 v12, 0
    invoke-static { v11, v12 }, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z
    move-result v11
  .line 76
    if-lez v0, :L9
    if-nez v11, :L9
  .line 77
    invoke-virtual { v10 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v12
    const-string v14, "reject"
    new-array v15, v13, [Ljava/lang/Class;
    sget-object v17, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/16 v16, 0
    aput-object v17, v15, v16
    invoke-static { v12, v14, v15 }, Lcom/sec/internal/google/ApIncomingCallBridge;->findMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v12
  :L6
  .line 78
    const-string v14, " active="
    if-eqz v12, :L8
  :L7
  .line 79
    new-array v5, v13, [Ljava/lang/Object;
    const/4 v13, 2
    invoke-static { v13 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v15
    const/4 v13, 0
    aput-object v15, v5, v13
    invoke-virtual { v12, v10, v5 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
  .line 80
    invoke-static { v7, v8 }, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;
    move-result-object v5
    invoke-virtual { v9, v6, v5 }, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
  .line 81
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "CALL_WAITING_REJECT_DEFAULT slot="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v14 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v5, " cause="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    const/4 v5, 2
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v5, " allow="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v11 }, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  .line 84
    invoke-static { v7, v8 }, Lcom/sec/internal/google/ApIncomingCallBridge;->prune(J)V
  .line 85
    return-void
  :L8
  .line 87
    new-instance v11, Ljava/lang/StringBuilder;
    invoke-direct { v11 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v12, "CALL_WAITING_REJECT_UNAVAILABLE slot="
    invoke-virtual { v11, v12 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v11
    invoke-virtual { v11, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v11
    invoke-virtual { v11, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v11
    invoke-virtual { v11, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v11
    invoke-virtual { v11, v14 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v11
    invoke-virtual { v11, v0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
  :L9
  .line 90
    const-string v0, "getCallProfile"
    invoke-static { v10, v0 }, Lcom/sec/internal/google/ApIncomingCallBridge;->invokeNoArgs(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
  .line 91
    if-nez v0, :L10
  .line 92
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "NO_PROFILE slot="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 93
    return-void
  :L10
  .line 95
    const-string v11, "com.sec.internal.google.ModernImsCallSession"
    invoke-static { v11 }, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v11
  .line 97
    invoke-static { v11, v10, v0 }, Lcom/sec/internal/google/ApIncomingCallBridge;->constructTwoArgs(Ljava/lang/Class;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
  .line 98
    if-nez v0, :L11
  .line 99
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "WRAP_FAILED slot="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 100
    return-void
  :L11
  .line 102
    invoke-virtual { v5 }, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v10
    const-string v11, "notifyIncomingCall"
  .line 103
    if-nez p3, :L12
    new-instance v12, Landroid/os/Bundle;
    invoke-direct { v12 }, Landroid/os/Bundle;-><init>()V
    goto :L13
  :L12
    move-object/from16 v12, p3
  :L13
  .line 102
    invoke-static { v10, v11, v0, v12 }, Lcom/sec/internal/google/ApIncomingCallBridge;->findCompatibleTwoArg(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/reflect/Method;
    move-result-object v10
  .line 104
    if-nez v10, :L14
  .line 105
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "NO_NOTIFY_METHOD slot="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
  .line 106
    return-void
  :L14
  .line 108
    invoke-static { v7, v8 }, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;
    move-result-object v11
    invoke-virtual { v9, v6, v11 }, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
  :L15
  .line 110
    const/4 v9, 2
  :L16
    new-array v9, v9, [Ljava/lang/Object;
    const/4 v11, 0
    aput-object v0, v9, v11
    if-nez p3, :L17
    new-instance v0, Landroid/os/Bundle;
    invoke-direct { v0 }, Landroid/os/Bundle;-><init>()V
    goto :L18
  :L17
    move-object/from16 v0, p3
  :L18
    aput-object v0, v9, v13
    invoke-virtual { v10, v5, v9 }, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
  .line 111
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct { v0 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "NOTIFIED slot="
    invoke-virtual { v0, v5 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual { v0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static { v4, v0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L19
  .line 115
    nop
  :L20
  .line 116
    invoke-static { v7, v8 }, Lcom/sec/internal/google/ApIncomingCallBridge;->prune(J)V
  .line 119
    goto :L23
  :L21
  .line 112
    move-exception v0
  .line 113
    sget-object v5, Lcom/sec/internal/google/ApIncomingCallBridge;->NOTIFIED:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-virtual { v5, v6 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
  .line 114
    throw v0
  :L22
  .line 117
    move-exception v0
  .line 118
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct { v5 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "NOTIFY_FAILED slot="
    invoke-virtual { v5, v6 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v5
    invoke-virtual { v5, v1 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v3 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1, v2 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v1
    invoke-virtual { v1 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static { v4, v1, v0 }, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
  :L23
  .line 120
    return-void
.end method

.method private static prune(J)V
  .registers 8
  .line 173
    sget-object v0, Lcom/sec/internal/google/ApIncomingCallBridge;->NOTIFIED:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-virtual { v0 }, Ljava/util/concurrent/ConcurrentHashMap;->entrySet()Ljava/util/Set;
    move-result-object v0
    invoke-interface { v0 }, Ljava/util/Set;->iterator()Ljava/util/Iterator;
    move-result-object v0
  :L0
    invoke-interface { v0 }, Ljava/util/Iterator;->hasNext()Z
    move-result v1
    if-eqz v1, :L2
    invoke-interface { v0 }, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Ljava/util/Map$Entry;
  .line 174
    invoke-interface { v1 }, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Ljava/lang/Long;
    invoke-virtual { v2 }, Ljava/lang/Long;->longValue()J
    move-result-wide v2
    sub-long v2, p0, v2
    const-wide/16 v4, 10000
    cmp-long v2, v2, v4
    if-lez v2, :L1
  .line 175
    sget-object v2, Lcom/sec/internal/google/ApIncomingCallBridge;->NOTIFIED:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-interface { v1 }, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;
    move-result-object v3
    invoke-interface { v1 }, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;
    move-result-object v1
    invoke-virtual { v2, v3, v1 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;Ljava/lang/Object;)Z
  :L1
  .line 177
    goto :L0
  :L2
  .line 178
    return-void
.end method

.method public static registerFeature(ILjava/lang/Object;)V
  .registers 4
  .line 28
    if-eqz p1, :L0
  .line 29
    sget-object v0, Lcom/sec/internal/google/ApIncomingCallBridge;->FEATURES:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    invoke-virtual { v0, v1, p1 }, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
  .line 30
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "FEATURE_REGISTER slot="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string p1, "AP_INCOMING_BRIDGE"
    invoke-static { p1, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L0
  .line 32
    return-void
.end method

.method public static unregisterFeature(ILjava/lang/Object;)V
  .registers 4
  .line 35
    if-eqz p1, :L0
  .line 36
    sget-object v0, Lcom/sec/internal/google/ApIncomingCallBridge;->FEATURES:Ljava/util/concurrent/ConcurrentHashMap;
    invoke-static { p0 }, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v1
    invoke-virtual { v0, v1, p1 }, Ljava/util/concurrent/ConcurrentHashMap;->remove(Ljava/lang/Object;Ljava/lang/Object;)Z
  .line 37
    new-instance p1, Ljava/lang/StringBuilder;
    invoke-direct { p1 }, Ljava/lang/StringBuilder;-><init>()V
    const-string v0, "FEATURE_REMOVE slot="
    invoke-virtual { p1, v0 }, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object p1
    invoke-virtual { p1, p0 }, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object p0
    invoke-virtual { p0 }, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object p0
    const-string p1, "AP_INCOMING_BRIDGE"
    invoke-static { p1, p0 }, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
  :L0
  .line 39
    return-void
.end method
