// Yinghua · Popup
// Lives in the extension action popup. Reads the current tab + recording state,
// lists persisted recordings from IndexedDB, dispatches start/stop to the SW.

(() => {
  'use strict';

  // ---- DOM refs -------------------------------------------------------------

  const $subtitle = document.getElementById('yh-subtitle');
  const $meetingPlatform = document.getElementById('yh-meeting-platform');
  const $meetingUrl = document.getElementById('yh-meeting-url');
  const $recordDot = document.getElementById('yh-record-dot');
  const $recordLabel = document.getElementById('yh-record-label');
  const $recordTime = document.getElementById('yh-record-time');
  const $recordHint = document.getElementById('yh-record-hint');
  const $cta = document.getElementById('yh-cta');
  const $listItems = document.getElementById('yh-list-items');
  const $listCount = document.getElementById('yh-list-count');
  const $openApp = document.getElementById('yh-open-app');

  // ---- Active tab detection -------------------------------------------------

  async function getActiveTab() {
    return new Promise((resolve) => {
      chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        resolve((tabs && tabs[0]) || null);
      });
    });
  }

  function detectPlatform(url) {
    try {
      const u = new URL(url);
      if (u.hostname.includes('zoom.us')) return 'Zoom';
      if (u.hostname.includes('meet.google.com')) return 'Google Meet';
      if (u.hostname.includes('teams.microsoft.com')) return 'Microsoft Teams';
    } catch (e) {
      /* not a URL */
    }
    return '';
  }

  function isSupported(url) {
    return !!detectPlatform(url);
  }

  function shortUrl(url) {
    try {
      const u = new URL(url);
      const path = u.pathname === '/' ? '' : u.pathname;
      return u.hostname.replace(/^www\./, '') + path;
    } catch (e) {
      return url || '';
    }
  }

  // ---- Recording state ------------------------------------------------------

  let currentState = {
    isRecording: false,
    startedAt: 0,
    duration: 0,
  };

  let tickHandle = null;

  function applyState(s) {
    currentState = {
      isRecording: !!s.isRecording,
      startedAt: s.startedAt || 0,
      duration: s.duration || 0,
    };

    if (currentState.isRecording) {
      $recordDot.classList.add('is-recording');
      $recordLabel.textContent = '正在录制';
      $cta.textContent = '停止录制';
      $cta.dataset.mode = 'stop';
      $cta.classList.add('is-stop');
      $recordHint.textContent = '音频正在被录制，文件留在浏览器本地。';
      tickTime();
    } else {
      $recordDot.classList.remove('is-recording');
      $recordLabel.textContent = '未在录制';
      $cta.textContent = '开始录制';
      $cta.dataset.mode = 'start';
      $cta.classList.remove('is-stop');
      $recordHint.textContent = '仅录制会议音频，文件保存在浏览器本地。';
      $recordTime.textContent = '00:00:00';
      if (tickHandle) clearInterval(tickHandle);
    }
  }

  function formatDuration(ms) {
    const total = Math.max(0, Math.floor((ms || 0) / 1000));
    const h = String(Math.floor(total / 3600)).padStart(2, '0');
    const m = String(Math.floor((total % 3600) / 60)).padStart(2, '0');
    const s = String(total % 60).padStart(2, '0');
    return `${h}:${m}:${s}`;
  }

  function tickTime() {
    if (tickHandle) clearInterval(tickHandle);
    const update = () => {
      const elapsed = currentState.startedAt
        ? Date.now() - currentState.startedAt
        : 0;
      $recordTime.textContent = formatDuration(elapsed);
    };
    update();
    tickHandle = setInterval(update, 1000);
  }

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

  // ---- Recordings list ------------------------------------------------------

  function formatBytes(n) {
    if (!n) return '0 KB';
    if (n < 1024 * 1024) return Math.round(n / 1024) + ' KB';
    return (n / (1024 * 1024)).toFixed(1) + ' MB';
  }

  function formatDate(ts) {
    if (!ts) return '';
    const d = new Date(ts);
    const pad = (n) => String(n).padStart(2, '0');
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
  }

  function renderRecordings(items) {
    $listItems.innerHTML = '';
    const list = Array.isArray(items) ? items : [];
    $listCount.textContent = String(list.length);

    if (list.length === 0) {
      const li = document.createElement('li');
      li.className = 'yh-list-empty';
      li.textContent = '尚无录音';
      $listItems.appendChild(li);
      $openApp.disabled = true;
      return;
    }

    for (const r of list) {
      const li = document.createElement('li');
      li.className = 'yh-list-item';
      li.dataset.id = r.id || '';

      const top = document.createElement('div');
      top.className = 'yh-list-item-top';
      const date = document.createElement('span');
      date.className = 'yh-list-item-date';
      date.textContent = formatDate(r.startedAt);
      const platform = document.createElement('span');
      platform.className = 'yh-list-item-platform';
      platform.textContent = r.meetingPlatform || detectPlatform(r.meetingUrl) || '会议';
      top.appendChild(date);
      top.appendChild(platform);

      const meta = document.createElement('div');
      meta.className = 'yh-list-item-meta';
      const dur = document.createElement('span');
      dur.className = 'yh-list-item-dur';
      dur.textContent = formatDuration(r.durationMs || 0);
      const size = document.createElement('span');
      size.className = 'yh-list-item-size';
      size.textContent = formatBytes(r.size);
      meta.appendChild(dur);
      meta.appendChild(size);

      const url = document.createElement('div');
      url.className = 'yh-list-item-url';
      url.textContent = r.meetingUrl ? shortUrl(r.meetingUrl) : '(no url)';
      url.title = r.meetingUrl || '';

      li.appendChild(top);
      li.appendChild(url);
      li.appendChild(meta);

      // Open in macOS app
      const open = document.createElement('button');
      open.type = 'button';
      open.className = 'yh-list-item-open';
      open.textContent = '在桌面 App 中打开';
      open.addEventListener('click', async (ev) => {
        ev.stopPropagation();
        const resp = await send({ type: 'openInMacApp', id: r.id });
        if (resp && resp.ok && resp.resp && resp.resp.ok === false) {
          // Native host responded but app refused — silent.
        }
      });
      li.appendChild(open);

      // Export to Markdown / .webm
      const exportWrap = document.createElement('div');
      exportWrap.className = 'yh-list-item-export';

      const exportBtn = document.createElement('button');
      exportBtn.type = 'button';
      exportBtn.className = 'yh-list-item-export-btn';
      exportBtn.setAttribute('aria-haspopup', 'true');
      exportBtn.setAttribute('aria-expanded', 'false');
      exportBtn.textContent = 'Export ▾';
      exportBtn.addEventListener('click', (ev) => {
        ev.stopPropagation();
        const open = exportWrap.classList.toggle('is-open');
        exportBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
      });
      exportWrap.appendChild(exportBtn);

      const exportMenu = document.createElement('div');
      exportMenu.className = 'yh-list-item-export-menu';
      exportMenu.setAttribute('role', 'menu');

      const mdBtn = document.createElement('button');
      mdBtn.type = 'button';
      mdBtn.className = 'yh-list-item-export-opt';
      mdBtn.setAttribute('role', 'menuitem');
      mdBtn.textContent = 'Markdown';
      mdBtn.title = '导出 transcript + AI 总结成 .md';
      mdBtn.addEventListener('click', (ev) => {
        ev.stopPropagation();
        doExport(r, 'md', exportWrap, exportBtn);
      });
      exportMenu.appendChild(mdBtn);

      const webmBtn = document.createElement('button');
      webmBtn.type = 'button';
      webmBtn.className = 'yh-list-item-export-opt';
      webmBtn.setAttribute('role', 'menuitem');
      webmBtn.textContent = '.webm (原始音频)';
      webmBtn.title = '直接下载原始 .webm 音频文件';
      webmBtn.addEventListener('click', (ev) => {
        ev.stopPropagation();
        doExport(r, 'webm', exportWrap, exportBtn);
      });
      exportMenu.appendChild(webmBtn);

      exportWrap.appendChild(exportMenu);

      const exportCheck = document.createElement('span');
      exportCheck.className = 'yh-list-item-export-ok';
      exportCheck.setAttribute('aria-live', 'polite');
      exportCheck.textContent = '✓';
      exportWrap.appendChild(exportCheck);

      li.appendChild(exportWrap);

      // Delete
      const del = document.createElement('button');
      del.type = 'button';
      del.className = 'yh-list-item-del';
      del.setAttribute('aria-label', '删除');
      del.textContent = '×';
      del.addEventListener('click', async (ev) => {
        ev.stopPropagation();
        if (!confirm('删除该录音？此操作无法撤销。')) return;
        await send({ type: 'deleteRecording', id: r.id });
        await refreshList();
      });
      li.appendChild(del);

      $listItems.appendChild(li);
    }

    $openApp.disabled = list.length === 0;
  }

  async function refreshList() {
    const resp = await send({ type: 'listRecordings' });
    if (resp && resp.ok) renderRecordings(resp.items);
    else renderRecordings([]);
  }

  // ---- Export (Markdown / .webm) ------------------------------------------

  function doExport(rec, format, wrap, btn) {
    if (!window.YinghuaExport) {
      // export.js not loaded — fail silently
      return;
    }
    let result;
    if (format === 'md') {
      // For MVP there's no real transcript or summary yet. The Markdown
      // template renders an "empty" structure so the file is still valid.
      result = window.YinghuaExport.exportMarkdown(rec, null, null);
    } else if (format === 'webm') {
      result = window.YinghuaExport.exportWebm(rec);
    } else {
      return;
    }
    // Collapse the menu
    wrap.classList.remove('is-open');
    btn.setAttribute('aria-expanded', 'false');
    // Show success / failure feedback inline
    const ok = wrap.querySelector('.yh-list-item-export-ok');
    if (!ok) return;
    if (result && result.ok) {
      ok.textContent = '✓ Exported';
      ok.classList.add('is-ok');
      ok.classList.remove('is-fail');
      ok.title = result.filename || '';
    } else {
      ok.textContent = '✕ ' + (result && result.error ? result.error : 'failed');
      ok.classList.add('is-fail');
      ok.classList.remove('is-ok');
    }
    ok.classList.add('is-visible');
    setTimeout(() => {
      ok.classList.remove('is-visible');
    }, 2200);
  }

  // ---- Wire up --------------------------------------------------------------

  $cta.addEventListener('click', async () => {
    const mode = $cta.dataset.mode;
    const tab = await getActiveTab();
    if (!tab || !tab.id) {
      $recordHint.textContent = '没有可用的活动标签页。';
      return;
    }
    if (!isSupported(tab.url || '')) {
      $recordHint.textContent = '请先打开 Zoom / Google Meet / Microsoft Teams。';
      return;
    }

    $cta.disabled = true;
    const resp = await send({
      type: mode === 'stop' ? 'stopRecording' : 'startRecording',
    });
    $cta.disabled = false;
    if (resp) {
      applyState(resp);
      if (mode === 'start' && !resp.isRecording) {
        $recordHint.textContent = '未能开始录制：' + (resp.error || '未知错误');
      }
    }
    // After a stop, the list may have a new entry.
    if (mode === 'stop') await refreshList();
  });

  $openApp.addEventListener('click', async () => {
    const items = ($listItems.querySelectorAll('.yh-list-item') || []);
    if (items.length === 0) return;
    const first = items[0];
    const id = first && first.dataset && first.dataset.id;
    await send({ type: 'openInMacApp', id });
  });

  // ---- Boot -----------------------------------------------------------------

  (async function boot() {
    const tab = await getActiveTab();
    if (tab && tab.url) {
      const p = detectPlatform(tab.url);
      if (p) {
        $meetingPlatform.textContent = p;
        $meetingUrl.textContent = shortUrl(tab.url);
        $meetingUrl.title = tab.url;
        $subtitle.textContent = '检测到会议 · 可录制';
      } else {
        $meetingPlatform.textContent = '—';
        $meetingUrl.textContent = '未检测到会议';
        $subtitle.textContent = '本地录制 · 不上传';
      }
    }

    const state = await send({ type: 'getRecordingState' });
    if (state) applyState(state);
    await refreshList();
  })();
})();
