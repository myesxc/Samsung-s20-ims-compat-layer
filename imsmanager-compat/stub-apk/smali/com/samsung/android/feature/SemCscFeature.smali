.class public Lcom/samsung/android/feature/SemCscFeature;
.super Ljava/lang/Object;

# De-Samsung stub. CSC (Country Specific Code) feature reader -> neutral defaults.

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static getInstance()Lcom/samsung/android/feature/SemCscFeature;
    .locals 1
    new-instance v0, Lcom/samsung/android/feature/SemCscFeature;
    invoke-direct {v0}, Lcom/samsung/android/feature/SemCscFeature;-><init>()V
    return-object v0
.end method

.method public getString(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    const-string v0, ""
    return-object v0
.end method

.method public getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 0
    return-object p2
.end method

.method public getString(ILjava/lang/String;)Ljava/lang/String;
    .locals 1
    const-string v0, ""
    return-object v0
.end method

.method public getString(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 0
    return-object p3
.end method

.method public getBoolean(Ljava/lang/String;)Z
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public getBoolean(Ljava/lang/String;Z)Z
    .locals 0
    return p2
.end method

.method public getBoolean(ILjava/lang/String;)Z
    .locals 1
    const/4 v0, 0x0
    return v0
.end method
