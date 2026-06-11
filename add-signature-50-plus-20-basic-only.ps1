$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\data.js") -or !(Test-Path ".\assets\fx.js") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-before-add-signature-50-pack_$stamp"

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

Write-Host "1) Writing Signature Pack data patch..."

$json = @'
{
  "categories": [
    {
      "id": "signature-structure",
      "num": "01",
      "title": "Signature Structure",
      "desc": "Cursor effects built from grids, brackets, cursor ghosts and structural marks.",
      "icon": "structure",
      "effects": [
        "sig-fractured-cursor",
        "sig-hinge-bracket",
        "sig-dotted-lasso",
        "sig-blueprint-corner",
        "sig-ruler-snap",
        "sig-folded-grid",
        "sig-anchor-pin",
        "sig-cross-section",
        "sig-orbit-stamp",
        "sig-elastic-box"
      ]
    },
    {
      "id": "signature-energy",
      "num": "02",
      "title": "Signature Energy",
      "desc": "Wave, signal, electric and pulse-based cursor effects.",
      "icon": "energy",
      "effects": [
        "sig-pulse-beacon",
        "sig-wave-ladder",
        "sig-signal-fan",
        "sig-electric-fork",
        "sig-sonar-bubble",
        "sig-phase-rings",
        "sig-storm-ticks",
        "sig-voltage-teeth",
        "sig-ripple-gate",
        "sig-light-drift"
      ]
    },
    {
      "id": "signature-matter",
      "num": "03",
      "title": "Signature Matter",
      "desc": "Liquid, paper, sand, cloth, dust and material motion.",
      "icon": "matter",
      "effects": [
        "sig-liquid-drop",
        "sig-sand-hourglass",
        "sig-dust-collapse",
        "sig-pebble-jump",
        "sig-cloth-fray",
        "sig-paper-kite",
        "sig-graphite-smear",
        "sig-wax-melt",
        "sig-pearl-chain",
        "sig-feather-fall"
      ]
    },
    {
      "id": "signature-data-ui",
      "num": "04",
      "title": "Signature Data UI",
      "desc": "Command stacks, packet jumps, cursor clones and UI micro-motion.",
      "icon": "dataui",
      "effects": [
        "sig-command-stack",
        "sig-packet-hop",
        "sig-cursor-clone",
        "sig-keycap-pop",
        "sig-loading-orbit",
        "sig-slider-ghost",
        "sig-window-shard",
        "sig-menu-dots",
        "sig-code-shiver",
        "sig-upload-burst"
      ]
    },
    {
      "id": "signature-cosmic",
      "num": "05",
      "title": "Signature Cosmic",
      "desc": "Moon, compass, gravity, constellation and geometric orbit effects.",
      "icon": "cosmic",
      "effects": [
        "sig-moon-crescent",
        "sig-compass-break",
        "sig-gravity-dots",
        "sig-constellation-snap",
        "sig-eclipse-gate",
        "sig-cube-wire",
        "sig-map-pin-pop",
        "sig-satellite-sweep",
        "sig-spiral-beads",
        "sig-star-dial"
      ]
    },
    {
      "id": "signature-basic-marks",
      "num": "06",
      "title": "Basic Cursor Marks",
      "desc": "Simple follow-cursor marks: rings, dots, plus signs, corners and bars.",
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
      "id": "signature-interface-basics",
      "num": "07",
      "title": "Interface Basics",
      "desc": "Default UI-style cursor helpers with clean, simple follow motion.",
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
      "key": "sig-fractured-cursor",
      "name": "Fractured Cursor",
      "desc": "Cursor-arrow fragments split away from the pointer.",
      "kind": "signature-rich",
      "mode": "fracturedCursor",
      "cat_id": "signature-structure",
      "cat_num": "01",
      "cat_title": "Signature Structure",
      "cat_desc": "Cursor effects built from grids, brackets, cursor ghosts and structural marks.",
      "cat_icon": "structure",
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
      "key": "sig-hinge-bracket",
      "name": "Hinge Bracket",
      "desc": "Four hinged brackets fold open around the cursor.",
      "kind": "signature-rich",
      "mode": "hingeBracket",
      "cat_id": "signature-structure",
      "cat_num": "01",
      "cat_title": "Signature Structure",
      "cat_desc": "Cursor effects built from grids, brackets, cursor ghosts and structural marks.",
      "cat_icon": "structure",
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
      "key": "sig-dotted-lasso",
      "name": "Dotted Lasso",
      "desc": "A dotted rope circle wraps and breaks apart.",
      "kind": "signature-rich",
      "mode": "dottedLasso",
      "cat_id": "signature-structure",
      "cat_num": "01",
      "cat_title": "Signature Structure",
      "cat_desc": "Cursor effects built from grids, brackets, cursor ghosts and structural marks.",
      "cat_icon": "structure",
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
      "key": "sig-blueprint-corner",
      "name": "Blueprint Corner",
      "desc": "Technical blueprint corners draw and fade.",
      "kind": "signature-rich",
      "mode": "blueprintCorner",
      "cat_id": "signature-structure",
      "cat_num": "01",
      "cat_title": "Signature Structure",
      "cat_desc": "Cursor effects built from grids, brackets, cursor ghosts and structural marks.",
      "cat_icon": "structure",
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
      "key": "sig-ruler-snap",
      "name": "Ruler Snap",
      "desc": "Tiny ruler ticks snap in measured steps.",
      "kind": "signature-rich",
      "mode": "rulerSnap",
      "cat_id": "signature-structure",
      "cat_num": "01",
      "cat_title": "Signature Structure",
      "cat_desc": "Cursor effects built from grids, brackets, cursor ghosts and structural marks.",
      "cat_icon": "structure",
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
      "key": "sig-folded-grid",
      "name": "Folded Grid",
      "desc": "Small grid tiles flip like folded panels.",
      "kind": "signature-rich",
      "mode": "foldedGrid",
      "cat_id": "signature-structure",
      "cat_num": "01",
      "cat_title": "Signature Structure",
      "cat_desc": "Cursor effects built from grids, brackets, cursor ghosts and structural marks.",
      "cat_icon": "structure",
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
      "key": "sig-anchor-pin",
      "name": "Anchor Pin",
      "desc": "A small pin drops with a grounded pulse.",
      "kind": "signature-rich",
      "mode": "anchorPin",
      "cat_id": "signature-structure",
      "cat_num": "01",
      "cat_title": "Signature Structure",
      "cat_desc": "Cursor effects built from grids, brackets, cursor ghosts and structural marks.",
      "cat_icon": "structure",
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
      "key": "sig-cross-section",
      "name": "Cross Section",
      "desc": "Cross-hatched section lines slice through the cursor.",
      "kind": "signature-rich",
      "mode": "crossSection",
      "cat_id": "signature-structure",
      "cat_num": "01",
      "cat_title": "Signature Structure",
      "cat_desc": "Cursor effects built from grids, brackets, cursor ghosts and structural marks.",
      "cat_icon": "structure",
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
      "key": "sig-orbit-stamp",
      "name": "Orbit Stamp",
      "desc": "A square stamp rotates with dusty edges.",
      "kind": "signature-rich",
      "mode": "orbitStamp",
      "cat_id": "signature-structure",
      "cat_num": "01",
      "cat_title": "Signature Structure",
      "cat_desc": "Cursor effects built from grids, brackets, cursor ghosts and structural marks.",
      "cat_icon": "structure",
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
      "key": "sig-elastic-box",
      "name": "Elastic Box",
      "desc": "A box stretches and rebounds around movement.",
      "kind": "signature-rich",
      "mode": "elasticBox",
      "cat_id": "signature-structure",
      "cat_num": "01",
      "cat_title": "Signature Structure",
      "cat_desc": "Cursor effects built from grids, brackets, cursor ghosts and structural marks.",
      "cat_icon": "structure",
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
      "key": "sig-pulse-beacon",
      "name": "Pulse Beacon",
      "desc": "A beacon dot sends two clean pulse rings.",
      "kind": "signature-rich",
      "mode": "pulseBeacon",
      "cat_id": "signature-energy",
      "cat_num": "02",
      "cat_title": "Signature Energy",
      "cat_desc": "Wave, signal, electric and pulse-based cursor effects.",
      "cat_icon": "energy",
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
      "key": "sig-wave-ladder",
      "name": "Wave Ladder",
      "desc": "A ladder of waveform bars rises around the cursor.",
      "kind": "signature-rich",
      "mode": "waveLadder",
      "cat_id": "signature-energy",
      "cat_num": "02",
      "cat_title": "Signature Energy",
      "cat_desc": "Wave, signal, electric and pulse-based cursor effects.",
      "cat_icon": "energy",
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
      "key": "sig-signal-fan",
      "name": "Signal Fan",
      "desc": "Signal arcs fan out from one side of the pointer.",
      "kind": "signature-rich",
      "mode": "signalFan",
      "cat_id": "signature-energy",
      "cat_num": "02",
      "cat_title": "Signature Energy",
      "cat_desc": "Wave, signal, electric and pulse-based cursor effects.",
      "cat_icon": "energy",
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
      "key": "sig-electric-fork",
      "name": "Electric Fork",
      "desc": "Forked electric branches snap outward.",
      "kind": "signature-rich",
      "mode": "electricFork",
      "cat_id": "signature-energy",
      "cat_num": "02",
      "cat_title": "Signature Energy",
      "cat_desc": "Wave, signal, electric and pulse-based cursor effects.",
      "cat_icon": "energy",
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
      "key": "sig-sonar-bubble",
      "name": "Sonar Bubble",
      "desc": "A sonar bubble expands with small echo dots.",
      "kind": "signature-rich",
      "mode": "sonarBubble",
      "cat_id": "signature-energy",
      "cat_num": "02",
      "cat_title": "Signature Energy",
      "cat_desc": "Wave, signal, electric and pulse-based cursor effects.",
      "cat_icon": "energy",
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
      "key": "sig-phase-rings",
      "name": "Phase Rings",
      "desc": "Two offset phase rings pass through each other.",
      "kind": "signature-rich",
      "mode": "phaseRings",
      "cat_id": "signature-energy",
      "cat_num": "02",
      "cat_title": "Signature Energy",
      "cat_desc": "Wave, signal, electric and pulse-based cursor effects.",
      "cat_icon": "energy",
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
      "key": "sig-storm-ticks",
      "name": "Storm Ticks",
      "desc": "Short storm ticks rotate in broken bursts.",
      "kind": "signature-rich",
      "mode": "stormTicks",
      "cat_id": "signature-energy",
      "cat_num": "02",
      "cat_title": "Signature Energy",
      "cat_desc": "Wave, signal, electric and pulse-based cursor effects.",
      "cat_icon": "energy",
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
      "key": "sig-voltage-teeth",
      "name": "Voltage Teeth",
      "desc": "Small zigzag teeth jump away from the cursor.",
      "kind": "signature-rich",
      "mode": "voltageTeeth",
      "cat_id": "signature-energy",
      "cat_num": "02",
      "cat_title": "Signature Energy",
      "cat_desc": "Wave, signal, electric and pulse-based cursor effects.",
      "cat_icon": "energy",
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
      "key": "sig-ripple-gate",
      "name": "Ripple Gate",
      "desc": "Two gate lines open while ripples pass through.",
      "kind": "signature-rich",
      "mode": "rippleGate",
      "cat_id": "signature-energy",
      "cat_num": "02",
      "cat_title": "Signature Energy",
      "cat_desc": "Wave, signal, electric and pulse-based cursor effects.",
      "cat_icon": "energy",
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
      "key": "sig-light-drift",
      "name": "Light Drift",
      "desc": "Soft light motes drift slowly behind movement.",
      "kind": "signature-rich",
      "mode": "lightDrift",
      "cat_id": "signature-energy",
      "cat_num": "02",
      "cat_title": "Signature Energy",
      "cat_desc": "Wave, signal, electric and pulse-based cursor effects.",
      "cat_icon": "energy",
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
      "key": "sig-liquid-drop",
      "name": "Liquid Drop",
      "desc": "A stretched liquid drop falls and dissolves.",
      "kind": "signature-rich",
      "mode": "liquidDrop",
      "cat_id": "signature-matter",
      "cat_num": "03",
      "cat_title": "Signature Matter",
      "cat_desc": "Liquid, paper, sand, cloth, dust and material motion.",
      "cat_icon": "matter",
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
      "key": "sig-sand-hourglass",
      "name": "Sand Hourglass",
      "desc": "Two tiny triangles pour dust between them.",
      "kind": "signature-rich",
      "mode": "sandHourglass",
      "cat_id": "signature-matter",
      "cat_num": "03",
      "cat_title": "Signature Matter",
      "cat_desc": "Liquid, paper, sand, cloth, dust and material motion.",
      "cat_icon": "matter",
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
      "key": "sig-dust-collapse",
      "name": "Dust Collapse",
      "desc": "Dust starts outside and collapses inward.",
      "kind": "signature-rich",
      "mode": "dustCollapse",
      "cat_id": "signature-matter",
      "cat_num": "03",
      "cat_title": "Signature Matter",
      "cat_desc": "Liquid, paper, sand, cloth, dust and material motion.",
      "cat_icon": "matter",
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
      "key": "sig-pebble-jump",
      "name": "Pebble Jump",
      "desc": "Small pebbles jump and fall with weight.",
      "kind": "signature-rich",
      "mode": "pebbleJump",
      "cat_id": "signature-matter",
      "cat_num": "03",
      "cat_title": "Signature Matter",
      "cat_desc": "Liquid, paper, sand, cloth, dust and material motion.",
      "cat_icon": "matter",
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
      "key": "sig-cloth-fray",
      "name": "Cloth Fray",
      "desc": "Frayed cloth strands tear away from the cursor.",
      "kind": "signature-rich",
      "mode": "clothFray",
      "cat_id": "signature-matter",
      "cat_num": "03",
      "cat_title": "Signature Matter",
      "cat_desc": "Liquid, paper, sand, cloth, dust and material motion.",
      "cat_icon": "matter",
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
      "key": "sig-paper-kite",
      "name": "Paper Kite",
      "desc": "A tiny paper kite flips and drifts.",
      "kind": "signature-rich",
      "mode": "paperKite",
      "cat_id": "signature-matter",
      "cat_num": "03",
      "cat_title": "Signature Matter",
      "cat_desc": "Liquid, paper, sand, cloth, dust and material motion.",
      "cat_icon": "matter",
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
      "key": "sig-graphite-smear",
      "name": "Graphite Smear",
      "desc": "A dry graphite smear drags behind movement.",
      "kind": "signature-rich",
      "mode": "graphiteSmear",
      "cat_id": "signature-matter",
      "cat_num": "03",
      "cat_title": "Signature Matter",
      "cat_desc": "Liquid, paper, sand, cloth, dust and material motion.",
      "cat_icon": "matter",
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
      "key": "sig-wax-melt",
      "name": "Wax Melt",
      "desc": "Rounded wax drops stretch downward.",
      "kind": "signature-rich",
      "mode": "waxMelt",
      "cat_id": "signature-matter",
      "cat_num": "03",
      "cat_title": "Signature Matter",
      "cat_desc": "Liquid, paper, sand, cloth, dust and material motion.",
      "cat_icon": "matter",
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
      "key": "sig-pearl-chain",
      "name": "Pearl Chain",
      "desc": "Small pearls follow a curved chain path.",
      "kind": "signature-rich",
      "mode": "pearlChain",
      "cat_id": "signature-matter",
      "cat_num": "03",
      "cat_title": "Signature Matter",
      "cat_desc": "Liquid, paper, sand, cloth, dust and material motion.",
      "cat_icon": "matter",
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
      "key": "sig-feather-fall",
      "name": "Feather Fall",
      "desc": "Light feather marks fall in different angles.",
      "kind": "signature-rich",
      "mode": "featherFall",
      "cat_id": "signature-matter",
      "cat_num": "03",
      "cat_title": "Signature Matter",
      "cat_desc": "Liquid, paper, sand, cloth, dust and material motion.",
      "cat_icon": "matter",
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
      "key": "sig-command-stack",
      "name": "Command Stack",
      "desc": "Stacked command prompts rise like terminal echoes.",
      "kind": "signature-rich",
      "mode": "commandStack",
      "cat_id": "signature-data-ui",
      "cat_num": "04",
      "cat_title": "Signature Data UI",
      "cat_desc": "Command stacks, packet jumps, cursor clones and UI micro-motion.",
      "cat_icon": "dataui",
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
      "key": "sig-packet-hop",
      "name": "Packet Hop",
      "desc": "A packet dot hops across a short trace line.",
      "kind": "signature-rich",
      "mode": "packetHop",
      "cat_id": "signature-data-ui",
      "cat_num": "04",
      "cat_title": "Signature Data UI",
      "cat_desc": "Command stacks, packet jumps, cursor clones and UI micro-motion.",
      "cat_icon": "dataui",
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
      "key": "sig-cursor-clone",
      "name": "Cursor Clone",
      "desc": "Ghost cursor arrows duplicate and fade.",
      "kind": "signature-rich",
      "mode": "cursorClone",
      "cat_id": "signature-data-ui",
      "cat_num": "04",
      "cat_title": "Signature Data UI",
      "cat_desc": "Command stacks, packet jumps, cursor clones and UI micro-motion.",
      "cat_icon": "dataui",
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
      "key": "sig-keycap-pop",
      "name": "Keycap Pop",
      "desc": "Small keyboard keycaps pop near the pointer.",
      "kind": "signature-rich",
      "mode": "keycapPop",
      "cat_id": "signature-data-ui",
      "cat_num": "04",
      "cat_title": "Signature Data UI",
      "cat_desc": "Command stacks, packet jumps, cursor clones and UI micro-motion.",
      "cat_icon": "dataui",
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
      "key": "sig-loading-orbit",
      "name": "Loading Orbit",
      "desc": "Three loading dots orbit and shoot away.",
      "kind": "signature-rich",
      "mode": "loadingOrbit",
      "cat_id": "signature-data-ui",
      "cat_num": "04",
      "cat_title": "Signature Data UI",
      "cat_desc": "Command stacks, packet jumps, cursor clones and UI micro-motion.",
      "cat_icon": "dataui",
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
      "key": "sig-slider-ghost",
      "name": "Slider Ghost",
      "desc": "A slider knob leaves a small ghost trail.",
      "kind": "signature-rich",
      "mode": "sliderGhost",
      "cat_id": "signature-data-ui",
      "cat_num": "04",
      "cat_title": "Signature Data UI",
      "cat_desc": "Command stacks, packet jumps, cursor clones and UI micro-motion.",
      "cat_icon": "dataui",
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
      "key": "sig-window-shard",
      "name": "Window Shard",
      "desc": "Tiny app-window shards break apart.",
      "kind": "signature-rich",
      "mode": "windowShard",
      "cat_id": "signature-data-ui",
      "cat_num": "04",
      "cat_title": "Signature Data UI",
      "cat_desc": "Command stacks, packet jumps, cursor clones and UI micro-motion.",
      "cat_icon": "dataui",
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
      "key": "sig-menu-dots",
      "name": "Menu Dots",
      "desc": "Three menu dots split in different directions.",
      "kind": "signature-rich",
      "mode": "menuDots",
      "cat_id": "signature-data-ui",
      "cat_num": "04",
      "cat_title": "Signature Data UI",
      "cat_desc": "Command stacks, packet jumps, cursor clones and UI micro-motion.",
      "cat_icon": "dataui",
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
      "key": "sig-code-shiver",
      "name": "Code Shiver",
      "desc": "Tiny code marks shiver and vanish.",
      "kind": "signature-rich",
      "mode": "codeShiver",
      "cat_id": "signature-data-ui",
      "cat_num": "04",
      "cat_title": "Signature Data UI",
      "cat_desc": "Command stacks, packet jumps, cursor clones and UI micro-motion.",
      "cat_icon": "dataui",
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
      "key": "sig-upload-burst",
      "name": "Upload Burst",
      "desc": "An upload arrow breaks into upward particles.",
      "kind": "signature-rich",
      "mode": "uploadBurst",
      "cat_id": "signature-data-ui",
      "cat_num": "04",
      "cat_title": "Signature Data UI",
      "cat_desc": "Command stacks, packet jumps, cursor clones and UI micro-motion.",
      "cat_icon": "dataui",
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
      "key": "sig-moon-crescent",
      "name": "Moon Crescent",
      "desc": "A crescent moon slips past the cursor.",
      "kind": "signature-rich",
      "mode": "moonCrescent",
      "cat_id": "signature-cosmic",
      "cat_num": "05",
      "cat_title": "Signature Cosmic",
      "cat_desc": "Moon, compass, gravity, constellation and geometric orbit effects.",
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
      "key": "sig-compass-break",
      "name": "Compass Break",
      "desc": "Compass ticks break toward four directions.",
      "kind": "signature-rich",
      "mode": "compassBreak",
      "cat_id": "signature-cosmic",
      "cat_num": "05",
      "cat_title": "Signature Cosmic",
      "cat_desc": "Moon, compass, gravity, constellation and geometric orbit effects.",
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
      "key": "sig-gravity-dots",
      "name": "Gravity Dots",
      "desc": "Dots curve around the pointer like gravity.",
      "kind": "signature-rich",
      "mode": "gravityDots",
      "cat_id": "signature-cosmic",
      "cat_num": "05",
      "cat_title": "Signature Cosmic",
      "cat_desc": "Moon, compass, gravity, constellation and geometric orbit effects.",
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
      "key": "sig-constellation-snap",
      "name": "Constellation Snap",
      "desc": "Small points connect into a quick constellation.",
      "kind": "signature-rich",
      "mode": "constellationSnap",
      "cat_id": "signature-cosmic",
      "cat_num": "05",
      "cat_title": "Signature Cosmic",
      "cat_desc": "Moon, compass, gravity, constellation and geometric orbit effects.",
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
      "key": "sig-eclipse-gate",
      "name": "Eclipse Gate",
      "desc": "Two dark-light discs cross like an eclipse.",
      "kind": "signature-rich",
      "mode": "eclipseGate",
      "cat_id": "signature-cosmic",
      "cat_num": "05",
      "cat_title": "Signature Cosmic",
      "cat_desc": "Moon, compass, gravity, constellation and geometric orbit effects.",
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
      "key": "sig-cube-wire",
      "name": "Cube Wire",
      "desc": "A tiny wireframe cube unfolds and fades.",
      "kind": "signature-rich",
      "mode": "cubeWire",
      "cat_id": "signature-cosmic",
      "cat_num": "05",
      "cat_title": "Signature Cosmic",
      "cat_desc": "Moon, compass, gravity, constellation and geometric orbit effects.",
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
      "key": "sig-map-pin-pop",
      "name": "Map Pin Pop",
      "desc": "A small map pin pops and leaves a ring.",
      "kind": "signature-rich",
      "mode": "mapPinPop",
      "cat_id": "signature-cosmic",
      "cat_num": "05",
      "cat_title": "Signature Cosmic",
      "cat_desc": "Moon, compass, gravity, constellation and geometric orbit effects.",
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
      "key": "sig-satellite-sweep",
      "name": "Satellite Sweep",
      "desc": "A satellite dot sweeps around an orbit line.",
      "kind": "signature-rich",
      "mode": "satelliteSweep",
      "cat_id": "signature-cosmic",
      "cat_num": "05",
      "cat_title": "Signature Cosmic",
      "cat_desc": "Moon, compass, gravity, constellation and geometric orbit effects.",
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
      "key": "sig-spiral-beads",
      "name": "Spiral Beads",
      "desc": "Beads spiral outward in a controlled curve.",
      "kind": "signature-rich",
      "mode": "spiralBeads",
      "cat_id": "signature-cosmic",
      "cat_num": "05",
      "cat_title": "Signature Cosmic",
      "cat_desc": "Moon, compass, gravity, constellation and geometric orbit effects.",
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
      "key": "sig-star-dial",
      "name": "Star Dial",
      "desc": "A dial of star ticks rotates open.",
      "kind": "signature-rich",
      "mode": "starDial",
      "cat_id": "signature-cosmic",
      "cat_num": "05",
      "cat_title": "Signature Cosmic",
      "cat_desc": "Moon, compass, gravity, constellation and geometric orbit effects.",
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
      "desc": "A quiet dot follows the cursor with soft delay.",
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-basic-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple follow-cursor marks: rings, dots, plus signs, corners and bars.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-basic-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple follow-cursor marks: rings, dots, plus signs, corners and bars.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-basic-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple follow-cursor marks: rings, dots, plus signs, corners and bars.",
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
      "desc": "A smaller plus mark with lighter motion.",
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-basic-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple follow-cursor marks: rings, dots, plus signs, corners and bars.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-basic-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple follow-cursor marks: rings, dots, plus signs, corners and bars.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-basic-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple follow-cursor marks: rings, dots, plus signs, corners and bars.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-basic-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple follow-cursor marks: rings, dots, plus signs, corners and bars.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-basic-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple follow-cursor marks: rings, dots, plus signs, corners and bars.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-basic-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple follow-cursor marks: rings, dots, plus signs, corners and bars.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-basic-marks",
      "cat_num": "06",
      "cat_title": "Basic Cursor Marks",
      "cat_desc": "Simple follow-cursor marks: rings, dots, plus signs, corners and bars.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-interface-basics",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI-style cursor helpers with clean, simple follow motion.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-interface-basics",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI-style cursor helpers with clean, simple follow motion.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-interface-basics",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI-style cursor helpers with clean, simple follow motion.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-interface-basics",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI-style cursor helpers with clean, simple follow motion.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-interface-basics",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI-style cursor helpers with clean, simple follow motion.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-interface-basics",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI-style cursor helpers with clean, simple follow motion.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-interface-basics",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI-style cursor helpers with clean, simple follow motion.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-interface-basics",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI-style cursor helpers with clean, simple follow motion.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-interface-basics",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI-style cursor helpers with clean, simple follow motion.",
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
      "kind": "signature-basic",
      "mode": "basic",
      "cat_id": "signature-interface-basics",
      "cat_num": "07",
      "cat_title": "Interface Basics",
      "cat_desc": "Default UI-style cursor helpers with clean, simple follow motion.",
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
$catsJson = ($pack.categories | ConvertTo-Json -Depth 60) -replace "\\u0026", "&"
$effectsJson = ($pack.effects | ConvertTo-Json -Depth 60) -replace "\\u0026", "&"

$dataTemplate = @'
(function () {
  const addonCategories = __CATS__;
  const addonEffects = __EFFECTS__;

  const addonCategoryIds = new Set(addonCategories.map((cat) => cat.id));
  const addonEffectKeys = new Set(addonEffects.map((fx) => fx.key));

  // Add-only mode:
  // only replace this Signature Pack if it already exists from an earlier run.
  // Existing mega/premium/old categories are not removed.
  const oldAddonCategoryIds = new Set([
    "signature-structure",
    "signature-energy",
    "signature-matter",
    "signature-data-ui",
    "signature-cosmic",
    "signature-basic-marks",
    "signature-interface-basics"
  ]);

  // Only remove Signature Pack's own keys on re-run to prevent duplicates.
  const oldAddonEffectKeys = new Set([
    "sig-fractured-cursor",
    "sig-hinge-bracket",
    "sig-dotted-lasso",
    "sig-blueprint-corner",
    "sig-ruler-snap",
    "sig-folded-grid",
    "sig-anchor-pin",
    "sig-cross-section",
    "sig-orbit-stamp",
    "sig-elastic-box",
    "sig-pulse-beacon",
    "sig-wave-ladder",
    "sig-signal-fan",
    "sig-electric-fork",
    "sig-sonar-bubble",
    "sig-phase-rings",
    "sig-storm-ticks",
    "sig-voltage-teeth",
    "sig-ripple-gate",
    "sig-light-drift",
    "sig-liquid-drop",
    "sig-sand-hourglass",
    "sig-dust-collapse",
    "sig-pebble-jump",
    "sig-cloth-fray",
    "sig-paper-kite",
    "sig-graphite-smear",
    "sig-wax-melt",
    "sig-pearl-chain",
    "sig-feather-fall",
    "sig-command-stack",
    "sig-packet-hop",
    "sig-cursor-clone",
    "sig-keycap-pop",
    "sig-loading-orbit",
    "sig-slider-ghost",
    "sig-window-shard",
    "sig-menu-dots",
    "sig-code-shiver",
    "sig-upload-burst",
    "sig-moon-crescent",
    "sig-compass-break",
    "sig-gravity-dots",
    "sig-constellation-snap",
    "sig-eclipse-gate",
    "sig-cube-wire",
    "sig-map-pin-pop",
    "sig-satellite-sweep",
    "sig-spiral-beads",
    "sig-star-dial",
    "bc-soft-dot",
    "bc-clean-ring",
    "bc-cross-plus",
    "bc-tiny-plus",
    "bc-cursor-halo",
    "bc-square-pulse",
    "bc-triangle-tick",
    "bc-underline-trail",
    "bc-corner-ticks",
    "bc-mini-dash",
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
  ]);

  window.COLD_DATA = (window.COLD_DATA || [])
    .filter((cat) => !oldAddonCategoryIds.has(cat.id) && !addonCategoryIds.has(cat.id))
    .map((cat) => ({
      ...cat,
      effects: (cat.effects || []).filter((key) => !oldAddonEffectKeys.has(key) && !addonEffectKeys.has(key))
    }))
    .filter((cat) => (cat.effects || []).length > 0);

  window.COLD_EFFECTS = (window.COLD_EFFECTS || [])
    .filter((fx) => !oldAddonEffectKeys.has(fx.key) && !addonEffectKeys.has(fx.key));

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

  window.SIGNATURE_PACK_CATEGORIES = addonCategories;
  window.SIGNATURE_PACK_EFFECTS = addonEffects;
})();
'@

$dataJs = $dataTemplate.Replace("__CATS__", $catsJson).Replace("__EFFECTS__", $effectsJson)
Save-Utf8 ".\assets\signature-pack-data.js" $dataJs

Write-Host "2) Writing Signature Pack renderer..."

$rendererJs = @'

(function () {
  if (typeof COLD_FX === "undefined") return;

  const oldSpawn = COLD_FX.spawn.bind(COLD_FX);
  const oldClear = COLD_FX.clear ? COLD_FX.clear.bind(COLD_FX) : null;
  const SIGNATURE_KEYS = new Set((window.SIGNATURE_PACK_EFFECTS || []).map((fx) => fx.key));
  const BASIC_STATES = new WeakMap();

  function rand(a, b) { return a + Math.random() * (b - a); }
  function pick(list) { return list[Math.floor(Math.random() * list.length)]; }

  function palette(effect) {
    const light = document.documentElement.getAttribute("data-theme") === "light";
    return light ? (effect.light || effect.dark) : (effect.dark || effect.light);
  }

  function make(layer, cls, x, y, effect, text) {
    const p = palette(effect);
    const el = document.createElement("span");
    el.className = "signature-fx " + cls;
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

  function fly(el, dx, dy, ms, scale = 1, rot = 0, anim = "signatureFly") {
    el.style.setProperty("--dx", dx + "px");
    el.style.setProperty("--dy", dy + "px");
    el.style.setProperty("--sc", scale);
    el.style.setProperty("--rot", rot + "deg");
    el.style.animation = anim + " " + ms + "ms cubic-bezier(.16,.82,.28,1) forwards";
    setTimeout(() => el.remove(), ms + 80);
  }

  function dot(layer, cls, x, y, effect, size, dx, dy, ms, rot = 0) {
    const el = make(layer, cls, x, y, effect);
    el.style.setProperty("--s", size + "px");
    fly(el, dx, dy, ms, rand(.55, 1.15), rot);
  }

  function line(layer, cls, x, y, effect, width, rot, dx, dy, ms) {
    const el = make(layer, cls, x, y, effect);
    el.style.setProperty("--w", width + "px");
    fly(el, dx, dy, ms, rand(.75, 1.12), rot);
  }

  function shape(layer, cls, x, y, effect, dx, dy, ms, rot = 0) {
    const el = make(layer, cls, x, y, effect);
    fly(el, dx, dy, ms, rand(.65, 1.12), rot);
  }

  function pulse(layer, cls, x, y, effect, ms = 760) {
    const el = make(layer, cls, x, y, effect);
    el.style.animation = "signaturePulse " + ms + "ms ease-out forwards";
    setTimeout(() => el.remove(), ms + 80);
  }

  function text(layer, cls, x, y, effect, content, dx, dy, ms, rot = 0) {
    const el = make(layer, cls, x, y, effect, content);
    fly(el, dx, dy, ms, rand(.75, 1.1), rot);
  }

  const RICH = {
    fracturedCursor(effect, layer, x, y) {
      [[-26,-10,-18],[20,-14,14],[-8,24,44]].forEach((v, i) => {
        const el = make(layer, "sig-cursor-arrow", x + rand(-3,3), y + rand(-3,3), effect);
        fly(el, v[0], v[1], 720 + i * 45, .9, v[2]);
      });
    },
    hingeBracket(effect, layer, x, y) {
      [["tl",-34,-24,-18],["tr",34,-24,18],["bl",-34,24,18],["br",34,24,-18]].forEach((v, i) => {
        const el = make(layer, "sig-hinge " + v[0], x, y, effect);
        fly(el, v[1], v[2], 680 + i * 30, 1, v[3], "signatureHinge");
      });
    },
    dottedLasso(effect, layer, x, y) {
      const base = performance.now() / 180;
      for (let i = 0; i < 12; i++) {
        const a = base + i * Math.PI / 6;
        dot(layer, "sig-lasso-dot", x + Math.cos(a) * 20, y + Math.sin(a) * 20, effect, 4, Math.cos(a) * rand(20, 48), Math.sin(a) * rand(20, 48), 720 + i * 18);
      }
    },
    blueprintCorner(effect, layer, x, y) {
      [["h",-34,-20,0],["v",-22,-32,90],["h",8,20,0],["v",22,8,90]].forEach((v,i)=>line(layer,"sig-blueprint",x+v[1],y+v[2],effect,rand(28,52),v[3],rand(-10,10),rand(-10,10),760+i*35));
      pulse(layer, "sig-blueprint-dot", x, y, effect, 640);
    },
    rulerSnap(effect, layer, x, y) {
      for (let i=0;i<9;i++) line(layer,"sig-ruler-tick",x-32+i*8,y+rand(-3,3),effect,i%3===0?18:10,90,rand(-6,6),rand(-18,18),620+i*25);
    },
    foldedGrid(effect, layer, x, y) {
      for (let i=0;i<9;i++) {
        const cx = x + (i%3-1)*14, cy = y + (Math.floor(i/3)-1)*14;
        shape(layer,"sig-grid-tile",cx,cy,effect,rand(-24,24),rand(-24,24),720+i*25,(i%2?90:-90));
      }
    },
    anchorPin(effect, layer, x, y) {
      shape(layer,"sig-map-pin-shape",x,y,effect,0,-35,740,0);
      pulse(layer,"sig-pin-ring",x,y+13,effect,760);
      for(let i=0;i<4;i++) dot(layer,"sig-pin-dust",x,y+12,effect,4,rand(-30,30),rand(5,35),680+i*30);
    },
    crossSection(effect, layer, x, y) {
      for(let i=0;i<7;i++) line(layer,"sig-cross-section",x+rand(-16,16),y+rand(-16,16),effect,rand(26,54),i%2?45:-45,rand(-28,28),rand(-28,28),660+i*25);
    },
    orbitStamp(effect, layer, x, y) {
      const el=make(layer,"sig-stamp-square",x,y,effect);
      fly(el,0,0,760,1.35,rand(-18,18),"signaturePulse");
      for(let i=0;i<8;i++) dot(layer,"sig-stamp-noise",x+rand(-16,16),y+rand(-16,16),effect,3,rand(-30,30),rand(-30,30),640+i*22);
    },
    elasticBox(effect, layer, x, y) {
      const el=make(layer,"sig-elastic-box",x,y,effect);
      el.style.animation="signatureElastic 820ms ease-out forwards";
      setTimeout(()=>el.remove(),900);
    },

    pulseBeacon(effect, layer, x, y) {
      pulse(layer,"sig-beacon-ring",x,y,effect,760);
      setTimeout(()=>pulse(layer,"sig-beacon-ring second",x,y,effect,760),120);
      dot(layer,"sig-beacon-core",x,y,effect,7,0,0,520);
    },
    waveLadder(effect, layer, x, y) {
      for(let i=0;i<8;i++) {
        const h = 12 + Math.abs(Math.sin(i*.9))*24;
        const el=make(layer,"sig-wave-bar",x-28+i*8,y,effect);
        el.style.setProperty("--h",h+"px");
        fly(el,rand(-8,8),rand(-35,5),720+i*30,1,0);
      }
    },
    signalFan(effect, layer, x, y) {
      for(let i=0;i<4;i++){const el=make(layer,"sig-signal-arc arc-"+i,x,y,effect);fly(el,34+i*8,-12-i*4,700+i*50,1+i*.18,0,"signaturePulse")}
    },
    electricFork(effect, layer, x, y) {
      [[36,-10,0],[42,16,25],[28,-28,-35],[-26,22,155],[-34,-18,-150]].forEach((v,i)=>line(layer,"sig-electric",x,y,effect,rand(26,52),v[2],v[0],v[1],580+i*35));
    },
    sonarBubble(effect, layer, x, y) {
      pulse(layer,"sig-sonar",x,y,effect,850);
      for(let i=0;i<5;i++) dot(layer,"sig-sonar-dot",x,y,effect,4,rand(-52,52),rand(-52,52),760+i*30);
    },
    phaseRings(effect, layer, x, y) {
      const a=make(layer,"sig-phase-ring a",x-8,y,effect), b=make(layer,"sig-phase-ring b",x+8,y,effect);
      fly(a,-24,-3,780,1.2,-8,"signaturePulse"); fly(b,24,3,780,1.2,8,"signaturePulse");
    },
    stormTicks(effect, layer, x, y) {
      for(let i=0;i<10;i++){const a=i*Math.PI/5; line(layer,"sig-storm-tick",x+Math.cos(a)*18,y+Math.sin(a)*18,effect,rand(10,22),a*180/Math.PI,Math.cos(a)*rand(18,48),Math.sin(a)*rand(18,48),560+i*24);}
    },
    voltageTeeth(effect, layer, x, y) {
      for(let i=0;i<6;i++) shape(layer,"sig-voltage-tooth",x+(i-2.5)*8,y+rand(-4,4),effect,rand(-32,32),rand(-42,42),620+i*40,rand(-110,110));
    },
    rippleGate(effect, layer, x, y) {
      line(layer,"sig-gate-line",x-14,y,effect,44,90,-28,0,760);
      line(layer,"sig-gate-line",x+14,y,effect,44,90,28,0,760);
      pulse(layer,"sig-gate-ripple",x,y,effect,720);
    },
    lightDrift(effect, layer, x, y) {
      for(let i=0;i<7;i++) dot(layer,"sig-light-mote",x+rand(-16,16),y+rand(-16,16),effect,rand(5,11),rand(-26,26),rand(-60,10),900+i*45);
    },

    liquidDrop(effect, layer, x, y) {
      for(let i=0;i<4;i++) shape(layer,"sig-liquid-drop",x+rand(-8,8),y+rand(-6,6),effect,rand(-12,12),rand(45,90),780+i*65,rand(-20,20));
    },
    sandHourglass(effect, layer, x, y) {
      shape(layer,"sig-hourglass",x,y,effect,0,0,860,0);
      for(let i=0;i<8;i++) dot(layer,"sig-sand-dot",x+rand(-8,8),y+rand(-4,4),effect,3,rand(-8,8),rand(22,55),760+i*25);
    },
    dustCollapse(effect, layer, x, y) {
      for(let i=0;i<10;i++){const a=i*.63; const r=rand(35,64); dot(layer,"sig-collapse-dot",x+Math.cos(a)*r,y+Math.sin(a)*r,effect,rand(3,6),-Math.cos(a)*r,-Math.sin(a)*r,760+i*18);}
    },
    pebbleJump(effect, layer, x, y) {
      for(let i=0;i<6;i++) shape(layer,"sig-pebble",x+rand(-10,10),y+rand(-4,12),effect,rand(-34,34),rand(-58,30),780+i*35,rand(-120,120));
    },
    clothFray(effect, layer, x, y) {
      for(let i=0;i<7;i++) line(layer,"sig-cloth-fray",x+rand(-16,16),y+rand(-8,8),effect,rand(16,38),rand(60,120),rand(-42,42),rand(-38,42),760+i*28);
    },
    paperKite(effect, layer, x, y) {
      shape(layer,"sig-paper-kite",x,y,effect,rand(28,58),rand(-44,-10),820,rand(-40,40));
      line(layer,"sig-kite-tail",x-6,y+12,effect,30,rand(20,60),rand(12,34),rand(20,44),800);
    },
    graphiteSmear(effect, layer, x, y) {
      for(let i=0;i<5;i++) line(layer,"sig-graphite-smear",x+rand(-8,8),y+rand(-8,8),effect,rand(32,72),rand(-25,25),rand(-38,8),rand(-12,12),820+i*40);
    },
    waxMelt(effect, layer, x, y) {
      for(let i=0;i<5;i++) shape(layer,"sig-wax-drop",x+rand(-10,10),y+rand(-6,6),effect,rand(-10,10),rand(42,82),860+i*45,0);
    },
    pearlChain(effect, layer, x, y) {
      for(let i=0;i<7;i++){const a=i*.55; dot(layer,"sig-pearl",x+i*7-20,y+Math.sin(a)*14,effect,6,rand(-8,35),rand(-35,35),760+i*35);}
    },
    featherFall(effect, layer, x, y) {
      for(let i=0;i<5;i++) shape(layer,"sig-feather",x+rand(-12,12),y+rand(-12,8),effect,rand(-28,28),rand(44,92),960+i*60,rand(-60,60));
    },

    commandStack(effect, layer, x, y) {
      [">","npm","run","dev"].forEach((m,i)=>text(layer,"sig-command",x+i*6,y+i*7,effect,m,rand(-8,18),-54-i*12,840+i*60,0));
    },
    packetHop(effect, layer, x, y) {
      line(layer,"sig-packet-line",x,y,effect,70,0,45,0,760);
      dot(layer,"sig-packet-dot",x-30,y,effect,8,72,0,760,0);
    },
    cursorClone(effect, layer, x, y) {
      [[-25,-18,-12],[18,-20,16],[-12,25,36],[25,18,-24]].forEach((v,i)=>{const el=make(layer,"sig-cursor-clone",x,y,effect);fly(el,v[0],v[1],720+i*35,.82,v[2]);});
    },
    keycapPop(effect, layer, x, y) {
      ["esc","⌘","tab","/"].forEach((k,i)=>text(layer,"sig-keycap",x+rand(-4,4),y+rand(-4,4),effect,k,rand(-44,44),rand(-52,22),760+i*50,rand(-15,15)));
    },
    loadingOrbit(effect, layer, x, y) {
      const base=performance.now()/180;
      for(let i=0;i<3;i++){const a=base+i*2.09;dot(layer,"sig-loading-dot",x+Math.cos(a)*18,y+Math.sin(a)*18,effect,7,Math.cos(a)*40,Math.sin(a)*40,760+i*50);}
    },
    sliderGhost(effect, layer, x, y) {
      line(layer,"sig-slider-track",x,y,effect,70,0,0,0,740);
      dot(layer,"sig-slider-knob",x-24,y,effect,10,48,0,740);
    },
    windowShard(effect, layer, x, y) {
      for(let i=0;i<5;i++) shape(layer,"sig-window-shard",x+rand(-4,4),y+rand(-4,4),effect,rand(-48,48),rand(-48,48),740+i*35,rand(-80,80));
    },
    menuDots(effect, layer, x, y) {
      [-12,0,12].forEach((off,i)=>dot(layer,"sig-menu-dot",x+off,y,effect,6,off*2,rand(-34,34),720+i*50));
    },
    codeShiver(effect, layer, x, y) {
      const marks=["{}","[]","//","<>","px",";"];
      for(let i=0;i<6;i++) text(layer,"sig-code-shiver",x+rand(-12,12),y+rand(-12,12),effect,pick(marks),rand(-38,38),rand(-28,28),600+i*40,0);
    },
    uploadBurst(effect, layer, x, y) {
      text(layer,"sig-upload-arrow",x,y,effect,"↑",0,-58,760,0);
      for(let i=0;i<5;i++) dot(layer,"sig-upload-dot",x,y,effect,4,rand(-28,28),rand(-76,-22),720+i*30);
    },

    moonCrescent(effect, layer, x, y) {
      shape(layer,"sig-moon-crescent",x,y,effect,34,-6,860,0);
      for(let i=0;i<3;i++) dot(layer,"sig-moon-dust",x,y,effect,4,rand(-28,28),rand(-36,36),760+i*50);
    },
    compassBreak(effect, layer, x, y) {
      [[0,-1,90],[1,0,0],[0,1,90],[-1,0,0]].forEach((v,i)=>line(layer,"sig-compass-tick",x,y,effect,34,v[2],v[0]*60,v[1]*60,700+i*35));
    },
    gravityDots(effect, layer, x, y) {
      for(let i=0;i<9;i++){const a=i*.7+performance.now()/260;dot(layer,"sig-gravity-dot",x+Math.cos(a)*rand(24,50),y+Math.sin(a)*rand(24,50),effect,rand(3,7),-Math.cos(a)*rand(18,44),-Math.sin(a)*rand(18,44),820+i*22);}
    },
    constellationSnap(effect, layer, x, y) {
      for(let i=0;i<5;i++) dot(layer,"sig-star-point",x+rand(-24,24),y+rand(-20,20),effect,4,rand(-18,18),rand(-18,18),760+i*35);
      for(let i=0;i<4;i++) line(layer,"sig-star-link",x+rand(-18,18),y+rand(-18,18),effect,rand(18,44),rand(-120,120),rand(-18,18),rand(-18,18),760+i*40);
    },
    eclipseGate(effect, layer, x, y) {
      shape(layer,"sig-eclipse-a",x-10,y,effect,-28,0,860,0);
      shape(layer,"sig-eclipse-b",x+10,y,effect,28,0,860,0);
    },
    cubeWire(effect, layer, x, y) {
      for(let i=0;i<6;i++) line(layer,"sig-cube-wire",x+rand(-8,8),y+rand(-8,8),effect,rand(24,42),i*30,rand(-30,30),rand(-30,30),760+i*28);
      shape(layer,"sig-cube-node",x,y,effect,0,0,700,45);
    },
    mapPinPop(effect, layer, x, y) {
      shape(layer,"sig-map-pin",x,y,effect,0,-42,760,0);
      pulse(layer,"sig-map-ring",x,y+12,effect,760);
    },
    satelliteSweep(effect, layer, x, y) {
      pulse(layer,"sig-satellite-orbit",x,y,effect,820);
      const a=performance.now()/220;
      dot(layer,"sig-satellite-dot",x+Math.cos(a)*24,y+Math.sin(a)*24,effect,7,Math.cos(a)*62,Math.sin(a)*62,820,a*180/Math.PI);
    },
    spiralBeads(effect, layer, x, y) {
      const base=performance.now()/220;
      for(let i=0;i<9;i++){const a=base+i*.55;const r=9+i*5;dot(layer,"sig-spiral-bead",x+Math.cos(a)*r,y+Math.sin(a)*r,effect,5,Math.cos(a)*r,Math.sin(a)*r,760+i*24);}
    },
    starDial(effect, layer, x, y) {
      for(let i=0;i<12;i++){const a=i*Math.PI/6;line(layer,"sig-star-dial",x+Math.cos(a)*18,y+Math.sin(a)*18,effect,i%3===0?20:12,a*180/Math.PI,Math.cos(a)*36,Math.sin(a)*36,680+i*18);}
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
    const p = palette(effect);
    const node = document.createElement("span");
    node.className = "signature-basic-follow " + effect.key;
    node.setAttribute("aria-hidden", "true");
    node.style.left = x + "px";
    node.style.top = y + "px";
    node.style.setProperty("--a", p.a);
    node.style.setProperty("--b", p.b);
    node.style.setProperty("--ink", p.ink);
    layer.appendChild(node);
    const state = { key: effect.key, node, x, y, tx: x, ty: y, vx: 0, vy: 0, angle: 0, dead: false };
    BASIC_STATES.set(layer, state);
    requestAnimationFrame(() => animateBasic(layer, state));
    return state;
  }

  function animateBasic(layer, s) {
    if (s.dead || BASIC_STATES.get(layer) !== s) return;
    const dx = s.tx - s.x;
    const dy = s.ty - s.y;
    s.vx += dx * .12;
    s.vy += dy * .12;
    s.vx *= .72;
    s.vy *= .72;
    s.x += s.vx;
    s.y += s.vy;
    if (Math.hypot(s.vx, s.vy) > .08) s.angle = Math.atan2(s.vy, s.vx);
    s.node.style.left = s.x + "px";
    s.node.style.top = s.y + "px";
    s.node.style.transform = "translate(-50%, -50%) rotate(" + (s.angle * 180 / Math.PI) + "deg)";
    requestAnimationFrame(() => animateBasic(layer, s));
  }

  COLD_FX.spawn = function (effect, layer, x, y) {
    if (effect && SIGNATURE_KEYS.has(effect.key)) {
      if (effect.kind === "signature-basic") {
        let s = BASIC_STATES.get(layer);
        if (!s || s.key !== effect.key) s = makeBasic(effect, layer, x, y);
        s.tx = x;
        s.ty = y;
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

  COLD_FX.clear = function (layer) {
    clearBasic(layer);
    if (oldClear) oldClear(layer);
    else layer.innerHTML = "";
  };
})();

'@

Save-Utf8 ".\assets\signature-pack-cursors.js" $rendererJs

Write-Host "3) Adding CSS..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath

$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== SIGNATURE 50 \+ 20 CURSOR PACK START ===== \*/.*?/\* ===== SIGNATURE 50 \+ 20 CURSOR PACK END ===== \*/', '')
$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== MEGA 70 CURSOR PACK START ===== \*/.*?/\* ===== MEGA 70 CURSOR PACK END ===== \*/', '')
$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== PREMIUM MOTION FINAL START ===== \*/.*?/\* ===== PREMIUM MOTION FINAL END ===== \*/', '')
$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== PREMIUM CURSORS START ===== \*/.*?/\* ===== PREMIUM CURSORS END ===== \*/', '')

$css = @'

/* ===== SIGNATURE 50 + 20 CURSOR PACK START ===== */
.signature-fx {
  position: absolute !important;
  pointer-events: none !important;
  z-index: 99999 !important;
  transform-origin: 50% 50% !important;
  will-change: transform, opacity !important;
}

.sig-lasso-dot,.sig-pin-dust,.sig-stamp-noise,.sig-beacon-core,.sig-sonar-dot,.sig-light-mote,.sig-sand-dot,.sig-collapse-dot,.sig-pearl,.sig-loading-dot,.sig-menu-dot,.sig-upload-dot,.sig-moon-dust,.sig-gravity-dot,.sig-star-point,.sig-satellite-dot,.sig-spiral-bead {
  width: var(--s, 5px);
  height: var(--s, 5px);
  border-radius: 999px;
  background: radial-gradient(circle, var(--a), transparent 72%);
  box-shadow: 0 0 9px color-mix(in srgb, var(--a) 24%, transparent);
}

.sig-beacon-core,.sig-loading-dot,.sig-satellite-dot { background: var(--a); }

.sig-blueprint,.sig-ruler-tick,.sig-cross-section,.sig-electric,.sig-gate-line,.sig-vapor-line,.sig-cloth-fray,.sig-graphite-smear,.sig-kite-tail,.sig-packet-line,.sig-slider-track,.sig-compass-tick,.sig-star-link,.sig-cube-wire,.sig-star-dial {
  width: var(--w, 40px);
  height: 2px;
  border-radius: 999px;
  background: linear-gradient(90deg, transparent, var(--a), var(--b), transparent);
  box-shadow: 0 0 9px color-mix(in srgb, var(--a) 20%, transparent);
}

.sig-cursor-arrow,.sig-cursor-clone {
  width: 22px;
  height: 28px;
  background: var(--a);
  clip-path: polygon(0 0, 100% 55%, 58% 62%, 78% 100%, 58% 100%, 38% 66%, 0 94%);
  filter: drop-shadow(0 7px 10px rgba(0,0,0,.18));
}

.sig-hinge {
  width: 23px;
  height: 23px;
  border: 2px solid var(--a);
}
.sig-hinge.tl { border-right: 0; border-bottom: 0; }
.sig-hinge.tr { border-left: 0; border-bottom: 0; }
.sig-hinge.bl { border-right: 0; border-top: 0; }
.sig-hinge.br { border-left: 0; border-top: 0; }

.sig-blueprint-dot,.sig-pin-ring,.sig-beacon-ring,.sig-sonar,.sig-phase-ring,.sig-gate-ripple,.sig-stamp-square,.sig-map-ring,.sig-satellite-orbit {
  width: 46px;
  height: 46px;
  border-radius: 999px;
  border: 1px solid color-mix(in srgb, var(--a) 56%, transparent);
  background: radial-gradient(circle, color-mix(in srgb, var(--a) 9%, transparent), transparent 64%);
}

.sig-stamp-square,.sig-elastic-box {
  border-radius: 10px;
  border-style: dashed;
}

.sig-grid-tile,.sig-window-shard {
  width: 15px;
  height: 15px;
  border: 1px solid var(--a);
  border-radius: 4px;
  background: color-mix(in srgb, var(--a) 10%, transparent);
}

.sig-map-pin-shape,.sig-map-pin {
  width: 22px;
  height: 28px;
  border-radius: 50% 50% 50% 0;
  background: linear-gradient(135deg, var(--a), var(--b));
  transform: translate(-50%, -50%) rotate(-45deg);
}

.sig-wave-bar {
  width: 5px;
  height: var(--h, 24px);
  border-radius: 999px;
  background: linear-gradient(180deg, var(--a), var(--b));
}

.sig-signal-arc {
  width: 34px;
  height: 34px;
  border: 2px solid var(--a);
  border-left-color: transparent;
  border-bottom-color: transparent;
  border-radius: 999px;
}

.sig-storm-tick,.sig-flare-tick {
  width: var(--w, 18px);
  height: 2px;
  border-radius: 999px;
  background: var(--a);
}

.sig-voltage-tooth {
  width: 18px;
  height: 13px;
  background: var(--a);
  clip-path: polygon(0 0, 45% 0, 28% 48%, 75% 48%, 20% 100%, 35% 56%, 0 56%);
}

.sig-liquid-drop,.sig-wax-drop {
  width: 15px;
  height: 26px;
  border-radius: 60% 60% 70% 70% / 45% 45% 80% 80%;
  background: linear-gradient(180deg, var(--a), var(--b));
}

.sig-hourglass {
  width: 26px;
  height: 34px;
  border: 2px solid var(--a);
  clip-path: polygon(0 0,100% 0,58% 50%,100% 100%,0 100%,42% 50%);
}

.sig-pebble {
  width: 15px;
  height: 11px;
  border-radius: 60% 42% 52% 48%;
  background: linear-gradient(135deg, var(--a), var(--b));
}

.sig-paper-kite {
  width: 22px;
  height: 28px;
  background: linear-gradient(135deg, var(--a), var(--b));
  clip-path: polygon(50% 0,100% 45%,50% 100%,0 45%);
}

.sig-feather {
  width: 11px;
  height: 30px;
  border-radius: 90% 10% 90% 10%;
  background: linear-gradient(180deg, var(--a), transparent);
}

.sig-command,.sig-keycap,.sig-code-shiver,.sig-upload-arrow {
  color: var(--a);
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 12px;
  font-weight: 950;
  text-shadow: 0 0 10px color-mix(in srgb, var(--a) 34%, transparent);
}
.sig-keycap {
  padding: 3px 6px;
  border-radius: 5px;
  border: 1px solid color-mix(in srgb, var(--a) 50%, transparent);
  background: color-mix(in srgb, var(--ink) 18%, transparent);
}
.sig-upload-arrow { font-size: 22px; }

.sig-packet-dot,.sig-slider-knob {
  width: var(--s, 8px);
  height: var(--s, 8px);
  border-radius: 999px;
  background: var(--a);
}

.sig-moon-crescent {
  width: 26px;
  height: 26px;
  border-radius: 999px;
  background: var(--a);
  box-shadow: inset 9px 0 0 var(--ink);
}

.sig-eclipse-a,.sig-eclipse-b {
  width: 30px;
  height: 30px;
  border-radius: 999px;
  background: var(--a);
  box-shadow: inset 8px 0 0 var(--b);
}

.sig-cube-node {
  width: 19px;
  height: 19px;
  border: 1px solid var(--a);
  background: transparent;
  transform-style: preserve-3d;
}

.sig-pin-ring,.sig-map-ring { width: 40px; height: 18px; transform: translate(-50%, -50%) scaleY(.45); }

.signature-basic-follow {
  position: absolute !important;
  width: 28px;
  height: 28px;
  pointer-events: none !important;
  z-index: 99999 !important;
  transform-origin: 50% 50% !important;
  will-change: left, top, transform !important;
}
.signature-basic-follow::before,.signature-basic-follow::after { content: ""; position: absolute; display: block; }

.bc-soft-dot::before,.bc-mono-dot::before { left:50%;top:50%;width:8px;height:8px;border-radius:999px;background:var(--a);transform:translate(-50%,-50%);box-shadow:0 0 10px color-mix(in srgb,var(--a) 22%,transparent); }
.bc-clean-ring::before,.bc-plain-ring::before,.bc-cursor-halo::before,.bc-quiet-bubble::before { inset:4px;border:1.5px solid var(--a);border-radius:999px; }
.bc-cursor-halo::before { inset:0;opacity:.45; }
.bc-quiet-bubble::before { background:color-mix(in srgb,var(--a) 10%,transparent); }
.bc-cross-plus::before,.bc-tiny-plus::before { left:50%;top:20%;width:2px;height:60%;background:var(--a);transform:translateX(-50%); }
.bc-cross-plus::after,.bc-tiny-plus::after { left:20%;top:50%;width:60%;height:2px;background:var(--a);transform:translateY(-50%); }
.bc-tiny-plus { scale:.72; }
.bc-square-pulse::before { inset:6px;border:1.5px solid var(--a);border-radius:5px; }
.bc-triangle-tick::before { left:7px;top:6px;width:16px;height:16px;background:var(--a);clip-path:polygon(50% 0,100% 100%,0 100%); }
.bc-underline-trail::before,.bc-follow-bar::before,.bc-mini-dash::before { left:4px;top:14px;width:22px;height:3px;border-radius:999px;background:var(--a); }
.bc-follow-bar::before { width:30px; }
.bc-mini-dash::before { width:14px; }
.bc-corner-ticks::before { inset:5px;border:2px solid var(--a);border-right-color:transparent;border-bottom-color:transparent; }
.bc-corner-ticks::after { inset:5px;border:2px solid var(--a);border-left-color:transparent;border-top-color:transparent; }
.bc-default-pointer::before { left:6px;top:4px;width:18px;height:22px;background:var(--a);clip-path:polygon(0 0,100% 52%,56% 60%,76% 100%,58% 100%,38% 64%,0 92%); }
.bc-caret-blink::before { left:13px;top:4px;width:2px;height:22px;background:var(--a);animation:sigBlink .75s step-end infinite; }
.bc-target-dot::before { inset:5px;border:1.5px solid var(--a);border-radius:999px; }
.bc-target-dot::after { left:50%;top:50%;width:5px;height:5px;border-radius:999px;background:var(--a);transform:translate(-50%,-50%); }
.bc-click-ripple::before { inset:4px;border:1.5px solid var(--a);border-radius:999px;animation:sigBasicPulse 900ms ease-out infinite; }
.bc-small-spark::before { content:"✦";color:var(--a);font-size:20px;left:4px;top:1px; }
.bc-axis-mark::before { left:50%;top:0;width:1.5px;height:28px;background:var(--a);opacity:.8; }
.bc-axis-mark::after { left:0;top:50%;width:28px;height:1.5px;background:var(--a);opacity:.8; }

@keyframes signatureFly {
  0% { opacity: 0; transform: translate(-50%, -50%) scale(.45) rotate(0); }
  16% { opacity: .95; }
  100% { opacity: 0; transform: translate(-50%, -50%) translate(var(--dx), var(--dy)) scale(var(--sc, 1)) rotate(var(--rot)); }
}
@keyframes signaturePulse {
  0% { opacity: 0; transform: translate(-50%, -50%) scale(.18) rotate(0); }
  30% { opacity: .86; }
  100% { opacity: 0; transform: translate(-50%, -50%) translate(var(--dx, 0), var(--dy, 0)) scale(var(--sc, 1.55)) rotate(var(--rot, 0deg)); }
}
@keyframes signatureHinge {
  0% { opacity: 0; transform: translate(-50%, -50%) scale(.55) rotate(0); }
  30% { opacity: .95; }
  100% { opacity: 0; transform: translate(-50%, -50%) translate(var(--dx), var(--dy)) rotate(var(--rot)) scale(1.05); }
}
@keyframes signatureElastic {
  0% { opacity:0; transform:translate(-50%,-50%) scale(.25,.9); }
  25% { opacity:.9; transform:translate(-50%,-50%) scale(1.35,.7); }
  65% { opacity:.65; transform:translate(-50%,-50%) scale(.88,1.18); }
  100% { opacity:0; transform:translate(-50%,-50%) scale(1.5,1.5); }
}
@keyframes sigBlink { 50% { opacity:.1; } }
@keyframes sigBasicPulse { 0% { opacity:.7; transform:scale(.6); } 100% { opacity:.12; transform:scale(1.6); } }
/* ===== SIGNATURE 50 + 20 CURSOR PACK END ===== */

'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $css)

Write-Host "4) Creating category and source pages..."

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
        <span class="pill">signature / category</span>
        <h1>$catTitle</h1>
        <p>$catDesc</p>
      </div>
    </section>

    <section class="effects-stack section-gap" id="effects">
$sections    </section>

    <footer>$catTitle contains effects from the Signature 50 pack.</footer>
  </div>
  <script src="../assets/data.js"></script>
  <script src="../assets/signature-pack-data.js"></script>
  <script src="../assets/fx.js"></script>
  <script src="../assets/signature-pack-cursors.js"></script>
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
      <pre class="code-pane" data-code="css" hidden><code>/* See assets/style.css: SIGNATURE 50 + 20 CURSOR PACK */</code></pre>
      <pre class="code-pane" data-code="js" hidden><code>/* See assets/signature-pack-cursors.js */
const effect = COLD_EFFECTS.find((item) =&gt; item.key === "$key");
COLD_FX.spawn(effect, layer, x, y);</code></pre>
    </section>

    <footer>$name is rendered by assets/signature-pack-cursors.js.</footer>
  </div>
  <script src="../assets/data.js"></script>
  <script src="../assets/signature-pack-data.js"></script>
  <script src="../assets/fx.js"></script>
  <script src="../assets/signature-pack-cursors.js"></script>
  <script src="../assets/app.js"></script>
  <script>initSourcePage("$key");</script>
</body>
</html>
"@

  Save-Utf8 ".\sources\$($eff.key).html" $sourcePage
}

Write-Host "5) Loading scripts on all HTML pages..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  # Add-only mode: remove only old Signature Pack script tags before adding fresh cache-busted tags.
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+signature-pack-data\.js[^>]*></script>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+signature-pack-cursors\.js[^>]*></script>\s*', '')

  $relativeDir = $_.DirectoryName.Substring($root.Length).TrimStart('\')
  $depth = if ([string]::IsNullOrWhiteSpace($relativeDir)) { 0 } else { ($relativeDir -split '[\\/]').Count }
  $dataSrc = (('../' * $depth) + "assets/signature-pack-data.js?v=$stamp").Replace('\','/')
  $cursorSrc = (('../' * $depth) + "assets/signature-pack-cursors.js?v=$stamp").Replace('\','/')
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

$removeLinks = @(
  "categories/signature-structure.html",
  "categories/signature-energy.html",
  "categories/signature-matter.html",
  "categories/signature-data-ui.html",
  "categories/signature-cosmic.html",
  "categories/signature-basic-marks.html",
  "categories/signature-interface-basics.html"
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
        <span class="pill">SIGNATURE / category</span>
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
  "<footer>Focused cursor categories. Signature Pack added: 50 rich effects and 20 basic follow cursors.</footer>"
)

Save-Utf8 $indexPath $index

Write-Host "7) Add-only mode: old categories/files are kept."

Write-Host "8) Syntax check..."

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\signature-pack-data.js" | Out-Null
  node --check ".\assets\signature-pack-cursors.js" | Out-Null
  node --check ".\assets\app.js" | Out-Null
  node --check ".\assets\fx.js" | Out-Null
}

Write-Host ""
Write-Host "DONE:"
Write-Host "- added Signature 50 without removing old effects"
Write-Host "- included 20 clean basic follow cursors"
Write-Host "- added 7 new categories without deleting old ones"
Write-Host "- did not rewrite assets/data.js"
Write-Host "- backup saved here:"
Write-Host $backup
