/* ===================================================================
 * 映话 (Yìnghuà) — Onboarding Prototype · main.js
 * 屏 1~4 共享交互逻辑 (no framework · 纯 vanilla)
 * =================================================================== */

(function () {
  'use strict';

  /* ---------- localStorage 状态管理 ---------- */
  var STORAGE_KEY = 'yinghua-onboarding';

  function saveState(screen) {
    try { localStorage.setItem(STORAGE_KEY, screen); } catch (e) { /* 隐私模式可能不可用 */ }
  }

  function getState() {
    try { return localStorage.getItem(STORAGE_KEY) || '01-welcome'; }
    catch (e) { return '01-welcome'; }
  }

  function getProvider() {
    try { return localStorage.getItem(STORAGE_KEY + '-provider') || 'anthropic'; }
    catch (e) { return 'anthropic'; }
  }

  function setProvider(p) {
    try { localStorage.setItem(STORAGE_KEY + '-provider', p); } catch (e) { /* noop */ }
  }

  // 暴露给屏内 inline 调用
  window.YH = window.YH || {};
  window.YH.saveState = saveState;
  window.YH.getState = getState;
  window.YH.getProvider = getProvider;
  window.YH.setProvider = setProvider;

  /* ---------- 屏跳转 (同目录相对路径) ---------- */
  function go(screen) {
    saveState(screen);
    window.location.href = screen;
  }

  window.YH.go = go;

  /* ---------- 屏 1-3 通用: progress dots 自动标记 passed ---------- */
  document.addEventListener('DOMContentLoaded', function () {
    var dots = document.querySelectorAll('.progress-dot');
    if (!dots.length) return;

    // 通过 filename 推断 active index
    var path = window.location.pathname;
    var match = path.match(/0(\d)-/);
    if (!match) return;
    var current = parseInt(match[1], 10); // 1..4

    dots.forEach(function (d, i) {
      var idx = i + 1;
      if (idx < current) d.classList.add('passed');
      else if (idx === current) d.classList.add('active');
    });
  });

  /* ---------- 屏 3: Provider 切换 ---------- */
  document.addEventListener('DOMContentLoaded', function () {
    var providerCards = document.querySelectorAll('.provider-card');
    if (!providerCards.length) return;

    // 恢复上次选中
    var lastProvider = getProvider();
    providerCards.forEach(function (card) {
      var name = card.getAttribute('data-provider');
      if (name === lastProvider) {
        card.classList.add('selected');
      }
      card.addEventListener('click', function () {
        providerCards.forEach(function (c) { c.classList.remove('selected'); });
        card.classList.add('selected');
        setProvider(name);
        // 同步更新测试按钮的 provider 文字
        var labelEl = document.getElementById('provider-label');
        if (labelEl) labelEl.textContent = name.charAt(0).toUpperCase() + name.slice(1);
      });
    });
  });

  /* ---------- 屏 3: API key 显示/隐藏 ---------- */
  document.addEventListener('DOMContentLoaded', function () {
    var eyeBtn = document.getElementById('eye-toggle');
    var keyInput = document.getElementById('api-key');
    if (!eyeBtn || !keyInput) return;

    eyeBtn.addEventListener('click', function () {
      var isPwd = keyInput.type === 'password';
      keyInput.type = isPwd ? 'text' : 'password';
      eyeBtn.setAttribute('aria-pressed', isPwd ? 'true' : 'false');
      var icon = eyeBtn.querySelector('svg');
      if (icon) {
        // 切换 eye-on / eye-off path
        icon.innerHTML = isPwd
          ? '<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7z" stroke="currentColor" stroke-width="1.5" fill="none" stroke-linecap="round" stroke-linejoin="round"/><circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.5" fill="none"/>'
          : '<path d="M3 3l18 18M10.7 6.2A10 10 0 0112 6c6.5 0 10 6 10 6a13 13 0 01-3.4 4.1M6.1 6.1C3.3 8 2 12 2 12s3.5 6 10 6c1.5 0 2.8-.3 4-.8M9.9 9.9a3 3 0 004.2 4.2" stroke="currentColor" stroke-width="1.5" fill="none" stroke-linecap="round" stroke-linejoin="round"/>';
      }
    });
  });

  /* ---------- 屏 3: Test connection 模拟 ---------- */
  document.addEventListener('DOMContentLoaded', function () {
    var testBtn = document.getElementById('test-btn');
    if (!testBtn) return;

    var status = document.getElementById('test-status');
    var cta = document.getElementById('finish-cta');
    var keyInput = document.getElementById('api-key');

    testBtn.addEventListener('click', function () {
      var apiKey = (keyInput && keyInput.value || '').trim();
      var providerEl = document.querySelector('.provider-card.selected');
      var provider = providerEl ? providerEl.getAttribute('data-provider') : 'anthropic';

      // reset
      if (status) {
        status.className = 'test-status testing';
        status.innerHTML = '<span class="test-spinner"></span><span>Testing connection…</span>';
      }
      if (cta) cta.disabled = true;

      // simulate latency
      setTimeout(function () {
        if (!apiKey) {
          if (status) {
            status.className = 'test-status failed';
            status.innerHTML = '<span>✗</span><span>请先填入 API key</span>';
          }
          return;
        }
        if (apiKey === 'wrong' || apiKey === 'invalid' || apiKey.length < 8) {
          if (status) {
            status.className = 'test-status failed';
            status.innerHTML = '<span>✗</span><span>Invalid key</span>';
          }
          return;
        }
        // success
        var prettyName = provider.charAt(0).toUpperCase() + provider.slice(1);
        if (status) {
          status.className = 'test-status success';
          status.innerHTML = '<span>✓</span><span>Connected to ' + prettyName + '</span>';
        }
        if (cta) cta.disabled = false;
      }, 1500);
    });
  });

  /* ---------- 屏 4: checkmark 弹跳动画 (CSS-driven by .drawn) ---------- */
  document.addEventListener('DOMContentLoaded', function () {
    var check = document.querySelector('.checkmark');
    if (!check) return;

    // 立即加 .drawn 触发 CSS 动画
    setTimeout(function () {
      check.classList.add('drawn');
    }, 200);
  });
})();
