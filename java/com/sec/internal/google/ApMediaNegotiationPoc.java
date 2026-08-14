package com.sec.internal.google;

import android.os.SystemClock;
import android.util.Log;
import java.util.ArrayList;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

public final class ApMediaNegotiationPoc {
    private static final String TAG = "AP_MEDIA_NEGOTIATION";
    private static final ConcurrentHashMap<Integer, State> CHANNELS = new ConcurrentHashMap<>();
    private static final AtomicLong GENERATIONS = new AtomicLong();
    private static final AtomicLong OPERATIONS = new AtomicLong();

    private ApMediaNegotiationPoc() {}

    public static final class Snapshot {
        public final int channel;
        public final long generation;
        public final String codec;
        public final int txPt;
        public final int rxPt;
        public final int clock;
        public final int ptime;
        public final boolean octetAligned;

        Snapshot(State state) {
            channel = state.channel;
            generation = state.generation;
            codec = state.codec;
            txPt = state.txPt;
            rxPt = state.rxPt;
            clock = state.clock;
            ptime = state.ptime;
            octetAligned = state.octetAligned;
        }

        public boolean amrNb() {
            return "AMR".equalsIgnoreCase(codec) || "AMR-NB".equalsIgnoreCase(codec);
        }
    }

    static final class State {
        final int channel;
        final long generation;
        final long createdMs;
        volatile long updatedMs;
        volatile String localIp;
        volatile String remoteIp;
        volatile String codec;
        volatile String lastOp;
        volatile int localRtp;
        volatile int remoteRtp;
        volatile int localRtcp;
        volatile int remoteRtcp;
        volatile int txPt = -1;
        volatile int rxPt = -1;
        volatile int clock;
        volatile int bitrate;
        volatile int ptime;
        volatile int maxPtime;
        volatile int modeSet;
        volatile int direction;
        volatile boolean octetAligned;
        volatile boolean started;
        volatile boolean stopped;
        volatile boolean deleted;

        State(int channel) {
            this.channel = channel;
            generation = GENERATIONS.incrementAndGet();
            createdMs = updatedMs = SystemClock.elapsedRealtime();
        }

        boolean downlinkReady() {
            boolean amrWb = "AMR-WB".equalsIgnoreCase(codec);
            boolean amrNb = "AMR".equalsIgnoreCase(codec) || "AMR-NB".equalsIgnoreCase(codec);
            int expectedClock = amrNb ? 8000 : 16000;
            return started && !stopped && !deleted && (amrWb || amrNb)
                    && txPt >= 0 && txPt <= 127 && rxPt >= 0 && rxPt <= 127
                    && clock == expectedClock && ptime == 20 && !octetAligned;
        }

        String describe() {
            return "generation=" + generation + " channel=" + channel
                    + " local=" + localIp + ":" + localRtp
                    + " remote=" + remoteIp + ":" + remoteRtp
                    + " rtcp=" + localRtcp + "/" + remoteRtcp
                    + " codec=" + codec + " txPt=" + txPt + " rxPt=" + rxPt
                    + " clock=" + clock + " bitrate=" + bitrate
                    + " ptime=" + ptime + " maxPtime=" + maxPtime
                    + " octetAligned=" + octetAligned + " modeSet=" + modeSet
                    + " direction=" + direction + " started=" + started
                    + " stopped=" + stopped + " deleted=" + deleted
                    + " downlinkReady=" + downlinkReady()
                    + " ageMs=" + (SystemClock.elapsedRealtime() - createdMs);
        }
    }

    private static State state(int channel) {
        State current = CHANNELS.get(Integer.valueOf(channel));
        if (current == null) {
            State created = new State(channel);
            State previous = CHANNELS.putIfAbsent(Integer.valueOf(channel), created);
            current = previous == null ? created : previous;
        }
        return current;
    }

    private static void log(String op, State state) {
        state.lastOp = op;
        state.updatedMs = SystemClock.elapsedRealtime();
        Log.i(TAG, "SVE_LIFECYCLE seq=" + OPERATIONS.incrementAndGet()
                + " op=" + op + " thread=" + Thread.currentThread().getName()
                + " " + state.describe() + " active=" + CHANNELS.size());
    }

    public static void onCreateFull(int channel, int mno, String localIp, int localRtp,
            String remoteIp, int remoteRtp, int localRtcp, int remoteRtcp, String pdn,
            boolean xq, boolean tty) {
        onCreate(channel, localIp, localRtp, remoteIp, remoteRtp, localRtcp, remoteRtcp);
    }

    public static void onUpdateFull(int channel, int direction, String localIp, int localRtp,
            String remoteIp, int remoteRtp, int localRtcp, int remoteRtcp) {
        onUpdate(channel, direction, localIp, localRtp, remoteIp, remoteRtp, localRtcp, remoteRtcp);
    }

