package com.sec.internal.google;

import android.os.Bundle;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.util.Log;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public final class ApIncomingCallBridge {
    private static final String TAG = "AP_INCOMING_BRIDGE";
    private static final long DUPLICATE_WINDOW_MS = 5000;
    private static final String CALL_WAITING_GATE =
            "persist.vendor.ims.ap_allow_call_waiting";
    private static final int BUSY_REJECT_CAUSE = 2;
    private static final ConcurrentHashMap<Integer, Object> FEATURES =
            new ConcurrentHashMap<Integer, Object>();
    private static final ConcurrentHashMap<String, Long> NOTIFIED =
            new ConcurrentHashMap<String, Long>();

    private ApIncomingCallBridge() {}

    public static void registerFeature(int slotId, Object feature) {
        if (feature != null) {
            FEATURES.put(Integer.valueOf(slotId), feature);
            Log.i(TAG, "FEATURE_REGISTER slot=" + slotId);
        }
    }

    public static void unregisterFeature(int slotId, Object feature) {
        if (feature != null) {
            FEATURES.remove(Integer.valueOf(slotId), feature);
            Log.i(TAG, "FEATURE_REMOVE slot=" + slotId);
        }
    }

    public static void notifyIncoming(Object googleService, int phoneId, int callId,
            Bundle extras) {
        try {
            Object feature = FEATURES.get(Integer.valueOf(phoneId));
            if (feature == null) {
                Log.e(TAG, "NO_FEATURE slot=" + phoneId + " callId=" + callId);
                return;
            }
            String key = phoneId + ":" + callId;
            long now = SystemClock.elapsedRealtime();
            Long previous = NOTIFIED.get(key);
            if (previous != null && now - previous.longValue() < DUPLICATE_WINDOW_MS) {
                Log.i(TAG, "DUPLICATE slot=" + phoneId + " callId=" + callId);
                return;
            }

            Integer serviceId = matchingServiceId(phoneId);
            if (serviceId == null) {
                Log.e(TAG, "NO_SERVICE slot=" + phoneId + " callId=" + callId);
                return;
            }
            Method pending = findMethod(googleService.getClass(), "getPendingCallSession",
                    int.class, String.class);
            if (pending == null) {
                Log.e(TAG, "NO_PENDING_METHOD slot=" + phoneId);
                return;
            }
            Object legacy = pending.invoke(googleService, serviceId.intValue(),
                    Integer.toString(callId));
            if (legacy == null) {
                Log.e(TAG, "NO_PENDING_SESSION slot=" + phoneId + " callId=" + callId);
                return;
            }
            int active = activeSessionCount(googleService, callId);
            boolean allowWaiting = SystemProperties.getBoolean(CALL_WAITING_GATE, false);
            if (active > 0 && !allowWaiting) {
                Method reject = findMethod(legacy.getClass(), "reject", int.class);
                if (reject != null) {
                    reject.invoke(legacy, Integer.valueOf(BUSY_REJECT_CAUSE));
                    NOTIFIED.put(key, Long.valueOf(now));
                    Log.i(TAG, "CALL_WAITING_REJECT_DEFAULT slot=" + phoneId
                            + " callId=" + callId + " active=" + active
                            + " cause=" + BUSY_REJECT_CAUSE + " allow=" + allowWaiting);
                    prune(now);
                    return;
                }
                Log.w(TAG, "CALL_WAITING_REJECT_UNAVAILABLE slot=" + phoneId
                        + " callId=" + callId + " active=" + active);
            }
            Object profile = invokeNoArgs(legacy, "getCallProfile");
            if (profile == null) {
                Log.e(TAG, "NO_PROFILE slot=" + phoneId + " callId=" + callId);
                return;
            }
            Class<?> modernClass = Class.forName(
                    "com.sec.internal.google.ModernImsCallSession");
            Object modern = constructTwoArgs(modernClass, legacy, profile);
            if (modern == null) {
                Log.e(TAG, "WRAP_FAILED slot=" + phoneId + " callId=" + callId);
                return;
            }
            Method notify = findCompatibleTwoArg(feature.getClass(), "notifyIncomingCall",
                    modern, extras == null ? new Bundle() : extras);
            if (notify == null) {
                Log.e(TAG, "NO_NOTIFY_METHOD slot=" + phoneId);
                return;
            }
            NOTIFIED.put(key, Long.valueOf(now));
            try {
                notify.invoke(feature, modern, extras == null ? new Bundle() : extras);
                Log.i(TAG, "NOTIFIED slot=" + phoneId + " callId=" + callId);
            } catch (Throwable t) {
                NOTIFIED.remove(key);
                throw t;
            }
            prune(now);
        } catch (Throwable t) {
            Log.e(TAG, "NOTIFY_FAILED slot=" + phoneId + " callId=" + callId, t);
        }
    }

    private static Integer matchingServiceId(int phoneId) throws Exception {
        Class<?> service = Class.forName("com.sec.internal.google.GoogleImsService");
        Field field = findField(service, "mServiceList");
        Object value = field == null ? null : field.get(null);
        if (!(value instanceof Map)) {
            return null;
        }
        for (Object raw : ((Map<?, ?>) value).entrySet()) {
            Map.Entry<?, ?> entry = (Map.Entry<?, ?>) raw;
            Object profile = entry.getValue();
            Object id = entry.getKey();
            Object slot = profile == null ? null : invokeNoArgs(profile, "getPhoneId");
            if (id instanceof Integer && slot instanceof Integer
                    && ((Integer) slot).intValue() == phoneId) {
                return (Integer) id;
            }
        }
        return null;
    }

    private static int activeSessionCount(Object googleService, int incomingCallId) {
        int count = 0;
        try {
            Field field = findField(googleService.getClass(), "mCallSessionList");
            Object value = field == null ? null : field.get(googleService);
            if (!(value instanceof Map)) return 0;
            for (Object raw : ((Map<?, ?>) value).entrySet()) {
                Map.Entry<?, ?> entry = (Map.Entry<?, ?>) raw;
                Object session = entry.getValue();
                if (entry.getKey() instanceof Integer
                        && ((Integer) entry.getKey()).intValue() == incomingCallId) continue;
                if (session == null) continue;
                Object samsung = session;
                Field sessionField = findField(session.getClass(), "mSession");
                if (sessionField != null) samsung = sessionField.get(session);
                if (samsung == null) continue;
                Object id = invokeNoArgs(samsung, "getCallId");
                if (id instanceof Integer && ((Integer) id).intValue() == incomingCallId) continue;
                Object state = invokeNoArgs(samsung, "getCallStateOrdinal");
                if (state instanceof Integer) {
                    int ordinal = ((Integer) state).intValue();
                    if (ordinal >= 3 && ordinal <= 11) count++;
                }
            }
        } catch (Throwable t) {
            Log.w(TAG, "ACTIVE_SCAN_FAILED", t);
        }
        return count;
    }

    private static void prune(long now) {
        for (Map.Entry<String, Long> entry : NOTIFIED.entrySet()) {
            if (now - entry.getValue().longValue() > DUPLICATE_WINDOW_MS * 2) {
                NOTIFIED.remove(entry.getKey(), entry.getValue());
            }
        }
    }

    private static Object constructTwoArgs(Class<?> type, Object first, Object second) {
        try {
            for (Constructor<?> c : type.getDeclaredConstructors()) {
                Class<?>[] p = c.getParameterTypes();
                if (p.length == 2 && p[0].isInstance(first) && p[1].isInstance(second)) {
                    c.setAccessible(true);
                    return c.newInstance(first, second);
                }
            }
        } catch (Throwable t) {
            Log.e(TAG, "CONSTRUCT_FAILED", t);
        }
        return null;
    }

    private static Method findCompatibleTwoArg(Class<?> type, String name,
            Object first, Object second) {
        for (Class<?> c = type; c != null; c = c.getSuperclass()) {
            for (Method m : c.getDeclaredMethods()) {
                Class<?>[] p = m.getParameterTypes();
                if (m.getName().equals(name) && p.length == 2
                        && p[0].isInstance(first) && p[1].isInstance(second)) {
                    m.setAccessible(true);
                    return m;
                }
            }
        }
        return null;
    }

    private static Method findMethod(Class<?> type, String name, Class<?>... args) {
        for (Class<?> c = type; c != null; c = c.getSuperclass()) {
            try {
                Method m = c.getDeclaredMethod(name, args);
                m.setAccessible(true);
                return m;
            } catch (NoSuchMethodException ignored) {
            }
        }
        return null;
    }

    private static Field findField(Class<?> type, String name) {
        for (Class<?> c = type; c != null; c = c.getSuperclass()) {
            try {
                Field f = c.getDeclaredField(name);
                f.setAccessible(true);
                return f;
            } catch (NoSuchFieldException ignored) {
            }
        }
        return null;
    }

    private static Object invokeNoArgs(Object target, String name) {
        try {
            Method m = findMethod(target.getClass(), name);
            return m == null ? null : m.invoke(target);
        } catch (Throwable t) {
            return null;
        }
    }
}
