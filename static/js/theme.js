// Dark/Light theme toggle with localStorage persistence
(function() {
  var STORAGE_KEY = 'theme-preference';

  function getStoredTheme() {
    try {
      return localStorage.getItem(STORAGE_KEY);
    } catch (e) {
      return null;
    }
  }

  function setStoredTheme(theme) {
    try {
      localStorage.setItem(STORAGE_KEY, theme);
    } catch (e) {
      // localStorage not available
    }
  }

  function applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    var icon = document.querySelector('.theme-toggle-icon');
    if (icon) {
      icon.textContent = theme === 'dark' ? '☀️' : '🌙';
    }
    var btn = document.getElementById('theme-toggle');
    if (btn) {
      btn.setAttribute('aria-label',
        theme === 'dark' ? 'Switch to light theme' : 'Switch to dark theme'
      );
    }
  }

  function getPreferredTheme() {
    var stored = getStoredTheme();
    if (stored) return stored;
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  // Apply theme immediately to prevent flash
  applyTheme(getPreferredTheme());

  function initThemeToggle() {
    var btn = document.getElementById('theme-toggle');
    if (!btn) return;

    // Ensure icon matches current theme
    applyTheme(getPreferredTheme());

    btn.addEventListener('click', function() {
      var current = document.documentElement.getAttribute('data-theme') || 'light';
      var next = current === 'dark' ? 'light' : 'dark';
      applyTheme(next);
      setStoredTheme(next);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initThemeToggle);
  } else {
    initThemeToggle();
  }
})();
