$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets") -or !(Test-Path ".\categories") -or !(Test-Path ".\sources")) {
  throw "Wrong folder. Run this script inside your flowsync-cursor-library project root."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-quality-cursors-backup_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Write-Utf8File($Path, $Text) {
  [System.IO.File]::WriteAllText($Path, $Text, $script:utf8NoBom)
}

function HtmlSafe($Value) {
  return [System.Net.WebUtility]::HtmlEncode([string]$Value)
}

$catalogJson = @'
[
  {
    "id": "particles",
    "num": "01",
    "title": "Particle Craft",
    "desc": "Small material effects with different shapes, weight and motion.",
    "icon": "*",
    "effects": [
      {
        "key": "ember-constellation",
        "name": "Ember Constellation",
        "desc": "Dots connect into a tiny star map, then break apart.",
        "kind": "constellation",
        "dark": {
          "a": "#ffb454",
          "b": "#ff6b6b",
          "ink": "#fff3d6"
        },
        "light": {
          "a": "#9a5b16",
          "b": "#c76f2d",
          "ink": "#28180a"
        }
      },
      {
        "key": "pixel-crack",
        "name": "Pixel Crack",
        "desc": "A clean grid fracture that snaps outward from the cursor.",
        "kind": "pixel-crack",
        "dark": {
          "a": "#7dd3fc",
          "b": "#a7e956",
          "ink": "#effaff"
        },
        "light": {
          "a": "#1f6f8b",
          "b": "#4e7f18",
          "ink": "#0d232a"
        }
      },
      {
        "key": "glass-manta",
        "name": "Glass Manta",
        "desc": "Transparent shard fins slide like a tiny glass creature.",
        "kind": "glass-manta",
        "dark": {
          "a": "#c7f9ff",
          "b": "#8bd8ff",
          "ink": "#ffffff"
        },
        "light": {
          "a": "#426a73",
          "b": "#577f8c",
          "ink": "#102126"
        }
      },
      {
        "key": "pollen-orbit",
        "name": "Pollen Orbit",
        "desc": "Organic pollen dots circle once before drifting away.",
        "kind": "pollen-orbit",
        "dark": {
          "a": "#b7ff54",
          "b": "#ffe66d",
          "ink": "#f8ffe9"
        },
        "light": {
          "a": "#6f8f20",
          "b": "#99751d",
          "ink": "#213006"
        }
      },
      {
        "key": "ash-spiral",
        "name": "Ash Spiral",
        "desc": "Muted ash flakes fall in a small twisting column.",
        "kind": "ash-spiral",
        "dark": {
          "a": "#c8c2b4",
          "b": "#77736b",
          "ink": "#f2ede4"
        },
        "light": {
          "a": "#5e5a52",
          "b": "#8a8174",
          "ink": "#211f1b"
        }
      },
      {
        "key": "micro-snow",
        "name": "Micro Snow",
        "desc": "Cold soft grains fall slowly with side wind.",
        "kind": "micro-snow",
        "dark": {
          "a": "#d8f5ff",
          "b": "#9ad7ff",
          "ink": "#ffffff"
        },
        "light": {
          "a": "#426d7d",
          "b": "#6c93a3",
          "ink": "#0d2228"
        }
      }
    ]
  },
  {
    "id": "trails",
    "num": "02",
    "title": "Signature Trails",
    "desc": "Cursor marks that leave readable motion instead of random dots.",
    "icon": "~",
    "effects": [
      {
        "key": "ribbon-weave",
        "name": "Ribbon Weave",
        "desc": "Short woven ribbons alternate direction behind the pointer.",
        "kind": "ribbon-weave",
        "dark": {
          "a": "#ff7ac8",
          "b": "#a78bfa",
          "ink": "#fff1fb"
        },
        "light": {
          "a": "#8e2f66",
          "b": "#5540a6",
          "ink": "#25111e"
        }
      },
      {
        "key": "ink-comet",
        "name": "Ink Comet",
        "desc": "A dark ink head drags a soft brush tail.",
        "kind": "ink-comet",
        "dark": {
          "a": "#f5f1e8",
          "b": "#6ee7b7",
          "ink": "#101319"
        },
        "light": {
          "a": "#1b1e24",
          "b": "#3c6f5b",
          "ink": "#08090b"
        }
      },
      {
        "key": "ghost-frames",
        "name": "Ghost Frames",
        "desc": "Delayed rectangular afterimages fade like animation frames.",
        "kind": "ghost-frames",
        "dark": {
          "a": "#a7e956",
          "b": "#6ee7ff",
          "ink": "#f8ffe7"
        },
        "light": {
          "a": "#597b20",
          "b": "#237383",
          "ink": "#142306"
        }
      },
      {
        "key": "stitch-thread",
        "name": "Stitch Thread",
        "desc": "Tiny dashed stitches sew the cursor path.",
        "kind": "stitch-thread",
        "dark": {
          "a": "#facc15",
          "b": "#fb7185",
          "ink": "#fff7d1"
        },
        "light": {
          "a": "#8a6a00",
          "b": "#9b3146",
          "ink": "#2b2100"
        }
      },
      {
        "key": "comet-scratch",
        "name": "Comet Scratch",
        "desc": "A sharp scratch line cuts through with grain sparks.",
        "kind": "comet-scratch",
        "dark": {
          "a": "#ffffff",
          "b": "#ff9f1c",
          "ink": "#fff4dd"
        },
        "light": {
          "a": "#2b2b2b",
          "b": "#a85d00",
          "ink": "#151515"
        }
      },
      {
        "key": "halo-breath",
        "name": "Halo Breath",
        "desc": "Two breathing halos expand at different speeds.",
        "kind": "halo-breath",
        "dark": {
          "a": "#93c5fd",
          "b": "#c4b5fd",
          "ink": "#eff6ff"
        },
        "light": {
          "a": "#315f99",
          "b": "#66519a",
          "ink": "#14223a"
        }
      }
    ]
  },
  {
    "id": "organic",
    "num": "03",
    "title": "Organic Followers",
    "desc": "Creature-like cursor followers with body, rhythm and character.",
    "icon": "o",
    "effects": [
      {
        "key": "bone-orbit",
        "name": "Bone Orbit",
        "desc": "A segmented ivory spine follows with slight side swing.",
        "kind": "bone-orbit",
        "dark": {
          "a": "#f2ede4",
          "b": "#b9ff57",
          "ink": "#ffffff"
        },
        "light": {
          "a": "#433f37",
          "b": "#6f8f35",
          "ink": "#171511"
        }
      },
      {
        "key": "jelly-chain",
        "name": "Jelly Chain",
        "desc": "Transparent jelly bubbles stretch into a soft tail.",
        "kind": "jelly-chain",
        "dark": {
          "a": "#67e8f9",
          "b": "#a7f3d0",
          "ink": "#ecfeff"
        },
        "light": {
          "a": "#26717a",
          "b": "#3d8064",
          "ink": "#0c2528"
        }
      },
      {
        "key": "firefly-swarm",
        "name": "Firefly Swarm",
        "desc": "Warm living lights gather, blink, then separate.",
        "kind": "firefly-swarm",
        "dark": {
          "a": "#fef08a",
          "b": "#bef264",
          "ink": "#fffbe6"
        },
        "light": {
          "a": "#8a7009",
          "b": "#66840e",
          "ink": "#2d2502"
        }
      },
      {
        "key": "leaf-cut",
        "name": "Leaf Cut",
        "desc": "Tiny leaf blades rotate and glide like cut paper.",
        "kind": "leaf-cut",
        "dark": {
          "a": "#86efac",
          "b": "#22c55e",
          "ink": "#f0fff4"
        },
        "light": {
          "a": "#2f6b3b",
          "b": "#28703d",
          "ink": "#092313"
        }
      },
      {
        "key": "bubble-ladder",
        "name": "Bubble Ladder",
        "desc": "Bubbles climb in a vertical chain with changing size.",
        "kind": "bubble-ladder",
        "dark": {
          "a": "#bae6fd",
          "b": "#7dd3fc",
          "ink": "#f0f9ff"
        },
        "light": {
          "a": "#39708c",
          "b": "#4b90a8",
          "ink": "#10242d"
        }
      },
      {
        "key": "larva-blink",
        "name": "Larva Blink",
        "desc": "A tiny soft larva tail follows and blinks.",
        "kind": "larva-blink",
        "dark": {
          "a": "#f0abfc",
          "b": "#f9a8d4",
          "ink": "#fff0fb"
        },
        "light": {
          "a": "#8b3e8f",
          "b": "#9a476f",
          "ink": "#30122d"
        }
      }
    ]
  },
  {
    "id": "fluid",
    "num": "04",
    "title": "Fluid Surfaces",
    "desc": "Smoke, water and membrane effects with slower premium motion.",
    "icon": "()",
    "effects": [
      {
        "key": "smoke-fold",
        "name": "Smoke Fold",
        "desc": "Layered smoke folds roll away from the cursor.",
        "kind": "smoke-fold",
        "dark": {
          "a": "#d1d5db",
          "b": "#94a3b8",
          "ink": "#f8fafc"
        },
        "light": {
          "a": "#5e6570",
          "b": "#777f8d",
          "ink": "#1e232b"
        }
      },
      {
        "key": "oil-membrane",
        "name": "Oil Membrane",
        "desc": "Iridescent cells stretch like thin oil on glass.",
        "kind": "oil-membrane",
        "dark": {
          "a": "#38bdf8",
          "b": "#fb7185",
          "ink": "#f0f9ff"
        },
        "light": {
          "a": "#146b8f",
          "b": "#93445a",
          "ink": "#092432"
        }
      },
      {
        "key": "water-ripple",
        "name": "Water Ripple",
        "desc": "A ripple expands while small droplets jump outward.",
        "kind": "water-ripple",
        "dark": {
          "a": "#5eead4",
          "b": "#67e8f9",
          "ink": "#ecfeff"
        },
        "light": {
          "a": "#247b70",
          "b": "#267884",
          "ink": "#082a27"
        }
      },
      {
        "key": "vapor-knot",
        "name": "Vapor Knot",
        "desc": "Two soft vapor loops cross and fade.",
        "kind": "vapor-knot",
        "dark": {
          "a": "#c4b5fd",
          "b": "#f0abfc",
          "ink": "#faf5ff"
        },
        "light": {
          "a": "#6251a2",
          "b": "#85458d",
          "ink": "#20153b"
        }
      },
      {
        "key": "plasma-blob",
        "name": "Plasma Blob",
        "desc": "Bright plasma cells pop with a liquid edge.",
        "kind": "plasma-blob",
        "dark": {
          "a": "#f97316",
          "b": "#ec4899",
          "ink": "#fff7ed"
        },
        "light": {
          "a": "#a34108",
          "b": "#9d2b66",
          "ink": "#2c1102"
        }
      },
      {
        "key": "mist-window",
        "name": "Mist Window",
        "desc": "Blurred glass panels drift like fogged UI windows.",
        "kind": "mist-window",
        "dark": {
          "a": "#e0f2fe",
          "b": "#99f6e4",
          "ink": "#ffffff"
        },
        "light": {
          "a": "#526a73",
          "b": "#5d837b",
          "ink": "#111f22"
        }
      }
    ]
  },
  {
    "id": "data-ui",
    "num": "05",
    "title": "Data UI Marks",
    "desc": "Developer-friendly effects using code, keys and interface objects.",
    "icon": "[]",
    "effects": [
      {
        "key": "code-scramble",
        "name": "Code Scramble",
        "desc": "Syntax chips scatter with small code labels.",
        "kind": "code-scramble",
        "dark": {
          "a": "#a7e956",
          "b": "#60a5fa",
          "ink": "#f5ffe5"
        },
        "light": {
          "a": "#577c1f",
          "b": "#245e9f",
          "ink": "#132506"
        }
      },
      {
        "key": "terminal-caret",
        "name": "Terminal Caret",
        "desc": "Caret blocks step forward like a command prompt.",
        "kind": "terminal-caret",
        "dark": {
          "a": "#22c55e",
          "b": "#bbf7d0",
          "ink": "#ecfdf5"
        },
        "light": {
          "a": "#147334",
          "b": "#3e7b51",
          "ink": "#062111"
        }
      },
      {
        "key": "binary-rain",
        "name": "Binary Rain",
        "desc": "Small 0/1 columns drop and dissolve.",
        "kind": "binary-rain",
        "dark": {
          "a": "#4ade80",
          "b": "#a7f3d0",
          "ink": "#f0fdf4"
        },
        "light": {
          "a": "#237944",
          "b": "#42795d",
          "ink": "#071f11"
        }
      },
      {
        "key": "bracket-lock",
        "name": "Bracket Lock",
        "desc": "Four brackets snap around the pointer like a focus lock.",
        "kind": "bracket-lock",
        "dark": {
          "a": "#f472b6",
          "b": "#93c5fd",
          "ink": "#fff1f8"
        },
        "light": {
          "a": "#9c3f79",
          "b": "#37659c",
          "ink": "#2b1022"
        }
      },
      {
        "key": "keycap-pop",
        "name": "Keycap Pop",
        "desc": "Mini keycaps jump with real keyboard-card feeling.",
        "kind": "keycap-pop",
        "dark": {
          "a": "#f5f1e8",
          "b": "#a7e956",
          "ink": "#111827"
        },
        "light": {
          "a": "#282828",
          "b": "#5f7f1e",
          "ink": "#111111"
        }
      },
      {
        "key": "card-stack",
        "name": "Card Stack",
        "desc": "Tiny UI cards fan out from the cursor.",
        "kind": "card-stack",
        "dark": {
          "a": "#e9d5ff",
          "b": "#a5b4fc",
          "ink": "#faf5ff"
        },
        "light": {
          "a": "#6e5395",
          "b": "#53639a",
          "ink": "#211536"
        }
      }
    ]
  },
  {
    "id": "light-physics",
    "num": "06",
    "title": "Light Physics",
    "desc": "Sharper energy effects with visible physics-based direction.",
    "icon": "//",
    "effects": [
      {
        "key": "laser-slicer",
        "name": "Laser Slicer",
        "desc": "A clean laser slice crosses with a small flash point.",
        "kind": "laser-slicer",
        "dark": {
          "a": "#ef4444",
          "b": "#fef2f2",
          "ink": "#fff1f1"
        },
        "light": {
          "a": "#9b1c1c",
          "b": "#3a1414",
          "ink": "#2b0808"
        }
      },
      {
        "key": "prism-split",
        "name": "Prism Split",
        "desc": "Three color rays split from one cursor point.",
        "kind": "prism-split",
        "dark": {
          "a": "#60a5fa",
          "b": "#f472b6",
          "ink": "#fef08a"
        },
        "light": {
          "a": "#255da0",
          "b": "#9c3f79",
          "ink": "#8a7009"
        }
      },
      {
        "key": "scan-radar",
        "name": "Scan Radar",
        "desc": "Radar arcs sweep out from the pointer.",
        "kind": "scan-radar",
        "dark": {
          "a": "#34d399",
          "b": "#67e8f9",
          "ink": "#ecfdf5"
        },
        "light": {
          "a": "#1b7a5a",
          "b": "#287884",
          "ink": "#09291e"
        }
      },
      {
        "key": "orbit-satellite",
        "name": "Orbit Satellite",
        "desc": "Small satellites circle a central cursor core.",
        "kind": "orbit-satellite",
        "dark": {
          "a": "#facc15",
          "b": "#38bdf8",
          "ink": "#fffbea"
        },
        "light": {
          "a": "#8a6a00",
          "b": "#146b8f",
          "ink": "#2b2200"
        }
      },
      {
        "key": "magnetic-pebbles",
        "name": "Magnetic Pebbles",
        "desc": "Pebbles pull inward as if the cursor has gravity.",
        "kind": "magnetic-pebbles",
        "dark": {
          "a": "#c084fc",
          "b": "#22d3ee",
          "ink": "#faf5ff"
        },
        "light": {
          "a": "#7747a6",
          "b": "#147b8c",
          "ink": "#241136"
        }
      },
      {
        "key": "gravity-sparks",
        "name": "Gravity Sparks",
        "desc": "Sparks drop downward with heavier gravity motion.",
        "kind": "gravity-sparks",
        "dark": {
          "a": "#fb923c",
          "b": "#fde68a",
          "ink": "#fff7ed"
        },
        "light": {
          "a": "#9a4c12",
          "b": "#8a7009",
          "ink": "#2a1302"
        }
      }
    ]
  }
]
'@
$fxJs = @'

