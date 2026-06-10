$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css") -or !(Test-Path ".\assets\data.js") -or !(Test-Path ".\assets\fx.js")) {
  throw "Wrong folder. Run this inside the flowsync-cursor-library project root."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-final-code-clean-backup_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($path) {
  return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($path, $text) {
  [System.IO.File]::WriteAllText($path, $text, $script:utf8NoBom)
}

function HtmlSafe($value) {
  return [System.Net.WebUtility]::HtmlEncode([string]$value)
}

Write-Host "1) Reading data.js..."

$dataText = Read-Utf8 ".\assets\data.js"
$catMatch = [regex]::Match($dataText, 'window\.COLD_DATA\s*=\s*(\[.*?\]);', [System.Text.RegularExpressions.RegexOptions]::Singleline)
$effMatch = [regex]::Match($dataText, 'window\.COLD_EFFECTS\s*=\s*(\[.*?\]);', [System.Text.RegularExpressions.RegexOptions]::Singleline)

if (!$catMatch.Success) { throw "Cannot find window.COLD_DATA in assets/data.js" }
if (!$effMatch.Success) { throw "Cannot find window.COLD_EFFECTS in assets/data.js" }

$categories = $catMatch.Groups[1].Value | ConvertFrom-Json
$effects = $effMatch.Groups[1].Value | ConvertFrom-Json

Write-Host "Categories found:" $categories.Count
Write-Host "Effects found:" $effects.Count

Write-Host "2) Cleaning old root scripts that are not website code..."

$currentScript = ""
try { $currentScript = Split-Path -Leaf $PSCommandPath } catch {}

$oldScripts = @(
  "quality-cursor-refactor.ps1",
  "add-uploaded-cursors-and-see-more.ps1",
  "add-uploaded-cursors-and-see-more-fixed.ps1",
  "coldboot-clean-final-fix.ps1"
)

foreach ($s in $oldScripts) {
  if ($s -ne $currentScript) {
    Remove-Item ".\$s" -Force -ErrorAction SilentlyContinue
  }
}

Write-Host "3) Fixing app.js category/see-more logic..."

$appPath = ".\assets\app.js"
$app = Read-Utf8 $appPath

$newRenderAndSetup = @'
function renderCategoryGrid(grid, activeId, sameFolder, expanded = false) {
  if (!grid) return;

  const primaryLimit = 5;
  const visible = COLD_DATA.slice(0, primaryLimit);

  function card(cat, insidePanel = false) {
    const href = sameFolder ? `${cat.id}.html` : `categories/${cat.id}.html`;
    return `
      <a class="category-card ${cat.id === activeId ? "active" : ""} ${insidePanel ? "panel-card" : ""}" href="${href}">
        <strong>
          <span class="cat-icon" aria-hidden="true">${cat.icon}</span>
          <span class="cat-label">${cat.title}</span>
        </strong>
      </a>
    `;
  }

  grid.innerHTML = `
    <div class="category-main-row">
      ${visible.map((cat) => card(cat, false)).join("")}
    </div>
    <div class="category-more-panel" aria-hidden="${expanded ? "false" : "true"}">
      <div class="more-panel-title">All categories</div>
      <div class="more-panel-grid">
        ${COLD_DATA.map((cat) => card(cat, true)).join("")}
      </div>
    </div>
  `;

  const strip = grid.closest(".category-strip");
  if (strip) {
    strip.classList.toggle("is-expanded", expanded);
    strip.classList.toggle("has-extra-categories", COLD_DATA.length > primaryLimit);
  }
}

function setupCategoryNav(activeId, sameFolder) {
  const strip = qs(".category-strip");
  const grid = strip ? qs("#categoryGrid", strip) : qs("#categoryGrid");
  const button = strip ? qs("#seeMoreBtn", strip) : qs("#seeMoreBtn");

  if (!grid) return;

  let expanded = false;

  function render() {
    renderCategoryGrid(grid, activeId, sameFolder, expanded);

    if (button) {
      const hasExtra = COLD_DATA.length > 5;
      button.hidden = !hasExtra;
      button.textContent = expanded ? "Close" : "See more";
      button.setAttribute("aria-expanded", expanded ? "true" : "false");
    }
  }

  render();

  if (button) {
    button.onclick = (event) => {
      event.preventDefault();
      expanded = !expanded;
      render();
    };
  }

  document.addEventListener("click", (event) => {
    if (!strip || !expanded) return;
    if (!strip.contains(event.target)) {
      expanded = false;
      render();
    }
  });
}

'@

# Replace old renderCategoryGrid + setupCategoryNav if both exist.
$app = [regex]::Replace(
  $app,
  '(?s)function renderCategoryGrid\(\s*grid,\s*activeId,\s*sameFolder,\s*expanded\s*=\s*false\s*\)\s*\{.*?\}\s*function setupCategoryNav\(\s*activeId,\s*sameFolder\s*\)\s*\{.*?\}\s*(?=function attachEffectPreview)',
  $newRenderAndSetup
)

# Replace old renderCategoryGrid variant if script is run on older version.
$app = [regex]::Replace(
  $app,
  '(?s)function renderCategoryGrid\(\s*grid,\s*activeId,\s*expanded,\s*sameFolder\s*\)\s*\{.*?\}\s*(?=function attachEffectPreview)',
  $newRenderAndSetup
)

# If setupCategoryNav was not present in old version, insert before attachEffectPreview.
if ($app -notmatch 'function setupCategoryNav\(') {
  $app = [regex]::Replace($app, '(?=function attachEffectPreview)', $newRenderAndSetup)
}

# Ensure initIndex/initCategoryPage call setupCategoryNav.
$app = [regex]::Replace(
  $app,
  '(?s)function initIndex\(\)\s*\{.*?\}\s*(?=function initCategoryPage)',
  "function initIndex() {`r`n  initTheme();`r`n  setupCategoryNav(`"`", false);`r`n}`r`n"
)

$app = [regex]::Replace(
  $app,
  '(?s)function initCategoryPage\(\s*catId\s*\)\s*\{.*?\}\s*(?=function initSourcePage)',
  "function initCategoryPage(catId) {`r`n  initTheme();`r`n  setupCategoryNav(catId, true);`r`n`r`n  qsa(`".effect-box`").forEach((box) => {`r`n    const effect = COLD_EFFECTS.find((item) => item.key === box.dataset.effect);`r`n    attachEffectPreview(box, effect);`r`n  });`r`n}`r`n"
)

