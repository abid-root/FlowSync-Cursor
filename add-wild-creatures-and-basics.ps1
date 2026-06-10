$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css") -or !(Test-Path ".\assets\data.js") -or !(Test-Path ".\assets\fx.js")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-add-wild-creatures-backup_$stamp"

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

function Remove-ObjectById($arr, $id) {
  return @($arr | Where-Object { $_.id -ne $id })
}

function Remove-ObjectByKey($arr, $key) {
  return @($arr | Where-Object { $_.key -ne $key })
}

Write-Host "1) Reading current data.js..."

$dataPath = ".\assets\data.js"
$dataText = Read-Utf8 $dataPath
$catMatch = [regex]::Match($dataText, 'window\.COLD_DATA\s*=\s*(\[.*?\]);', [System.Text.RegularExpressions.RegexOptions]::Singleline)
$effMatch = [regex]::Match($dataText, 'window\.COLD_EFFECTS\s*=\s*(\[.*?\]);', [System.Text.RegularExpressions.RegexOptions]::Singleline)

if (!$catMatch.Success) { throw "Cannot find window.COLD_DATA in assets/data.js" }
if (!$effMatch.Success) { throw "Cannot find window.COLD_EFFECTS in assets/data.js" }

$categories = @($catMatch.Groups[1].Value | ConvertFrom-Json)
$effects = @($effMatch.Groups[1].Value | ConvertFrom-Json)

Write-Host "Current categories:" $categories.Count
Write-Host "Current effects:" $effects.Count

Write-Host "2) Adding Wild Creatures + Classic Basics categories..."

$categories = Remove-ObjectById $categories "wild-creatures"
$categories = Remove-ObjectById $categories "classic-basics"

$wildNum = "{0:D2}" -f ($categories.Count + 1)
$classicNum = "{0:D2}" -f ($categories.Count + 2)

$wildCategory = [PSCustomObject]@{
  id = "wild-creatures"
  num = $wildNum
  title = "Wild Creatures"
  desc = "Spider, cockroach, crocodile, dragon and more animal followers using your snake physics."
  icon = "wild"
  effects = @(
    "spider-crawler",
    "cockroach-skitter",
    "crocodile-crawl",
    "mini-dragon",
    "scorpion-tail",
    "gecko-dash",
    "bat-flutter",
    "crab-walk"
  )
}

$classicCategory = [PSCustomObject]@{
  id = "classic-basics"
  num = $classicNum
  title = "Classic Basics"
  desc = "Default normal cursor helpers: dot, ring, crosshair, bracket and tiny click effects."
  icon = "basic"
  effects = @(
    "default-dot",
    "default-ring",
    "default-crosshair",
    "corner-bracket",
    "click-flash"
  )
}

$categories += $wildCategory
$categories += $classicCategory

