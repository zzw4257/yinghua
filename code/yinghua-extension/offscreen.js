// Yinghua · Offscreen Recorder
// Runs in a hidden offscreen document. Receives a tabCapture stream ID via
// chrome.runtime.sendMessage, attaches to it via navigator.mediaDevices,
// records with MediaRecorder, writes chunks into IndexedDB, and streams a
// 12-band VU signal to the background for forwarding to the page's content
// script. All audio stays in the browser. Nothing is uploaded.

(() => {
  'use strict';

  // ---- State ----------------------------------------------------------------

  /** @type {MediaStream | null} */
  let activeStream = null;
  /** @type {MediaRecorder | null} */
  let activeRecorder = null;
  /** @type {string | null} */
  let activeRecordingId = null;
  /** @type {Array<Blob>} */
  let activeChunks = [];
  /** @type {number} */
  let activeStartedAt = 0;
  /** @type {string} */
  let activeUrl = '';
  /** @type {string} */
  let activePlatform = '';

  // VU analyser chain (created on start, torn down on stop)
  /** @type {AudioContext | null} */
  let audioCtx = null;
  /** @type {MediaStreamAudioSourceNode | null} */
  let audioSource = null;
  /** @type {AnalyserNode | null} */
  let analyser = null;
  /** @type {number} */
  let vuRafHandle = 0;
  /** @type {number} */
  let lastVuSentAt = 0;
  const VU_INTERVAL_MS = 50; // 20 Hz ceiling
  const VU_BANDS = 12;
  /** @type {Uint8Array | null} */
  let vuFreqBuf = null;

  // ---- IndexedDB ------------------------------------------------------------

  const DB_NAME = 'yinghua-recordings';
  const DB_VERSION = 1;
  const STORE = 'recordings';

  function openDb() {
    return new Promise((resolve, reject) => {
      const req = indexedDB.open(DB_NAME, DB_VERSION);
      req.onupgradeneeded = () => {
        const db = req.result;
        if (!db.objectStoreNames.contains(STORE)) {
          const store = db.createObjectStore(STORE, { keyPath: 'id' });
          store.createIndex('startedAt', 'startedAt', { unique: false });
        }
      };
      req.onsuccess = () => resolve(req.result);
      req.onerror = () => reject(req.error);
    });
  }

  function saveRecording(record) {
    return openDb().then((db) => new Promise((resolve, reject) => {
      const tx = db.transaction(STORE, 'readwrite');
      tx.objectStore(STORE).put(record);
      tx.oncomplete = () => resolve(true);
      tx.onerror = () => reject(tx.error);
    }));
  }

  // ---- Recording lifecycle --------------------------------------------------

  function makeId() {
    return 'rec_' + Date.now().toString(36) + '_' + Math.random().toString(36).slice(2, 8);
  }

  async function start(streamId, meetingUrl, meetingPlatform) {
    if (activeRecorder && activeRecorder.state !== 'inactive') {
      return { ok: false, error: 'already_recording' };
    }
    if (!streamId) {
      return { ok: false, error: 'missing_stream_id' };
    }

    // Attach to the tab capture stream. The user has already granted tabCapture
    // permission to the extension; in the offscreen document we just need to
    // grab the stream by id.
    const constraints = {
      audio: {
        mandatory: {
          chromeMediaSource: 'tab',
          chromeMediaSourceId: streamId,
        },
      },
      video: false,
    };

    let stream;
    try {
      stream = await navigator.mediaDevices.getUserMedia(constraints);
    } catch (e) {
      return { ok: false, error: 'getUserMedia_failed: ' + (e && e.message || e) };
    }

    activeStream = stream;
    activeRecordingId = makeId();
    activeStartedAt = Date.now();
    activeUrl = meetingUrl || '';
    activePlatform = meetingPlatform || '';
    activeChunks = [];

    // Pick a widely supported mime type. Fall back to default if none match.
    const preferredTypes = [
      'audio/webm;codecs=opus',
      'audio/webm',
      'audio/ogg;codecs=opus',
    ];
    let mimeType = '';
    for (const t of preferredTypes) {
      if (window.MediaRecorder && MediaRecorder.isTypeSupported(t)) {
        mimeType = t;
        break;
      }
    }

    let recorder;
    try {
      recorder = mimeType ? new MediaRecorder(stream, { mimeType }) : new MediaRecorder(stream);
    } catch (e) {
      cleanupStream();
      return { ok: false, error: 'MediaRecorder_failed: ' + (e && e.message || e) };
    }

    recorder.ondataavailable = (ev) => {
      if (ev.data && ev.data.size > 0) activeChunks.push(ev.data);
    };

    recorder.onerror = (ev) => {
      // eslint-disable-next-line no-console
      console.error('[yinghua] recorder error', ev);
    };

    recorder.onstop = async () => {
      try {
        const blob = new Blob(activeChunks, { type: recorder.mimeType || 'audio/webm' });
        const record = {
          id: activeRecordingId,
          startedAt: activeStartedAt,
          endedAt: Date.now(),
          durationMs: Date.now() - activeStartedAt,
          mimeType: recorder.mimeType || 'audio/webm',
          size: blob.size,
          meetingUrl: activeUrl,
          meetingPlatform: activePlatform,
          blob,
        };
        await saveRecording(record);
      } catch (e) {
        // eslint-disable-next-line no-console
        console.error('[yinghua] failed to persist recording', e);
      } finally {
        teardownVuChain();
        cleanupStream();
        activeRecorder = null;
        activeChunks = [];
        activeRecordingId = null;
        activeUrl = '';
        activePlatform = '';
        activeStartedAt = 0;
      }
    };

    // timeslice 5000ms — flush a chunk every 5s so a crash doesn't lose everything
    recorder.start(5000);
    activeRecorder = recorder;

    // Build the VU analyser chain off the same stream.
    try {
      setupVuChain(stream);
    } catch (e) {
      // VU is best-effort; don't fail the recording if Web Audio is unavailable.
      // eslint-disable-next-line no-console
      console.error('[yinghua] vu setup failed', e);
    }

    return { ok: true, id: activeRecordingId, startedAt: activeStartedAt };
  }

  async function stop() {
    if (!activeRecorder || activeRecorder.state === 'inactive') {
      // Still tear down VU in case it was set up but recorder already finished
      teardownVuChain();
      return { ok: true, recording: false };
    }
    const id = activeRecordingId;
    // onstop will fire and persist to IndexedDB. VU teardown happens there.
    activeRecorder.stop();
    return { ok: true, recording: true, id };
  }

  function cleanupStream() {
    if (activeStream) {
      try {
        for (const t of activeStream.getTracks()) t.stop();
      } catch (e) {
        /* ignore */
      }
      activeStream = null;
    }
  }

  // ---- VU analyser chain ----------------------------------------------------

  // 12 logarithmic bands from 60 Hz to 8 kHz. Voice energy peaks in 300-3000 Hz
  // which naturally lands on the center bars (5-6) for the "center loudest" feel.
  // Values are 1-based bin indexes; each band averages a small window around it.
  const VU_MIN_HZ = 60;
  const VU_MAX_HZ = 8000;

  function computeBandEdges(sampleRate, fftSize) {
    const binHz = sampleRate / fftSize;
    const minBin = Math.max(1, Math.floor(VU_MIN_HZ / binHz));
    const maxBin = Math.min(fftSize / 2 - 1, Math.ceil(VU_MAX_HZ / binHz));
    const edges = [];
    for (let i = 0; i < VU_BANDS; i++) {
      // Logarithmic interpolation
      const t = i / (VU_BANDS - 1);
      const f = VU_MIN_HZ * Math.pow(VU_MAX_HZ / VU_MIN_HZ, t);
      edges.push(Math.round(f / binHz));
    }
    // Clamp to [minBin, maxBin]
    for (let i = 0; i < edges.length; i++) {
      if (edges[i] < minBin) edges[i] = minBin;
      if (edges[i] > maxBin) edges[i] = maxBin;
    }
    return edges;
  }

  function setupVuChain(stream) {
    if (audioCtx) teardownVuChain();
    const Ctx = window.AudioContext || window.webkitAudioContext;
    if (!Ctx) throw new Error('AudioContext unavailable');

    audioCtx = new Ctx();
    audioSource = audioCtx.createMediaStreamSource(stream);
    analyser = audioCtx.createAnalyser();
    analyser.fftSize = 256; // 128 bins — enough for 12 bands, very cheap
    analyser.smoothingTimeConstant = 0.7;
    audioSource.connect(analyser);

    vuFreqBuf = new Uint8Array(analyser.frequencyBinCount);

    // Start the rAF loop
    vuRafHandle = requestAnimationFrame(vuTick);
  }

  function teardownVuChain() {
    if (vuRafHandle) {
      cancelAnimationFrame(vuRafHandle);
      vuRafHandle = 0;
    }
    try { if (audioSource) audioSource.disconnect(); } catch (e) { /* ignore */ }
    try { if (analyser) analyser.disconnect(); } catch (e) { /* ignore */ }
    if (audioCtx) {
      try { audioCtx.close(); } catch (e) { /* ignore */ }
      audioCtx = null;
    }
    audioSource = null;
    analyser = null;
    vuFreqBuf = null;
    lastVuSentAt = 0;
  }

  function vuTick() {
    vuRafHandle = requestAnimationFrame(vuTick);
    if (!analyser || !vuFreqBuf) return;

    const now = (typeof performance !== 'undefined' && performance.now)
      ? performance.now()
      : Date.now();
    if (now - lastVuSentAt < VU_INTERVAL_MS) return;
    lastVuSentAt = now;

    try {
      analyser.getByteFrequencyData(vuFreqBuf);
    } catch (e) {
      // Stream may have ended; teardown will happen on recorder.onstop
      return;
    }

    const sampleRate = audioCtx ? audioCtx.sampleRate : 48000;
    const edges = computeBandEdges(sampleRate, analyser.fftSize);

    // Average each band's bins. Skip DC bin 0 (it carries no useful info).
    const levels = new Array(VU_BANDS);
    for (let i = 0; i < VU_BANDS; i++) {
      const center = edges[i];
      // Window of ±1 bin
      const lo = Math.max(1, center - 1);
      const hi = Math.min(vuFreqBuf.length - 1, center + 1);
      let sum = 0;
      let n = 0;
      for (let b = lo; b <= hi; b++) {
        sum += vuFreqBuf[b];
        n++;
      }
      const avg = n > 0 ? sum / n : 0;
      // 0..255 → 0..1
      levels[i] = Math.min(1, Math.max(0, avg / 255));
    }

    // Mirror around center for visual symmetry: bar[i] = bar[VU_BANDS-1-i].
    // Result: leftmost = rightmost (lowest band mirrored), center = center.
    const mirrored = new Array(VU_BANDS);
    for (let i = 0; i < VU_BANDS; i++) {
      // Edges already give "low → high" from i=0..11; mirror to put loudest
      // (mid-frequency voice energy) at the center.
      // Pair: 0↔11, 1↔10, 2↔9, ... 5↔6, center stays center
      const j = VU_BANDS - 1 - i;
      const a = levels[i];
      const b = levels[j];
      mirrored[i] = Math.max(a, b);
    }

    try {
      chrome.runtime.sendMessage({ type: 'vuMeter', levels: mirrored }).catch(() => {
        // Background may be restarting; safe to drop a frame.
      });
    } catch (e) {
      // No receiver — ignore.
    }
  }

  // ---- Message router -------------------------------------------------------

  chrome.runtime.onMessage.addListener((message, _sender, sendResponse) => {
    if (!message || typeof message !== 'object') return false;

    (async () => {
      try {
        switch (message.type) {
          case 'offscreenStart': {
            const r = await start(message.streamId, message.meetingUrl, message.meetingPlatform);
            sendResponse(r);
            break;
          }
          case 'offscreenStop': {
            const r = await stop();
            sendResponse(r);
            break;
          }
          case 'offscreenPing': {
            sendResponse({
              ok: true,
              recording: !!(activeRecorder && activeRecorder.state === 'recording'),
            });
            break;
          }
          default:
            sendResponse({ ok: false, error: 'unknown_type' });
        }
      } catch (e) {
        sendResponse({ ok: false, error: String(e && e.message || e) });
      }
    })();

    return true;
  });
})();
