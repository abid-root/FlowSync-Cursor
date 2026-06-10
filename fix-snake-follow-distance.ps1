$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\fx.js") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-snake-follow-fix-backup_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($path) {
  return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($path, $text) {
  [System.IO.File]::WriteAllText($path, $text, $script:utf8NoBom)
}

Write-Host "Fixing snake physics in fx.js..."

$fxPath = ".\assets\fx.js"
$fx = Read-Utf8 $fxPath

$newUpdateTail = @'
  function updateTail(layer, key, effect, x, y, count, className, options = {}) {
    let store = tails.get(layer);
    const spacing = options.spacing || 13;
    const follow = options.follow || .88;
    const ease = options.ease || .55;
    const waveAmount = options.wave || 0;

    if (!store || store.key !== key) {
      clear(layer);
      store = { key, parts: [], angle: 0 };

      for (let i = 0; i < count; i++) {
        const node = add(layer, className(i), x - i * spacing, y, effect);
        node.dataset.x = x - i * spacing;
        node.dataset.y = y;
        node.dataset.angle = "0";
        node.style.opacity = "1";

        const bodyW = Math.max(7, (options.baseW || 22) - i * (options.shrink || .34));
        const bodyH = Math.max(5, (options.baseH || 11) - i * .13);
        css(node, {
          "--w": `${bodyW}px`,
          "--h": `${bodyH}px`
        });

        store.parts.push(node);
      }

      tails.set(layer, store);
    }

    const head = store.parts[0];
    const oldHeadX = Number(head.dataset.x) || x;
    const oldHeadY = Number(head.dataset.y) || y;

    const headX = oldHeadX + (x - oldHeadX) * follow;
    const headY = oldHeadY + (y - oldHeadY) * follow;

    let headAngle = Math.atan2(y - oldHeadY, x - oldHeadX);
    if (!Number.isFinite(headAngle)) headAngle = store.angle || 0;
    store.angle = headAngle;

    head.dataset.x = headX;
    head.dataset.y = headY;
    head.dataset.angle = String(headAngle);
    head.style.transform = `translate(${headX}px, ${headY}px) translate(-50%,-50%) rotate(${headAngle * 180 / Math.PI}deg)`;

    for (let i = 1; i < store.parts.length; i++) {
      const prev = store.parts[i - 1];
      const node = store.parts[i];

      const prevX = Number(prev.dataset.x);
      const prevY = Number(prev.dataset.y);
      let cx = Number(node.dataset.x);
      let cy = Number(node.dataset.y);

      let dx = cx - prevX;
      let dy = cy - prevY;
      let dist = Math.hypot(dx, dy);

      if (!Number.isFinite(dist) || dist < .001) {
        const prevAngle = Number(prev.dataset.angle) || store.angle || 0;
        dx = -Math.cos(prevAngle);
        dy = -Math.sin(prevAngle);
        dist = 1;
      }

      const nx = dx / dist;
      const ny = dy / dist;

      const wave = Math.sin(performance.now() / 145 + i * .78) * waveAmount;
      const perpX = -ny * wave;
      const perpY = nx * wave;

      const targetX = prevX + nx * spacing + perpX;
      const targetY = prevY + ny * spacing + perpY;

      cx += (targetX - cx) * ease;
      cy += (targetY - cy) * ease;

      const angle = Math.atan2(prevY - cy, prevX - cx);

      node.dataset.x = cx;
      node.dataset.y = cy;
      node.dataset.angle = String(angle);

      node.style.transform = `translate(${cx}px, ${cy}px) translate(-50%,-50%) rotate(${angle * 180 / Math.PI}deg)`;
    }
  }

'@

$fx = [regex]::Replace(
  $fx,
  '(?s)  function updateTail\(\s*layer,\s*key,\s*effect,\s*x,\s*y,\s*count,\s*className,\s*options\s*=\s*\{\}\s*\)\s*\{.*?\}\s*(?=\s*const renderers\s*=\s*\{)',
  $newUpdateTail
)

