// Yinghua · Meeting Recorder — Service Worker
// Owns recording state. Bridges content scripts ↔ offscreen MediaRecorder.
// All audio stays local. No upload, no network.

const STORAGE_KEY = 'yinghua_recording_state';

const DEFAULT_STATE = Object.freeze({
  isRecording: false,
  startedAt: 0,
  duration: 0,
  meetingUrl: '',
  meetingPlatform: '',
  activeTabId: -1,
});

// ---- Storage helpers -------------------------------------------------------

async function readState() {
  const { [STORAGE_KEY]: saved } = await chrome.storage.local.get(STORAGE_KEY);
  return { ...DEFAULT_STATE, ...(saved || {}) };
}

async function writeState(partial) {
  const next = { ...(await readState()), ...partial };
  await chrome.storage.local.set({ [STORAGE_KEY]: next });
  // Broadcast so any open popup / content script can update immediately.
  broadcastState(next);
  return next;
}

function broadcastState(state) {
  // content scripts
  chrome.tabs.query({}).then((tabs) => {
    for (const t of tabs) {
      if (t.id == null) continue;
      chrome.tabs.sendMessage(t.id, { type: 'recordingState', state }).catch(() => {
        // Tab doesn't have a content script listening — safe to ignore.
      });
    }
  });
  // popup (if open)
  chrome.runtime.sendMessage({ type: 'recordingState', state }).catch(() => {
    // No receiver (popup closed) — fine.
  });
}

// ---- Offscreen document lifecycle -----------------------------------------

async function ensureOffscreen() {
  const existing = await chrome.offscreen.hasDocument?.();
  if (existing) return;
  await chrome.offscreen.createDocument({
    url: 'offscreen.html',
    reasons: ['USER_MEDIA'],
    justification: 'Recording meeting audio via tabCapture for the local Yinghua recorder.',
  });
}

async function closeOffscreen() {
  const existing = await chrome.offscreen.hasDocument?.();
  if (existing) {
    await chrome.offscreen.closeDocument();
  }
}

// ---- Recording control -----------------------------------------------------

async function startRecording(sender) {
  const current = await readState();
  if (current.isRecording) return current;

  const tabId = sender?.tab?.id;
  if (tabId == null) {
    throw new Error('No active tab available for capture.');
  }

  // 1. Get a media stream ID for this tab's audio.
  const streamId = await chrome.tabCapture.getMediaStreamId({
    targetTabId: tabId,
  });

  // 2. Make sure the offscreen document exists.
  await ensureOffscreen();

  // 3. Ask the offscreen document to start MediaRecorder on that stream.
  const startResp = await chrome.runtime.sendMessage({
    type: 'offscreenStart',
    streamId,
    meetingUrl: sender?.tab?.url || '',
    meetingPlatform: detectPlatform(sender?.tab?.url || ''),
  });

  if (!startResp || !startResp.ok) {
    await closeOffscreen();
    throw new Error(startResp?.error || 'Failed to start recorder.');
  }

  return writeState({
    isRecording: true,
    startedAt: Date.now(),
    duration: 0,
    meetingUrl: sender?.tab?.url || '',
    meetingPlatform: detectPlatform(sender?.tab?.url || ''),
    activeTabId: tabId,
  });
}

async function stopRecording() {
  const current = await readState();
  if (!current.isRecording) return current;

  // Ask offscreen to stop + flush the recording to IndexedDB.
  try {
    const resp = await chrome.runtime.sendMessage({ type: 'offscreenStop' });
    if (resp && resp.recording) {
      // Offscreen wrote to IndexedDB. We just need to reset state.
    }
  } catch (e) {
    // Offscreen may already be gone; that's OK.
  }

  await closeOffscreen();

  return writeState({
    isRecording: false,
    startedAt: 0,
    duration: Date.now() - (current.startedAt || Date.now()),
    activeTabId: -1,
  });
}

function detectPlatform(url) {
  try {
    const u = new URL(url);
    if (u.hostname.includes('zoom.us')) return 'zoom';
    if (u.hostname.includes('meet.google.com')) return 'meet';
    if (u.hostname.includes('teams.microsoft.com')) return 'teams';
  } catch (e) {
    /* not a URL */
  }
  return '';
}

// ---- Tab routing helpers ---------------------------------------------------

async function forwardToActiveTab(message) {
  const state = await readState();
  const tabId = state.activeTabId;
  if (!tabId || tabId < 0) return;
  try {
    chrome.tabs.sendMessage(tabId, message, () => {
      // Swallow "Receiving end does not exist" if the tab navigated away.
      void chrome.runtime.lastError;
    });
  } catch (e) {
    /* tab gone — fine */
  }
}

