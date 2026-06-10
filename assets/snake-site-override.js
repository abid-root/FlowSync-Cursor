(function () {
  if (typeof COLD_FX === "undefined") return;

  const originalSpawn = COLD_FX.spawn.bind(COLD_FX);
  const originalClear = COLD_FX.clear ? COLD_FX.clear.bind(COLD_FX) : null;
  const stores = new WeakMap();

  const snakeKeys = new Set([
    "spine-serpent",
    "good-snake-follower",
    "neon-centipede",
    "jelly-larva",
    "fish-chain"
  ]);

  function getPalette(effect) {
    const theme = document.documentElement.getAttribute("data-theme") === "light" ? "light" : "dark";
    return effect[theme] || effect.dark || { a: "#f7eed3", b: "#b9ff34", ink: "#111111" };
  }

  function removeStore(layer) {
    const store = stores.get(layer);
    if (!store) return;

    store.dead = true;
    store.parts.forEach((part) => part.el.remove());
    stores.delete(layer);
  }

  function makePart(layer, effect, index, total) {
    const palette = getPalette(effect);
    const el = document.createElement("span");

    el.className = [
      "site-snake-fx",
      index === 0 ? "site-snake-head" : "site-snake-body",
      effect.key ? "site-snake-" + effect.key : ""
    ].join(" ");

    el.setAttribute("aria-hidden", "true");
    el.style.setProperty("--a", palette.a);
    el.style.setProperty("--b", palette.b);
    el.style.setProperty("--ink", palette.ink);
    el.style.setProperty("--snake-i", index);
    el.style.zIndex = String(1000 - index);

    const bodyW = Math.max(8, 20 - index * 0.18);
    const bodyH = Math.max(6, 10 - index * 0.04);
    el.style.setProperty("--snake-w", index === 0 ? "30px" : bodyW + "px");
    el.style.setProperty("--snake-h", index === 0 ? "18px" : bodyH + "px");

    layer.appendChild(el);

    return {
      el,
      x: 0,
      y: 0,
      angle: 0
    };
  }

  function createStore(layer, effect, x, y) {
    removeStore(layer);

    const count =
      effect.key === "spine-serpent" ? 26 :
      effect.key === "good-snake-follower" ? 24 :
      effect.key === "neon-centipede" ? 22 :
      effect.key === "jelly-larva" ? 18 :
      16;

    const spacing =
      effect.key === "spine-serpent" ? 12 :
      effect.key === "good-snake-follower" ? 11 :
      effect.key === "jelly-larva" ? 15 :
      effect.key === "fish-chain" ? 13 :
      11;

    const parts = [];

    for (let i = 0; i < count; i += 1) {
      const part = makePart(layer, effect, i, count);
      part.x = x - i * spacing;
      part.y = y;
      parts.push(part);
    }

    const store = {
      key: effect.key,
      effect,
      parts,
      targetX: x,
      targetY: y,
      spacing,
      dead: false,
      lastMove: performance.now(),
      lastAngle: 0
    };

    stores.set(layer, store);
    requestAnimationFrame(() => animateStore(layer, store));

    return store;
  }

  /*
     ABOUT / SECOND SECTION
     Good snake follower

     This uses the same idea from your main site:
     - one head follows the cursor
     - every body segment follows the segment before it
     - here it is adapted for preview-zone coordinates
     - fixed spacing is added so it does not collapse into one blob
  */
  function animateStore(layer, store) {
    if (store.dead || stores.get(layer) !== store) return;

    const parts = store.parts;
    const now = performance.now();

    const head = parts[0];

    const dxHead = store.targetX - head.x;
    const dyHead = store.targetY - head.y;

    /*
      Keep the head close to the real pointer.
      This is the main fix for the "cursor is here but snake is far away" problem.
    */
    head.x += dxHead * 0.72;
    head.y += dyHead * 0.72;

    if (Math.abs(dxHead) + Math.abs(dyHead) > 0.08) {
      store.lastAngle = Math.atan2(dyHead, dxHead);
    }

    head.angle = store.lastAngle;

    for (let i = 1; i < parts.length; i += 1) {
      const prev = parts[i - 1];
      const part = parts[i];

      let dx = part.x - prev.x;
      let dy = part.y - prev.y;
      let dist = Math.hypot(dx, dy);

      if (!Number.isFinite(dist) || dist < 0.001) {
        dx = -Math.cos(prev.angle || store.lastAngle);
        dy = -Math.sin(prev.angle || store.lastAngle);
        dist = 1;
      }

      const nx = dx / dist;
      const ny = dy / dist;

      /*
        Fixed distance target. This keeps every bone/part separated.
      */
      let targetX = prev.x + nx * store.spacing;
      let targetY = prev.y + ny * store.spacing;

      /*
        Soft curve. Not too much, so it looks flexible but not broken.
      */
      const moving = Math.min(1, Math.hypot(store.targetX - head.x, store.targetY - head.y) / 90);
      const wave = Math.sin(now / 135 + i * 0.62) * moving * 1.8;
      targetX += -ny * wave;
      targetY += nx * wave;

      const follow = i < 5 ? 0.62 : 0.48;
      part.x += (targetX - part.x) * follow;
      part.y += (targetY - part.y) * follow;

      part.angle = Math.atan2(prev.y - part.y, prev.x - part.x);
    }

    for (let i = 0; i < parts.length; i += 1) {
      const part = parts[i];

      /*
        Important:
        Use left/top directly in layer coordinates.
        Do NOT use translate(x,y) from a non-zero left/top.
        This avoids the doubled-position bug that pushed your snake far away.
      */
      part.el.style.left = part.x + "px";
      part.el.style.top = part.y + "px";
      part.el.style.transform = "translate(-50%, -50%) rotate(" + (part.angle * 180 / Math.PI) + "deg)";
    }

    requestAnimationFrame(() => animateStore(layer, store));
  }

  function siteSnakeSpawn(effect, layer, x, y) {
    let store = stores.get(layer);

    if (!store || store.key !== effect.key) {
      store = createStore(layer, effect, x, y);
    }

    store.targetX = x;
    store.targetY = y;
    store.lastMove = performance.now();

    const palette = getPalette(effect);
    store.parts.forEach((part) => {
      part.el.style.setProperty("--a", palette.a);
      part.el.style.setProperty("--b", palette.b);
      part.el.style.setProperty("--ink", palette.ink);
      part.el.style.opacity = "1";
    });
  }

  COLD_FX.spawn = function (effect, layer, x, y) {
    if (effect && snakeKeys.has(effect.key)) {
      siteSnakeSpawn(effect, layer, x, y);
      return;
    }

    originalSpawn(effect, layer, x, y);
  };

  COLD_FX.clear = function (layer) {
    removeStore(layer);

    if (originalClear) {
      originalClear(layer);
    } else {
      layer.innerHTML = "";
    }
  };
})();