// SPDX-License-Identifier: GPL-2.0
// RFC 4867 AMR-WB payload handling adapted from floss-ims SipAmrRtpPayload.kt.
package com.sec.internal.google;

import android.media.AudioAttributes;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.media.MediaCodec;
import android.media.MediaFormat;
import android.net.Network;
import android.os.SystemProperties;
import android.util.Log;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetSocketAddress;
import java.net.InetAddress;
import java.net.SocketTimeoutException;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.TreeMap;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;

/** Property-gated RFC4867 AMR-NB/WB downlink playback with optional RTCP feedback. */
public final class ApRtpReceivePoc {
    private static final String TAG = "AP_RTP_PLAYBACK";
    private static final String GATE = "persist.vendor.ims.ap_rtp_playback";
    private static final ConcurrentHashMap<Integer, Probe> PROBES = new ConcurrentHashMap<>();
    private static final AtomicLong GENERATION = new AtomicLong();
    private static final Object LIFECYCLE_LOCK = new Object();
    private ApRtpReceivePoc() {}

    private static int amrBits(int ft, boolean nb) {
        if (nb) {
            switch (ft) {
                case 0: return 95;
                case 1: return 103;
                case 2: return 118;
                case 3: return 134;
                case 4: return 148;
                case 5: return 159;
                case 6: return 204;
                case 7: return 244;
                case 8: return 39;
                default: throw new IllegalArgumentException("unsupported AMR-NB FT=" + ft);
            }
        }
        switch (ft) {
            case 0: return 132;
            case 1: return 177;
            case 2: return 253;
            case 3: return 285;
            case 4: return 317;
            case 5: return 365;
            case 6: return 397;
            case 7: return 461;
            case 8: return 477;
            case 9: return 40;
            default: throw new IllegalArgumentException("unsupported FT=" + ft);
        }
    }

    public static boolean onDtmfStart(char c) { return routeDtmf(c, false); }
    public static boolean onDtmfStop() {
        Probe target=null;for(Probe p:PROBES.values())if(p.rtpEndpointLocked&&p.uplink!=null&&p.uplink.isVoiceActive()){if(target!=null){Log.w(TAG,"DTMF_FALLBACK reason=multiple_probes");return false;}target=p;}
        if(target==null){Log.w(TAG,"DTMF_FALLBACK reason=no_active_uplink");return false;}
        boolean owned=target.uplink.stopDtmf();Log.i(TAG,"AP_DTMF_TAKEOVER action=stop result="+owned);return owned;
    }
    public static boolean onDtmfPulse(char c) { return routeDtmf(c, true); }
    private static boolean routeDtmf(char c, boolean pulse) {
        if(!ApMediaConfigPoc.bool("ap_dtmf_rtp",true))return false;
        int event=c>='0'&&c<='9'?c-'0':c=='*'?10:c=='#'?11:-1;if(event<0){Log.w(TAG,"DTMF_FALLBACK reason=invalid_char char="+(int)c);return false;}
        Probe target=null;for(Probe p:PROBES.values())if(p.running.get()&&p.mediaResolved&&p.rtpEndpointLocked&&p.uplink!=null&&p.uplink.isVoiceActive()){if(target!=null){Log.w(TAG,"DTMF_FALLBACK reason=multiple_probes");return false;}target=p;}
        if(target==null){Log.w(TAG,"DTMF_FALLBACK reason=no_active_uplink");return false;}boolean owned=pulse?target.uplink.pulseDtmf(event):target.uplink.startDtmf(event);Log.i(TAG,"AP_DTMF_TAKEOVER action="+(pulse?"pulse":"start")+" event="+event+" result="+owned+" voicePt="+target.uplinkPt+" codec="+target.codecProfile);return owned;
    }

    public static void onEstablished(int callId) { onEstablished(callId, null); }
    public static void onEstablished(int callId, Network network) {
        ApUplinkCapturePoc.onEstablished(callId);
        String playbackRaw = SystemProperties.get(GATE, "");
        boolean playbackEnabled = ApMediaConfigPoc.bool("ap_rtp_playback", true);
        Log.i(TAG, "MEDIA_GATE callId=" + callId + " playbackRaw="
                + (playbackRaw.length() == 0 ? "<unset>" : playbackRaw)
                + " playbackEnabled=" + playbackEnabled);
        if (!playbackEnabled) return;
        synchronized (LIFECYCLE_LOCK) {
            if (PROBES.containsKey(Integer.valueOf(callId))) {
                Log.i(TAG, "ESTABLISHED_DUPLICATE callId=" + callId);
                return;
            }
        }
        ApMediaNegotiationPoc.Snapshot media =
                ApMediaNegotiationPoc.awaitUniqueReady(750);
        int rxPt = media == null ? -1 : media.rxPt;
        int txPt = media == null ? -1 : media.txPt;
        String negotiatedCodec = media == null ? null : media.codec;
        String ptSource = media == null ? "wire-profile-pending" : "negotiated-rx";
        int baseRtp = ApMediaConfigPoc.integer("ap_rtp_port", 1234, 1, 65535);
        int baseRtcp = ApMediaConfigPoc.integer("ap_rtcp_port", 1235, 1, 65535);
        boolean rotate = ApMediaConfigPoc.bool("ap_media_rotate_ports", false);
        int slot = rotate ? Math.max(0, callId - 1) : 0;
        int rtp = baseRtp + slot * 2;
        int rtcp = baseRtcp + slot * 2;
        Log.i(TAG, "PORT_SELECT callId=" + callId + " rotate=" + rotate
                + " slot=" + slot + " base=" + baseRtp + "/" + baseRtcp
                + " selected=" + rtp + "/" + rtcp);
        Log.i(TAG, "MEDIA_SELECT callId=" + callId
                + " channel=" + (media == null ? -1 : media.channel)
                + " generation=" + (media == null ? -1 : media.generation)
                + " codec=" + negotiatedCodec + " rxPt=" + rxPt + " txPt=" + txPt
                + " ptSource=" + ptSource);
        if (rtp < 1 || rtp > 65535 || rtcp < 1 || rtcp > 65535 || rtp == rtcp
                || rxPt > 127 || txPt > 127) {
            Log.e(TAG, "START_REJECT callId=" + callId + " rtp=" + rtp
                    + " rtcp=" + rtcp + " rxPt=" + rxPt + " txPt=" + txPt);
            return;
        }
        synchronized (LIFECYCLE_LOCK) {
            if (PROBES.containsKey(Integer.valueOf(callId))) {
                Log.i(TAG, "ESTABLISHED_DUPLICATE callId=" + callId);
                return;
            }
            stopAllLocked("new_call_" + callId);
            long generation = GENERATION.incrementAndGet();
            Probe probe = new Probe(callId, generation, rtp, rtcp, rxPt, txPt,
                    negotiatedCodec, network);
            PROBES.put(Integer.valueOf(callId), probe);
            Log.i(TAG, "PROBE_CREATE callId=" + callId + " generation=" + generation
                    + " mapSize=" + PROBES.size());
            probe.start();
        }
    }
    /** Refresh negotiated media for a repeated early-media update on the same call. */
    public static void onEarlyMediaStarted(int callId) {
        Log.i(TAG, "EARLY_MEDIA_START callId=" + callId);
        synchronized (LIFECYCLE_LOCK) {
            Probe existing = PROBES.get(Integer.valueOf(callId));
            if (existing != null) {
                ApMediaNegotiationPoc.Snapshot media = ApMediaNegotiationPoc.awaitUniqueReady(750);
                if (media != null) {
                    existing.refreshNegotiation(media);
                    existing.wireRelockArmed = true;
                    Log.i(TAG, "EARLY_MEDIA_REFRESH callId=" + callId
                            + " generation=" + media.generation + " codec=" + media.codec
                            + " rxPt=" + media.rxPt + " txPt=" + media.txPt);
                } else {
                    existing.armWireRelock();
                    Log.w(TAG, "EARLY_MEDIA_REFRESH_PENDING callId=" + callId
                            + " EARLY_MEDIA_REFRESH_ARMED=true");
                }
                return;
            }
        }
        onEstablished(callId, null);
    }

