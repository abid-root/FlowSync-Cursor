$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\fx.js") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-real-service-snake-physics-backup_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($path) {
  return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($path, $text) {
  [System.IO.File]::WriteAllText($path, $text, $script:utf8NoBom)
}

Write-Host "1) Removing previous snake override links..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+snake-site-override\.js[^>]*></script>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+real-snake-physics\.js[^>]*></script>\s*', '')

  Save-Utf8 $_.FullName $html
}

Remove-Item ".\assets\snake-site-override.js" -Force -ErrorAction SilentlyContinue

Write-Host "2) Creating real service-section snake physics..."

$snakeJs = @'
(function () {
  if (typeof COLD_FX === "undefined") return;

  const originalSpawn = COLD_FX.spawn.bind(COLD_FX);
  const originalClear = COLD_FX.clear ? COLD_FX.clear.bind(COLD_FX) : null;

  const snakeStores = new WeakMap();

  function isSnakeEffect(effect) {
    if (!effect) return false;

    return (
      ["snake", "centipede", "jelly", "fish"].includes(effect.kind) ||
      [
        "spine-serpent",
        "good-snake-follower",
        "neon-centipede",
        "jelly-larva",
        "fish-chain",
        "bone-spine",
        "cyber-worm",
        "soft-larva",
        "chain-fish",
        "jelly-tail"
      ].includes(effect.key)
    );
  }

  function getSettings(effect) {
    if (effect.key === "jelly-larva" || effect.key === "jelly-tail") {
      return { count: 18, headEase: 0.34, bodyEase: 0.30, hueStart: 178, hueStep: 5, className: "jelly" };
    }

    if (effect.key === "fish-chain" || effect.key === "chain-fish") {
      return { count: 17, headEase: 0.34, bodyEase: 0.30, hueStart: 190, hueStep: 8, className: "fish" };
    }

    if (effect.key === "neon-centipede" || effect.key === "cyber-worm") {
      return { count: 22, headEase: 0.34, bodyEase: 0.30, hueStart: 145, hueStep: 7, className: "neon" };
    }

    return { count: 22, headEase: 0.34, bodyEase: 0.30, hueStart: 145, hueStep: 7, className: "real" };
  }

  function clearSnake(layer) {
    const store = snakeStores.get(layer);
    if (!store) return;

    store.dead = true;
    store.parts.forEach((part) => part.el.remove());
    snakeStores.delete(layer);
  }

  function makeSnakePart(layer, effect, index, settings) {
    const el = document.createElement("span");

    el.className =
      index === 0
        ? `service-real-snake-fx snake-head service-real-snake-${settings.className}`
        : `service-real-snake-fx service-real-snake-${settings.className}`;

    el.setAttribute("aria-hidden", "true");
    el.style.opacity = "0";
    el.style.setProperty("--snake-index", index);
    el.style.setProperty("--snake-hue", settings.hueStart + index * settings.hueStep);
    el.style.zIndex = String(999 - index);

    layer.appendChild(el);

    return {
      el,
      x: 0,
      y: 0
    };
  }

  function createSnake(layer, effect, x, y) {
    clearSnake(layer);

    const settings = getSettings(effect);
    const parts = [];

    for (let i = 0; i < settings.count; i += 1) {
      const part = makeSnakePart(layer, effect, i, settings);
      part.x = x;
      part.y = y;
      part.el.style.opacity = "1";
      parts.push(part);
    }

    const store = {
      key: effect.key,
      effect,
      settings,
      parts,
      targetX: x,
      targetY: y,
      active: true,
      started: true,
      dead: false
    };

    snakeStores.set(layer, store);
    requestAnimationFrame(() => animateSnake(layer, store));

    return store;
  }

  /*
    SERVICE / THIRD SECTION
    Actual colorful snake follower

    This is the same physics from your site:
    - head follows cursor with 0.34
    - every body part follows previous part with 0.30
    - uses left/top directly
    - adapted from fixed-position site cursor to preview-layer absolute coordinates
  */
  function animateSnake(layer, store) {
    if (store.dead || snakeStores.get(layer) !== store) return;

    const snakeParts = store.parts;
    const settings = store.settings;

    if (store.active) {
      snakeParts[0].x += (store.targetX - snakeParts[0].x) * settings.headEase;
      snakeParts[0].y += (store.targetY - snakeParts[0].y) * settings.headEase;

      for (let i = 1; i < snakeParts.length; i += 1) {
        snakeParts[i].x += (snakeParts[i - 1].x - snakeParts[i].x) * settings.bodyEase;
        snakeParts[i].y += (snakeParts[i - 1].y - snakeParts[i].y) * settings.bodyEase;
      }

      snakeParts.forEach((part, index) => {
        const next = snakeParts[index - 1] || {
          x: store.targetX,
          y: store.targetY
        };

        const dx = next.x - part.x;
        const dy = next.y - part.y;
        const angle = Math.atan2(dy, dx) * (180 / Math.PI);

        part.el.style.left = `${part.x}px`;
        part.el.style.top = `${part.y}px`;
        part.el.style.transform = `translate(-50%, -50%) rotate(${angle}deg)`;
        part.el.style.opacity = "1";
      });
    }

    requestAnimationFrame(() => animateSnake(layer, store));
  }

  function spawnSnake(effect, layer, x, y) {
    let store = snakeStores.get(layer);

    if (!store || store.key !== effect.key) {
      store = createSnake(layer, effect, x, y);
    }

    store.targetX = x;
    store.targetY = y;
    store.active = true;
  }

  COLD_FX.spawn = function (effect, layer, x, y) {
    if (isSnakeEffect(effect)) {
      spawnSnake(effect, layer, x, y);
      return;
    }

    originalSpawn(effect, layer, x, y);
  };

  COLD_FX.clear = function (layer) {
    clearSnake(layer);

    if (originalClear) {
      originalClear(layer);
    } else {
      layer.innerHTML = "";
    }
  };
})();
'@

