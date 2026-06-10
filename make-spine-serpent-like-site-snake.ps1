$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\fx.js") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-real-snake-fix-backup_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($path) {
  return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($path, $text) {
  [System.IO.File]::WriteAllText($path, $text, $script:utf8NoBom)
}

Write-Host "1) Fixing the real snake position/spacing bug..."

$fxPath = ".\assets\fx.js"
$fx = Read-Utf8 $fxPath

$newUpdateTail = @'
  function updateTail(layer, key, effect, x, y, count, className, options = {}) {
    let store = tails.get(layer);

    const spacing = options.spacing || 12;
    const follow = options.follow == null ? 1 : options.follow;
    const rigidity = options.rigidity || .92;
    const iterations = options.iterations || 3;
    const waveAmount = options.wave || 0;
    const baseW = options.baseW || 17;
    const baseH = options.baseH || 9;
    const shrink = options.shrink || .12;

    if (!store || store.key !== key) {
      clear(layer);

      store = {
        key,
        parts: [],
        angle: 0,
        lastX: x,
        lastY: y
      };

      for (let i = 0; i < count; i++) {
        const node = add(layer, className(i), 0, 0, effect);

        /* Important:
           add() normally writes left/top = cursor position because normal particles
           animate from left/top. A snake uses transform coordinates instead.
           If left/top is not reset to 0, the snake position becomes doubled and
           feels far away from the pointer.
        */
        node.style.left = "0px";
        node.style.top = "0px";

        node.dataset.x = String(x - i * spacing);
        node.dataset.y = String(y);
        node.dataset.angle = "0";
        node.style.opacity = "1";

        const w = Math.max(8, baseW - i * shrink);
        const h = Math.max(6, baseH - i * .05);
        css(node, {
          "--w": `${w}px`,
          "--h": `${h}px`,
          "--snake-i": i
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

    let headAngle = Math.atan2(headY - oldHeadY, headX - oldHeadX);
    if (!Number.isFinite(headAngle) || Math.abs(headX - oldHeadX) + Math.abs(headY - oldHeadY) < .05) {
      headAngle = store.angle || 0;
    }

    store.angle = headAngle;
    store.lastX = headX;
    store.lastY = headY;

    head.dataset.x = String(headX);
    head.dataset.y = String(headY);
    head.dataset.angle = String(headAngle);

    for (let pass = 0; pass < iterations; pass++) {
      for (let i = 1; i < store.parts.length; i++) {
        const prev = store.parts[i - 1];
        const node = store.parts[i];

        const px = Number(prev.dataset.x);
        const py = Number(prev.dataset.y);
        let cx = Number(node.dataset.x);
        let cy = Number(node.dataset.y);

        let dx = cx - px;
        let dy = cy - py;
        let dist = Math.hypot(dx, dy);

        if (!Number.isFinite(dist) || dist < .001) {
          const fallbackAngle = (Number(prev.dataset.angle) || store.angle || 0) + Math.PI;
          dx = Math.cos(fallbackAngle);
          dy = Math.sin(fallbackAngle);
          dist = 1;
        }

        const nx = dx / dist;
        const ny = dy / dist;

        const targetX = px + nx * spacing;
        const targetY = py + ny * spacing;

        cx += (targetX - cx) * rigidity;
        cy += (targetY - cy) * rigidity;

        if (waveAmount && pass === iterations - 1) {
          const wave = Math.sin(performance.now() / 150 + i * .65) * waveAmount;
          cx += -ny * wave;
          cy += nx * wave;
        }

        const angle = Math.atan2(py - cy, px - cx);

        node.dataset.x = String(cx);
        node.dataset.y = String(cy);
        node.dataset.angle = String(angle);
      }
    }

    store.parts.forEach((node, i) => {
      const cx = Number(node.dataset.x);
      const cy = Number(node.dataset.y);
      const angle = Number(node.dataset.angle) || 0;

      node.style.transform = `translate(${cx}px, ${cy}px) translate(-50%,-50%) rotate(${angle * 180 / Math.PI}deg)`;
      node.style.zIndex = String(80 - i);
    });
  }

'@

$pattern = '(?s)\s*function updateTail\(\s*layer,\s*key,\s*effect,\s*x,\s*y,\s*count,\s*className,\s*options\s*=\s*\{\}\s*\)\s*\{.*?\}\s*(?=\s*const renderers\s*=\s*\{)'
if ($fx -notmatch $pattern) {
  throw "Could not find updateTail() in assets/fx.js. Send me your ZIP if this happens."
}

$fx = [regex]::Replace($fx, $pattern, "`r`n$newUpdateTail")

Write-Host "2) Making Spine Serpent use fixed bone spacing..."

$fx = [regex]::Replace(
  $fx,
  '(?m)^\s*"spine-serpent"\s*:\s*\(e,l,x,y\)\s*=>.*$',
  '    "spine-serpent": (e,l,x,y) => updateTail(l,"spine-serpent",e,x,y,24,(i)=>`fx-snake ${i===0?"head":""}`,{follow:1,rigidity:.96,iterations:4,spacing:12,wave:.22,baseW:16,baseH:9,shrink:.08}),'
)

$fx = [regex]::Replace(
  $fx,
  '(?m)^\s*"neon-centipede"\s*:\s*\(e,l,x,y\)\s*=>.*$',
  '    "neon-centipede": (e,l,x,y) => updateTail(l,"neon-centipede",e,x,y,20,(i)=>`fx-snake ${i===0?"head":""}`,{follow:.98,rigidity:.93,iterations:3,spacing:11,wave:.9,baseW:15,baseH:8,shrink:.1}),'
)

$fx = [regex]::Replace(
  $fx,
  '(?m)^\s*"jelly-larva"\s*:\s*\(e,l,x,y\)\s*=>.*$',
  '    "jelly-larva": (e,l,x,y) => updateTail(l,"jelly-larva",e,x,y,16,()=>"fx-blob",{follow:.94,rigidity:.86,iterations:3,spacing:13,wave:1.4,baseW:17,baseH:10,shrink:.15}),'
)

$fx = [regex]::Replace(
  $fx,
  '(?m)^\s*"fish-chain"\s*:\s*\(e,l,x,y\)\s*=>.*$',
  '    "fish-chain": (e,l,x,y) => updateTail(l,"fish-chain",e,x,y,15,(i)=> i===0?"fx-tri":"fx-dot",{follow:.96,rigidity:.9,iterations:3,spacing:13,wave:1.8,baseW:16,baseH:8,shrink:.1}),'
)

Save-Utf8 $fxPath $fx

Write-Host "3) Removing snake preview lag in app.js..."

$appPath = ".\assets\app.js"
$app = Read-Utf8 $appPath

$app = [regex]::Replace(
  $app,
  'const gap\s*=\s*.*?;',
  'const gap = ["snake", "centipede", "jelly", "fish"].includes(effect.kind) ? 6 : 72;',
  [System.Text.RegularExpressions.RegexOptions]::Singleline
)

Save-Utf8 $appPath $app

Write-Host "4) Making the snake visually closer to your site snake..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath

$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== REAL SITE SNAKE STYLE START ===== \*/.*?/\* ===== REAL SITE SNAKE STYLE END ===== \*/', '')

$snakeCss = @'

/* ===== REAL SITE SNAKE STYLE START ===== */
.fx-snake{
  width:var(--w,16px) !important;
  height:var(--h,9px) !important;
  border-radius:7px !important;
  background:
    linear-gradient(90deg,
      color-mix(in srgb, var(--a) 74%, #ffffff 26%),
      color-mix(in srgb, var(--b) 70%, #fff6d6 30%)) !important;
  border:1px solid color-mix(in srgb, var(--b) 42%, rgba(40,32,18,.25)) !important;
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,.42),
    0 0 8px color-mix(in srgb, var(--b) 20%, transparent) !important;
  transform-origin:center center !important;
  backface-visibility:hidden !important;
  will-change:transform !important;
}

.fx-snake:not(.head)::before,
.fx-snake:not(.head)::after{
  content:"" !important;
  position:absolute !important;
  top:50% !important;
  width:5px !important;
  height:5px !important;
  border-radius:999px !important;
  background:color-mix(in srgb, var(--a) 76%, #ffffff 24%) !important;
  border:1px solid color-mix(in srgb, var(--b) 34%, rgba(40,32,18,.18)) !important;
  transform:translateY(-50%) !important;
  opacity:.9 !important;
}

.fx-snake:not(.head)::before{left:-3px !important}
.fx-snake:not(.head)::after{right:-3px !important}

.fx-snake.head{
  width:32px !important;
  height:19px !important;
  border-radius:62% 48% 48% 62% !important;
  background:
    radial-gradient(circle at 72% 34%, var(--ink) 0 2px, transparent 2.4px),
    radial-gradient(circle at 72% 66%, var(--ink) 0 2px, transparent 2.4px),
    linear-gradient(90deg,
      color-mix(in srgb, var(--a) 78%, #ffffff 22%),
      color-mix(in srgb, var(--b) 62%, #fff2ca 38%)) !important;
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,.55),
    0 0 13px color-mix(in srgb, var(--b) 26%, transparent) !important;
}

.fx-snake.head::before,
.fx-snake.head::after{
  display:none !important;
}

html[data-theme="light"] .fx-snake{
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,.34),
    0 5px 10px rgba(35,32,24,.13) !important;
}
/* ===== REAL SITE SNAKE STYLE END ===== */
'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $snakeCss)

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\fx.js" | Out-Null
  node --check ".\assets\app.js" | Out-Null
}

Write-Host "DONE: Spine Serpent now follows the pointer closely."
Write-Host "DONE: Fixed doubled snake coordinates."
Write-Host "DONE: Body keeps fixed spacing and should not collapse."
Write-Host "DONE: Bone snake style added."
Write-Host "Backup saved here:"
Write-Host $backup
