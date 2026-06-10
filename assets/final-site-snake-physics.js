(function () {
  if (typeof COLD_FX === "undefined") return;

  const originalSpawn = COLD_FX.spawn.bind(COLD_FX);
  const originalClear = COLD_FX.clear ? COLD_FX.clear.bind(COLD_FX) : null;

  const stores = new WeakMap();

  const snakeKeys = new Set([
    "spine-serpent",
    "good-snake-follower",
    "bone-spine",
    "neon-centipede",
    "cyber-worm",
    "jelly-larva",
    "jelly-tail",
    "fish-chain",
    "chain-fish",
    "soft-larva"
  ]);

  function isSnake(effect) {
    if (!effect) return false;
    return snakeKeys.has(effect.key) || ["snake", "centipede", "jelly", "fish"].includes(effect.kind);
  }

  function snakeConfig(effect) {
    switch (effect.key) {
      case "spine-serpent":
      case "bone-spine":
      case "good-snake-follower":
        return {
          count: 24,
          headEase: 0.32,
          bodyEase: 0.28,
          type: "bone",
          headClass: "about-good-snake-head",
          baseZ: 100030
        };

      case "neon-centipede":
      case "cyber-worm":
        return {
          count: 22,
          headEase: 0.32,
          bodyEase: 0.28,
          type: "color",
          headClass: "snake-head",
          baseZ: 100030
        };

      case "jelly-larva":
      case "jelly-tail":
      case "soft-larva":
        return {
          count: 20,
          headEase: 0.32,
          bodyEase: 0.28,
          type: "jelly",
          headClass: "snake-head",
          baseZ: 100030
        };

      case "fish-chain":
      case "chain-fish":
        return {
          count: 18,
          headEase: 0.32,
          bodyEase: 0.28,
          type: "fish",
          headClass: "snake-head",
          baseZ: 100030
        };

      default:
        return {
          count: 22,
          headEase: 0.32,
          bodyEase: 0.28,
          type: "color",
          headClass: "snake-head",
          baseZ: 100030
        };
    }
  }

  function removeStore(layer) {
    const store = stores.get(layer);
    if (!store) return;

    store.dead = true;
    store.snake.forEach((part) => part.el.remove());
    stores.delete(layer);
  }

  function makePart(layer, config, index) {
    const part = document.createElement("span");

    if (config.type === "bone") {
      part.className =
        index === 0
          ? "about-good-snake-fx about-good-snake-head library-site-snake"
          : "about-good-snake-fx library-site-snake";
    } else {
      part.className =
        index === 0
          ? `service-real-snake-fx snake-head library-site-snake library-site-snake-${config.type}`
          : `service-real-snake-fx library-site-snake library-site-snake-${config.type}`;
    }

    part.setAttribute("aria-hidden", "true");
    part.style.opacity = "0";

    part.style.left = "0px";
    part.style.top = "0px";
    part.style.position = "absolute";

    part.style.setProperty("--snake-i", index);
    part.style.setProperty("--snake-index", index);
    part.style.setProperty("--snake-hue", 145 + index * 7);

    /*
      Head must always stay on top.
      This is exactly what you asked: head layer higher than body.
    */
    part.style.zIndex = index === 0 ? "100060" : String(config.baseZ - index);

    layer.appendChild(part);

    return {
      el: part,
      x: 0,
      y: 0
    };
  }

  function createStore(layer, effect, x, y) {
    removeStore(layer);

    const config = snakeConfig(effect);
    const snake = [];

    for (let i = 0; i < config.count; i += 1) {
      const part = makePart(layer, config, i);
      part.x = x;
      part.y = y;
      part.el.style.opacity = "1";
      snake.push(part);
    }

    const store = {
      key: effect.key,
      config,
      snake,
      snakeX: x,
      snakeY: y,
      snakeActive: true,
      snakeStarted: true,
      dead: false
    };

    stores.set(layer, store);
    requestAnimationFrame(() => animateSnake(layer, store));

    return store;
  }

  /*
    ABOUT / SECOND SECTION
    Good snake follower

    This is your exact physics:
    - head ease: 0.32
    - body ease: 0.28
    - each part follows the previous part
    - transform uses translate3d(x, y, 0) like your site
    - adapted for the preview layer, so left/top stays 0 and coordinates are local
  */
  function animateSnake(layer, store) {
    if (store.dead || stores.get(layer) !== store) return;

    const snake = store.snake;
    const config = store.config;

    if (store.snakeActive) {
      snake[0].x += (store.snakeX - snake[0].x) * config.headEase;
      snake[0].y += (store.snakeY - snake[0].y) * config.headEase;

      for (let i = 1; i < snake.length; i += 1) {
        snake[i].x += (snake[i - 1].x - snake[i].x) * config.bodyEase;
        snake[i].y += (snake[i - 1].y - snake[i].y) * config.bodyEase;
      }

      snake.forEach((part, index) => {
        const next = snake[index - 1] || {
          x: store.snakeX,
          y: store.snakeY
        };

        const dx = next.x - part.x;
        const dy = next.y - part.y;
        const angle = Math.atan2(dy, dx) * (180 / Math.PI);

        part.el.style.transform = `translate3d(${part.x}px, ${part.y}px, 0) translate(-50%, -50%) rotate(${angle}deg)`;
        part.el.style.opacity = "1";
      });
    }

    requestAnimationFrame(() => animateSnake(layer, store));
  }

  function spawnSnake(effect, layer, x, y) {
    let store = stores.get(layer);

    if (!store || store.key !== effect.key) {
      store = createStore(layer, effect, x, y);
    }

    store.snakeX = x;
    store.snakeY = y;

    if (!store.snakeStarted) {
      store.snake.forEach((part) => {
        part.x = x;
        part.y = y;
        part.el.style.opacity = "1";
      });
      store.snakeStarted = true;
    }

    store.snakeActive = true;
  }

  COLD_FX.spawn = function (effect, layer, x, y) {
    if (isSnake(effect)) {
      spawnSnake(effect, layer, x, y);
      return;
    }

    originalSpawn(effect, layer, x, y);
  };

  COLD_FX.clear = function (layer) {
    const store = stores.get(layer);

    if (store) {
      store.snakeActive = false;
      store.snakeStarted = false;

      store.snake.forEach((part) => {
        part.el.style.opacity = "0";
      });

      setTimeout(() => removeStore(layer), 160);
      return;
    }

    if (originalClear) {
      originalClear(layer);
    } else {
      layer.innerHTML = "";
    }
  };
})();