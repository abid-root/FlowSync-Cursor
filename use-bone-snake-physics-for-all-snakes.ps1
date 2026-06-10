$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\fx.js") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-final-snake-physics-backup_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($path) {
  return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($path, $text) {
  [System.IO.File]::WriteAllText($path, $text, $script:utf8NoBom)
}

Write-Host "1) Removing older snake override files/links..."

$oldSnakeScripts = @(
  "snake-site-override.js",
  "real-snake-physics.js",
  "final-site-snake-physics.js"
)

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  foreach ($file in $oldSnakeScripts) {
    $escaped = [regex]::Escape($file)
    $html = [regex]::Replace($html, "(?im)^\s*<script[^>]+$escaped[^>]*></script>\s*", "")
  }

  Save-Utf8 $_.FullName $html
}

foreach ($file in $oldSnakeScripts) {
  Remove-Item ".\assets\$file" -Force -ErrorAction SilentlyContinue
}

Write-Host "2) Creating final snake physics using your exact ABOUT/SECOND SECTION logic..."

$snakeJs = @'
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
'@

Save-Utf8 ".\assets\final-site-snake-physics.js" $snakeJs

Write-Host "3) Loading final snake file after fx.js..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  $relativeDir = $_.DirectoryName.Substring($root.Length).TrimStart('\')
  $depth = if ([string]::IsNullOrWhiteSpace($relativeDir)) { 0 } else { ($relativeDir -split '[\\/]').Count }
  $src = (('../' * $depth) + "assets/final-site-snake-physics.js?v=$stamp").Replace('\','/')
  $tag = "  <script src=""$src""></script>"

  if ($html -match 'assets/fx\.js') {
    $html = [regex]::Replace(
      $html,
      '(?im)(^\s*<script[^>]+assets/fx\.js[^>]*></script>\s*)',
      "`$1$tag`r`n",
      1
    )
  } else {
    $html = $html -replace '(?i)</body>', "$tag`r`n</body>"
  }

  Save-Utf8 $_.FullName $html
}

Write-Host "4) Removing pointer throttle for snake effects..."

$appPath = ".\assets\app.js"
$app = Read-Utf8 $appPath

$app = [regex]::Replace(
  $app,
  'const gap\s*=\s*effect\.kind\s*===\s*"snake"\s*\|\|\s*effect\.kind\s*===\s*"centipede"\s*\|\|\s*effect\.kind\s*===\s*"jelly"\s*\|\|\s*effect\.kind\s*===\s*"fish"\s*\?\s*\d+\s*:\s*\d+;',
  'const gap = effect.kind === "snake" || effect.kind === "centipede" || effect.kind === "jelly" || effect.kind === "fish" ? 0 : 72;'
)

$app = [regex]::Replace(
  $app,
  'const gap\s*=\s*\["snake",\s*"centipede",\s*"jelly",\s*"fish"\]\.includes\(effect\.kind\)\s*\?\s*\d+\s*:\s*\d+;',
  'const gap = ["snake", "centipede", "jelly", "fish"].includes(effect.kind) ? 0 : 72;'
)

Save-Utf8 $appPath $app

Write-Host "5) Adding your bone snake CSS + different styles for other snakes..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath

$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== FINAL SITE SNAKE CSS START ===== \*/.*?/\* ===== FINAL SITE SNAKE CSS END ===== \*/', '')

$css = @'

/* ===== FINAL SITE SNAKE CSS START ===== */

/* shared */
.library-site-snake {
  pointer-events: none !important;
  transform-origin: 50% 50% !important;
  transition: opacity 120ms ease !important;
  will-change: transform, opacity !important;
  backface-visibility: hidden !important;
  contain: layout paint !important;
}