Save-Utf8 $appPath $app

Write-Host "4) Fixing HTML category strips and index cards..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  # Remove duplicate/old see-more button, then add one clean button after categoryGrid.
  if ($html -match 'id="categoryGrid"') {
    $html = [regex]::Replace($html, '(?is)\s*<button[^>]*id="seeMoreBtn"[^>]*>.*?</button>\s*', "`r`n")
    $html = [regex]::Replace(
      $html,
      '(<div\s+class="category-grid"\s+id="categoryGrid"></div>)',
      { param($m) $m.Groups[1].Value + "`r`n      <button class=""see-more"" id=""seeMoreBtn"" type=""button"" aria-expanded=""false"">See more</button>" }
    )
  }

  Save-Utf8 $_.FullName $html
}

# Rebuild index library cards so it shows all current categories, not old 6-category text.
$indexPath = ".\index.html"
$index = Read-Utf8 $indexPath

$cards = ""
foreach ($cat in $categories) {
  $num = HtmlSafe $cat.num
  $title = HtmlSafe $cat.title
  $desc = HtmlSafe $cat.desc
  $id = HtmlSafe $cat.id
  $cards += @"
      <article class="main-card" data-watermark="$title">
        <span class="pill">$num / category</span>
        <h2>$title</h2>
        <p>$desc</p>
        <a href="categories/$id.html">Open category</a>
      </article>

"@
}

$index = [regex]::Replace(
  $index,
  '(?is)<section\s+class="main-grid section-gap"\s+id="library">.*?</section>',
  "<section class=""main-grid section-gap"" id=""library"">`r`n$cards    </section>"
)

$index = [regex]::Replace(
  $index,
  '(?is)<footer>.*?</footer>',
  "<footer>$($categories.Count) focused categories. $($effects.Count) redesigned cursor effects. Each effect has dark and light theme visibility.</footer>"
)

Save-Utf8 $indexPath $index

Write-Host "5) Cleaning CSS conflict blocks and adding final category panel CSS..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath

