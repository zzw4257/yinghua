/* =========================================================================
   映话 (Yìnghuà) — Y Icon (C87 fix: static + hover scale, no 3D rotation)
   - Removes preserve-3d / perspective / idle rotation that caused viewport
     blowout (Y was rendering at viewBox 1024×1024 inside 240×240 stage
     when 3D transform stack was active).
   - Keeps mouse hover micro-interaction (scale) for affordance.
   - Honors prefers-reduced-motion.
   ========================================================================= */

(function () {
  'use strict';

  class YStatic {
    constructor(container) {
      this.container = container;
      this.svg = container.querySelector('svg');
      this.reducedMotion = window.matchMedia &&
        window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      this.bind();
    }

    bind() {
      if (!this.svg) return;
      this.container.addEventListener('mouseenter', () => {
        this.svg.style.transform = this.reducedMotion ? '' : 'scale(1.05)';
      });
      this.container.addEventListener('mouseleave', () => {
        this.svg.style.transform = 'scale(1)';
      });
    }
  }

  function init() {
    const el = document.getElementById('y-icon-3d-stage');
    if (el) new YStatic(el);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
