$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\data.js") -or !(Test-Path ".\assets\fx.js") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-before-mega-70-pack_$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-Utf8($p) {
  [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Save-Utf8($p, $t) {
  [System.IO.File]::WriteAllText($p, $t, $script:utf8NoBom)
}

function HtmlSafe($value) {
  [System.Net.WebUtility]::HtmlEncode([string]$value)
}

Write-Host "1) Writing 70-effect data patch..."

$json = @'
{
  "categories": [
    {
      "id": "mega-ash-smoke",
      "num": "01",
      "title": "Ash & Smoke",
      "desc": "Dry ash, soot, vapor and ember-style cursor motion.",
      "icon": "ash",
      "effects": [
        "pm-ash-spiral",
        "pm-ember-veil",
        "pm-smoke-knot",
        "pm-cinder-lift",
        "pm-soot-comet",
        "pm-burnt-pollen",
        "pm-charcoal-rain",
        "pm-vapor-stitch",
        "pm-ghost-ash",
        "pm-coal-flicker"
      ]
    },
    {
      "id": "mega-glass-light",
      "num": "02",
      "title": "Glass & Light",
      "desc": "Clean scratches, prism cuts, bloom rings and needle-light motion.",
      "icon": "glass",
      "effects": [
        "pm-glass-scratch",
        "pm-prism-crack",
        "pm-mirror-splinter",
        "pm-lens-bloom",
        "pm-frost-shard",
        "pm-crystal-orbit",
        "pm-light-thread",
        "pm-halo-split",
        "pm-star-glint",
        "pm-flare-needle"
      ]
    },
    {
      "id": "mega-code-data",
      "num": "03",
      "title": "Code & Data",
      "desc": "Binary, brackets, packets, scanlines and terminal-inspired motion.",
      "icon": "code",
      "effects": [
        "pm-binary-rain",
        "pm-terminal-caret",
        "pm-bracket-orbit",
        "pm-cursor-matrix",
        "pm-syntax-sparks",
        "pm-command-echo",
        "pm-packet-trace",
        "pm-scanline-break",
        "pm-hex-bloom",
        "pm-prompt-ghost"
      ]
    },
    {
      "id": "mega-ink-paper",
      "num": "04",
      "title": "Ink & Paper",
      "desc": "Ink wings, torn paper, graphite dust and typewriter-like cursor motion.",
      "icon": "ink",
      "effects": [
        "pm-ink-moth",
        "pm-paper-cuts",
        "pm-calligraphy-smoke",
        "pm-torn-edge",
        "pm-graphite-dust",
        "pm-manuscript-fireflies",
        "pm-folded-corner",
        "pm-typewriter-ghost",
        "pm-stamp-burst",
        "pm-vellum-snow"
      ]
    },
    {
      "id": "mega-cosmic-mech",
      "num": "05",
      "title": "Cosmic & Mechanical",
      "desc": "Orbit, gravity, gears, compass sparks and mechanical cursor motion.",
      "icon": "cosmic",
      "effects": [
        "pm-orbit-needle",
        "pm-gravity-well",
        "pm-tiny-eclipse",
        "pm-star-map",
        "pm-clockwork-bits",
        "pm-magnet-shards",
        "pm-satellite-pulse",
        "pm-black-hole-dust",
        "pm-gear-sparks",
        "pm-compass-flare"
      ]
    },
    {
      "id": "basic-cursor-marks",
      "num": "06",
      "title": "Basic Cursor Marks",
      "desc": "Simple clean cursor-follow marks: rings, crosses, squares and small trails.",
      "icon": "basic",
      "effects": [
        "bc-soft-dot",
        "bc-clean-ring",
        "bc-cross-plus",
        "bc-tiny-plus",
        "bc-cursor-halo",
        "bc-square-pulse",
        "bc-triangle-tick",
        "bc-underline-trail",
        "bc-corner-ticks",
        "bc-mini-dash"
      ]
    },
    {
      "id": "basic-interface-kit",
      "num": "07",
      "title": "Interface Basics",
      "desc": "Default UI cursor helpers with simple motion and clean shapes.",
      "icon": "ui",
      "effects": [
        "bc-default-pointer",
        "bc-caret-blink",
        "bc-target-dot",
        "bc-click-ripple",
        "bc-small-spark",
        "bc-plain-ring",
        "bc-follow-bar",
        "bc-axis-mark",
        "bc-mono-dot",
        "bc-quiet-bubble"
      ]
    }
  ],
  "effects": [
    {
      "key": "pm-ash-spiral",
      "name": "Ash Spiral",
      "desc": "Ash dots spiral outward like burnt paper.",
      "kind": "mega-rich",
      "mode": "ashSpiral",
      "cat_id": "mega-ash-smoke",
      "cat_num": "01",
      "cat_title": "Ash & Smoke",
      "cat_desc": "Dry ash, soot, vapor and ember-style cursor motion.",
      "cat_icon": "ash",
      "index": 1,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-ember-veil",
      "name": "Ember Veil",
      "desc": "Warm ember specks lift and vanish in a loose veil.",
      "kind": "mega-rich",
      "mode": "emberVeil",
      "cat_id": "mega-ash-smoke",
      "cat_num": "01",
      "cat_title": "Ash & Smoke",
      "cat_desc": "Dry ash, soot, vapor and ember-style cursor motion.",
      "cat_icon": "ash",
      "index": 2,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-smoke-knot",
      "name": "Smoke Knot",
      "desc": "Soft smoke blobs fold around the cursor before fading.",
      "kind": "mega-rich",
      "mode": "smokeKnot",
      "cat_id": "mega-ash-smoke",
      "cat_num": "01",
      "cat_title": "Ash & Smoke",
      "cat_desc": "Dry ash, soot, vapor and ember-style cursor motion.",
      "cat_icon": "ash",
      "index": 3,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-cinder-lift",
      "name": "Cinder Lift",
      "desc": "Sharp cinder flakes rise with a dry upward pull.",
      "kind": "mega-rich",
      "mode": "cinderLift",
      "cat_id": "mega-ash-smoke",
      "cat_num": "01",
      "cat_title": "Ash & Smoke",
      "cat_desc": "Dry ash, soot, vapor and ember-style cursor motion.",
      "cat_icon": "ash",
      "index": 4,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-soot-comet",
      "name": "Soot Comet",
      "desc": "Dark soot marks shoot away with a tiny comet tail.",
      "kind": "mega-rich",
      "mode": "sootComet",
      "cat_id": "mega-ash-smoke",
      "cat_num": "01",
      "cat_title": "Ash & Smoke",
      "cat_desc": "Dry ash, soot, vapor and ember-style cursor motion.",
      "cat_icon": "ash",
      "index": 5,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-burnt-pollen",
      "name": "Burnt Pollen",
      "desc": "Small pollen-like ash clusters scatter in uneven groups.",
      "kind": "mega-rich",
      "mode": "burntPollen",
      "cat_id": "mega-ash-smoke",
      "cat_num": "01",
      "cat_title": "Ash & Smoke",
      "cat_desc": "Dry ash, soot, vapor and ember-style cursor motion.",
      "cat_icon": "ash",
      "index": 6,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-charcoal-rain",
      "name": "Charcoal Rain",
      "desc": "Muted charcoal grains fall down with gravity.",
      "kind": "mega-rich",
      "mode": "charcoalRain",
      "cat_id": "mega-ash-smoke",
      "cat_num": "01",
      "cat_title": "Ash & Smoke",
      "cat_desc": "Dry ash, soot, vapor and ember-style cursor motion.",
      "cat_icon": "ash",
      "index": 7,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-vapor-stitch",
      "name": "Vapor Stitch",
      "desc": "Broken vapor stitches trail behind the pointer.",
      "kind": "mega-rich",
      "mode": "vaporStitch",
      "cat_id": "mega-ash-smoke",
      "cat_num": "01",
      "cat_title": "Ash & Smoke",
      "cat_desc": "Dry ash, soot, vapor and ember-style cursor motion.",
      "cat_icon": "ash",
      "index": 8,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-ghost-ash",
      "name": "Ghost Ash",
      "desc": "Pale ghost-ash rings drift and dissolve slowly.",
      "kind": "mega-rich",
      "mode": "ghostAsh",
      "cat_id": "mega-ash-smoke",
      "cat_num": "01",
      "cat_title": "Ash & Smoke",
      "cat_desc": "Dry ash, soot, vapor and ember-style cursor motion.",
      "cat_icon": "ash",
      "index": 9,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-coal-flicker",
      "name": "Coal Flicker",
      "desc": "Tiny coal sparks flicker close to the cursor.",
      "kind": "mega-rich",
      "mode": "coalFlicker",
      "cat_id": "mega-ash-smoke",
      "cat_num": "01",
      "cat_title": "Ash & Smoke",
      "cat_desc": "Dry ash, soot, vapor and ember-style cursor motion.",
      "cat_icon": "ash",
      "index": 10,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-glass-scratch",
      "name": "Glass Scratch",
      "desc": "Sharp glass scratches slice and disappear.",
      "kind": "mega-rich",
      "mode": "glassScratch",
      "cat_id": "mega-glass-light",
      "cat_num": "02",
      "cat_title": "Glass & Light",
      "cat_desc": "Clean scratches, prism cuts, bloom rings and needle-light motion.",
      "cat_icon": "glass",
      "index": 1,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-prism-crack",
      "name": "Prism Crack",
      "desc": "Angular prism shards burst from the pointer.",
      "kind": "mega-rich",
      "mode": "prismCrack",
      "cat_id": "mega-glass-light",
      "cat_num": "02",
      "cat_title": "Glass & Light",
      "cat_desc": "Clean scratches, prism cuts, bloom rings and needle-light motion.",
      "cat_icon": "glass",
      "index": 2,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-mirror-splinter",
      "name": "Mirror Splinter",
      "desc": "Small mirror splinters rotate away quickly.",
      "kind": "mega-rich",
      "mode": "mirrorSplinter",
      "cat_id": "mega-glass-light",
      "cat_num": "02",
      "cat_title": "Glass & Light",
      "cat_desc": "Clean scratches, prism cuts, bloom rings and needle-light motion.",
      "cat_icon": "glass",
      "index": 3,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-lens-bloom",
      "name": "Lens Bloom",
      "desc": "A thin lens ring blooms outward with soft light.",
      "kind": "mega-rich",
      "mode": "lensBloom",
      "cat_id": "mega-glass-light",
      "cat_num": "02",
      "cat_title": "Glass & Light",
      "cat_desc": "Clean scratches, prism cuts, bloom rings and needle-light motion.",
      "cat_icon": "glass",
      "index": 4,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-frost-shard",
      "name": "Frost Shard",
      "desc": "Cold shard needles fan out with crisp motion.",
      "kind": "mega-rich",
      "mode": "frostShard",
      "cat_id": "mega-glass-light",
      "cat_num": "02",
      "cat_title": "Glass & Light",
      "cat_desc": "Clean scratches, prism cuts, bloom rings and needle-light motion.",
      "cat_icon": "glass",
      "index": 5,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-crystal-orbit",
      "name": "Crystal Orbit",
      "desc": "Tiny crystal diamonds orbit before snapping out.",
      "kind": "mega-rich",
      "mode": "crystalOrbit",
      "cat_id": "mega-glass-light",
      "cat_num": "02",
      "cat_title": "Glass & Light",
      "cat_desc": "Clean scratches, prism cuts, bloom rings and needle-light motion.",
      "cat_icon": "glass",
      "index": 6,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-light-thread",
      "name": "Light Thread",
      "desc": "Thin light threads cross the cursor and fade.",
      "kind": "mega-rich",
      "mode": "lightThread",
      "cat_id": "mega-glass-light",
      "cat_num": "02",
      "cat_title": "Glass & Light",
      "cat_desc": "Clean scratches, prism cuts, bloom rings and needle-light motion.",
      "cat_icon": "glass",
      "index": 7,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-halo-split",
      "name": "Halo Split",
      "desc": "A halo splits into two offset rings.",
      "kind": "mega-rich",
      "mode": "haloSplit",
      "cat_id": "mega-glass-light",
      "cat_num": "02",
      "cat_title": "Glass & Light",
      "cat_desc": "Clean scratches, prism cuts, bloom rings and needle-light motion.",
      "cat_icon": "glass",
      "index": 8,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-star-glint",
      "name": "Star Glint",
      "desc": "Small star glints pop with a premium sparkle.",
      "kind": "mega-rich",
      "mode": "starGlint",
      "cat_id": "mega-glass-light",
      "cat_num": "02",
      "cat_title": "Glass & Light",
      "cat_desc": "Clean scratches, prism cuts, bloom rings and needle-light motion.",
      "cat_icon": "glass",
      "index": 9,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-flare-needle",
      "name": "Flare Needle",
      "desc": "Long flare needles radiate from the cursor.",
      "kind": "mega-rich",
      "mode": "flareNeedle",
      "cat_id": "mega-glass-light",
      "cat_num": "02",
      "cat_title": "Glass & Light",
      "cat_desc": "Clean scratches, prism cuts, bloom rings and needle-light motion.",
      "cat_icon": "glass",
      "index": 10,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-binary-rain",
      "name": "Binary Rain",
      "desc": "Tiny binary marks fall and fade near the cursor.",
      "kind": "mega-rich",
      "mode": "binaryRain",
      "cat_id": "mega-code-data",
      "cat_num": "03",
      "cat_title": "Code & Data",
      "cat_desc": "Binary, brackets, packets, scanlines and terminal-inspired motion.",
      "cat_icon": "code",
      "index": 1,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-terminal-caret",
      "name": "Terminal Caret",
      "desc": "Blinking terminal carets jump away from the cursor.",
      "kind": "mega-rich",
      "mode": "terminalCaret",
      "cat_id": "mega-code-data",
      "cat_num": "03",
      "cat_title": "Code & Data",
      "cat_desc": "Binary, brackets, packets, scanlines and terminal-inspired motion.",
      "cat_icon": "code",
      "index": 2,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-bracket-orbit",
      "name": "Bracket Orbit",
      "desc": "Code brackets orbit briefly around the pointer.",
      "kind": "mega-rich",
      "mode": "bracketOrbit",
      "cat_id": "mega-code-data",
      "cat_num": "03",
      "cat_title": "Code & Data",
      "cat_desc": "Binary, brackets, packets, scanlines and terminal-inspired motion.",
      "cat_icon": "code",
      "index": 3,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-cursor-matrix",
      "name": "Cursor Matrix",
      "desc": "Mini matrix cells drift and break apart.",
      "kind": "mega-rich",
      "mode": "cursorMatrix",
      "cat_id": "mega-code-data",
      "cat_num": "03",
      "cat_title": "Code & Data",
      "cat_desc": "Binary, brackets, packets, scanlines and terminal-inspired motion.",
      "cat_icon": "code",
      "index": 4,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-syntax-sparks",
      "name": "Syntax Sparks",
      "desc": "Code symbols pop like sparks around the cursor.",
      "kind": "mega-rich",
      "mode": "syntaxSparks",
      "cat_id": "mega-code-data",
      "cat_num": "03",
      "cat_title": "Code & Data",
      "cat_desc": "Binary, brackets, packets, scanlines and terminal-inspired motion.",
      "cat_icon": "code",
      "index": 5,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-command-echo",
      "name": "Command Echo",
      "desc": "Small command echoes repeat and fade behind movement.",
      "kind": "mega-rich",
      "mode": "commandEcho",
      "cat_id": "mega-code-data",
      "cat_num": "03",
      "cat_title": "Code & Data",
      "cat_desc": "Binary, brackets, packets, scanlines and terminal-inspired motion.",
      "cat_icon": "code",
      "index": 6,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-packet-trace",
      "name": "Packet Trace",
      "desc": "Packet dots trace short network-like lines.",
      "kind": "mega-rich",
      "mode": "packetTrace",
      "cat_id": "mega-code-data",
      "cat_num": "03",
      "cat_title": "Code & Data",
      "cat_desc": "Binary, brackets, packets, scanlines and terminal-inspired motion.",
      "cat_icon": "code",
      "index": 7,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-scanline-break",
      "name": "Scanline Break",
      "desc": "Scan bars tear apart horizontally.",
      "kind": "mega-rich",
      "mode": "scanlineBreak",
      "cat_id": "mega-code-data",
      "cat_num": "03",
      "cat_title": "Code & Data",
      "cat_desc": "Binary, brackets, packets, scanlines and terminal-inspired motion.",
      "cat_icon": "code",
      "index": 8,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-hex-bloom",
      "name": "Hex Bloom",
      "desc": "Hex marks bloom outward in a radial burst.",
      "kind": "mega-rich",
      "mode": "hexBloom",
      "cat_id": "mega-code-data",
      "cat_num": "03",
      "cat_title": "Code & Data",
      "cat_desc": "Binary, brackets, packets, scanlines and terminal-inspired motion.",
      "cat_icon": "code",
      "index": 9,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-prompt-ghost",
      "name": "Prompt Ghost",
      "desc": "Ghosted prompt symbols float upward and vanish.",
      "kind": "mega-rich",
      "mode": "promptGhost",
      "cat_id": "mega-code-data",
      "cat_num": "03",
      "cat_title": "Code & Data",
      "cat_desc": "Binary, brackets, packets, scanlines and terminal-inspired motion.",
      "cat_icon": "code",
      "index": 10,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-ink-moth",
      "name": "Ink Moth",
      "desc": "Two ink wings open and dissolve like a tiny moth.",
      "kind": "mega-rich",
      "mode": "inkMoth",
      "cat_id": "mega-ink-paper",
      "cat_num": "04",
      "cat_title": "Ink & Paper",
      "cat_desc": "Ink wings, torn paper, graphite dust and typewriter-like cursor motion.",
      "cat_icon": "ink",
      "index": 1,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-paper-cuts",
      "name": "Paper Cuts",
      "desc": "Thin paper cut marks flick away from the pointer.",
      "kind": "mega-rich",
      "mode": "paperCuts",
      "cat_id": "mega-ink-paper",
      "cat_num": "04",
      "cat_title": "Ink & Paper",
      "cat_desc": "Ink wings, torn paper, graphite dust and typewriter-like cursor motion.",
      "cat_icon": "ink",
      "index": 2,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-calligraphy-smoke",
      "name": "Calligraphy Smoke",
      "desc": "Ink strokes curl like smoke and disappear.",
      "kind": "mega-rich",
      "mode": "calligraphySmoke",
      "cat_id": "mega-ink-paper",
      "cat_num": "04",
      "cat_title": "Ink & Paper",
      "cat_desc": "Ink wings, torn paper, graphite dust and typewriter-like cursor motion.",
      "cat_icon": "ink",
      "index": 3,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-torn-edge",
      "name": "Torn Edge",
      "desc": "Ripped paper fragments scatter with rough motion.",
      "kind": "mega-rich",
      "mode": "tornEdge",
      "cat_id": "mega-ink-paper",
      "cat_num": "04",
      "cat_title": "Ink & Paper",
      "cat_desc": "Ink wings, torn paper, graphite dust and typewriter-like cursor motion.",
      "cat_icon": "ink",
      "index": 4,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-graphite-dust",
      "name": "Graphite Dust",
      "desc": "Muted graphite dust trails behind cursor movement.",
      "kind": "mega-rich",
      "mode": "graphiteDust",
      "cat_id": "mega-ink-paper",
      "cat_num": "04",
      "cat_title": "Ink & Paper",
      "cat_desc": "Ink wings, torn paper, graphite dust and typewriter-like cursor motion.",
      "cat_icon": "ink",
      "index": 5,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-manuscript-fireflies",
      "name": "Manuscript Fireflies",
      "desc": "Tiny manuscript dots glow and drift softly.",
      "kind": "mega-rich",
      "mode": "manuscriptFireflies",
      "cat_id": "mega-ink-paper",
      "cat_num": "04",
      "cat_title": "Ink & Paper",
      "cat_desc": "Ink wings, torn paper, graphite dust and typewriter-like cursor motion.",
      "cat_icon": "ink",
      "index": 6,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-folded-corner",
      "name": "Folded Corner",
      "desc": "Small folded-corner triangles flip and fade.",
      "kind": "mega-rich",
      "mode": "foldedCorner",
      "cat_id": "mega-ink-paper",
      "cat_num": "04",
      "cat_title": "Ink & Paper",
      "cat_desc": "Ink wings, torn paper, graphite dust and typewriter-like cursor motion.",
      "cat_icon": "ink",
      "index": 7,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-typewriter-ghost",
      "name": "Typewriter Ghost",
      "desc": "Ghost letters appear like old typewriter marks.",
      "kind": "mega-rich",
      "mode": "typewriterGhost",
      "cat_id": "mega-ink-paper",
      "cat_num": "04",
      "cat_title": "Ink & Paper",
      "cat_desc": "Ink wings, torn paper, graphite dust and typewriter-like cursor motion.",
      "cat_icon": "ink",
      "index": 8,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-stamp-burst",
      "name": "Stamp Burst",
      "desc": "A stamp-like pulse breaks into paper dust.",
      "kind": "mega-rich",
      "mode": "stampBurst",
      "cat_id": "mega-ink-paper",
      "cat_num": "04",
      "cat_title": "Ink & Paper",
      "cat_desc": "Ink wings, torn paper, graphite dust and typewriter-like cursor motion.",
      "cat_icon": "ink",
      "index": 9,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-vellum-snow",
      "name": "Vellum Snow",
      "desc": "Soft vellum flakes drift with paper-like weight.",
      "kind": "mega-rich",
      "mode": "vellumSnow",
      "cat_id": "mega-ink-paper",
      "cat_num": "04",
      "cat_title": "Ink & Paper",
      "cat_desc": "Ink wings, torn paper, graphite dust and typewriter-like cursor motion.",
      "cat_icon": "ink",
      "index": 10,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-orbit-needle",
      "name": "Orbit Needle",
      "desc": "Thin needle marks orbit and snap away.",
      "kind": "mega-rich",
      "mode": "orbitNeedle",
      "cat_id": "mega-cosmic-mech",
      "cat_num": "05",
      "cat_title": "Cosmic & Mechanical",
      "cat_desc": "Orbit, gravity, gears, compass sparks and mechanical cursor motion.",
      "cat_icon": "cosmic",
      "index": 1,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-gravity-well",
      "name": "Gravity Well",
      "desc": "Dust bends inward then collapses into the cursor.",
      "kind": "mega-rich",
      "mode": "gravityWell",
      "cat_id": "mega-cosmic-mech",
      "cat_num": "05",
      "cat_title": "Cosmic & Mechanical",
      "cat_desc": "Orbit, gravity, gears, compass sparks and mechanical cursor motion.",
      "cat_icon": "cosmic",
      "index": 2,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-tiny-eclipse",
      "name": "Tiny Eclipse",
      "desc": "A small eclipse ring crosses and fades.",
      "kind": "mega-rich",
      "mode": "tinyEclipse",
      "cat_id": "mega-cosmic-mech",
      "cat_num": "05",
      "cat_title": "Cosmic & Mechanical",
      "cat_desc": "Orbit, gravity, gears, compass sparks and mechanical cursor motion.",
      "cat_icon": "cosmic",
      "index": 3,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-star-map",
      "name": "Star Map",
      "desc": "Tiny map points connect like a small constellation.",
      "kind": "mega-rich",
      "mode": "starMap",
      "cat_id": "mega-cosmic-mech",
      "cat_num": "05",
      "cat_title": "Cosmic & Mechanical",
      "cat_desc": "Orbit, gravity, gears, compass sparks and mechanical cursor motion.",
      "cat_icon": "cosmic",
      "index": 4,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-clockwork-bits",
      "name": "Clockwork Bits",
      "desc": "Small mechanical ticks rotate around the pointer.",
      "kind": "mega-rich",
      "mode": "clockworkBits",
      "cat_id": "mega-cosmic-mech",
      "cat_num": "05",
      "cat_title": "Cosmic & Mechanical",
      "cat_desc": "Orbit, gravity, gears, compass sparks and mechanical cursor motion.",
      "cat_icon": "cosmic",
      "index": 5,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-magnet-shards",
      "name": "Magnet Shards",
      "desc": "Shard marks pull inward then scatter outward.",
      "kind": "mega-rich",
      "mode": "magnetShards",
      "cat_id": "mega-cosmic-mech",
      "cat_num": "05",
      "cat_title": "Cosmic & Mechanical",
      "cat_desc": "Orbit, gravity, gears, compass sparks and mechanical cursor motion.",
      "cat_icon": "cosmic",
      "index": 6,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-satellite-pulse",
      "name": "Satellite Pulse",
      "desc": "A satellite-like dot orbits then shoots away.",
      "kind": "mega-rich",
      "mode": "satellitePulse",
      "cat_id": "mega-cosmic-mech",
      "cat_num": "05",
      "cat_title": "Cosmic & Mechanical",
      "cat_desc": "Orbit, gravity, gears, compass sparks and mechanical cursor motion.",
      "cat_icon": "cosmic",
      "index": 7,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-black-hole-dust",
      "name": "Black Hole Dust",
      "desc": "Dust circles the cursor and collapses darkly.",
      "kind": "mega-rich",
      "mode": "blackHoleDust",
      "cat_id": "mega-cosmic-mech",
      "cat_num": "05",
      "cat_title": "Cosmic & Mechanical",
      "cat_desc": "Orbit, gravity, gears, compass sparks and mechanical cursor motion.",
      "cat_icon": "cosmic",
      "index": 8,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-gear-sparks",
      "name": "Gear Sparks",
      "desc": "Gear-tooth sparks rotate and break apart.",
      "kind": "mega-rich",
      "mode": "gearSparks",
      "cat_id": "mega-cosmic-mech",
      "cat_num": "05",
      "cat_title": "Cosmic & Mechanical",
      "cat_desc": "Orbit, gravity, gears, compass sparks and mechanical cursor motion.",
      "cat_icon": "cosmic",
      "index": 9,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "pm-compass-flare",
      "name": "Compass Flare",
      "desc": "Compass ticks snap in four directions.",
      "kind": "mega-rich",
      "mode": "compassFlare",
      "cat_id": "mega-cosmic-mech",
      "cat_num": "05",
      "cat_title": "Cosmic & Mechanical",
      "cat_desc": "Orbit, gravity, gears, compass sparks and mechanical cursor motion.",
      "cat_icon": "cosmic",
      "index": 10,
      "dark": {
        "a": "#f1e7d6",
        "b": "#9d8c6e",
        "ink": "#17131f"
      },
      "light": {
        "a": "#211c16",
        "b": "#70614c",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-soft-dot",
      "name": "Soft Dot",
      "desc": "A quiet dot follows the cursor with a soft delay.",
      "kind": "mega-basic",
      "mode": "softDot",
      "cat_id": "basic-cursor-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple clean cursor-follow marks: rings, crosses, squares and small trails.",
      "cat_icon": "basic",
      "index": 1,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-clean-ring",
      "name": "Clean Ring",
      "desc": "A thin ring follows the pointer cleanly.",
      "kind": "mega-basic",
      "mode": "cleanRing",
      "cat_id": "basic-cursor-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple clean cursor-follow marks: rings, crosses, squares and small trails.",
      "cat_icon": "basic",
      "index": 2,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-cross-plus",
      "name": "Cross Plus",
      "desc": "A minimal plus mark follows the cursor.",
      "kind": "mega-basic",
      "mode": "crossPlus",
      "cat_id": "basic-cursor-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple clean cursor-follow marks: rings, crosses, squares and small trails.",
      "cat_icon": "basic",
      "index": 3,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-tiny-plus",
      "name": "Tiny Plus",
      "desc": "A small plus mark with lighter motion.",
      "kind": "mega-basic",
      "mode": "tinyPlus",
      "cat_id": "basic-cursor-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple clean cursor-follow marks: rings, crosses, squares and small trails.",
      "cat_icon": "basic",
      "index": 4,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-cursor-halo",
      "name": "Cursor Halo",
      "desc": "A subtle halo follows cursor movement.",
      "kind": "mega-basic",
      "mode": "cursorHalo",
      "cat_id": "basic-cursor-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple clean cursor-follow marks: rings, crosses, squares and small trails.",
      "cat_icon": "basic",
      "index": 5,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-square-pulse",
      "name": "Square Pulse",
      "desc": "A small square pulse tracks the pointer.",
      "kind": "mega-basic",
      "mode": "squarePulse",
      "cat_id": "basic-cursor-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple clean cursor-follow marks: rings, crosses, squares and small trails.",
      "cat_icon": "basic",
      "index": 6,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-triangle-tick",
      "name": "Triangle Tick",
      "desc": "A tiny triangle tick follows with rotation.",
      "kind": "mega-basic",
      "mode": "triangleTick",
      "cat_id": "basic-cursor-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple clean cursor-follow marks: rings, crosses, squares and small trails.",
      "cat_icon": "basic",
      "index": 7,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-underline-trail",
      "name": "Underline Trail",
      "desc": "A small underline bar follows beneath the cursor.",
      "kind": "mega-basic",
      "mode": "underlineTrail",
      "cat_id": "basic-cursor-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple clean cursor-follow marks: rings, crosses, squares and small trails.",
      "cat_icon": "basic",
      "index": 8,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-corner-ticks",
      "name": "Corner Ticks",
      "desc": "Four small corner ticks follow the pointer.",
      "kind": "mega-basic",
      "mode": "cornerTicks",
      "cat_id": "basic-cursor-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple clean cursor-follow marks: rings, crosses, squares and small trails.",
      "cat_icon": "basic",
      "index": 9,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-mini-dash",
      "name": "Mini Dash",
      "desc": "A tiny dash follows cursor direction.",
      "kind": "mega-basic",
      "mode": "miniDash",
      "cat_id": "basic-cursor-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple clean cursor-follow marks: rings, crosses, squares and small trails.",
      "cat_icon": "basic",
      "index": 10,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-default-pointer",
      "name": "Default Pointer",
      "desc": "A small pointer arrow follows the cursor.",
      "kind": "mega-basic",
      "mode": "defaultPointer",
      "cat_id": "basic-interface-kit",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI cursor helpers with simple motion and clean shapes.",
      "cat_icon": "ui",
      "index": 1,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-caret-blink",
      "name": "Caret Blink",
      "desc": "A blinking caret follows like a text cursor.",
      "kind": "mega-basic",
      "mode": "caretBlink",
      "cat_id": "basic-interface-kit",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI cursor helpers with simple motion and clean shapes.",
      "cat_icon": "ui",
      "index": 2,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-target-dot",
      "name": "Target Dot",
      "desc": "A clean target dot follows cursor movement.",
      "kind": "mega-basic",
      "mode": "targetDot",
      "cat_id": "basic-interface-kit",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI cursor helpers with simple motion and clean shapes.",
      "cat_icon": "ui",
      "index": 3,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-click-ripple",
      "name": "Click Ripple",
      "desc": "A simple ripple pulse follows the pointer.",
      "kind": "mega-basic",
      "mode": "clickRipple",
      "cat_id": "basic-interface-kit",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI cursor helpers with simple motion and clean shapes.",
      "cat_icon": "ui",
      "index": 4,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-small-spark",
      "name": "Small Spark",
      "desc": "A tiny spark mark follows with light rotation.",
      "kind": "mega-basic",
      "mode": "smallSpark",
      "cat_id": "basic-interface-kit",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI cursor helpers with simple motion and clean shapes.",
      "cat_icon": "ui",
      "index": 5,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-plain-ring",
      "name": "Plain Ring",
      "desc": "A plain neutral ring follows the pointer.",
      "kind": "mega-basic",
      "mode": "plainRing",
      "cat_id": "basic-interface-kit",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI cursor helpers with simple motion and clean shapes.",
      "cat_icon": "ui",
      "index": 6,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-follow-bar",
      "name": "Follow Bar",
      "desc": "A short bar follows cursor direction.",
      "kind": "mega-basic",
      "mode": "followBar",
      "cat_id": "basic-interface-kit",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI cursor helpers with simple motion and clean shapes.",
      "cat_icon": "ui",
      "index": 7,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-axis-mark",
      "name": "Axis Mark",
      "desc": "A small x/y axis mark follows the cursor.",
      "kind": "mega-basic",
      "mode": "axisMark",
      "cat_id": "basic-interface-kit",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI cursor helpers with simple motion and clean shapes.",
      "cat_icon": "ui",
      "index": 8,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-mono-dot",
      "name": "Mono Dot",
      "desc": "A simple mono dot with low movement delay.",
      "kind": "mega-basic",
      "mode": "monoDot",
      "cat_id": "basic-interface-kit",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI cursor helpers with simple motion and clean shapes.",
      "cat_icon": "ui",
      "index": 9,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "bc-quiet-bubble",
      "name": "Quiet Bubble",
      "desc": "A small soft bubble follows the cursor.",
      "kind": "mega-basic",
      "mode": "quietBubble",
      "cat_id": "basic-interface-kit",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI cursor helpers with simple motion and clean shapes.",
      "cat_icon": "ui",
      "index": 10,
      "dark": {
        "a": "#efe6d6",
        "b": "#a2947b",
        "ink": "#17131f"
      },
      "light": {
        "a": "#23201b",
        "b": "#766b5a",
        "ink": "#faf8f1"
      }
    }
  ]
}
'@

$pack = $json | ConvertFrom-Json
$catsJson = ($pack.categories | ConvertTo-Json -Depth 50) -replace "\\u0026", "&"
$effectsJson = ($pack.effects | ConvertTo-Json -Depth 50) -replace "\\u0026", "&"

$dataTemplate = @'
(function () {
  const addonCategories = __CATS__;
  const addonEffects = __EFFECTS__;
  const addonCategoryIds = new Set(addonCategories.map((cat) => cat.id));
  const addonEffectKeys = new Set(addonEffects.map((fx) => fx.key));

  const weakCategoryIds = new Set([
    "animal-friends",
    "wild-creatures",
    "classic-basics",
    "premium-motion",
    "mega-ash-smoke",
    "mega-glass-light",
    "mega-code-data",
    "mega-ink-paper",
    "mega-cosmic-mech",
    "basic-cursor-marks",
    "basic-interface-kit"
  ]);

  const weakEffectKeys = new Set([
    "cat-paw","butterfly-pair","bird-flock","rabbit-hop","dragonfly-dash",
    "spider-crawler","cockroach-skitter","crocodile-crawl","crocodile-snap",
    "mini-dragon","scorpion-tail","gecko-dash","bat-flutter","crab-walk",
    "default-dot","default-ring","default-crosshair","corner-bracket","click-flash",
    "ash-spiral","bone-embers","glass-scratch","cursor-lantern","orbit-needle",
    "ink-moth","glitch-scan","dark-snow","ash-ribbon","terminal-sparks"
  ]);

  window.COLD_DATA = (window.COLD_DATA || [])
    .filter((cat) => !weakCategoryIds.has(cat.id) && !addonCategoryIds.has(cat.id))
    .map((cat) => ({
      ...cat,
      effects: (cat.effects || []).filter((key) => !weakEffectKeys.has(key) && !addonEffectKeys.has(key))
    }))
    .filter((cat) => (cat.effects || []).length > 0);

  window.COLD_EFFECTS = (window.COLD_EFFECTS || [])
    .filter((fx) => !weakEffectKeys.has(fx.key) && !addonEffectKeys.has(fx.key));

  const start = window.COLD_DATA.length + 1;

  addonCategories.forEach((cat, index) => {
    const num = String(start + index).padStart(2, "0");
    const normalized = { ...cat, num };
    window.COLD_DATA.push(normalized);

    addonEffects
      .filter((fx) => fx.cat_id === cat.id)
      .forEach((fx) => {
        window.COLD_EFFECTS.push({
          ...fx,
          cat_num: num,
          cat_title: normalized.title,
          cat_desc: normalized.desc,
          cat_icon: normalized.icon
        });
      });
  });

  window.MEGA_MOTION_CATEGORIES = addonCategories;
  window.MEGA_MOTION_EFFECTS = addonEffects;
})();
'@

$dataJs = $dataTemplate.Replace("__CATS__", $catsJson).Replace("__EFFECTS__", $effectsJson)
Save-Utf8 ".\assets\mega-motion-data.js" $dataJs

Write-Host "2) Writing mega renderer..."

$rendererJs = @'

(function () {
  if (typeof COLD_FX === "undefined") return;

  const oldSpawn = COLD_FX.spawn.bind(COLD_FX);
  const oldClear = COLD_FX.clear ? COLD_FX.clear.bind(COLD_FX) : null;

  const MEGA_KEYS = new Set((window.MEGA_MOTION_EFFECTS || []).map((fx) => fx.key));
  const BASIC_STATES = new WeakMap();

  function rand(a, b) {
    return a + Math.random() * (b - a);
  }

  function pick(items) {
    return items[Math.floor(Math.random() * items.length)];
  }

  function pal(effect) {
    const light = document.documentElement.getAttribute("data-theme") === "light";
    return light ? (effect.light || effect.dark) : (effect.dark || effect.light);
  }

  function piece(layer, cls, x, y, effect, text) {
    const p = pal(effect);
    const el = document.createElement("span");
    el.className = "mega-fx " + cls;
    el.setAttribute("aria-hidden", "true");
    if (text != null) el.textContent = text;
    el.style.left = x + "px";
    el.style.top = y + "px";
    el.style.setProperty("--a", p.a);
    el.style.setProperty("--b", p.b);
    el.style.setProperty("--ink", p.ink);
    layer.appendChild(el);
    return el;
  }

  function fly(el, dx, dy, ms, scale = 1, rot = 0, anim = "megaFly") {
    el.style.setProperty("--dx", dx + "px");
    el.style.setProperty("--dy", dy + "px");
    el.style.setProperty("--sc", scale);
    el.style.setProperty("--rot", rot + "deg");
    el.style.animation = anim + " " + ms + "ms cubic-bezier(.16,.82,.28,1) forwards";
    setTimeout(() => el.remove(), ms + 80);
  }

  function line(layer, cls, x, y, effect, w, rot, dx, dy, ms) {
    const el = piece(layer, cls, x, y, effect);
    el.style.setProperty("--w", w + "px");
    fly(el, dx, dy, ms, rand(.75, 1.12), rot);
  }

  function dot(layer, cls, x, y, effect, s, dx, dy, ms, rot = 0) {
    const el = piece(layer, cls, x, y, effect);
    el.style.setProperty("--s", s + "px");
    fly(el, dx, dy, ms, rand(.45, 1.15), rot);
  }

  function textMark(layer, cls, x, y, effect, text, dx, dy, ms, rot = 0) {
    const el = piece(layer, cls, x, y, effect, text);
    fly(el, dx, dy, ms, rand(.75, 1.1), rot);
  }

  function shape(layer, cls, x, y, effect, dx, dy, ms, rot = 0) {
    const el = piece(layer, cls, x, y, effect);
    fly(el, dx, dy, ms, rand(.55, 1.15), rot);
  }

  function ring(layer, cls, x, y, effect, ms = 780) {
    const el = piece(layer, cls, x, y, effect);
    el.style.animation = "megaPulse " + ms + "ms ease-out forwards";
    setTimeout(() => el.remove(), ms + 80);
  }

  const RICH = {
    ashSpiral(effect, layer, x, y) {
      const base = performance.now() / 260;
      for (let i = 0; i < 5; i++) {
        const a = base + i * 1.22 + rand(-.16, .16);
        const d = rand(22, 62);
        dot(layer, "mega-ash-dot", x + Math.cos(a) * 8, y + Math.sin(a) * 8, effect, rand(3,7), Math.cos(a)*d, Math.sin(a)*d-rand(22,54), 860+i*45, rand(-180,180));
      }
    },
    emberVeil(effect, layer, x, y) {
      for (let i=0;i<6;i++) line(layer,"mega-warm-ember",x+rand(-14,14),y+rand(-8,10),effect,rand(8,22),rand(-90,90),rand(-28,28),rand(-86,-28),760+i*45);
    },
    smokeKnot(effect, layer, x, y) {
      for (let i=0;i<4;i++) dot(layer,"mega-smoke-blob",x+rand(-8,8),y+rand(-8,8),effect,rand(20,44),rand(-34,34),rand(-48,8),920+i*70,rand(-90,90));
    },
    cinderLift(effect, layer, x, y) {
      for (let i=0;i<6;i++) shape(layer,"mega-cinder",x+rand(-7,7),y+rand(-7,7),effect,rand(-40,40),rand(-95,-20),720+i*35,rand(-180,180));
    },
    sootComet(effect, layer, x, y) {
      for (let i=0;i<4;i++) line(layer,"mega-soot-comet",x,y,effect,rand(26,48),rand(-30,30),rand(-70,-20),rand(-22,22),680+i*50);
    },
    burntPollen(effect, layer, x, y) {
      for (let i=0;i<8;i++) dot(layer,"mega-pollen",x+rand(-12,12),y+rand(-12,12),effect,rand(3,6),rand(-55,55),rand(-55,20),780+i*30);
    },
    charcoalRain(effect, layer, x, y) {
      for (let i=0;i<7;i++) dot(layer,"mega-charcoal",x+rand(-18,18),y+rand(-10,8),effect,rand(4,8),rand(-16,16),rand(34,86),940+i*40,rand(-100,100));
    },
    vaporStitch(effect, layer, x, y) {
      for (let i=0;i<5;i++) line(layer,"mega-vapor-stitch",x+i*6-12,y+rand(-10,10),effect,rand(12,26),rand(-20,20),rand(-36,36),rand(-28,28),700+i*35);
    },
    ghostAsh(effect, layer, x, y) {
      for (let i=0;i<3;i++) ring(layer,"mega-ghost-ring",x+rand(-8,8),y+rand(-8,8),effect,860+i*80);
    },
    coalFlicker(effect, layer, x, y) {
      for (let i=0;i<5;i++) dot(layer,"mega-coal",x+rand(-6,6),y+rand(-6,6),effect,rand(5,10),rand(-24,24),rand(-32,12),620+i*30);
    },

    glassScratch(effect, layer, x, y) {
      for (let i=0;i<4;i++) line(layer,"mega-glass-line",x+rand(-6,6),y+rand(-6,6),effect,rand(30,72),rand(-70,70),rand(-54,54),rand(-42,42),560+i*55);
    },
    prismCrack(effect, layer, x, y) {
      for (let i=0;i<6;i++) shape(layer,"mega-prism",x+rand(-5,5),y+rand(-5,5),effect,rand(-58,58),rand(-58,58),700+i*40,rand(-180,180));
    },
    mirrorSplinter(effect, layer, x, y) {
      for (let i=0;i<5;i++) line(layer,"mega-mirror-splinter",x,y,effect,rand(18,40),rand(-140,140),rand(-60,60),rand(-50,50),600+i*45);
    },
    lensBloom(effect, layer, x, y) {
      ring(layer,"mega-lens-ring",x,y,effect,720);
      dot(layer,"mega-lens-core",x,y,effect,8,0,0,540,0);
    },
    frostShard(effect, layer, x, y) {
      for (let i=0;i<7;i++) line(layer,"mega-frost",x,y,effect,rand(18,34),i*26+rand(-8,8),Math.cos(i)*rand(22,50),Math.sin(i)*rand(22,50),690+i*30);
    },
    crystalOrbit(effect, layer, x, y) {
      const base=performance.now()/160;
      for (let i=0;i<5;i++){const a=base+i*1.25; shape(layer,"mega-crystal",x+Math.cos(a)*18,y+Math.sin(a)*18,effect,Math.cos(a)*rand(38,62),Math.sin(a)*rand(38,62),700+i*35,a*180/Math.PI);}
    },
    lightThread(effect, layer, x, y) {
      for (let i=0;i<4;i++) line(layer,"mega-light-thread",x+rand(-16,16),y+rand(-16,16),effect,rand(45,85),rand(-40,40),rand(-36,36),rand(-36,36),760+i*40);
    },
    haloSplit(effect, layer, x, y) {
      const a = piece(layer,"mega-halo-left",x,y,effect); fly(a,-30,-6,760,1.25,-8,"megaSplitRing");
      const b = piece(layer,"mega-halo-right",x,y,effect); fly(b,30,6,760,1.25,8,"megaSplitRing");
    },
    starGlint(effect, layer, x, y) {
      for(let i=0;i<4;i++) shape(layer,"mega-star-glint",x+rand(-10,10),y+rand(-10,10),effect,rand(-34,34),rand(-34,34),620+i*50,rand(-90,90));
    },
    flareNeedle(effect, layer, x, y) {
      for (let i=0;i<8;i++){const a=i*Math.PI/4; line(layer,"mega-flare-needle",x,y,effect,rand(28,55),a*180/Math.PI,Math.cos(a)*rand(30,65),Math.sin(a)*rand(30,65),620+i*25);}
    },

    binaryRain(effect, layer, x, y) {
      for(let i=0;i<6;i++) textMark(layer,"mega-code-text",x+rand(-22,22),y+rand(-10,10),effect,pick(["0","1"]),rand(-10,10),rand(42,95),820+i*35,0);
    },
    terminalCaret(effect, layer, x, y) {
      for(let i=0;i<5;i++) textMark(layer,"mega-code-text caret",x+rand(-10,10),y+rand(-10,10),effect,"_",rand(-48,48),rand(-30,30),620+i*40,0);
    },
    bracketOrbit(effect, layer, x, y) {
      const marks=["{","}","[","]","(",")"];
      for(let i=0;i<6;i++){const a=i*Math.PI/3+performance.now()/260; textMark(layer,"mega-code-text bracket",x+Math.cos(a)*18,y+Math.sin(a)*18,effect,marks[i],Math.cos(a)*48,Math.sin(a)*48,720+i*25,a*30);}
    },
    cursorMatrix(effect, layer, x, y) {
      for(let i=0;i<7;i++) textMark(layer,"mega-matrix-cell",x+rand(-25,25),y+rand(-20,20),effect,pick(["01","10","<>","//"]),rand(-28,28),rand(-50,60),760+i*30,0);
    },
    syntaxSparks(effect, layer, x, y) {
      for(let i=0;i<7;i++) textMark(layer,"mega-code-spark",x,y,effect,pick(["*",";","=","=>","/"]),rand(-60,60),rand(-45,45),660+i*30,rand(-40,40));
    },
    commandEcho(effect, layer, x, y) {
      for(let i=0;i<4;i++) textMark(layer,"mega-command-echo",x-i*5,y+i*3,effect,">",rand(-42,10),rand(-16,16),700+i*70,0);
    },
    packetTrace(effect, layer, x, y) {
      for(let i=0;i<4;i++){line(layer,"mega-packet-line",x,y,effect,rand(36,68),rand(-25,25),rand(30,70),rand(-20,20),700+i*45); dot(layer,"mega-packet-dot",x,y,effect,5,rand(35,75),rand(-20,20),700+i*45);}
    },
    scanlineBreak(effect, layer, x, y) {
      for(let i=0;i<5;i++) line(layer,"mega-scanline",x+rand(-8,8),y+(i-2)*7,effect,rand(38,86),0,rand(-70,70),rand(-8,8),580+i*35);
    },
    hexBloom(effect, layer, x, y) {
      for(let i=0;i<6;i++){const a=i*Math.PI/3; textMark(layer,"mega-hex",x,y,effect,"⬡",Math.cos(a)*rand(35,65),Math.sin(a)*rand(35,65),680+i*30,a*180/Math.PI);}
    },
    promptGhost(effect, layer, x, y) {
      for(let i=0;i<4;i++) textMark(layer,"mega-prompt-ghost",x+rand(-8,8),y+rand(-8,8),effect,pick([">","$","~"]),rand(-20,20),rand(-65,-18),780+i*60,0);
    },

    inkMoth(effect, layer, x, y) {
      const l=piece(layer,"mega-ink-wing left",x-6,y,effect), r=piece(layer,"mega-ink-wing right",x+6,y,effect), b=piece(layer,"mega-ink-body",x,y,effect);
      l.style.animation="megaMothLeft 760ms ease-out forwards"; r.style.animation="megaMothRight 760ms ease-out forwards"; b.style.animation="megaMothBody 760ms ease-out forwards";
      setTimeout(()=>{l.remove();r.remove();b.remove();},840);
    },
    paperCuts(effect, layer, x, y) {
      for(let i=0;i<5;i++) line(layer,"mega-paper-cut",x,y,effect,rand(18,45),rand(-120,120),rand(-48,48),rand(-42,42),650+i*40);
    },
    calligraphySmoke(effect, layer, x, y) {
      for(let i=0;i<4;i++) line(layer,"mega-calligraphy",x+rand(-6,6),y+rand(-6,6),effect,rand(34,70),rand(-80,80),rand(-36,36),rand(-54,4),860+i*50);
    },
    tornEdge(effect, layer, x, y) {
      for(let i=0;i<6;i++) shape(layer,"mega-torn-paper",x,y,effect,rand(-55,55),rand(-45,45),700+i*40,rand(-180,180));
    },
    graphiteDust(effect, layer, x, y) {
      for(let i=0;i<8;i++) dot(layer,"mega-graphite",x+rand(-14,14),y+rand(-10,10),effect,rand(2,5),rand(-50,50),rand(-35,45),760+i*22);
    },
    manuscriptFireflies(effect, layer, x, y) {
      for(let i=0;i<5;i++) dot(layer,"mega-manuscript-dot",x+rand(-14,14),y+rand(-14,14),effect,rand(5,9),rand(-35,35),rand(-70,-15),860+i*45);
    },
    foldedCorner(effect, layer, x, y) {
      for(let i=0;i<5;i++) shape(layer,"mega-folded-corner",x,y,effect,rand(-44,44),rand(-44,44),720+i*40,rand(-160,160));
    },
    typewriterGhost(effect, layer, x, y) {
      for(let i=0;i<5;i++) textMark(layer,"mega-typewriter",x+rand(-18,18),y+rand(-8,8),effect,pick(["a","x","/","_",";"]),rand(-18,18),rand(-48,18),740+i*45,0);
    },
    stampBurst(effect, layer, x, y) {
      ring(layer,"mega-stamp-ring",x,y,effect,720);
      for(let i=0;i<5;i++) dot(layer,"mega-stamp-dust",x,y,effect,rand(3,6),rand(-55,55),rand(-45,45),720+i*25);
    },
    vellumSnow(effect, layer, x, y) {
      for(let i=0;i<6;i++) shape(layer,"mega-vellum",x+rand(-18,18),y+rand(-10,10),effect,rand(-22,22),rand(30,88),980+i*50,rand(-120,120));
    },

    orbitNeedle(effect, layer, x, y) {
      const base=performance.now()/180;
      for(let i=0;i<4;i++){const a=base+i*Math.PI/2; line(layer,"mega-orbit-needle",x+Math.cos(a)*18,y+Math.sin(a)*18,effect,rand(26,44),a*180/Math.PI,Math.cos(a)*rand(28,60),Math.sin(a)*rand(28,60),620);}
    },
    gravityWell(effect, layer, x, y) {
      for(let i=0;i<8;i++){const a=i*Math.PI/4; dot(layer,"mega-gravity-dot",x+Math.cos(a)*rand(35,55),y+Math.sin(a)*rand(35,55),effect,rand(3,6),-Math.cos(a)*rand(25,52),-Math.sin(a)*rand(25,52),760+i*25);}
    },
    tinyEclipse(effect, layer, x, y) {
      ring(layer,"mega-eclipse",x,y,effect,820);
      shape(layer,"mega-eclipse-moon",x-18,y,effect,34,0,820,0);
    },
    starMap(effect, layer, x, y) {
      for(let i=0;i<5;i++) line(layer,"mega-star-map-line",x+rand(-20,20),y+rand(-20,20),effect,rand(18,46),rand(-120,120),rand(-28,28),rand(-28,28),760+i*35);
      for(let i=0;i<5;i++) dot(layer,"mega-star-map-dot",x+rand(-20,20),y+rand(-20,20),effect,4,rand(-28,28),rand(-28,28),760+i*35);
    },
    clockworkBits(effect, layer, x, y) {
      for(let i=0;i<6;i++) textMark(layer,"mega-clock-bit",x,y,effect,pick(["•","/","—","×"]),rand(-55,55),rand(-55,55),700+i*30,rand(-180,180));
    },
    magnetShards(effect, layer, x, y) {
      for(let i=0;i<7;i++){const a=rand(0,Math.PI*2); shape(layer,"mega-magnet-shard",x+Math.cos(a)*40,y+Math.sin(a)*40,effect,-Math.cos(a)*rand(30,55),-Math.sin(a)*rand(30,55),680+i*30,rand(-180,180));}
    },
    satellitePulse(effect, layer, x, y) {
      const a=performance.now()/180; dot(layer,"mega-satellite",x+Math.cos(a)*26,y+Math.sin(a)*26,effect,9,Math.cos(a)*56,Math.sin(a)*56,760,a*180/Math.PI); ring(layer,"mega-satellite-ring",x,y,effect,760);
    },
    blackHoleDust(effect, layer, x, y) {
      for(let i=0;i<8;i++){const a=i*.8+performance.now()/200; dot(layer,"mega-black-dust",x+Math.cos(a)*rand(15,45),y+Math.sin(a)*rand(15,45),effect,rand(3,7),-Math.cos(a)*rand(8,28),-Math.sin(a)*rand(8,28),880+i*25);}
    },
    gearSparks(effect, layer, x, y) {
      for(let i=0;i<6;i++) textMark(layer,"mega-gear-spark",x,y,effect,pick(["⚙","×","/","+"]),rand(-52,52),rand(-52,52),720+i*25,rand(-180,180));
    },
    compassFlare(effect, layer, x, y) {
      [[0,-1],[1,0],[0,1],[-1,0]].forEach((v,i)=>line(layer,"mega-compass",x,y,effect,rand(30,50),i*90,v[0]*rand(40,70),v[1]*rand(40,70),680+i*40));
    }
  };

  function clearBasic(layer) {
    const s = BASIC_STATES.get(layer);
    if (!s) return;
    s.dead = true;
    s.node.remove();
    BASIC_STATES.delete(layer);
  }

  function makeBasic(effect, layer, x, y) {
    clearBasic(layer);
    const p = pal(effect);
    const node = document.createElement("span");
    node.className = "basic-follow " + effect.key;
    node.setAttribute("aria-hidden","true");
    node.style.left = x + "px";
    node.style.top = y + "px";
    node.style.setProperty("--a", p.a);
    node.style.setProperty("--b", p.b);
    node.style.setProperty("--ink", p.ink);
    layer.appendChild(node);
    const state = { key: effect.key, node, x, y, tx:x, ty:y, vx:0, vy:0, angle:0, dead:false };
    BASIC_STATES.set(layer, state);
    requestAnimationFrame(() => animateBasic(layer, state));
    return state;
  }

  function animateBasic(layer, s) {
    if (s.dead || BASIC_STATES.get(layer) !== s) return;
    const dx=s.tx-s.x, dy=s.ty-s.y;
    s.vx += dx*.12; s.vy += dy*.12;
    s.vx *= .72; s.vy *= .72;
    s.x += s.vx; s.y += s.vy;
    if (Math.hypot(s.vx,s.vy)>.08) s.angle = Math.atan2(s.vy,s.vx);
    s.node.style.left=s.x+"px";
    s.node.style.top=s.y+"px";
    s.node.style.transform="translate(-50%,-50%) rotate("+(s.angle*180/Math.PI)+"deg)";
    requestAnimationFrame(() => animateBasic(layer, s));
  }

  COLD_FX.spawn = function(effect, layer, x, y) {
    if (effect && MEGA_KEYS.has(effect.key)) {
      if (effect.kind === "mega-basic") {
        let s = BASIC_STATES.get(layer);
        if (!s || s.key !== effect.key) s = makeBasic(effect, layer, x, y);
        s.tx = x; s.ty = y;
        return;
      }

      const fn = RICH[effect.mode];
      if (fn) {
        fn(effect, layer, x, y);
        return;
      }
    }
    oldSpawn(effect, layer, x, y);
  };

  COLD_FX.clear = function(layer) {
    clearBasic(layer);
    if (oldClear) oldClear(layer);
    else layer.innerHTML = "";
  };
})();

'@

Save-Utf8 ".\assets\mega-motion-cursors.js" $rendererJs

Write-Host "3) Adding CSS..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath
$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== MEGA 70 CURSOR PACK START ===== \*/.*?/\* ===== MEGA 70 CURSOR PACK END ===== \*/', '')
$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== PREMIUM MOTION FINAL START ===== \*/.*?/\* ===== PREMIUM MOTION FINAL END ===== \*/', '')
$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== PREMIUM CURSORS START ===== \*/.*?/\* ===== PREMIUM CURSORS END ===== \*/', '')

$css = @'

/* ===== MEGA 70 CURSOR PACK START ===== */
.mega-fx{position:absolute!important;pointer-events:none!important;z-index:99999!important;transform-origin:50% 50%!important;will-change:transform,opacity!important}
.mega-fx:not(.mega-code-text):not(.mega-matrix-cell):not(.mega-code-spark):not(.mega-command-echo):not(.mega-hex):not(.mega-prompt-ghost):not(.mega-typewriter):not(.mega-clock-bit):not(.mega-gear-spark){font-size:12px}
.mega-ash-dot,.mega-pollen,.mega-charcoal,.mega-coal,.mega-packet-dot,.mega-graphite,.mega-manuscript-dot,.mega-stamp-dust,.mega-gravity-dot,.mega-star-map-dot,.mega-satellite,.mega-black-dust{width:var(--s,5px);height:var(--s,5px);border-radius:999px;background:radial-gradient(circle,var(--a),transparent 72%);box-shadow:0 0 9px color-mix(in srgb,var(--a) 24%,transparent)}
.mega-smoke-blob{width:var(--s,30px);height:var(--s,30px);border-radius:999px;background:radial-gradient(circle,color-mix(in srgb,var(--a) 22%,transparent),transparent 68%);filter:blur(1px)}
.mega-warm-ember,.mega-soot-comet,.mega-vapor-stitch,.mega-glass-line,.mega-mirror-splinter,.mega-frost,.mega-light-thread,.mega-flare-needle,.mega-packet-line,.mega-scanline,.mega-paper-cut,.mega-calligraphy,.mega-orbit-needle,.mega-star-map-line,.mega-compass,.mega-bone-ember,.mega-ash-ribbon{width:var(--w,40px);height:2px;border-radius:999px;background:linear-gradient(90deg,transparent,var(--a),var(--b),transparent);box-shadow:0 0 10px color-mix(in srgb,var(--a) 20%,transparent)}
.mega-vapor-stitch{height:1px;background:repeating-linear-gradient(90deg,transparent 0 4px,var(--a) 4px 9px,transparent 9px 13px)}
.mega-cinder,.mega-prism,.mega-crystal,.mega-torn-paper,.mega-folded-corner,.mega-vellum,.mega-magnet-shard{width:15px;height:12px;background:linear-gradient(135deg,var(--a),var(--b));clip-path:polygon(50% 0,100% 40%,72% 100%,10% 78%,0 28%);box-shadow:0 0 10px color-mix(in srgb,var(--a) 18%,transparent)}
.mega-prism{clip-path:polygon(50% 0,100% 100%,0 100%);opacity:.82}.mega-crystal{clip-path:polygon(50% 0,100% 50%,50% 100%,0 50%)}.mega-torn-paper{clip-path:polygon(0 10%,100% 0,78% 100%,18% 85%)}.mega-folded-corner{clip-path:polygon(0 0,100% 0,100% 100%)}.mega-vellum{border-radius:3px;clip-path:polygon(12% 0,100% 18%,82% 100%,0 82%)}
.mega-ghost-ring,.mega-lens-ring,.mega-halo-left,.mega-halo-right,.mega-stamp-ring,.mega-eclipse,.mega-satellite-ring{width:44px;height:44px;border-radius:999px;border:1px solid color-mix(in srgb,var(--a) 55%,transparent);background:radial-gradient(circle,color-mix(in srgb,var(--a) 10%,transparent),transparent 64%)}
.mega-lens-core{background:var(--a)}.mega-eclipse-moon{width:24px;height:24px;border-radius:999px;background:var(--b);box-shadow:inset 7px 0 0 var(--ink)}
.mega-star-glint,.mega-clock-bit,.mega-gear-spark{color:var(--a);font-weight:900;text-shadow:0 0 10px color-mix(in srgb,var(--a) 35%,transparent)}.mega-star-glint:before{content:"✦";}.mega-clock-bit,.mega-gear-spark{font-family:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace}
.mega-code-text,.mega-matrix-cell,.mega-code-spark,.mega-command-echo,.mega-hex,.mega-prompt-ghost,.mega-typewriter{color:var(--a);font-family:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;font-size:12px;font-weight:950;text-shadow:0 0 10px color-mix(in srgb,var(--a) 34%,transparent)}
.mega-hex{font-size:14px}.mega-prompt-ghost{opacity:.86}
.mega-ink-wing{width:25px;height:18px;border-radius:70% 30% 70% 30%;background:color-mix(in srgb,var(--a) 72%,var(--b));opacity:.9}.mega-ink-wing.left{transform-origin:100% 50%}.mega-ink-wing.right{transform-origin:0 50%}.mega-ink-body{width:8px;height:24px;border-radius:999px;background:var(--b)}
.mega-moth-wing{} /* compat */
.mega-stamp-ring{border-style:dashed}.mega-calligraphy{height:3px;border-radius:60% 20% 70% 30%}.mega-paper-cut{height:1px}.mega-manuscript-dot{background:radial-gradient(circle,var(--a),var(--b),transparent 72%)}
.mega-satellite{background:var(--a)}.mega-black-dust{background:radial-gradient(circle,var(--b),transparent 72%);filter:brightness(.7)}
.basic-follow{position:absolute!important;width:28px;height:28px;pointer-events:none!important;z-index:99999!important;transform-origin:50% 50%!important;will-change:left,top,transform!important}
.basic-follow:before,.basic-follow:after{content:"";position:absolute;display:block}
.bc-soft-dot:before,.bc-mono-dot:before{left:50%;top:50%;width:8px;height:8px;border-radius:999px;background:var(--a);transform:translate(-50%,-50%);box-shadow:0 0 10px color-mix(in srgb,var(--a) 22%,transparent)}
.bc-clean-ring:before,.bc-plain-ring:before,.bc-cursor-halo:before,.bc-quiet-bubble:before{inset:4px;border:1.5px solid var(--a);border-radius:999px}.bc-cursor-halo:before{inset:0;opacity:.45}.bc-quiet-bubble:before{background:color-mix(in srgb,var(--a) 10%,transparent)}
.bc-cross-plus:before,.bc-tiny-plus:before{left:50%;top:20%;width:2px;height:60%;background:var(--a);transform:translateX(-50%)}.bc-cross-plus:after,.bc-tiny-plus:after{left:20%;top:50%;width:60%;height:2px;background:var(--a);transform:translateY(-50%)}.bc-tiny-plus{scale:.72}
.bc-square-pulse:before{inset:6px;border:1.5px solid var(--a);border-radius:5px}.bc-triangle-tick:before{left:7px;top:6px;width:16px;height:16px;background:var(--a);clip-path:polygon(50% 0,100% 100%,0 100%)}.bc-underline-trail:before,.bc-follow-bar:before,.bc-mini-dash:before{left:4px;top:14px;width:22px;height:3px;border-radius:999px;background:var(--a)}.bc-follow-bar:before{width:30px}.bc-mini-dash:before{width:14px}
.bc-corner-ticks:before{inset:5px;border:2px solid var(--a);border-right-color:transparent;border-bottom-color:transparent}.bc-corner-ticks:after{inset:5px;border:2px solid var(--a);border-left-color:transparent;border-top-color:transparent}.bc-default-pointer:before{left:6px;top:4px;width:18px;height:22px;background:var(--a);clip-path:polygon(0 0,100% 52%,56% 60%,76% 100%,58% 100%,38% 64%,0 92%)}.bc-caret-blink:before{left:13px;top:4px;width:2px;height:22px;background:var(--a);animation:megaBlink .75s step-end infinite}.bc-target-dot:before{inset:5px;border:1.5px solid var(--a);border-radius:999px}.bc-target-dot:after{left:50%;top:50%;width:5px;height:5px;border-radius:999px;background:var(--a);transform:translate(-50%,-50%)}.bc-click-ripple:before{inset:4px;border:1.5px solid var(--a);border-radius:999px;animation:basicPulse 900ms ease-out infinite}.bc-small-spark:before{content:"✦";color:var(--a);font-size:20px;left:4px;top:1px}.bc-axis-mark:before{left:50%;top:0;width:1.5px;height:28px;background:var(--a);opacity:.8}.bc-axis-mark:after{left:0;top:50%;width:28px;height:1.5px;background:var(--a);opacity:.8}
@keyframes megaFly{0%{opacity:0;transform:translate(-50%,-50%) scale(.45) rotate(0)}16%{opacity:.95}100%{opacity:0;transform:translate(-50%,-50%) translate(var(--dx),var(--dy)) scale(var(--sc,1)) rotate(var(--rot))}}
@keyframes megaPulse{0%{opacity:0;transform:translate(-50%,-50%) scale(.18)}30%{opacity:.9}100%{opacity:0;transform:translate(-50%,-50%) scale(1.55)}}
@keyframes megaSplitRing{0%{opacity:0;transform:translate(-50%,-50%) scale(.25) rotate(0)}35%{opacity:.8}100%{opacity:0;transform:translate(-50%,-50%) translate(var(--dx),var(--dy)) scale(var(--sc,1)) rotate(var(--rot))}}
@keyframes megaMothLeft{0%{opacity:0;transform:translate(-50%,-50%) scale(.3) rotate(0)}30%{opacity:.9}100%{opacity:0;transform:translate(-50%,-50%) translate(-34px,-18px) scale(1.1) rotate(-42deg)}}
@keyframes megaMothRight{0%{opacity:0;transform:translate(-50%,-50%) scale(.3) rotate(0)}30%{opacity:.9}100%{opacity:0;transform:translate(-50%,-50%) translate(34px,-18px) scale(1.1) rotate(42deg)}}
@keyframes megaMothBody{0%{opacity:0;transform:translate(-50%,-50%) scale(.3)}35%{opacity:.85}100%{opacity:0;transform:translate(-50%,-50%) translate(0,-24px) scale(.8)}}
@keyframes megaBlink{50%{opacity:.1}}@keyframes basicPulse{0%{opacity:.7;transform:scale(.6)}100%{opacity:.12;transform:scale(1.6)}}
/* ===== MEGA 70 CURSOR PACK END ===== */

'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $css)

Write-Host "4) Creating category/source pages..."

New-Item -ItemType Directory -Path ".\categories" -Force | Out-Null
New-Item -ItemType Directory -Path ".\sources" -Force | Out-Null

foreach ($cat in $pack.categories) {
  $sections = ""

  $catEffects = @($pack.effects | Where-Object { $_.cat_id -eq $cat.id })

  foreach ($eff in $catEffects) {
    $key = HtmlSafe $eff.key
    $name = HtmlSafe $eff.name
    $desc = HtmlSafe $eff.desc
    $idx = [int]$eff.index
    $pill = HtmlSafe ("$($cat.title) / " + ("{0:D2}" -f $idx))

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

  $catId = HtmlSafe $cat.id
  $catTitle = HtmlSafe $cat.title
  $catDesc = HtmlSafe $cat.desc

  $catPage = @"
<!doctype html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex,nofollow">
  <title>$catTitle | Coldboot Cursor Library</title>
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
        <span class="pill">addon / category</span>
        <h1>$catTitle</h1>
        <p>$catDesc</p>
      </div>
    </section>

    <section class="effects-stack section-gap" id="effects">
$sections    </section>

    <footer>$catTitle contains added cursor effects from the 70-effect pack.</footer>
  </div>
  <script src="../assets/data.js"></script>
  <script src="../assets/mega-motion-data.js"></script>
  <script src="../assets/fx.js"></script>
  <script src="../assets/mega-motion-cursors.js"></script>
  <script src="../assets/app.js"></script>
  <script>initCategoryPage("$catId");</script>
</body>
</html>
"@

  Save-Utf8 ".\categories\$($cat.id).html" $catPage
}

foreach ($eff in $pack.effects) {
  $key = HtmlSafe $eff.key
  $name = HtmlSafe $eff.name
  $desc = HtmlSafe $eff.desc
  $catId = HtmlSafe $eff.cat_id
  $catTitle = HtmlSafe $eff.cat_title

  $sourcePage = @"
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
        <span class="pill">$catTitle / source</span>
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
      <pre class="code-pane" data-code="css" hidden><code>/* See assets/style.css: MEGA 70 CURSOR PACK */</code></pre>
      <pre class="code-pane" data-code="js" hidden><code>/* See assets/mega-motion-cursors.js */
const effect = COLD_EFFECTS.find((item) =&gt; item.key === "$key");
COLD_FX.spawn(effect, layer, x, y);</code></pre>
    </section>

    <footer>$name is rendered by assets/mega-motion-cursors.js.</footer>
  </div>
  <script src="../assets/data.js"></script>
  <script src="../assets/mega-motion-data.js"></script>
  <script src="../assets/fx.js"></script>
  <script src="../assets/mega-motion-cursors.js"></script>
  <script src="../assets/app.js"></script>
  <script>initSourcePage("$key");</script>
</body>
</html>
"@

  Save-Utf8 ".\sources\$($eff.key).html" $sourcePage
}

Write-Host "5) Loading addon scripts on HTML pages..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+mega-motion-data\.js[^>]*></script>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+mega-motion-cursors\.js[^>]*></script>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+premium-data\.js[^>]*></script>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+premium-cursors\.js[^>]*></script>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+quality-creatures\.js[^>]*></script>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+real-animals-not-snake\.js[^>]*></script>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+fresh-animals\.js[^>]*></script>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+wild-creatures\.js[^>]*></script>\s*', '')

  $relativeDir = $_.DirectoryName.Substring($root.Length).TrimStart('\')
  $depth = if ([string]::IsNullOrWhiteSpace($relativeDir)) { 0 } else { ($relativeDir -split '[\\/]').Count }
  $dataSrc = (('../' * $depth) + "assets/mega-motion-data.js?v=$stamp").Replace('\','/')
  $cursorSrc = (('../' * $depth) + "assets/mega-motion-cursors.js?v=$stamp").Replace('\','/')
  $dataTag = "  <script src=""$dataSrc""></script>"
  $cursorTag = "  <script src=""$cursorSrc""></script>"

  if ($html -match 'assets/data\.js') {
    $html = [regex]::Replace($html, '(?im)(^\s*<script[^>]+assets/data\.js[^>]*></script>\s*)', "`$1$dataTag`r`n", 1)
  }

  if ($html -match 'assets/fx\.js') {
    $html = [regex]::Replace($html, '(?im)(^\s*<script[^>]+assets/fx\.js[^>]*></script>\s*)', "`$1$cursorTag`r`n", 1)
  }

  Save-Utf8 $_.FullName $html
}

Write-Host "6) Updating home cards..."

$indexPath = ".\index.html"
$index = Read-Utf8 $indexPath

# Remove old weak or previous-addon cards from index only.
$removeLinks = @(
  "categories/animal-friends.html",
  "categories/wild-creatures.html",
  "categories/classic-basics.html",
  "categories/premium-motion.html",
  "categories/mega-ash-smoke.html",
  "categories/mega-glass-light.html",
  "categories/mega-code-data.html",
  "categories/mega-ink-paper.html",
  "categories/mega-cosmic-mech.html",
  "categories/basic-cursor-marks.html",
  "categories/basic-interface-kit.html"
)

foreach ($link in $removeLinks) {
  $safe = [regex]::Escape($link)
  $index = [regex]::Replace($index, "(?is)\s*<article class=""main-card""(?:(?!</article>).)*?href=""$safe""(?:(?!</article>).)*?</article>", "")
}

$cards = ""
foreach ($cat in $pack.categories) {
  $id = HtmlSafe $cat.id
  $title = HtmlSafe $cat.title
  $desc = HtmlSafe $cat.desc

  $cards += @"

      <article class="main-card" data-watermark="$title">
        <span class="pill">ADDON / category</span>
        <h2>$title</h2>
        <p>$desc</p>
        <a href="categories/$id.html">Open category</a>
      </article>
"@
}

if ($index -match '(?is)<section\s+class="main-grid section-gap"\s+id="library">') {
  $index = [regex]::Replace(
    $index,
    '(?is)(<section\s+class="main-grid section-gap"\s+id="library">.*?)(\s*</section>)',
    "`$1$cards`r`n    `$2",
    1
  )
}

$index = [regex]::Replace(
  $index,
  '(?is)<footer>.*?</footer>',
  "<footer>Focused cursor categories. Added 50 rich effects and 20 basic follow cursors.</footer>"
)

Save-Utf8 $indexPath $index

Write-Host "7) Removing weak old pages/files..."

$oldPages = @(
  "animal-friends","wild-creatures","classic-basics","premium-motion"
)
foreach ($id in $oldPages) {
  Remove-Item ".\categories\$id.html" -Force -ErrorAction SilentlyContinue
}

Remove-Item ".\assets\premium-data.js" -Force -ErrorAction SilentlyContinue
Remove-Item ".\assets\premium-cursors.js" -Force -ErrorAction SilentlyContinue
Remove-Item ".\assets\quality-creatures.js" -Force -ErrorAction SilentlyContinue
Remove-Item ".\assets\real-animals-not-snake.js" -Force -ErrorAction SilentlyContinue
Remove-Item ".\assets\fresh-animals.js" -Force -ErrorAction SilentlyContinue
Remove-Item ".\assets\wild-creatures.js" -Force -ErrorAction SilentlyContinue

Write-Host "8) Syntax check..."

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\mega-motion-data.js" | Out-Null
  node --check ".\assets\mega-motion-cursors.js" | Out-Null
  node --check ".\assets\app.js" | Out-Null
  node --check ".\assets\fx.js" | Out-Null
}

Write-Host ""
Write-Host "DONE:"
Write-Host "- added 50 rich cursor effects"
Write-Host "- added 20 basic follow cursors"
Write-Host "- added 7 new categories"
Write-Host "- removed weak animal/basic duplicate addon cards"
Write-Host "- did not rewrite assets/data.js"
Write-Host "- backup saved here:"
Write-Host $backup