    public static void onEnded(int callId) { ApUplinkCapturePoc.onEnded(callId); stop(callId, "ended"); }
    public static void onError(int callId) { ApUplinkCapturePoc.onError(callId); stop(callId, "error"); }
    public static void onTerminated(int callId, String reason) { stop(callId, reason); }
    public static void stopAll(String why) { synchronized (LIFECYCLE_LOCK) { stopAllLocked(why); } }
    private static void stopAllLocked(String why) {
        long start = android.os.SystemClock.elapsedRealtime(); int before = PROBES.size();
        Probe[] probes = PROBES.values().toArray(new Probe[0]);
        for (Probe p : probes) { PROBES.remove(p.callId, p); p.stop(why); }
        Log.i(TAG, "STOP_ALL reason=" + why + " before=" + before + " after=" + PROBES.size() + " elapsedMs=" + (android.os.SystemClock.elapsedRealtime()-start));
    }
    private static void stop(int callId, String why) {
        synchronized (LIFECYCLE_LOCK) { Probe p = PROBES.remove(callId); if (p != null) p.stop(why); }
    }

    private static final class Frame {
        final int seq; final long timestamp; final byte[] au;
        Frame(int s, long t, byte[] a) { seq=s; timestamp=t; au=a; }
    }
    private static final class BitReader {
        final byte[] data; final int endBit; int bit;
        BitReader(byte[] d, int off, int len) { data=d; bit=off*8; endBit=(off+len)*8; }
        int remaining() { return endBit-bit; }
        int read(int n) {
            if (n < 0 || n > 31 || remaining() < n) throw new IllegalArgumentException("short payload");
            int v=0; while(n-- > 0) v=(v<<1)|((data[bit>>3]>>(7-(bit++&7)))&1); return v;
        }
        byte[] readStorage(int ft, int q, int bits) {
            byte[] out=new byte[1+(bits+7)/8]; out[0]=(byte)((ft<<3)|((q&1)<<2));
            for(int i=0;i<bits;i++) if(read(1)!=0) out[1+(i>>3)]|=(byte)(0x80>>(i&7));
            return out;
        }
    }

