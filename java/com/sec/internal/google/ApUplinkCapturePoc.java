package com.sec.internal.google;

import android.content.Context;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.util.Log;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;

public final class ApUplinkCapturePoc {
    private static final String TAG="AP_UPLINK_CAPTURE";
    private static final ConcurrentHashMap<Integer,Capture> ACTIVE=new ConcurrentHashMap<>();
    private ApUplinkCapturePoc(){}
    public static void onEstablished(int callId){if(!SystemProperties.getBoolean("persist.vendor.ims.ap_uplink_capture",false))return;Capture c=new Capture(callId);Capture old=ACTIVE.put(callId,c);if(old!=null)old.stop("replace");c.start();}
    public static void onEnded(int callId){stop(callId,"ended");}
    public static void onError(int callId){stop(callId,"error");}
    private static void stop(int callId,String why){Capture c=ACTIVE.remove(callId);if(c!=null)c.stop(why);}
    static int source(String s){if("mic".equals(s))return MediaRecorder.AudioSource.MIC;if("voice_communication".equals(s))return MediaRecorder.AudioSource.VOICE_COMMUNICATION;if("voice_uplink".equals(s))return MediaRecorder.AudioSource.VOICE_UPLINK;return -1;}
    static int clamp(int x,int lo,int hi){return Math.max(lo,Math.min(hi,x));}
    static final class Capture {
        final int callId;final AtomicBoolean running=new AtomicBoolean(true);volatile AudioRecord record;volatile Thread thread;
        Capture(int id){callId=id;}
        void start(){thread=new Thread(this::run,"ap-uplink-capture-"+callId);thread.setDaemon(true);thread.start();}
        void run(){String requested=SystemProperties.get("persist.vendor.ims.ap_uplink_source","mic");int src=source(requested);int seconds=clamp(SystemProperties.getInt("persist.vendor.ims.ap_uplink_seconds",10),1,30);int maxBytes=clamp(SystemProperties.getInt("persist.vendor.ims.ap_uplink_bytes",320000),3200,960000);boolean fileEnabled=SystemProperties.getBoolean("persist.vendor.ims.ap_uplink_file",false);BufferedOutputStream out=null;long reads=0,bytes=0,zero=0,nonzero=0,sumSquares=0,firstNonzeroMs=-1;int peak=0,errors=0;long started=SystemClock.elapsedRealtime();try{
            if(src<0)throw new IllegalArgumentException("unsupported source="+requested);
            String negotiated=ApMediaNegotiationPoc.uniqueReady();
            int min=AudioRecord.getMinBufferSize(16000,AudioFormat.CHANNEL_IN_MONO,AudioFormat.ENCODING_PCM_16BIT);if(min<=0)throw new IllegalStateException("minBuffer="+min);int buffer=Math.max(6400,min*2);
            record=new AudioRecord(src,16000,AudioFormat.CHANNEL_IN_MONO,AudioFormat.ENCODING_PCM_16BIT,buffer);if(record.getState()!=AudioRecord.STATE_INITIALIZED)throw new IllegalStateException("uninitialized");
            AudioManager am=null;try{am=(AudioManager)Class.forName("android.app.ActivityThread").getMethod("currentApplication").invoke(null).getClass().getMethod("getSystemService",String.class).invoke(Class.forName("android.app.ActivityThread").getMethod("currentApplication").invoke(null),Context.AUDIO_SERVICE);}catch(Throwable ignored){}
            int mode=am==null?-1:am.getMode();String routed="null";try{Object d=record.getRoutedDevice();routed=String.valueOf(d);}catch(Throwable ignored){}
            if(fileEnabled)try{File dir=new File("/data/vendor/ims");if(!dir.exists()&&!dir.mkdirs())throw new IllegalStateException("mkdir "+dir);out=new BufferedOutputStream(new FileOutputStream(new File(dir,"desem26_call_"+callId+"_"+requested+".pcm"),false));}catch(Throwable e){Log.w(TAG,"FILE_DISABLED callId="+callId+" path=/data/vendor/ims",e);out=null;fileEnabled=false;}
            Log.i(TAG,"START callId="+callId+" source="+requested+" sourceId="+src+" seconds="+seconds+" maxBytes="+maxBytes+" buffer="+buffer+" mode="+mode+" routed="+routed+" file="+fileEnabled+" rtpSend=false negotiated="+negotiated);
            record.startRecording();if(record.getRecordingState()!=AudioRecord.RECORDSTATE_RECORDING)throw new IllegalStateException("not recording");byte[] b=new byte[buffer];long deadline=started+seconds*1000L;
            while(running.get()&&SystemClock.elapsedRealtime()<deadline&&bytes<maxBytes){int want=(int)Math.min(b.length,maxBytes-bytes);int n=record.read(b,0,want);if(n<0){errors++;Log.w(TAG,"READ_ERROR callId="+callId+" code="+n);continue;}if(n==0)continue;reads++;bytes+=n;if(out!=null)out.write(b,0,n);for(int i=0;i+1<n;i+=2){int sample=(short)((b[i]&255)|(b[i+1]<<8));int a=Math.abs(sample);if(a==0)zero++;else{nonzero++;if(firstNonzeroMs<0)firstNonzeroMs=SystemClock.elapsedRealtime()-started;}if(a>peak)peak=a;sumSquares+=(long)sample*sample;}}
        }catch(Throwable e){Log.e(TAG,"FAIL callId="+callId,e);}finally{running.set(false);AudioRecord r=record;record=null;if(r!=null){try{r.stop();}catch(Throwable ignored){}try{r.release();}catch(Throwable ignored){}}if(out!=null)try{out.flush();out.close();}catch(Throwable ignored){}long samples=zero+nonzero;long rms=samples==0?0:(long)Math.sqrt((double)sumSquares/samples);Log.i(TAG,"STOP callId="+callId+" reads="+reads+" bytes="+bytes+" zeroSamples="+zero+" nonzeroSamples="+nonzero+" peak="+peak+" rms="+rms+" firstNonzeroMs="+firstNonzeroMs+" errors="+errors+" rtpSend=false");ACTIVE.remove(callId,this);}}
        void stop(String why){if(running.getAndSet(false)){AudioRecord r=record;if(r!=null)try{r.stop();}catch(Throwable ignored){}Thread t=thread;if(t!=null&&t!=Thread.currentThread())try{t.join(1500);}catch(InterruptedException e){Thread.currentThread().interrupt();}Log.i(TAG,"STOP_REQUEST callId="+callId+" reason="+why);}}
    }
}
