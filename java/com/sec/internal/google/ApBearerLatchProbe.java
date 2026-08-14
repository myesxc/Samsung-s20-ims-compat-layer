package com.sec.internal.google;

import android.os.SystemClock;
import android.os.SystemProperties;
import android.util.Log;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * desem48 bearer-latch gradient probe.
 *
 * Question: the modem QoS flow counter only advances across a re-registration
 * (GSI froze at 92/93 then 153/154 in three runs, while stock stepped +61 per
 * call). The 92/93 -> 153/154 transition happened when a re-registration AND a
 * radio power cycle occurred together, so neither can be credited alone.
 *
 * This probe fires a chosen reset rung after call 1 ends, WITHOUT touching the
 * radio. If the flow counter then advances and call 2 gets its dedicated
 * bearer, the latch is bound to the IMS registration session. If it stays
 * frozen, the latch lives below IMS, in the modem bearer context, and only
 * setRadioPower can clear it.
 *
 * Rungs (persist.vendor.ims.ap_latch_probe_rung):
 *   0  off (control)
 *   1  sendReRegister(phoneId, pdnType) - SIP re-REGISTER only, PDN kept
 *   2  deregister + register - full 401-challenged cycle, PDN kept
 *   3  stopPdnConnectivity - tear the IMS PDN down, radio untouched
 *   4  airplane-mode radio cycle (stable fallback)
 *   5  explicit IMS PDN stop/start rebuild
 *   6  direct TelephonyManager.setRadioPower cycle (no airplane setting/broadcast)
 *
 * Everything is reflection-guarded: a missing method logs and returns instead
 * of throwing into the Samsung state machine. desem35 shipped a rung whose
 * method name did not exist (saeTerminate) and it threw on every invocation,
 * so that hypothesis was never actually tested. Every lookup here logs its
 * resolved signature so a silent no-op can never again be mistaken for a
 * negative result.
 */
public final class ApBearerLatchProbe {
    private static final String TAG = "AP_LATCH_PROBE";
    private static final String RUNG_PROP = "persist.vendor.ims.ap_latch_probe_rung";
    private static final String DELAY_PROP = "persist.vendor.ims.ap_latch_probe_delay_ms";
    private static final String PDN_TYPE_PROP = "persist.vendor.ims.ap_latch_probe_pdn_type";
    private static final String REREG_DELAY_PROP = "persist.vendor.ims.ap_latch_probe_rereg_delay_ms";
    private static final String RADIO_DWELL_PROP = "persist.vendor.ims.ap_latch_probe_radio_dwell_ms";
    private static final String PDN_GAP_PROP = "persist.vendor.ims.ap_latch_probe_pdn_gap_ms";

    /**
     * A 0 ms dwell reproduced "remote rings, local still dialling", but 100 ms was
     * verified sufficient on device - the radio state change is asynchronous, so the
     * toggle only has to be delivered, not completed.
     */
    private static final int MIN_RADIO_DWELL_MS = 200;

    /** PdnController type 11 = IMS, as seen in RegiMgr "isPdnConnected: false, PdnType: 11". */
    private static final int DEFAULT_PDN_TYPE = 11;

    private static int fireCount;
    private static boolean quiet;
    private static long lastFireElapsed = -1;
    private static long guardGeneration;
    private static boolean formalCallEntered;
    private static int formalSessionId = -1;
    private static final int ALL_CALLS_DEBOUNCE_MS = 1000;

    private ApBearerLatchProbe() {}

    public static synchronized void onCallEstablished(int sessionId) {
        formalCallEntered = true;
        formalSessionId = sessionId;
        Log.i(TAG, "FORMAL_CALL_ENTERED sessionId=" + sessionId);
    }

    public static synchronized void onCallEstablished(Object module, int sessionId) {
        onCallEstablished(sessionId);
    }

    /** Called from VolteServiceModule.onCallEnded once no sessions remain. */
    public static synchronized void onLastCallEnded(final Object module, final int phoneId,
            final int sessionId) {
        int rung = ApMediaConfigPoc.integer("ap_latch_probe_rung", 6, 0, 6);
        boolean requireFormalCall = rung != 6;
        if (requireFormalCall && !formalCallEntered) {
            Log.i(TAG, "RUNG4_SKIP reason=no_formal_call sessionId=" + sessionId);
            return;
        }
        Log.i(TAG, "CHECK rung=" + rung + " phoneId=" + phoneId + " sessionId=" + sessionId
                + " fireCount=" + fireCount + " formalSessionId=" + formalSessionId);
        if (rung <= 0) {
            Log.i(TAG, "DISABLED rung=0 - control run, no reset attempted");
            return;
        }

        // This runs on the Samsung state-machine thread. Blocking it stalls call
        // teardown and trips the watchdog, so hand the work to a throwaway thread
        // and return immediately.
        final int rungFinal = rung;
        final long generation;
        synchronized (ApBearerLatchProbe.class) {
            generation = ++guardGeneration;
        }
        Thread worker = new Thread(new Runnable() {
            @Override
            public void run() {
                waitForAllCallsEnded(module, phoneId, sessionId, rungFinal, generation);
            }
        }, "desem48-latch-guard");
        worker.setDaemon(true);
        worker.start();
        Log.i(TAG, "DISPATCHED rung=" + rung + " to worker thread");
    }

