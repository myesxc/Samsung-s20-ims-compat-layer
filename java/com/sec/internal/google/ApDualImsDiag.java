package com.sec.internal.google;

import android.os.SystemClock;
import android.os.SystemProperties;
import android.util.Log;
import java.lang.reflect.Method;

public final class ApDualImsDiag {
    private static final String TAG = "AP_DUAL_IMS";
    private static final String SIM_UTIL = "com.sec.internal.helper.SimUtil";
    private static final String FLOATING = "com.samsung.android.feature.SemFloatingFeature";
    private static final String FEATURE = "SEC_FLOATING_FEATURE_COMMON_CONFIG_DUAL_IMS";
    private static final String OVERRIDE_PROP = "persist.vendor.ims.ap_dual_ims_override";
    private static int lastUaOriginal = -1;
    private static int lastUaEffective = -1;
    private static int lastUaWritten = -1;
    private static boolean overrideEnabledAtUa;
    private static int uaConfigCalls;
    private static long lastUaElapsedMs = -1;

    private ApDualImsDiag() {}

    public static synchronized void onUaConfig(int written) {
        lastUaWritten = written;
        logConfig("UA_CONFIG", written);
        logLedger("UA_LEDGER");
    }

    public static synchronized void onCallSnapshot() {
        logConfig("CALL_CONFIG", translated());
        logLedger("CALL_LEDGER");
    }

    private static void logConfig(String event, int translated) {
        int phoneCount = staticInt(SIM_UTIL, "getPhoneCount");
        String config = staticString(SIM_UTIL, "getConfigDualIMS");
        String floating = floatingFeature();
        String radio = SystemProperties.get("persist.radio.multisim.config", "");
        String mock = SystemProperties.get("persist.ims.mock.multisim", "");
        Log.i(TAG, event + " phoneCount=" + phoneCount
                + " floating=" + safe(floating)
                + " config=" + safe(config)
                + " translated=" + translated
                + " radioMultisim=" + safe(radio)
                + " mockMultisim=" + safe(mock)
                + " elapsedMs=" + SystemClock.elapsedRealtime());
    }

    public static synchronized int effectiveConfig(int original) {
        boolean enabled = SystemProperties.getBoolean(OVERRIDE_PROP, false);
        int effective = enabled && original == 0 ? 3 : original;
        lastUaOriginal = original;
        lastUaEffective = effective;
        overrideEnabledAtUa = enabled;
        uaConfigCalls++;
        lastUaElapsedMs = SystemClock.elapsedRealtime();
        Log.i(TAG, "OVERRIDE original=" + original
                + " effective=" + effective
                + " enabled=" + enabled
                + " uaConfigCalls=" + uaConfigCalls
                + " phoneCount=" + staticInt(SIM_UTIL, "getPhoneCount")
                + " config=" + safe(staticString(SIM_UTIL, "getConfigDualIMS"))
                + " elapsedMs=" + lastUaElapsedMs);
        return effective;
    }

    private static void logLedger(String event) {
        Log.i(TAG, event
                + " lastUaOriginal=" + lastUaOriginal
                + " lastUaEffective=" + lastUaEffective
                + " lastUaWritten=" + lastUaWritten
                + " overrideEnabledAtUa=" + overrideEnabledAtUa
                + " uaConfigCalls=" + uaConfigCalls
                + " uaElapsedMs=" + lastUaElapsedMs
                + " nowElapsedMs=" + SystemClock.elapsedRealtime());
    }

    private static int translated() {
        try {
            Class<?> type = Class.forName("com.sec.internal.ims.core.handler.secims.StackRequestBuilderUtil");
            Method method = type.getDeclaredMethod("translateConfigDualIms");
            method.setAccessible(true);
            return ((Number) method.invoke(null)).intValue();
        } catch (Throwable e) {
            Log.w(TAG, "READ_FAIL translateConfigDualIms", e);
            return -1;
        }
    }

    private static int staticInt(String className, String method) {
        try {
            return ((Number) Class.forName(className).getMethod(method).invoke(null)).intValue();
        } catch (Throwable e) {
            Log.w(TAG, "READ_FAIL class=" + className + " method=" + method, e);
            return -1;
        }
    }

    private static String staticString(String className, String method) {
        try {
            Object value = Class.forName(className).getMethod(method).invoke(null);
            return value == null ? "<null>" : String.valueOf(value);
        } catch (Throwable e) {
            Log.w(TAG, "READ_FAIL class=" + className + " method=" + method, e);
            return "<error>";
        }
    }

    private static String floatingFeature() {
        try {
            Class<?> type = Class.forName(FLOATING);
            Object instance = type.getMethod("getInstance").invoke(null);
            Method getString = type.getMethod("getString", String.class);
            Object value = getString.invoke(instance, FEATURE);
            return value == null ? "<null>" : String.valueOf(value);
        } catch (Throwable e) {
            Log.w(TAG, "READ_FAIL floatingFeature", e);
            return "<error>";
        }
    }

    private static String safe(String value) {
        if (value == null) return "<null>";
        return value.replace(' ', '_');
    }
}
