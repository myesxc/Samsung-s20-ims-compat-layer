package com.sec.internal.google;

import android.os.SystemClock;
import android.util.Log;
import java.lang.reflect.Method;
import java.util.concurrent.atomic.AtomicLong;

public final class ApDedicatedBearerPoc {
    private static final String TAG="AP_QCI_LEDGER";
    private static final AtomicLong SEQ=new AtomicLong();
    private ApDedicatedBearerPoc(){}
    public static void onRaw(int state,int qci,int sessionId){
        Log.i(TAG,"QCI_EVENT seq="+SEQ.incrementAndGet()+" stage=RAW sessionId="+sessionId+" qci="+qci+" state="+state+" elapsedMs="+SystemClock.elapsedRealtime()+" thread="+Thread.currentThread().getName());
    }
    public static void onModule(Object session,Object event){
        try{
            int sessionId=integer(event,"getBearerSessionId");
            int qci=integer(event,"getQci");
            int state=integer(event,"getBearerState");
            int phoneId=optionalInteger(session,"getPhoneId",-1);
            int callState=optionalInteger(session,"getCallStateOrdinal",-1);
            Log.i(TAG,"QCI_EVENT seq="+SEQ.incrementAndGet()+" stage=MODULE phoneId="+phoneId+" sessionId="+sessionId+" qci="+qci+" state="+state+" callState="+callState+" elapsedMs="+SystemClock.elapsedRealtime()+" thread="+Thread.currentThread().getName());
        }catch(Throwable e){Log.e(TAG,"QCI_EVENT_FAIL stage=MODULE",e);}
    }
    private static int integer(Object target,String name)throws Exception{return ((Integer)target.getClass().getMethod(name).invoke(target)).intValue();}
    private static int optionalInteger(Object target,String name,int fallback){try{return integer(target,name);}catch(Throwable ignored){return fallback;}}
}