    private static void waitForAllCallsEnded(Object module, int phoneId, int sessionId,
            int rung, long generation) {
        int active;
        for (;;) {
            synchronized (ApBearerLatchProbe.class) {
                if (generation != guardGeneration) {
                    Log.i(TAG, "RUNG4_DEFER stale_generation=" + generation);
                    return;
                }
            }
            active = liveSessionCount(module);
            if (active == 0) break;
            Log.i(TAG, "RUNG4_WAIT activeSessions=" + active + " sessionId=" + sessionId);
            try { Thread.sleep(500); } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return;
            }
        }
        Log.i(TAG, "RUNG4_ALL_CALLS_ENDED sessionId=" + sessionId);
        try { Thread.sleep(ALL_CALLS_DEBOUNCE_MS); } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return;
        }
        synchronized (ApBearerLatchProbe.class) {
            if (generation != guardGeneration) {
                Log.i(TAG, "RUNG4_DEFER stale_after_debounce=" + generation);
                return;
            }
        }
        if (liveSessionCount(module) != 0) {
            Log.i(TAG, "RUNG4_DEFER call_returned_during_debounce");
            return;
        }
        Log.i(TAG, "RUNG4_FIRE_ALLOWED all_calls_ended=true");
        synchronized (ApBearerLatchProbe.class) {
            if (rung != 6 && (!formalCallEntered || liveSessionCount(module) != 0)) {
                Log.i(TAG, "RUNG4_DEFER formal_or_sessions_changed");
                return;
            }
            if (rung != 6) {
                formalCallEntered = false;
                Log.i(TAG, "FORMAL_CALL_EXITED sessionId=" + formalSessionId);
            }
        }
        fire(module, phoneId, sessionId, rung);
    }

    private static int liveSessionCount(Object module) {
        try {
            Object manager = field(module, "mImsCallSessionManager");
            Object map = manager == null ? null : field(manager, "mSessionMap");
            if (!(map instanceof java.util.Map)) return 0;
            int count = 0;
            for (Object raw : ((java.util.Map<?, ?>) map).values()) {
                Object state = call(raw, "getCallState");
                String name = state == null ? "" : String.valueOf(state);
                if (!"EndedCall".equals(name) && !"EndingCall".equals(name)
                        && !"Idle".equals(name)) count++;
            }
            return count;
        } catch (Throwable t) {
            Log.w(TAG, "RUNG4_SESSION_SCAN_FAILED", t);
            return 1;
        }
    }

    private static Object field(Object target, String name) {
        try {
            for (Class<?> c = target.getClass(); c != null; c = c.getSuperclass()) {
                try {
                    Field f = c.getDeclaredField(name);
                    f.setAccessible(true);
                    return f.get(target);
                } catch (NoSuchFieldException ignored) {}
            }
        } catch (Throwable ignored) {}
        return null;
    }

    private static void fire(Object module, int phoneId, int sessionId, int rung) {
        int delayMs = ApMediaConfigPoc.integer("ap_latch_probe_delay_ms", 1500, 0, 60000);
        if (delayMs > 0) {
            try {
                Thread.sleep(delayMs);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }

        Object regiMgr = findRegistrationManager(module, phoneId);
        if (regiMgr == null) {
            Log.e(TAG, "ABORT could not resolve registration manager - rung " + rung + " not attempted");
            return;
        }
        Log.i(TAG, "REGIMGR class=" + regiMgr.getClass().getName());

        fireCount++;
        lastFireElapsed = SystemClock.elapsedRealtime();
        int pdnType = SystemProperties.getInt(PDN_TYPE_PROP, DEFAULT_PDN_TYPE);
        int setupDataCallsBefore = rung >= 4 ? countLogMatches("SETUP_DATA_CALL") : -1;

        switch (rung) {
            case 1:
                rungReRegister(regiMgr, phoneId, pdnType);
                break;
            case 2:
                rungDeregisterProfile(regiMgr, phoneId, pdnType);
                break;
            case 3:
                rungStopPdn(regiMgr, phoneId, pdnType);
                break;
            case 4:
                rungRadioCycle(phoneId);
                break;
            case 5:
                rungPdnRebuild(phoneId, pdnType);
                break;
            case 6:
                rungDirectRadioCycle(phoneId);
                break;
            default:
                Log.e(TAG, "UNKNOWN rung=" + rung);
                break;
        }

        verifyRegistrationMoved(phoneId, rung, setupDataCallsBefore);
    }

    /**
     * Confirm the rung actually did something observable.
     *
     * Three rungs have now been reported as "returned normally" while doing nothing:
     * a wrong method name (desem35), an unresolvable manager (v3/v4), and a pdnType
     * filter that matches no task. So the probe self-certifies rather than leaving it
     * to log archaeology afterwards.
     *
     * What counts as evidence differs per rung, and getting this wrong is itself a
     * trap: v6 watched the registration handle and reported NO_CHANGE for rung 1 even
     * though a REGISTER had gone out 23 ms earlier. The handle only changes on a full
     * deregister/register cycle (verified: 19525 -> 32502 across SIM removal), so a
     * refresh re-REGISTER legitimately keeps it. Rung 1 must therefore be judged on
     * whether a REGISTER was actually transmitted, not on handle movement.
     */
    private static void verifyRegistrationMoved(int phoneId, int rung, int setupDataCallsBefore) {
        // Rungs 4 and 5 rebuild the data bearer rather than the SIP session, so the
        // proof is a SETUP_DATA_CALL reaching the RIL. Capture the baseline before
        // firing: PDN setup can finish before this worker reaches verification.
        if (rung >= 4) {
            verifyPdnRebuilt(rung, setupDataCallsBefore);
            return;
        }
        String before = registrationFingerprint(phoneId);
        int registersBefore = countRegisterSends();
        Log.i(TAG, "VERIFY_BEFORE " + before + " registerSends=" + registersBefore);

        for (int i = 0; i < 12; i++) {
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return;
            }
            int elapsed = (i + 1) * 500;

            // Rung 1 refreshes an existing registration: a transmitted REGISTER is
            // the proof, and the handle is expected to stay put.
            int sends = countRegisterSends();
            if (sends > registersBefore) {
                Log.w(TAG, "VERIFY_REGISTER_SENT rung=" + rung + " after " + elapsed
                        + "ms: " + (sends - registersBefore) + " outbound REGISTER(s)"
                        + " - the rung DID execute");
                return;
            }

            // Rungs 2 and 3 tear the session down, so the handle should move.
            String now = registrationFingerprint(phoneId);
            if (!now.equals(before)) {
                Log.w(TAG, "VERIFY_MOVED rung=" + rung + " after " + elapsed
                        + "ms: " + before + " -> " + now);
                return;
            }
        }
        Log.e(TAG, "VERIFY_NO_CHANGE rung=" + rung + " no REGISTER sent and registration"
                + " unchanged after 6s (" + before + ") - the rung was a NO-OP,"
                + " not a negative result");
    }

    /** Watch for the RIL actually being asked to rebuild a data call. */
    private static void verifyPdnRebuilt(int rung, int before) {
        if (before < 0) {
            Log.e(TAG, "VERIFY_NO_PDN rung=" + rung + " could not establish the pre-fire"
                    + " SETUP_DATA_CALL baseline");
            return;
        }
        Log.i(TAG, "VERIFY_BEFORE setupDataCalls=" + before);
        for (int i = 0; i < 20; i++) {
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return;
            }
            int now = countLogMatches("SETUP_DATA_CALL");
            if (now > before) {
                Log.w(TAG, "VERIFY_PDN_REBUILT rung=" + rung + " after " + ((i + 1) * 500)
                        + "ms: " + (now - before) + " new SETUP_DATA_CALL - the rung DID execute");
                return;
            }
        }
        Log.e(TAG, "VERIFY_NO_PDN rung=" + rung + " no SETUP_DATA_CALL in 10s -"
                + " the request never reached the RIL, the same failure mode as rung 3");
    }

    private static int countLogMatches(String needle) {
        java.io.BufferedReader r = null;
        try {
            Process p = new ProcessBuilder("logcat", "-b", "all", "-d", "-t", "600")
                    .redirectErrorStream(true).start();
            r = new java.io.BufferedReader(new java.io.InputStreamReader(p.getInputStream()));
            String line;
            int n = 0;
            while ((line = r.readLine()) != null) {
                if (line.contains(needle)) {
                    n++;
                }
            }
            return n;
        } catch (Throwable e) {
            return -1;
        } finally {
            if (r != null) {
                try {
                    r.close();
                } catch (java.io.IOException ignored) {
                    // nothing useful to do
                }
            }
        }
    }

    /**
     * Count outbound REGISTER requests the stack has logged. Reading our own logcat is
     * crude, but it is the only signal available in-process that distinguishes "a
     * REGISTER went out" from "the call returned without doing anything".
     */
    private static int countRegisterSends() {
        java.io.BufferedReader r = null;
        try {
            Process p = new ProcessBuilder(
                    "logcat", "-b", "all", "-d", "-t", "400", "-s", "SIPMSG[0]")
                    .redirectErrorStream(true).start();
            r = new java.io.BufferedReader(new java.io.InputStreamReader(p.getInputStream()));
            String line;
            int n = 0;
            while ((line = r.readLine()) != null) {
                if (line.contains("[-->] REGISTER sip:")) {
                    n++;
                }
            }
            return n;
        } catch (Throwable e) {
            Log.i(TAG, "VERIFY_NOTE cannot read logcat (" + e + "), falling back to handle only");
            return -1;
        } finally {
            if (r != null) {
                try {
                    r.close();
                } catch (java.io.IOException ignored) {
                    // nothing useful to do
                }
            }
        }
    }

    /** State/handle of the live task, used to detect that a re-registration happened. */
    private static String registrationFingerprint(int phoneId) {
        // Sampled 12 times during verification; keep it quiet or it drowns the log.
        quiet = true;
        try {
            Object task = findRegisterTask(null, phoneId);
            if (task == null) {
                return "task=null";
            }
            Object state = call(task, "getState");
            Object reg = call(task, "getImsRegistration");
            String handle = "?";
            if (reg != null) {
                Object h = call(reg, "getHandle");
                if (h == null) {
                    h = readField(reg, "mHandle");
                }
                handle = String.valueOf(h);
            }
            return "state=" + state + " handle=" + handle;
        } finally {
            quiet = false;
        }
    }

    /**
     * Rung 1: plain SIP re-REGISTER. Signature verified in RegistrationManagerBase:6212.
     *
     * sendReRegister(phoneId, pdnType) walks the task list and only acts on tasks whose
     * getPdnType() equals pdnType; a mismatch means it iterates, matches nothing, and
     * returns normally having done nothing. "Returned normally" therefore does not prove
     * a REGISTER went out. Read the live task's own pdnType and use that, and log both
     * values so a silent filter miss is visible rather than being mistaken for a
     * negative result.
     */
    private static void rungReRegister(Object regiMgr, int phoneId, int pdnType) {
        Object task = findRegisterTask(null, phoneId);

        // Preferred path: RegistrationManager.sendReRegister(RegisterTask) is public and
        // acts on exactly the task we already picked, with no pdnType filtering at all.
        if (task != null) {
            Method direct = findMethod(regiMgr.getClass(), "sendReRegister", task.getClass());
            if (direct == null) {
                for (Method cand : collectMethods(regiMgr.getClass())) {
                    if (cand.getName().equals("sendReRegister")
                            && cand.getParameterTypes().length == 1
                            && cand.getParameterTypes()[0].isInstance(task)) {
                        cand.setAccessible(true);
                        direct = cand;
                        break;
                    }
                }
            }
            if (direct != null) {
                try {
                    Log.w(TAG, "RUNG1_FIRE sendReRegister(task) phoneId=" + phoneId
                            + " task=" + task.getClass().getSimpleName());
                    direct.invoke(regiMgr, task);
                    Log.w(TAG, "RUNG1_COMPLETE sendReRegister(task) returned - expect an "
                            + "outbound REGISTER within ~1s");
                    return;
                } catch (Throwable e) {
                    Log.e(TAG, "RUNG1_FAIL sendReRegister(task) threw, falling back", e);
                }
            } else {
                Log.i(TAG, "RUNG1_NOTE no sendReRegister(RegisterTask) overload, using (int,int)");
            }
        }

        // Fallback: sendReRegister(phoneId, pdnType) walks the task list and only acts on
        // tasks whose getPdnType() equals pdnType. A mismatch means it matches nothing and
        // returns normally having done nothing, so "returned normally" does not prove a
        // REGISTER went out. Use the live task's own pdnType and log both values.
        Method m = findMethod(regiMgr.getClass(), "sendReRegister", int.class, int.class);
        if (m == null) {
            Log.e(TAG, "RUNG1_UNAVAILABLE no usable sendReRegister on "
                    + regiMgr.getClass().getName());
            return;
        }

        int effective = pdnType;
        if (task != null) {
            Object live = call(task, "getPdnType");
            if (live instanceof Integer) {
                int livePdn = ((Integer) live).intValue();
                Log.i(TAG, "RUNG1_PDN configured=" + pdnType + " liveTask=" + livePdn);
                if (livePdn != pdnType) {
                    Log.w(TAG, "RUNG1_PDN_OVERRIDE using live task pdnType=" + livePdn
                            + " (configured " + pdnType + " would match no task)");
                    effective = livePdn;
                }
            }
        }

        try {
            Log.w(TAG, "RUNG1_FIRE sendReRegister phoneId=" + phoneId + " pdnType=" + effective);
            m.invoke(regiMgr, phoneId, effective);
            Log.w(TAG, "RUNG1_COMPLETE sendReRegister returned - check for an outbound "
                    + "REGISTER in the next second to confirm it was not a filter miss");
        } catch (Throwable e) {
            Log.e(TAG, "RUNG1_FAIL sendReRegister threw", e);
        }
    }

    /** All declared methods up the hierarchy, for overload matching on internal types. */
    private static java.util.List<Method> collectMethods(Class<?> type) {
        java.util.List<Method> out = new java.util.ArrayList<Method>();
        Class<?> c = type;
        while (c != null) {
            for (Method m : c.getDeclaredMethods()) {
                out.add(m);
            }
            c = c.getSuperclass();
        }
        return out;
    }

    /**
     * Rung 2: deregister the profile, letting the stack re-register itself.
     *
     * The first parameter is the PROFILE ID, not the registration handle. Two wrong
     * guesses got here: v7 passed (phoneId, pdnType), v8 passed (handle, phoneId) after
     * the smali logged p1 as "deregisterProfile: handle:". That log string is
     * misleading - following the value through shows what actually consumes it:
     *
     *   deregisterProfile(id, phoneId)
     *     -> notifyManualDeRegisterRequested -> Bundle{"id"} -> message 0xa
     *     -> onManualDeregister(id, explicit, phoneId)
     *     -> getRegisterTaskByProfileId(id, phoneId)
     *          which compares against task.getProfile().getId()
     *
     * A non-matching id means the task lookup returns null and the whole request is
     * dropped with no log at our level - exactly the silent no-op we kept seeing.
     */
    private static void rungDeregisterProfile(Object regiMgr, int phoneId, int pdnType) {
        Method m = findMethod(regiMgr.getClass(), "deregisterProfile", int.class, int.class);
        if (m == null) {
            Log.e(TAG, "RUNG2_UNAVAILABLE deregisterProfile(int,int) not found on "
                    + regiMgr.getClass().getName());
            return;
        }

        Object task = findRegisterTask(null, phoneId);
        if (task == null) {
            Log.e(TAG, "RUNG2_ABORT no RegisterTask for phoneId=" + phoneId);
            return;
        }
        Object profile = call(task, "getProfile");
        if (profile == null) {
            Log.e(TAG, "RUNG2_ABORT task has no ImsProfile");
            return;
        }
        Object idObj = call(profile, "getId");
        if (!(idObj instanceof Integer)) {
            Log.e(TAG, "RUNG2_ABORT ImsProfile.getId() returned "
                    + (idObj == null ? "null" : idObj.getClass().getName())
                    + " - refusing to call with a guessed id");
            return;
        }
        int profileId = ((Integer) idObj).intValue();
        int handle = liveRegistrationHandle(phoneId);
        Log.i(TAG, "RUNG2_IDS profileId=" + profileId + " handle=" + handle
                + " (the call takes profileId; handle is logged only for correlation)");

        try {
            Log.w(TAG, "RUNG2_FIRE deregisterProfile profileId=" + profileId
                    + " phoneId=" + phoneId);
            m.invoke(regiMgr, profileId, phoneId);
            Log.w(TAG, "RUNG2_COMPLETE deregisterProfile returned - expect the handle to move");
        } catch (Throwable e) {
            Log.e(TAG, "RUNG2_FAIL deregisterProfile threw", e);
            return;
        }

        // deregisterProfile means "the user turned this profile off": onManualDeregister
        // ends with removeExtendedProfile(id), so the stack will NOT come back on its
        // own. v9 left the phone deregistered and call 2 died instantly - worse than the
        // bug under study. Re-register explicitly to complete the cycle.
        reRegisterProfile(regiMgr, profile, phoneId, profileId);
    }

    /**
     * Put the profile back after rung 2 tore it down. Without this the run ends with no
     * IMS registration at all, which is not the experiment we meant to run.
     */
    private static void reRegisterProfile(Object regiMgr, Object profile, int phoneId,
            int profileId) {
        int delayMs = SystemProperties.getInt(REREG_DELAY_PROP, 2000);
        if (delayMs > 0) {
            try {
                Thread.sleep(delayMs);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return;
            }
        }

        Method m = findMethodByName(regiMgr.getClass(), "registerProfile", 2);
        if (m == null) {
            Log.e(TAG, "RUNG2_REREG_UNAVAILABLE registerProfile/2 not found - the phone is"
                    + " left DEREGISTERED, treat this run as void");
            return;
        }
        Class<?>[] params = m.getParameterTypes();
        if (!params[0].isInstance(profile)) {
            Log.e(TAG, "RUNG2_REREG_SKIP registerProfile expects " + params[0].getName()
                    + ", have " + profile.getClass().getName());
            return;
        }
        try {
            Log.w(TAG, "RUNG2_REREG_FIRE registerProfile profileId=" + profileId
                    + " phoneId=" + phoneId);
            Object r = m.invoke(regiMgr, profile, phoneId);
            Log.w(TAG, "RUNG2_REREG_COMPLETE registerProfile returned " + r
                    + " - expect a fresh 401-challenged REGISTER");
        } catch (Throwable e) {
            Log.e(TAG, "RUNG2_REREG_FAIL registerProfile threw", e);
        }
    }

    /** Numeric handle of the live registration, or -1. */
    private static int liveRegistrationHandle(int phoneId) {
        Object task = findRegisterTask(null, phoneId);
        if (task == null) {
            return -1;
        }
        Object reg = call(task, "getImsRegistration");
        if (reg == null) {
            return -1;
        }
        Object h = call(reg, "getHandle");
        if (h == null) {
            h = readField(reg, "mHandle");
        }
        if (h instanceof Integer) {
            return ((Integer) h).intValue();
        }
        try {
            return Integer.parseInt(String.valueOf(h));
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    /**
     * Rung 3: drop the IMS PDN. stopPdnConnectivity(int, IRegisterTask) verified at
     * RegistrationManagerBase:6750 - it needs a task object, so we pull the current
     * one off the manager rather than fabricating it.
     */
    private static void rungStopPdn(Object regiMgr, int phoneId, int pdnType) {
        Method m = findMethodByName(regiMgr.getClass(), "stopPdnConnectivity", 2);
        if (m == null) {
            Log.e(TAG, "RUNG3_UNAVAILABLE stopPdnConnectivity/2 not found on "
                    + regiMgr.getClass().getName());
            return;
        }
        Object task = findRegisterTask(null, phoneId);
        if (task == null) {
            Log.e(TAG, "RUNG3_ABORT no IRegisterTask resolved for phoneId=" + phoneId);
            return;
        }
        try {
            Log.w(TAG, "RUNG3_FIRE stopPdnConnectivity phoneId=" + phoneId + " pdnType=" + pdnType
                    + " task=" + task.getClass().getName());
            m.invoke(regiMgr, pdnType, task);
            Log.w(TAG, "RUNG3_COMPLETE stopPdnConnectivity returned normally");
        } catch (Throwable e) {
            Log.e(TAG, "RUNG3_FAIL stopPdnConnectivity threw", e);
        }
    }

    /**
     * Rung 4: cycle the radio the way the airplane-mode toggle does.
     *
     * This is the only reset that works, and unlike rungs 1-3 it is not an IMS-layer
     * action at all. Evidence: all three IMS rungs executed and all failed, while an
     * airplane toggle taken 30 s after call 1 succeeded - far below the ~120 s a pure
     * wait needs. Bearer numbering shows why: every run before the toggle used bearer
     * 38/39 with the flow counter frozen at 92/93; after it the phone used bearer 39/40
     * with flow 214/215 -> 275/276, i.e. +61 per call, exactly the stock stride. So
     * setRadioPower rebuilds the modem bearer/QoS context, and nothing reachable from
     * the IMS stack does.
     *
     * Writing the airplane_mode_on setting is what actually drives it: RegiObsMgr
     * observes that URI and PhoneGlobals turns the radio off from there
     * ("Turning radio off - airplane" -> SST setRadioPower power false). Note that
     * "svc data disable" is NOT equivalent - it never touches radioState.
     *
     * Dwell time matters: 500 ms works, but 0 ms leaves the remote end ringing while
     * the local UI is still dialling, so the radio must settle in the off state first.
     */
    private static void rungRadioCycle(int phoneId) {
        int dwellMs = ApMediaConfigPoc.integer("ap_latch_probe_radio_dwell_ms", 400, MIN_RADIO_DWELL_MS, 10000);
        if (dwellMs < MIN_RADIO_DWELL_MS) {
            Log.w(TAG, "RUNG4_DWELL raising " + dwellMs + "ms to the " + MIN_RADIO_DWELL_MS
                    + "ms floor - too short a dwell desynchronises the call UI");
            dwellMs = MIN_RADIO_DWELL_MS;
        }

        Log.w(TAG, "RUNG4_FIRE airplane cycle dwell=" + dwellMs + "ms phoneId=" + phoneId);
        if (!setAirplaneMode(true)) {
            Log.e(TAG, "RUNG4_FAIL could not enable airplane mode - radio not cycled");
            return;
        }
        try {
            Thread.sleep(dwellMs);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        if (!setAirplaneMode(false)) {
            Log.e(TAG, "RUNG4_ABORT airplane mode is still ON - the device has no radio."
                    + " Turn it off manually.");
            return;
        }
        Log.w(TAG, "RUNG4_COMPLETE radio cycled - expect a fresh registration and a new"
                + " bearer/flow base");
    }

    /** Direct radio-only variant: no airplane setting or broadcast is touched. */
    private static void rungDirectRadioCycle(int phoneId) {
        int dwellMs = ApMediaConfigPoc.integer("ap_latch_probe_radio_dwell_ms", 400,
                MIN_RADIO_DWELL_MS, 10000);
        Log.w(TAG, "RUNG6_FIRE direct radio power cycle dwell=" + dwellMs
                + "ms phoneId=" + phoneId + " airplane_setting_untouched=true");
        if (!setDirectRadioPower(false)) {
            Log.e(TAG, "RUNG6_FAIL radio off request unavailable or rejected");
            return;
        }
        try { Thread.sleep(dwellMs); } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return;
        }
        if (!setDirectRadioPower(true)) {
            Log.e(TAG, "RUNG6_ABORT radio on request failed; manual recovery may be required");
            return;
        }
        Log.w(TAG, "RUNG6_COMPLETE direct radio cycled - airplane_mode_on was not written");
    }

    private static boolean setDirectRadioPower(boolean on) {
        try {
            Class<?> tmClass = Class.forName("android.telephony.TelephonyManager");
            Object context = appContext();
            if (context == null) return false;
            Object tm = context.getClass().getMethod("getSystemService", String.class)
                    .invoke(context, "phone");
            if (tm == null) return false;
            Method m = tmClass.getMethod("setRadioPower", boolean.class);
            Object result = m.invoke(tm, Boolean.valueOf(on));
            Log.i(TAG, "RUNG6_RADIO_POWER on=" + on + " result=" + result
                    + " method=TelephonyManager.setRadioPower(Z)");
            return !(result instanceof Boolean) || ((Boolean) result).booleanValue();
        } catch (Throwable e) {
            Log.e(TAG, "RUNG6_RADIO_POWER unavailable on=" + on, e);
            return false;
        }
    }

    /**
     * Rung 5: tear the IMS PDN down and bring it straight back, leaving the radio alone.
     *
     * Rung 4 works but costs 3-5 s with the radio off, during which no call can arrive.
     * What the airplane toggle actually accomplishes is onTearDownAllDataNetworks ->
     * SETUP_DATA_CALL -> TxCbFlowActivate with a fresh bearer base; PDN setup itself
     * measured 0.553 s, so doing only that should cut the outage by ~10x.
     *
     * The catch, learned the hard way in v13: PdnController keys everything off the
     * exact PdnEventListener instance that registered the request
     * (mNetworkCallbacks.get(listener), then "if callback == null" skips the whole
     * teardown). Passing the RegisterTask looked right - IRegisterTask does extend
     * PdnEventListener - but it is not necessarily the object that was registered, so
     * the lookup missed, unregisterNetworkCallback never ran, and no SETUP_DATA_CALL
     * followed. That is the same shape as rung 3's failure and it returned 1 either
     * way, so the return value proves nothing.
     *
     * So: take the listener straight out of mNetworkCallbacks rather than assuming.
     */
    private static void rungPdnRebuild(int phoneId, int pdnType) {
        Object pdn = findPdnController(phoneId);
        if (pdn == null) {
            Log.e(TAG, "RUNG5_ABORT could not resolve PdnController");
            return;
        }
        Log.i(TAG, "RUNG5_PDNCTL " + pdn.getClass().getName());

        Object listener = registeredPdnListener(pdn, phoneId);
        if (listener == null) {
            Log.e(TAG, "RUNG5_ABORT no unique registered PdnEventListener found in"
                    + " mNetworkCallbacks - a teardown would be ambiguous or a silent no-op,"
                    + " so it is not attempted");
            return;
        }

        Object task = findRegisterTask(null, phoneId);
        Log.i(TAG, "RUNG5_BEFORE pdnType=" + pdnType + " phoneId=" + phoneId
                + " listener=" + listener.getClass().getName()
                + " taskState=" + (task == null ? "null" : call(task, "getState"))
                + " registration=" + registrationFingerprint(phoneId));

        Method stop = findMethodByName(pdn.getClass(), "stopPdnConnectivity", 3);
        Method start = findMethodByName(pdn.getClass(), "startPdnConnectivity", 3);
        if (stop == null || start == null) {
            Log.e(TAG, "RUNG5_UNAVAILABLE stop=" + (stop != null) + " start=" + (start != null));
            return;
        }

        try {
            Log.w(TAG, "RUNG5_FIRE stopPdnConnectivity pdnType=" + pdnType
                    + " phoneId=" + phoneId + " listener=" + listener.getClass().getName());
            Object rc = stop.invoke(pdn, pdnType, phoneId, listener);
            Log.w(TAG, "RUNG5_STOPPED returned " + rc
                    + " (return value is not proof - watch for SETUP_DATA_CALL)");
        } catch (Throwable e) {
            Log.e(TAG, "RUNG5_FAIL stopPdnConnectivity threw", e);
            return;
        }

        int gapMs = SystemProperties.getInt(PDN_GAP_PROP, 1200);
        try {
            Thread.sleep(gapMs);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // Pair the teardown with a rebuild; an unpaired teardown stranded the phone
        // when rung 2 did the same thing at the registration layer.
        try {
            int startPhoneId = phoneIdForStartConnectivity(task != null ? task : listener, phoneId);
            Log.w(TAG, "RUNG5_REBUILD startPdnConnectivity pdnType=" + pdnType
                    + " startPhoneId=" + startPhoneId + " after " + gapMs + "ms");
            Object rc = start.invoke(pdn, pdnType, listener, startPhoneId);
            Log.w(TAG, "RUNG5_COMPLETE startPdnConnectivity returned " + rc);
        } catch (Throwable e) {
            Log.e(TAG, "RUNG5_FAIL startPdnConnectivity threw", e);
            Log.e(TAG, "RUNG5_RECOVERY_REQUIRED IMS PDN may be down; use the verified"
                    + " explicit rung-4 recovery, and do not count this run as rung-5 success");
        }
    }

    /**
     * The listener PdnController actually holds a NetworkCallback for. Anything else
     * makes stopPdnConnectivity a no-op, which is indistinguishable from success at the
     * call site.
     */
    private static Object registeredPdnListener(Object pdn, int phoneId) {
        Object map = readField(pdn, "mNetworkCallbacks");
        if (!(map instanceof java.util.Map)) {
            Log.e(TAG, "RUNG5_LISTENER mNetworkCallbacks is "
                    + (map == null ? "null" : map.getClass().getName()));
            return null;
        }
        java.util.Map<?, ?> callbacks = (java.util.Map<?, ?>) map;
        Log.i(TAG, "RUNG5_LISTENER mNetworkCallbacks has " + callbacks.size() + " entry(s)");

        Object task = findRegisterTask(null, phoneId);
        Object onlyRegistered = null;
        int registeredCount = 0;
        for (java.util.Map.Entry<?, ?> e : callbacks.entrySet()) {
            Object key = e.getKey();
            if (key == null) {
                continue;
            }
            boolean registered = e.getValue() != null;
            Log.i(TAG, "RUNG5_LISTENER candidate " + key.getClass().getName()
                    + " callback=" + registered);
            if (!registered) {
                continue;
            }
            if (key == task) {
                Log.i(TAG, "RUNG5_LISTENER exact match with the live RegisterTask");
                return key;
            }
            registeredCount++;
            onlyRegistered = key;
        }
        if (registeredCount == 1) {
            Log.w(TAG, "RUNG5_LISTENER task not registered; using the only listener"
                    + " that holds a callback: " + onlyRegistered.getClass().getName());
            return onlyRegistered;
        }
        if (registeredCount > 1) {
            Log.e(TAG, "RUNG5_LISTENER ambiguous: " + registeredCount
                    + " non-task listeners hold callbacks; refusing to guess");
        }
        return null;
    }

    /**
     * PdnController lives as mPdnController on the registration manager handler, which
     * is already on the path we walk for the other rungs.
     */
    private static Object findPdnController(int phoneId) {
        Object task = findRegisterTask(null, phoneId);
        if (task == null) {
            return null;
        }
        Object handler = readField(task, "mRegHandler");
        if (handler != null) {
            Object pdn = readField(handler, "mPdnController");
            if (pdn != null) {
                Log.i(TAG, "RUNG5_PDN_VIA handler.mPdnController");
                return pdn;
            }
            Object mgr = readField(handler, "mRegMan");
            if (mgr != null) {
                Object viaMgr = readField(mgr, "mPdnController");
                if (viaMgr != null) {
                    Log.i(TAG, "RUNG5_PDN_VIA mRegMan.mPdnController");
                    return viaMgr;
                }
            }
        }
        Object viaRegistry = callStatic("com.sec.internal.ims.core.ImsRegistry",
                "getPdnController");
        if (viaRegistry != null) {
            Log.i(TAG, "RUNG5_PDN_VIA ImsRegistry.getPdnController()");
        }
        return viaRegistry;
    }

    /**
     * The stack derives the phoneId for startPdnConnectivity through a helper rather
     * than passing the slot straight through; mirror that, falling back to the slot.
     */
    private static int phoneIdForStartConnectivity(Object task, int phoneId) {
        try {
            Class<?> utils = Class.forName("com.sec.internal.ims.core.RegistrationUtils");
            for (Method m : utils.getDeclaredMethods()) {
                if (m.getName().equals("getPhoneIdForStartConnectivity")
                        && m.getParameterTypes().length == 1) {
                    m.setAccessible(true);
                    Object v = m.invoke(null, task);
                    if (v instanceof Integer) {
                        return ((Integer) v).intValue();
                    }
                }
            }
        } catch (Throwable e) {
            Log.i(TAG, "RUNG5_NOTE getPhoneIdForStartConnectivity unavailable: " + e);
        }
        return phoneId;
    }

    /**
     * Flip airplane mode the way the Settings UI does: write the global setting, then
     * broadcast the change. Both halves are needed; the setting alone misses listeners.
     *
     * Shelling out to "settings put" fails here - it exited 255 on device, because the
     * subprocess does not carry the permissions needed to write a secure setting. But
     * this APK runs as android.uid.system with the platform signature, so calling
     * Settings.Global directly from inside the process does have the rights. Everything
     * is reflected so a missing class logs instead of throwing into the stack.
     */
    private static boolean setAirplaneMode(boolean on) {
        Object context = appContext();
        if (context == null) {
            Log.e(TAG, "RUNG4_CTX no application context - cannot toggle airplane mode");
            return false;
        }

        int value = on ? 1 : 0;
        try {
            Object resolver = context.getClass()
                    .getMethod("getContentResolver").invoke(context);
            Class<?> global = Class.forName("android.provider.Settings$Global");
            Method put = global.getMethod("putInt",
                    Class.forName("android.content.ContentResolver"), String.class, int.class);
            Object ok = put.invoke(null, resolver, "airplane_mode_on", value);
            if (Boolean.FALSE.equals(ok)) {
                Log.e(TAG, "RUNG4_SETTING putInt(airplane_mode_on," + value + ") returned false"
                        + " - the write was rejected");
                return false;
            }
            Log.i(TAG, "RUNG4_AIRPLANE airplane_mode_on=" + value + " written via Settings.Global");
        } catch (Throwable e) {
            Log.e(TAG, "RUNG4_SETTING failed to write airplane_mode_on=" + value, e);
            return false;
        }

        // The observers that actually drive setRadioPower key off the broadcast as well
        // as the setting, so both are required. ACTION_AIRPLANE_MODE_CHANGED is a
        // protected broadcast, which uid system is allowed to send.
        try {
            Class<?> intentClass = Class.forName("android.content.Intent");
            Object intent = intentClass.getConstructor(String.class)
                    .newInstance("android.intent.action.AIRPLANE_MODE");
            intentClass.getMethod("putExtra", String.class, boolean.class)
                    .invoke(intent, "state", on);
            context.getClass().getMethod("sendBroadcast", intentClass)
                    .invoke(context, intent);
            Log.i(TAG, "RUNG4_BROADCAST AIRPLANE_MODE state=" + on);
        } catch (Throwable e) {
            Log.e(TAG, "RUNG4_BROADCAST failed (setting was written, radio may still cycle)", e);
        }
        return true;
    }

    /** The process-wide Application, reached without needing a caller to hand one in. */
    private static Object appContext() {
        try {
            Class<?> at = Class.forName("android.app.ActivityThread");
            Object app = at.getMethod("currentApplication").invoke(null);
            if (app != null) {
                return app;
            }
        } catch (Throwable e) {
            Log.i(TAG, "RUNG4_CTX ActivityThread.currentApplication unavailable: " + e);
        }
        try {
            Class<?> at = Class.forName("android.app.AppGlobals");
            return at.getMethod("getInitialApplication").invoke(null);
        } catch (Throwable e) {
            Log.e(TAG, "RUNG4_CTX AppGlobals.getInitialApplication unavailable", e);
            return null;
        }
    }

    /**
     * Resolve RegistrationManagerBase, which owns sendReRegister / deregisterProfile /
     * stopPdnConnectivity.
     *
     * The v3 probe guessed at field names on the service module and at static
     * getters, found none, and aborted on all three rungs - a null run. The real
     * path, read out of the smali, is:
     *
     *   RegistrationUtils.getPendingRegistrationInternal(phoneId)  (static, verified
     *     present - the stack itself calls it in 83 places)
     *     -> RegisterTask
     *     -> field mRegHandler : RegistrationManagerHandler
     *     -> field mRegMan     : RegistrationManagerBase   <- the target
     *
     * RegistrationManager has no static singleton and RegistrationManagerBase has no
     * static instance field, so this task-first walk is the only reachable route.
     */
    private static Object findRegistrationManager(Object module, int phoneId) {
        Object task = findRegisterTask(null, phoneId);
        if (task == null) {
            Log.e(TAG, "REGIMGR_FAIL no RegisterTask for phoneId=" + phoneId);
            return null;
        }
        Log.i(TAG, "REGIMGR_STEP1 task=" + task.getClass().getName());

        Object handler = readField(task, "mRegHandler");
        if (handler == null) {
            Log.e(TAG, "REGIMGR_FAIL task has no mRegHandler");
            return null;
        }
        Log.i(TAG, "REGIMGR_STEP2 handler=" + handler.getClass().getName());

        Object mgr = readField(handler, "mRegMan");
        if (mgr == null) {
            Log.e(TAG, "REGIMGR_FAIL handler has no mRegMan");
            return null;
        }
        Log.i(TAG, "REGIMGR_STEP3 mgr=" + mgr.getClass().getName());

        // Confirm the resolved object really carries the rung methods before we
        // report success, so an abort can never be confused with a silent no-op.
        boolean ok = findMethod(mgr.getClass(), "sendReRegister", int.class, int.class) != null;
        Log.i(TAG, "REGIMGR_VERIFY sendReRegister present=" + ok);
        if (!ok) {
            Log.e(TAG, "REGIMGR_FAIL resolved object lacks sendReRegister - wrong class");
            return null;
        }
        return mgr;
    }

    /** Pull a live IRegisterTask for this slot via the static registry. */
    private static Object findRegisterTask(Object regiMgr, int phoneId) {
        // Primary path, both members verified public in the smali:
        //   SlotBasedConfig.getInstance(int)  -> SlotBasedConfig
        //   .getRegistrationTasks()           -> RegisterTaskList (a CopyOnWriteArrayList)
        //
        // v4 went through RegistrationUtils.getPendingRegistrationInternal instead,
        // which is `protected static`. getMethod() only sees public members, so the
        // lookup threw NoSuchMethodException, callStatic swallowed it, and the probe
        // reported "returned null" - indistinguishable from a genuinely empty list.
        // Go straight to the public API the protected helper itself delegates to.
        Object cfg = callStatic("com.sec.internal.ims.core.SlotBasedConfig",
                "getInstance", phoneId);
        if (cfg == null) {
            Log.e(TAG, "TASK_FAIL SlotBasedConfig.getInstance(" + phoneId + ") unavailable");
        } else {
            Object tasks = call(cfg, "getRegistrationTasks");
            if (tasks instanceof Iterable) {
                Object best = pickRegisteredTask((Iterable<?>) tasks, phoneId);
                if (best != null) {
                    return best;
                }
                Log.e(TAG, "TASK_FAIL getRegistrationTasks had no usable entry");
            } else {
                Log.e(TAG, "TASK_FAIL getRegistrationTasks returned "
                        + (tasks == null ? "null" : tasks.getClass().getName()));
            }
        }

        // Fallback: the protected helper, reached with getDeclaredMethod so that
        // non-public visibility is not mistaken for absence.
        Object list = callStaticDeclared("com.sec.internal.ims.core.RegistrationUtils",
                "getPendingRegistrationInternal", phoneId);
        if (list instanceof Iterable) {
            Object best = pickRegisteredTask((Iterable<?>) list, phoneId);
            if (best != null) {
                Log.i(TAG, "TASK_VIA getPendingRegistrationInternal (fallback)");
                return best;
            }
            Log.e(TAG, "TASK_FAIL fallback list had no usable entry");
        }
        return null;
    }

    /**
     * Prefer a task that is actually registered on this slot. The list also holds
     * IDLE RCS profiles (CTC Internet RCS / CTC WIFI RCS in the logs); firing a
     * re-REGISTER at one of those would be a no-op and would look like the rung
     * had run.
     */
    private static Object pickRegisteredTask(Iterable<?> tasks, int phoneId) {
        Object first = null;
        int seen = 0;
        for (Object t : tasks) {
            if (t == null) {
                continue;
            }
            seen++;
            if (first == null) {
                first = t;
            }
            String state = String.valueOf(call(t, "getState"));
            String profile = String.valueOf(call(t, "getProfile"));
            if (!quiet) {
                Log.i(TAG, "TASK_CANDIDATE #" + seen + " state=" + state
                        + " class=" + t.getClass().getSimpleName());
            }
            if (state.toUpperCase().contains("REGISTERED")
                    && !state.toUpperCase().contains("DEREGISTERED")) {
                if (!quiet) {
                    Log.i(TAG, "TASK_PICK registered task, profile=" + profile);
                }
                return t;
            }
        }
        if (first != null) {
            if (!quiet) {
                Log.i(TAG, "TASK_PICK falling back to first of " + seen + " task(s)");
            }
        }
        return first;
    }

    private static Method findMethod(Class<?> type, String name, Class<?>... args) {
        try {
            Method m = type.getMethod(name, args);
            m.setAccessible(true);
            return m;
        } catch (Throwable ignored) {
            // getMethod only sees public members. Walk the hierarchy for
            // protected/package-private ones rather than reporting absence -
            // that mistake produced the v4 null run.
            Class<?> c = type;
            while (c != null) {
                try {
                    Method m = c.getDeclaredMethod(name, args);
                    m.setAccessible(true);
                    return m;
                } catch (NoSuchMethodException e) {
                    c = c.getSuperclass();
                } catch (Throwable e) {
                    return null;
                }
            }
            return null;
        }
    }

    /** Zero-arg instance call. */
    private static Object call(Object target, String name) {
        try {
            Method m = findMethod(target.getClass(), name);
            if (m == null) {
                return null;
            }
            return m.invoke(target);
        } catch (Throwable e) {
            return null;
        }
    }

    /** Static call that also finds non-public methods. */
    private static Object callStaticDeclared(String cls, String mth, int arg) {
        try {
            Class<?> c = Class.forName(cls);
            Method m = findMethod(c, mth, int.class);
            if (m == null) {
                Log.e(TAG, "REFLECT_MISS " + cls + "." + mth + "(int) not found at all");
                return null;
            }
            return m.invoke(null, arg);
        } catch (Throwable e) {
            Log.e(TAG, "REFLECT_THROW " + cls + "." + mth + ": " + e);
            return null;
        }
    }

    /** Fall back to arity matching when the parameter types are internal interfaces. */
    private static Method findMethodByName(Class<?> type, String name, int argCount) {
        Class<?> c = type;
        while (c != null) {
            for (Method m : c.getDeclaredMethods()) {
                if (m.getName().equals(name) && m.getParameterTypes().length == argCount) {
                    m.setAccessible(true);
                    return m;
                }
            }
            c = c.getSuperclass();
        }
        return null;
    }

    private static Object readField(Object target, String name) {
        Class<?> c = target.getClass();
        while (c != null) {
            try {
                Field f = c.getDeclaredField(name);
                f.setAccessible(true);
                return f.get(target);
            } catch (NoSuchFieldException e) {
                c = c.getSuperclass();
            } catch (Throwable e) {
                return null;
            }
        }
        return null;
    }

    private static Object call(Object target, String name, int arg) {
        try {
            Method m = target.getClass().getMethod(name, int.class);
            m.setAccessible(true);
            return m.invoke(target, arg);
        } catch (Throwable e) {
            return null;
        }
    }

    private static Object callStatic(String cls, String mth, int arg) {
        try {
            Class<?> c = Class.forName(cls);
            Method m = c.getMethod(mth, int.class);
            m.setAccessible(true);
            return m.invoke(null, arg);
        } catch (Throwable e) {
            return null;
        }
    }

    private static Object callStatic(String cls, String mth) {
        try {
            Class<?> c = Class.forName(cls);
            Method m = c.getMethod(mth);
            m.setAccessible(true);
            return m.invoke(null);
        } catch (Throwable e) {
            return null;
        }
    }
}