/* =========================================================
   ABOUT / SECOND SECTION
   Bone snake follower
========================================================= */
.about-good-snake-fx {
  --bone: rgba(255, 244, 223, 0.96);
  --bone-soft: rgba(255, 235, 198, 0.82);
  --bone-edge: rgba(123, 96, 62, 0.46);
  --bone-cut: rgba(30, 24, 20, 0.28);
  --bone-eye: #17131f;

  position: absolute !important;
  left: 0;
  top: 0;
  width: calc(24px - (var(--snake-i) * 0.52px)) !important;
  height: calc(15px - (var(--snake-i) * 0.23px)) !important;
  min-width: 8px !important;
  min-height: 5px !important;
  border-radius: 999px !important;

  background:
    radial-gradient(
      circle at 50% 50%,
      var(--bone) 0 2.8px,
      var(--bone-edge) 3px 3.6px,
      transparent 3.8px
    ),
    linear-gradient(
      90deg,
      transparent 0 37%,
      var(--bone) 38% 62%,
      transparent 63%
    ),
    radial-gradient(
      ellipse at 28% 50%,
      var(--bone-soft) 0 2.1px,
      transparent 2.4px
    ),
    radial-gradient(
      ellipse at 72% 50%,
      var(--bone-soft) 0 2.1px,
      transparent 2.4px
    ) !important;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.22) !important;
}

.about-good-snake-fx::before,
.about-good-snake-fx::after {
  content: "" !important;
  position: absolute !important;
  left: 50% !important;
  width: calc(17px - (var(--snake-i) * 0.28px)) !important;
  height: calc(9px - (var(--snake-i) * 0.12px)) !important;
  min-width: 5px !important;
  min-height: 3px !important;
  border-radius: 999px !important;
  opacity: calc(0.9 - (var(--snake-i) * 0.018)) !important;
}

.about-good-snake-fx::before {
  top: 47% !important;
  border-top: 1.4px solid var(--bone) !important;
  border-left: 1px solid transparent !important;
  transform: translate(-50%, -85%) rotate(-15deg) !important;
}

.about-good-snake-fx::after {
  top: 53% !important;
  border-bottom: 1.4px solid var(--bone) !important;
  border-left: 1px solid transparent !important;
  transform: translate(-50%, -15%) rotate(15deg) !important;
}

/* skull head */
.about-good-snake-fx.about-good-snake-head {
  z-index: 100060 !important;
  width: 31px !important;
  height: 18px !important;
  min-width: 31px !important;
  min-height: 18px !important;
  border-radius: 68% 42% 46% 62% / 58% 48% 52% 56% !important;
  border: 1px solid var(--bone-edge) !important;
  background:
    radial-gradient(
      circle at 68% 34%,
      var(--bone-eye) 0 2px,
      transparent 2.2px
    ),
    radial-gradient(
      circle at 68% 66%,
      var(--bone-eye) 0 2px,
      transparent 2.2px
    ),
    radial-gradient(
      ellipse at 82% 50%,
      var(--bone-cut) 0 2.5px,
      transparent 2.8px
    ),
    radial-gradient(
      ellipse at 38% 50%,
      rgba(255, 255, 255, 0.18) 0 6px,
      transparent 6.5px
    ),
    linear-gradient(90deg, var(--bone), var(--bone-soft)) !important;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.24) !important;
}

.about-good-snake-fx.about-good-snake-head::before {
  content: "" !important;
  position: absolute !important;
  right: 2px !important;
  top: 50% !important;
  left: auto !important;
  width: 12px !important;
  height: 1.4px !important;
  min-width: 0 !important;
  min-height: 0 !important;
  border: 0 !important;
  border-radius: 999px !important;
  background: var(--bone-cut) !important;
  transform: translateY(-50%) !important;
  opacity: 0.9 !important;
}

.about-good-snake-fx.about-good-snake-head::after {
  content: "" !important;
  position: absolute !important;
  right: -1px !important;
  top: 52% !important;
  left: auto !important;
  width: 8px !important;
  height: 6px !important;
  min-width: 0 !important;
  min-height: 0 !important;
  border: 0 !important;
  border-radius: 0 999px 999px 0 !important;
  background: repeating-linear-gradient(
    90deg,
    var(--bone) 0 1px,
    transparent 1px 3px
  ) !important;
  transform: translateY(-50%) !important;
  opacity: 0.82 !important;
}

