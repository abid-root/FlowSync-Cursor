$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\ultra80-cursors.js") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-before-ultra80-preview-fix_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($p) {
  [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($p, $t) {
  [System.IO.File]::WriteAllText($p, $t, $script:utf8NoBom)
}

Write-Host "1) Fixing Ultra80 renderer bug..."

$u80Path = ".\assets\ultra80-cursors.js"
$js = Read-Utf8 $u80Path

# Previous Ultra80 renderer accidentally used a variable named `e` inside every effect function.
# Browser then throws ReferenceError: e is not defined, so previews do nothing.
$js = [regex]::Replace($js, '(?<![A-Za-z0-9_$])e(?![A-Za-z0-9_$])', 'effect')

$remainingBadE = [regex]::Matches($js, '(?<![A-Za-z0-9_$])e(?![A-Za-z0-9_$])').Count
if ($remainingBadE -gt 0) {
  throw "Ultra80 renderer still contains broken standalone e references. Stop and send me the ZIP."
}

Save-Utf8 $u80Path $js

Write-Host "2) Cache-busting ultra80-cursors.js script tags..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName
  $relativeDir = $_.DirectoryName.Substring($root.Length).TrimStart('\')
  $depth = if ([string]::IsNullOrWhiteSpace($relativeDir)) { 0 } else { ($relativeDir -split '[\\/]').Count }
  $src = (('../' * $depth) + "assets/ultra80-cursors.js?v=$stamp").Replace('\','/')

  if ($html -match 'assets/ultra80-cursors\.js') {
    $html = [regex]::Replace($html, '(?im)(<script[^>]+src=")([^"]*assets/ultra80-cursors\.js)(\?v=[^"]*)?("[^>]*></script>)', "`$1$src`$4")
  }

  Save-Utf8 $_.FullName $html
}

Write-Host "3) Making preview trigger more reliable..."

$appPath = ".\assets\app.js"
$app = Read-Utf8 $appPath
$app = [regex]::Replace($app, '(?s)\r?\n?/\* ===== ULTRA80 FINAL PREVIEW PATCH START ===== \*/.*?/\* ===== ULTRA80 FINAL PREVIEW PATCH END ===== \*/', '')

$patch = @'

/* ===== ULTRA80 FINAL PREVIEW PATCH START ===== */
(function () {
  if (window.__ultra80FinalPreviewPatch) return;
  window.__ultra80FinalPreviewPatch = true;

  if (typeof attachEffectPreview !== "function") return;

  attachEffectPreview = function (section, effect) {
    const layer = section.querySelector(".fx-layer");
    const target = section.querySelector(".preview-zone") || section;
    if (!layer || !target || !effect || typeof COLD_FX === "undefined") return;

    let last = 0;
    const persistent = new Set(["snake", "centipede", "jelly", "fish", "wild-animal", "mega-basic", "signature-basic", "ultra-follow"]);

    function spawnAt(clientX, clientY, force) {
      const now = performance.now();
      const gap = persistent.has(effect.kind) ? 0 : 40;
      if (!force && now - last < gap) return;
      last = now;

      const rect = layer.getBoundingClientRect();
      COLD_FX.spawn(effect, layer, clientX - rect.left, clientY - rect.top);
    }

    function spawnCenter() {
      const rect = target.getBoundingClientRect();
      spawnAt(rect.left + rect.width / 2, rect.top + rect.height / 2, true);
    }

    target.addEventListener("pointerenter", spawnCenter);
    target.addEventListener("pointermove", (event) => spawnAt(event.clientX, event.clientY, false));
    target.addEventListener("pointerdown", (event) => spawnAt(event.clientX, event.clientY, true));
    target.addEventListener("touchstart", (event) => {
      const touch = event.touches && event.touches[0];
      if (touch) spawnAt(touch.clientX, touch.clientY, true);
    }, { passive: true });

    target.addEventListener("pointerleave", () => {
      if (persistent.has(effect.kind)) setTimeout(() => COLD_FX.clear(layer), 240);
    });

    setTimeout(spawnCenter, 180);
  };
})();
/* ===== ULTRA80 FINAL PREVIEW PATCH END ===== */
'@

Save-Utf8 $appPath ($app.TrimEnd() + $patch)

Write-Host "4) Syntax check..."

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\ultra80-cursors.js" | Out-Null
  node --check ".\assets\app.js" | Out-Null
}

Write-Host ""
Write-Host "DONE: Ultra80 previews fixed."
Write-Host "Reason was: ReferenceError e is not defined inside ultra80-cursors.js."
Write-Host "Backup saved here:"
Write-Host $backup
