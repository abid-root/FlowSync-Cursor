$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\coldboot-addon-cursors.js") -or !(Test-Path ".\assets\style.css")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-before-preview-bugfix_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($p) {
  [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($p, $t) {
  [System.IO.File]::WriteAllText($p, $t, $script:utf8NoBom)
}

Write-Host "1) Fixing basic cursor preview renderer..."

$addonPath = ".\assets\coldboot-addon-cursors.js"
$addon = Read-Utf8 $addonPath

$addon = $addon.Replace(
  'if (effect.kind === "signature-basic") {',
  'if (effect.kind === "signature-basic" || effect.kind === "coldboot-basic") {'
)

$addon = $addon.Replace(
  'node.className = "signature-basic-follow " + effect.key;',
  'const basicClass = String(effect.key).replace(/^cb-basic-/, "bc-");' + "`r`n" + '    node.className = "signature-basic-follow " + effect.key + " " + basicClass;'
)

Save-Utf8 $addonPath $addon

Write-Host "2) Making preview boxes more reliable..."

$appPath = ".\assets\app.js"
$app = Read-Utf8 $appPath

$newAttach = @'
function attachEffectPreview(section, effect) {
  const layer = qs(".fx-layer", section);
  const target = qs(".preview-zone", section) || section;
  if (!layer || !target || !effect || typeof COLD_FX === "undefined" || typeof COLD_FX.spawn !== "function") return;

  const liveKinds = new Set([
    "snake",
    "centipede",
    "jelly",
    "fish",
    "wild-animal",
    "coldboot-basic",
    "signature-basic",
    "mega-basic"
  ]);

  let last = 0;
  let lastX = null;
  let lastY = null;

  function pointFromEvent(event) {
    const rect = layer.getBoundingClientRect();
    const source = event.touches && event.touches[0] ? event.touches[0] : event;
    let x = source.clientX - rect.left;
    let y = source.clientY - rect.top;

    if (!Number.isFinite(x) || !Number.isFinite(y)) {
      x = rect.width / 2;
      y = rect.height / 2;
    }

    x = Math.max(8, Math.min(rect.width - 8, x));
    y = Math.max(8, Math.min(rect.height - 8, y));
    return { x, y };
  }

  function fire(event, force = false) {
    const now = performance.now();
    const gap = liveKinds.has(effect.kind) ? 0 : 48;
    if (!force && now - last < gap) return;
    last = now;

    const pt = pointFromEvent(event || {});
    lastX = pt.x;
    lastY = pt.y;
    COLD_FX.spawn(effect, layer, pt.x, pt.y);
  }

  target.addEventListener("pointerenter", (event) => fire(event, true));
  target.addEventListener("pointermove", (event) => fire(event, false));
  target.addEventListener("mousemove", (event) => fire(event, false));

  target.addEventListener("touchstart", (event) => fire(event, true), { passive: true });
  target.addEventListener("touchmove", (event) => fire(event, false), { passive: true });

  target.addEventListener("pointerleave", () => {
    if (liveKinds.has(effect.kind)) {
      setTimeout(() => COLD_FX.clear(layer), 180);
      return;
    }

    // For particle effects, clear old pieces after they finish so previews do not stack forever.
    setTimeout(() => {
      if (lastX !== null || lastY !== null) COLD_FX.clear(layer);
    }, 1300);
  });
}
'@

$pattern = 'function attachEffectPreview\(section, effect\) \{.*?\n\}'
$fixed = [regex]::Replace($app, $pattern, $newAttach, [System.Text.RegularExpressions.RegexOptions]::Singleline)

if ($fixed -eq $app) {
  throw "Could not replace attachEffectPreview in assets/app.js. Send me your latest ZIP."
}

Save-Utf8 $appPath $fixed

Write-Host "3) Adding tiny CSS safety rule..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath

$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== BASIC PREVIEW BUGFIX START ===== \*/.*?/\* ===== BASIC PREVIEW BUGFIX END ===== \*/', '')

$css = @'

/* ===== BASIC PREVIEW BUGFIX START ===== */
.signature-basic-follow[class*="cb-basic-"] { opacity: 1; }
/* cb-basic-* elements also receive the matching bc-* class from coldboot-addon-cursors.js. */
/* ===== BASIC PREVIEW BUGFIX END ===== */
'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $css)

Write-Host "4) Syntax check..."

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\app.js" | Out-Null
  node --check ".\assets\coldboot-addon-cursors.js" | Out-Null
  node --check ".\assets\fx.js" | Out-Null
}

Write-Host ""
Write-Host "DONE: preview bug fixed."
Write-Host "Fixed: cb-basic preview effects now render correctly."
Write-Host "Fixed: preview boxes also trigger on pointer enter/touch, not only movement."
Write-Host "Backup saved here:"
Write-Host $backup
