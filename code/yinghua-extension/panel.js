// Yinghua · Popover Panel
// Runs inside an iframe loaded from chrome-extension://<id>/panel.html.
// Listens for VU / state / transcript events from the parent content script
// and from chrome.runtime broadcasts. Renders the 12-bar VU meter, the
// rolling transcript, the 4-section AI summary preview, and the stop button.
// All DOM updates use textContent / createElement (no innerHTML with user data).

(() => {
  'use strict';

  // ---- DOM refs -------------------------------------------------------------

  const $dot = document.querySelector('[data-rec-dot]');
  const $close = document.querySelector('[data-close]');
  const $time = document.querySelector('[data-time]');
  const $status = document.querySelector('[data-status]');
  const $vuBars = document.querySelector('[data-vu-bars]');
  const $transcript = document.querySelector('[data-transcript]');
  const $transcriptMeta = document.querySelector('[data-transcript-meta]');
  const $summary = document.querySelector('[data-summary]');
  const $summaryMeta = document.querySelector('[data-summary-meta]');
  const $stop = document.querySelector('[data-stop]');
  const $stopLabel = document.querySelector('[data-stop-label]');
  const $settings = document.querySelector('[data-settings]');

  // ---- State (in-iframe, mirror of background state) -----------------------

  const state = {
    isRecording: false,
    startedAt: 0,
    transcript: /** @type {Array<{time:string,speaker:string,text:string}>} */ ([]),
    summary: /** @type {{keyMoments:string[],decisions:string[],actionItems:string[],openQuestions:string[]}|null} */ (null),
  };

  // ---- VU meter rendering ---------------------------------------------------

  // 12 bars. Each bar's height is set via inline style on a child div.
  // Color is also inline via CSS variables; thresholds (green / yellow / red / quiet)
  // mirror vu-meter.css rules.
  const BARS = 12;
  const bars = /** @type {HTMLDivElement[]} */ ([]);

  function buildBars() {
    $vuBars.innerHTML = ''; // safe — empty string only
    for (let i = 0; i < BARS; i++) {
      const bar = document.createElement('div');
      bar.className = 'yh-vu-bar';
      bar.dataset.idx = String(i);
      $vuBars.appendChild(bar);
      bars.push(bar);
    }
  }

  let latestLevels = new Array(BARS).fill(0);
  let rafHandle = 0;

  function tickVu() {
    rafHandle = requestAnimationFrame(tickVu);
    for (let i = 0; i < BARS; i++) {
      const level = latestLevels[i] || 0;
      const bar = bars[i];
      if (!bar) continue;
      // Map 0..1 → CSS height percentage (0..100%)
      const h = Math.round(level * 100);
      bar.style.height = h + '%';
      // Color via data-level attribute (CSS handles actual colors)
      if (level < 0.05) {
        bar.dataset.level = 'quiet';
      } else if (level < 0.6) {
        bar.dataset.level = 'green';
      } else if (level < 0.8) {
        bar.dataset.level = 'yellow';
      } else {
        bar.dataset.level = 'red';
      }
    }
  }

  function startVu() {
    if (rafHandle) return;
    rafHandle = requestAnimationFrame(tickVu);
  }

  function stopVu() {
    if (rafHandle) {
      cancelAnimationFrame(rafHandle);
      rafHandle = 0;
    }
    // Fade to zero
    for (let i = 0; i < BARS; i++) latestLevels[i] = 0;
  }

  // ---- Time rendering -------------------------------------------------------

  function formatDuration(ms) {
    const total = Math.max(0, Math.floor((ms || 0) / 1000));
    const h = String(Math.floor(total / 3600)).padStart(2, '0');
    const m = String(Math.floor((total % 3600) / 60)).padStart(2, '0');
    const s = String(total % 60).padStart(2, '0');
    return `${h}:${m}:${s}`;
  }

  let tickHandle = 0;
  function startTimeTicker() {
    if (tickHandle) return;
    const update = () => {
      const elapsed = state.startedAt ? Date.now() - state.startedAt : 0;
      $time.textContent = formatDuration(elapsed);
    };
    update();
    tickHandle = setInterval(update, 1000);
  }

  function stopTimeTicker() {
    if (tickHandle) {
      clearInterval(tickHandle);
      tickHandle = 0;
    }
    if (!state.isRecording) $time.textContent = '00:00:00';
  }

  // ---- Transcript rendering (rolling, 5 lines visible) ---------------------

  const MAX_LINES = 50; // hard cap to keep DOM small

  function pushTranscriptLine(line) {
    if (!line || typeof line.text !== 'string') return;
    state.transcript.push(line);
    if (state.transcript.length > MAX_LINES) {
      state.transcript.splice(0, state.transcript.length - MAX_LINES);
    }
    renderTranscript();
  }

  function renderTranscript() {
    // Hide the empty placeholder when there's at least one line
    if (state.transcript.length === 0) {
      $transcript.innerHTML = ''; // safe
      const empty = document.createElement('div');
      empty.className = 'yh-panel-transcript-empty';
      empty.textContent = '等待转录内容…';
      $transcript.appendChild(empty);
      $transcriptMeta.textContent = '—';
      return;
    }
    $transcript.innerHTML = ''; // safe
    // Render last 5 lines
    const visible = state.transcript.slice(-5);
    for (const line of visible) {
      const row = document.createElement('div');
      row.className = 'yh-panel-transcript-line';

      const t = document.createElement('span');
      t.className = 'yh-panel-transcript-time';
      t.textContent = line.time || '00:00';

      const sp = document.createElement('span');
      sp.className = 'yh-panel-transcript-speaker';
      sp.textContent = line.speaker || 'Speaker';

      const tx = document.createElement('span');
      tx.className = 'yh-panel-transcript-text';
      tx.textContent = line.text;

      row.appendChild(t);
      row.appendChild(sp);
      row.appendChild(tx);
      $transcript.appendChild(row);
    }
    // Scroll to bottom
    $transcript.scrollTop = $transcript.scrollHeight;
    $transcriptMeta.textContent = String(state.transcript.length) + ' 行';
  }

  // ---- Summary rendering (4 collapsible sections) -------------------------

  const SUMMARY_KEYS = ['keyMoments', 'decisions', 'actionItems', 'openQuestions'];

  function renderSummary() {
    const data = state.summary;
    $summaryMeta.textContent = data ? '已生成' : '未生成';
    for (const key of SUMMARY_KEYS) {
      const list = data ? data[key] || [] : [];
      const $ul = $summary.querySelector(`[data-list="${key}"]`);
      const $count = $summary.querySelector(`[data-count="${key}"]`);
      if (!$ul || !$count) continue;
      $count.textContent = String(list.length);
      $ul.innerHTML = ''; // safe
      if (list.length === 0) {
        const li = document.createElement('li');
        li.className = 'yh-panel-sum-empty';
        li.textContent = '—';
        $ul.appendChild(li);
      } else {
        for (const item of list) {
          const li = document.createElement('li');
          li.textContent = String(item || '');
          $ul.appendChild(li);
        }
      }
    }
  }

  // ---- State application ---------------------------------------------------

  function applyState(next) {
    const wasRecording = state.isRecording;
    state.isRecording = !!next.isRecording;
    state.startedAt = next.startedAt || 0;

    if (state.isRecording) {
      $dot.classList.add('is-recording');
      $stop.classList.add('is-recording');
      $stopLabel.textContent = '停止录制';
      $stop.disabled = false;
      $status.textContent = '录制中 · 音频仅本地保存';
      $time.classList.remove('is-idle');
      startTimeTicker();
      startVu();
    } else {
      $dot.classList.remove('is-recording');
      $stop.classList.remove('is-recording');
      $stopLabel.textContent = '开始录制';
      $stop.disabled = false;
      $status.textContent = '未在录制';
      $time.classList.add('is-idle');
      stopTimeTicker();
      stopVu();
    }

    if (wasRecording && !state.isRecording) {
      // Recording just stopped — load a mock / stored summary if available
      loadMockSummary();
    }
  }

  function loadMockSummary() {
    // MVP: there's no actual summary yet (transcription lives in macOS app).
    // Surface a 4-section mock keyed off IndexedDB so the layout is real.
    try {
      const key = 'yinghua_last_summary';
      chrome.storage?.local?.get?.(key, (data) => {
        const s = data && data[key];
        if (s && typeof s === 'object') {
          state.summary = {
            keyMoments: s.keyMoments || [],
            decisions: s.decisions || [],
            actionItems: s.actionItems || [],
            openQuestions: s.openQuestions || [],
          };
          renderSummary();
        }
      });
    } catch (e) {
      // chrome.storage unavailable — leave summary as null
    }
  }

  // ---- chrome.runtime bridge ----------------------------------------------

  function send(message) {
    return new Promise((resolve) => {
      try {
        chrome.runtime.sendMessage(message, (resp) => {
          if (chrome.runtime.lastError) {
            resolve(null);
            return;
          }
          resolve(resp);
        });
      } catch (e) {
        resolve(null);
      }
    });
  }

  chrome.runtime.onMessage.addListener((message, _sender, _sendResponse) => {
    if (!message || typeof message !== 'object') return false;
    if (message.type === 'recordingState' && message.state) {
      applyState(message.state);
    }
    if (message.type === 'transcriptLine' && message.line) {
      pushTranscriptLine(message.line);
    }
    if (message.type === 'summaryUpdated' && message.summary) {
      state.summary = message.summary;
      renderSummary();
    }
    return false;
  });

  // ---- postMessage bridge (parent content.js → panel) ---------------------

  window.addEventListener('message', (ev) => {
    if (!ev || ev.source !== window.parent) return;
    const data = ev.data;
    if (!data || typeof data !== 'object') return;

    if (data.type === 'yinghua:vu' && Array.isArray(data.levels)) {
      // 12 normalized levels 0..1
      for (let i = 0; i < BARS; i++) {
        const v = data.levels[i];
        latestLevels[i] = typeof v === 'number' && v >= 0 && v <= 1 ? v : 0;
      }
    } else if (data.type === 'yinghua:state' && data.state) {
      applyState(data.state);
    } else if (data.type === 'yinghua:transcript' && Array.isArray(data.lines)) {
      state.transcript = data.lines.slice(-MAX_LINES);
      renderTranscript();
    } else if (data.type === 'yinghua:summary' && data.summary) {
      state.summary = data.summary;
      renderSummary();
    } else if (data.type === 'yinghua:ping') {
      // parent is asking if the iframe is alive — acknowledge
      try {
        window.parent.postMessage({ type: 'yinghua:pong', t: Date.now() }, '*');
      } catch (e) { /* noop */ }
    }
  });

  // ---- DOM event handlers --------------------------------------------------

  $close.addEventListener('click', () => {
    try {
      window.parent.postMessage({ type: 'yinghua:close' }, '*');
    } catch (e) { /* noop */ }
  });

  $stop.addEventListener('click', async () => {
    const msg = state.isRecording
      ? { type: 'stopRecording' }
      : { type: 'startRecording' };
    $stop.disabled = true;
    const resp = await send(msg);
    if (resp) applyState(resp);
    $stop.disabled = false;
  });

  $settings.addEventListener('click', (ev) => {
    ev.preventDefault();
    try {
      chrome.runtime.sendMessage({ type: 'openSettings' }, () => {
        // no-op
      });
    } catch (e) { /* noop */ }
  });

  // ---- Boot ----------------------------------------------------------------

  buildBars();

  (async function boot() {
    const s = await send({ type: 'getRecordingState' });
    if (s) applyState(s);
    // Always render a baseline summary frame so the layout reads correctly.
    renderSummary();
    renderTranscript();
  })();
})();