    private static final class Probe {
        final int callId, rtpPort, rtcpPort;
        volatile int expectedPt, uplinkPt;
        final long generation;
        volatile String codecProfile, codecMime, txPtSource;
        volatile boolean mediaResolved, amrNb, wireRelockArmed;
        volatile int sampleRate, timestampStep;
        final Network network;
        final boolean rrEnabled = ApMediaConfigPoc.bool("ap_rtcp_rr", true);
        final int rrIntervalSec = ApMediaConfigPoc.integer("ap_rtcp_rr_interval", 5, 3, 10);
        final long randomReceiverSsrc = new SecureRandom().nextInt() & 0xffffffffL;
        final String cname = Long.toHexString(new SecureRandom().nextLong()) + "@android";
        final String mode = SystemProperties.get("persist.vendor.ims.ap_rtp_mode", "play");
        final boolean decodeEnabled = !"capture".equals(mode);
        final boolean trackEnabled = "play".equals(mode);
        final int captureMax = clamp(SystemProperties.getInt("persist.vendor.ims.ap_rtp_capture_bytes", 1048575), 0, 8388607);
        final int jitterMax = clamp(SystemProperties.getInt("persist.vendor.ims.ap_rtp_jitter", 12), 3, 50);
        final AtomicBoolean running = new AtomicBoolean(true), cleanupStarted = new AtomicBoolean(false), cleanupComplete = new AtomicBoolean(false);
        final Object completionLock = new Object();
        final Object queueLock = new Object(); final TreeMap<Integer,ArrayList<Frame>> queue = new TreeMap<>();
        volatile DatagramSocket rtpSocket, rtcpSocket; volatile MediaCodec codec; volatile AudioTrack track;
        volatile BufferedOutputStream capture;
        volatile Thread mediaMilestoneThread;
        long startElapsedMs, firstRtpElapsedMs=-1, firstRtcpElapsedMs=-1;
        volatile String rtpSocketAddress="unbound", rtcpSocketAddress="unbound";
        volatile String firstRtpSource="none", firstRtcpSource="none";
        long capturedBytes;
        volatile Thread mainThread, rtcpThread, decodeThread;
        long rtpPackets, rtpBytes, rtcpPackets, rtcpBytes, badRtp, wrongPt, malformed, frames, decodedBytes, playedBytes, dropped, reordered;
        long rrSent, rrErrors, endpointChanges, remoteSsrc=-1, baseExtSeq=-1, maxExtSeq=-1, received, expectedPrior, receivedPrior, jitterQ4, previousTransit, lastSrMiddle32, lastSrArrivalMs, lastRrMs;
        final long[] downlinkFt=new long[16],downlinkCmr=new long[16];long downlinkQ0,downlinkQ1,downlinkMarkers,downlinkPayloadBytes,downlinkTimestampStep=-1,previousRtpTimestamp=-1;
        volatile InetAddress remoteRtcpAddress,rtpCandidateAddress,remoteRtpAddress; volatile int remoteRtcpPort,rtpCandidatePort,remoteRtpPort; volatile boolean networkBound,rtpEndpointLocked;
        volatile ApRtpUplinkPoc uplink;
        long rtpCandidateSsrc=-1;int rtpCandidateCount;
        volatile InetAddress profileCandidateAddress;
        volatile int profileCandidatePort=-1, profileCandidatePt=-1, profileCandidateCount;
        volatile long profileCandidateSsrc=-1, profileCandidateTimestamp=-1;
        volatile int profileCandidateSeq=-1;
        volatile boolean profileCandidateNb;
        int expectedSeq=-1; boolean transitValid;
        Probe(int id, long gen, int rtp, int rtcp, int rxPt, int txPt,
                String negotiatedCodec, Network n) {
            callId = id;
            generation = gen;
            rtpPort = rtp;
            rtcpPort = rtcp;
            expectedPt = rxPt;
            uplinkPt = txPt;
            mediaResolved = negotiatedCodec != null;
            if (mediaResolved) {
                commitProfile("AMR".equalsIgnoreCase(negotiatedCodec)
                        || "AMR-NB".equalsIgnoreCase(negotiatedCodec), rxPt, false);
                txPtSource = "negotiated";
            } else {
                codecProfile = "unresolved";
                codecMime = "unresolved";
                sampleRate = 0;
                timestampStep = 0;
                txPtSource = "pending";
            }
            network = n;
        }
        synchronized void armWireRelock() {
            wireRelockArmed = true;
            profileCandidateCount = 0;
            profileCandidatePt = -1;
            profileCandidateSeq = -1;
            profileCandidateTimestamp = -1;
            profileCandidateSsrc = -1;
            profileCandidateAddress = null;
            profileCandidatePort = -1;
            Log.i(TAG, "EARLY_MEDIA_REFRESH_ARMED callId=" + callId
                    + " oldPt=" + expectedPt + " codec=" + codecProfile);
        }

        synchronized void refreshNegotiation(ApMediaNegotiationPoc.Snapshot media) {
            if (media == null || media.codec == null || media.rxPt < 0 || media.txPt < 0) return;
            boolean nb = media.amrNb();
            expectedPt = media.rxPt;
            uplinkPt = media.txPt;
            txPtSource = "early-media-refresh";
            String desired = nb ? "amr-nb" : "amr-wb";
            if (!mediaResolved || !desired.equals(codecProfile)) {
                commitProfile(nb, media.rxPt, false);
                mediaResolved = true;
            }
            synchronized (queueLock) { queueLock.notifyAll(); }
        }

