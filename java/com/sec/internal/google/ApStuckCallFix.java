package com.sec.internal.google;

import android.os.SystemProperties;
import android.telephony.ims.ImsReasonInfo;
import android.util.Log;

/**
 * desem48 stuck-call fix.
 *
 * When the second call in a registration session fails, the Samsung stack emits
 * callSessionInitiatingFailed and then stops. The framework treats that as "the
 * dial attempt failed" but still waits for a terminal event before it will move
 * the Telecom call out of DISCONNECTING. Nothing ever sends one, so TC@2 sits in
 * DISCONNECTING forever: the user cannot hang up, and no further call can be
 * placed. Log evidence (desem47 20:09:04.463): the relay queues exactly one
 * event, callSessionInitiatingFailed, and reports "terminal delivery complete",
 * whereas a healthy call-1 teardown queues callSessionTerminated.
 *
 * This helper decides whether to synthesise the missing callSessionTerminated.
 * It is deliberately conservative: it fires only for the initiating-failed path,
 * only once per session, and can be disabled at runtime. That matters because
 * the same failure is the experiment's dependent variable - the fix must clear
 * the stuck call without masking whether the bearer arrived.
 */
public final class ApStuckCallFix {
    private static final String TAG = "AP_STUCK_CALL_FIX";
    private static final String GATE = "persist.vendor.ims.ap_stuck_call_fix";

    private ApStuckCallFix() {}

    /**
     * @return true if the caller should follow up with callSessionTerminated.
     */
    public static boolean shouldSynthesiseTerminated(String event, boolean alreadyClosing) {
        boolean enabled = SystemProperties.getBoolean(GATE, true);
        if (!enabled) {
            Log.i(TAG, "DISABLED gate=false event=" + event);
            return false;
        }
        if (!"callSessionInitiatingFailed".equals(event)) {
            return false;
        }
        if (alreadyClosing) {
            Log.i(TAG, "SKIP session already closing event=" + event);
            return false;
        }
        Log.w(TAG, "SYNTHESISE callSessionTerminated after " + event
                + " - framework would otherwise strand the call in DISCONNECTING");
        return true;
    }

    /** Reason carried on the synthesised terminal event. */
    public static ImsReasonInfo terminalReason(ImsReasonInfo original) {
        if (original != null) {
            Log.i(TAG, "REASON reusing code=" + original.getCode()
                    + " extra=" + original.getExtraCode());
            return original;
        }
        Log.i(TAG, "REASON original=null, using CODE_UNSPECIFIED");
        return new ImsReasonInfo(ImsReasonInfo.CODE_UNSPECIFIED, 0, "synthesised terminal");
    }
}
