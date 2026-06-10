$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css") -or !(Test-Path ".\assets\data.js") -or !(Test-Path ".\assets\fx.js")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-site-snake-override-backup_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($path) {
  return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($path, $text) {
  [System.IO.File]::WriteAllText($path, $text, $script:utf8NoBom)
}

Write-Host "1) Creating site-style snake override..."

$snakeJs = @'
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
'@

Save-Utf8 ".\assets\snake-site-override.js" $snakeJs

Write-Host "2) Adding snake override script to all HTML files..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+snake-site-override\.js[^>]*></script>\s*', '')

  $relativeDir = $_.DirectoryName.Substring($root.Length).TrimStart('\')
  $depth = if ([string]::IsNullOrWhiteSpace($relativeDir)) { 0 } else { ($relativeDir -split '[\\/]').Count }
  $src = (('../' * $depth) + "assets/snake-site-override.js?v=$stamp").Replace('\','/')

  $scriptTag = "  <script src=""$src""></script>"

  if ($html -match '(?i)<script>init(CategoryPage|SourcePage)\(') {
    $html = [regex]::Replace($html, '(?i)(\s*<script>init(?:CategoryPage|SourcePage)\()', "`r`n$scriptTag`$1", 1)
  } elseif ($html -match '(?i)</body>') {
    $html = $html -replace '(?i)</body>', "$scriptTag`r`n</body>"
  }

  Save-Utf8 $_.FullName $html
}

Write-Host "3) Reducing pointermove throttle for creature effects..."

$appPath = ".\assets\app.js"
$app = Read-Utf8 $appPath

$app = [regex]::Replace(
  $app,
  'const gap\s*=\s*effect\.kind\s*===\s*"snake"\s*\|\|\s*effect\.kind\s*===\s*"centipede"\s*\|\|\s*effect\.kind\s*===\s*"jelly"\s*\|\|\s*effect\.kind\s*===\s*"fish"\s*\?\s*\d+\s*:\s*\d+;',
  'const gap = effect.kind === "snake" || effect.kind === "centipede" || effect.kind === "jelly" || effect.kind === "fish" ? 6 : 72;'
)

$app = [regex]::Replace(
  $app,
  'const gap\s*=\s*\["snake",\s*"centipede",\s*"jelly",\s*"fish"\]\.includes\(effect\.kind\)\s*\?\s*\d+\s*:\s*\d+;',
  'const gap = ["snake", "centipede", "jelly", "fish"].includes(effect.kind) ? 6 : 72;'
)

Save-Utf8 $appPath $app

Write-Host "4) Adding site-snake CSS..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath

$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== SITE SNAKE OVERRIDE STYLE START ===== \*/.*?/\* ===== SITE SNAKE OVERRIDE STYLE END ===== \*/', '')

$snakeCss = @'

/* ===== SITE SNAKE OVERRIDE STYLE START ===== */
.site-snake-fx{
  position:absolute !important;
  display:block !important;
  pointer-events:none !important;
  width:var(--snake-w,18px) !important;
  height:var(--snake-h,9px) !important;
  border-radius:999px !important;
  background:
    linear-gradient(90deg,
      color-mix(in srgb, var(--a) 74%, #ffffff 26%),
      color-mix(in srgb, var(--b) 66%, #fff1c8 34%)) !important;
  border:1px solid color-mix(in srgb, var(--b) 34%, rgba(42,34,18,.22)) !important;
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,.48),
    0 0 9px color-mix(in srgb, var(--b) 24%, transparent) !important;
  transform-origin:center center !important;
  will-change:left, top, transform !important;
  backface-visibility:hidden !important;
}

.site-snake-body::before,
.site-snake-body::after{
  content:"" !important;
  position:absolute !important;
  top:50% !important;
  width:5px !important;
  height:5px !important;
  border-radius:999px !important;
  background:color-mix(in srgb, var(--a) 70%, #ffffff 30%) !important;
  border:1px solid color-mix(in srgb, var(--b) 28%, rgba(42,34,18,.18)) !important;
  transform:translateY(-50%) !important;
  opacity:.86 !important;
}

.site-snake-body::before{left:-3px !important}
.site-snake-body::after{right:-3px !important}

.site-snake-head{
  border-radius:62% 48% 48% 62% !important;
  background:
    radial-gradient(circle at 72% 34%, var(--ink) 0 2px, transparent 2.4px),
    radial-gradient(circle at 72% 66%, var(--ink) 0 2px, transparent 2.4px),
    linear-gradient(90deg,
      color-mix(in srgb, var(--a) 78%, #ffffff 22%),
      color-mix(in srgb, var(--b) 62%, #fff2ca 38%)) !important;
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,.58),
    0 0 14px color-mix(in srgb, var(--b) 28%, transparent) !important;
}

.site-snake-jelly-larva{
  border-radius:999px !important;
  filter:blur(.2px) !important;
  opacity:.88 !important;
}

.site-snake-fish-chain.site-snake-body{
  width:10px !important;
  height:10px !important;
}

html[data-theme="light"] .site-snake-fx{
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,.34),
    0 5px 10px rgba(35,32,24,.13) !important;
}
/* ===== SITE SNAKE OVERRIDE STYLE END ===== */
'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $snakeCss)

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\app.js" | Out-Null
  node --check ".\assets\fx.js" | Out-Null
  node --check ".\assets\snake-site-override.js" | Out-Null
}

Write-Host "DONE: Snake replaced with your site-style second-section logic."
Write-Host "DONE: Head follows close to cursor."
Write-Host "DONE: Body stays flexible and does not collapse into one blob."
Write-Host "DONE: Old non-snake effects are untouched."
Write-Host "Backup saved here:"
Write-Host $backup
