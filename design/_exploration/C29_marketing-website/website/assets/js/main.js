/* =========================================================================
   映话 (Yìnghuà) — Main JS
   - Theme toggle (auto / dark / light, persisted in localStorage)
   - Smooth scroll for anchor links
   - Mobile nav menu toggle
   - Active section highlight in nav
   - FAQ accordion
   - Footer year auto-fill
   ========================================================================= */

(function () {
  'use strict';

  // ---------------------------------------------------------------------------
  // 1. Theme management
  // ---------------------------------------------------------------------------

  const THEME_KEY = 'yinghua-theme';
  const root = document.documentElement;

  function getStoredTheme() {
    try {
      return localStorage.getItem(THEME_KEY);
    } catch (e) {
      return null;
    }
  }

  function setStoredTheme(value) {
    try {
      localStorage.setItem(THEME_KEY, value);
    } catch (e) { /* private mode */ }
  }

  function applyTheme(theme) {
    if (theme === 'auto') {
      root.setAttribute('data-theme', 'auto');
    } else {
      root.setAttribute('data-theme', theme);
    }
    const btn = document.querySelector('[data-theme-toggle]');
    if (btn) {
      btn.setAttribute('aria-label', theme === 'light' ? '切换到深色' : '切换到浅色');
      btn.setAttribute('title', theme === 'light' ? '切换到深色' : '切换到浅色');
    }
  }

  function cycleTheme() {
    const current = root.getAttribute('data-theme') || 'dark';
    let next;
    if (current === 'dark') next = 'light';
    else if (current === 'light') next = 'auto';
    else next = 'dark';
    setStoredTheme(next);
    applyTheme(next);
  }

  // Initialize theme — runs early so no flash
  (function initTheme() {
    const stored = getStoredTheme();
    const theme = stored || 'dark';
    applyTheme(theme);
  })();

  document.addEventListener('DOMContentLoaded', function () {
    const themeBtn = document.querySelector('[data-theme-toggle]');
    if (themeBtn) {
      themeBtn.addEventListener('click', cycleTheme);
    }
  });

  // ---------------------------------------------------------------------------
  // 2. Smooth scroll for anchor links (CSS scroll-behavior handles most cases,
  //    but we add offset for the fixed nav)
  // ---------------------------------------------------------------------------

  document.addEventListener('DOMContentLoaded', function () {
    const navHeight = 64;
    document.querySelectorAll('a[href^="#"]').forEach(function (link) {
      const href = link.getAttribute('href');
      if (href === '#' || href.length < 2) return;
      const target = document.querySelector(href);
      if (!target) return;
      link.addEventListener('click', function (e) {
        e.preventDefault();
        const offsetTop = target.getBoundingClientRect().top + window.pageYOffset - navHeight;
        window.scrollTo({
          top: offsetTop,
          behavior: prefersReducedMotion() ? 'auto' : 'smooth'
        });
        // Close mobile menu if open
        const mobile = document.querySelector('.nav-mobile-menu');
        if (mobile) mobile.classList.remove('open');
      });
    });
  });

  // ---------------------------------------------------------------------------
  // 3. Mobile nav toggle
  // ---------------------------------------------------------------------------

  document.addEventListener('DOMContentLoaded', function () {
    const toggle = document.querySelector('[data-mobile-toggle]');
    const menu = document.querySelector('.nav-mobile-menu');
    if (!toggle || !menu) return;
    toggle.addEventListener('click', function () {
      const isOpen = menu.classList.toggle('open');
      toggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    });
  });

  // ---------------------------------------------------------------------------
  // 4. Active section highlight in nav (homepage only)
  // ---------------------------------------------------------------------------

  document.addEventListener('DOMContentLoaded', function () {
    const navLinks = document.querySelectorAll('.nav-links a[href^="#"]');
    if (!navLinks.length) return;

    const sections = [];
    navLinks.forEach(function (link) {
      const id = link.getAttribute('href').slice(1);
      const section = document.getElementById(id);
      if (section) sections.push({ id: id, el: section, link: link });
    });
    if (!sections.length) return;

    function update() {
      const scrollY = window.pageYOffset;
      const offset = 120;
      let current = sections[0];
      for (const s of sections) {
        if (s.el.offsetTop - offset <= scrollY) current = s;
      }
      navLinks.forEach(function (l) { l.classList.remove('active'); });
      if (current && current.link) current.link.classList.add('active');
    }

    let ticking = false;
    window.addEventListener('scroll', function () {
      if (!ticking) {
        window.requestAnimationFrame(function () {
          update();
          ticking = false;
        });
        ticking = true;
      }
    }, { passive: true });
    update();
  });

  // ---------------------------------------------------------------------------
  // 5. FAQ accordion
  // ---------------------------------------------------------------------------

  document.addEventListener('DOMContentLoaded', function () {
    const triggers = document.querySelectorAll('.faq-trigger');
    triggers.forEach(function (trigger) {
      trigger.addEventListener('click', function () {
        const item = trigger.closest('.faq-item');
        if (!item) return;
        const isOpen = item.classList.contains('open');
        // Optional: close others
        document.querySelectorAll('.faq-item.open').forEach(function (other) {
          if (other !== item) other.classList.remove('open');
        });
        if (isOpen) item.classList.remove('open');
        else item.classList.add('open');
        trigger.setAttribute('aria-expanded', isOpen ? 'false' : 'true');
      });
    });
  });

  // ---------------------------------------------------------------------------
  // 6. Footer year
  // ---------------------------------------------------------------------------

  document.addEventListener('DOMContentLoaded', function () {
    const yearEl = document.querySelector('[data-current-year]');
    if (yearEl) yearEl.textContent = String(new Date().getFullYear());
  });

  // ---------------------------------------------------------------------------
  // 7. Helpers
  // ---------------------------------------------------------------------------

  function prefersReducedMotion() {
    return window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  }

  // ---------------------------------------------------------------------------
  // 8. Listen for system theme changes (only when in auto mode)
  // ---------------------------------------------------------------------------

  if (window.matchMedia) {
    const mq = window.matchMedia('(prefers-color-scheme: light)');
    const handler = function () {
      const current = root.getAttribute('data-theme');
      if (current === 'auto') {
        // Trigger re-eval by removing and re-setting
        root.setAttribute('data-theme', 'auto');
      }
    };
    if (mq.addEventListener) mq.addEventListener('change', handler);
    else if (mq.addListener) mq.addListener(handler);
  }

  // ---------------------------------------------------------------------------
  // 9. C79 motion — Apple-style micro-animations
  //    - Hero parallax scroll
  //    - Y-mark 3D mouse-tracked tilt
  //    - Scroll reveal (IntersectionObserver)
  //    - Number count-up
  //    - All wrapped with prefers-reduced-motion guards
  // ---------------------------------------------------------------------------

  document.addEventListener('DOMContentLoaded', function () {
    if (prefersReducedMotion()) {
      // Reveal everything immediately, no motion
      document.querySelectorAll(
        '.feature-card, .stat, .screenshot-card, .teams-card, .price-card, .testimonial, .hero-stat'
      ).forEach(function (el) { el.classList.add('revealed'); });
      return;
    }

    // 1. Hero parallax (rAF-throttled)
    const heroBg = document.querySelector('.hero-bg');
    if (heroBg) {
      let ticking = false;
      function updateParallax() {
        const scrolled = window.pageYOffset || window.scrollY;
        // Limit parallax range so it doesn't drift too far
        const offset = Math.min(scrolled * 0.3, 200);
        heroBg.style.transform = 'translate3d(0, ' + offset + 'px, 0)';
        ticking = false;
      }
      function onScroll() {
        if (!ticking) {
          window.requestAnimationFrame(updateParallax);
          ticking = true;
        }
      }
      window.addEventListener('scroll', onScroll, { passive: true });
    }

    // 2. Y-mark 3D mouse tilt
    document.querySelectorAll('.y-mark-3d').forEach(function (el) {
      el.addEventListener('mousemove', function (e) {
        const rect = el.getBoundingClientRect();
        const x = (e.clientX - rect.left) / rect.width - 0.5;
        const y = (e.clientY - rect.top) / rect.height - 0.5;
        el.style.transform =
          'perspective(800px) rotateY(' + (x * 25) + 'deg) rotateX(' + (-y * 25) + 'deg)';
      });
      el.addEventListener('mouseleave', function () {
        el.style.transform = 'perspective(800px) rotateY(0) rotateX(0)';
      });
    });

    // 3. Scroll reveal (IntersectionObserver)
    if ('IntersectionObserver' in window) {
      const revealTargets = document.querySelectorAll(
        '.feature-card, .stat, .screenshot-card, .teams-card, .price-card, .testimonial, .hero-stat'
      );
      const revealObserver = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add('revealed');
            revealObserver.unobserve(entry.target);
          }
        });
      }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
      revealTargets.forEach(function (el) { revealObserver.observe(el); });
    } else {
      // Fallback: reveal all immediately
      document.querySelectorAll(
        '.feature-card, .stat, .screenshot-card, .teams-card, .price-card, .testimonial, .hero-stat'
      ).forEach(function (el) { el.classList.add('revealed'); });
    }

    // 4. Counter animation
    function animateCounter(el, target, duration) {
      duration = duration || 1500;
      const start = 0;
      const startTime = performance.now();
      const useLocale = (target >= 1000);
      function update(now) {
        const elapsed = now - startTime;
        const progress = Math.min(elapsed / duration, 1);
        // easeOutCubic
        const eased = 1 - Math.pow(1 - progress, 3);
        const current = Math.floor(start + (target - start) * eased);
        el.textContent = useLocale ? current.toLocaleString() : String(current);
        if (progress < 1) {
          window.requestAnimationFrame(update);
        } else {
          el.textContent = useLocale ? target.toLocaleString() : String(target);
        }
      }
      window.requestAnimationFrame(update);
    }

    if ('IntersectionObserver' in window) {
      document.querySelectorAll('.stat-number[data-target]').forEach(function (el) {
        const raw = el.getAttribute('data-target');
        const target = parseInt(raw, 10);
        if (isNaN(target)) return;
        const obs = new IntersectionObserver(function (entries) {
          if (entries[0].isIntersecting) {
            animateCounter(el, target, 1400);
            obs.disconnect();
          }
        }, { threshold: 0.5 });
        obs.observe(el);
      });
    } else {
      // No-op fallback: just show the target
      document.querySelectorAll('.stat-number[data-target]').forEach(function (el) {
        const target = parseInt(el.getAttribute('data-target'), 10);
        if (!isNaN(target)) el.textContent = String(target);
      });
    }
  });
})();
