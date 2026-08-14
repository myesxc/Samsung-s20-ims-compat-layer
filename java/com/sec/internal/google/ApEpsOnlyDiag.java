package com.sec.internal.google;

import android.os.SystemClock;
import android.os.SystemProperties;
import android.util.Log;
import java.lang.reflect.Method;

public final class ApEpsOnlyDiag {
    private static final String TAG = "AP_EPS_ONLY";
    private static final String OVERRIDE_PROP = "persist.vendor.ims.ap_eps_only_override";
    private static int servicePhoneId = -1;
    private static int serviceDataReg = -1;
    private static int serviceDataNetwork = -1;
    private static boolean servicePsOnly;
    private static boolean lastOriginal;
    private static boolean lastEffective;
    private static boolean lastEnabled;
    private static int lastPhoneId = -1;
    private static int lastCallType = -1;
    private static boolean lastEmergency;
    private static int overrideCalls;
    private static long lastOverrideElapsedMs = -1;

    private ApEpsOnlyDiag() {}

    public static synchronized void onServiceState(Object wrapper, int phoneId, boolean epsOnly) {
        int dataReg = integer(wrapper, "getDataRegState");
        int dataNetwork = integer(wrapper, "getDataNetworkType");
        int voiceReg = integer(wrapper, "getVoiceRegState");
        int voiceNetwork = integer(wrapper, "getVoiceNetworkType");
        int accessNetwork = integerArg(wrapper, "getAccessNetworkTechnology", 1);
        boolean psOnly = bool(wrapper, "isPsOnlyReg");
        servicePhoneId = phoneId;
        serviceDataReg = dataReg;
        serviceDataNetwork = dataNetwork;
        servicePsOnly = psOnly;
        Log.i(TAG, "SERVICE_STATE phoneId=" + phoneId
                + " dataReg=" + dataReg
                + " dataNetwork=" + dataNetwork
                + " voiceReg=" + voiceReg
                + " voiceNetwork=" + voiceNetwork
                + " psOnly=" + psOnly
                + " accessNetwork=" + accessNetwork
                + " epsOnly=" + epsOnly
                + " elapsedMs=" + SystemClock.elapsedRealtime());
    }

    public static synchronized boolean effectiveCallSetup(int phoneId, boolean original,
            int callType, boolean emergency) {
        boolean enabled = SystemProperties.getBoolean(OVERRIDE_PROP, false);
        boolean stateMatches = phoneId == servicePhoneId;
        int dataReg = stateMatches ? serviceDataReg : -1;
        int dataNetwork = stateMatches ? serviceDataNetwork : -1;
        boolean effective = enabled && !original && callType == 1 && !emergency
                && dataReg == 0 && dataNetwork == 13 ? true : original;
        lastOriginal = original;
        lastEffective = effective;
        lastEnabled = enabled;
        lastPhoneId = phoneId;
        lastCallType = callType;
        lastEmergency = emergency;
        overrideCalls++;
        lastOverrideElapsedMs = SystemClock.elapsedRealtime();
        Log.i(TAG, "OVERRIDE phoneId=" + phoneId
                + " original=" + original
                + " effective=" + effective
                + " enabled=" + enabled
                + " callType=" + callType
                + " emergency=" + emergency
                + " dataReg=" + dataReg
                + " dataNetwork=" + dataNetwork
                + " psOnly=" + (phoneId == servicePhoneId && servicePsOnly)
                + " calls=" + overrideCalls
                + " elapsedMs=" + lastOverrideElapsedMs);
        return effective;
    }

    public static synchronized void onCallSetup(int phoneId, boolean written) {
        Log.i(TAG, "CALL_SETUP phoneId=" + phoneId
                + " written=" + written
                + " original=" + lastOriginal
                + " effective=" + lastEffective
                + " enabled=" + lastEnabled
                + " callType=" + lastCallType
                + " emergency=" + lastEmergency
                + " dataReg=" + (phoneId == servicePhoneId ? serviceDataReg : -1)
                + " dataNetwork=" + (phoneId == servicePhoneId ? serviceDataNetwork : -1)
                + " psOnly=" + (phoneId == servicePhoneId && servicePsOnly)
                + " calls=" + overrideCalls
                + " overrideElapsedMs=" + lastOverrideElapsedMs
                + " elapsedMs=" + SystemClock.elapsedRealtime());
    }

    private static int integer(Object target, String method) {
        try {
            return ((Number) target.getClass().getMethod(method).invoke(target)).intValue();
        } catch (Throwable e) {
            Log.w(TAG, "READ_FAIL method=" + method + " type=" + type(target), e);
            return -1;
        }
    }

    private static int integerArg(Object target, String method, int argument) {
        try {
            Method m = target.getClass().getMethod(method, int.class);
            return ((Number) m.invoke(target, argument)).intValue();
        } catch (Throwable e) {
            Log.w(TAG, "READ_FAIL method=" + method + " type=" + type(target), e);
            return -1;
        }
    }

    private static boolean bool(Object target, String method) {
        try {
            return (Boolean) target.getClass().getMethod(method).invoke(target);
        } catch (Throwable e) {
            Log.w(TAG, "READ_FAIL method=" + method + " type=" + type(target), e);
            return false;
        }
    }

    private static String type(Object target) {
        return target == null ? "null" : target.getClass().getName();
    }
}
