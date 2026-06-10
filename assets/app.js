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
  const saved = localStorage.getItem("coldboot-cursor-theme") || "dark";
  root.setAttribute("data-theme", saved);

  qsa("[data-theme-toggle]").forEach((btn) => {
    const sync = () => {
      btn.textContent = root.getAttribute("data-theme") === "light" ? "☀" : "☾";
    };

    sync();

    btn.addEventListener("click", () => {
      const next = root.getAttribute("data-theme") === "light" ? "dark" : "light";
      root.setAttribute("data-theme", next);
      localStorage.setItem("coldboot-cursor-theme", next);
      qsa("[data-theme-toggle]").forEach((b) => {
        b.textContent = next === "light" ? "☀" : "☾";
      });
    });
  });
}

function attachEffectPreview(section, effect) {
  const layer = qs(".fx-layer", section);
  const preview = qs(".preview-zone", section) || section;

  if (!layer || !preview || !effect) return;

  let last = 0;

  preview.addEventListener("pointermove", (event) => {
    const now = performance.now();
    const gap = effect.kind && effect.kind.startsWith("snake") ? 24 : 92;

    if (now - last < gap) return;
    last = now;

    const layerRect = layer.getBoundingClientRect();
    const x = event.clientX - layerRect.left;
    const y = event.clientY - layerRect.top;

    COLD_FX.spawn(effect, layer, x, y);
  });

  preview.addEventListener("pointerleave", () => {
    if (effect.kind && effect.kind.startsWith("snake")) {
      setTimeout(() => COLD_FX.clear(layer), 420);
    }
  });
}

function initIndex() {
  initTheme();

  const grid = qs("#categoryGrid");
  const button = qs("#seeMoreBtn");

  if (!grid) return;

  let expanded = false;

  function render() {
    grid.innerHTML = COLD_DATA.map((cat, index) => `
      <a class="category-card ${!expanded && index >= 4 ? "hidden" : ""}" href="categories/${cat.id}.html">
        <small>${cat.num} / 6 effects</small>
        <strong>${cat.icon} ${cat.title}</strong>
      </a>
    `).join("");

    if (button) button.textContent = expanded ? "Show less" : "See more";
  }

  render();

  if (button) {
    button.addEventListener("click", () => {
      expanded = !expanded;
      render();
    });
  }
}

function initCategoryPage(catId) {
  initTheme();

  const grid = qs("#categoryGrid");
  const button = qs("#seeMoreBtn");

  if (!grid) return;

  let expanded = false;

  function render() {
    grid.innerHTML = COLD_DATA.map((cat, index) => `
      <a class="category-card ${cat.id === catId ? "active" : ""} ${!expanded && index >= 4 ? "hidden" : ""}" href="${cat.id}.html">
        <small>${cat.num} / 6 effects</small>
        <strong>${cat.icon} ${cat.title}</strong>
      </a>
    `).join("");

    if (button) button.textContent = expanded ? "Show less" : "See more";
  }

  render();

  if (button) {
    button.addEventListener("click", () => {
      expanded = !expanded;
      render();
    });
  }

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
      qsa(".code-tab").forEach((item) => {
        item.classList.toggle("active", item === btn);
      });

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
