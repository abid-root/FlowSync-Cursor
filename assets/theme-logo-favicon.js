(function () {
  if (window.__flowsyncThemeLogoReady) return;
  window.__flowsyncThemeLogoReady = true;

  const root = document.documentElement;

  function getTheme() {
    return root.getAttribute("data-theme") === "light" ? "light" : "dark";
  }

  function nestedPrefix() {
    const path = window.location.pathname || "";
    return (path.includes("/sources/") || path.includes("/categories/")) ? "../" : "";
  }

  function fallback(theme) {
    return nestedPrefix() + (theme === "light"
      ? "assets/common/flowsync-logo-light-128.webp"
      : "assets/common/flowsync-logo-dark-128.webp");
  }

  function resolve(path, theme) {
    const value = (path || "").trim();
    if (!value || value.startsWith("=")) return fallback(theme);
    return value;
  }

  function applyThemeAssets() {
    const theme = getTheme();

    document.querySelectorAll("img.brand-logo[data-logo-dark][data-logo-light]").forEach((img) => {
      const src = resolve(theme === "light" ? img.dataset.logoLight : img.dataset.logoDark, theme);
      if (img.getAttribute("src") !== src) img.setAttribute("src", src);
    });

    document.querySelectorAll("link[data-theme-favicon]").forEach((link) => {
      const href = resolve(theme === "light" ? link.dataset.hrefLight : link.dataset.hrefDark, theme);
      if (link.getAttribute("href") !== href) link.setAttribute("href", href);
    });
  }

  new MutationObserver(applyThemeAssets).observe(root, {
    attributes: true,
    attributeFilter: ["data-theme"]
  });

  document.addEventListener("DOMContentLoaded", applyThemeAssets);
  document.addEventListener("click", (event) => {
    if (event.target.closest("[data-theme-toggle]")) {
      window.setTimeout(applyThemeAssets, 0);
      window.setTimeout(applyThemeAssets, 80);
    }
  });

  applyThemeAssets();
})();