const COLD_FX = (() => {
  const live = new WeakMap();
  let stylesReady = false;

  const rand = (a, b) => a + Math.random() * (b - a);
  const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];
  const clamp = (n, a, b) => Math.max(a, Math.min(b, n));

  function injectStyles() {
    if (stylesReady) return;
    stylesReady = true;
    const style = document.createElement("style");
    style.textContent = `
.fx-layer{position:absolute;inset:0;overflow:hidden;pointer-events:none;z-index:2}
.fx-piece,.fx-live{position:absolute;left:0;top:0;pointer-events:none;will-change:transform,opacity,filter}
.fx-dot{width:var(--s,10px);height:var(--s,10px);border-radius:999px;background:var(--a);box-shadow:0 0 var(--glow,12px) color-mix(in srgb,var(--a) 46%,transparent)}
.fx-square{width:var(--s,10px);height:var(--s,10px);border-radius:var(--r,2px);background:var(--a)}
.fx-line{width:var(--w,70px);height:var(--h,2px);border-radius:999px;background:linear-gradient(90deg,transparent,var(--a),var(--b),transparent);box-shadow:0 0 var(--glow,16px) color-mix(in srgb,var(--a) 42%,transparent)}
.fx-ring{width:var(--s,48px);height:var(--s,48px);border:var(--bw,2px) solid var(--a);border-radius:999px;box-shadow:0 0 var(--glow,16px) color-mix(in srgb,var(--a) 28%,transparent)}
.fx-rect-ring{width:var(--w,52px);height:var(--h,34px);border:2px solid var(--a);border-radius:12px;background:rgba(255,255,255,.025);backdrop-filter:blur(2px)}
.fx-text{font-family:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;font-weight:950;font-size:var(--s,15px);line-height:1;color:var(--a);text-shadow:0 0 12px color-mix(in srgb,var(--a) 42%,transparent)}
.fx-key{min-width:34px;height:27px;padding:0 9px;display:grid;place-items:center;border:1px solid color-mix(in srgb,var(--a) 40%,rgba(255,255,255,.14));border-radius:8px;background:color-mix(in srgb,var(--ink) 12%,rgba(255,255,255,.08));color:var(--ink);font-family:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;font-size:11px;font-weight:950;box-shadow:0 8px 18px rgba(0,0,0,.16)}
.fx-blob{width:var(--s,54px);height:calc(var(--s,54px)*.72);border-radius:58% 42% 54% 46%;background:radial-gradient(circle at 35% 28%,rgba(255,255,255,.38),transparent 25%),linear-gradient(135deg,var(--a),var(--b));filter:blur(var(--blur,2px));opacity:.9}
.fx-smoke{width:var(--s,62px);height:var(--s,62px);border-radius:999px;background:radial-gradient(circle, color-mix(in srgb,var(--a) 36%,transparent), transparent 66%);filter:blur(11px)}
.fx-shard{width:0;height:0;border-left:var(--s,12px) solid transparent;border-right:calc(var(--s,12px)*.48) solid transparent;border-bottom:calc(var(--s,12px)*1.75) solid color-mix(in srgb,var(--a) 58%,transparent);filter:drop-shadow(0 0 8px color-mix(in srgb,var(--a) 30%,transparent))}
.fx-leaf{width:var(--w,22px);height:var(--h,11px);border-radius:90% 12% 90% 12%;background:linear-gradient(135deg,var(--a),var(--b));box-shadow:inset 0 0 0 1px rgba(255,255,255,.16)}
.fx-card{width:var(--w,46px);height:var(--h,30px);border-radius:10px;border:1px solid color-mix(in srgb,var(--a) 36%,rgba(255,255,255,.16));background:linear-gradient(135deg,color-mix(in srgb,var(--a) 18%,rgba(255,255,255,.10)),color-mix(in srgb,var(--b) 14%,rgba(0,0,0,.08)));box-shadow:0 10px 22px rgba(0,0,0,.16)}
.fx-bone{width:var(--w,23px);height:var(--h,10px);border-radius:999px;background:var(--a);border:1px solid color-mix(in srgb,var(--b) 42%,rgba(0,0,0,.18));box-shadow:0 0 9px color-mix(in srgb,var(--b) 22%,transparent)}
.fx-jelly{width:var(--s,22px);height:var(--s,22px);border-radius:44% 56% 62% 38%;background:radial-gradient(circle at 30% 25%,rgba(255,255,255,.52),transparent 24%),color-mix(in srgb,var(--a) 42%,transparent);border:1px solid color-mix(in srgb,var(--a) 55%,transparent);backdrop-filter:blur(2px)}
@keyframes fxDrift{0%{opacity:0;transform:translate(-50%,-50%) scale(.65) rotate(0deg)}12%{opacity:var(--op,.95)}100%{opacity:0;transform:translate(-50%,-50%) translate(var(--dx),var(--dy)) scale(var(--sc,1.4)) rotate(var(--rot,0deg))}}
@keyframes fxCrack{0%{opacity:0;transform:translate(-50%,-50%) scale(.2)}10%{opacity:1}55%{opacity:.9}100%{opacity:0;transform:translate(-50%,-50%) translate(var(--dx),var(--dy)) rotate(var(--rot)) scale(.72)}}
@keyframes fxRing{0%{opacity:.0;transform:translate(-50%,-50%) scale(.18)}10%{opacity:.78}100%{opacity:0;transform:translate(-50%,-50%) scale(var(--sc,2.4))}}
@keyframes fxFall{0%{opacity:0;transform:translate(-50%,-50%) scale(.5) rotate(0)}12%{opacity:.9}100%{opacity:0;transform:translate(-50%,-50%) translate(var(--dx),var(--dy)) scale(var(--sc,1)) rotate(var(--rot,90deg))}}
@keyframes fxSlide{0%{opacity:0;transform:translate(-50%,-50%) rotate(var(--rot)) scaleX(.12)}12%{opacity:.95}100%{opacity:0;transform:translate(-50%,-50%) translate(var(--dx),var(--dy)) rotate(var(--rot)) scaleX(1)}}
@keyframes fxPop{0%{opacity:0;transform:translate(-50%,-50%) translateY(9px) scale(.6)}16%{opacity:1}100%{opacity:0;transform:translate(-50%,-50%) translate(var(--dx),var(--dy)) scale(var(--sc,1.15)) rotate(var(--rot))}}
@keyframes fxMagnet{0%{opacity:0;transform:translate(-50%,-50%) translate(var(--dx),var(--dy)) scale(1.05)}18%{opacity:.95}100%{opacity:0;transform:translate(-50%,-50%) scale(.08)}}
@keyframes fxOrbit{0%{opacity:0;transform:translate(-50%,-50%) rotate(0deg) translateX(var(--rad,24px)) scale(.75)}12%{opacity:.95}100%{opacity:0;transform:translate(-50%,-50%) rotate(var(--turn,260deg)) translateX(var(--rad,24px)) scale(.2)}}
@keyframes fxBlink{0%,100%{opacity:0}12%,58%{opacity:1}}
`;
    document.head.appendChild(style);
  }

  function themeName() {
    return document.documentElement.getAttribute("data-theme") === "light" ? "light" : "dark";
  }

  function colors(effect) {
    const theme = themeName();
    const p = effect && effect[theme] ? effect[theme] : {};
    return {
      a: p.a || "#a7e956",
      b: p.b || "#67e8f9",
      ink: p.ink || (theme === "light" ? "#15191e" : "#f5f1e8")
    };
  }

  function add(layer, className, x, y, effect, html = "") {
    injectStyles();
    const c = colors(effect);
    const node = document.createElement("span");
    node.className = `fx-piece ${className}`;
    node.innerHTML = html;
    node.style.left = `${x}px`;
    node.style.top = `${y}px`;
    node.style.setProperty("--a", c.a);
    node.style.setProperty("--b", c.b);
    node.style.setProperty("--ink", c.ink);
    layer.appendChild(node);
    return node;
  }

  function liveNode(layer, key, className, effect) {
    injectStyles();
    const c = colors(effect);
    const node = document.createElement("span");
    node.className = `fx-live ${className}`;
    node.style.setProperty("--a", c.a);
    node.style.setProperty("--b", c.b);
    node.style.setProperty("--ink", c.ink);
    node.dataset.x = "0";
    node.dataset.y = "0";
    layer.appendChild(node);
    return node;
  }

  function css(node, vars) {
    Object.entries(vars).forEach(([k, v]) => node.style.setProperty(k, v));
  }

  function removeAfter(node, ms) {
    setTimeout(() => node.remove(), ms + 80);
  }

  function drift(node, ms = 1050, spread = 50) {
    css(node, {
      "--dx": `${rand(-spread, spread)}px`,
      "--dy": `${rand(-spread - 18, 28)}px`,
      "--rot": `${rand(-180, 180)}deg`,
      "--sc": `${rand(.8, 1.7)}`
    });
    node.style.animation = `fxDrift ${ms}ms ease-out forwards`;
    removeAfter(node, ms);
  }

  function crack(node, dx, dy, ms = 780) {
    css(node, {
      "--dx": `${dx}px`,
      "--dy": `${dy}px`,
      "--rot": `${rand(-160, 160)}deg`
    });
    node.style.animation = `fxCrack ${ms}ms cubic-bezier(.16,.8,.28,1) forwards`;
    removeAfter(node, ms);
  }

  function ring(node, ms = 900, scale = 2.5) {
    css(node, {"--sc": scale});
    node.style.animation = `fxRing ${ms}ms ease-out forwards`;
    removeAfter(node, ms);
  }

  function slide(node, angle = 0, ms = 760, dist = 60) {
    const rad = angle * Math.PI / 180;
    css(node, {
      "--rot": `${angle}deg`,
      "--dx": `${Math.cos(rad) * dist}px`,
      "--dy": `${Math.sin(rad) * dist}px`
    });
    node.style.animation = `fxSlide ${ms}ms ease-out forwards`;
    removeAfter(node, ms);
  }

  function pop(node, ms = 900, spread = 36) {
    css(node, {
      "--dx": `${rand(-spread, spread)}px`,
      "--dy": `${rand(-spread - 22, -12)}px`,
      "--rot": `${rand(-18, 18)}deg`,
      "--sc": `${rand(.9, 1.16)}`
    });
    node.style.animation = `fxPop ${ms}ms cubic-bezier(.16,.8,.28,1) forwards`;
    removeAfter(node, ms);
  }

  function getLive(layer, key, count, makeClass, effect) {
    let state = live.get(layer);
    if (!state) {
      state = {};
      live.set(layer, state);
    }

    if (!state[key] || state[key].nodes.length !== count) {
      if (state[key]) state[key].nodes.forEach((n) => n.remove());
      const nodes = [];
      for (let i = 0; i < count; i++) {
        nodes.push(liveNode(layer, key, makeClass(i), effect));
      }
      state[key] = { nodes };
    }
    return state[key].nodes;
  }

  function updateTail(layer, key, effect, x, y, count, classMaker, options = {}) {
    const nodes = getLive(layer, key, count, classMaker, effect);
    let tx = x;
    let ty = y;
    nodes.forEach((node, i) => {
      if (!node.dataset.ready) {
        node.dataset.x = x;
        node.dataset.y = y;
        node.dataset.ready = "1";
      }
      const px = Number(node.dataset.x);
      const py = Number(node.dataset.y);
      const ease = i === 0 ? (options.headEase || .35) : (options.ease || .22);
      const wave = Math.sin((performance.now() / 190) + i * .88) * (options.wave || 0);
      const nx = px + (tx - px) * ease;
      const ny = py + (ty - py) * ease + wave;
      node.dataset.x = nx;
      node.dataset.y = ny;
      const rot = Math.atan2(ty - py, tx - px) * 180 / Math.PI;
      const scale = clamp(1 - i * (options.shrink || .035), .38, 1);
      node.style.zIndex = String(30 - i);
      node.style.transform = `translate(${nx}px, ${ny}px) translate(-50%,-50%) rotate(${rot}deg) scale(${scale})`;
      tx = nx;
      ty = ny;
    });
  }

  function rendererConstellation(effect, layer, x, y) {
    const points = [];
    for (let i = 0; i < 5; i++) {
      const px = x + rand(-34, 34);
      const py = y + rand(-28, 28);
      points.push([px, py]);
      const n = add(layer, "fx-dot", px, py, effect);
      css(n, {"--s": `${rand(5, 10)}px`, "--glow": "18px"});
      drift(n, 1050, 36);
    }
    for (let i = 0; i < 3; i++) {
      const a = points[i], b = points[(i + 2) % points.length];
      const dx = b[0] - a[0], dy = b[1] - a[1];
      const n = add(layer, "fx-line", (a[0] + b[0]) / 2, (a[1] + b[1]) / 2, effect);
      css(n, {"--w": `${Math.hypot(dx, dy)}px`, "--h": "1px", "--glow": "10px"});
      slide(n, Math.atan2(dy, dx) * 180 / Math.PI, 850, 8);
    }
  }

  function rendererPixelCrack(effect, layer, x, y) {
    const dirs = [[-32,-18],[-18,0],[-28,22],[0,-30],[0,28],[24,-20],[30,0],[20,24]];
    dirs.forEach(([dx, dy], i) => {
      const n = add(layer, "fx-square", x + (i % 3 - 1) * 6, y + (Math.floor(i / 3) - 1) * 6, effect);
      css(n, {"--s": `${rand(8, 13)}px`, "--r": "2px"});
      crack(n, dx, dy, 680 + i * 22);
    });
  }

  function rendererGlassManta(effect, layer, x, y) {
    for (let i = 0; i < 5; i++) {
      const n = add(layer, "fx-shard", x + rand(-8, 8), y + rand(-6, 6), effect);
      css(n, {"--s": `${rand(11, 18)}px`});
      slide(n, rand(-160, 30), 920, rand(28, 62));
    }
  }

  function rendererPollenOrbit(effect, layer, x, y) {
    const base = add(layer, "fx-ring", x, y, effect);
    css(base, {"--s": "46px", "--bw": "1px", "--glow": "8px"});
    ring(base, 900, 1.9);
    for (let i = 0; i < 5; i++) {
      const n = add(layer, "fx-dot", x, y, effect);
      css(n, {"--s": `${rand(6, 10)}px`, "--rad": `${rand(18, 34)}px`, "--turn": `${pick([210, -250, 320])}deg`});
      n.style.animation = `fxOrbit ${900 + i * 50}ms ease-out forwards`;
      removeAfter(n, 1100);
    }
  }

  function rendererAshSpiral(effect, layer, x, y) {
    for (let i = 0; i < 7; i++) {
      const n = add(layer, i % 2 ? "fx-square" : "fx-dot", x, y, effect);
      css(n, {"--s": `${rand(3, 7)}px`, "--dx": `${Math.sin(i) * rand(20, 46)}px`, "--dy": `${rand(48, 100)}px`, "--rot": `${rand(90, 260)}deg`, "--sc": `${rand(.6, 1.05)}`});
      n.style.animation = `fxFall ${1200 + i * 70}ms ease-in forwards`;
      removeAfter(n, 1600);
    }
  }

  function rendererMicroSnow(effect, layer, x, y) {
    for (let i = 0; i < 8; i++) {
      const n = add(layer, "fx-dot", x + rand(-24, 24), y + rand(-8, 8), effect);
      css(n, {"--s": `${rand(3, 7)}px`, "--dx": `${rand(-18, 34)}px`, "--dy": `${rand(55, 115)}px`, "--sc": `${rand(.8, 1.2)}`, "--rot": "0deg", "--glow": "8px"});
      n.style.animation = `fxFall ${1300 + rand(0, 400)}ms linear forwards`;
      removeAfter(n, 1800);
    }
  }

  function rendererRibbonWeave(effect, layer, x, y) {
    [-28, 0, 28].forEach((a, i) => {
      const n = add(layer, "fx-line", x, y + (i - 1) * 5, effect);
      css(n, {"--w": `${rand(52, 86)}px`, "--h": "5px", "--glow": "12px"});
      slide(n, a + rand(-8, 8), 820, 48);
    });
  }

  function rendererInkComet(effect, layer, x, y) {
    const head = add(layer, "fx-blob", x, y, effect);
    css(head, {"--s": "28px", "--blur": "1px"});
    drift(head, 980, 18);
    const tail = add(layer, "fx-line", x - 12, y + 2, effect);
    css(tail, {"--w": "96px", "--h": "7px", "--glow": "0px"});
    slide(tail, rand(166, 194), 880, 70);
  }

  function rendererGhostFrames(effect, layer, x, y) {
    for (let i = 0; i < 3; i++) {
      const n = add(layer, "fx-rect-ring", x - i * 10, y - i * 5, effect);
      css(n, {"--w": `${44 + i * 13}px`, "--h": `${30 + i * 9}px`, "--sc": `${1.4 + i * .32}`});
      n.style.animation = `fxRing ${840 + i * 140}ms ease-out forwards`;
      n.style.animationDelay = `${i * 45}ms`;
      removeAfter(n, 1250);
    }
  }

  function rendererStitchThread(effect, layer, x, y) {
    const angle = rand(-35, 35);
    for (let i = 0; i < 8; i++) {
      const n = add(layer, "fx-line", x + (i - 4) * 10, y + Math.sin(i) * 4, effect);
      css(n, {"--w": "11px", "--h": "3px", "--glow": "4px"});
      slide(n, angle, 680 + i * 28, 18);
    }
  }

  function rendererCometScratch(effect, layer, x, y) {
    const angle = rand(-12, 12);
    const slash = add(layer, "fx-line", x, y, effect);
    css(slash, {"--w": "122px", "--h": "2px", "--glow": "18px"});
    slide(slash, angle, 620, 44);
    for (let i = 0; i < 5; i++) {
      const n = add(layer, "fx-square", x + rand(-18, 18), y + rand(-8, 8), effect);
      css(n, {"--s": `${rand(3, 6)}px`});
      crack(n, rand(-24, 44), rand(-22, 22), 640);
    }
  }

  function rendererHaloBreath(effect, layer, x, y) {
    [54, 86].forEach((size, i) => {
      const n = add(layer, "fx-ring", x, y, effect);
      css(n, {"--s": `${size}px`, "--bw": `${i + 1}px`, "--glow": "20px"});
      ring(n, 940 + i * 240, 1.75 + i * .25);
    });
  }

  function rendererBoneOrbit(effect, layer, x, y) {
    updateTail(layer, "bone-orbit", effect, x, y, 13, (i) => "fx-bone", {wave: 2.4, shrink: .04, headEase:.38, ease:.24});
  }

  function rendererJellyChain(effect, layer, x, y) {
    updateTail(layer, "jelly-chain", effect, x, y, 10, (i) => "fx-jelly", {wave: 3.8, shrink: .055, headEase:.34, ease:.20});
  }

  function rendererFireflySwarm(effect, layer, x, y) {
    for (let i = 0; i < 7; i++) {
      const n = add(layer, "fx-dot", x + rand(-16, 16), y + rand(-12, 12), effect);
      css(n, {"--s": `${rand(5, 9)}px`, "--glow": "24px"});
      drift(n, 1050 + i * 40, 44);
    }
  }

  function rendererLeafCut(effect, layer, x, y) {
    for (let i = 0; i < 4; i++) {
      const n = add(layer, "fx-leaf", x + rand(-8, 8), y + rand(-5, 5), effect);
      css(n, {"--w": `${rand(16, 25)}px`, "--h": `${rand(8, 13)}px`, "--dx": `${rand(-34, 34)}px`, "--dy": `${rand(22, 70)}px`, "--rot": `${rand(90, 280)}deg`, "--sc": `${rand(.7, 1.2)}`});
      n.style.animation = `fxFall ${980 + i * 80}ms ease-in-out forwards`;
      removeAfter(n, 1400);
    }
  }

  function rendererBubbleLadder(effect, layer, x, y) {
    for (let i = 0; i < 5; i++) {
      const n = add(layer, "fx-ring", x + rand(-12, 12), y + i * 5, effect);
      css(n, {"--s": `${18 + i * 7}px`, "--bw": "1px", "--dx": `${rand(-12, 12)}px`, "--dy": `${-45 - i * 14}px`, "--rot": "0deg", "--sc": `${.8 + i * .06}`});
      n.style.animation = `fxDrift ${1050 + i * 80}ms ease-out forwards`;
      removeAfter(n, 1500);
    }
  }

  function rendererLarvaBlink(effect, layer, x, y) {
    updateTail(layer, "larva-blink", effect, x, y, 9, (i) => i === 0 ? "fx-jelly" : "fx-dot", {wave: 1.5, shrink:.065, headEase:.40, ease:.25});
  }

  function rendererSmokeFold(effect, layer, x, y) {
    for (let i = 0; i < 4; i++) {
      const n = add(layer, "fx-smoke", x + rand(-10, 10), y + rand(-8, 8), effect);
      css(n, {"--s": `${rand(54, 90)}px`, "--dx": `${rand(-32, 32)}px`, "--dy": `${rand(-54, -8)}px`, "--rot": `${rand(-30, 30)}deg`, "--sc": `${rand(1.15, 1.7)}`});
      n.style.animation = `fxDrift ${1450 + i * 100}ms ease-out forwards`;
      removeAfter(n, 1900);
    }
  }

  function rendererOilMembrane(effect, layer, x, y) {
    for (let i = 0; i < 3; i++) {
      const n = add(layer, "fx-blob", x + rand(-10, 10), y + rand(-8, 8), effect);
      css(n, {"--s": `${rand(42, 70)}px`, "--blur": "0px"});
      drift(n, 1120 + i * 90, 28);
    }
  }

  function rendererWaterRipple(effect, layer, x, y) {
    const r = add(layer, "fx-ring", x, y, effect);
    css(r, {"--s": "34px", "--bw": "2px"});
    ring(r, 920, 3.1);
    for (let i = 0; i < 5; i++) {
      const n = add(layer, "fx-dot", x, y, effect);
      const a = i * 72 + rand(-14, 14);
      css(n, {"--s": `${rand(4, 8)}px`});
      crack(n, Math.cos(a * Math.PI / 180) * rand(28, 56), Math.sin(a * Math.PI / 180) * rand(28, 56), 820);
    }
  }

  function rendererVaporKnot(effect, layer, x, y) {
    for (let i = 0; i < 2; i++) {
      const n = add(layer, "fx-ring", x, y, effect);
      css(n, {"--s": `${62 + i * 20}px`, "--bw": "3px", "--sc": `${1.5 + i * .28}`});
      n.style.borderRadius = i ? "62% 38% 55% 45%" : "42% 58% 40% 60%";
      n.style.animation = `fxRing ${1180 + i * 160}ms ease-out forwards`;
      removeAfter(n, 1500);
    }
  }

  function rendererPlasmaBlob(effect, layer, x, y) {
    for (let i = 0; i < 4; i++) {
      const n = add(layer, "fx-blob", x + rand(-6, 6), y + rand(-6, 6), effect);
      css(n, {"--s": `${rand(24, 46)}px`, "--blur": "1px"});
      pop(n, 850 + i * 70, 34);
    }
  }

  function rendererMistWindow(effect, layer, x, y) {
    for (let i = 0; i < 3; i++) {
      const n = add(layer, "fx-card", x + rand(-8, 8), y + rand(-6, 6), effect);
      css(n, {"--w": `${rand(42, 70)}px`, "--h": `${rand(26, 42)}px`, "--dx": `${rand(-26, 26)}px`, "--dy": `${rand(-42, 8)}px`, "--rot": `${rand(-10, 10)}deg`, "--sc": `${rand(.8, 1.05)}`});
      n.style.filter = "blur(.6px)";
      n.style.animation = `fxDrift ${1080 + i * 90}ms ease-out forwards`;
      removeAfter(n, 1500);
    }
  }

  function rendererCodeScramble(effect, layer, x, y) {
    ["JS", "CSS", "{}", "</>", "var"].forEach((t, i) => {
      const n = add(layer, "fx-text", x + rand(-6, 6), y + rand(-6, 6), effect, t);
      css(n, {"--s": `${rand(11, 16)}px`});
      crack(n, rand(-46, 46), rand(-38, 28), 800 + i * 40);
    });
  }

  function rendererTerminalCaret(effect, layer, x, y) {
    [">", "_", "$"].forEach((t, i) => {
      const n = add(layer, "fx-text", x + i * 16, y, effect, t);
      css(n, {"--s": `${16 + i * 2}px`, "--dx": `${18 + i * 8}px`, "--dy": "0px", "--rot": "0deg", "--sc": "1"});
      n.style.animation = `fxBlink ${760 + i * 70}ms steps(2,end) forwards`;
      removeAfter(n, 980);
    });
  }

  function rendererBinaryRain(effect, layer, x, y) {
    for (let col = -1; col <= 1; col++) {
      for (let i = 0; i < 4; i++) {
        const n = add(layer, "fx-text", x + col * 18, y - i * 12, effect, Math.random() > .5 ? "1" : "0");
        css(n, {"--s": `${rand(10, 14)}px`, "--dx": `${rand(-3, 3)}px`, "--dy": `${48 + i * 16}px`, "--rot": "0deg", "--sc": ".88"});
        n.style.animation = `fxFall ${900 + i * 90}ms linear forwards`;
        removeAfter(n, 1400);
      }
    }
  }

  function rendererBracketLock(effect, layer, x, y) {
    const items = [["[", -32, 0], ["]", 32, 0], ["{", 0, -26], ["}", 0, 26]];
    items.forEach(([t, dx, dy], i) => {
      const n = add(layer, "fx-text", x + dx, y + dy, effect, t);
      css(n, {"--s": "24px"});
      pop(n, 760 + i * 30, 14);
    });
  }

  function rendererKeycapPop(effect, layer, x, y) {
    ["TAB", "JS", "CSS"].forEach((t, i) => {
      const n = add(layer, "fx-key", x + (i - 1) * 14, y + rand(-4, 4), effect, t);
      pop(n, 850 + i * 60, 34);
    });
  }

  function rendererCardStack(effect, layer, x, y) {
    for (let i = 0; i < 4; i++) {
      const n = add(layer, "fx-card", x + i * 4, y + i * 3, effect);
      css(n, {"--w": `${48 + i * 3}px`, "--h": `${30 + i * 2}px`});
      pop(n, 920 + i * 45, 42);
    }
  }

  function rendererLaserSlicer(effect, layer, x, y) {
    const flash = add(layer, "fx-dot", x, y, effect);
    css(flash, {"--s": "18px", "--glow": "28px"});
    pop(flash, 620, 4);
    const n = add(layer, "fx-line", x, y, effect);
    css(n, {"--w": "150px", "--h": "2px", "--glow": "24px"});
    slide(n, rand(-8, 8), 580, 70);
  }

  function rendererPrismSplit(effect, layer, x, y) {
    const angles = [-24, 0, 24];
    angles.forEach((a, i) => {
      const n = add(layer, "fx-line", x, y, effect);
      const c = colors(effect);
      if (i === 0) n.style.setProperty("--a", c.a);
      if (i === 1) n.style.setProperty("--a", c.b);
      if (i === 2) n.style.setProperty("--a", c.ink);
      css(n, {"--w": "92px", "--h": "3px", "--glow": "18px"});
      slide(n, a, 780 + i * 60, 62);
    });
  }

  function rendererScanRadar(effect, layer, x, y) {
    [42, 70].forEach((s, i) => {
      const n = add(layer, "fx-ring", x, y, effect);
      css(n, {"--s": `${s}px`, "--bw": "1px"});
      ring(n, 840 + i * 140, 2.1);
    });
    const sweep = add(layer, "fx-line", x, y, effect);
    css(sweep, {"--w": "76px", "--h": "2px", "--glow": "18px"});
    slide(sweep, rand(15, 70), 820, 44);
  }

  function rendererOrbitSatellite(effect, layer, x, y) {
    const core = add(layer, "fx-dot", x, y, effect);
    css(core, {"--s": "10px", "--glow": "24px"});
    pop(core, 760, 4);
    for (let i = 0; i < 4; i++) {
      const n = add(layer, "fx-dot", x, y, effect);
      css(n, {"--s": `${rand(5, 8)}px`, "--rad": `${24 + i * 6}px`, "--turn": `${i % 2 ? -360 : 360}deg`, "--glow": "18px"});
      n.style.animation = `fxOrbit ${920 + i * 70}ms ease-out forwards`;
      removeAfter(n, 1300);
    }
  }

  function rendererMagneticPebbles(effect, layer, x, y) {
    for (let i = 0; i < 9; i++) {
      const n = add(layer, "fx-dot", x, y, effect);
      css(n, {"--s": `${rand(5, 10)}px`, "--dx": `${rand(-58, 58)}px`, "--dy": `${rand(-46, 46)}px`, "--glow": "14px"});
      n.style.animation = `fxMagnet ${760 + i * 30}ms ease-in forwards`;
      removeAfter(n, 1100);
    }
  }

  function rendererGravitySparks(effect, layer, x, y) {
    for (let i = 0; i < 7; i++) {
      const n = add(layer, i % 2 ? "fx-square" : "fx-dot", x + rand(-8, 8), y + rand(-5, 5), effect);
      css(n, {"--s": `${rand(4, 9)}px`, "--dx": `${rand(-22, 22)}px`, "--dy": `${rand(70, 132)}px`, "--rot": `${rand(80, 260)}deg`, "--sc": `${rand(.65, 1)}`});
      n.style.animation = `fxFall ${780 + i * 70}ms cubic-bezier(.18,.72,.35,1.12) forwards`;
      removeAfter(n, 1400);
    }
  }

  const renderers = {
    "ember-constellation": rendererConstellation,
    "pixel-crack": rendererPixelCrack,
    "glass-manta": rendererGlassManta,
    "pollen-orbit": rendererPollenOrbit,
    "ash-spiral": rendererAshSpiral,
    "micro-snow": rendererMicroSnow,
    "ribbon-weave": rendererRibbonWeave,
    "ink-comet": rendererInkComet,
    "ghost-frames": rendererGhostFrames,
    "stitch-thread": rendererStitchThread,
    "comet-scratch": rendererCometScratch,
    "halo-breath": rendererHaloBreath,
    "bone-orbit": rendererBoneOrbit,
    "jelly-chain": rendererJellyChain,
    "firefly-swarm": rendererFireflySwarm,
    "leaf-cut": rendererLeafCut,
    "bubble-ladder": rendererBubbleLadder,
    "larva-blink": rendererLarvaBlink,
    "smoke-fold": rendererSmokeFold,
    "oil-membrane": rendererOilMembrane,
    "water-ripple": rendererWaterRipple,
    "vapor-knot": rendererVaporKnot,
    "plasma-blob": rendererPlasmaBlob,
    "mist-window": rendererMistWindow,
    "code-scramble": rendererCodeScramble,
    "terminal-caret": rendererTerminalCaret,
    "binary-rain": rendererBinaryRain,
    "bracket-lock": rendererBracketLock,
    "keycap-pop": rendererKeycapPop,
    "card-stack": rendererCardStack,
    "laser-slicer": rendererLaserSlicer,
    "prism-split": rendererPrismSplit,
    "scan-radar": rendererScanRadar,
    "orbit-satellite": rendererOrbitSatellite,
    "magnetic-pebbles": rendererMagneticPebbles,
    "gravity-sparks": rendererGravitySparks
  };

  const fast = new Set(["bone-orbit", "jelly-chain", "larva-blink"]);
  const medium = new Set(["stitch-thread", "terminal-caret", "binary-rain", "orbit-satellite", "magnetic-pebbles"]);

  function spawn(effect, layer, x, y) {
    if (!effect || !layer) return;
    injectStyles();
    const fn = renderers[effect.key] || rendererConstellation;
    fn(effect, layer, x, y);
  }

  function clear(layer) {
    if (!layer) return;
    layer.querySelectorAll(".fx-piece,.fx-live").forEach((node) => node.remove());
    live.delete(layer);
  }

  function rate(effect) {
    if (!effect) return 90;
    if (fast.has(effect.key)) return 18;
    if (medium.has(effect.key)) return 55;
    return 86;
  }

  return { spawn, clear, rate };
})();

