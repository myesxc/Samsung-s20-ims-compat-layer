.class Lcom/sec/internal/google/ApBearerLatchProbe$1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.source "ApBearerLatchProbe.java"

.annotation system Ldalvik/annotation/EnclosingMethod;
  value = Lcom/sec/internal/google/ApBearerLatchProbe;->onLastCallEnded(Ljava/lang/Object;II)V
.end annotation
.annotation system Ldalvik/annotation/InnerClass;
  accessFlags = 0
  name = null
.end annotation

.field final synthetic val$generation:J

.field final synthetic val$module:Ljava/lang/Object;

.field final synthetic val$phoneId:I

.field final synthetic val$rungFinal:I

.field final synthetic val$sessionId:I

.method constructor <init>(Ljava/lang/Object;IIIJ)V
  .annotation system Ldalvik/annotation/Signature;
    value = {
      "()V"
    }
  .end annotation
  .registers 7
  .line 103
    iput-object p1, p0, Lcom/sec/internal/google/ApBearerLatchProbe$1;->val$module:Ljava/lang/Object;
    iput p2, p0, Lcom/sec/internal/google/ApBearerLatchProbe$1;->val$phoneId:I
    iput p3, p0, Lcom/sec/internal/google/ApBearerLatchProbe$1;->val$sessionId:I
    iput p4, p0, Lcom/sec/internal/google/ApBearerLatchProbe$1;->val$rungFinal:I
    iput-wide p5, p0, Lcom/sec/internal/google/ApBearerLatchProbe$1;->val$generation:J
    invoke-direct { p0 }, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public run()V
  .registers 7
  .line 106
    iget-object v0, p0, Lcom/sec/internal/google/ApBearerLatchProbe$1;->val$module:Ljava/lang/Object;
    iget v1, p0, Lcom/sec/internal/google/ApBearerLatchProbe$1;->val$phoneId:I
    iget v2, p0, Lcom/sec/internal/google/ApBearerLatchProbe$1;->val$sessionId:I
    iget v3, p0, Lcom/sec/internal/google/ApBearerLatchProbe$1;->val$rungFinal:I
    iget-wide v4, p0, Lcom/sec/internal/google/ApBearerLatchProbe$1;->val$generation:J
    invoke-static/range { v0 .. v5 }, Lcom/sec/internal/google/ApBearerLatchProbe;->access$000(Ljava/lang/Object;IIIJ)V
  .line 107
    return-void
.end method