Save-Utf8 ".\assets\real-snake-physics.js" $snakeJs

Write-Host "3) Loading real-snake-physics.js after fx.js..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  $relativeDir = $_.DirectoryName.Substring($root.Length).TrimStart('\')
  $depth = if ([string]::IsNullOrWhiteSpace($relativeDir)) { 0 } else { ($relativeDir -split '[\\/]').Count }
  $src = (('../' * $depth) + "assets/real-snake-physics.js?v=$stamp").Replace('\','/')
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

Write-Host "4) Making snake pointer updates fast..."

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

Write-Host "5) Adding exact colorful snake CSS..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath

$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== REAL COLORFUL SERVICE SNAKE START ===== \*/.*?/\* ===== REAL COLORFUL SERVICE SNAKE END ===== \*/', '')

$style += @'

/* ===== REAL COLORFUL SERVICE SNAKE START ===== */
.service-real-snake-fx {
  position: absolute !important;
  z-index: 99999 !important;
  width: calc(24px - (var(--snake-index) * 0.55px)) !important;
  height: calc(13px - (var(--snake-index) * 0.23px)) !important;
  min-width: 8px !important;
  min-height: 5px !important;
  border-radius: 999px !important;
  pointer-events: none !important;
  transform-origin: 50% 50% !important;
  transition: opacity 220ms ease !important;
  background:
    linear-gradient(
      90deg,
      hsl(var(--snake-hue), 92%, 58%),
      hsl(calc(var(--snake-hue) + 45), 96%, 66%)
    ) !important;
  box-shadow:
    0 0 6px hsla(var(--snake-hue), 95%, 64%, 0.52),
    0 0 16px hsla(calc(var(--snake-hue) + 45), 95%, 66%, 0.22) !important;
  will-change: left, top, transform !important;
  backface-visibility: hidden !important;
}

.service-real-snake-fx::after {
  content: "" !important;
  position: absolute !important;
  inset: 23% !important;
  border-radius: inherit !important;
  background: rgba(255, 255, 255, 0.35) !important;
}

.service-real-snake-fx.snake-head {
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

.service-real-snake-jelly {
  filter: blur(.2px) !important;
  opacity: .9 !important;
}

.service-real-snake-fish:not(.snake-head) {
  width: calc(18px - (var(--snake-index) * 0.34px)) !important;
  height: calc(10px - (var(--snake-index) * 0.13px)) !important;
}
/* ===== REAL COLORFUL SERVICE SNAKE END ===== */
'@

Save-Utf8 $stylePath $style

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\real-snake-physics.js" | Out-Null
  node --check ".\assets\app.js" | Out-Null
}

Write-Host "DONE: All snake effects now use your exact service-section physics."
Write-Host "DONE: Head ease = 0.34 and body ease = 0.30."
Write-Host "DONE: Uses left/top, not doubled translate coordinates."
Write-Host "DONE: Colorful snake CSS added."
Write-Host "Backup saved here:"
Write-Host $backup
