.class public Landroid/os/SemSystemProperties;
.super Ljava/lang/Object;

# De-Samsung stub for AOSP/LineageOS: android.os.SemSystemProperties does not exist.
# Delegate to the standard android.os.SystemProperties (present in bootclasspath).
# imsmanager.jar only calls get(String) and get(String,String).

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static get(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    invoke-static {p0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

.method public static get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    invoke-static {p0, p1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

.method public static getInt(Ljava/lang/String;I)I
    .locals 1
    invoke-static {p0, p1}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I
    move-result v0
    return v0
.end method

.method public static getBoolean(Ljava/lang/String;Z)Z
    .locals 1
    invoke-static {p0, p1}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0
.end method

.method public static getLong(Ljava/lang/String;J)J
    .locals 1
    invoke-static {p0, p1, p2}, Landroid/os/SystemProperties;->getLong(Ljava/lang/String;J)J
    move-result-wide v0
    return-wide v0
.end method