'@
$appJs = @'

const COLD_DATA = window.COLD_DATA || [];
const COLD_EFFECTS = window.COLD_EFFECTS || [];

function qs(sel, root = document) {
  return root.querySelector(sel);
}

function qsa(sel, root = document) {
  return Array.from(root.querySelectorAll(sel));
}

function initTheme() {
  const root = document.documentElement;

  function clean(value) {
    return value === "light" ? "light" : "dark";
  }

  function apply(theme) {
    theme = clean(theme);
    root.setAttribute("data-theme", theme);
    document.body.setAttribute("data-theme", theme);
    document.body.classList.toggle("dark", theme === "dark");
    localStorage.setItem("coldboot-cursor-theme", theme);

    qsa("[data-theme-toggle]").forEach((btn) => {
      btn.textContent = theme === "light" ? "鈽€" : "鈽?;
      btn.setAttribute("aria-label", "Toggle theme");
      btn.setAttribute("type", "button");
    });
  }

  qsa("[data-theme-toggle]").forEach((btn) => {
    btn.onclick = (event) => {
      event.preventDefault();
      const current = clean(root.getAttribute("data-theme"));
      apply(current === "light" ? "dark" : "light");
    };
  });

  apply(localStorage.getItem("coldboot-cursor-theme") || root.getAttribute("data-theme") || "dark");
}