# Remove all previous generated final override blocks so they stop fighting each other.
$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== COLDBOOT CLEAN FINAL START ===== \*/.*?/\* ===== COLDBOOT CLEAN FINAL END ===== \*/', '')
$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== CATEGORY SEE MORE FINAL START ===== \*/.*?/\* ===== CATEGORY SEE MORE FINAL END ===== \*/', '')
$style = [regex]::Replace($style, '(?s)\r?\n?/\* === V11 COMPACT PREVIEW FIX START === \*/.*?/\* === V11 COMPACT PREVIEW FIX END === \*/', '')
$style = [regex]::Replace($style, '(?s)\r?\n?/\* === V16 CLEAN CATEGORY ROW START === \*/.*?/\* === V16 CLEAN CATEGORY ROW END === \*/', '')

$finalCss = @'

/* ===== COLDBOOT FINAL CLEAN + SEE MORE START ===== */

/* theme stays clean */
html[data-theme="dark"]{
  --bg:#06090f !important;
  --page:#090e17 !important;
  --page-2:#0b111d !important;
  --panel:#101724 !important;
  --panel-2:#111a29 !important;
  --soft:#182235 !important;
  --line:rgba(255,255,255,.075) !important;
  --text:#f5f1e8 !important;
  --muted:rgba(245,241,232,.62) !important;
  --accent:#a7e956 !important;
  --accent-soft:rgba(167,233,86,.13) !important;
  --shadow:0 12px 34px rgba(0,0,0,.24) !important;
  --grid:rgba(255,255,255,.04) !important;
  --wm:rgba(255,255,255,.018) !important;
}

html[data-theme="light"]{
  --bg:#c7c0b1 !important;
  --page:#cfc7b8 !important;
  --page-2:#bdb5a7 !important;
  --panel:#b9b1a4 !important;
  --panel-2:#aaa398 !important;
  --soft:#9f9a91 !important;
  --line:rgba(25,25,25,.14) !important;
  --text:#15191e !important;
  --muted:#3d4146 !important;
  --accent:#6f8f35 !important;
  --accent-soft:rgba(111,143,53,.15) !important;
  --shadow:0 14px 32px rgba(35,32,28,.14) !important;
  --grid:rgba(20,25,30,.045) !important;
  --wm:rgba(20,24,28,.035) !important;
}

html[data-theme="dark"] body{
  background:
    radial-gradient(circle at 14% 10%, rgba(185,255,87,.045), transparent 22%),
    radial-gradient(circle at 92% 84%, rgba(185,255,87,.025), transparent 24%),
    var(--bg) !important;
}

