package com.sec.internal.google;

import android.util.Log;
import java.lang.reflect.Method;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

public final class ApSessionConvergencePoc {
    private static final String TAG="AP_SESSION_CONVERGENCE";
    private static final AtomicLong TOKENS=new AtomicLong();
    private static final ConcurrentHashMap<Integer,Long> PENDING=new ConcurrentHashMap<>();
    private ApSessionConvergencePoc(){}
    public static void onError(Object session,int callId,int error){
        long token=TOKENS.incrementAndGet();PENDING.put(callId,token);
        Log.i(TAG,"ERROR_ARM callId="+callId+" error="+error+" token="+token+" timeoutMs=2000");
        Thread t=new Thread(new ForcedCloser(session,callId,token),"ap-session-close-"+callId);t.setDaemon(true);t.start();
    }
    public static void onEnded(int callId){Long token=PENDING.remove(callId);Log.i(TAG,"ENDED_CANCEL callId="+callId+" pending="+(token!=null));}
    private static final class ForcedCloser implements Runnable{
        final Object session;final int callId;final long token;
        ForcedCloser(Object s,int c,long t){session=s;callId=c;token=t;}
        public void run(){try{Thread.sleep(2000);}catch(InterruptedException ignored){return;}Long current=PENDING.get(callId);if(current==null||current.longValue()!=token){Log.i(TAG,"FORCE_SKIP callId="+callId+" token="+token);return;}try{Method m=session.getClass().getMethod("close");m.invoke(session);Log.w(TAG,"MODERN_TERMINATION_FORCED callId="+callId+" token="+token+" action=legacy_close");}catch(Throwable e){Log.e(TAG,"FORCE_CLOSE_FAIL callId="+callId+" token="+token,e);}finally{PENDING.remove(callId,token);}}
    }
}