function syncCategoryExpandedState(grid, expanded) {
  const strip = grid ? grid.closest(".category-strip") : null;
  if (strip) strip.classList.toggle("is-expanded", expanded);
}

function renderCategoryGrid(grid, activeId, expanded, sameFolder) {
  grid.innerHTML = COLD_DATA.map((cat) => {
    const href = sameFolder ? `${cat.id}.html` : `categories/${cat.id}.html`;
    return `
      <a class="category-card ${cat.id === activeId ? "active" : ""}" href="${href}">
        <strong>
          <span class="cat-icon" aria-hidden="true">${cat.icon}</span>
          <span class="cat-label">${cat.title}</span>
        </strong>
      </a>
    `;
  }).join("");
}

function attachEffectPreview(section, effect) {
  const layer = qs(".fx-layer", section);
  const target = qs(".preview-zone", section) || section;

  if (!layer || !target || !effect || typeof COLD_FX === "undefined") return;

  let last = 0;

  target.addEventListener("pointermove", (event) => {
    const now = performance.now();
    const gap = typeof COLD_FX.rate === "function" ? COLD_FX.rate(effect) : 86;

    if (now - last < gap) return;
    last = now;

    const rect = layer.getBoundingClientRect();
    const x = event.clientX - rect.left;
    const y = event.clientY - rect.top;

    COLD_FX.spawn(effect, layer, x, y);
  });

  target.addEventListener("pointerleave", () => {
    setTimeout(() => COLD_FX.clear(layer), 520);
  });
}