html[data-theme="light"] body{
  background:
    radial-gradient(circle at 12% 10%, rgba(80,95,55,.055), transparent 24%),
    linear-gradient(180deg,#c7c0b1 0%,#bdb5a7 100%) !important;
}

body::before{
  background-image:
    linear-gradient(var(--grid) 1px, transparent 1px),
    linear-gradient(90deg, var(--grid) 1px, transparent 1px) !important;
}

html[data-theme="light"] body::before{opacity:.12 !important}
html[data-theme="dark"] body::before{opacity:.42 !important}

/* spacing */
.shell{
  width:min(1160px, calc(100% - 48px)) !important;
  padding-top:18px !important;
  padding-bottom:70px !important;
}

.nav{
  position:sticky !important;
  top:14px !important;
  z-index:120 !important;
  min-height:58px !important;
  padding:10px 16px !important;
  margin:0 0 18px !important;
  border-radius:22px !important;
  box-shadow:var(--shadow) !important;
  background:color-mix(in srgb, var(--panel) 82%, transparent) !important;
}

.theme-toggle{
  background:transparent !important;
  border:none !important;
  box-shadow:none !important;
}

.hero{
  padding:34px 0 18px !important;
}

/* category bar: 5 items + see more on right */
.category-strip{
  position:relative !important;
  top:auto !important;
  z-index:90 !important;
  display:flex !important;
  align-items:center !important;
  gap:14px !important;
  margin:18px 0 24px !important;
  padding:14px 16px !important;
  min-height:86px !important;
  height:auto !important;
  overflow:visible !important;
  border-radius:22px !important;
  background:color-mix(in srgb, var(--panel) 84%, transparent) !important;
  border:1px solid var(--line) !important;
  box-shadow:var(--shadow) !important;
  backdrop-filter:blur(14px) !important;
}

.category-strip.section-gap{
  margin-top:18px !important;
}

#categoryGrid,
.category-grid{
  flex:1 1 auto !important;
  min-width:0 !important;
  display:block !important;
}

.category-main-row{
  display:grid !important;
  grid-template-columns:repeat(5, minmax(0, 1fr)) !important;
  gap:12px !important;
  align-items:center !important;
}

.category-card{
  min-height:54px !important;
  height:54px !important;
  padding:0 12px !important;
  border-radius:18px !important;
  display:flex !important;
  align-items:center !important;
  justify-content:center !important;
  flex-direction:row !important;
  white-space:nowrap !important;
  background:var(--panel-2) !important;
  border:1px solid var(--line) !important;
  box-shadow:none !important;
  transform:none !important;
}

.category-card:hover,
.category-card.active{
  border-color:color-mix(in srgb, var(--accent) 42%, transparent) !important;
  background:color-mix(in srgb, var(--panel-2) 76%, var(--accent-soft)) !important;
}

.category-card small{
  display:none !important;
}

.category-card strong{
  width:100% !important;
  margin:0 !important;
  display:flex !important;
  align-items:center !important;
  justify-content:center !important;
  gap:8px !important;
  font-size:.78rem !important;
  line-height:1 !important;
  white-space:nowrap !important;
  overflow:hidden !important;
}

.cat-icon{
  flex:0 0 auto !important;
  width:18px !important;
  display:inline-flex !important;
  align-items:center !important;
  justify-content:center !important;
  opacity:.95 !important;
}

.cat-label{
  overflow:hidden !important;
  text-overflow:ellipsis !important;
}

#seeMoreBtn,
.see-more{
  display:flex !important;
  align-items:center !important;
  justify-content:center !important;
  flex:0 0 132px !important;
  width:132px !important;
  height:54px !important;
  margin-left:auto !important;
  border-radius:999px !important;
  border:1px solid color-mix(in srgb, var(--accent) 34%, transparent) !important;
  background:var(--accent-soft) !important;
  color:var(--text) !important;
  font-size:.7rem !important;
  font-weight:950 !important;
  letter-spacing:.18em !important;
  text-transform:uppercase !important;
  box-shadow:none !important;
  cursor:pointer !important;
  white-space:nowrap !important;
}

#seeMoreBtn[hidden],
.see-more[hidden]{
  display:none !important;
}

/* see more panel shows all categories */
.category-more-panel{
  position:absolute !important;
  top:calc(100% + 12px) !important;
  right:16px !important;
  width:min(760px, calc(100vw - 48px)) !important;
  padding:16px !important;
  border-radius:24px !important;
  opacity:0 !important;
  pointer-events:none !important;
  transform:translateY(-8px) scale(.985) !important;
  transition:opacity .18s ease, transform .18s ease !important;
  border:1px solid var(--line) !important;
  background:color-mix(in srgb, var(--panel) 96%, transparent) !important;
  box-shadow:0 22px 60px rgba(0,0,0,.34) !important;
  backdrop-filter:blur(18px) !important;
}

.category-strip.is-expanded .category-more-panel{
  opacity:1 !important;
  pointer-events:auto !important;
  transform:translateY(0) scale(1) !important;
}

.more-panel-title{
  margin:0 0 12px !important;
  color:var(--muted) !important;
  font-size:.68rem !important;
  font-weight:950 !important;
  letter-spacing:.18em !important;
  text-transform:uppercase !important;
}

.more-panel-grid{
  display:grid !important;
  grid-template-columns:repeat(3, minmax(0, 1fr)) !important;
  gap:10px !important;
}

.category-more-panel .category-card{
  height:52px !important;
  min-height:52px !important;
}

.category-more-panel .category-card.active{
  border-color:color-mix(in srgb, var(--accent) 50%, transparent) !important;
}

/* category/effect spacing */
.category-hero{
  margin-top:22px !important;
  min-height:230px !important;
  padding:30px !important;
  border-radius:28px !important;
}

.category-hero h1{
  font-size:clamp(2.7rem, 5.5vw, 5rem) !important;
}

.effects-stack{
  margin-top:24px !important;
  gap:24px !important;
}

.effect-box{
  min-height:330px !important;
  border-radius:28px !important;
}

.preview-zone{
  background:linear-gradient(135deg, color-mix(in srgb, var(--panel-2) 88%, transparent), color-mix(in srgb, var(--bg) 88%, transparent)) !important;
}

html[data-theme="light"] .preview-zone,
html[data-theme="light"] .source-preview .preview-zone{
  background:linear-gradient(135deg,#969188,#89847d) !important;
  border-color:rgba(70,95,35,.25) !important;
}

html[data-theme="dark"] .preview-zone,
html[data-theme="dark"] .source-preview .preview-zone{
  background:#04070d !important;
  border-color:rgba(167,233,86,.18) !important;
}

/* hide nav/category on scroll down */
.nav,
.category-strip{
  transition:transform .28s ease, opacity .22s ease !important;
  will-change:transform, opacity !important;
}

body.hide-top-bars .nav{
  transform:translateY(-120px) !important;
  opacity:0 !important;
  pointer-events:none !important;
}

body.hide-top-bars .category-strip{
  transform:translateY(-120px) !important;
  opacity:0 !important;
  pointer-events:none !important;
}

/* tablet */
@media (max-width:1060px){
  .category-main-row{
    grid-template-columns:repeat(3, minmax(0, 1fr)) !important;
  }

  .category-card strong{
    font-size:.82rem !important;
  }
}

/* phone */
@media (max-width:640px){
  .shell{
    width:min(100% - 28px, 1160px) !important;
    padding-top:12px !important;
  }

  .nav{
    margin-bottom:14px !important;
  }

  .hero{
    padding:28px 0 18px !important;
  }

  .category-strip{
    gap:10px !important;
    margin:16px 0 20px !important;
    padding:10px !important;
    min-height:72px !important;
    overflow:visible !important;
  }

  #categoryGrid,
  .category-grid{
    overflow-x:auto !important;
  }

  .category-main-row{
    display:flex !important;
    flex-wrap:nowrap !important;
    gap:10px !important;
  }

  .category-card{
    flex:0 0 auto !important;
    min-width:176px !important;
    height:50px !important;
    min-height:50px !important;
  }

  #seeMoreBtn,
  .see-more{
    flex:0 0 auto !important;
    width:auto !important;
    height:50px !important;
    padding:0 18px !important;
  }

  .category-more-panel{
    left:10px !important;
    right:10px !important;
    width:auto !important;
  }

  .more-panel-grid{
    grid-template-columns:1fr !important;
  }

  .category-hero{
    margin-top:18px !important;
    min-height:210px !important;
    padding:22px !important;
  }

  body.hide-top-bars .category-strip{
    transform:none !important;
    opacity:1 !important;
    pointer-events:auto !important;
  }
}

/* ===== COLDBOOT FINAL CLEAN + SEE MORE END ===== */
'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $finalCss)

Write-Host "6) Final checks..."

# JS syntax check if Node exists
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node ".\assets\data.js" | Out-Null
  node --check ".\assets\app.js" | Out-Null
  node --check ".\assets\fx.js" | Out-Null
}

$badHtml = Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
Select-String -Pattern "quality-theme\.css|category-clean-final\.css|category-gap-fix\.css|category-one-line\.css|category-panel\.css|ui-refresh\.css|theme-final|light-theme-fix|soft-light-final|clean-ui-final" -List

if ($badHtml) {
  $badHtml | Select-Object Path,LineNumber,Line | Format-Table -AutoSize
  throw "Old CSS/JS override links still found in HTML."
}

$seeMoreCount = (Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
Select-String -Pattern 'id="seeMoreBtn"' -AllMatches).Matches.Count

Write-Host "See More buttons found:" $seeMoreCount
Write-Host "DONE: code cleaned."
Write-Host "DONE: index now has See More too."
Write-Host "DONE: old CSS conflict blocks removed."
Write-Host "DONE: category bar uses 5 main items + See More on right."
Write-Host "DONE: See More panel shows all categories."
Write-Host "DONE: index cards/footer updated to current category/effect count."
Write-Host "Backup saved here:"
Write-Host $backup
