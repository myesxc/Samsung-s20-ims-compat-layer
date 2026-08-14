package com.sec.internal.google;

import android.content.Context;
import android.telephony.SmsManager;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.ims.aidl.IImsSmsListener;
import android.telephony.ims.stub.ImsSmsImplBase;
import android.util.Log;

public final class ModernImsSms extends ImsSmsImplBase {
    private static final String TAG = "MODERN_IMS_SMS";
    private final int phoneId;
    private final Context context;
    private final ImsSmsImpl samsung;
    private volatile boolean ready;

    public ModernImsSms(Context context, int slotId) {
        this.context = context;
        phoneId = slotId;
        samsung = new ImsSmsImpl(context, slotId, new SamsungListener());
        Log.i(TAG, "CREATE slot=" + slotId);
    }

    @Override
    public void onReady() {
        ready = true;
        Log.i(TAG, "READY slot=" + phoneId);
    }

    @Override
    public String getSmsFormat() {
        try {
            return samsung.getSmsFormat(phoneId);
        } catch (Throwable error) {
            Log.e(TAG, "FORMAT_FAILED slot=" + phoneId, error);
            return "3gpp";
        }
    }

    private static String scaHex(String address) {
        if (address == null) return null;
        String raw = address.trim();
        int scheme = raw.indexOf(':');
        if (scheme >= 0 && (raw.regionMatches(true, 0, "sip:", 0, 4)
                || raw.regionMatches(true, 0, "tel:", 0, 4))) raw = raw.substring(scheme + 1);
        int end = raw.length();
        int at = raw.indexOf('@');
        int semicolon = raw.indexOf(';');
        if (at >= 0 && at < end) end = at;
        if (semicolon >= 0 && semicolon < end) end = semicolon;
        raw = raw.substring(0, end);
        boolean international = raw.startsWith("+");
        StringBuilder digits = new StringBuilder();
        for (int i = 0; i < raw.length(); i++) {
            char c = raw.charAt(i);
            if (c >= '0' && c <= '9') digits.append(c);
        }
        if (digits.length() < 3 || digits.length() > 20) return null;
        StringBuilder hex = new StringBuilder();
        int bytes = 1 + (digits.length() + 1) / 2;
        hex.append(String.format("%02X%02X", bytes, international ? 0x91 : 0x81));
        for (int i = 0; i < digits.length(); i += 2) {
            char first = digits.charAt(i);
            char second = i + 1 < digits.length() ? digits.charAt(i + 1) : 'F';
            hex.append(second).append(first);
        }
        return hex.toString();
    }

    private String simSmsc() {
        try {
            SubscriptionManager manager = context.getSystemService(SubscriptionManager.class);
            SubscriptionInfo info = manager == null ? null
                    : manager.getActiveSubscriptionInfoForSimSlotIndex(phoneId);
            if (info == null) return null;
            String encoded = scaHex(SmsManager.getSmsManagerForSubscriptionId(
                    info.getSubscriptionId()).getSmscAddress());
            if (encoded != null) Log.i(TAG, "SMSC_RESOLVED slot=" + phoneId + " source=sim");
            return encoded;
        } catch (Throwable error) {
            Log.w(TAG, "SMSC_SIM_FAILED slot=" + phoneId, error);
            return null;
        }
    }

    private String profileSmsc() {
        try {
            Class<?> registry = Class.forName("com.sec.internal.ims.registry.ImsRegistry");
            Object registrations = registry.getMethod("getRegistrationInfoByPhoneId", int.class)
                    .invoke(null, Integer.valueOf(phoneId));
            if (!(registrations instanceof Object[])) return null;
            for (Object registration : (Object[]) registrations) {
                if (registration == null) continue;
                Object profile = registration.getClass().getMethod("getImsProfile")
                        .invoke(registration);
                if (profile == null) continue;
                Object value = profile.getClass().getMethod("getSmsPsi").invoke(profile);
                String encoded = scaHex(value == null ? null : value.toString());
                if (encoded != null) {
                    Log.i(TAG, "SMSC_RESOLVED slot=" + phoneId + " source=ims_profile");
                    return encoded;
                }
            }
        } catch (Throwable error) {
            Log.w(TAG, "SMSC_PROFILE_FAILED slot=" + phoneId, error);
        }
        return null;
    }

    private String resolveSmsc(String supplied) {
        if (supplied != null && supplied.length() > 2 && !"00".equals(supplied)) {
            Log.i(TAG, "SMSC_RESOLVED slot=" + phoneId + " source=framework");
            return supplied;
        }
        String encoded = simSmsc();
        if (encoded == null) encoded = profileSmsc();
        if (encoded == null) Log.e(TAG, "SMSC_UNAVAILABLE slot=" + phoneId);
        return encoded;
    }

