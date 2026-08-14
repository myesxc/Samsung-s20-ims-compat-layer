package com.sec.internal.google;

import android.os.SystemProperties;
import android.util.Log;

final class ApMediaConfigPoc {
    private static final String TAG = "AP_MEDIA_CONFIG";
    private static final String PREFIX = "persist.vendor.ims.";

    private ApMediaConfigPoc() {}

    static boolean bool(String suffix, boolean fallback) {
        String name = PREFIX + suffix;
        String raw = SystemProperties.get(name, "").trim();
        if (raw.length() == 0) return fallback;
        if ("1".equals(raw) || "true".equalsIgnoreCase(raw)
                || "on".equalsIgnoreCase(raw) || "yes".equalsIgnoreCase(raw)) {
            Log.i(TAG, "CONFIG_OVERRIDE property=" + name + " raw=" + raw + " effective=true");
            return true;
        }
        if ("0".equals(raw) || "false".equalsIgnoreCase(raw)
                || "off".equalsIgnoreCase(raw) || "no".equalsIgnoreCase(raw)) {
            Log.i(TAG, "CONFIG_OVERRIDE property=" + name + " raw=" + raw + " effective=false");
            return false;
        }
        Log.w(TAG, "CONFIG_REJECT property=" + name + " raw=" + raw + " fallback=" + fallback);
        return fallback;
    }

    static int integer(String suffix, int fallback, int min, int max) {
        String name = PREFIX + suffix;
        String raw = SystemProperties.get(name, "").trim();
        if (raw.length() == 0) return fallback;
        try {
            int value = Integer.parseInt(raw);
            if (value >= min && value <= max) {
                Log.i(TAG, "CONFIG_OVERRIDE property=" + name + " raw=" + raw + " effective=" + value);
                return value;
            }
        } catch (Throwable ignored) {}
        Log.w(TAG, "CONFIG_REJECT property=" + name + " raw=" + raw + " fallback=" + fallback);
        return fallback;
    }

    static String source() {
        String name = PREFIX + "ap_uplink_source";
        String raw = SystemProperties.get(name, "").trim();
        if (raw.length() == 0) return "voice_uplink";
        if ("mic".equals(raw) || "voice_communication".equals(raw) || "voice_uplink".equals(raw)) {
            Log.i(TAG, "CONFIG_OVERRIDE property=" + name + " raw=" + raw + " effective=" + raw);
            return raw;
        }
        Log.w(TAG, "CONFIG_REJECT property=" + name + " raw=" + raw + " fallback=voice_uplink");
        return "voice_uplink";
    }

    static int voicePtOverride() {
        int value = integer("ap_uplink_pt_override", -1, -1, 127);
        if (value == -1 || value >= 96) return value;
        Log.w(TAG, "CONFIG_REJECT property=" + PREFIX + "ap_uplink_pt_override raw=" + value + " fallback=-1");
        return -1;
    }

    static int uplinkSeconds() {
        return integer("ap_uplink_rtp_seconds", 32766, 0, 32766);
    }

    static int uplinkBitrate(boolean amrNb) {
        if (!amrNb) return integer("ap_uplink_wb_bitrate", 12650, 12650, 12650);
        String name = PREFIX + "ap_uplink_nb_bitrate";
        String raw = SystemProperties.get(name, "").trim();
        if (raw.length() == 0) return 12200;
        try {
            int value = Integer.parseInt(raw);
            if (value == 4750 || value == 5150 || value == 5900 || value == 6700
                    || value == 7400 || value == 7950 || value == 10200 || value == 12200) {
                Log.i(TAG, "CONFIG_OVERRIDE property=" + name + " raw=" + raw + " effective=" + value);
                return value;
            }
        } catch (Throwable ignored) {}
        Log.w(TAG, "CONFIG_REJECT property=" + name + " raw=" + raw + " fallback=12200");
        return 12200;
    }

    static int dtmfPt(boolean amrNb) {
        return integer(amrNb ? "ap_dtmf_nb_pt" : "ap_dtmf_wb_pt",
                amrNb ? 110 : 111, 96, 127);
    }

    static int dtmfClock(int mediaClock) {
        String name = PREFIX + "ap_dtmf_clock";
        String raw = SystemProperties.get(name, "").trim();
        if (raw.length() == 0) return mediaClock;
        try {
            int value = Integer.parseInt(raw);
            if ((value == 8000 || value == 16000) && value == mediaClock) {
                Log.i(TAG, "CONFIG_OVERRIDE property=" + name + " raw=" + raw + " effective=" + value);
                return value;
            }
        } catch (Throwable ignored) {}
        Log.w(TAG, "CONFIG_REJECT property=" + name + " raw=" + raw
                + " mediaClock=" + mediaClock + " fallback=" + mediaClock);
        return mediaClock;
    }

    static void logSnapshot(int mediaClock) {
        Log.i(TAG, "SNAPSHOT latchRung=" + integer("ap_latch_probe_rung", 4, 0, 5)
                + " latchDelayMs=" + integer("ap_latch_probe_delay_ms", 1500, 0, 60000)
                + " radioDwellMs=" + integer("ap_latch_probe_radio_dwell_ms", 400, 200, 10000)
                + " rotate=" + bool("ap_media_rotate_ports", false)
                + " rtp=" + integer("ap_rtp_port", 1234, 1, 65535)
                + " rtcp=" + integer("ap_rtcp_port", 1235, 1, 65535)
                + " playback=" + bool("ap_rtp_playback", true)
                + " uplink=" + bool("ap_uplink_rtp", true)
                + " source=" + source()
                + " seconds=" + uplinkSeconds()
                + " voicePtOverride=" + voicePtOverride()
                + " nbBitrate=" + uplinkBitrate(true)
                + " wbBitrate=" + uplinkBitrate(false)
                + " dtmf=" + bool("ap_dtmf_rtp", true)
                + " nbDtmfPt=" + dtmfPt(true)
                + " wbDtmfPt=" + dtmfPt(false)
                + " mediaClock=" + mediaClock
                + " rtcpRr=" + bool("ap_rtcp_rr", true)
                + " rtcpRrInterval=" + integer("ap_rtcp_rr_interval", 5, 3, 10));
    }
}
