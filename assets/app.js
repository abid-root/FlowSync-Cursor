
const COLD_DATA = window.COLD_DATA || [];
const COLD_EFFECTS = window.COLD_EFFECTS || [];

function qs(sel, root = document) {
  return root.querySelector(sel);
}

function qsa(sel, root = document) {
  return Array.from(root.querySelectorAll(sel));
}

function initTheme() {
  const root = document.documentElement;
  const body = document.body;
  const sun = String.fromCharCode(9788);
  const moon = String.fromCharCode(9789);

  function clean(value) {
    return value === "light" ? "light" : "dark";
  }

  function apply(theme) {
    theme = clean(theme);
    root.setAttribute("data-theme", theme);
    body.setAttribute("data-theme", theme);
    body.classList.toggle("dark", theme === "dark");
    localStorage.setItem("coldboot-cursor-theme", theme);

    qsa("[data-theme-toggle]").forEach((btn) => {
      btn.textContent = theme === "light" ? sun : moon;
      btn.setAttribute("aria-label", "Toggle theme");
      btn.setAttribute("type", "button");
    });
  }

  qsa("[data-theme-toggle]").forEach((btn) => {
    btn.onclick = (event) => {
      event.preventDefault();
      const current = clean(root.getAttribute("data-theme"));
      apply(current === "light" ? "dark" : "light");
    };
  });

  apply(localStorage.getItem("coldboot-cursor-theme") || root.getAttribute("data-theme") || "dark");
}
function syncCategoryExpandedState(grid, expanded) {
  const strip = grid ? grid.closest(".category-strip") : null;
  if (strip) strip.classList.toggle("is-expanded", expanded);
}

function renderCategoryGrid(grid, activeId, expanded, sameFolder) {
  grid.innerHTML = COLD_DATA.map((cat) => {
    const href = sameFolder ? `${cat.id}.html` : `categories/${cat.id}.html`;
    return `
      <a class="category-card ${cat.id === activeId ? "active" : ""}" href="${href}">
        <strong>
          <span class="cat-icon" aria-hidden="true">${cat.icon}</span>
          <span class="cat-label">${cat.title}</span>
        </strong>
      </a>
    `;
  }).join("");
}

function attachEffectPreview(section, effect) {
  const layer = qs(".fx-layer", section);
  const target = qs(".preview-zone", section) || section;

  if (!layer || !target || !effect || typeof COLD_FX === "undefined") return;

  let last = 0;

  target.addEventListener("pointermove", (event) => {
    const now = performance.now();
    const gap = typeof COLD_FX.rate === "function" ? COLD_FX.rate(effect) : 86;

    if (now - last < gap) return;
    last = now;

    const rect = layer.getBoundingClientRect();
    const x = event.clientX - rect.left;
    const y = event.clientY - rect.top;

    COLD_FX.spawn(effect, layer, x, y);
  });

  target.addEventListener("pointerleave", () => {
    setTimeout(() => COLD_FX.clear(layer), 520);
  });
}

function initIndex() {
  initTheme();

  const grid = qs("#categoryGrid");
  const button = qs("#seeMoreBtn");

  if (!grid) return;

  let expanded = true;

  function render() {
    renderCategoryGrid(grid, "", expanded, false);
    syncCategoryExpandedState(grid, expanded);
    if (button) button.style.display = "none";
  }

  render();
}

function initCategoryPage(catId) {
  initTheme();

  const grid = qs("#categoryGrid");
  const button = qs("#seeMoreBtn");

  if (!grid) return;

  let expanded = true;

  function render() {
    renderCategoryGrid(grid, catId, expanded, true);
    syncCategoryExpandedState(grid, expanded);
    if (button) button.style.display = "none";
  }

  render();

  qsa(".effect-box").forEach((box) => {
    const effect = COLD_EFFECTS.find((item) => item.key === box.dataset.effect);
    attachEffectPreview(box, effect);
  });
}

function initSourcePage(effectKey) {
  initTheme();

  const effect = COLD_EFFECTS.find((item) => item.key === effectKey);
  const preview = qs("#sourcePreview");

  if (preview && effect) {
    attachEffectPreview(preview, effect);
  }

  qsa(".code-tab").forEach((btn) => {
    btn.addEventListener("click", () => {
      qsa(".code-tab").forEach((item) => item.classList.toggle("active", item === btn));
      qsa(".code-pane").forEach((pane) => {
        pane.hidden = pane.dataset.code !== btn.dataset.tab;
      });
    });
  });

  const copyBtn = qs("#copyAll");

  if (copyBtn) {
    copyBtn.addEventListener("click", async () => {
      const text = qsa(".code-pane code").map((node) => node.textContent).join("\n\n");

      try {
        await navigator.clipboard.writeText(text);
        copyBtn.textContent = "Copied";
        setTimeout(() => copyBtn.textContent = "Copy all", 1200);
      } catch {
        copyBtn.textContent = "Copy failed";
        setTimeout(() => copyBtn.textContent = "Copy all", 1200);
      }
    });
  }
}

/* hide nav/category when scrolling down, reveal when scrolling up */
(function () {
  let lastScrollY = window.scrollY;
  let ticking = false;

  function updateBars() {
    const currentY = window.scrollY;
    const down = currentY > lastScrollY && currentY > 100;
    const up = currentY < lastScrollY;

    document.body.classList.toggle("hide-top-bars", down && !up);

    if (up || currentY < 40) {
      document.body.classList.remove("hide-top-bars");
    }

    lastScrollY = currentY;
    ticking = false;
  }

  window.addEventListener("scroll", () => {
    if (!ticking) {
      requestAnimationFrame(updateBars);
      ticking = true;
    }
  }, { passive: true });
})();