        synchronized void commitProfile(boolean nb, int downlinkPt, boolean fromWire) {
            if (mediaResolved && fromWire) return;
            amrNb = nb;
            codecProfile = nb ? "amr-nb" : "amr-wb";
            sampleRate = nb ? 8000 : 16000;
            timestampStep = nb ? 160 : 320;
            codecMime = nb ? "audio/3gpp" : "audio/amr-wb";
            expectedPt = downlinkPt;
            if (fromWire) {
                int override = ApMediaConfigPoc.voicePtOverride();
                if (override >= 96 && override <= 127) {
                    uplinkPt = override;
                    txPtSource = "diagnostic-override";
                } else {
                    uplinkPt = downlinkPt;
                    txPtSource = "wire-symmetric-assumption";
                }
                mediaResolved = true;
                synchronized (queueLock) { queueLock.notifyAll(); }
            }
        }
        static int clamp(int x,int lo,int hi){return Math.max(lo,Math.min(hi,x));}
        void start(){mainThread=new Thread(this::run,"ap-rtp-rx-"+callId);mainThread.setDaemon(true);mainThread.start();}
        DatagramSocket bind(int port)throws Exception{DatagramSocket s=new DatagramSocket(null);s.setReuseAddress(false);s.bind(new InetSocketAddress(port));s.setSoTimeout(500);return s;}
        void bindNetwork(DatagramSocket rtp,DatagramSocket rtcp){if(network==null){Log.w(TAG,"NETWORK_UNAVAILABLE callId="+callId+" rr disabled");return;}try{network.bindSocket(rtp);network.bindSocket(rtcp);networkBound=true;}catch(Throwable e){networkBound=false;Log.w(TAG,"NETWORK_BIND_FAIL callId="+callId+" rr disabled",e);}}
        void run(){
            try{
                startElapsedMs=android.os.SystemClock.elapsedRealtime();
                rtpSocket=bind(rtpPort); rtcpSocket=bind(rtcpPort); bindNetwork(rtpSocket,rtcpSocket);
                rtpSocketAddress=String.valueOf(rtpSocket.getLocalSocketAddress());
                rtcpSocketAddress=String.valueOf(rtcpSocket.getLocalSocketAddress());
                Log.i(TAG,"AP_MEDIA_LEDGER START callId="+callId+" generation="+generation+" rtpListen="+rtpSocketAddress+" rtcpListen="+rtcpSocketAddress+" network="+network+" networkBound="+networkBound+" pt="+expectedPt+" codec="+codecProfile);
                Log.i(TAG,"START callId="+callId+" generation="+generation+" rtp="+rtpPort+" rtcp="+rtcpPort+" pt="+expectedPt+" codecProfile="+codecProfile+" sampleRate="+sampleRate+" mode="+mode+" decode="+decodeEnabled+" track="+trackEnabled+" captureMax="+captureMax+" network="+(network!=null)+" networkBound="+networkBound+" rr="+rrEnabled+" rrInterval="+rrIntervalSec+" txPtSource="+txPtSource+" rtpSend=false rtcpFeedbackOnly=true");
                mediaMilestoneThread=new Thread(this::logMediaMilestone,"ap-media-ledger-"+callId);mediaMilestoneThread.setDaemon(true);mediaMilestoneThread.start();
                if(captureMax>0)try{File dir=new File("/data/vendor/ims");if(!dir.exists()&&!dir.mkdirs())throw new IllegalStateException("mkdir failed: "+dir);capture=new BufferedOutputStream(new FileOutputStream(new File(dir,"desem22_call_"+callId+".rtpdump"),false));}catch(Throwable e){Log.w(TAG,"CAPTURE_DISABLED callId="+callId,e);capture=null;}
                rtcpThread=new Thread(this::receiveRtcp,"ap-rtcp-rx-"+callId);rtcpThread.setDaemon(true);rtcpThread.start();
                if(decodeEnabled){decodeThread=new Thread(this::decodeLoop,"ap-amrwb-dec-"+callId);decodeThread.setDaemon(true);decodeThread.start();}
                receiveRtp();
            }catch(Throwable e){if(running.get())Log.e(TAG,"FAIL callId="+callId,e);}
            finally{cleanup("exit");}
        }
        void logMediaMilestone(){try{Thread.sleep(3000);}catch(InterruptedException ignored){return;}if(running.get()&&firstRtpElapsedMs<0&&firstRtcpElapsedMs<0)Log.w(TAG,"AP_MEDIA_LEDGER NO_UDP_AFTER_3S callId="+callId+" generation="+generation+" rtpListen="+rtpSocketAddress+" rtcpListen="+rtcpSocketAddress+" network="+network+" networkBound="+networkBound+" pt="+expectedPt+" codec="+codecProfile);}
        void receiveRtp(){byte[] b=new byte[4096];DatagramPacket p=new DatagramPacket(b,b.length);while(running.get())try{
            p.setLength(b.length);rtpSocket.receive(p);rtpPackets++;rtpBytes+=p.getLength();if(firstRtpElapsedMs<0){firstRtpElapsedMs=android.os.SystemClock.elapsedRealtime()-startElapsedMs;firstRtpSource=p.getAddress().getHostAddress()+":"+p.getPort();Log.i(TAG,"AP_MEDIA_LEDGER FIRST_RTP callId="+callId+" generation="+generation+" source="+firstRtpSource+" elapsedMs="+firstRtpElapsedMs+" bytes="+p.getLength());}capturePacket(b,p.getLength());parseRtp(b,p.getLength(),p);
        }catch(SocketTimeoutException ignored){}catch(Throwable e){if(running.get())Log.e(TAG,"RTP_FAIL callId="+callId,e);break;}}
        void capturePacket(byte[] b,int n){BufferedOutputStream o=capture;if(o==null||capturedBytes>=captureMax)return;try{int take=(int)Math.min(n,captureMax-capturedBytes);o.write((take>>>8)&255);o.write(take&255);o.write(b,0,take);capturedBytes+=take+2;}catch(Throwable e){Log.w(TAG,"CAPTURE_FAIL callId="+callId,e);try{o.close();}catch(Throwable ignored){}capture=null;}}
        void receiveRtcp(){byte[] b=new byte[2048];DatagramPacket p=new DatagramPacket(b,b.length);while(running.get())try{
            p.setLength(b.length);rtcpSocket.receive(p);rtcpPackets++;rtcpBytes+=p.getLength();if(firstRtcpElapsedMs<0){firstRtcpElapsedMs=android.os.SystemClock.elapsedRealtime()-startElapsedMs;firstRtcpSource=p.getAddress().getHostAddress()+":"+p.getPort();Log.i(TAG,"AP_MEDIA_LEDGER FIRST_RTCP callId="+callId+" generation="+generation+" source="+firstRtcpSource+" elapsedMs="+firstRtcpElapsedMs+" bytes="+p.getLength());}if(parseCompoundRtcp(b,p.getLength()))learnEndpoint(p);maybeSendReceiverReport();
            int type=p.getLength()>=2?(b[1]&255):-1;
            if(rtcpPackets<=5||rtcpPackets%100==0)Log.i(TAG,"RTCP_RX callId="+callId+" count="+rtcpPackets+" bytes="+p.getLength()+" type="+type);
        }catch(SocketTimeoutException ignored){maybeSendReceiverReport();}catch(Throwable e){if(running.get())Log.e(TAG,"RTCP_FAIL callId="+callId,e);break;}}
        static long u32(byte[] b,int o){return ((long)(b[o]&255)<<24)|((long)(b[o+1]&255)<<16)|((long)(b[o+2]&255)<<8)|(b[o+3]&255);}
        static void put16(byte[] b,int o,long v){b[o]=(byte)(v>>>8);b[o+1]=(byte)v;}
        static void put32(byte[] b,int o,long v){b[o]=(byte)(v>>>24);b[o+1]=(byte)(v>>>16);b[o+2]=(byte)(v>>>8);b[o+3]=(byte)v;}
        synchronized void updateReception(int seq,long ts,long ssrc){if(remoteSsrc<0){remoteSsrc=ssrc;maxExtSeq=baseExtSeq=seq;received=1;previousTransit=System.nanoTime()/(amrNb?125000L:62500L)-ts;transitValid=true;return;}if(remoteSsrc!=ssrc)return;long x=(maxExtSeq&~0xffffL)|seq;if(x+0x8000L<maxExtSeq)x+=0x10000L;else if(x-0x8000L>maxExtSeq)x-=0x10000L;if(x>maxExtSeq)maxExtSeq=x;received++;long transit=System.nanoTime()/62500L-ts;if(transitValid){long d=Math.abs(transit-previousTransit);jitterQ4+=d-jitterQ4/16;}previousTransit=transit;transitValid=true;}
        void learnEndpoint(DatagramPacket p){InetAddress a=p.getAddress();int port=p.getPort();if(a==null||port<1||port>65535||a.isAnyLocalAddress()||a.isMulticastAddress())return;if(!a.equals(remoteRtcpAddress)||port!=remoteRtcpPort){remoteRtcpAddress=a;remoteRtcpPort=port;endpointChanges++;Log.i(TAG,"RTCP_ENDPOINT callId="+callId+" address="+a.getHostAddress()+" port="+port);}}
        synchronized boolean parseCompoundRtcp(byte[] b,int n){int o=0;boolean valid=false;while(o+4<=n){int len=((((b[o+2]&255)<<8)|(b[o+3]&255))+1)*4;int type=b[o+1]&255;if((b[o]&0xc0)!=0x80||type<192||type>223||len<4||o+len>n){malformed++;return false;}valid=true;if(type==200&&len>=28){long ssrc=u32(b,o+4);if(remoteSsrc<0||remoteSsrc==ssrc){remoteSsrc=ssrc;lastSrMiddle32=((u32(b,o+8)&0xffffL)<<16)|(u32(b,o+12)>>>16);lastSrArrivalMs=android.os.SystemClock.elapsedRealtime();}}o+=len;}if(o!=n){malformed++;return false;}return valid;}
        long rrSenderSsrc(){String raw=SystemProperties.get("persist.vendor.ims.ap_rtcp_rr_ssrc","").trim();if(raw.isEmpty())return randomReceiverSsrc;try{long v=raw.startsWith("0x")||raw.startsWith("0X")?Long.parseLong(raw.substring(2),16):Long.parseLong(raw);return v>=0&&v<=0xffffffffL?v:randomReceiverSsrc;}catch(Throwable ignored){return randomReceiverSsrc;}}
        synchronized byte[] buildReceiverReportCompound(long sender){byte[] cn=cname.getBytes(StandardCharsets.UTF_8);int item=2+cn.length+1,sdes=4+4+((item+3)&~3);byte[] out=new byte[32+sdes];out[0]=(byte)0x81;out[1]=(byte)201;put16(out,2,7);put32(out,4,sender);put32(out,8,remoteSsrc);long expected=maxExtSeq>=baseExtSeq?maxExtSeq-baseExtSeq+1:0,lost=Math.max(-0x800000L,Math.min(0x7fffffL,expected-received));long ie=expected-expectedPrior,ir=received-receivedPrior,il=ie-ir;int fraction=ie<=0||il<=0?0:(int)Math.min(255,(il<<8)/ie);expectedPrior=expected;receivedPrior=received;out[12]=(byte)fraction;out[13]=(byte)(lost>>>16);out[14]=(byte)(lost>>>8);out[15]=(byte)lost;put32(out,16,maxExtSeq);put32(out,20,jitterQ4/16);put32(out,24,lastSrMiddle32);long dlsr=lastSrArrivalMs==0?0:Math.min(0xffffffffL,(android.os.SystemClock.elapsedRealtime()-lastSrArrivalMs)*65536L/1000L);put32(out,28,dlsr);int o=32;out[o]=(byte)0x81;out[o+1]=(byte)202;put16(out,o+2,sdes/4-1);put32(out,o+4,sender);out[o+8]=1;out[o+9]=(byte)cn.length;System.arraycopy(cn,0,out,o+10,cn.length);return out;}
        void maybeSendReceiverReport(){long now=android.os.SystemClock.elapsedRealtime();if(!rrEnabled||!networkBound||now-lastRrMs<rrIntervalSec*1000L)return;DatagramSocket s=rtcpSocket;InetAddress a=remoteRtcpAddress;int port=remoteRtcpPort;if(s==null||a==null||remoteSsrc<0)return;lastRrMs=now;sendReceiverReport(s,a,port);}
        void sendReceiverReport(DatagramSocket s,InetAddress a,int port){try{long sender=rrSenderSsrc();byte[] data=buildReceiverReportCompound(sender);s.send(new DatagramPacket(data,data.length,a,port));rrSent++;if(rrSent<=3||rrSent%12==0)Log.i(TAG,"RTCP_RR_TX callId="+callId+" count="+rrSent+" bytes="+data.length+" rrSenderSsrc="+sender+" remoteReportSsrc="+remoteSsrc+" endpoint="+a.getHostAddress()+":"+port);}catch(Throwable e){rrErrors++;if(rrErrors<=3)Log.w(TAG,"RTCP_RR_FAIL callId="+callId+" count="+rrErrors,e);}}
        synchronized void observeRtpEndpoint(DatagramPacket p,long ssrc){InetAddress a=p.getAddress();int port=p.getPort();if(a==null||port<1||port>65535||a.isAnyLocalAddress()||a.isMulticastAddress())return;if(rtpEndpointLocked){if(!a.equals(remoteRtpAddress)||port!=remoteRtpPort||ssrc!=rtpCandidateSsrc){endpointChanges++;ApRtpUplinkPoc u=uplink;uplink=null;if(u!=null)u.stop("endpoint_change");Log.e(TAG,"UPLINK_ENDPOINT_CHANGE callId="+callId+" address="+a.getHostAddress()+":"+port+" ssrc="+ssrc);}return;}if(a.equals(rtpCandidateAddress)&&port==rtpCandidatePort&&ssrc==rtpCandidateSsrc)rtpCandidateCount++;else{rtpCandidateAddress=a;rtpCandidatePort=port;rtpCandidateSsrc=ssrc;rtpCandidateCount=1;}if(rtpCandidateCount==10){remoteRtpAddress=a;remoteRtpPort=port;rtpEndpointLocked=true;Log.i(TAG,"UPLINK_ENDPOINT_LOCK callId="+callId+" address="+a.getHostAddress()+":"+port+" remoteSsrc="+ssrc);if(ApMediaConfigPoc.bool("ap_uplink_rtp",true)&&networkBound){String source=ApMediaConfigPoc.source();Log.i(TAG,"UPLINK_GATE callId="+callId+" enabled=true source="+source);ApMediaConfigPoc.logSnapshot(sampleRate);uplink=new ApRtpUplinkPoc(rtpSocket,a,port,uplinkPt,rrSenderSsrc(),amrNb);uplink.start();}else Log.w(TAG,"UPLINK_GATE callId="+callId+" enabled="+ApMediaConfigPoc.bool("ap_uplink_rtp",true)+" networkBound="+networkBound);}}
        boolean validAmrAcquisitionPayload(byte[] data, int off, int len, boolean nb) {
            try {
                BitReader reader = new BitReader(data, off, len);
                int cmr = reader.read(4);
                int follow = reader.read(1);
                int ft = reader.read(4);
                int q = reader.read(1);
                int maxCmr = nb ? 7 : 8;
                if (!((cmr >= 0 && cmr <= maxCmr) || cmr == 15)
                        || follow != 0 || ft < 0 || ft > 8 || q != 1) return false;
                int speechBits = amrBits(ft, nb);
                int expectedBytes = (10 + speechBits + 7) / 8;
                if (len != expectedBytes || reader.remaining() < speechBits) return false;
                for (int i = 0; i < speechBits; i++) reader.read(1);
                while (reader.remaining() > 0) if (reader.read(1) != 0) return false;
                return true;
            } catch (Throwable invalid) {
                return false;
            }
        }
        synchronized boolean observeWireProfile(int pt, int seq, long ts, long ssrc,
                DatagramPacket packet, byte[] data, int off, int len) {
            if (wireRelockArmed && pt != expectedPt) {
                return observeWireRelock(pt, seq, ts, ssrc, packet, data, off, len);
            }
            if (mediaResolved) return pt == expectedPt;
            int dtmfPt = ApMediaConfigPoc.integer("ap_dtmf_pt", 111, 96, 127);
            if (pt == dtmfPt || pt < 0 || pt > 127 || packet.getAddress() == null) return false;
            boolean nbValid = validAmrAcquisitionPayload(data, off, len, true);
            boolean wbValid = validAmrAcquisitionPayload(data, off, len, false);
            if (nbValid == wbValid) {
                profileCandidateCount = 0;
                return false;
            }
            boolean nb = nbValid;
            int step = nb ? 160 : 320;
            boolean same = pt == profileCandidatePt && nb == profileCandidateNb
                    && ssrc == profileCandidateSsrc
                    && packet.getPort() == profileCandidatePort
                    && packet.getAddress().equals(profileCandidateAddress)
                    && profileCandidateSeq >= 0 && seq == ((profileCandidateSeq + 1) & 0xffff)
                    && profileCandidateTimestamp >= 0
                    && ((ts - profileCandidateTimestamp) & 0xffffffffL) == step;
            if (same) {
                profileCandidateCount++;
            } else {
                profileCandidatePt = pt;
                profileCandidateNb = nb;
                profileCandidateAddress = packet.getAddress();
                profileCandidatePort = packet.getPort();
                profileCandidateSsrc = ssrc;
                profileCandidateCount = 1;
            }
            profileCandidateSeq = seq;
            profileCandidateTimestamp = ts;
            if (profileCandidateCount < 10) return false;
            commitProfile(nb, profileCandidatePt, true);
            Log.i(TAG, "WIRE_PROFILE_LOCK callId=" + callId + " codec=" + codecProfile
                    + " pt=" + expectedPt + " step=" + timestampStep
                    + " packets=" + profileCandidateCount + " txPt=" + uplinkPt
                    + " txPtSource=" + txPtSource
                    + " validation=rfc4867-seq-ts-ssrc-source");
            return true;
        }
        private synchronized boolean observeWireRelock(int pt, int seq, long ts, long ssrc,
                DatagramPacket packet, byte[] data, int off, int len) {
            if (pt < 0 || pt > 127 || packet.getAddress() == null) return false;
            boolean nbValid = validAmrAcquisitionPayload(data, off, len, true);
            boolean wbValid = validAmrAcquisitionPayload(data, off, len, false);
            if (nbValid == wbValid) {
                profileCandidateCount = 0;
                return false;
            }
            boolean nb = nbValid;
            int step = nb ? 160 : 320;
            boolean same = pt == profileCandidatePt && nb == profileCandidateNb
                    && ssrc == profileCandidateSsrc
                    && packet.getPort() == profileCandidatePort
                    && packet.getAddress().equals(profileCandidateAddress)
                    && profileCandidateSeq >= 0 && seq == ((profileCandidateSeq + 1) & 0xffff)
                    && profileCandidateTimestamp >= 0
                    && ((ts - profileCandidateTimestamp) & 0xffffffffL) == step;
            if (same) profileCandidateCount++;
            else {
                profileCandidatePt = pt;
                profileCandidateNb = nb;
                profileCandidateAddress = packet.getAddress();
                profileCandidatePort = packet.getPort();
                profileCandidateSsrc = ssrc;
                profileCandidateCount = 1;
            }
            profileCandidateSeq = seq;
            profileCandidateTimestamp = ts;
            if (profileCandidateCount < 10) return false;
            int oldPt = expectedPt;
            amrNb = nb;
            codecProfile = nb ? "amr-nb" : "amr-wb";
            sampleRate = nb ? 8000 : 16000;
            timestampStep = nb ? 160 : 320;
            codecMime = nb ? "audio/3gpp" : "audio/amr-wb";
            expectedPt = pt;
            uplinkPt = pt;
            txPtSource = "wire-relock-symmetric-assumption";
            mediaResolved = true;
            synchronized (queueLock) { queueLock.notifyAll(); }
            wireRelockArmed = false;
            Log.i(TAG, "WIRE_PROFILE_RELOCK callId=" + callId + " oldPt=" + oldPt
                    + " newPt=" + expectedPt + " codec=" + codecProfile
                    + " packets=10 validation=rfc4867-seq-ts-ssrc-source");
            return true;
        }

