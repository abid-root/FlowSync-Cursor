(function () {
  if (typeof COLD_FX === "undefined") return;

  const originalSpawn = COLD_FX.spawn.bind(COLD_FX);
  const originalClear = COLD_FX.clear ? COLD_FX.clear.bind(COLD_FX) : null;
  const stores = new WeakMap();

  const wildHandlers = new Set([
    "spider-crawler",
    "cockroach-skitter",
    "crocodile-crawl",
    "mini-dragon",
    "scorpion-tail",
    "gecko-dash",
    "bat-flutter",
    "crab-walk"
  ]);

  const classicHandlers = {
    "default-dot": defaultDot,
    "default-ring": defaultRing,
    "default-crosshair": defaultCrosshair,
    "corner-bracket": cornerBracket,
    "click-flash": clickFlash
  };

  function palette(effect) {
    const theme = document.documentElement.getAttribute("data-theme") === "light" ? "light" : "dark";
    return effect[theme] || effect.dark || { a: "#a7e956", b: "#f5f1e8", ink: "#101014" };
  }

  function rand(a, b) { return a + Math.random() * (b - a); }
  function removeAfter(el, ms) { setTimeout(() => el.remove(), ms + 60); }

  function addPiece(layer, cls, x, y, effect, text = "") {
    const p = palette(effect);
    const el = document.createElement("span");
    el.className = "fx-piece wild-basic-fx " + cls;
    el.textContent = text;
    el.style.left = x + "px";
    el.style.top = y + "px";
    el.style.setProperty("--a", p.a);
    el.style.setProperty("--b", p.b);
    el.style.setProperty("--ink", p.ink);
    layer.appendChild(el);
    return el;
  }

  function fly(el, dx, dy, ms, scale = 1, rot = 0) {
    el.style.setProperty("--dx", dx + "px");
    el.style.setProperty("--dy", dy + "px");
    el.style.setProperty("--sc", scale);
    el.style.setProperty("--rot", rot + "deg");
    el.style.animation = "wildBasicFly " + ms + "ms cubic-bezier(.16,.82,.28,1) forwards";
    removeAfter(el, ms);
  }

  function defaultDot(effect, layer, x, y) {
    const el = addPiece(layer, "wild-default-dot", x, y, effect);
    fly(el, rand(-5, 5), rand(-5, 5), 460, 1.35, 0);
  }

  function defaultRing(effect, layer, x, y) {
    const el = addPiece(layer, "wild-default-ring", x, y, effect);
    el.style.animation = "wildBasicRing 720ms ease-out forwards";
    removeAfter(el, 720);
  }

  function defaultCrosshair(effect, layer, x, y) {
    const el = addPiece(layer, "wild-default-crosshair", x, y, effect);
    fly(el, 0, 0, 560, 1, 0);
  }

  function cornerBracket(effect, layer, x, y) {
    const el = addPiece(layer, "wild-corner-bracket", x, y, effect);
    fly(el, 0, 0, 660, 1.1, 0);
  }

  function clickFlash(effect, layer, x, y) {
    for (let i = 0; i < 5; i += 1) {
      const el = addPiece(layer, "wild-click-flash", x + rand(-3, 3), y + rand(-3, 3), effect);
      fly(el, rand(-34, 34), rand(-34, 34), 620 + i * 30, 1.2, rand(-140, 140));
    }
  }

  function configFor(effect) {
    switch (effect.key) {
      case "spider-crawler":
        return { count: 9, headEase: .32, bodyEase: .28, type: "spider", hueStart: 260, hueStep: 5 };
      case "cockroach-skitter":
        return { count: 12, headEase: .36, bodyEase: .30, type: "cockroach", hueStart: 28, hueStep: 3 };
      case "crocodile-crawl":
        return { count: 20, headEase: .30, bodyEase: .26, type: "crocodile", hueStart: 116, hueStep: 2 };
      case "mini-dragon":
        return { count: 20, headEase: .34, bodyEase: .29, type: "dragon", hueStart: 18, hueStep: 9 };
      case "scorpion-tail":
        return { count: 17, headEase: .31, bodyEase: .27, type: "scorpion", hueStart: 34, hueStep: 4 };
      case "gecko-dash":
        return { count: 12, headEase: .38, bodyEase: .32, type: "gecko", hueStart: 145, hueStep: 5 };
      case "bat-flutter":
        return { count: 8, headEase: .36, bodyEase: .30, type: "bat", hueStart: 245, hueStep: 7 };
      case "crab-walk":
        return { count: 10, headEase: .33, bodyEase: .29, type: "crab", hueStart: 8, hueStep: 4 };
      default:
        return { count: 12, headEase: .32, bodyEase: .28, type: "animal", hueStart: 145, hueStep: 7 };
    }
  }

  function clearWild(layer) {
    const store = stores.get(layer);
    if (!store) return;
    store.dead = true;
    store.parts.forEach((part) => part.el.remove());
    stores.delete(layer);
  }

  function makeAnimalPart(layer, effect, cfg, index) {
    const p = palette(effect);
    const el = document.createElement("span");
    el.className =
      index === 0
        ? `wild-animal-fx wild-head wild-${cfg.type}`
        : `wild-animal-fx wild-body wild-${cfg.type}`;

    el.setAttribute("aria-hidden", "true");
    el.style.opacity = "0";
    el.style.left = "0px";
    el.style.top = "0px";
    el.style.position = "absolute";
    el.style.setProperty("--a", p.a);
    el.style.setProperty("--b", p.b);
    el.style.setProperty("--ink", p.ink);
    el.style.setProperty("--i", index);
    el.style.setProperty("--hue", cfg.hueStart + index * cfg.hueStep);
    el.style.zIndex = index === 0 ? "100060" : String(100030 - index);
    layer.appendChild(el);

    return { el, x: 0, y: 0 };
  }

  function createStore(layer, effect, x, y) {
    clearWild(layer);

    const cfg = configFor(effect);
    const parts = [];

    for (let i = 0; i < cfg.count; i += 1) {
      const part = makeAnimalPart(layer, effect, cfg, i);
      part.x = x;
      part.y = y;
      part.el.style.opacity = "1";
      parts.push(part);
    }

    const store = {
      key: effect.key,
      cfg,
      parts,
      targetX: x,
      targetY: y,
      active: true,
      dead: false
    };

    stores.set(layer, store);
    requestAnimationFrame(() => animateAnimal(layer, store));
    return store;
  }

  /*
    Same physics style as your snake:
    - head follows pointer
    - each body part follows previous body part
    - head layer stays on top
    - different animal classes make each one look different
  */
  function animateAnimal(layer, store) {
    if (store.dead || stores.get(layer) !== store) return;

    const parts = store.parts;
    const cfg = store.cfg;

    if (store.active) {
      parts[0].x += (store.targetX - parts[0].x) * cfg.headEase;
      parts[0].y += (store.targetY - parts[0].y) * cfg.headEase;

      for (let i = 1; i < parts.length; i += 1) {
        parts[i].x += (parts[i - 1].x - parts[i].x) * cfg.bodyEase;
        parts[i].y += (parts[i - 1].y - parts[i].y) * cfg.bodyEase;
      }

      parts.forEach((part, index) => {
        const next = parts[index - 1] || { x: store.targetX, y: store.targetY };
        const dx = next.x - part.x;
        const dy = next.y - part.y;
        const angle = Math.atan2(dy, dx) * (180 / Math.PI);

        part.el.style.transform = `translate3d(${part.x}px, ${part.y}px, 0) translate(-50%, -50%) rotate(${angle}deg)`;
        part.el.style.opacity = "1";
      });
    }

    requestAnimationFrame(() => animateAnimal(layer, store));
  }

  function spawnWild(effect, layer, x, y) {
    let store = stores.get(layer);
    if (!store || store.key !== effect.key) {
      store = createStore(layer, effect, x, y);
    }

    store.targetX = x;
    store.targetY = y;
    store.active = true;

    const p = palette(effect);
    store.parts.forEach((part, index) => {
      part.el.style.setProperty("--a", p.a);
      part.el.style.setProperty("--b", p.b);
      part.el.style.setProperty("--ink", p.ink);
      part.el.style.opacity = "1";
      part.el.style.zIndex = index === 0 ? "100060" : String(100030 - index);
    });
  }

  COLD_FX.spawn = function (effect, layer, x, y) {
    if (effect && wildHandlers.has(effect.key)) {
      spawnWild(effect, layer, x, y);
      return;
    }

    if (effect && classicHandlers[effect.key]) {
      classicHandlers[effect.key](effect, layer, x, y);
      return;
    }

    originalSpawn(effect, layer, x, y);
  };

  COLD_FX.clear = function (layer) {
    clearWild(layer);

    if (originalClear) originalClear(layer);
    else layer.innerHTML = "";
  };
})();