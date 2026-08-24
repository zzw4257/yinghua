/* =========================================================================
   映话 (Yìnghuà) — Recording Demo
   - Simulated 10s loop: REC start → live transcript → AI summary → reset
   - Honors prefers-reduced-motion (no autostart)
   ========================================================================= */

(function () {
  'use strict';

  class RecordingDemo {
    constructor(container) {
      this.container = container;
      this.timeEl = container.querySelector('.demo-timecode');
      this.recDotEl = container.querySelector('.demo-rec-dot');
      this.transcriptEl = container.querySelector('.demo-transcript');
      this.summaryEl = container.querySelector('.demo-summary');

      this.reducedMotion = window.matchMedia &&
        window.matchMedia('(prefers-reduced-motion: reduce)').matches;

      this.startTime = 0;
      this.isRecording = false;
      this.tickHandle = null;

      // Show a static summary immediately for users with reduced motion,
      // so they still see what the app does without animation.
      if (this.reducedMotion) {
        this.showSummary();
        if (this.recDotEl) this.recDotEl.classList.add('active');
        if (this.timeEl) this.timeEl.textContent = '00:00';
        return;
      }

      this.start();
    }

    start() {
      // Phase 1: start recording
      setTimeout(() => {
        this.isRecording = true;
        this.startTime = Date.now();
        if (this.recDotEl) this.recDotEl.classList.add('active');
        this.tick();
      }, 500);

      // Phase 2: live transcript lines
      setTimeout(() => this.addTranscriptLine('面试官', '请介绍一下你最近的项目经验。'), 2500);
      setTimeout(() => this.addTranscriptLine('我', '好的，我最近在做一个 macOS app...'), 3500);
      setTimeout(() => this.addTranscriptLine('面试官', '技术选型上有哪些考虑？'), 4500);

      // Phase 3: stop + AI summary
      setTimeout(() => {
        this.isRecording = false;
        if (this.recDotEl) this.recDotEl.classList.remove('active');
        this.showSummary();
      }, 5500);

      // Phase 4: reset & loop
      setTimeout(() => this.reset(), 9500);
      setTimeout(() => this.start(), 10000);
    }

    tick() {
      if (!this.isRecording) return;
      const elapsed = Math.floor((Date.now() - this.startTime) / 1000);
      const m = Math.floor(elapsed / 60).toString().padStart(2, '0');
      const s = (elapsed % 60).toString().padStart(2, '0');
      if (this.timeEl) this.timeEl.textContent = m + ':' + s;
      this.tickHandle = setTimeout(() => this.tick(), 1000);
    }

    addTranscriptLine(speaker, text) {
      if (!this.transcriptEl) return;
      const line = document.createElement('div');
      line.className = 'demo-line';
      const color = speaker === '面试官' ? '#8A5BFF' : '#2DD4BF';
      const speakerEl = document.createElement('span');
      speakerEl.className = 'demo-speaker';
      speakerEl.style.color = color;
      speakerEl.textContent = speaker;
      const textEl = document.createElement('span');
      textEl.className = 'demo-text';
      textEl.textContent = text;
      line.appendChild(speakerEl);
      line.appendChild(textEl);
      this.transcriptEl.appendChild(line);
      this.transcriptEl.scrollTop = this.transcriptEl.scrollHeight;
    }

    showSummary() {
      if (!this.summaryEl) return;
      const sections = [
        { title: '关键瞬间', count: '3 个' },
        { title: '达成的决定', count: '2 个' },
        { title: '待办', count: '3 个' },
        { title: '遗留问题', count: '1 个' }
      ];
      this.summaryEl.innerHTML = sections.map((s, i) => {
        const sec = document.createElement('div');
        sec.className = 'demo-summary-section';
        sec.style.setProperty('--delay', (i * 0.1) + 's');
        const title = document.createElement('span');
        title.className = 'demo-summary-title';
        title.textContent = s.title;
        const count = document.createElement('span');
        count.className = 'demo-summary-count';
        count.textContent = s.count;
        sec.appendChild(title);
        sec.appendChild(count);
        return sec;
      });
      this.summaryEl.classList.add('visible');
    }

    reset() {
      if (this.tickHandle) {
        clearTimeout(this.tickHandle);
        this.tickHandle = null;
      }
      if (this.recDotEl) this.recDotEl.classList.remove('active');
      if (this.transcriptEl) this.transcriptEl.innerHTML = '';
      if (this.summaryEl) {
        this.summaryEl.innerHTML = '';
        this.summaryEl.classList.remove('visible');
      }
      if (this.timeEl) this.timeEl.textContent = '00:00';
    }
  }

  function init() {
    const demos = document.querySelectorAll('.recording-demo');
    demos.forEach((el) => new RecordingDemo(el));
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
