$ErrorActionPreference = "Stop"

# Run inside either:
# 1) flowsync-cursor-library
# 2) parent folder that contains flowsync-cursor-library

$start = (Get-Location).Path

if ((Test-Path ".\assets\data.js") -and (Test-Path ".\assets\style.css") -and (Test-Path ".\index.html")) {
  $site = $start
} elseif ((Test-Path ".\flowsync-cursor-library\assets\data.js") -and (Test-Path ".\flowsync-cursor-library\index.html")) {
  $site = Join-Path $start "flowsync-cursor-library"
} else {
  throw "Wrong folder. Run inside flowsync-cursor-library or its parent folder."
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $site -Parent) "flowsync-cursor-library-before-category-preview-fix_$stamp"
Copy-Item $site $backup -Recurse -Force

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($p) {
  [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($p, $t) {
  [System.IO.File]::WriteAllText($p, $t, $script:utf8NoBom)
}

Write-Host "1) Fixing category names/icons so they do not overlap..."

$dataPath = Join-Path $site "assets\data.js"
$data = Read-Utf8 $dataPath

$replaceMap = [ordered]@{
  '"title": "Ash & Smoke"' = '"title": "Ash Smoke"'
  '"title": "Signature Structure"' = '"title": "Structure"'
  '"title": "Signal & Energy"' = '"title": "Signal"'
  '"title": "Precision Instruments"' = '"title": "Precision"'
  '"title": "Kinetic Objects"' = '"title": "Kinetic"'
  '"icon": "ash"' = '"icon": "◌"'
  '"icon": "structure"' = '"icon": "▦"'
  '"icon": "energy"' = '"icon": "ϟ"'
  '"icon": "instrument"' = '"icon": "⌖"'
  '"icon": "kinetic"' = '"icon": "◆"'
}

foreach ($key in $replaceMap.Keys) {
  $data = $data.Replace($key, $replaceMap[$key])
}

Save-Utf8 $dataPath $data

Write-Host "2) Fixing Ash/Structure/Signal preview renderer..."

$bridgePath = Join-Path $site "assets\cb-addon-preview-fix.js"

$bridge = @'
/* Fix for FlowSync addon preview categories.
   The cleaned data file keeps the CB effects inside COLD_EFFECTS, but the addon
   renderer expects COLD_ADDON_EFFECTS. This bridge makes Ash/Structure/Signal previews work. */
(function () {
  const current = Array.isArray(window.COLD_ADDON_EFFECTS) ? window.COLD_ADDON_EFFECTS : [];
  const all = Array.isArray(window.COLD_EFFECTS) ? window.COLD_EFFECTS : [];
  const byKey = new Map();

  current.forEach((item) => {
    if (item && item.key) byKey.set(item.key, item);
  });

  all.forEach((item) => {
    if (!item || !item.key) return;

    const key = String(item.key);
    const kind = String(item.kind || "");

    if (
      key.startsWith("cb-") ||
      kind.includes("coldboot") ||
      kind.includes("signature")
    ) {
      byKey.set(key, item);
    }
  });

  window.COLD_ADDON_EFFECTS = Array.from(byKey.values());
})();
'@

Save-Utf8 $bridgePath $bridge

Write-Host "3) Loading preview bridge before flowsync-addon-cursors.js..."

Get-ChildItem -Path $site -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\_local-backups\\" -and $_.FullName -notmatch "\\\.git\\" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  $html = [regex]::Replace(
    $html,
    '(?im)^\s*<script[^>]+cb-addon-preview-fix\.js[^>]*></script>\s*',
    ''
  )

  if ($html -match 'flowsync-addon-cursors\.js') {
    $prefix = "assets"
    if ($_.FullName -match "\\categories\\" -or $_.FullName -match "\\sources\\") {
      $prefix = "../assets"
    }

    $tag = '  <script src="' + $prefix + '/cb-addon-preview-fix.js"></script>' + "`r`n"

    $html = [regex]::Replace(
      $html,
      '(?im)(^\s*<script[^>]+flowsync-addon-cursors\.js[^>]*></script>\s*)',
      $tag + '$1',
      1
    )
  }

  Save-Utf8 $_.FullName $html
}

Write-Host "4) Adding category text/layout CSS fix..."

$stylePath = Join-Path $site "assets\style.css"
$style = Read-Utf8 $stylePath

$style = [regex]::Replace(
  $style,
  '(?s)\r?\n?/\* ===== CATEGORY LABEL AND PREVIEW FIX START ===== \*/.*?/\* ===== CATEGORY LABEL AND PREVIEW FIX END ===== \*/\s*',
  "`r`n"
)

$css = @'

/* ===== CATEGORY LABEL AND PREVIEW FIX START ===== */

/* Fix long category names/icons overlapping in See More panel */
.category-main-row {
  grid-template-columns: repeat(5, minmax(0, 1fr)) !important;
}

.category-card {
  overflow: hidden !important;
}

.category-card strong {
  min-width: 0 !important;
  width: 100% !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 8px !important;
}

.cat-icon {
  flex: 0 0 22px !important;
  width: 22px !important;
  max-width: 22px !important;
  overflow: hidden !important;
  text-align: center !important;
  font-size: .74rem !important;
  line-height: 1 !important;
  letter-spacing: 0 !important;
}

.cat-label {
  min-width: 0 !important;
  max-width: 100% !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  white-space: nowrap !important;
  font-size: clamp(.64rem, .78vw, .78rem) !important;
  line-height: 1 !important;
}

/* More panel: wider cards, no text collision */
.more-panel-grid {
  grid-template-columns: repeat(auto-fit, minmax(190px, 1fr)) !important;
}

.category-more-panel .category-card {
  justify-content: flex-start !important;
  padding-inline: 14px !important;
}

.category-more-panel .category-card strong {
  justify-content: flex-start !important;
  text-align: left !important;
}

.category-more-panel .cat-label {
  font-size: .76rem !important;
}

.category-more-panel .cat-icon {
  color: var(--accent) !important;
}

/* Ensure invisible overlay never blocks preview pointer events */
.preview-zone {
  pointer-events: auto !important;
}

.fx-layer {
  pointer-events: none !important;
}

@media (max-width: 720px) {
  .cat-label {
    font-size: .72rem !important;
  }

  .more-panel-grid {
    grid-template-columns: 1fr !important;
  }
}

/* ===== CATEGORY LABEL AND PREVIEW FIX END ===== */
'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $css + "`r`n")

Write-Host "5) Syntax check..."

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check (Join-Path $site "assets\cb-addon-preview-fix.js") | Out-Null
  node --check (Join-Path $site "assets\app.js") | Out-Null
  node --check (Join-Path $site "assets\flowsync-addon-cursors.js") | Out-Null
}

Write-Host ""
Write-Host "DONE:"
Write-Host "- fixed the 3 broken addon preview categories: Ash Smoke, Structure, Signal"
Write-Host "- shortened category names in the tab panel"
Write-Host "- replaced long text icons with small clean symbols"
Write-Host "- fixed overlapping category labels"
Write-Host "- backup saved here:"
Write-Host $backup