function initIndex() {
  initTheme();

  const grid = qs("#categoryGrid");
  const button = qs("#seeMoreBtn");

  if (!grid) return;

  let expanded = true;

  function render() {
    renderCategoryGrid(grid, "", expanded, false);
    syncCategoryExpandedState(grid, expanded);
    if (button) button.style.display = "none";
  }

  render();
}

function initCategoryPage(catId) {
  initTheme();

  const grid = qs("#categoryGrid");
  const button = qs("#seeMoreBtn");

  if (!grid) return;

  let expanded = true;

  function render() {
    renderCategoryGrid(grid, catId, expanded, true);
    syncCategoryExpandedState(grid, expanded);
    if (button) button.style.display = "none";
  }

  render();

  qsa(".effect-box").forEach((box) => {
    const effect = COLD_EFFECTS.find((item) => item.key === box.dataset.effect);
    attachEffectPreview(box, effect);
  });
}

function initSourcePage(effectKey) {
  initTheme();

  const effect = COLD_EFFECTS.find((item) => item.key === effectKey);
  const preview = qs("#sourcePreview");

  if (preview && effect) {
    attachEffectPreview(preview, effect);
  }

  qsa(".code-tab").forEach((btn) => {
    btn.addEventListener("click", () => {
      qsa(".code-tab").forEach((item) => item.classList.toggle("active", item === btn));
      qsa(".code-pane").forEach((pane) => {
        pane.hidden = pane.dataset.code !== btn.dataset.tab;
      });
    });
  });

  const copyBtn = qs("#copyAll");

  if (copyBtn) {
    copyBtn.addEventListener("click", async () => {
      const text = qsa(".code-pane code").map((node) => node.textContent).join("\n\n");

      try {
        await navigator.clipboard.writeText(text);
        copyBtn.textContent = "Copied";
        setTimeout(() => copyBtn.textContent = "Copy all", 1200);
      } catch {
        copyBtn.textContent = "Copy failed";
        setTimeout(() => copyBtn.textContent = "Copy all", 1200);
      }
    });
  }
}