$wildEffects = @(
  [PSCustomObject]@{
    key="spider-crawler"; name="Spider Crawler"; desc="A dark spider body follows the pointer with tiny leg motion."; kind="wild-animal";
    cat_id=$wildCategory.id; cat_num=$wildCategory.num; cat_title=$wildCategory.title; cat_desc=$wildCategory.desc; cat_icon=$wildCategory.icon; index=1;
    dark=[PSCustomObject]@{a="#a18cff";b="#5cf28b";ink="#101014"}; light=[PSCustomObject]@{a="#443864";b="#2f6848";ink="#faf8f1"}
  },
  [PSCustomObject]@{
    key="cockroach-skitter"; name="Cockroach Skitter"; desc="A fast brown roach-style follower with antennae and short shell segments."; kind="wild-animal";
    cat_id=$wildCategory.id; cat_num=$wildCategory.num; cat_title=$wildCategory.title; cat_desc=$wildCategory.desc; cat_icon=$wildCategory.icon; index=2;
    dark=[PSCustomObject]@{a="#9b6a35";b="#f0bd74";ink="#1b1009"}; light=[PSCustomObject]@{a="#4f2d13";b="#8d612f";ink="#faf8f1"}
  },
  [PSCustomObject]@{
    key="crocodile-crawl"; name="Crocodile Crawl"; desc="Green armored body pieces crawl behind the pointer like a mini crocodile."; kind="wild-animal";
    cat_id=$wildCategory.id; cat_num=$wildCategory.num; cat_title=$wildCategory.title; cat_desc=$wildCategory.desc; cat_icon=$wildCategory.icon; index=3;
    dark=[PSCustomObject]@{a="#5cf28b";b="#b9ff57";ink="#102013"}; light=[PSCustomObject]@{a="#2f6f3d";b="#687d26";ink="#faf8f1"}
  },
  [PSCustomObject]@{
    key="mini-dragon"; name="Mini Dragon"; desc="A tiny dragon with a glowing head, body chain and small wing feel."; kind="wild-animal";
    cat_id=$wildCategory.id; cat_num=$wildCategory.num; cat_title=$wildCategory.title; cat_desc=$wildCategory.desc; cat_icon=$wildCategory.icon; index=4;
    dark=[PSCustomObject]@{a="#ff7b4a";b="#c89cff";ink="#181014"}; light=[PSCustomObject]@{a="#8a3b22";b="#6b4b91";ink="#faf8f1"}
  },
  [PSCustomObject]@{
    key="scorpion-tail"; name="Scorpion Tail"; desc="Segmented scorpion tail with a sharp stinger following the cursor."; kind="wild-animal";
    cat_id=$wildCategory.id; cat_num=$wildCategory.num; cat_title=$wildCategory.title; cat_desc=$wildCategory.desc; cat_icon=$wildCategory.icon; index=5;
    dark=[PSCustomObject]@{a="#e8c27d";b="#ff8a54";ink="#17100d"}; light=[PSCustomObject]@{a="#76562a";b="#9e4427";ink="#faf8f1"}
  },
  [PSCustomObject]@{
    key="gecko-dash"; name="Gecko Dash"; desc="Small gecko-like follower with soft green body and tiny toe marks."; kind="wild-animal";
    cat_id=$wildCategory.id; cat_num=$wildCategory.num; cat_title=$wildCategory.title; cat_desc=$wildCategory.desc; cat_icon=$wildCategory.icon; index=6;
    dark=[PSCustomObject]@{a="#80ffb0";b="#70d7ff";ink="#102018"}; light=[PSCustomObject]@{a="#2e7045";b="#2e7282";ink="#faf8f1"}
  },
  [PSCustomObject]@{
    key="bat-flutter"; name="Bat Flutter"; desc="A small bat silhouette flutters after the cursor with flexible body motion."; kind="wild-animal";
    cat_id=$wildCategory.id; cat_num=$wildCategory.num; cat_title=$wildCategory.title; cat_desc=$wildCategory.desc; cat_icon=$wildCategory.icon; index=7;
    dark=[PSCustomObject]@{a="#bca8ff";b="#6b6f90";ink="#07070c"}; light=[PSCustomObject]@{a="#554b78";b="#34384f";ink="#faf8f1"}
  },
  [PSCustomObject]@{
    key="crab-walk"; name="Crab Walk"; desc="Tiny crab-like pieces walk sideways around the cursor."; kind="wild-animal";
    cat_id=$wildCategory.id; cat_num=$wildCategory.num; cat_title=$wildCategory.title; cat_desc=$wildCategory.desc; cat_icon=$wildCategory.icon; index=8;
    dark=[PSCustomObject]@{a="#ff856b";b="#ffd27a";ink="#1b110c"}; light=[PSCustomObject]@{a="#8d3b2f";b="#8c6724";ink="#faf8f1"}
  }
)

$classicEffects = @(
  [PSCustomObject]@{
    key="default-dot"; name="Default Dot"; desc="A clean dot that follows the cursor without extra noise."; kind="classic-basic";
    cat_id=$classicCategory.id; cat_num=$classicCategory.num; cat_title=$classicCategory.title; cat_desc=$classicCategory.desc; cat_icon=$classicCategory.icon; index=1;
    dark=[PSCustomObject]@{a="#f5f1e8";b="#a7e956";ink="#101014"}; light=[PSCustomObject]@{a="#22262c";b="#6f8f35";ink="#faf8f1"}
  },
  [PSCustomObject]@{
    key="default-ring"; name="Default Ring"; desc="A simple expanding cursor ring for normal UI demos."; kind="classic-basic";
    cat_id=$classicCategory.id; cat_num=$classicCategory.num; cat_title=$classicCategory.title; cat_desc=$classicCategory.desc; cat_icon=$classicCategory.icon; index=2;
    dark=[PSCustomObject]@{a="#a7e956";b="#f5f1e8";ink="#101014"}; light=[PSCustomObject]@{a="#5d7b2e";b="#20242a";ink="#faf8f1"}
  },
  [PSCustomObject]@{
    key="default-crosshair"; name="Default Crosshair"; desc="A precise crosshair mark for simple pointer preview."; kind="classic-basic";
    cat_id=$classicCategory.id; cat_num=$classicCategory.num; cat_title=$classicCategory.title; cat_desc=$classicCategory.desc; cat_icon=$classicCategory.icon; index=3;
    dark=[PSCustomObject]@{a="#d6e6ff";b="#7ec8ff";ink="#101014"}; light=[PSCustomObject]@{a="#243b59";b="#426a8c";ink="#faf8f1"}
  },
  [PSCustomObject]@{
    key="corner-bracket"; name="Corner Bracket"; desc="Four bracket corners pulse around the pointer."; kind="classic-basic";
    cat_id=$classicCategory.id; cat_num=$classicCategory.num; cat_title=$classicCategory.title; cat_desc=$classicCategory.desc; cat_icon=$classicCategory.icon; index=4;
    dark=[PSCustomObject]@{a="#c89cff";b="#f5f1e8";ink="#101014"}; light=[PSCustomObject]@{a="#5c4679";b="#24262c";ink="#faf8f1"}
  },
  [PSCustomObject]@{
    key="click-flash"; name="Click Flash"; desc="Tiny flash particles for a very simple cursor feedback style."; kind="classic-basic";
    cat_id=$classicCategory.id; cat_num=$classicCategory.num; cat_title=$classicCategory.title; cat_desc=$classicCategory.desc; cat_icon=$classicCategory.icon; index=5;
    dark=[PSCustomObject]@{a="#ffd36b";b="#a7e956";ink="#101014"}; light=[PSCustomObject]@{a="#745719";b="#55762b";ink="#faf8f1"}
  }
)

