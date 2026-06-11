$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-before-speed-preview-fix_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($p) {
  [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($p, $t) {
  [System.IO.File]::WriteAllText($p, $t, $script:utf8NoBom)
}

Write-Host "1) Removing old auto-preview patches from app.js..."

$appPath = ".\assets\app.js"
$app = Read-Utf8 $appPath

# These two patches auto-started every preview after page load.
$app = [regex]::Replace(
  $app,
  '(?s)\r?\n?/\* ===== ULTRA80 PREVIEW RESCUE START ===== \*/.*?/\* ===== ULTRA80 PREVIEW RESCUE END ===== \*/',
  ''
)

$app = [regex]::Replace(
  $app,
  '(?s)\r?\n?/\* ===== ULTRA80 FINAL PREVIEW PATCH START ===== \*/.*?/\* ===== ULTRA80 FINAL PREVIEW PATCH END ===== \*/',
  ''
)

# Keep the original preview system, but make Ultra80 follow cursors persistent.
if ($app -match '"mega-basic"') {
  if ($app -notmatch '"ultra-follow"') {
    $app = $app -replace '"mega-basic"\s*\n\s*\]', '"mega-basic",`r`n    "ultra-follow"`r`n  ]'
  }
}

Save-Utf8 $appPath $app

Write-Host "2) Adding performance CSS..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath

$style = [regex]::Replace(
  $style,
  '(?s)\r?\n?/\* ===== SPEED PREVIEW FIX START ===== \*/.*?/\* ===== SPEED PREVIEW FIX END ===== \*/',
  ''
)

$css = @'

/* ===== SPEED PREVIEW FIX START ===== */

/* Do not spend layout/paint cost on far-offscreen preview cards until needed */
.effect-box,
.source-preview,
.code-card,
.main-card {
  content-visibility: auto;
  contain-intrinsic-size: 520px;
}

/* Keep animation layers isolated so effects do not repaint the whole page */
.fx-layer,
.preview-zone {
  contain: layout paint style;
}

/* Reduce expensive blur repaint while scrolling sticky bars */
.nav,
.category-strip {
  will-change: transform;
  transform: translateZ(0);
}

/* smoother sticky category tab under nav without forcing huge repaint */
.category-strip {
  backface-visibility: hidden;
}

/* ===== SPEED PREVIEW FIX END ===== */
'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $css)

Write-Host "3) Using smaller WebP logo for nav when available..."

$darkWebp = "assets/common/blackone.webp"
$lightWebp = "assets/common/whiteone.webp"

if ((Test-Path $darkWebp) -and (Test-Path $lightWebp)) {
  Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
  Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
  ForEach-Object {
    $html = Read-Utf8 $_.FullName

    $relativeDir = $_.DirectoryName.Substring($root.Length).TrimStart('\')
    $depth = if ([string]::IsNullOrWhiteSpace($relativeDir)) { 0 } else { ($relativeDir -split '[\\/]').Count }

    $darkSrc = (('../' * $depth) + $darkWebp).Replace('\','/')
    $lightSrc = (('../' * $depth) + $lightWebp).Replace('\','/')

    # Only change the nav brand image, not favicon.
    $html = [regex]::Replace(
      $html,
      '<img\s+class=["'']brand-logo["''][^>]*>',
      "<img class=""brand-logo"" src=""$darkSrc?v=$stamp"" data-logo-dark=""$darkSrc?v=$stamp"" data-logo-light=""$lightSrc?v=$stamp"" alt=""Coldboot logo"" decoding=""async"">"
    )

    Save-Utf8 $_.FullName $html
  }

  Write-Host "WebP nav logo enabled."
} else {
  Write-Host "WebP logo not found; nav logo unchanged."
}

Write-Host "4) Cleaning duplicate script tags..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  # Remove exact duplicate script tags while keeping order.
  $seen = @{}
  $lines = $html -split "\r?\n"
  $outLines = New-Object System.Collections.Generic.List[string]

  foreach ($line in $lines) {
    $m = [regex]::Match($line, '<script[^>]+src=["'']([^"'']+)["''][^>]*></script>')
    if ($m.Success) {
      $src = $m.Groups[1].Value -replace '\?v=[^"'']+', ''
      if ($seen.ContainsKey($src)) {
        continue
      }
      $seen[$src] = $true
    }
    $outLines.Add($line)
  }

  Save-Utf8 $_.FullName ($outLines -join "`r`n")
}

Write-Host "5) Syntax check..."

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\app.js" | Out-Null
  if (Test-Path ".\assets\ultra80-cursors.js") { node --check ".\assets\ultra80-cursors.js" | Out-Null }
  if (Test-Path ".\assets\ultra80-data.js") { node --check ".\assets\ultra80-data.js" | Out-Null }
  if (Test-Path ".\assets\fx.js") { node --check ".\assets\fx.js" | Out-Null }
}

Write-Host ""
Write-Host "DONE:"
Write-Host "- stopped previews from auto-running during page load"
Write-Host "- kept previews working on hover/move/touch"
Write-Host "- added content-visibility performance CSS"
Write-Host "- switched nav logo to small WebP if available"
Write-Host "- removed duplicate script tags"
Write-Host "- backup saved here:"
Write-Host $backup
