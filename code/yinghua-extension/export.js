// Yinghua · Export to Markdown / .webm
// Loaded in popup.html. Two public methods:
//   - YinghuaExport.exportMarkdown(recording, summary) → downloads a .md file
//   - YinghuaExport.exportWebm(recording)              → downloads the raw .webm
//   - YinghuaExport.suggestFilename(recording, ext)    → "yinghua-2026-08-23-1530.webm"
//
// Download path: URL.createObjectURL → <a download> click → revoke. No
// chrome.downloads permission needed (the .download attribute on a synthetic
// anchor still works for blob URLs in extension pages).
//
// Markdown template mirrors the macOS app's SummaryService prompt design
// (4 sections: Key moments / Decisions / Action items / Open questions) so
// the same UI rhythm is honored on both sides.

(() => {
  'use strict';

  // ---- Filename helpers ----------------------------------------------------

  function pad(n) { return String(n).padStart(2, '0'); }

  function dateStamp(ts) {
    if (!ts) return 'unknown-date';
    const d = new Date(ts);
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}-${pad(d.getHours())}${pad(d.getMinutes())}`;
  }

  function shortId(id) {
    if (!id || typeof id !== 'string') return 'rec';
    // id looks like "rec_lzv7x_a3b9c" — keep the last 6 chars after the prefix
    const parts = id.split('_');
    return (parts[parts.length - 1] || 'rec').slice(0, 8);
  }

  function safeForFilename(s) {
    return String(s || '')
      .replace(/[^a-zA-Z0-9-_]+/g, '-')
      .replace(/-+/g, '-')
      .replace(/^-+|-+$/g, '')
      .slice(0, 60) || 'recording';
  }

  function suggestFilename(rec, ext) {
    const date = dateStamp(rec && rec.startedAt);
    const tail = shortId(rec && rec.id);
    return `yinghua-${date}-${tail}.${ext}`;
  }

  // ---- Duration / bytes helpers --------------------------------------------

  function formatDuration(ms) {
    const total = Math.max(0, Math.floor((ms || 0) / 1000));
    const h = String(Math.floor(total / 3600)).padStart(2, '0');
    const m = String(Math.floor((total % 3600) / 60)).padStart(2, '0');
    const s = String(total % 60).padStart(2, '0');
    return `${h}:${m}:${s}`;
  }

  function formatBytes(n) {
    if (!n) return '0 KB';
    if (n < 1024 * 1024) return Math.round(n / 1024) + ' KB';
    return (n / (1024 * 1024)).toFixed(1) + ' MB';
  }

  function formatDate(ts) {
    if (!ts) return '—';
    const d = new Date(ts);
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
  }

  // ---- Markdown builder ----------------------------------------------------

  /**
   * @param {Object} rec - recording metadata (id, startedAt, durationMs, meetingUrl, meetingPlatform, size)
   * @param {Object|null} [summary] - {keyMoments, decisions, actionItems, openQuestions}
   * @param {Array}  [transcript] - [{time, speaker, text}, ...]
   * @returns {string} markdown text
   */
  function buildMarkdown(rec, summary, transcript) {
    const lines = [];
    const date = formatDate(rec && rec.startedAt);
    const dur = formatDuration(rec && rec.durationMs);
    const url = (rec && rec.meetingUrl) || '—';
    const platform = (rec && rec.meetingPlatform) || 'meeting';
    const speakers = collectSpeakers(transcript);

    lines.push(`# 映话 Recording — ${suggestFilename(rec, 'md').replace(/\.md$/, '')}`);
    lines.push('');
    lines.push(`- **Date**: ${date}`);
    lines.push(`- **Duration**: ${dur}`);
    lines.push(`- **Size**: ${formatBytes(rec && rec.size)}`);
    lines.push(`- **Platform**: ${platform}`);
    lines.push(`- **Meeting URL**: ${url}`);
    lines.push(`- **Speakers**: ${speakers.length ? speakers.join(', ') : '—'}`);
    lines.push('');

    lines.push('## AI Summary');
    lines.push('');
    lines.push('### Key moments');
    lines.push('');
    pushBullets(lines, summary && summary.keyMoments);
    lines.push('');
    lines.push('### Decisions');
    lines.push('');
    pushBullets(lines, summary && summary.decisions);
    lines.push('');
    lines.push('### Action items');
    lines.push('');
    pushBullets(lines, summary && summary.actionItems);
    lines.push('');
    lines.push('### Open questions');
    lines.push('');
    pushBullets(lines, summary && summary.openQuestions);
    lines.push('');

    lines.push('## Transcript');
    lines.push('');
    if (Array.isArray(transcript) && transcript.length > 0) {
      for (const t of transcript) {
        const time = (t && t.time) || '00:00';
        const speaker = (t && t.speaker) || 'Speaker';
        const text = (t && t.text) || '';
        lines.push(`- **${time}** ${speaker}: ${text}`);
      }
    } else {
      lines.push('*（无转录内容 — 浏览器扩展仅录制音频，转录由 macOS 应用生成。）*');
    }
    lines.push('');
    lines.push('---');
    lines.push(`*Exported by Yinghua Chrome extension · ${new Date().toISOString()}*`);
    lines.push('');

    return lines.join('\n');
  }

  function pushBullets(out, arr) {
    if (Array.isArray(arr) && arr.length > 0) {
      for (const item of arr) {
        // Escape any leading "-" so markdown doesn't break
        const text = String(item == null ? '' : item).replace(/\r?\n/g, ' ');
        out.push(`- ${text}`);
      }
    } else {
      out.push('*（无）*');
    }
  }

  function collectSpeakers(transcript) {
    if (!Array.isArray(transcript) || transcript.length === 0) return [];
    const seen = new Set();
    for (const t of transcript) {
      const s = t && t.speaker;
      if (s) seen.add(s);
    }
    return Array.from(seen);
  }

  // ---- Download driver -----------------------------------------------------

  function triggerDownload(blob, filename) {
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.rel = 'noopener';
    a.style.display = 'none';
    document.body.appendChild(a);
    a.click();
    // Revoke after a tick so the browser has time to start the download
    setTimeout(() => {
      try { URL.revokeObjectURL(url); } catch (e) { /* ignore */ }
      if (a.parentNode) a.parentNode.removeChild(a);
    }, 250);
  }

  // ---- Public API ----------------------------------------------------------

  function exportMarkdown(rec, summary, transcript) {
    if (!rec) return { ok: false, error: 'missing_recording' };
    try {
      const md = buildMarkdown(rec, summary || null, transcript || null);
      const blob = new Blob([md], { type: 'text/markdown;charset=utf-8' });
      const filename = suggestFilename(rec, 'md');
      triggerDownload(blob, filename);
      return { ok: true, filename, bytes: blob.size };
    } catch (e) {
      return { ok: false, error: String(e && e.message || e) };
    }
  }

  function exportWebm(rec) {
    if (!rec) return { ok: false, error: 'missing_recording' };
    if (!rec.blob) {
      return { ok: false, error: 'no_blob' };
    }
    try {
      const filename = suggestFilename(rec, 'webm');
      triggerDownload(rec.blob, filename);
      return { ok: true, filename, bytes: rec.blob.size || 0 };
    } catch (e) {
      return { ok: false, error: String(e && e.message || e) };
    }
  }

  // Expose as a single namespace so the popup can call:
  //   YinghuaExport.exportMarkdown(rec, summary, transcript)
  //   YinghuaExport.exportWebm(rec)
  //   YinghuaExport.suggestFilename(rec, ext)
  window.YinghuaExport = {
    exportMarkdown,
    exportWebm,
    suggestFilename,
  };
})();