foreach ($eff in ($wildEffects + $classicEffects)) {
  $effects = Remove-ObjectByKey $effects $eff.key
  $effects += $eff
}

$dataOut = "window.COLD_DATA = " + (($categories | ConvertTo-Json -Depth 20) -replace "\\u0026", "&") + ";`r`n"
$dataOut += "window.COLD_EFFECTS = " + (($effects | ConvertTo-Json -Depth 20) -replace "\\u0026", "&") + ";`r`n"
Save-Utf8 $dataPath $dataOut

Write-Host "3) Creating wild-creatures.js handlers..."

$wildJs = @'
(function () {
  if (typeof COLD_FX === "undefined") return;

  const originalSpawn = COLD_FX.spawn.bind(COLD_FX);
  const originalClear = COLD_FX.clear ? COLD_FX.clear.bind(COLD_FX) : null;
  const stores = new WeakMap();

  const wildHandlers = new Set([
    "spider-crawler",
    "cockroach-skitter",
    "crocodile-crawl",
    "mini-dragon",
    "scorpion-tail",
    "gecko-dash",
    "bat-flutter",
    "crab-walk"
  ]);

  const classicHandlers = {
    "default-dot": defaultDot,
    "default-ring": defaultRing,
    "default-crosshair": defaultCrosshair,
    "corner-bracket": cornerBracket,
    "click-flash": clickFlash
  };

  function palette(effect) {
    const theme = document.documentElement.getAttribute("data-theme") === "light" ? "light" : "dark";
    return effect[theme] || effect.dark || { a: "#a7e956", b: "#f5f1e8", ink: "#101014" };
  }

  function rand(a, b) { return a + Math.random() * (b - a); }
  function removeAfter(el, ms) { setTimeout(() => el.remove(), ms + 60); }

  function addPiece(layer, cls, x, y, effect, text = "") {
    const p = palette(effect);
    const el = document.createElement("span");
    el.className = "fx-piece wild-basic-fx " + cls;
    el.textContent = text;
    el.style.left = x + "px";
    el.style.top = y + "px";
    el.style.setProperty("--a", p.a);
    el.style.setProperty("--b", p.b);
    el.style.setProperty("--ink", p.ink);
    layer.appendChild(el);
    return el;
  }

  function fly(el, dx, dy, ms, scale = 1, rot = 0) {
    el.style.setProperty("--dx", dx + "px");
    el.style.setProperty("--dy", dy + "px");
    el.style.setProperty("--sc", scale);
    el.style.setProperty("--rot", rot + "deg");
    el.style.animation = "wildBasicFly " + ms + "ms cubic-bezier(.16,.82,.28,1) forwards";
    removeAfter(el, ms);
  }

  function defaultDot(effect, layer, x, y) {
    const el = addPiece(layer, "wild-default-dot", x, y, effect);
    fly(el, rand(-5, 5), rand(-5, 5), 460, 1.35, 0);
  }

  function defaultRing(effect, layer, x, y) {
    const el = addPiece(layer, "wild-default-ring", x, y, effect);
    el.style.animation = "wildBasicRing 720ms ease-out forwards";
    removeAfter(el, 720);
  }

  function defaultCrosshair(effect, layer, x, y) {
    const el = addPiece(layer, "wild-default-crosshair", x, y, effect);
    fly(el, 0, 0, 560, 1, 0);
  }

  function cornerBracket(effect, layer, x, y) {
    const el = addPiece(layer, "wild-corner-bracket", x, y, effect);
    fly(el, 0, 0, 660, 1.1, 0);
  }

  function clickFlash(effect, layer, x, y) {
    for (let i = 0; i < 5; i += 1) {
      const el = addPiece(layer, "wild-click-flash", x + rand(-3, 3), y + rand(-3, 3), effect);
      fly(el, rand(-34, 34), rand(-34, 34), 620 + i * 30, 1.2, rand(-140, 140));
    }
  }

  function configFor(effect) {
    switch (effect.key) {
      case "spider-crawler":
        return { count: 9, headEase: .32, bodyEase: .28, type: "spider", hueStart: 260, hueStep: 5 };
      case "cockroach-skitter":
        return { count: 12, headEase: .36, bodyEase: .30, type: "cockroach", hueStart: 28, hueStep: 3 };
      case "crocodile-crawl":
        return { count: 20, headEase: .30, bodyEase: .26, type: "crocodile", hueStart: 116, hueStep: 2 };
      case "mini-dragon":
        return { count: 20, headEase: .34, bodyEase: .29, type: "dragon", hueStart: 18, hueStep: 9 };
      case "scorpion-tail":
        return { count: 17, headEase: .31, bodyEase: .27, type: "scorpion", hueStart: 34, hueStep: 4 };
      case "gecko-dash":
        return { count: 12, headEase: .38, bodyEase: .32, type: "gecko", hueStart: 145, hueStep: 5 };
      case "bat-flutter":
        return { count: 8, headEase: .36, bodyEase: .30, type: "bat", hueStart: 245, hueStep: 7 };
      case "crab-walk":
        return { count: 10, headEase: .33, bodyEase: .29, type: "crab", hueStart: 8, hueStep: 4 };
      default:
        return { count: 12, headEase: .32, bodyEase: .28, type: "animal", hueStart: 145, hueStep: 7 };
    }
  }

  function clearWild(layer) {
    const store = stores.get(layer);
    if (!store) return;
    store.dead = true;
    store.parts.forEach((part) => part.el.remove());
    stores.delete(layer);
  }

  function makeAnimalPart(layer, effect, cfg, index) {
    const p = palette(effect);
    const el = document.createElement("span");
    el.className =
      index === 0
        ? `wild-animal-fx wild-head wild-${cfg.type}`
        : `wild-animal-fx wild-body wild-${cfg.type}`;

    el.setAttribute("aria-hidden", "true");
    el.style.opacity = "0";
    el.style.left = "0px";
    el.style.top = "0px";
    el.style.position = "absolute";
    el.style.setProperty("--a", p.a);
    el.style.setProperty("--b", p.b);
    el.style.setProperty("--ink", p.ink);
    el.style.setProperty("--i", index);
    el.style.setProperty("--hue", cfg.hueStart + index * cfg.hueStep);
    el.style.zIndex = index === 0 ? "100060" : String(100030 - index);
    layer.appendChild(el);

    return { el, x: 0, y: 0 };
  }

  function createStore(layer, effect, x, y) {
    clearWild(layer);

    const cfg = configFor(effect);
    const parts = [];

    for (let i = 0; i < cfg.count; i += 1) {
      const part = makeAnimalPart(layer, effect, cfg, i);
      part.x = x;
      part.y = y;
      part.el.style.opacity = "1";
      parts.push(part);
    }

    const store = {
      key: effect.key,
      cfg,
      parts,
      targetX: x,
      targetY: y,
      active: true,
      dead: false
    };

    stores.set(layer, store);
    requestAnimationFrame(() => animateAnimal(layer, store));
    return store;
  }

  /*
    Same physics style as your snake:
    - head follows pointer
    - each body part follows previous body part
    - head layer stays on top
    - different animal classes make each one look different
  */
  function animateAnimal(layer, store) {
    if (store.dead || stores.get(layer) !== store) return;

    const parts = store.parts;
    const cfg = store.cfg;

    if (store.active) {
      parts[0].x += (store.targetX - parts[0].x) * cfg.headEase;
      parts[0].y += (store.targetY - parts[0].y) * cfg.headEase;

      for (let i = 1; i < parts.length; i += 1) {
        parts[i].x += (parts[i - 1].x - parts[i].x) * cfg.bodyEase;
        parts[i].y += (parts[i - 1].y - parts[i].y) * cfg.bodyEase;
      }

      parts.forEach((part, index) => {
        const next = parts[index - 1] || { x: store.targetX, y: store.targetY };
        const dx = next.x - part.x;
        const dy = next.y - part.y;
        const angle = Math.atan2(dy, dx) * (180 / Math.PI);

        part.el.style.transform = `translate3d(${part.x}px, ${part.y}px, 0) translate(-50%, -50%) rotate(${angle}deg)`;
        part.el.style.opacity = "1";
      });
    }

    requestAnimationFrame(() => animateAnimal(layer, store));
  }

  function spawnWild(effect, layer, x, y) {
    let store = stores.get(layer);
    if (!store || store.key !== effect.key) {
      store = createStore(layer, effect, x, y);
    }

    store.targetX = x;
    store.targetY = y;
    store.active = true;

    const p = palette(effect);
    store.parts.forEach((part, index) => {
      part.el.style.setProperty("--a", p.a);
      part.el.style.setProperty("--b", p.b);
      part.el.style.setProperty("--ink", p.ink);
      part.el.style.opacity = "1";
      part.el.style.zIndex = index === 0 ? "100060" : String(100030 - index);
    });
  }

  COLD_FX.spawn = function (effect, layer, x, y) {
    if (effect && wildHandlers.has(effect.key)) {
      spawnWild(effect, layer, x, y);
      return;
    }

    if (effect && classicHandlers[effect.key]) {
      classicHandlers[effect.key](effect, layer, x, y);
      return;
    }

    originalSpawn(effect, layer, x, y);
  };

  COLD_FX.clear = function (layer) {
    clearWild(layer);

    if (originalClear) originalClear(layer);
    else layer.innerHTML = "";
  };
})();
'@