// ---- Message router --------------------------------------------------------

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (!message || typeof message !== 'object') return false;
  // L-4 audit fix: only accept messages from our own extension context.
  if (sender && sender.id && sender.id !== chrome.runtime.id) return false;

  (async () => {
    try {
      switch (message.type) {
        case 'getRecordingState': {
          const state = await readState();
          sendResponse(state);
          break;
        }
        case 'startRecording': {
          const state = await startRecording(sender);
          sendResponse(state);
          break;
        }
        case 'stopRecording': {
          const state = await stopRecording();
          sendResponse(state);
          break;
        }
        case 'listRecordings': {
          sendResponse(await listRecordings());
          break;
        }
        case 'deleteRecording': {
          sendResponse(await deleteRecording(message.id));
          break;
        }
        case 'openInMacApp': {
          // MVP: try the native messaging host if available.
          // Falls back to a no-op so popup doesn't break.
          try {
            chrome.runtime.sendNativeMessage(
              'com.yinghua.macbridge',
              { type: 'open', recordingId: message.id || '' },
              (resp) => sendResponse({ ok: true, resp: resp || null }),
            );
            return; // async response will be sent by callback
          } catch (e) {
            sendResponse({ ok: false, error: 'native_host_unavailable' });
          }
          break;
        }
        case 'ping': {
          sendResponse({ ok: true, t: Date.now() });
          break;
        }
        case 'vuMeter': {
          // Routed from offscreen to the active recording tab's content script.
          // No sendResponse needed; just forward.
          forwardToActiveTab({ type: 'vuMeter', levels: message.levels });
          break;
        }
        case 'transcriptLine': {
          forwardToActiveTab({ type: 'transcriptLine', line: message.line });
          break;
        }
        case 'transcriptBatch': {
          if (Array.isArray(message.lines)) {
            forwardToActiveTab({ type: 'transcriptBatch', lines: message.lines });
          }
          break;
        }
        case 'summaryUpdated': {
          // Persist a copy for the panel to read on next open
          try {
            if (message.summary) {
              await chrome.storage.local.set({ yinghua_last_summary: message.summary });
            }
          } catch (e) { /* ignore */ }
          forwardToActiveTab({ type: 'summaryUpdated', summary: message.summary });
          break;
        }
        case 'openSettings': {
          // MVP: open the popup. Future: open an options page.
          try {
            chrome.action.openPopup?.();
          } catch (e) {
            // openPopup may not be available — ignore
          }
          sendResponse({ ok: true });
          break;
        }
        default:
          sendResponse({ ok: false, error: 'unknown_type' });
      }
    } catch (err) {
      sendResponse({ ok: false, error: String(err && err.message || err) });
    }
  })();

  return true; // keep channel open for async sendResponse
});

// ---- Recordings (IndexedDB) ------------------------------------------------
// The offscreen document is the one that actually writes to IndexedDB.
// From the service worker we only *list* metadata so the popup can show it.

async function listRecordings() {
  try {
    const db = await openDb();
    const items = await dbAll(db, 'recordings');
    // Newest first
    items.sort((a, b) => (b.startedAt || 0) - (a.startedAt || 0));
    return { ok: true, items };
  } catch (e) {
    return { ok: false, items: [], error: String(e && e.message || e) };
  }
}

async function deleteRecording(id) {
  try {
    const db = await openDb();
    await dbRun(db, 'recordings', 'readwrite', (store) => {
      store.delete(id);
    });
    return { ok: true };
  } catch (e) {
    return { ok: false, error: String(e && e.message || e) };
  }
}

// ---- IndexedDB helpers (service-worker side, read-only) --------------------

function openDb() {
  return new Promise((resolve, reject) => {
    const req = indexedDB.open('yinghua-recordings', 1);
    req.onupgradeneeded = () => {
      const db = req.result;
      if (!db.objectStoreNames.contains('recordings')) {
        const store = db.createObjectStore('recordings', { keyPath: 'id' });
        store.createIndex('startedAt', 'startedAt', { unique: false });
      }
    };
    req.onsuccess = () => resolve(req.result);
    req.onerror = () => reject(req.error);
  });
}

function dbAll(db, storeName) {
  return new Promise((resolve, reject) => {
    const tx = db.transaction(storeName, 'readonly');
    const store = tx.objectStore(storeName);
    const req = store.getAll();
    req.onsuccess = () => resolve(req.result || []);
    req.onerror = () => reject(req.error);
  });
}

function dbRun(db, storeName, mode, fn) {
  return new Promise((resolve, reject) => {
    const tx = db.transaction(storeName, mode);
    const store = tx.objectStore(storeName);
    const out = fn(store);
    tx.oncomplete = () => resolve(out);
    tx.onerror = () => reject(tx.error);
  });
}

// ---- Lifecycle -------------------------------------------------------------

chrome.runtime.onInstalled.addListener(async () => {
  await writeState({});
});

chrome.runtime.onStartup.addListener(async () => {
  // If a previous session left us in "recording" state (browser restart
  // mid-recording, etc.), reset it — we no longer have the tab stream.
  const s = await readState();
  if (s.isRecording) {
    await writeState({
      isRecording: false,
      startedAt: 0,
      duration: 0,
    });
  }
});
