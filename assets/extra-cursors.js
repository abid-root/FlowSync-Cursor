(function () {
  if (typeof COLD_FX === "undefined") return;

  const originalSpawn = COLD_FX.spawn.bind(COLD_FX);
  const originalClear = COLD_FX.clear ? COLD_FX.clear.bind(COLD_FX) : null;

  const handlers = {
    "simple-dot": simpleDot,
    "clean-ring": cleanRing,
    "soft-shadow": softShadow,
    "cursor-cross": cursorCross,
    "arrow-pointer": arrowPointer,
    "cat-paw": catPaw,
    "butterfly-pair": butterflyPair,
    "bird-flock": birdFlock,
    "rabbit-hop": rabbitHop,
    "dragonfly-dash": dragonflyDash,
    "paper-plane": paperPlane,
    "rocket-spark": rocketSpark,
    "magic-wand": magicWand,
    "bouncing-ball": bouncingBall,
    "mini-planet": miniPlanet
  };

  function rand(a, b) { return a + Math.random() * (b - a); }
  function pick(list) { return list[Math.floor(Math.random() * list.length)]; }
  function palette(effect) {
    const theme = document.documentElement.getAttribute("data-theme") === "light" ? "light" : "dark";
    return effect[theme] || effect.dark || { a: "#b9ff57", b: "#fff", ink: "#111" };
  }
  function add(layer, cls, x, y, effect, text = "") {
    const p = palette(effect);
    const n = document.createElement("span");
    n.className = "fx-piece extra-fx " + cls;
    n.textContent = text;
    n.style.left = x + "px";
    n.style.top = y + "px";
    n.style.setProperty("--a", p.a);
    n.style.setProperty("--b", p.b);
    n.style.setProperty("--ink", p.ink);
    layer.appendChild(n);
    return n;
  }
  function css(n, obj) { Object.entries(obj).forEach(([k, v]) => n.style.setProperty(k, v)); }
  function remove(n, ms) { setTimeout(() => n.remove(), ms + 80); }
  function fly(n, dx, dy, ms = 900, rot = 0, scale = 1) {
    css(n, { "--dx": dx + "px", "--dy": dy + "px", "--rot": rot + "deg", "--sc": scale });
    n.style.animation = "extraFly " + ms + "ms cubic-bezier(.16,.82,.28,1) forwards";
    remove(n, ms);
  }

  function simpleDot(e, l, x, y) {
    const n = add(l, "extra-dot", x, y, e);
    css(n, { "--s": rand(10, 15) + "px" });
    fly(n, rand(-8, 8), rand(-8, 8), 520, 0, 1.4);
  }
  function cleanRing(e, l, x, y) {
    const n = add(l, "extra-ring", x, y, e);
    css(n, { "--s": rand(48, 70) + "px" });
    n.style.animation = "extraRing 760ms ease-out forwards";
    remove(n, 760);
  }
  function softShadow(e, l, x, y) {
    const n = add(l, "extra-shadow", x, y, e);
    css(n, { "--s": rand(42, 78) + "px" });
    fly(n, rand(-18, 18), rand(-18, 18), 800, 0, 1.6);
  }
  function cursorCross(e, l, x, y) {
    const a = add(l, "extra-cross-x", x, y, e);
    const b = add(l, "extra-cross-y", x, y, e);
    fly(a, 0, 0, 520, 0, 1.1);
    fly(b, 0, 0, 520, 0, 1.1);
  }
  function arrowPointer(e, l, x, y) {
    const n = add(l, "extra-arrow", x, y, e);
    fly(n, rand(24, 56), rand(-34, 28), 760, rand(-25, 25), 1);
  }

  function catPaw(e, l, x, y) {
    const paw = add(l, "extra-paw", x + rand(-8, 8), y + rand(-8, 8), e);
    fly(paw, rand(-24, 24), rand(-22, 26), 900, rand(-18, 18), 1);
  }
  function butterflyPair(e, l, x, y) {
    for (let i = 0; i < 2; i++) {
      const n = add(l, "extra-butterfly", x + rand(-10, 10), y + rand(-10, 10), e);
      fly(n, (i ? 1 : -1) * rand(34, 68), rand(-60, -22), 960 + i * 80, (i ? 1 : -1) * rand(12, 34), 1.05);
    }
  }
  function birdFlock(e, l, x, y) {
    for (let i = 0; i < 5; i++) {
      const n = add(l, "extra-bird", x + i * 10 - 20, y + Math.abs(i - 2) * 8, e);
      fly(n, rand(-42, 42), rand(-70, -28), 900 + i * 50, rand(-10, 10), 1);
    }
  }
  function rabbitHop(e, l, x, y) {
    for (let i = 0; i < 2; i++) {
      const n = add(l, "extra-rabbit", x + (i ? 8 : -8), y + i * 10, e);
      fly(n, rand(-16, 16), rand(-44, -18), 760 + i * 70, rand(-10, 10), 1);
    }
  }
  function dragonflyDash(e, l, x, y) {
    const n = add(l, "extra-dragonfly", x, y, e);
    fly(n, rand(62, 112), rand(-42, 36), 720, rand(-18, 18), 1);
  }

  function paperPlane(e, l, x, y) {
    const n = add(l, "extra-plane", x, y, e);
    fly(n, rand(74, 128), rand(-56, 24), 900, rand(-16, 16), 1);
  }
  function rocketSpark(e, l, x, y) {
    const r = add(l, "extra-rocket", x, y, e);
    fly(r, rand(58, 108), rand(-74, -26), 780, rand(-32, -8), 1);
    for (let i = 0; i < 4; i++) {
      const s = add(l, "extra-mini-spark", x, y, e);
      fly(s, rand(-34, 10), rand(12, 46), 620, rand(-120, 120), 1.2);
    }
  }
  function magicWand(e, l, x, y) {
    const w = add(l, "extra-wand", x, y, e);
    fly(w, rand(20, 42), rand(-28, 16), 680, rand(-30, 30), 1);
    for (let i = 0; i < 6; i++) {
      const s = add(l, "extra-star", x + rand(-4, 4), y + rand(-4, 4), e, pick(["*", "+", "✦"]));
      fly(s, rand(-56, 56), rand(-56, 36), 820 + i * 30, rand(-160, 160), 1.2);
    }
  }
  function bouncingBall(e, l, x, y) {
    const n = add(l, "extra-ball", x, y, e);
    css(n, { "--s": rand(18, 26) + "px" });
    n.style.animation = "extraBounce 900ms cubic-bezier(.16,.82,.28,1) forwards";
    css(n, { "--dx": rand(-34, 34) + "px", "--dy": rand(38, 74) + "px" });
    remove(n, 900);
  }
  function miniPlanet(e, l, x, y) {
    const n = add(l, "extra-planet", x, y, e);
    fly(n, rand(-38, 38), rand(-48, 24), 980, rand(-30, 30), 1);
    const ring = add(l, "extra-ring", x, y, e);
    css(ring, { "--s": "58px" });
    ring.style.animation = "extraRing 820ms ease-out forwards";
    remove(ring, 820);
  }

  COLD_FX.spawn = function (effect, layer, x, y) {
    if (effect && handlers[effect.key]) {
      handlers[effect.key](effect, layer, x, y);
      return;
    }
    originalSpawn(effect, layer, x, y);
  };

  COLD_FX.clear = function (layer) {
    if (originalClear) originalClear(layer);
    else layer.innerHTML = "";
  };
})();