    public static void onCodecFull(int channel, String codec, int txPt, int rxPt, int clock,
            int bitrate, int ptime, int maxPtime, boolean octetAligned, int modeSet) {
        onCodec(channel, codec, txPt, rxPt, clock, bitrate, ptime, maxPtime, octetAligned, modeSet);
    }

    public static void onStartFull(int channel, int direction, boolean ipv6) {
        onStart(channel, direction);
    }

    public static void onCreate(int channel, String localIp, int localRtp, String remoteIp,
            int remoteRtp, int localRtcp, int remoteRtcp) {
        State previous = CHANNELS.get(Integer.valueOf(channel));
        if (previous != null) log("CREATE_REPLACE", previous);
        State created = new State(channel);
        created.localIp = localIp;
        created.localRtp = localRtp;
        created.remoteIp = remoteIp;
        created.remoteRtp = remoteRtp;
        created.localRtcp = localRtcp;
        created.remoteRtcp = remoteRtcp;
        CHANNELS.put(Integer.valueOf(channel), created);
        log("CREATE", created);
    }

    public static void onUpdate(int channel, int direction, String localIp, int localRtp,
            String remoteIp, int remoteRtp, int localRtcp, int remoteRtcp) {
        State state = state(channel);
        state.direction = direction;
        state.localIp = localIp;
        state.localRtp = localRtp;
        state.remoteIp = remoteIp;
        state.remoteRtp = remoteRtp;
        state.localRtcp = localRtcp;
        state.remoteRtcp = remoteRtcp;
        log("UPDATE", state);
    }

    public static void onCodec(int channel, String codec, int txPt, int rxPt, int clock,
            int bitrate, int ptime, int maxPtime, boolean octetAligned, int modeSet) {
        State state = state(channel);
        state.codec = codec;
        state.txPt = txPt;
        state.rxPt = rxPt;
        state.clock = clock;
        state.bitrate = bitrate;
        state.ptime = ptime;
        state.maxPtime = maxPtime;
        state.octetAligned = octetAligned;
        state.modeSet = modeSet;
        log("CODEC", state);
    }

    public static void onStart(int channel, int direction) {
        State state = state(channel);
        state.direction = direction;
        state.started = true;
        state.stopped = false;
        log("START", state);
    }

    public static void onStop(int channel) {
        State state = state(channel);
        state.started = false;
        state.stopped = true;
        log("STOP", state);
    }

    public static void onDelete(int channel) {
        State state = CHANNELS.remove(Integer.valueOf(channel));
        if (state == null) {
            state = new State(channel);
            state.deleted = true;
            log("DELETE_MISSING", state);
        } else {
            state.deleted = true;
            log("DELETE", state);
        }
    }

    public static void onGlobal(String op, int phoneId, int status) {
        Log.i(TAG, "SAE_GLOBAL seq=" + OPERATIONS.incrementAndGet() + " op=" + op
                + " phoneId=" + phoneId + " status=" + status
                + " thread=" + Thread.currentThread().getName()
                + " active=" + CHANNELS.size());
    }

    public static Snapshot awaitUniqueReady(long timeoutMs) {
        long deadline = SystemClock.elapsedRealtime() + Math.max(0, timeoutMs);
        do {
            ArrayList<State> ready = new ArrayList<State>();
            for (State state : CHANNELS.values()) {
                if (state.downlinkReady()) ready.add(state);
            }
            if (ready.size() == 1) {
                State state = ready.get(0);
                Snapshot snapshot = new Snapshot(state);
                if (CHANNELS.get(Integer.valueOf(state.channel)) == state
                        && state.generation == snapshot.generation && state.downlinkReady()) {
                    Log.i(TAG, "MEDIA_CORRELATION_READY channel=" + snapshot.channel
                            + " generation=" + snapshot.generation
                            + " codec=" + snapshot.codec + " txPt=" + snapshot.txPt
                            + " rxPt=" + snapshot.rxPt);
                    return snapshot;
                }
            } else if (ready.size() > 1) {
                Log.e(TAG, "MEDIA_CORRELATION_REJECT reason=ambiguous readyCount="
                        + ready.size() + " total=" + CHANNELS.size());
                return null;
            }
            if (SystemClock.elapsedRealtime() >= deadline) {
                Log.e(TAG, "MEDIA_CORRELATION_REJECT reason=timeout readyCount="
                        + ready.size() + " total=" + CHANNELS.size());
                return null;
            }
            try {
                Thread.sleep(25);
            } catch (InterruptedException interrupted) {
                Thread.currentThread().interrupt();
                Log.e(TAG, "MEDIA_CORRELATION_REJECT reason=interrupted");
                return null;
            }
        } while (true);
    }

    public static String uniqueReady() {
        Snapshot snapshot = awaitUniqueReady(0);
        return snapshot == null ? null : "generation=" + snapshot.generation
                + " channel=" + snapshot.channel + " codec=" + snapshot.codec
                + " txPt=" + snapshot.txPt + " rxPt=" + snapshot.rxPt;
    }
}