    @Override
    public void sendSms(int token, int messageRef, String format, String smsc,
            boolean isRetry, byte[] pdu) {
        if (!ready || !"3gpp".equals(format) || pdu == null) {
            Log.e(TAG, "SEND_REJECT slot=" + phoneId + " token=" + token
                    + " ref=" + messageRef + " ready=" + ready
                    + " format=" + format + " bytes=" + (pdu == null ? -1 : pdu.length));
            onSendSmsResultError(token, messageRef, SEND_STATUS_ERROR,
                    SmsManager.RESULT_INVALID_SMS_FORMAT, RESULT_NO_NETWORK_ERROR);
            return;
        }
        try {
            samsung.setRetryCount(phoneId, token, isRetry ? 1 : 0);
            String samsungSmsc = resolveSmsc(smsc);
            if (samsungSmsc == null) {
                onSendSmsResultError(token, messageRef, SEND_STATUS_ERROR,
                        SmsManager.RESULT_INVALID_SMSC_ADDRESS, RESULT_NO_NETWORK_ERROR);
                return;
            }
            samsung.sendSms(phoneId, token, messageRef, format, samsungSmsc, pdu);
            Log.i(TAG, "SEND_DELEGATED slot=" + phoneId + " token=" + token
                    + " ref=" + messageRef + " retry=" + isRetry + " bytes=" + pdu.length);
        } catch (Throwable error) {
            Log.e(TAG, "SEND_FAILED slot=" + phoneId + " token=" + token
                    + " ref=" + messageRef, error);
            onSendSmsResultError(token, messageRef, SEND_STATUS_ERROR_RETRY,
                    SmsManager.RESULT_ERROR_GENERIC_FAILURE, RESULT_NO_NETWORK_ERROR);
        }
    }

    @Override
    public void acknowledgeSms(int token, int messageRef, int result) {
        try {
            samsung.acknowledgeSms(phoneId, token, token, result);
            Log.i(TAG, "ACK slot=" + phoneId + " token=" + token
                    + " ref=" + messageRef + " result=" + result);
        } catch (Throwable error) {
            Log.e(TAG, "ACK_FAILED slot=" + phoneId + " token=" + token, error);
        }
    }

    @Override
    public void acknowledgeSmsReport(int token, int messageRef, int result) {
        try {
            samsung.acknowledgeSmsReport(phoneId, token, messageRef, result);
            Log.i(TAG, "REPORT_ACK slot=" + phoneId + " token=" + token
                    + " ref=" + messageRef + " result=" + result);
        } catch (Throwable error) {
            Log.e(TAG, "REPORT_ACK_FAILED slot=" + phoneId + " token=" + token, error);
        }
    }

    @Override
    public void onMemoryAvailable(int token) {
        try {
            samsung.sendRpSmma(phoneId, "3gpp");
            onMemoryAvailableResult(token, SEND_STATUS_OK, RESULT_NO_NETWORK_ERROR);
        } catch (Throwable error) {
            Log.e(TAG, "MEMORY_FAILED slot=" + phoneId + " token=" + token, error);
            onMemoryAvailableResult(token, SEND_STATUS_ERROR,
                    RESULT_NO_NETWORK_ERROR);
        }
    }

    public void close() {
        ready = false;
        Log.i(TAG, "CLOSE slot=" + phoneId);
    }

    private final class SamsungListener extends IImsSmsListener.Stub {
        @Override
        public void onSendSmsResult(int token, int messageRef, int status, int reason,
                int networkErrorCode) {
            if (status == SEND_STATUS_OK) {
                onSendSmsResultSuccess(token, messageRef);
            } else {
                onSendSmsResultError(token, messageRef, status, reason, networkErrorCode);
            }
            Log.i(TAG, "SEND_RESULT slot=" + phoneId + " token=" + token
                    + " ref=" + messageRef + " status=" + status
                    + " reason=" + reason + " network=" + networkErrorCode);
        }

        public void onSendSmsResponse(int token, int messageRef, int status, int reason,
                int networkErrorCode, int errorClass) {
            onSendSmsResult(token, messageRef, status, reason, networkErrorCode);
        }

        @Override
        public void onSmsStatusReportReceived(int token, String format, byte[] pdu) {
            ModernImsSms.this.onSmsStatusReportReceived(token, format, pdu);
            Log.i(TAG, "STATUS_REPORT slot=" + phoneId + " token=" + token
                    + " format=" + format + " bytes=" + (pdu == null ? -1 : pdu.length));
        }

        @Override
        public void onSmsReceived(int token, String format, byte[] pdu) {
            ModernImsSms.this.onSmsReceived(token, format, pdu);
            Log.i(TAG, "RECEIVED slot=" + phoneId + " token=" + token
                    + " format=" + format + " bytes=" + (pdu == null ? -1 : pdu.length));
        }

        public void onReceiveSmsDeliveryReportAck(int messageRef, int reasonCode) {
            Log.i(TAG, "DELIVERY_ACK slot=" + phoneId + " ref=" + messageRef
                    + " reason=" + reasonCode);
        }

        @Override
        public void onMemoryAvailableResult(int token, int status, int networkErrorCode) {
            ModernImsSms.this.onMemoryAvailableResult(token, status, networkErrorCode);
        }
    }
}
