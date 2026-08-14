package com.sec.internal.google;

import android.os.SystemProperties;
import android.util.Log;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

public final class ApSaeResetPoc {
    private static final String TAG="AP_SAE_RESET";
    private static final String GATE="persist.vendor.ims.ap_sae_reset_on_last_call";
    private ApSaeResetPoc(){}
    public static void onSessionRemoved(Object module,int phoneId,int sessionId){
        boolean enabled=SystemProperties.getBoolean(GATE,false);
        try{
            Method countMethod=module.getClass().getMethod("getSessionCount");
            int count=((Integer)countMethod.invoke(module)).intValue();
            Log.i(TAG,"CHECK enabled="+enabled+" phoneId="+phoneId+" sessionId="+sessionId+" globalSessions="+count);
            if(!enabled||count!=0)return;
            Field field=findField(module.getClass(),"mMediaSvcIntf");
            Object media=field.get(module);
            if(media==null){Log.e(TAG,"SKIP media=null");return;}
            Method terminate=media.getClass().getMethod("saeTerminate");
            terminate.invoke(media);
            Log.w(TAG,"SAE_TERMINATE_COMPLETE phoneId="+phoneId+" sessionId="+sessionId+" mediaClass="+media.getClass().getName());
        }catch(Throwable e){Log.e(TAG,"SAE_TERMINATE_FAIL phoneId="+phoneId+" sessionId="+sessionId,e);}
    }
    private static Field findField(Class<?> type,String name)throws Exception{
        Class<?> c=type;
        while(c!=null){try{Field f=c.getDeclaredField(name);f.setAccessible(true);return f;}catch(NoSuchFieldException ignored){c=c.getSuperclass();}}
        throw new NoSuchFieldException(name);
    }
}