Save-Utf8 ".\assets\wild-creatures.js" $wildJs

Write-Host "4) Loading wild-creatures.js after extra-cursors.js..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+wild-creatures\.js[^>]*></script>\s*', '')

  $relativeDir = $_.DirectoryName.Substring($root.Length).TrimStart('\')
  $depth = if ([string]::IsNullOrWhiteSpace($relativeDir)) { 0 } else { ($relativeDir -split '[\\/]').Count }
  $src = (('../' * $depth) + "assets/wild-creatures.js?v=$stamp").Replace('\','/')
  $tag = "  <script src=""$src""></script>"

  if ($html -match 'assets/extra-cursors\.js') {
    $html = [regex]::Replace(
      $html,
      '(?im)(^\s*<script[^>]+assets/extra-cursors\.js[^>]*></script>\s*)',
      "`$1$tag`r`n",
      1
    )
  } elseif ($html -match 'assets/fx\.js') {
    $html = [regex]::Replace(
      $html,
      '(?im)(^\s*<script[^>]+assets/fx\.js[^>]*></script>\s*)',
      "`$1$tag`r`n",
      1
    )
  } else {
    $html = $html -replace '(?i)</body>', "$tag`r`n</body>"
  }

  Save-Utf8 $_.FullName $html
}

Write-Host "5) Making wild animals update like snake physics..."

$appPath = ".\assets\app.js"
$app = Read-Utf8 $appPath

$app = [regex]::Replace(
  $app,
  '\["snake",\s*"centipede",\s*"jelly",\s*"fish"\]\.includes\(effect\.kind\)',
  '["snake", "centipede", "jelly", "fish", "wild-animal"].includes(effect.kind)'
)

Save-Utf8 $appPath $app

Write-Host "6) Adding CSS for wild animals + classic basics..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath
$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== WILD CREATURES EXTRA CURSORS START ===== \*/.*?/\* ===== WILD CREATURES EXTRA CURSORS END ===== \*/', '')

$wildCss = @'

/* ===== WILD CREATURES EXTRA CURSORS START ===== */
.wild-animal-fx{
  position:absolute !important;
  left:0;
  top:0;
  pointer-events:none !important;
  transform-origin:50% 50% !important;
  transition:opacity 120ms ease !important;
  will-change:transform, opacity !important;
  backface-visibility:hidden !important;
  contain:layout paint !important;
  width:calc(24px - (var(--i) * .45px));
  height:calc(14px - (var(--i) * .18px));
  min-width:7px;
  min-height:5px;
  border-radius:999px;
  background:linear-gradient(90deg,var(--a),var(--b));
  box-shadow:0 0 8px color-mix(in srgb, var(--b) 30%, transparent);
}

.wild-animal-fx::after{
  content:"";
  position:absolute;
  inset:24%;
  border-radius:inherit;
  background:rgba(255,255,255,.28);
}

.wild-head{
  z-index:100060 !important;
  width:32px !important;
  height:18px !important;
}

.wild-head::before{
  content:"";
  position:absolute;
  right:7px;
  top:4px;
  width:4px;
  height:4px;
  border-radius:999px;
  background:var(--ink);
  box-shadow:0 8px 0 var(--ink);
}

/* spider */
.wild-spider{
  width:calc(20px - (var(--i) * .22px));
  height:calc(16px - (var(--i) * .16px));
  border-radius:55% 45% 52% 48%;
  background:
    radial-gradient(circle at 68% 34%, var(--ink) 0 1.4px, transparent 1.7px),
    radial-gradient(circle at 68% 66%, var(--ink) 0 1.4px, transparent 1.7px),
    linear-gradient(90deg, color-mix(in srgb,var(--a) 64%,#15121f), color-mix(in srgb,var(--b) 35%,#15121f));
}
.wild-spider.wild-body::before{
  content:"";
  position:absolute;
  left:50%;
  top:50%;
  width:30px;
  height:22px;
  transform:translate(-50%,-50%);
  background:
    linear-gradient(25deg, transparent 0 44%, color-mix(in srgb,var(--a) 75%,transparent) 45% 53%, transparent 54%),
    linear-gradient(-25deg, transparent 0 44%, color-mix(in srgb,var(--a) 75%,transparent) 45% 53%, transparent 54%),
    linear-gradient(155deg, transparent 0 44%, color-mix(in srgb,var(--b) 70%,transparent) 45% 53%, transparent 54%),
    linear-gradient(-155deg, transparent 0 44%, color-mix(in srgb,var(--b) 70%,transparent) 45% 53%, transparent 54%);
  opacity:.68;
}

/* cockroach */
.wild-cockroach{
  border-radius:60% 45% 45% 60%;
  background:
    linear-gradient(90deg, color-mix(in srgb,var(--a) 80%,#241000), color-mix(in srgb,var(--b) 75%,#3a1b06));
  border:1px solid rgba(255,220,160,.16);
}
.wild-cockroach.wild-head::after{
  inset:34%;
  background:rgba(255,222,170,.24);
}
.wild-cockroach.wild-head::before{
  box-shadow:0 8px 0 var(--ink), 8px -6px 0 -1px color-mix(in srgb,var(--b) 75%,transparent), 8px 6px 0 -1px color-mix(in srgb,var(--b) 75%,transparent);
}

/* crocodile */
.wild-crocodile{
  border-radius:8px 999px 999px 8px;
  background:
    repeating-linear-gradient(90deg, rgba(255,255,255,.16) 0 3px, transparent 3px 9px),
    linear-gradient(90deg, color-mix(in srgb,var(--a) 86%,#0d2b12), color-mix(in srgb,var(--b) 78%,#1d3b0f));
}
.wild-crocodile.wild-body::before{
  content:"";
  position:absolute;
  left:20%;
  right:15%;
  top:-4px;
  height:7px;
  background:linear-gradient(135deg, transparent 0 48%, color-mix(in srgb,var(--b) 72%,transparent) 50% 70%, transparent 72%);
  background-size:10px 7px;
}
.wild-crocodile.wild-head{
  width:38px !important;
  border-radius:12px 70% 70% 12px !important;
}

/* dragon */
.wild-dragon{
  background:linear-gradient(90deg, hsl(var(--hue),92%,58%), hsl(calc(var(--hue) + 45),96%,66%));
  box-shadow:0 0 10px hsla(var(--hue),95%,64%,.32);
}
.wild-dragon.wild-head{
  width:36px !important;
  background:
    radial-gradient(circle at 70% 34%, var(--ink) 0 2px, transparent 2.3px),
    radial-gradient(circle at 70% 66%, var(--ink) 0 2px, transparent 2.3px),
    linear-gradient(90deg,#ff7b4a,#54d7ff,#c89cff) !important;
}
.wild-dragon.wild-head::after{
  content:"";
  position:absolute;
  left:7px;
  top:-10px;
  width:20px;
  height:16px;
  border-radius:90% 10% 90% 10%;
  background:rgba(200,156,255,.28);
  transform:rotate(-22deg);
}

/* scorpion */
.wild-scorpion{
  background:linear-gradient(90deg, color-mix(in srgb,var(--a) 82%,#2a1705), color-mix(in srgb,var(--b) 72%,#3a1908));
}
.wild-scorpion.wild-body{
  border-radius:48% 52% 52% 48%;
}
.wild-scorpion.wild-body::before{
  content:"";
  position:absolute;
  left:50%;
  top:-5px;
  width:8px;
  height:8px;
  border-top:2px solid color-mix(in srgb,var(--b) 75%,transparent);
  border-right:2px solid color-mix(in srgb,var(--b) 75%,transparent);
  transform:translateX(-50%) rotate(-45deg);
  opacity:.6;
}

/* gecko */
.wild-gecko{
  background:linear-gradient(90deg, color-mix(in srgb,var(--a) 78%,#0d2a16), color-mix(in srgb,var(--b) 55%,#10343a));
}
.wild-gecko.wild-body::before{
  content:"";
  position:absolute;
  left:50%;
  top:50%;
  width:34px;
  height:22px;
  transform:translate(-50%,-50%);
  background:
    radial-gradient(circle at 10% 15%, var(--a) 0 2px, transparent 2.4px),
    radial-gradient(circle at 10% 85%, var(--a) 0 2px, transparent 2.4px),
    radial-gradient(circle at 90% 15%, var(--b) 0 2px, transparent 2.4px),
    radial-gradient(circle at 90% 85%, var(--b) 0 2px, transparent 2.4px);
  opacity:.62;
}

/* bat */
.wild-bat{
  border-radius:999px;
  background:linear-gradient(90deg, color-mix(in srgb,var(--a) 60%,#08080f), color-mix(in srgb,var(--b) 45%,#07070f));
}
.wild-bat.wild-head::after,
.wild-bat.wild-body::after{
  content:"";
  position:absolute;
  left:50%;
  top:50%;
  width:38px;
  height:20px;
  transform:translate(-50%,-50%);
  background:
    radial-gradient(ellipse at 20% 50%, color-mix(in srgb,var(--a) 50%,transparent) 0 45%, transparent 48%),
    radial-gradient(ellipse at 80% 50%, color-mix(in srgb,var(--a) 50%,transparent) 0 45%, transparent 48%);
  opacity:.72;
}

/* crab */
.wild-crab{
  border-radius:45% 55% 55% 45%;
  background:linear-gradient(90deg, color-mix(in srgb,var(--a) 78%,#3a0f0a), color-mix(in srgb,var(--b) 70%,#5a2e0b));
}
.wild-crab.wild-head::after{
  content:"";
  position:absolute;
  left:50%;
  top:50%;
  width:40px;
  height:22px;
  transform:translate(-50%,-50%);
  background:
    radial-gradient(circle at 5% 50%, color-mix(in srgb,var(--a) 74%,transparent) 0 5px, transparent 5.4px),
    radial-gradient(circle at 95% 50%, color-mix(in srgb,var(--b) 74%,transparent) 0 5px, transparent 5.4px);
}

/* classic basics */
.wild-basic-fx{
  position:absolute;
  pointer-events:none;
  color:var(--a);
  border-color:var(--a);
  transform:translate(-50%,-50%);
}

.wild-default-dot{
  width:12px;
  height:12px;
  border-radius:999px;
  background:var(--a);
  box-shadow:0 0 14px color-mix(in srgb,var(--a) 42%,transparent);
}

.wild-default-ring{
  width:54px;
  height:54px;
  border:2px solid var(--a);
  border-radius:999px;
}

.wild-default-crosshair{
  width:34px;
  height:34px;
}
.wild-default-crosshair::before,
.wild-default-crosshair::after{
  content:"";
  position:absolute;
  background:var(--a);
  border-radius:999px;
}
.wild-default-crosshair::before{left:50%;top:0;width:2px;height:100%;transform:translateX(-50%)}
.wild-default-crosshair::after{left:0;top:50%;width:100%;height:2px;transform:translateY(-50%)}

.wild-corner-bracket{
  width:42px;
  height:42px;
  border-radius:9px;
  background:
    linear-gradient(var(--a),var(--a)) left top/14px 2px no-repeat,
    linear-gradient(var(--a),var(--a)) left top/2px 14px no-repeat,
    linear-gradient(var(--a),var(--a)) right top/14px 2px no-repeat,
    linear-gradient(var(--a),var(--a)) right top/2px 14px no-repeat,
    linear-gradient(var(--a),var(--a)) left bottom/14px 2px no-repeat,
    linear-gradient(var(--a),var(--a)) left bottom/2px 14px no-repeat,
    linear-gradient(var(--a),var(--a)) right bottom/14px 2px no-repeat,
    linear-gradient(var(--a),var(--a)) right bottom/2px 14px no-repeat;
}

.wild-click-flash{
  width:8px;
  height:8px;
  border-radius:2px;
  background:var(--a);
}

@keyframes wildBasicFly{
  0%{opacity:0;transform:translate(-50%,-50%) scale(.72) rotate(0deg)}
  16%{opacity:.96}
  100%{opacity:0;transform:translate(-50%,-50%) translate(var(--dx),var(--dy)) scale(var(--sc)) rotate(var(--rot))}
}

@keyframes wildBasicRing{
  0%{opacity:.85;transform:translate(-50%,-50%) scale(.32)}
  100%{opacity:0;transform:translate(-50%,-50%) scale(1.35)}
}
/* ===== WILD CREATURES EXTRA CURSORS END ===== */
'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $wildCss)

Write-Host "7) Creating category and source pages..."

New-Item -ItemType Directory -Path ".\categories" -Force | Out-Null
New-Item -ItemType Directory -Path ".\sources" -Force | Out-Null

function ScriptsFor($prefix) {
  return @"
  <script src="$($prefix)assets/data.js"></script>
  <script src="$($prefix)assets/fx.js"></script>
  <script src="$($prefix)assets/final-site-snake-physics.js"></script>
  <script src="$($prefix)assets/extra-cursors.js"></script>
  <script src="$($prefix)assets/wild-creatures.js"></script>
  <script src="$($prefix)assets/app.js"></script>
"@
}

function MakeCategoryPage($cat, $catEffects) {
  $sections = ""
  foreach ($eff in $catEffects) {
    $pill = HtmlSafe ("$($eff.cat_num)." + ("{0:D2}" -f [int]$eff.index) + " / $($eff.key)")
    $key = HtmlSafe $eff.key
    $name = HtmlSafe $eff.name
    $desc = HtmlSafe $eff.desc
    $sections += @"
      <section class="effect-box" data-effect="$key">
        <div class="fx-layer" aria-hidden="true"></div>
        <div class="effect-content">
          <span class="pill">$pill</span>
          <h2>$name</h2>
          <p>$desc</p>
          <span class="preview-note">Move cursor inside preview</span>
        </div>
        <div class="preview-zone" aria-hidden="true"></div>
        <a class="source-link" href="../sources/$key.html">See source code</a>
      </section>

"@
  }

  $html = @"
<!doctype html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex,nofollow">
  <title>$(HtmlSafe $cat.title) | Coldboot Cursor Library</title>
  <link rel="stylesheet" href="../assets/style.css">
</head>
<body>
  <div class="shell">
    <header class="nav">
      <a class="brand" href="../index.html"><span class="brand-dot"></span>Coldboot</a>
      <nav class="nav-links">
        <a href="../index.html">Home</a>
        <a href="#effects">Effects</a>
        <a href="#categories">Categories</a>
        <button class="theme-toggle" data-theme-toggle type="button" aria-label="Toggle theme">&#9789;</button>
      </nav>
    </header>

    <section class="category-strip" id="categories">
      <div class="category-grid" id="categoryGrid"></div>
      <button class="see-more" id="seeMoreBtn" type="button" aria-expanded="false">See more</button>
    </section>

    <section class="category-hero">
      <div class="text">
        <span class="pill">$(HtmlSafe $cat.num) / category</span>
        <h1>$(HtmlSafe $cat.title)</h1>
        <p>$(HtmlSafe $cat.desc)</p>
      </div>
    </section>

    <section class="effects-stack section-gap" id="effects">
$sections    </section>

    <footer>$(HtmlSafe $cat.title). Move the cursor inside each preview.</footer>
  </div>
$(ScriptsFor "../")  <script>initCategoryPage("$(HtmlSafe $cat.id)");</script>
</body>
</html>
"@

  Save-Utf8 ".\categories\$($cat.id).html" $html
}

function MakeSourcePage($eff) {
  $key = HtmlSafe $eff.key
  $name = HtmlSafe $eff.name
  $desc = HtmlSafe $eff.desc
  $catId = HtmlSafe $eff.cat_id

  $html = @"
<!doctype html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex,nofollow">
  <title>$name | Source Code</title>
  <link rel="stylesheet" href="../assets/style.css">
</head>
<body>
  <div class="shell">
    <header class="nav">
      <a class="brand" href="../index.html"><span class="brand-dot"></span>Coldboot</a>
      <nav class="nav-links">
        <a href="../categories/$catId.html">Back</a>
        <a href="#preview">Preview</a>
        <a href="#code">Code</a>
        <button class="theme-toggle" data-theme-toggle type="button" aria-label="Toggle theme">&#9789;</button>
      </nav>
    </header>

    <section class="category-hero">
      <div class="text">
        <span class="pill">source</span>
        <h1>$name</h1>
        <p>$desc</p>
      </div>
    </section>

    <section class="source-preview section-gap" id="sourcePreview" data-effect="$key">
      <div class="fx-layer" aria-hidden="true"></div>
      <div class="preview-zone" aria-hidden="true"></div>
    </section>

    <section class="code-card section-gap" id="code">
      <div class="code-head">
        <div>
          <span class="pill">copy source</span>
          <h2>Use this effect</h2>
        </div>
        <button class="copy-btn" id="copyAll" type="button">Copy all</button>
      </div>

      <div class="code-tabs">
        <button class="code-tab active" data-tab="html" type="button">HTML</button>
        <button class="code-tab" data-tab="css" type="button">CSS</button>
        <button class="code-tab" data-tab="js" type="button">JS</button>
      </div>

      <pre class="code-pane" data-code="html"><code>&lt;section class=&quot;cursor-demo&quot; data-cursor-effect=&quot;$key&quot;&gt;
  &lt;div class=&quot;fx-layer&quot; aria-hidden=&quot;true&quot;&gt;&lt;/div&gt;
&lt;/section&gt;</code></pre>
      <pre class="code-pane" data-code="css" hidden><code>.cursor-demo {
  position: relative;
  min-height: 320px;
  overflow: hidden;
  border-radius: 24px;
}

.fx-layer {
  position: absolute;
  inset: 0;
  pointer-events: none;
}</code></pre>
      <pre class="code-pane" data-code="js" hidden><code>const effect = COLD_EFFECTS.find((item) =&gt; item.key === &quot;$key&quot;);
const target = document.querySelector(&quot;[data-cursor-effect=&#39;$key&#39;]&quot;);
const layer = target.querySelector(&quot;.fx-layer&quot;);

target.addEventListener(&quot;pointermove&quot;, (event) =&gt; {
  const rect = layer.getBoundingClientRect();
  COLD_FX.spawn(effect, layer, event.clientX - rect.left, event.clientY - rect.top);
});</code></pre>
    </section>

    <footer>Theme-aware palettes are included in assets/data.js.</footer>
  </div>
$(ScriptsFor "../")  <script>initSourcePage("$key");</script>
</body>
</html>
"@

  Save-Utf8 ".\sources\$($eff.key).html" $html
}

foreach ($cat in @($wildCategory, $classicCategory)) {
  $catEffects = @($effects | Where-Object { $cat.effects -contains $_.key } | Sort-Object index)
  MakeCategoryPage $cat $catEffects
  foreach ($eff in $catEffects) {
    MakeSourcePage $eff
  }
}

Write-Host "8) Updating index category cards and footer..."

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

Write-Host "9) Final syntax check..."

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node ".\assets\data.js" | Out-Null
  node --check ".\assets\app.js" | Out-Null
  node --check ".\assets\fx.js" | Out-Null
  node --check ".\assets\extra-cursors.js" | Out-Null
  node --check ".\assets\final-site-snake-physics.js" | Out-Null
  node --check ".\assets\wild-creatures.js" | Out-Null
}

Write-Host "DONE: Added Wild Creatures category."
Write-Host "DONE: Added Classic Basics category."
Write-Host "DONE: Added spider, cockroach, crocodile, dragon, scorpion, gecko, bat, crab."
Write-Host "DONE: Added 5 simple/default cursor effects."
Write-Host "DONE: Wild animals use the same snake-style physics: head follows cursor, body follows previous part."
Write-Host "DONE: Existing good snake physics is untouched."
Write-Host "Backup saved here:"
Write-Host $backup
