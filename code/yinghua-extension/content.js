// Yinghua · Meeting Recorder — Content Script
// Injects a floating bubble into Zoom / Google Meet / Teams pages.
// Click the bubble → opens the 400×600 popover panel (iframe) that hosts
// the live VU meter, transcript scroll, AI summary preview, and stop button.
// All data stays local. No upload. No third-party deps.

(() => {
  'use strict';

  // ---- Platform detection ---------------------------------------------------

  function detectPlatform() {
    const host = window.location.hostname;
    if (host.includes('zoom.us')) return 'zoom';
    if (host.includes('meet.google.com')) return 'meet';
    if (host.includes('teams.microsoft.com')) return 'teams';
    return null;
  }

  const platform = detectPlatform();
  if (!platform) return;

  // Bail if already injected (SPA re-runs script on navigation).
  if (document.getElementById('yinghua-bubble')) return;

  // ---- Design tokens (mirrored from design/design-tokens.json) -------------

  const TOKENS = {
    brandPurple: '#B57BFF',
    brandMid: '#8A5BFF',
    brandTeal: '#2DD4BF',
    recordingRed: '#FF3B30',
    nearBlack: '#0A0A0F',
    glassDeep: 'rgba(10, 10, 15, 0.7)',
    warmWhite: '#F4F1EC',
    secondary: 'rgba(244, 241, 236, 0.8)',
    tertiary: 'rgba(244, 241, 236, 0.6)',
    hairline: 'rgba(244, 241, 236, 0.08)',
    glassAuroraWash:
      'linear-gradient(135deg, rgba(181, 123, 255, 0.15) 0%, rgba(45, 212, 191, 0.15) 100%)',
    primaryGradient: 'linear-gradient(135deg, #B57BFF 0%, #8A5BFF 50%, #2DD4BF 100%)',
  };

  // ---- Local state (in-page, not the source of truth) ----------------------

  let state = {
    isRecording: false,
    startedAt: 0,
    duration: 0,
  };

  let panelVisible = false;
  let panelEl = /** @type {HTMLIFrameElement|null} */ (null);
  let lastVuSentAt = 0;
  const VU_FORWARD_THROTTLE_MS = 70; // ~14 Hz forwarded to panel

  // ---- DOM construction: bubble --------------------------------------------

  const bubble = document.createElement('div');
  bubble.id = 'yinghua-bubble';
  bubble.className = 'yinghua-bubble';
  bubble.setAttribute('role', 'button');
  bubble.setAttribute('aria-label', 'Yinghua');
  bubble.setAttribute('tabindex', '0');

  const bubbleIcon = document.createElement('div');
  bubbleIcon.className = 'yinghua-bubble-icon';

  // Inline SVG Y — matches the 02 GRADIENT brand mark.
  // (DOM construction, no innerHTML — content_security_policy friendly.)
  (function buildSvg() {
    const NS = 'http://www.w3.org/2000/svg';
    const svg = document.createElementNS(NS, 'svg');
    svg.setAttribute('viewBox', '0 0 32 32');
    svg.setAttribute('width', '32');
    svg.setAttribute('height', '32');
    svg.setAttribute('aria-hidden', 'true');

    const defs = document.createElementNS(NS, 'defs');
    const grad = document.createElementNS(NS, 'linearGradient');
    grad.setAttribute('id', 'yinghua-y-grad');
    grad.setAttribute('x1', '0%');
    grad.setAttribute('y1', '0%');
    grad.setAttribute('x2', '100%');
    grad.setAttribute('y2', '100%');
    const stops = [
      { off: '0%', color: TOKENS.brandPurple },
      { off: '50%', color: TOKENS.brandMid },
      { off: '100%', color: TOKENS.brandTeal },
    ];
    for (const s of stops) {
      const stop = document.createElementNS(NS, 'stop');
      stop.setAttribute('offset', s.off);
      stop.setAttribute('stop-color', s.color);
      grad.appendChild(stop);
    }
    defs.appendChild(grad);
    svg.appendChild(defs);

    const path = document.createElementNS(NS, 'path');
    path.setAttribute('d', 'M5 5 L13 13 L13 27 M27 5 L19 13');
    path.setAttribute('fill', 'none');
    path.setAttribute('stroke', 'url(#yinghua-y-grad)');
    path.setAttribute('stroke-width', '4.5');
    path.setAttribute('stroke-linecap', 'round');
    path.setAttribute('stroke-linejoin', 'round');
    svg.appendChild(path);

    bubbleIcon.appendChild(svg);
  })();
  bubble.appendChild(bubbleIcon);

  // Recording indicator dot (hidden by default)
  const recDot = document.createElement('span');
  recDot.className = 'yinghua-rec-dot';
  recDot.setAttribute('aria-hidden', 'true');
  bubble.appendChild(recDot);

  document.body.appendChild(bubble);

  // ---- Panel iframe --------------------------------------------------------

  function buildPanel() {
    if (panelEl) return panelEl;
    const iframe = document.createElement('iframe');
    iframe.id = 'yinghua-panel-iframe';
    iframe.className = 'yinghua-panel-iframe';
    iframe.setAttribute('title', 'Yinghua 控制台');
    iframe.setAttribute('aria-label', 'Yinghua 控制台');
    iframe.setAttribute('allow', ''); // no special permissions
    // sandbox: same-origin lets the iframe use chrome.runtime; scripts allowed.
    iframe.setAttribute('sandbox', 'allow-scripts allow-same-origin');
    iframe.src = chrome.runtime.getURL('panel.html');
    panelEl = iframe;
    return iframe;
  }

  function showPanel() {
    if (panelVisible) return;
    const iframe = buildPanel();
    if (!iframe.isConnected) document.body.appendChild(iframe);
    // Force reflow before adding the visible class so the transition fires
    void iframe.offsetWidth;
    iframe.classList.add('is-visible');
    panelVisible = true;
    bubble.classList.add('is-panel-open');
    // Push current state to the panel after a tick (iframe load)
    setTimeout(() => {
      try {
        iframe.contentWindow.postMessage(
          { type: 'yinghua:state', state },
          chrome.runtime.getURL('').replace(/\/$/, ''),
        );
      } catch (e) { /* iframe not ready yet — content script will retry on vu */ }
    }, 80);
  }

  function hidePanel() {
    if (!panelVisible) return;
    panelVisible = false;
    bubble.classList.remove('is-panel-open');
    if (panelEl) {
      panelEl.classList.remove('is-visible');
      // Keep iframe in DOM (cheaper to show again). GC will reclaim once tab closes.
    }
  }

  function togglePanel() {
    if (panelVisible) hidePanel();
    else showPanel();
  }

  function postToPanel(msg) {
    if (!panelVisible || !panelEl || !panelEl.contentWindow) return;
    try {
      const extOrigin = chrome.runtime.getURL('').replace(/\/$/, '');
      panelEl.contentWindow.postMessage(msg, extOrigin);
    } catch (e) { /* cross-frame — silent */ }
  }

  // ---- State sync with background ------------------------------------------

  function pullState() {
    try {
      chrome.runtime.sendMessage({ type: 'getRecordingState' }, (resp) => {
        if (chrome.runtime.lastError) return;
        if (resp) applyState(resp);
      });
    } catch (e) {
      // Extension context invalidated (reload). Fail silently.
    }
  }

  function applyState(s) {
    state = {
      isRecording: !!s.isRecording,
      startedAt: s.startedAt || 0,
      duration: s.duration || 0,
    };

    if (state.isRecording) {
      bubble.classList.add('is-recording');
    } else {
      bubble.classList.remove('is-recording');
    }

    // Forward to panel if it's open
    postToPanel({ type: 'yinghua:state', state });
  }

  // ---- chrome.runtime.onMessage (broadcasts from background) --------------

  try {
    chrome.runtime.onMessage.addListener((message, _sender, _sendResponse) => {
      if (!message || typeof message !== 'object') return false;

      if (message.type === 'recordingState' && message.state) {
        applyState(message.state);
      } else if (message.type === 'vuMeter' && Array.isArray(message.levels)) {
        // Throttle so we don't spam the iframe
        const now = Date.now();
        if (now - lastVuSentAt < VU_FORWARD_THROTTLE_MS) return false;
        lastVuSentAt = now;
        postToPanel({ type: 'yinghua:vu', levels: message.levels });
      } else if (message.type === 'transcriptLine' && message.line) {
        postToPanel({ type: 'yinghua:transcript', lines: [message.line] });
      } else if (message.type === 'transcriptBatch' && Array.isArray(message.lines)) {
        postToPanel({ type: 'yinghua:transcript', lines: message.lines });
      } else if (message.type === 'summaryUpdated' && message.summary) {
        postToPanel({ type: 'yinghua:summary', summary: message.summary });
      }
      return false;
    });
  } catch (e) {
    // chrome.runtime unavailable in this context — silent.
  }

  // ---- postMessage bridge (panel iframe → content script) -----------------

  window.addEventListener('message', (ev) => {
    if (!ev || ev.source !== (panelEl && panelEl.contentWindow)) return;
    const data = ev.data;
    if (!data || typeof data !== 'object') return;

    if (data.type === 'yinghua:close') {
      hidePanel();
    } else if (data.type === 'yinghua:pong') {
      // iframe acknowledged ping — connection live
    }
  });

  // ---- Interactions --------------------------------------------------------

  bubble.addEventListener('click', (ev) => {
    ev.stopPropagation();
    togglePanel();
  });

  bubble.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault();
      togglePanel();
    }
  });

  // Click outside the panel hides it
  document.addEventListener('click', (e) => {
    if (!panelVisible) return;
    if (bubble.contains(e.target)) return;
    if (panelEl && panelEl.contains && panelEl.contains(e.target)) return;
    hidePanel();
  });

  // ---- Lifecycle -----------------------------------------------------------

  // Initial state pull
  pullState();

  // Re-pull when tab becomes visible / focused
  document.addEventListener('visibilitychange', () => {
    if (!document.hidden) pullState();
  });

  // Light polling fallback in case the service worker restarts
  setInterval(pullState, 3000);
})();