# Make all creature tail effects use fixed spacing instead of collapsing.
$replacements = @{
  '"spine-serpent"\s*:\s*\(e,l,x,y\)\s*=>\s*updateTail\(l,"spine-serpent".*?\),' = '"spine-serpent": (e,l,x,y) => updateTail(l,"spine-serpent",e,x,y,24,(i)=>`fx-snake ${i===0?"head":""}`,{follow:.94,ease:.62,spacing:13,wave:.45,shrink:.38,baseW:21,baseH:10}),'
  '"neon-centipede"\s*:\s*\(e,l,x,y\)\s*=>\s*updateTail\(l,"neon-centipede".*?\),' = '"neon-centipede": (e,l,x,y) => updateTail(l,"neon-centipede",e,x,y,20,(i)=>`fx-snake ${i===0?"head":""}`,{follow:.92,ease:.56,spacing:12,wave:1.2,shrink:.42,baseW:20,baseH:9}),'
  '"jelly-larva"\s*:\s*\(e,l,x,y\)\s*=>\s*updateTail\(l,"jelly-larva".*?\),' = '"jelly-larva": (e,l,x,y) => updateTail(l,"jelly-larva",e,x,y,16,()=>"fx-blob",{follow:.88,ease:.44,spacing:15,wave:1.6,shrink:.24,baseW:18,baseH:10}),'
  '"fish-chain"\s*:\s*\(e,l,x,y\)\s*=>\s*updateTail\(l,"fish-chain".*?\),' = '"fish-chain": (e,l,x,y) => updateTail(l,"fish-chain",e,x,y,15,(i)=> i===0?"fx-tri":"fx-dot",{follow:.92,ease:.48,spacing:14,wave:2.2,shrink:.28,baseW:18,baseH:9}),'
}

foreach ($pattern in $replacements.Keys) {
  $fx = [regex]::Replace($fx, $pattern, $replacements[$pattern])
}

Save-Utf8 $fxPath $fx

Write-Host "Fixing preview pointer delay in app.js..."

$appPath = ".\assets\app.js"
$app = Read-Utf8 $appPath

# Make creature effects update almost every frame instead of lagging behind the pointer.
$app = [regex]::Replace(
  $app,
  'const gap\s*=\s*effect\.kind\s*===\s*"snake"\s*\|\|\s*effect\.kind\s*===\s*"centipede"\s*\|\|\s*effect\.kind\s*===\s*"jelly"\s*\|\|\s*effect\.kind\s*===\s*"fish"\s*\?\s*\d+\s*:\s*\d+;',
  'const gap = effect.kind === "snake" || effect.kind === "centipede" || effect.kind === "jelly" || effect.kind === "fish" ? 8 : 72;'
)

# Fallback if app.js was formatted differently.
$app = [regex]::Replace(
  $app,
  'const gap\s*=\s*\["snake",\s*"centipede",\s*"jelly",\s*"fish"\]\.includes\(effect\.kind\)\s*\?\s*\d+\s*:\s*\d+;',
  'const gap = ["snake", "centipede", "jelly", "fish"].includes(effect.kind) ? 8 : 72;'
)

Save-Utf8 $appPath $app

Write-Host "Adding small visual snake polish in style.css..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath

$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== SNAKE FOLLOW QUALITY FIX START ===== \*/.*?/\* ===== SNAKE FOLLOW QUALITY FIX END ===== \*/', '')

$style += @'

/* ===== SNAKE FOLLOW QUALITY FIX START ===== */
.fx-snake{
  transform-origin:center center !important;
  backface-visibility:hidden !important;
  will-change:transform !important;
}

.fx-snake.head{
  z-index:40 !important;
}

.fx-snake:not(.head){
  opacity:.92 !important;
}

.fx-blob{
  transform-origin:center center !important;
}
/* ===== SNAKE FOLLOW QUALITY FIX END ===== */
'@

Save-Utf8 $stylePath $style

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\fx.js" | Out-Null
  node --check ".\assets\app.js" | Out-Null
}

Write-Host "DONE: snake no longer collapses into one part."
Write-Host "DONE: snake follows closer to pointer."
Write-Host "DONE: fast movement should no longer become one big blob."
Write-Host "Backup saved here:"
Write-Host $backup