        void parseRtp(byte[] b,int n,DatagramPacket packet){
            try{
                if(n<12||(b[0]&0xc0)!=0x80)throw new IllegalArgumentException("version/header");
                int cc=b[0]&15;boolean ext=(b[0]&0x10)!=0,pad=(b[0]&0x20)!=0;int pt=b[1]&127;
                int seq=((b[2]&255)<<8)|(b[3]&255);long ssrc=u32(b,8);long ts=((long)(b[4]&255)<<24)|((long)(b[5]&255)<<16)|((long)(b[6]&255)<<8)|(b[7]&255);
                int off=12+cc*4;if(off>n)throw new IllegalArgumentException("csrc");
                if(ext){if(off+4>n)throw new IllegalArgumentException("extension");int words=((b[off+2]&255)<<8)|(b[off+3]&255);off+=4+words*4;if(off>n)throw new IllegalArgumentException("extension size");}
                int end=n;if(pad){int count=b[n-1]&255;if(count<1||count>end-off)throw new IllegalArgumentException("padding");end-=count;}
                if(end<=off)throw new IllegalArgumentException("empty");
                if(pt!=expectedPt && !observeWireProfile(pt,seq,ts,ssrc,packet,b,off,end-off)){
                    wrongPt++;
                    return;
                }
                updateReception(seq,ts,ssrc); observeWireProfile(b,off,end-off,(b[1]&0x80)!=0,ts); ArrayList<byte[]> aus=depacketize(b,off,end-off);observeRtpEndpoint(packet,ssrc);
                synchronized(queueLock){
                    int i=0;for(byte[] au:aus){int key=(seq+i)&0xffff;ArrayList<Frame> list=queue.get(key);if(list==null){list=new ArrayList<>();queue.put(key,list);}list.add(new Frame(key,ts+i*(long)timestampStep,au));i++;frames++;}
                    while(queue.size()>jitterMax){int victim=queue.firstKey();if(expectedSeq>=0){int far=-1;for(int k:queue.keySet()){int ahead=(k-expectedSeq)&0xffff;if(ahead>far&&ahead<0x8000){far=ahead;victim=k;}}}queue.remove(victim);dropped++;} queueLock.notifyAll();
                }
                if(rtpPackets<=5||rtpPackets%100==0)Log.i(TAG,"RTP_RX callId="+callId+" count="+rtpPackets+" seq="+seq+" ts="+ts+" payload="+(end-off)+" frames="+aus.size());
            }catch(Throwable e){badRtp++;if(badRtp<=5)Log.w(TAG,"RTP_DROP callId="+callId+" "+e);}
        }
        void observeWireProfile(byte[] b,int off,int len,boolean marker,long ts){
            try{BitReader r=new BitReader(b,off,len);int cmr=r.read(4),follow=r.read(1),ft=r.read(4),q=r.read(1);downlinkCmr[cmr]++;downlinkFt[ft]++;if(q==0)downlinkQ0++;else downlinkQ1++;if(marker)downlinkMarkers++;downlinkPayloadBytes+=len;if(previousRtpTimestamp>=0){long d=(ts-previousRtpTimestamp)&0xffffffffL;if(d>0&&d<0x80000000L&&(downlinkTimestampStep<0||d<downlinkTimestampStep))downlinkTimestampStep=d;}previousRtpTimestamp=ts;if(rtpPackets<=5||rtpPackets%500==0)Log.i(TAG,"WIRE_PROFILE callId="+callId+" count="+rtpPackets+" cmr="+cmr+" ft="+ft+" q="+q+" follow="+follow+" payloadBytes="+len+" marker="+marker+" tsStep="+downlinkTimestampStep);}catch(Throwable e){Log.w(TAG,"WIRE_PROFILE_FAIL callId="+callId,e);}
        }
        static String distribution(long[] counts){StringBuilder s=new StringBuilder();for(int i=0;i<counts.length;i++)if(counts[i]!=0){if(s.length()!=0)s.append(',');s.append(i).append(':').append(counts[i]);}return s.length()==0?"none":s.toString();}
        ArrayList<byte[]> depacketize(byte[] b,int off,int len){
            BitReader r=new BitReader(b,off,len);r.read(4);int follow=r.read(1);int ft=r.read(4),q=r.read(1);if(follow!=0)throw new IllegalArgumentException("multi-frame unsupported");if((amrNb&&ft>8)||(!amrNb&&ft>9))throw new IllegalArgumentException("unsupported FT="+ft);
            int bits=amrBits(ft,amrNb);if(r.remaining()<bits)throw new IllegalArgumentException("speech bits "+r.remaining()+"<"+bits);
            ArrayList<byte[]> out=new ArrayList<>();out.add(r.readStorage(ft,q,bits));return out;
        }
        void initMedia()throws Exception{
            codec=MediaCodec.createDecoderByType(codecMime);MediaFormat f=MediaFormat.createAudioFormat(codecMime,sampleRate,1);codec.configure(f,null,null,0);codec.start();
            if(trackEnabled){int min=AudioTrack.getMinBufferSize(sampleRate,AudioFormat.CHANNEL_OUT_MONO,AudioFormat.ENCODING_PCM_16BIT);track=new AudioTrack.Builder().setAudioAttributes(new AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_VOICE_COMMUNICATION).setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build()).setAudioFormat(new AudioFormat.Builder().setSampleRate(sampleRate).setChannelMask(AudioFormat.CHANNEL_OUT_MONO).setEncoding(AudioFormat.ENCODING_PCM_16BIT).build()).setBufferSizeInBytes(Math.max(min,amrNb?3200:6400)).setTransferMode(AudioTrack.MODE_STREAM).build();track.play();}
            Log.i(TAG,"MEDIA_READY callId="+callId+" codec="+codec.getName()+" track="+(track!=null));
        }
        int nearestAhead(){int best=-1,bestDistance=65535;for(int k:queue.keySet()){int d=(k-expectedSeq)&0xffff;if(best<0||d<bestDistance){bestDistance=d;best=k;}}return best;}
        Frame takeFrame()throws InterruptedException{
            synchronized(queueLock){while(running.get()&&queue.size()<3)queueLock.wait(200);if(queue.isEmpty())return null;
                if(expectedSeq<0)expectedSeq=queue.firstKey();ArrayList<Frame> list=queue.remove(expectedSeq);
                if(list==null){queueLock.wait(40);list=queue.remove(expectedSeq);if(list==null){int next=nearestAhead();if(next<0)return null;expectedSeq=next;list=queue.remove(next);dropped++;reordered++;}}
                expectedSeq=(expectedSeq+1)&0xffff;return list.get(0);
            }
        }
        void decodeLoop(){try{
            synchronized(queueLock){while(running.get()&&!mediaResolved)queueLock.wait(200);}
            if(!running.get())return;
            initMedia();MediaCodec.BufferInfo info=new MediaCodec.BufferInfo();long pts=0;while(running.get()){
            Frame f=takeFrame();if(f!=null){int in=codec.dequeueInputBuffer(10000);if(in>=0){ByteBuffer ib=codec.getInputBuffer(in);ib.clear();ib.put(f.au);codec.queueInputBuffer(in,0,f.au.length,pts,0);pts+=20000;}}
            for(;;){int out=codec.dequeueOutputBuffer(info,0);if(out<0)break;ByteBuffer ob=codec.getOutputBuffer(out);if(ob!=null&&info.size>0){byte[] pcm=new byte[info.size];ob.position(info.offset);ob.get(pcm);decodedBytes+=pcm.length;if(track!=null){int w=track.write(pcm,0,pcm.length,AudioTrack.WRITE_BLOCKING);if(w>0)playedBytes+=w;}}codec.releaseOutputBuffer(out,false);}
        }}catch(Throwable e){if(running.get())Log.e(TAG,"DECODE_FAIL callId="+callId,e);}finally{releaseMedia();}}
        void stop(String why){running.set(false);closeSockets();wakeQueue();Thread t=mainThread;if(t!=null&&t!=Thread.currentThread()){join(t,2000);if(t.isAlive()){t.interrupt();join(t,1500);}}if(t==Thread.currentThread())cleanup(why);else if(!cleanupComplete.get())cleanup(why);awaitCleanup(2000);}
        void cleanup(String why){if(cleanupStarted.compareAndSet(false,true)){running.set(false);closeSockets();wakeQueue();join(rtcpThread,1500);join(decodeThread,1500);releaseMedia();PROBES.remove(callId,this);summary(why);cleanupComplete.set(true);synchronized(completionLock){completionLock.notifyAll();}Log.i(TAG,"TEARDOWN_COMPLETE callId="+callId+" generation="+generation+" reason="+why+" mapSize="+PROBES.size()+" mainAlive="+alive(mainThread)+" rtcpAlive="+alive(rtcpThread)+" decodeAlive="+alive(decodeThread)+" socketsClosed="+(rtpSocket==null&&rtcpSocket==null)+" mediaReleased="+(codec==null&&track==null)+" uplinkReleased="+(uplink==null));}else awaitCleanup(2000);}
        void awaitCleanup(long ms){long end=android.os.SystemClock.elapsedRealtime()+ms;synchronized(completionLock){while(!cleanupComplete.get()){long left=end-android.os.SystemClock.elapsedRealtime();if(left<=0)break;try{completionLock.wait(left);}catch(InterruptedException e){Thread.currentThread().interrupt();break;}}}}
        static boolean alive(Thread t){return t!=null&&t!=Thread.currentThread()&&t.isAlive();}
        void wakeQueue(){synchronized(queueLock){queueLock.notifyAll();}}
        void closeSockets(){Thread t=mediaMilestoneThread;if(t!=null&&t!=Thread.currentThread())t.interrupt();ApRtpUplinkPoc u=uplink;uplink=null;if(u!=null)u.stop("socket_close");DatagramSocket s=rtpSocket;if(s!=null){s.close();rtpSocket=null;}s=rtcpSocket;if(s!=null){s.close();rtcpSocket=null;}BufferedOutputStream o=capture;capture=null;if(o!=null)try{o.flush();o.close();}catch(Throwable ignored){}}
        void join(Thread t,long ms){if(t!=null&&t!=Thread.currentThread())try{t.join(ms);}catch(InterruptedException e){Thread.currentThread().interrupt();}}
        synchronized void releaseMedia(){AudioTrack a=track;track=null;if(a!=null){try{a.pause();a.flush();a.stop();}catch(Throwable ignored){}try{a.release();}catch(Throwable ignored){}}MediaCodec c=codec;codec=null;if(c!=null){try{c.stop();}catch(Throwable ignored){}try{c.release();}catch(Throwable ignored){}}}
        final AtomicBoolean summarized=new AtomicBoolean(false);
        void summary(String why){if(summarized.compareAndSet(false,true)){Log.i(TAG,"AP_MEDIA_LEDGER STOP callId="+callId+" generation="+generation+" rtpSeen="+(firstRtpElapsedMs>=0)+" rtcpSeen="+(firstRtcpElapsedMs>=0)+" firstRtpMs="+firstRtpElapsedMs+" firstRtpSource="+firstRtpSource+" firstRtcpMs="+firstRtcpElapsedMs+" firstRtcpSource="+firstRtcpSource+" rtpListen="+rtpSocketAddress+" rtcpListen="+rtcpSocketAddress+" network="+network+" networkBound="+networkBound);Log.i(TAG,"STOP callId="+callId+" generation="+generation+" reason="+why+" rtpPackets="+rtpPackets+" rtpBytes="+rtpBytes+" rtcpPackets="+rtcpPackets+" rtcpBytes="+rtcpBytes+" rrSent="+rrSent+" rrErrors="+rrErrors+" remoteSsrc="+remoteSsrc+" jitter="+(jitterQ4/16)+" endpointChanges="+endpointChanges+" badRtp="+badRtp+" wrongPt="+wrongPt+" frames="+frames+" capturedBytes="+capturedBytes+" decodedBytes="+decodedBytes+" playedBytes="+playedBytes+" dropped="+dropped+" reordered="+reordered+" dlFt="+distribution(downlinkFt)+" dlCmr="+distribution(downlinkCmr)+" dlQ0="+downlinkQ0+" dlQ1="+downlinkQ1+" dlMarkers="+downlinkMarkers+" dlPayloadBytes="+downlinkPayloadBytes+" dlTimestampStep="+downlinkTimestampStep);}}
    }
}
