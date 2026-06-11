$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\style.css")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-before-logo-favicon-category-fixed_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($p) {
  [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($p, $t) {
  [System.IO.File]::WriteAllText($p, $t, $script:utf8NoBom)
}

function First-Existing($items) {
  foreach ($item in $items) {
    if (Test-Path $item) { return $item }
  }
  return $null
}

Write-Host "1) Finding dark/light logo files..."

# Dark theme should use the dark-card / white-mark logo.
$darkLogo = First-Existing @(
  "assets/common/blackone.png",
  "assets/common/lightone.png",
  "assets/common/blackone.webp",
  "assets/common/brandlogo-blackbg.png",
  "assets/common/coldboot-black.png"
)

# Light theme should use the light-card / dark-mark logo.
$lightLogo = First-Existing @(
  "assets/common/whiteone.png",
  "assets/common/darkone.png",
  "assets/common/whiteone.webp",
  "assets/common/brandlogowhite.png"
)

if (!$darkLogo -or !$lightLogo) {
  throw "Logo files not found. Need dark logo and light logo inside assets/common. Expected blackone.png + whiteone.png, or lightone.png + darkone.png, or blackone.webp + whiteone.webp."
}

Write-Host "Dark theme logo:" $darkLogo
Write-Host "Light theme logo:" $lightLogo

Write-Host "2) Writing theme logo/favicon switcher..."

$themeJs = @'
(function () {
  if (window.__coldbootThemeLogoReady) return;
  window.__coldbootThemeLogoReady = true;

  const root = document.documentElement;

  function getTheme() {
    return root.getAttribute("data-theme") === "light" ? "light" : "dark";
  }

  function applyThemeAssets() {
    const theme = getTheme();

    document.querySelectorAll("img.brand-logo[data-logo-dark][data-logo-light]").forEach((img) => {
      const src = theme === "light" ? img.dataset.logoLight : img.dataset.logoDark;
      if (src && img.getAttribute("src") !== src) img.setAttribute("src", src);
    });

    document.querySelectorAll("link[data-theme-favicon]").forEach((link) => {
      const href = theme === "light" ? link.dataset.hrefLight : link.dataset.hrefDark;
      if (href && link.getAttribute("href") !== href) link.setAttribute("href", href);
    });
  }

  new MutationObserver(applyThemeAssets).observe(root, {
    attributes: true,
    attributeFilter: ["data-theme"]
  });

  document.addEventListener("DOMContentLoaded", applyThemeAssets);
  document.addEventListener("click", (event) => {
    if (event.target.closest("[data-theme-toggle]")) {
      window.setTimeout(applyThemeAssets, 0);
      window.setTimeout(applyThemeAssets, 80);
    }
  });

  applyThemeAssets();
})();
'@

Save-Utf8 ".\assets\theme-logo-favicon.js" $themeJs

Write-Host "3) Updating all HTML pages with logo, favicon and script..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  $relativeDir = $_.DirectoryName.Substring($root.Length).TrimStart('\')
  $depth = if ([string]::IsNullOrWhiteSpace($relativeDir)) { 0 } else { ($relativeDir -split '[\\/]').Count }

  $darkSrc = (('../' * $depth) + $darkLogo).Replace('\','/')
  $lightSrc = (('../' * $depth) + $lightLogo).Replace('\','/')
  $switcherSrc = (('../' * $depth) + "assets/theme-logo-favicon.js?v=$stamp").Replace('\','/')

  $logoTag = "<img class=`"brand-logo`" src=`"$darkSrc?v=$stamp`" data-logo-dark=`"$darkSrc?v=$stamp`" data-logo-light=`"$lightSrc?v=$stamp`" alt=`"Coldboot logo`">"

  # Remove old favicon tags and old theme logo switcher tags.
  $html = [regex]::Replace($html, '(?im)^\s*<link\s+[^>]*rel=["''](?:icon|shortcut icon|apple-touch-icon)["''][^>]*>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<link\s+[^>]*data-theme-favicon[^>]*>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+theme-logo-favicon\.js[^>]*></script>\s*', '')

  # Add dynamic favicon links. Browser will start with dark-theme icon, JS switches on light theme.
  $faviconLinks = @"
  <link id="coldboot-theme-favicon" rel="icon" type="image/png" href="$darkSrc?v=$stamp" data-theme-favicon data-href-dark="$darkSrc?v=$stamp" data-href-light="$lightSrc?v=$stamp">
  <link rel="shortcut icon" type="image/png" href="$darkSrc?v=$stamp" data-theme-favicon data-href-dark="$darkSrc?v=$stamp" data-href-light="$lightSrc?v=$stamp">
  <link rel="apple-touch-icon" href="$darkSrc?v=$stamp" data-theme-favicon data-href-dark="$darkSrc?v=$stamp" data-href-light="$lightSrc?v=$stamp">
"@

  if ($html -match '(?i)</head>') {
    $html = $html -replace '(?i)</head>', "$faviconLinks</head>"
  }

  # Replace old dot or old brand logo with the new theme-aware logo.
  $html = [regex]::Replace($html, '<img\s+class=["'']brand-logo["''][^>]*>', $logoTag)
  $html = [regex]::Replace($html, '<span\s+class=["'']brand-dot["'']\s*>\s*</span>', $logoTag)

  # If a brand link has no logo after the replacements, insert one at the start.
  if ($html -notmatch 'class="brand-logo"' -and $html -match '<a\s+class=["'']brand["'']') {
    $html = [regex]::Replace($html, '(<a\s+class=["'']brand["''][^>]*>)', "`$1$logoTag", 1)
  }

  $scriptTag = "  <script src=`"$switcherSrc`"></script>"

  # Load after app.js when possible, otherwise before </body>.
  if ($html -match 'assets/app\.js') {
    $html = [regex]::Replace($html, '(?im)(^\s*<script[^>]+assets/app\.js[^>]*></script>\s*)', "`$1$scriptTag`r`n", 1)
  } elseif ($html -match '(?i)</body>') {
    $html = $html -replace '(?i)</body>', "$scriptTag`r`n</body>"
  }

  Save-Utf8 $_.FullName $html
}

Write-Host "4) Adding final nav logo and category-position CSS..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath

$style = [regex]::Replace(
  $style,
  '(?s)\r?\n?/\* ===== FINAL LOGO FAVICON CATEGORY TAB FIX START ===== \*/.*?/\* ===== FINAL LOGO FAVICON CATEGORY TAB FIX END ===== \*/',
  ''
)

$css = @'

/* ===== FINAL LOGO FAVICON CATEGORY TAB FIX START ===== */
:root {
  --cb-nav-top: 16px;
  --cb-nav-height: 64px;
  --cb-cat-gap: 14px;
}

/* Brand logo: replaces green dot */
.brand {
  display: inline-flex !important;
  align-items: center !important;
  gap: 12px !important;
  line-height: 1 !important;
}

.brand-dot {
  display: none !important;
}

.brand-logo {
  width: 34px !important;
  height: 34px !important;
  display: inline-block !important;
  object-fit: cover !important;
  border-radius: 10px !important;
  flex: 0 0 auto !important;
  vertical-align: middle !important;
  box-shadow: 0 8px 18px rgba(0, 0, 0, .24) !important;
}

/* Nav stays clean at top */
.nav {
  position: sticky !important;
  top: var(--cb-nav-top) !important;
  z-index: 1200 !important;
  min-height: var(--cb-nav-height) !important;
  margin-bottom: 0 !important;
  display: flex !important;
  align-items: center !important;
  backdrop-filter: blur(18px) saturate(135%) !important;
}

/* Category tab fixed directly under nav */
.category-strip {
  display: flex !important;
  visibility: visible !important;
  opacity: 1 !important;
  position: sticky !important;
  top: calc(var(--cb-nav-top) + var(--cb-nav-height) + var(--cb-cat-gap)) !important;
  z-index: 1150 !important;
  margin-top: 18px !important;
  margin-bottom: 30px !important;
  backdrop-filter: blur(18px) saturate(135%) !important;
}

.category-grid {
  flex: 1 1 auto !important;
  min-width: 0 !important;
}

.category-main-row {
  display: grid !important;
  grid-template-columns: repeat(5, minmax(0, 1fr)) !important;
  gap: 12px !important;
}

.category-card {
  min-width: 0 !important;
}

.see-more {
  flex: 0 0 132px !important;
  width: 132px !important;
  margin-left: 0 !important;
}

.category-more-panel {
  z-index: 1300 !important;
}

/* Do not let scroll helper hide nav/category bars */
body.hide-top-bars .nav,
body.hide-top-bars .category-strip {
  opacity: 1 !important;
  transform: none !important;
  visibility: visible !important;
  pointer-events: auto !important;
}

/* Keep the hero below the category tab with a clean gap */
.category-hero {
  margin-top: 28px !important;
}

@media (max-width: 900px) {
  .category-main-row {
    display: flex !important;
    flex-wrap: nowrap !important;
    gap: 10px !important;
    overflow-x: auto !important;
    scrollbar-width: none !important;
  }

  .category-main-row::-webkit-scrollbar {
    display: none !important;
  }

  .category-card {
    flex: 0 0 auto !important;
    min-width: 190px !important;
  }
}

@media (max-width: 640px) {
  :root {
    --cb-nav-top: 8px;
    --cb-nav-height: 58px;
    --cb-cat-gap: 10px;
  }

  .brand {
    gap: 9px !important;
  }

  .brand-logo {
    width: 28px !important;
    height: 28px !important;
    border-radius: 8px !important;
  }

  .nav {
    min-height: var(--cb-nav-height) !important;
  }

  .category-strip {
    min-height: 68px !important;
    margin-top: 12px !important;
    margin-bottom: 24px !important;
  }

  .category-card {
    min-width: 168px !important;
  }

  .see-more {
    flex: 0 0 auto !important;
    width: auto !important;
    padding-inline: 18px !important;
  }
}
/* ===== FINAL LOGO FAVICON CATEGORY TAB FIX END ===== */
'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $css)

Write-Host "5) Syntax check..."
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\theme-logo-favicon.js" | Out-Null
  if (Test-Path ".\assets\app.js") { node --check ".\assets\app.js" | Out-Null }
}

Write-Host ""
Write-Host "DONE: nav logo added with dark/light theme switching."
Write-Host "DONE: favicon added with dark/light theme switching."
Write-Host "DONE: category tab fixed under nav."
Write-Host "Backup saved here:"
Write-Host $backup
