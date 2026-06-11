(function () {
  if (window.__coldbootThemeLogoReady) return;
  window.__coldbootThemeLogoReady = true;

  const root = document.documentElement;

  function getTheme() {
    return root.getAttribute("data-theme") === "light" ? "light" : "dark";
  }

  function applyThemeAssets() {
    const theme = getTheme();

    document.querySelectorAll("img.brand-logo[data-logo-dark][data-logo-light]").forEach((img) => {
      const src = theme === "light" ? img.dataset.logoLight : img.dataset.logoDark;
      if (src && img.getAttribute("src") !== src) img.setAttribute("src", src);
    });

    document.querySelectorAll("link[data-theme-favicon]").forEach((link) => {
      const href = theme === "light" ? link.dataset.hrefLight : link.dataset.hrefDark;
      if (href && link.getAttribute("href") !== href) link.setAttribute("href", href);
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