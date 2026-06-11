$ErrorActionPreference = "Stop"

# Run inside either:
# 1) flowsync-cursor-library
# 2) parent folder that contains flowsync-cursor-library

$start = (Get-Location).Path

if ((Test-Path ".\assets\app.js") -and (Test-Path ".\index.html")) {
  $site = $start
} elseif ((Test-Path ".\flowsync-cursor-library\assets\app.js") -and (Test-Path ".\flowsync-cursor-library\index.html")) {
  $site = Join-Path $start "flowsync-cursor-library"
} else {
  throw "Wrong folder. Run inside flowsync-cursor-library or its parent folder."
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $site -Parent) "flowsync-cursor-library-before-real-pointer-fix_$stamp"
Copy-Item $site $backup -Recurse -Force

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($p) {
  [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($p, $t) {
  [System.IO.File]::WriteAllText($p, $t, $script:utf8NoBom)
}

Write-Host "1) Fixing preview coordinate bug..."

$appPath = Join-Path $site "assets\app.js"
$app = Read-Utf8 $appPath

# Remove the broken patch that spawns effects at preview center.
$app = [regex]::Replace(
  $app,
  '(?s)\r?\n?/\* ===== ULTRA80 FINAL PREVIEW PATCH START ===== \*/.*?/\* ===== ULTRA80 FINAL PREVIEW PATCH END ===== \*/\s*',
  "`r`n"
)

# Remove older copy of this fix if re-run.
$app = [regex]::Replace(
  $app,
  '(?s)\r?\n?/\* ===== REAL POINTER PREVIEW FIX START ===== \*/.*?/\* ===== REAL POINTER PREVIEW FIX END ===== \*/\s*',
  "`r`n"
)

$fix = @'
/* ===== REAL POINTER PREVIEW FIX START ===== */
(function () {
  if (window.__flowsyncRealPointerPreviewFix) return;
  window.__flowsyncRealPointerPreviewFix = true;

  if (typeof attachEffectPreview !== "function") return;

  attachEffectPreview = function (section, effect) {
    const layer = section.querySelector(".fx-layer");
    const target = section.querySelector(".preview-zone") || section;

    if (!layer || !target || !effect || typeof COLD_FX === "undefined" || typeof COLD_FX.spawn !== "function") return;

    const liveKinds = new Set([
      "snake",
      "centipede",
      "jelly",
      "fish",
      "wild-animal",
      "coldboot-basic",
      "signature-basic",
      "mega-basic",
      "ultra-follow"
    ]);

    let last = 0;
    let hasPointer = false;

    function localPoint(event) {
      const rect = layer.getBoundingClientRect();
      const source = event.touches && event.touches[0] ? event.touches[0] : event;

      const x = source.clientX - rect.left;
      const y = source.clientY - rect.top;

      if (!Number.isFinite(x) || !Number.isFinite(y)) return null;
      if (x < 0 || y < 0 || x > rect.width || y > rect.height) return null;

      return {
        x: Math.max(8, Math.min(rect.width - 8, x)),
        y: Math.max(8, Math.min(rect.height - 8, y))
      };
    }

    function fire(event, force = false) {
      const pt = localPoint(event);
      if (!pt) return;

      hasPointer = true;

      const now = performance.now();
      const gap = liveKinds.has(effect.kind) ? 0 : 42;

      if (!force && now - last < gap) return;
      last = now;

      COLD_FX.spawn(effect, layer, pt.x, pt.y);
    }

    target.addEventListener("pointerenter", (event) => fire(event, true));
    target.addEventListener("pointermove", (event) => fire(event, false));
    target.addEventListener("pointerdown", (event) => fire(event, true));

    target.addEventListener("touchstart", (event) => fire(event, true), { passive: true });
    target.addEventListener("touchmove", (event) => fire(event, false), { passive: true });

    target.addEventListener("pointerleave", () => {
      if (!hasPointer) return;

      if (liveKinds.has(effect.kind)) {
        setTimeout(() => COLD_FX.clear(layer), 220);
        return;
      }

      setTimeout(() => COLD_FX.clear(layer), 1300);
    });
  };
})();
/* ===== REAL POINTER PREVIEW FIX END ===== */
'@

Save-Utf8 $appPath ($app.TrimEnd() + "`r`n`r`n" + $fix + "`r`n")

Write-Host "2) Checking JavaScript..."

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check $appPath | Out-Null
}

Write-Host ""
Write-Host "DONE:"
Write-Host "- removed the center auto-spawn bug"
Write-Host "- preview effects now start from your real pointer position"
Write-Host "- no effect will spawn before you move/enter the preview"
Write-Host "- backup saved here:"
Write-Host $backup