/* light theme bone */
:root:not([data-theme="dark"]) .about-good-snake-fx {
  --bone: rgba(24, 22, 20, 0.92);
  --bone-soft: rgba(38, 34, 29, 0.74);
  --bone-edge: rgba(250, 248, 241, 0.28);
  --bone-cut: rgba(250, 248, 241, 0.32);
  --bone-eye: #faf8f1;

  box-shadow: 0 1px 2px rgba(24, 22, 20, 0.14) !important;
}

/* colorful / neon / jelly / fish share the same physics but different looks */
.service-real-snake-fx {
  position: absolute !important;
  left: 0;
  top: 0;
  width: calc(24px - (var(--snake-index) * 0.55px)) !important;
  height: calc(13px - (var(--snake-index) * 0.23px)) !important;
  min-width: 8px !important;
  min-height: 5px !important;
  border-radius: 999px !important;
  background:
    linear-gradient(
      90deg,
      hsl(var(--snake-hue), 92%, 58%),
      hsl(calc(var(--snake-hue) + 45), 96%, 66%)
    ) !important;
  box-shadow:
    0 0 6px hsla(var(--snake-hue), 95%, 64%, 0.52),
    0 0 16px hsla(calc(var(--snake-hue) + 45), 95%, 66%, 0.22) !important;
}

.service-real-snake-fx::after {
  content: "" !important;
  position: absolute !important;
  inset: 23% !important;
  border-radius: inherit !important;
  background: rgba(255, 255, 255, 0.35) !important;
}

.service-real-snake-fx.snake-head {
  z-index: 100060 !important;
  width: 32px !important;
  height: 17px !important;
  background:
    linear-gradient(
      90deg,
      #5cf28b,
      #54d7ff,
      #c89cff
    ) !important;
  box-shadow:
    0 0 8px rgba(92, 242, 139, 0.5),
    0 0 18px rgba(84, 215, 255, 0.3) !important;
}

.service-real-snake-fx.snake-head::before {
  content: "" !important;
  position: absolute !important;
  right: 7px !important;
  top: 4px !important;
  width: 4px !important;
  height: 4px !important;
  border-radius: 999px !important;
  background: #101014 !important;
  box-shadow: 0 8px 0 #101014 !important;
}

.service-real-snake-fx.snake-head::after {
  inset: 25% !important;
}

.library-site-snake-neon:not(.snake-head) {
  border-radius: 8px 999px 999px 8px !important;
  filter: saturate(1.25) !important;
}

.library-site-snake-jelly {
  opacity: .88 !important;
  filter: blur(.35px) saturate(1.2) !important;
  background:
    radial-gradient(circle at 38% 34%, rgba(255,255,255,.62), transparent 0 18%),
    linear-gradient(90deg, rgba(120,220,255,.62), rgba(210,170,255,.55)) !important;
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,.44),
    0 0 14px rgba(130,220,255,.22) !important;
}

.library-site-snake-fish:not(.snake-head) {
  width: calc(18px - (var(--snake-index) * 0.28px)) !important;
  height: calc(11px - (var(--snake-index) * 0.12px)) !important;
  clip-path: polygon(0 50%, 22% 8%, 100% 50%, 22% 92%) !important;
  border-radius: 0 !important;
}

/* ===== FINAL SITE SNAKE CSS END ===== */
'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $css)

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\final-site-snake-physics.js" | Out-Null
  node --check ".\assets\app.js" | Out-Null
}

Write-Host "DONE: All snake effects now use your ABOUT/SECOND SECTION physics."
Write-Host "DONE: Spine Serpent / Good Snake use your bone skeleton CSS."
Write-Host "DONE: Other snakes use the same physics but different looks: colorful, jelly, fish."
Write-Host "DONE: Head z-index is always highest."
Write-Host "Backup saved here:"
Write-Host $backup