/* hide nav/category when scrolling down, reveal when scrolling up */
(function () {
  let lastScrollY = window.scrollY;
  let ticking = false;

  function updateBars() {
    const currentY = window.scrollY;
    const down = currentY > lastScrollY && currentY > 100;
    const up = currentY < lastScrollY;

    document.body.classList.toggle("hide-top-bars", down && !up);

    if (up || currentY < 40) {
      document.body.classList.remove("hide-top-bars");
    }

    lastScrollY = currentY;
    ticking = false;
  }

  window.addEventListener("scroll", () => {
    if (!ticking) {
      requestAnimationFrame(updateBars);
      ticking = true;
    }
  }, { passive: true });
})();

'@
$themeCss = @'

/* ===== QUALITY THEME + REDUCED CATEGORY SET ===== */
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
    #06090f !important;
  color:var(--text) !important;
}

html[data-theme="light"] body{
  background:
    radial-gradient(circle at 12% 10%, rgba(80,95,55,.05), transparent 24%),
    linear-gradient(180deg,#c7c0b1 0%,#bdb5a7 100%) !important;
  color:var(--text) !important;
}

html[data-theme="dark"] body::before{opacity:.36 !important;background-size:36px 36px !important}
html[data-theme="light"] body::before{opacity:.12 !important;background-size:38px 38px !important}

.shell{width:min(1160px,calc(100% - 48px)) !important;padding-top:18px !important}

.nav{
  border-radius:22px !important;
  box-shadow:var(--shadow) !important;
}
html[data-theme="dark"] .nav{background:rgba(13,19,31,.82) !important}
html[data-theme="light"] .nav{background:rgba(185,177,164,.82) !important}
.theme-toggle{background:transparent !important;border:none !important;box-shadow:none !important}

.hero{padding:52px 0 26px !important}
.hero h1{font-size:clamp(3rem,7vw,6.3rem) !important}
.hero p{max-width:680px !important}

.category-strip{
  border-radius:22px !important;
  box-shadow:var(--shadow) !important;
}
.category-grid{
  grid-template-columns:repeat(3,minmax(0,1fr)) !important;
}
.category-card{
  min-height:58px !important;
  height:58px !important;
  padding:13px 15px !important;
  justify-content:center !important;
  box-shadow:none !important;
}
.category-card strong{
  margin:0 !important;
  display:flex !important;
  align-items:center !important;
  gap:8px !important;
  font-size:.92rem !important;
}
.category-card small{display:none !important}

.main-grid{
  grid-template-columns:repeat(2,minmax(0,1fr)) !important;
  gap:22px !important;
}
.main-card{
  min-height:220px !important;
  border-radius:24px !important;
  box-shadow:var(--shadow) !important;
}
.main-card h2{font-size:clamp(2.1rem,4vw,3.45rem) !important}
.main-card::after{opacity:.75 !important}

.category-hero{
  min-height:220px !important;
  border-radius:24px !important;
  box-shadow:var(--shadow) !important;
}

.effect-box{
  min-height:330px !important;
  border-radius:26px !important;
  box-shadow:var(--shadow) !important;
}
.effect-content h2{
  font-size:clamp(2.2rem,4.5vw,4.1rem) !important;
}
.preview-zone{
  background:var(--soft) !important;
  border-color:color-mix(in srgb,var(--accent) 24%,var(--line)) !important;
}
html[data-theme="dark"] .preview-zone,
html[data-theme="dark"] .source-preview{
  background:#04070d !important;
}
html[data-theme="light"] .preview-zone,
html[data-theme="light"] .source-preview{
  background:linear-gradient(135deg,#969188,#89847d) !important;
}
.preview-zone::before{color:var(--muted) !important}

.source-preview{
  min-height:360px !important;
  border-radius:26px !important;
  position:relative !important;
  overflow:hidden !important;
}
.source-preview .fx-layer{position:absolute;inset:0}

.source-preview > .preview-zone{
  position:absolute !important;
  inset:22px !important;
  left:22px !important;
  right:22px !important;
  top:22px !important;
  bottom:22px !important;
  min-height:auto !important;
}
.source-preview > .preview-zone::before{
  content:"preview";
  position:absolute;
  left:16px;
  top:14px;
  font-size:.68rem;
  font-weight:920;
  letter-spacing:.14em;
  text-transform:uppercase;
  color:var(--muted);
}

.pill,.source-link,.see-more,.main-card a,.copy-btn,.code-tab{
  box-shadow:none !important;
}

footer{
  color:var(--muted) !important;
}

@media(max-width:900px){
  .category-grid{grid-template-columns:repeat(2,minmax(0,1fr)) !important}
  .main-grid{grid-template-columns:1fr !important}
  .effect-box{display:block !important;min-height:auto !important}
  .effect-content{width:100% !important}
  .preview-zone{
    position:relative !important;
    inset:auto !important;
    left:auto !important;
    right:auto !important;
    top:auto !important;
    bottom:auto !important;
    min-height:240px !important;
    margin-top:22px !important;
  }
}
@media(max-width:560px){
  .shell{width:min(100% - 28px,1160px) !important}
  .category-grid{grid-template-columns:1fr !important}
  .hero h1{font-size:clamp(2.6rem,14vw,4.2rem) !important}
  .main-card,.effect-box,.category-hero{border-radius:20px !important}
}

'@

$catalog = $catalogJson | ConvertFrom-Json

$coldData = @()
$coldEffects = @()

foreach ($cat in $catalog) {
  $effectKeys = @()
  $i = 1

  foreach ($fx in $cat.effects) {
    $effectKeys += $fx.key

    $coldEffects += [pscustomobject][ordered]@{
      key       = $fx.key
      name      = $fx.name
      desc      = $fx.desc
      kind      = $fx.kind
      cat_id    = $cat.id
      cat_num   = $cat.num
      cat_title = $cat.title
      cat_desc  = $cat.desc
      cat_icon  = $cat.icon
      index     = $i
      dark      = $fx.dark
      light     = $fx.light
    }

    $i++
  }

  $coldData += [pscustomobject][ordered]@{
    id      = $cat.id
    num     = $cat.num
    title   = $cat.title
    desc    = $cat.desc
    icon    = $cat.icon
    effects = $effectKeys
  }
}

$dataJs = "window.COLD_DATA = " + ($coldData | ConvertTo-Json -Depth 20 -Compress) + ";`r`n" +
          "window.COLD_EFFECTS = " + ($coldEffects | ConvertTo-Json -Depth 20 -Compress) + ";`r`n"

Write-Utf8File ".\assets\data.js" $dataJs
Write-Utf8File ".\assets\fx.js" $fxJs
Write-Utf8File ".\assets\app.js" $appJs
Write-Utf8File ".\assets\quality-theme.css" $themeCss

# Remove old broken/generated theme files from previous experiments. They will not be linked anymore.
Remove-Item ".\assets\ui-refresh.css" -Force -ErrorAction SilentlyContinue
Remove-Item ".\assets\clean-ui-final.css" -Force -ErrorAction SilentlyContinue
Remove-Item ".\assets\light-theme-fix.css" -Force -ErrorAction SilentlyContinue
Remove-Item ".\assets\soft-light-final.css" -Force -ErrorAction SilentlyContinue
Remove-Item ".\assets\theme-final.css" -Force -ErrorAction SilentlyContinue
Remove-Item ".\assets\theme-final.js" -Force -ErrorAction SilentlyContinue
Remove-Item ".\assets\theme-clean.css" -Force -ErrorAction SilentlyContinue

# Clean old static pages so duplicate/similar old cursors disappear.
Get-ChildItem ".\categories" -Filter "*.html" -File | Remove-Item -Force
Get-ChildItem ".\sources" -Filter "*.html" -File | Remove-Item -Force

$mainCards = @()
foreach ($cat in $catalog) {
  $title = HtmlSafe $cat.title
  $desc = HtmlSafe $cat.desc
  $mainCards += @"
      <article class="main-card" data-watermark="$title">
        <span class="pill">$($cat.num) / category</span>
        <h2>$title</h2>
        <p>$desc</p>
        <a href="categories/$($cat.id).html">Open category</a>
      </article>
"@
}

$indexHtml = @"
<!doctype html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex,nofollow">
  <title>Coldboot Cursor Library</title>
  <link rel="stylesheet" href="assets/style.css">
  <link rel="stylesheet" href="assets/quality-theme.css?v=$stamp">
</head>
<body>
  <div class="shell">
    <header class="nav">
      <a class="brand" href="index.html"><span class="brand-dot"></span>Coldboot</a>
      <nav class="nav-links">
        <a href="index.html">Home</a>
        <a href="#categories">Categories</a>
        <a href="#library">Library</a>
        <button class="theme-toggle" data-theme-toggle type="button">鈽?/button>
      </nav>
    </header>

    <section class="hero">
      <span class="pill">Coldboot / quality cursor library</span>
      <h1>Less categories. Better cursor effects.</h1>
      <p>A cleaner cursor library rebuilt around unique motion, readable previews, and separate dark/light palettes for every effect.</p>
    </section>

    <section class="category-strip" id="categories">
      <div class="section-head">
        <strong>Quality categories</strong>
        <button class="see-more" id="seeMoreBtn" type="button">See more</button>
      </div>
      <div class="category-grid" id="categoryGrid"></div>
    </section>

    <section class="main-grid section-gap" id="library">
$($mainCards -join "`r`n")
    </section>

    <footer>6 focused categories. 36 redesigned cursor effects. Each effect has dark and light theme visibility.</footer>
  </div>
  <script src="assets/data.js?v=$stamp"></script>
  <script src="assets/fx.js?v=$stamp"></script>
  <script src="assets/app.js?v=$stamp"></script>
  <script>initIndex();</script>
</body>
</html>
"@

Write-Utf8File ".\index.html" $indexHtml

foreach ($cat in $catalog) {
  $effectsHtml = @()

  foreach ($fx in $cat.effects) {
    $e = $coldEffects | Where-Object { $_.key -eq $fx.key } | Select-Object -First 1
    $title = HtmlSafe $fx.name
    $desc = HtmlSafe $fx.desc
    $kind = HtmlSafe $fx.kind
    $effectsHtml += @"
      <section class="effect-box" data-effect="$($fx.key)">
        <div class="fx-layer" aria-hidden="true"></div>
        <div class="effect-content">
          <span class="pill">$($cat.num).$("{0:D2}" -f [int]$e.index) / $kind</span>
          <h2>$title</h2>
          <p>$desc</p>
          <span class="preview-note">Move cursor inside preview</span>
        </div>
        <div class="preview-zone" aria-hidden="true"></div>
        <a class="source-link" href="../sources/$($fx.key).html">See source code</a>
      </section>
"@
  }

  $catTitle = HtmlSafe $cat.title
  $catDesc = HtmlSafe $cat.desc

  $categoryHtml = @"
<!doctype html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex,nofollow">
  <title>$catTitle | Coldboot Cursor Library</title>
  <link rel="stylesheet" href="../assets/style.css">
  <link rel="stylesheet" href="../assets/quality-theme.css?v=$stamp">
</head>
<body>
  <div class="shell">
    <header class="nav">
      <a class="brand" href="../index.html"><span class="brand-dot"></span>Coldboot</a>
      <nav class="nav-links">
        <a href="../index.html">Home</a>
        <a href="#effects">Effects</a>
        <a href="../index.html#categories">Categories</a>
        <button class="theme-toggle" data-theme-toggle type="button">鈽?/button>
      </nav>
    </header>

    <section class="category-strip section-gap">
      <div class="section-head">
        <strong>Quality categories</strong>
        <button class="see-more" id="seeMoreBtn" type="button">See more</button>
      </div>
      <div class="category-grid" id="categoryGrid"></div>
    </section>

    <section class="category-hero">
      <div class="text">
        <span class="pill">$($cat.num) / category</span>
        <h1>$catTitle</h1>
        <p>$catDesc</p>
      </div>
    </section>

    <section class="effects-stack" id="effects">
$($effectsHtml -join "`r`n")
    </section>

    <footer>$catTitle has $($cat.effects.Count) redesigned cursor effects.</footer>
  </div>
  <script src="../assets/data.js?v=$stamp"></script>
  <script src="../assets/fx.js?v=$stamp"></script>
  <script src="../assets/app.js?v=$stamp"></script>
  <script>initCategoryPage("$($cat.id)");</script>
</body>
</html>
"@

  Write-Utf8File ".\categories\$($cat.id).html" $categoryHtml
}

foreach ($fx in $coldEffects) {
  $title = HtmlSafe $fx.name
  $desc = HtmlSafe $fx.desc

  $htmlDemo = @"
<section class="cursor-demo" data-cursor-effect="$($fx.key)">
  <div class="fx-layer" aria-hidden="true"></div>
</section>
"@

  $cssDemo = @"
.cursor-demo {
  position: relative;
  min-height: 320px;
  overflow: hidden;
  border-radius: 24px;
}

.fx-layer {
  position: absolute;
  inset: 0;
  pointer-events: none;
}
"@

  $jsDemo = @"
const effect = COLD_EFFECTS.find((item) => item.key === "$($fx.key)");
const target = document.querySelector("[data-cursor-effect='$($fx.key)']");
const layer = target.querySelector(".fx-layer");

target.addEventListener("pointermove", (event) => {
  const rect = layer.getBoundingClientRect();
  COLD_FX.spawn(effect, layer, event.clientX - rect.left, event.clientY - rect.top);
});
"@

  $sourceHtml = @"
<!doctype html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex,nofollow">
  <title>$title | Source Code</title>
  <link rel="stylesheet" href="../assets/style.css">
  <link rel="stylesheet" href="../assets/quality-theme.css?v=$stamp">
</head>
<body>
  <div class="shell">
    <header class="nav">
      <a class="brand" href="../index.html"><span class="brand-dot"></span>Coldboot</a>
      <nav class="nav-links">
        <a href="../categories/$($fx.cat_id).html">Back</a>
        <a href="#preview">Preview</a>
        <a href="#code">Code</a>
        <button class="theme-toggle" data-theme-toggle type="button">鈽?/button>
      </nav>
    </header>

    <section class="category-hero">
      <div class="text">
        <span class="pill">$($fx.cat_num).$("{0:D2}" -f [int]$fx.index) / source</span>
        <h1>$title</h1>
        <p>$desc</p>
      </div>
    </section>

    <section class="source-preview section-gap" id="sourcePreview" data-effect="$($fx.key)">
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

      <pre class="code-pane" data-code="html"><code>$(HtmlSafe $htmlDemo)</code></pre>
      <pre class="code-pane" data-code="css" hidden><code>$(HtmlSafe $cssDemo)</code></pre>
      <pre class="code-pane" data-code="js" hidden><code>$(HtmlSafe $jsDemo)</code></pre>
    </section>

    <footer>Theme aware effect: dark and light palettes are included in assets/data.js.</footer>
  </div>
  <script src="../assets/data.js?v=$stamp"></script>
  <script src="../assets/fx.js?v=$stamp"></script>
  <script src="../assets/app.js?v=$stamp"></script>
  <script>initSourcePage("$($fx.key)");</script>
</body>
</html>
"@

  Write-Utf8File ".\sources\$($fx.key).html" $sourceHtml
}

# Clean browser-sticky old theme values on next load by keeping only the new key.
# The app.js ignores old coldboot-theme now.

Write-Host "DONE: cursor library rebuilt for quality."
Write-Host "DONE: 12 old categories became 6 focused categories."
Write-Host "DONE: 72 similar effects became 36 unique effects."
Write-Host "DONE: every effect now has dark and light palette data."
Write-Host "DONE: index, category pages, source pages, data.js, fx.js, and app.js regenerated."
Write-Host "Backup saved here:"
Write-Host $backup

