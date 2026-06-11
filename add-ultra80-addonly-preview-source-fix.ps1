$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets\data.js") -or !(Test-Path ".\assets\fx.js") -or !(Test-Path ".\assets\app.js") -or !(Test-Path ".\assets\style.css")) {
  throw "Wrong folder. Run this inside flowsync-cursor-library."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-before-ultra80-addonly_$stamp"

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

Write-Host "1) Writing Ultra 80 add-only data/renderer..."

$dataJs = @'
(function () {
  const addonCategories = [
  {
    "id": "u80-precision-instruments",
    "num": "01",
    "title": "Precision Instruments",
    "desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "icon": "instrument",
    "effects": [
      "u80-caliper-snap",
      "u80-protractor-sweep",
      "u80-magnifier-bloom",
      "u80-level-bubble",
      "u80-metronome-tick",
      "u80-pendulum-arc",
      "u80-ruler-crawl",
      "u80-barcode-wipe",
      "u80-focus-reticle",
      "u80-gauge-needle"
    ]
  },
  {
    "id": "u80-kinetic-objects",
    "num": "02",
    "title": "Kinetic Objects",
    "desc": "Physical toys, springs, levers and weighted cursor motion.",
    "icon": "kinetic",
    "effects": [
      "u80-rubber-band",
      "u80-spring-coil",
      "u80-chain-link",
      "u80-piston-push",
      "u80-lever-snap",
      "u80-pulley-rope",
      "u80-bearing-orbit",
      "u80-bolt-scatter",
      "u80-domino-fall",
      "u80-dice-tumble"
    ]
  },
  {
    "id": "u80-ui-micro",
    "num": "03",
    "title": "UI Micro Motion",
    "desc": "Interface-inspired cursor animations with cards, chips and controls.",
    "icon": "ui",
    "effects": [
      "u80-tooltip-pop",
      "u80-dropdown-fold",
      "u80-toggle-orbit",
      "u80-progress-ticks",
      "u80-command-palette",
      "u80-notification-badge",
      "u80-drag-handle",
      "u80-resize-corners",
      "u80-breadcrumb-trail",
      "u80-window-dock"
    ]
  },
  {
    "id": "u80-network-systems",
    "num": "04",
    "title": "Network Systems",
    "desc": "Packets, servers, databases, APIs and signal behavior.",
    "icon": "network",
    "effects": [
      "u80-router-ping",
      "u80-dns-pulse",
      "u80-firewall-sparks",
      "u80-database-rings",
      "u80-api-braces",
      "u80-packet-ladder",
      "u80-server-rack",
      "u80-webhook-hook",
      "u80-circuit-branch",
      "u80-qr-pixels"
    ]
  },
  {
    "id": "u80-material-fields",
    "num": "05",
    "title": "Material Fields",
    "desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
    "icon": "material",
    "effects": [
      "u80-gel-squish",
      "u80-wax-drip",
      "u80-bubble-column",
      "u80-foam-pop",
      "u80-thread-needle",
      "u80-cloth-rip",
      "u80-stone-skip",
      "u80-metal-filings",
      "u80-crystal-crack",
      "u80-crumb-fall"
    ]
  },
  {
    "id": "u80-map-navigation",
    "num": "06",
    "title": "Map & Navigation",
    "desc": "Pins, routes, radar, coordinates and navigator UI motion.",
    "icon": "map",
    "effects": [
      "u80-map-ping",
      "u80-route-dashes",
      "u80-waypoint-chain",
      "u80-radar-sweep",
      "u80-compass-rose",
      "u80-coordinate-pop",
      "u80-location-beam",
      "u80-topography-lines",
      "u80-grid-locator",
      "u80-nav-arrow"
    ]
  },
  {
    "id": "u80-paper-tools",
    "num": "07",
    "title": "Paper Tools",
    "desc": "Origami, envelopes, clips, stamps and desk-object motion.",
    "icon": "paper",
    "effects": [
      "u80-origami-fold",
      "u80-envelope-tear",
      "u80-ticket-punch",
      "u80-paperclip-loop",
      "u80-bookmark-flip",
      "u80-scissor-snip",
      "u80-wax-seal",
      "u80-pinwheel-spin",
      "u80-scroll-curl",
      "u80-type-slug"
    ]
  },
  {
    "id": "u80-glyph-games",
    "num": "08",
    "title": "Glyphs & Games",
    "desc": "Glyphs, runes, game marks and playful symbolic effects.",
    "icon": "glyph",
    "effects": [
      "u80-glyph-wheel",
      "u80-morse-blips",
      "u80-braille-dots",
      "u80-chess-step",
      "u80-lock-shards",
      "u80-key-turn",
      "u80-hourglass-flip",
      "u80-playing-card",
      "u80-puzzle-pop",
      "u80-dial-combo"
    ]
  }
];
  const addonEffects = [
  {
    "key": "u80-caliper-snap",
    "name": "Caliper Snap",
    "desc": "Two measuring jaws close and release around the pointer.",
    "kind": "ultra80",
    "mode": "caliperSnap",
    "cat_id": "u80-precision-instruments",
    "cat_num": "01",
    "cat_title": "Precision Instruments",
    "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "cat_icon": "instrument",
    "index": 1,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-protractor-sweep",
    "name": "Protractor Sweep",
    "desc": "A half-circle protractor sweep draws angle ticks.",
    "kind": "ultra80",
    "mode": "protractorSweep",
    "cat_id": "u80-precision-instruments",
    "cat_num": "01",
    "cat_title": "Precision Instruments",
    "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "cat_icon": "instrument",
    "index": 2,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-magnifier-bloom",
    "name": "Magnifier Bloom",
    "desc": "A small magnifier ring expands and focuses dust.",
    "kind": "ultra80",
    "mode": "magnifierBloom",
    "cat_id": "u80-precision-instruments",
    "cat_num": "01",
    "cat_title": "Precision Instruments",
    "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "cat_icon": "instrument",
    "index": 3,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-level-bubble",
    "name": "Level Bubble",
    "desc": "A bubble level capsule slides and balances.",
    "kind": "ultra80",
    "mode": "levelBubble",
    "cat_id": "u80-precision-instruments",
    "cat_num": "01",
    "cat_title": "Precision Instruments",
    "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "cat_icon": "instrument",
    "index": 4,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-metronome-tick",
    "name": "Metronome Tick",
    "desc": "A metronome needle swings with tiny base ticks.",
    "kind": "ultra80",
    "mode": "metronomeTick",
    "cat_id": "u80-precision-instruments",
    "cat_num": "01",
    "cat_title": "Precision Instruments",
    "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "cat_icon": "instrument",
    "index": 5,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-pendulum-arc",
    "name": "Pendulum Arc",
    "desc": "A pendulum bob swings under a tiny anchor point.",
    "kind": "ultra80",
    "mode": "pendulumArc",
    "cat_id": "u80-precision-instruments",
    "cat_num": "01",
    "cat_title": "Precision Instruments",
    "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "cat_icon": "instrument",
    "index": 6,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-ruler-crawl",
    "name": "Ruler Crawl",
    "desc": "Measured ruler ticks crawl outward from the cursor.",
    "kind": "ultra80",
    "mode": "rulerCrawl",
    "cat_id": "u80-precision-instruments",
    "cat_num": "01",
    "cat_title": "Precision Instruments",
    "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "cat_icon": "instrument",
    "index": 7,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-barcode-wipe",
    "name": "Barcode Wipe",
    "desc": "A barcode strip wipes across and breaks apart.",
    "kind": "ultra80",
    "mode": "barcodeWipe",
    "cat_id": "u80-precision-instruments",
    "cat_num": "01",
    "cat_title": "Precision Instruments",
    "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "cat_icon": "instrument",
    "index": 8,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-focus-reticle",
    "name": "Focus Reticle",
    "desc": "Camera focus brackets tighten then fade.",
    "kind": "ultra80",
    "mode": "focusReticle",
    "cat_id": "u80-precision-instruments",
    "cat_num": "01",
    "cat_title": "Precision Instruments",
    "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "cat_icon": "instrument",
    "index": 9,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-gauge-needle",
    "name": "Gauge Needle",
    "desc": "A gauge needle snaps across a mini dial.",
    "kind": "ultra80",
    "mode": "gaugeNeedle",
    "cat_id": "u80-precision-instruments",
    "cat_num": "01",
    "cat_title": "Precision Instruments",
    "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "cat_icon": "instrument",
    "index": 10,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-rubber-band",
    "name": "Rubber Band",
    "desc": "An elastic loop stretches behind the cursor.",
    "kind": "ultra80",
    "mode": "rubberBand",
    "cat_id": "u80-kinetic-objects",
    "cat_num": "02",
    "cat_title": "Kinetic Objects",
    "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
    "cat_icon": "kinetic",
    "index": 1,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-spring-coil",
    "name": "Spring Coil",
    "desc": "A tiny spring coil compresses and releases.",
    "kind": "ultra80",
    "mode": "springCoil",
    "cat_id": "u80-kinetic-objects",
    "cat_num": "02",
    "cat_title": "Kinetic Objects",
    "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
    "cat_icon": "kinetic",
    "index": 2,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-chain-link",
    "name": "Chain Link",
    "desc": "Short chain links separate with staggered timing.",
    "kind": "ultra80",
    "mode": "chainLink",
    "cat_id": "u80-kinetic-objects",
    "cat_num": "02",
    "cat_title": "Kinetic Objects",
    "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
    "cat_icon": "kinetic",
    "index": 3,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-piston-push",
    "name": "Piston Push",
    "desc": "A piston shaft pushes forward then retracts.",
    "kind": "ultra80",
    "mode": "pistonPush",
    "cat_id": "u80-kinetic-objects",
    "cat_num": "02",
    "cat_title": "Kinetic Objects",
    "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
    "cat_icon": "kinetic",
    "index": 4,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-lever-snap",
    "name": "Lever Snap",
    "desc": "A lever bar pivots quickly from a hinge.",
    "kind": "ultra80",
    "mode": "leverSnap",
    "cat_id": "u80-kinetic-objects",
    "cat_num": "02",
    "cat_title": "Kinetic Objects",
    "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
    "cat_icon": "kinetic",
    "index": 5,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-pulley-rope",
    "name": "Pulley Rope",
    "desc": "A rope arc and pulley dot roll away.",
    "kind": "ultra80",
    "mode": "pulleyRope",
    "cat_id": "u80-kinetic-objects",
    "cat_num": "02",
    "cat_title": "Kinetic Objects",
    "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
    "cat_icon": "kinetic",
    "index": 6,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-bearing-orbit",
    "name": "Bearing Orbit",
    "desc": "Ball bearings orbit then scatter outward.",
    "kind": "ultra80",
    "mode": "bearingOrbit",
    "cat_id": "u80-kinetic-objects",
    "cat_num": "02",
    "cat_title": "Kinetic Objects",
    "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
    "cat_icon": "kinetic",
    "index": 7,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-bolt-scatter",
    "name": "Bolt Scatter",
    "desc": "Small bolt shapes tumble away from the cursor.",
    "kind": "ultra80",
    "mode": "boltScatter",
    "cat_id": "u80-kinetic-objects",
    "cat_num": "02",
    "cat_title": "Kinetic Objects",
    "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
    "cat_icon": "kinetic",
    "index": 8,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-domino-fall",
    "name": "Domino Fall",
    "desc": "Tiny domino tiles fall in sequence.",
    "kind": "ultra80",
    "mode": "dominoFall",
    "cat_id": "u80-kinetic-objects",
    "cat_num": "02",
    "cat_title": "Kinetic Objects",
    "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
    "cat_icon": "kinetic",
    "index": 9,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-dice-tumble",
    "name": "Dice Tumble",
    "desc": "Small dice squares tumble in different angles.",
    "kind": "ultra80",
    "mode": "diceTumble",
    "cat_id": "u80-kinetic-objects",
    "cat_num": "02",
    "cat_title": "Kinetic Objects",
    "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
    "cat_icon": "kinetic",
    "index": 10,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-tooltip-pop",
    "name": "Tooltip Pop",
    "desc": "A tiny tooltip bubble pops and slides away.",
    "kind": "ultra80",
    "mode": "tooltipPop",
    "cat_id": "u80-ui-micro",
    "cat_num": "03",
    "cat_title": "UI Micro Motion",
    "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
    "cat_icon": "ui",
    "index": 1,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-dropdown-fold",
    "name": "Dropdown Fold",
    "desc": "Stacked dropdown panels unfold downward.",
    "kind": "ultra80",
    "mode": "dropdownFold",
    "cat_id": "u80-ui-micro",
    "cat_num": "03",
    "cat_title": "UI Micro Motion",
    "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
    "cat_icon": "ui",
    "index": 2,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-toggle-orbit",
    "name": "Toggle Orbit",
    "desc": "A switch knob orbits around a small pill.",
    "kind": "ultra80",
    "mode": "toggleOrbit",
    "cat_id": "u80-ui-micro",
    "cat_num": "03",
    "cat_title": "UI Micro Motion",
    "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
    "cat_icon": "ui",
    "index": 3,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-progress-ticks",
    "name": "Progress Ticks",
    "desc": "Progress ticks fill and float from the cursor.",
    "kind": "ultra80",
    "mode": "progressTicks",
    "cat_id": "u80-ui-micro",
    "cat_num": "03",
    "cat_title": "UI Micro Motion",
    "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
    "cat_icon": "ui",
    "index": 4,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-command-palette",
    "name": "Command Palette",
    "desc": "A tiny command palette opens then fragments.",
    "kind": "ultra80",
    "mode": "commandPalette",
    "cat_id": "u80-ui-micro",
    "cat_num": "03",
    "cat_title": "UI Micro Motion",
    "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
    "cat_icon": "ui",
    "index": 5,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-notification-badge",
    "name": "Notification Badge",
    "desc": "A notification badge pops with unread dots.",
    "kind": "ultra80",
    "mode": "notificationBadge",
    "cat_id": "u80-ui-micro",
    "cat_num": "03",
    "cat_title": "UI Micro Motion",
    "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
    "cat_icon": "ui",
    "index": 6,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-drag-handle",
    "name": "Drag Handle",
    "desc": "Grip dots slide like a draggable handle.",
    "kind": "ultra80",
    "mode": "dragHandle",
    "cat_id": "u80-ui-micro",
    "cat_num": "03",
    "cat_title": "UI Micro Motion",
    "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
    "cat_icon": "ui",
    "index": 7,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-resize-corners",
    "name": "Resize Corners",
    "desc": "Resize handles shoot out from four corners.",
    "kind": "ultra80",
    "mode": "resizeCorners",
    "cat_id": "u80-ui-micro",
    "cat_num": "03",
    "cat_title": "UI Micro Motion",
    "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
    "cat_icon": "ui",
    "index": 8,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-breadcrumb-trail",
    "name": "Breadcrumb Trail",
    "desc": "Small breadcrumb chips step behind the pointer.",
    "kind": "ultra80",
    "mode": "breadcrumbTrail",
    "cat_id": "u80-ui-micro",
    "cat_num": "03",
    "cat_title": "UI Micro Motion",
    "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
    "cat_icon": "ui",
    "index": 9,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-window-dock",
    "name": "Window Dock",
    "desc": "Mini window cards dock and bounce upward.",
    "kind": "ultra80",
    "mode": "windowDock",
    "cat_id": "u80-ui-micro",
    "cat_num": "03",
    "cat_title": "UI Micro Motion",
    "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
    "cat_icon": "ui",
    "index": 10,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-router-ping",
    "name": "Router Ping",
    "desc": "Router nodes ping outward with short packet dots.",
    "kind": "ultra80",
    "mode": "routerPing",
    "cat_id": "u80-network-systems",
    "cat_num": "04",
    "cat_title": "Network Systems",
    "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
    "cat_icon": "network",
    "index": 1,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-dns-pulse",
    "name": "DNS Pulse",
    "desc": "DNS label dots pulse and resolve into a line.",
    "kind": "ultra80",
    "mode": "dnsPulse",
    "cat_id": "u80-network-systems",
    "cat_num": "04",
    "cat_title": "Network Systems",
    "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
    "cat_icon": "network",
    "index": 2,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-firewall-sparks",
    "name": "Firewall Sparks",
    "desc": "A tiny wall blocks and throws sparks aside.",
    "kind": "ultra80",
    "mode": "firewallSparks",
    "cat_id": "u80-network-systems",
    "cat_num": "04",
    "cat_title": "Network Systems",
    "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
    "cat_icon": "network",
    "index": 3,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-database-rings",
    "name": "Database Rings",
    "desc": "Database cylinder rings lift upward.",
    "kind": "ultra80",
    "mode": "databaseRings",
    "cat_id": "u80-network-systems",
    "cat_num": "04",
    "cat_title": "Network Systems",
    "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
    "cat_icon": "network",
    "index": 4,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-api-braces",
    "name": "API Braces",
    "desc": "Curly API braces snap open around the cursor.",
    "kind": "ultra80",
    "mode": "apiBraces",
    "cat_id": "u80-network-systems",
    "cat_num": "04",
    "cat_title": "Network Systems",
    "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
    "cat_icon": "network",
    "index": 5,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-packet-ladder",
    "name": "Packet Ladder",
    "desc": "Packets hop through a stepped ladder path.",
    "kind": "ultra80",
    "mode": "packetLadder",
    "cat_id": "u80-network-systems",
    "cat_num": "04",
    "cat_title": "Network Systems",
    "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
    "cat_icon": "network",
    "index": 6,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-server-rack",
    "name": "Server Rack",
    "desc": "Server rack slots blink and slide away.",
    "kind": "ultra80",
    "mode": "serverRack",
    "cat_id": "u80-network-systems",
    "cat_num": "04",
    "cat_title": "Network Systems",
    "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
    "cat_icon": "network",
    "index": 7,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-webhook-hook",
    "name": "Webhook Hook",
    "desc": "A small hook catches and releases a packet.",
    "kind": "ultra80",
    "mode": "webhookHook",
    "cat_id": "u80-network-systems",
    "cat_num": "04",
    "cat_title": "Network Systems",
    "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
    "cat_icon": "network",
    "index": 8,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-circuit-branch",
    "name": "Circuit Branch",
    "desc": "Circuit branches grow from a central chip.",
    "kind": "ultra80",
    "mode": "circuitBranch",
    "cat_id": "u80-network-systems",
    "cat_num": "04",
    "cat_title": "Network Systems",
    "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
    "cat_icon": "network",
    "index": 9,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-qr-pixels",
    "name": "QR Pixels",
    "desc": "QR-like pixel blocks assemble and scatter.",
    "kind": "ultra80",
    "mode": "qrPixels",
    "cat_id": "u80-network-systems",
    "cat_num": "04",
    "cat_title": "Network Systems",
    "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
    "cat_icon": "network",
    "index": 10,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-gel-squish",
    "name": "Gel Squish",
    "desc": "A soft gel blob squashes and rebounds.",
    "kind": "ultra80",
    "mode": "gelSquish",
    "cat_id": "u80-material-fields",
    "cat_num": "05",
    "cat_title": "Material Fields",
    "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
    "cat_icon": "material",
    "index": 1,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-wax-drip",
    "name": "Wax Drip",
    "desc": "Rounded wax drops stretch downward slowly.",
    "kind": "ultra80",
    "mode": "waxDrip",
    "cat_id": "u80-material-fields",
    "cat_num": "05",
    "cat_title": "Material Fields",
    "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
    "cat_icon": "material",
    "index": 2,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-bubble-column",
    "name": "Bubble Column",
    "desc": "Bubbles rise in a thin vertical column.",
    "kind": "ultra80",
    "mode": "bubbleColumn",
    "cat_id": "u80-material-fields",
    "cat_num": "05",
    "cat_title": "Material Fields",
    "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
    "cat_icon": "material",
    "index": 3,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-foam-pop",
    "name": "Foam Pop",
    "desc": "Foam circles pop at different sizes.",
    "kind": "ultra80",
    "mode": "foamPop",
    "cat_id": "u80-material-fields",
    "cat_num": "05",
    "cat_title": "Material Fields",
    "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
    "cat_icon": "material",
    "index": 4,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-thread-needle",
    "name": "Thread Needle",
    "desc": "A needle line pulls a soft thread behind it.",
    "kind": "ultra80",
    "mode": "threadNeedle",
    "cat_id": "u80-material-fields",
    "cat_num": "05",
    "cat_title": "Material Fields",
    "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
    "cat_icon": "material",
    "index": 5,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-cloth-rip",
    "name": "Cloth Rip",
    "desc": "Frayed cloth fibers pull apart sideways.",
    "kind": "ultra80",
    "mode": "clothRip",
    "cat_id": "u80-material-fields",
    "cat_num": "05",
    "cat_title": "Material Fields",
    "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
    "cat_icon": "material",
    "index": 6,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-stone-skip",
    "name": "Stone Skip",
    "desc": "Small stones skip with gravity and bounce.",
    "kind": "ultra80",
    "mode": "stoneSkip",
    "cat_id": "u80-material-fields",
    "cat_num": "05",
    "cat_title": "Material Fields",
    "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
    "cat_icon": "material",
    "index": 7,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-metal-filings",
    "name": "Metal Filings",
    "desc": "Metal filings align toward an invisible magnet.",
    "kind": "ultra80",
    "mode": "metalFilings",
    "cat_id": "u80-material-fields",
    "cat_num": "05",
    "cat_title": "Material Fields",
    "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
    "cat_icon": "material",
    "index": 8,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-crystal-crack",
    "name": "Crystal Crack",
    "desc": "Crystal cracks grow in angular branches.",
    "kind": "ultra80",
    "mode": "crystalCrack",
    "cat_id": "u80-material-fields",
    "cat_num": "05",
    "cat_title": "Material Fields",
    "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
    "cat_icon": "material",
    "index": 9,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-crumb-fall",
    "name": "Crumb Fall",
    "desc": "Tiny crumbs fall and rotate with weight.",
    "kind": "ultra80",
    "mode": "crumbFall",
    "cat_id": "u80-material-fields",
    "cat_num": "05",
    "cat_title": "Material Fields",
    "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
    "cat_icon": "material",
    "index": 10,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-map-ping",
    "name": "Map Ping",
    "desc": "A map pin drops with a circular ping.",
    "kind": "ultra80",
    "mode": "mapPing",
    "cat_id": "u80-map-navigation",
    "cat_num": "06",
    "cat_title": "Map & Navigation",
    "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
    "cat_icon": "map",
    "index": 1,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-route-dashes",
    "name": "Route Dashes",
    "desc": "Route dashes travel along a curved path.",
    "kind": "ultra80",
    "mode": "routeDashes",
    "cat_id": "u80-map-navigation",
    "cat_num": "06",
    "cat_title": "Map & Navigation",
    "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
    "cat_icon": "map",
    "index": 2,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-waypoint-chain",
    "name": "Waypoint Chain",
    "desc": "Waypoint dots link and break apart.",
    "kind": "ultra80",
    "mode": "waypointChain",
    "cat_id": "u80-map-navigation",
    "cat_num": "06",
    "cat_title": "Map & Navigation",
    "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
    "cat_icon": "map",
    "index": 3,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-radar-sweep",
    "name": "Radar Sweep",
    "desc": "A radar wedge sweeps through a circle.",
    "kind": "ultra80",
    "mode": "radarSweep",
    "cat_id": "u80-map-navigation",
    "cat_num": "06",
    "cat_title": "Map & Navigation",
    "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
    "cat_icon": "map",
    "index": 4,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-compass-rose",
    "name": "Compass Rose",
    "desc": "Compass rose ticks open in eight directions.",
    "kind": "ultra80",
    "mode": "compassRose",
    "cat_id": "u80-map-navigation",
    "cat_num": "06",
    "cat_title": "Map & Navigation",
    "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
    "cat_icon": "map",
    "index": 5,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-coordinate-pop",
    "name": "Coordinate Pop",
    "desc": "Coordinate numbers pop and drift upward.",
    "kind": "ultra80",
    "mode": "coordinatePop",
    "cat_id": "u80-map-navigation",
    "cat_num": "06",
    "cat_title": "Map & Navigation",
    "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
    "cat_icon": "map",
    "index": 6,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-location-beam",
    "name": "Location Beam",
    "desc": "A location beam shoots upward from the cursor.",
    "kind": "ultra80",
    "mode": "locationBeam",
    "cat_id": "u80-map-navigation",
    "cat_num": "06",
    "cat_title": "Map & Navigation",
    "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
    "cat_icon": "map",
    "index": 7,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-topography-lines",
    "name": "Topography Lines",
    "desc": "Contour lines ripple outward unevenly.",
    "kind": "ultra80",
    "mode": "topographyLines",
    "cat_id": "u80-map-navigation",
    "cat_num": "06",
    "cat_title": "Map & Navigation",
    "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
    "cat_icon": "map",
    "index": 8,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-grid-locator",
    "name": "Grid Locator",
    "desc": "Locator grid cells flash and vanish.",
    "kind": "ultra80",
    "mode": "gridLocator",
    "cat_id": "u80-map-navigation",
    "cat_num": "06",
    "cat_title": "Map & Navigation",
    "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
    "cat_icon": "map",
    "index": 9,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-nav-arrow",
    "name": "Navigation Arrow",
    "desc": "A navigation arrow glides and splits into ticks.",
    "kind": "ultra80",
    "mode": "navArrow",
    "cat_id": "u80-map-navigation",
    "cat_num": "06",
    "cat_title": "Map & Navigation",
    "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
    "cat_icon": "map",
    "index": 10,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-origami-fold",
    "name": "Origami Fold",
    "desc": "Paper triangles fold open like origami.",
    "kind": "ultra80",
    "mode": "origamiFold",
    "cat_id": "u80-paper-tools",
    "cat_num": "07",
    "cat_title": "Paper Tools",
    "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
    "cat_icon": "paper",
    "index": 1,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-envelope-tear",
    "name": "Envelope Tear",
    "desc": "Envelope flap tears into small paper pieces.",
    "kind": "ultra80",
    "mode": "envelopeTear",
    "cat_id": "u80-paper-tools",
    "cat_num": "07",
    "cat_title": "Paper Tools",
    "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
    "cat_icon": "paper",
    "index": 2,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-ticket-punch",
    "name": "Ticket Punch",
    "desc": "A ticket rectangle punches out tiny holes.",
    "kind": "ultra80",
    "mode": "ticketPunch",
    "cat_id": "u80-paper-tools",
    "cat_num": "07",
    "cat_title": "Paper Tools",
    "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
    "cat_icon": "paper",
    "index": 3,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-paperclip-loop",
    "name": "Paperclip Loop",
    "desc": "A paperclip shape loops and springs away.",
    "kind": "ultra80",
    "mode": "paperclipLoop",
    "cat_id": "u80-paper-tools",
    "cat_num": "07",
    "cat_title": "Paper Tools",
    "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
    "cat_icon": "paper",
    "index": 4,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-bookmark-flip",
    "name": "Bookmark Flip",
    "desc": "A bookmark ribbon flips downward.",
    "kind": "ultra80",
    "mode": "bookmarkFlip",
    "cat_id": "u80-paper-tools",
    "cat_num": "07",
    "cat_title": "Paper Tools",
    "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
    "cat_icon": "paper",
    "index": 5,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-scissor-snip",
    "name": "Scissor Snip",
    "desc": "Two scissor blades snip and fly away.",
    "kind": "ultra80",
    "mode": "scissorSnip",
    "cat_id": "u80-paper-tools",
    "cat_num": "07",
    "cat_title": "Paper Tools",
    "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
    "cat_icon": "paper",
    "index": 6,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-wax-seal",
    "name": "Wax Seal",
    "desc": "A wax seal stamp expands and cracks.",
    "kind": "ultra80",
    "mode": "waxSeal",
    "cat_id": "u80-paper-tools",
    "cat_num": "07",
    "cat_title": "Paper Tools",
    "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
    "cat_icon": "paper",
    "index": 7,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-pinwheel-spin",
    "name": "Pinwheel Spin",
    "desc": "A tiny pinwheel rotates and drifts.",
    "kind": "ultra80",
    "mode": "pinwheelSpin",
    "cat_id": "u80-paper-tools",
    "cat_num": "07",
    "cat_title": "Paper Tools",
    "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
    "cat_icon": "paper",
    "index": 8,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-scroll-curl",
    "name": "Scroll Curl",
    "desc": "A small scroll curl opens and rolls away.",
    "kind": "ultra80",
    "mode": "scrollCurl",
    "cat_id": "u80-paper-tools",
    "cat_num": "07",
    "cat_title": "Paper Tools",
    "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
    "cat_icon": "paper",
    "index": 9,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-type-slug",
    "name": "Type Slug",
    "desc": "Typewriter slug blocks strike and fade.",
    "kind": "ultra80",
    "mode": "typeSlug",
    "cat_id": "u80-paper-tools",
    "cat_num": "07",
    "cat_title": "Paper Tools",
    "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
    "cat_icon": "paper",
    "index": 10,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-glyph-wheel",
    "name": "Glyph Wheel",
    "desc": "A wheel of glyphs spins outward.",
    "kind": "ultra80",
    "mode": "glyphWheel",
    "cat_id": "u80-glyph-games",
    "cat_num": "08",
    "cat_title": "Glyphs & Games",
    "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
    "cat_icon": "glyph",
    "index": 1,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-morse-blips",
    "name": "Morse Blips",
    "desc": "Morse dot-dash marks blink in a line.",
    "kind": "ultra80",
    "mode": "morseBlips",
    "cat_id": "u80-glyph-games",
    "cat_num": "08",
    "cat_title": "Glyphs & Games",
    "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
    "cat_icon": "glyph",
    "index": 2,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-braille-dots",
    "name": "Braille Dots",
    "desc": "Braille-style dots lift in a small grid.",
    "kind": "ultra80",
    "mode": "brailleDots",
    "cat_id": "u80-glyph-games",
    "cat_num": "08",
    "cat_title": "Glyphs & Games",
    "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
    "cat_icon": "glyph",
    "index": 3,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-chess-step",
    "name": "Chess Step",
    "desc": "A chess-piece silhouette steps diagonally.",
    "kind": "ultra80",
    "mode": "chessStep",
    "cat_id": "u80-glyph-games",
    "cat_num": "08",
    "cat_title": "Glyphs & Games",
    "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
    "cat_icon": "glyph",
    "index": 4,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-lock-shards",
    "name": "Lock Shards",
    "desc": "A tiny lock cracks into angular shards.",
    "kind": "ultra80",
    "mode": "lockShards",
    "cat_id": "u80-glyph-games",
    "cat_num": "08",
    "cat_title": "Glyphs & Games",
    "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
    "cat_icon": "glyph",
    "index": 5,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-key-turn",
    "name": "Key Turn",
    "desc": "A key shape turns and releases small marks.",
    "kind": "ultra80",
    "mode": "keyTurn",
    "cat_id": "u80-glyph-games",
    "cat_num": "08",
    "cat_title": "Glyphs & Games",
    "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
    "cat_icon": "glyph",
    "index": 6,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-hourglass-flip",
    "name": "Hourglass Flip",
    "desc": "An hourglass flips while sand dots fall.",
    "kind": "ultra80",
    "mode": "hourglassFlip",
    "cat_id": "u80-glyph-games",
    "cat_num": "08",
    "cat_title": "Glyphs & Games",
    "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
    "cat_icon": "glyph",
    "index": 7,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-playing-card",
    "name": "Playing Card",
    "desc": "A playing card flips and leaves suit marks.",
    "kind": "ultra80",
    "mode": "playingCard",
    "cat_id": "u80-glyph-games",
    "cat_num": "08",
    "cat_title": "Glyphs & Games",
    "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
    "cat_icon": "glyph",
    "index": 8,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-puzzle-pop",
    "name": "Puzzle Pop",
    "desc": "Puzzle piece shapes pop away from the cursor.",
    "kind": "ultra80",
    "mode": "puzzlePop",
    "cat_id": "u80-glyph-games",
    "cat_num": "08",
    "cat_title": "Glyphs & Games",
    "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
    "cat_icon": "glyph",
    "index": 9,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  },
  {
    "key": "u80-dial-combo",
    "name": "Dial Combo",
    "desc": "Combination dial ticks rotate in layers.",
    "kind": "ultra80",
    "mode": "dialCombo",
    "cat_id": "u80-glyph-games",
    "cat_num": "08",
    "cat_title": "Glyphs & Games",
    "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
    "cat_icon": "glyph",
    "index": 10,
    "dark": {
      "a": "#f0e7d4",
      "b": "#9b8a6d",
      "ink": "#16120e"
    },
    "light": {
      "a": "#1f1a14",
      "b": "#75654d",
      "ink": "#faf8f1"
    }
  }
];
  const addonCategoryIds = new Set(addonCategories.map((cat) => cat.id));
  const addonEffectKeys = new Set(addonEffects.map((fx) => fx.key));

  // Add-only: remove only this Ultra 80 pack if it exists already, so re-running does not duplicate it.
  window.COLD_DATA = (window.COLD_DATA || [])
    .filter((cat) => !addonCategoryIds.has(cat.id))
    .map((cat) => ({
      ...cat,
      effects: (cat.effects || []).filter((key) => !addonEffectKeys.has(key))
    }));

  window.COLD_EFFECTS = (window.COLD_EFFECTS || [])
    .filter((fx) => !addonEffectKeys.has(fx.key));

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

  window.ULTRA80_CATEGORIES = addonCategories;
  window.ULTRA80_EFFECTS = addonEffects;
})();

'@

$rendererJs = @'
(function () {
  if (typeof COLD_FX === "undefined") return;

  const oldSpawn = COLD_FX.spawn.bind(COLD_FX);
  const oldClear = COLD_FX.clear ? COLD_FX.clear.bind(COLD_FX) : null;
  const states = new WeakMap();

  function rand(a, b) { return a + Math.random() * (b - a); }
  function pick(list) { return list[Math.floor(Math.random() * list.length)]; }
  function palette(effect) {
    const light = document.documentElement.getAttribute("data-theme") === "light";
    return light ? (effect.light || effect.dark) : (effect.dark || effect.light);
  }

  function piece(layer, className, x, y, effect, text) {
    const p = palette(effect);
    const el = document.createElement("span");
    el.className = "u80-fx " + className;
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

  function fly(el, dx, dy, ms, scale = 1, rot = 0, anim = "u80Fly") {
    el.style.setProperty("--dx", dx + "px");
    el.style.setProperty("--dy", dy + "px");
    el.style.setProperty("--sc", scale);
    el.style.setProperty("--rot", rot + "deg");
    el.style.animation = anim + " " + ms + "ms cubic-bezier(.16,.82,.28,1) forwards";
    setTimeout(() => el.remove(), ms + 90);
  }

  function dot(layer, cls, x, y, effect, s, dx, dy, ms, rot = 0) {
    const el = piece(layer, cls, x, y, effect);
    el.style.setProperty("--s", s + "px");
    fly(el, dx, dy, ms, rand(.55, 1.12), rot);
  }

  function line(layer, cls, x, y, effect, w, rot, dx, dy, ms) {
    const el = piece(layer, cls, x, y, effect);
    el.style.setProperty("--w", w + "px");
    fly(el, dx, dy, ms, rand(.75, 1.12), rot);
  }

  function shape(layer, cls, x, y, effect, dx, dy, ms, rot = 0, anim = "u80Fly") {
    const el = piece(layer, cls, x, y, effect);
    fly(el, dx, dy, ms, rand(.65, 1.12), rot, anim);
  }

  function pulse(layer, cls, x, y, effect, ms = 760) {
    const el = piece(layer, cls, x, y, effect);
    el.style.animation = "u80Pulse " + ms + "ms ease-out forwards";
    setTimeout(() => el.remove(), ms + 90);
  }

  function textMark(layer, cls, x, y, effect, content, dx, dy, ms, rot = 0) {
    const el = piece(layer, cls, x, y, effect, content);
    fly(el, dx, dy, ms, rand(.75, 1.1), rot);
  }

  function card(layer, cls, x, y, effect, content, dx, dy, ms, rot = 0) {
    const el = piece(layer, cls, x, y, effect, content || "");
    fly(el, dx, dy, ms, rand(.85, 1.08), rot);
  }

  const R = {
    caliperSnap(effect, layer, x, y) { line(layer,"u80-caliper-jaw",x-18,y,e,36,90,-26,0,720); line(layer,"u80-caliper-jaw",x+18,y,e,36,90,26,0,720); line(layer,"u80-caliper-bar",x,y-18,e,60,0,0,-14,720); },
    protractorSweep(effect, layer, x, y) { shape(layer,"u80-protractor",x,y,e,0,0,820,0,"u80Pulse"); for(let i=0;i<9;i++){let a=(-160+i*20)*Math.PI/180; line(layer,"u80-tick",x+Math.cos(a)*32,y+Math.sin(a)*32,e,i%2?8:14,a*180/Math.PI,Math.cos(a)*22,Math.sin(a)*22,700+i*24);} },
    magnifierBloom(effect, layer, x, y) { shape(layer,"u80-magnifier",x,y,e,0,0,780,0,"u80Pulse"); line(layer,"u80-handle",x+22,y+22,e,28,45,25,24,780); for(let i=0;i<5;i++) dot(layer,"u80-focus-dot",x+rand(-10,10),y+rand(-10,10),e,4,rand(-35,35),rand(-35,35),680+i*35); },
    levelBubble(effect, layer, x, y) { shape(layer,"u80-level",x,y,e,0,0,760,0); dot(layer,"u80-level-bubble",x-20,y,e,10,40,0,760); line(layer,"u80-level-mark",x,y,e,70,0,0,0,760); },
    metronomeTick(effect, layer, x, y) { shape(layer,"u80-metronome-base",x,y+18,e,0,20,820,0); line(layer,"u80-metronome-arm",x,y,e,54,-24,-12,-30,820); dot(layer,"u80-metronome-bob",x-12,y-26,e,9,-18,-30,820); },
    pendulumArc(effect, layer, x, y) { line(layer,"u80-pendulum-string",x,y-5,e,52,80,28,12,860); dot(layer,"u80-pendulum-bob",x+24,y+26,e,13,36,8,860); shape(layer,"u80-pendulum-anchor",x,y-28,e,0,-10,760,0); },
    rulerCrawl(effect, layer, x, y) { for(let i=0;i<12;i++) line(layer,"u80-ruler-tick",x-46+i*8,y+rand(-2,2),e,i%4===0?20:10,90,rand(-5,5),rand(-24,24),620+i*22); line(layer,"u80-ruler-base",x,y+12,e,96,0,0,20,760); },
    barcodeWipe(effect, layer, x, y) { for(let i=0;i<12;i++){let h=rand(18,42); line(layer,"u80-barcode",x-36+i*6,y,e,h,90,rand(-18,18),rand(-26,26),620+i*18);} line(layer,"u80-scan-beam",x,y,e,110,0,40,0,580); },
    focusReticle(effect, layer, x, y) { [[-1,-1], [1,-1], [-1,1], [1,1]].forEach((p,i)=>shape(layer,"u80-focus-corner",x+p[0]*22,y+p[1]*22,e,p[0]*16,p[1]*16,720+i*30,p[0]*p[1]*10)); pulse(layer,"u80-focus-ring",x,y,e,700); },
    gaugeNeedle(effect, layer, x, y) { shape(layer,"u80-gauge",x,y,e,0,0,760,0,"u80Pulse"); line(layer,"u80-gauge-needle",x,y,e,38,-35,25,-12,760); for(let i=0;i<5;i++) line(layer,"u80-gauge-tick",x-24+i*12,y-18,e,8,90,0,-18,650+i*30); },
    rubberBand(effect, layer, x, y) { shape(layer,"u80-rubber-loop",x,y,e,0,0,820,0,"u80Elastic"); dot(layer,"u80-band-pin",x-34,y,e,6,-34,0,720); dot(layer,"u80-band-pin",x+34,y,e,6,34,0,720); },
    springCoil(effect, layer, x, y) { for(let i=0;i<9;i++) line(layer,"u80-spring-seg",x-32+i*8,y+Math.sin(i)*5,e,15,i%2?55:-55,rand(-10,10),rand(-30,20),720+i*20); },
    chainLink(effect, layer, x, y) { for(let i=0;i<6;i++) shape(layer,"u80-chain-link",x-25+i*10,y+Math.sin(i)*4,e,rand(-30,30),rand(-32,32),760+i*28,i*18); },
    pistonPush(effect, layer, x, y) { line(layer,"u80-piston-rod",x,y,e,68,0,42,0,760); shape(layer,"u80-piston-head",x+36,y,e,45,0,760,0); shape(layer,"u80-piston-base",x-28,y,e,-18,0,760,0); },
    leverSnap(effect, layer, x, y) { shape(layer,"u80-lever-hinge",x-18,y+12,e,-12,18,740,0); line(layer,"u80-lever-bar",x,y,e,76,-22,32,-22,760); dot(layer,"u80-lever-knob",x+34,y-15,e,9,45,-28,760); },
    pulleyRope(effect, layer, x, y) { shape(layer,"u80-pulley-wheel",x,y,e,0,0,820,0,"u80Pulse"); line(layer,"u80-rope",x-24,y,e,52,90,-24,35,820); line(layer,"u80-rope",x+24,y,e,52,90,24,-35,820); },
    bearingOrbit(effect, layer, x, y) { pulse(layer,"u80-bearing-ring",x,y,e,760); for(let i=0;i<8;i++){let a=i*Math.PI/4+performance.now()/220;dot(layer,"u80-bearing-ball",x+Math.cos(a)*26,y+Math.sin(a)*26,e,7,Math.cos(a)*45,Math.sin(a)*45,720+i*20);} },
    boltScatter(effect, layer, x, y) { for(let i=0;i<6;i++) shape(layer,"u80-bolt",x+rand(-4,4),y+rand(-4,4),e,rand(-55,55),rand(-50,50),760+i*35,rand(-220,220)); },
    dominoFall(effect, layer, x, y) { for(let i=0;i<6;i++) shape(layer,"u80-domino",x-28+i*11,y,e,rand(-6,36),rand(-22,28),740+i*55,18+i*14); },
    diceTumble(effect, layer, x, y) { for(let i=0;i<4;i++) shape(layer,"u80-dice",x+rand(-6,6),y+rand(-6,6),e,rand(-48,48),rand(-48,28),820+i*45,rand(-180,180)); },
    tooltipPop(effect, layer, x, y) { card(layer,"u80-tooltip",x,y,e,"tip",rand(-14,14),-48,760,0); dot(layer,"u80-tooltip-tail",x,y+12,e,6,0,-20,680); },
    dropdownFold(effect, layer, x, y) { for(let i=0;i<4;i++) card(layer,"u80-dropdown-panel",x,y+i*9,e,"",0,30+i*10,760+i*45,0); },
    toggleOrbit(effect, layer, x, y) { shape(layer,"u80-toggle-pill",x,y,e,0,0,760,0); dot(layer,"u80-toggle-knob",x-18,y,e,12,38,0,760); pulse(layer,"u80-toggle-orbit",x,y,e,740); },
    progressTicks(effect, layer, x, y) { for(let i=0;i<8;i++) line(layer,"u80-progress-tick",x-32+i*9,y,e,12,90,rand(-6,6),rand(-42,-10),640+i*28); line(layer,"u80-progress-base",x,y+10,e,80,0,0,10,760); },
    commandPalette(effect, layer, x, y) { card(layer,"u80-command-palette",x,y,e,"> run",0,-30,820,0); for(let i=0;i<3;i++) line(layer,"u80-command-line",x,y-6+i*10,e,42,0,rand(-10,10),-30+i*10,720+i*35); },
    notificationBadge(effect, layer, x, y) { card(layer,"u80-notify-card",x,y,e,"",0,-24,800,0); dot(layer,"u80-badge",x+22,y-18,e,13,28,-36,760); for(let i=0;i<3;i++) dot(layer,"u80-badge-dot",x,y,e,4,rand(-32,32),rand(-40,10),680+i*30); },
    dragHandle(effect, layer, x, y) { for(let i=0;i<6;i++) dot(layer,"u80-grip-dot",x+(i%2)*8-4,y+Math.floor(i/2)*8-8,e,4,rand(-20,20),rand(-35,35),620+i*35); },
    resizeCorners(effect, layer, x, y) { [[-1,-1],[1,-1],[-1,1],[1,1]].forEach((p,i)=>shape(layer,"u80-resize-corner",x+p[0]*18,y+p[1]*18,e,p[0]*34,p[1]*34,720+i*30,p[0]*p[1]*45)); },
    breadcrumbTrail(effect, layer, x, y) { ["home","/","page","/","fx"].forEach((t,i)=>textMark(layer,"u80-breadcrumb",x-34+i*17,y,e,t,rand(-8,28),rand(-35,20),720+i*35,0)); },
    windowDock(effect, layer, x, y) { for(let i=0;i<4;i++) card(layer,"u80-window-card",x-24+i*16,y,e,"",rand(-16,16),-44-Math.abs(i-1.5)*8,780+i*35,rand(-10,10)); },
    routerPing(effect, layer, x, y) { for(let i=0;i<4;i++){let a=i*Math.PI/2; line(layer,"u80-network-line",x,y,e,44,a*180/Math.PI,Math.cos(a)*45,Math.sin(a)*45,760+i*30); dot(layer,"u80-node",x+Math.cos(a)*25,y+Math.sin(a)*25,e,7,Math.cos(a)*48,Math.sin(a)*48,760+i*30);} dot(layer,"u80-router-core",x,y,e,10,0,0,560); },
    dnsPulse(effect, layer, x, y) { ["DNS","A","MX","IP"].forEach((t,i)=>textMark(layer,"u80-dns-chip",x+rand(-8,8),y+rand(-8,8),e,t,rand(-52,52),rand(-42,42),760+i*55,0)); pulse(layer,"u80-dns-ring",x,y,e,760); },
    firewallSparks(effect, layer, x, y) { for(let i=0;i<5;i++) line(layer,"u80-firewall-brick",x,y-14+i*7,e,42,0,-20,rand(-5,5),720+i*20); for(let i=0;i<7;i++) dot(layer,"u80-fire-spark",x+22,y,e,4,rand(20,58),rand(-40,40),650+i*25); },
    databaseRings(effect, layer, x, y) { for(let i=0;i<4;i++) shape(layer,"u80-db-ring",x,y-i*5,e,0,-30-i*8,780+i*60,0); shape(layer,"u80-db-body",x,y,e,0,-20,820,0); },
    apiBraces(effect, layer, x, y) { textMark(layer,"u80-api-brace",x-15,y,e,"{",-38,0,720,-12); textMark(layer,"u80-api-brace",x+15,y,e,"}",38,0,720,12); textMark(layer,"u80-api-text",x,y,e,"API",0,-38,760,0); },
    packetLadder(effect, layer, x, y) { for(let i=0;i<6;i++){line(layer,"u80-ladder-step",x+i*8-22,y-i*7,e,20,0,30,-24,720+i*35); dot(layer,"u80-packet",x+i*8-22,y-i*7,e,6,38,-28,720+i*35);} },
    serverRack(effect, layer, x, y) { for(let i=0;i<5;i++) card(layer,"u80-server-slot",x,y-18+i*8,e,"",rand(-28,28),rand(-24,24),720+i*40,0); },
    webhookHook(effect, layer, x, y) { shape(layer,"u80-hook",x,y,e,42,-16,780,24); dot(layer,"u80-hook-packet",x-20,y+8,e,8,55,-22,780); },
    circuitBranch(effect, layer, x, y) { shape(layer,"u80-chip",x,y,e,0,0,760,0); [[1,0],[-1,0],[0,1],[0,-1],[1,1],[-1,-1]].forEach((p,i)=>line(layer,"u80-circuit",x,y,e,38,Math.atan2(p[1],p[0])*180/Math.PI,p[0]*45,p[1]*45,720+i*25)); },
    qrPixels(effect, layer, x, y) { for(let i=0;i<16;i++) shape(layer,"u80-qr-pixel",x+(i%4-1.5)*8,y+(Math.floor(i/4)-1.5)*8,e,rand(-36,36),rand(-36,36),700+i*18,0); },
    gelSquish(effect, layer, x, y) { shape(layer,"u80-gel",x,y,e,0,0,850,0,"u80Elastic"); for(let i=0;i<3;i++) dot(layer,"u80-gel-dot",x+rand(-10,10),y+rand(-7,7),e,5,rand(-18,18),rand(-20,20),760+i*40); },
    waxDrip(effect, layer, x, y) { for(let i=0;i<5;i++) shape(layer,"u80-wax",x+rand(-16,16),y+rand(-6,6),e,rand(-8,8),rand(45,86),900+i*45,0); },
    bubbleColumn(effect, layer, x, y) { for(let i=0;i<7;i++) dot(layer,"u80-bubble",x+rand(-9,9),y+rand(-8,8),e,rand(6,14),rand(-18,18),rand(-80,-30),920+i*40); },
    foamPop(effect, layer, x, y) { for(let i=0;i<6;i++) pulse(layer,"u80-foam",x+rand(-18,18),y+rand(-12,12),e,680+i*50); },
    threadNeedle(effect, layer, x, y) { line(layer,"u80-needle",x,y,e,64,rand(-18,18),55,-10,760); line(layer,"u80-thread",x-20,y+12,e,84,rand(12,42),rand(-38,38),rand(20,54),900); },
    clothRip(effect, layer, x, y) { for(let i=0;i<8;i++) line(layer,"u80-cloth-fiber",x+rand(-16,16),y+rand(-8,8),e,rand(18,42),rand(60,120),rand(-48,48),rand(-38,38),780+i*25); },
    stoneSkip(effect, layer, x, y) { for(let i=0;i<5;i++) shape(layer,"u80-stone",x+rand(-8,8),y+rand(-4,6),e,rand(22,70),rand(-60,32),840+i*50,rand(-140,140)); },
    metalFilings(effect, layer, x, y) { for(let i=0;i<12;i++){let a=i*Math.PI/6; line(layer,"u80-filing",x+Math.cos(a)*rand(16,42),y+Math.sin(a)*rand(16,42),e,rand(8,18),a*180/Math.PI+90,-Math.cos(a)*rand(10,28),-Math.sin(a)*rand(10,28),760+i*18);} },
    crystalCrack(effect, layer, x, y) { for(let i=0;i<7;i++){let a=rand(-160,160); line(layer,"u80-crack",x,y,e,rand(22,54),a,Math.cos(a*Math.PI/180)*rand(24,58),Math.sin(a*Math.PI/180)*rand(24,58),660+i*35);} },
    crumbFall(effect, layer, x, y) { for(let i=0;i<9;i++) shape(layer,"u80-crumb",x+rand(-14,14),y+rand(-10,8),e,rand(-30,30),rand(35,88),820+i*25,rand(-180,180)); },
    mapPing(effect, layer, x, y) { shape(layer,"u80-map-pin",x,y,e,0,-34,780,0); pulse(layer,"u80-map-ping",x,y+12,e,760); },
    routeDashes(effect, layer, x, y) { for(let i=0;i<8;i++) line(layer,"u80-route-dash",x-35+i*10,y+Math.sin(i)*10,e,14,rand(-20,20),rand(20,55),rand(-24,24),720+i*25); },
    waypointChain(effect, layer, x, y) { for(let i=0;i<5;i++){dot(layer,"u80-waypoint",x-24+i*12,y+Math.sin(i)*9,e,7,rand(-28,42),rand(-34,34),760+i*35); if(i<4) line(layer,"u80-way-link",x-18+i*12,y+Math.sin(i)*8,e,18,rand(-25,25),rand(-20,35),rand(-30,30),760+i*35);} },
    radarSweep(effect, layer, x, y) { pulse(layer,"u80-radar-ring",x,y,e,840); shape(layer,"u80-radar-wedge",x,y,e,0,0,840,rand(60,140)); },
    compassRose(effect, layer, x, y) { for(let i=0;i<8;i++){let a=i*Math.PI/4; line(layer,"u80-compass-tick",x,y,e,i%2?18:30,a*180/Math.PI,Math.cos(a)*55,Math.sin(a)*55,720+i*20);} },
    coordinatePop(effect, layer, x, y) { [`x:${Math.floor(rand(10,99))}`,`y:${Math.floor(rand(10,99))}`,'lat','lng'].forEach((t,i)=>textMark(layer,'u80-coordinate',x+rand(-6,6),y+rand(-6,6),e,t,rand(-38,38),rand(-58,20),760+i*50,0)); },
    locationBeam(effect, layer, x, y) { line(layer,"u80-location-beam",x,y,e,86,90,0,-68,760); dot(layer,"u80-location-core",x,y,e,9,0,-42,760); pulse(layer,"u80-location-ring",x,y,e,760); },
    topographyLines(effect, layer, x, y) { for(let i=0;i<5;i++){let el=piece(layer,'u80-topo',x,y,e);el.style.setProperty('--s',(38+i*18)+'px');fly(el,rand(-10,10),rand(-10,10),840+i*50,1,rand(-12,12),'u80Pulse');} },
    gridLocator(effect, layer, x, y) { for(let i=0;i<16;i++) shape(layer,"u80-grid-cell",x+(i%4-1.5)*11,y+(Math.floor(i/4)-1.5)*11,e,rand(-18,18),rand(-18,18),620+i*18,0); },
    navArrow(effect, layer, x, y) { shape(layer,"u80-nav-arrow",x,y,e,52,-20,820,rand(-24,24)); for(let i=0;i<4;i++) line(layer,"u80-nav-tick",x,y,e,16,rand(-60,60),rand(-30,20),rand(-30,20),700+i*30); },
    origamiFold(effect, layer, x, y) { for(let i=0;i<4;i++) shape(layer,"u80-origami",x+rand(-4,4),y+rand(-4,4),e,rand(-42,42),rand(-42,42),760+i*45,rand(-180,180)); },
    envelopeTear(effect, layer, x, y) { shape(layer,"u80-envelope",x,y,e,0,-30,780,0); for(let i=0;i<6;i++) shape(layer,"u80-paper-bit",x,y,e,rand(-50,50),rand(-46,24),700+i*35,rand(-180,180)); },
    ticketPunch(effect, layer, x, y) { card(layer,"u80-ticket",x,y,e,"TKT",0,-28,820,0); for(let i=0;i<5;i++) dot(layer,"u80-ticket-hole",x-20+i*10,y,e,4,rand(-16,16),rand(-48,-10),700+i*30); },
    paperclipLoop(effect, layer, x, y) { shape(layer,"u80-paperclip",x,y,e,36,-20,820,rand(20,60)); line(layer,"u80-clip-shadow",x,y,e,40,rand(20,60),28,-20,820); },
    bookmarkFlip(effect, layer, x, y) { shape(layer,"u80-bookmark",x,y,e,0,42,820,rand(-18,18)); line(layer,"u80-bookmark-fold",x,y-10,e,24,0,0,34,820); },
    scissorSnip(effect, layer, x, y) { line(layer,"u80-scissor",x,y,e,46,-35,-40,-20,760); line(layer,"u80-scissor",x,y,e,46,35,40,-20,760); pulse(layer,"u80-snip-ring",x,y,e,620); },
    waxSeal(effect, layer, x, y) { shape(layer,"u80-wax-seal",x,y,e,0,0,820,0,'u80Pulse'); for(let i=0;i<6;i++) line(layer,'u80-seal-crack',x,y,e,rand(10,24),rand(-180,180),rand(-20,20),rand(-20,20),700+i*30); },
    pinwheelSpin(effect, layer, x, y) { for(let i=0;i<4;i++) shape(layer,'u80-pinwheel-blade',x,y,e,Math.cos(i*Math.PI/2)*36,Math.sin(i*Math.PI/2)*36,820,i*90+rand(0,30)); dot(layer,'u80-pinwheel-pin',x,y,e,6,0,0,620); },
    scrollCurl(effect, layer, x, y) { shape(layer,'u80-scroll',x,y,e,20,-35,860,rand(-20,20)); line(layer,'u80-scroll-line',x,y+8,e,42,0,20,-30,820); },
    typeSlug(effect, layer, x, y) { ['A','B','/','*'].forEach((t,i)=>card(layer,'u80-type-slug',x+rand(-5,5),y+rand(-5,5),e,t,rand(-42,42),rand(-52,18),760+i*45,rand(-14,14))); },
    glyphWheel(effect, layer, x, y) { const glyphs=['✕','◇','△','○','+','//','*','□']; glyphs.forEach((g,i)=>{let a=i*Math.PI/4; textMark(layer,'u80-glyph',x+Math.cos(a)*18,y+Math.sin(a)*18,e,g,Math.cos(a)*48,Math.sin(a)*48,760+i*20,a*180/Math.PI);}); },
    morseBlips(effect, layer, x, y) { ['•','—','•','•','—'].forEach((t,i)=>textMark(layer,'u80-morse',x-24+i*12,y,e,t,rand(-10,10),rand(-45,25),700+i*50,0)); },
    brailleDots(effect, layer, x, y) { for(let i=0;i<6;i++) dot(layer,'u80-braille',x+(i%2)*9-4,y+Math.floor(i/2)*9-9,e,5,rand(-25,25),rand(-40,25),700+i*35); },
    chessStep(effect, layer, x, y) { shape(layer,'u80-chess',x,y,e,34,-34,820,0); for(let i=0;i<3;i++) dot(layer,'u80-chess-dot',x+i*10,y-i*10,e,4,30+i*10,-30-i*10,740+i*40); },
    lockShards(effect, layer, x, y) { shape(layer,'u80-lock',x,y,e,0,-20,760,0); for(let i=0;i<6;i++) shape(layer,'u80-lock-shard',x,y,e,rand(-50,50),rand(-45,45),700+i*35,rand(-180,180)); },
    keyTurn(effect, layer, x, y) { shape(layer,'u80-key',x,y,e,42,-8,820,70); for(let i=0;i<4;i++) dot(layer,'u80-key-spark',x+18,y,e,4,rand(20,55),rand(-30,30),680+i*30); },
    hourglassFlip(effect, layer, x, y) { shape(layer,'u80-hourglass',x,y,e,0,0,860,180); for(let i=0;i<7;i++) dot(layer,'u80-sand',x+rand(-8,8),y+rand(-6,6),e,3,rand(-10,10),rand(25,55),760+i*25); },
    playingCard(effect, layer, x, y) { card(layer,'u80-playing-card',x,y,e,pick(['♠','♥','♦','♣']),rand(-20,20),-42,820,rand(-40,40)); for(let i=0;i<4;i++) textMark(layer,'u80-suit',x,y,e,pick(['♠','♥','♦','♣']),rand(-45,45),rand(-45,20),720+i*30,rand(-60,60)); },
    puzzlePop(effect, layer, x, y) { for(let i=0;i<5;i++) shape(layer,'u80-puzzle',x+rand(-6,6),y+rand(-6,6),e,rand(-46,46),rand(-46,36),760+i*35,rand(-120,120)); },
    dialCombo(effect, layer, x, y) { pulse(layer,'u80-dial',x,y,e,820); for(let i=0;i<10;i++){let a=i*Math.PI/5; line(layer,'u80-dial-tick',x+Math.cos(a)*24,y+Math.sin(a)*24,e,i%2?10:17,a*180/Math.PI,Math.cos(a)*40,Math.sin(a)*40,720+i*20);} }
  };

  function clearLayerState(layer) {
    const s = states.get(layer);
    if (!s) return;
    s.dead = true;
    if (s.node) s.node.remove();
    states.delete(layer);
  }

  COLD_FX.spawn = function(effect, layer, x, y) {
    if (effect && effect.kind === "ultra80" && R[effect.mode]) {
      R[effect.mode](effect, layer, x, y);
      return;
    }
    oldSpawn(effect, layer, x, y);
  };

  COLD_FX.clear = function(layer) {
    clearLayerState(layer);
    if (oldClear) oldClear(layer);
    else layer.innerHTML = "";
  };
})();

'@

Save-Utf8 ".\assets\ultra80-data.js" $dataJs
Save-Utf8 ".\assets\ultra80-cursors.js" $rendererJs

Write-Host "2) Adding Ultra 80 CSS..."

$stylePath = ".\assets\style.css"
$style = Read-Utf8 $stylePath
$style = [regex]::Replace($style, '(?s)\r?\n?/\* ===== ULTRA 80 ADD-ONLY CURSOR PACK START ===== \*/.*?/\* ===== ULTRA 80 ADD-ONLY CURSOR PACK END ===== \*/', '')

$css = @'

/* ===== ULTRA 80 ADD-ONLY CURSOR PACK START ===== */
.u80-fx {
  position: absolute !important;
  pointer-events: none !important;
  z-index: 99999 !important;
  transform-origin: 50% 50% !important;
  will-change: transform, opacity !important;
  box-sizing: border-box !important;
}

.u80-fx:is(.u80-focus-dot,.u80-level-bubble,.u80-metronome-bob,.u80-band-pin,.u80-bearing-ball,.u80-badge,.u80-badge-dot,.u80-grip-dot,.u80-node,.u80-router-core,.u80-fire-spark,.u80-packet,.u80-gel-dot,.u80-bubble,.u80-map-ping,.u80-waypoint,.u80-coordinate,.u80-location-core,.u80-ticket-hole,.u80-pinwheel-pin,.u80-braille,.u80-chess-dot,.u80-key-spark,.u80-sand) {
  width: var(--s, 7px);
  height: var(--s, 7px);
  border-radius: 999px;
  background: radial-gradient(circle, var(--a), var(--b));
  box-shadow: 0 0 10px color-mix(in srgb, var(--a) 24%, transparent);
}

.u80-fx:is(.u80-caliper-jaw,.u80-caliper-bar,.u80-tick,.u80-handle,.u80-level-mark,.u80-metronome-arm,.u80-pendulum-string,.u80-ruler-tick,.u80-ruler-base,.u80-barcode,.u80-scan-beam,.u80-gauge-needle,.u80-gauge-tick,.u80-spring-seg,.u80-piston-rod,.u80-lever-bar,.u80-rope,.u80-progress-tick,.u80-progress-base,.u80-command-line,.u80-network-line,.u80-firewall-brick,.u80-ladder-step,.u80-circuit,.u80-needle,.u80-thread,.u80-cloth-fiber,.u80-filing,.u80-crack,.u80-route-dash,.u80-way-link,.u80-compass-tick,.u80-location-beam,.u80-scissor,.u80-seal-crack,.u80-scroll-line,.u80-morse,.u80-dial-tick) {
  width: var(--w, 42px);
  height: 2px;
  border-radius: 999px;
  background: linear-gradient(90deg, transparent, var(--a), var(--b), transparent);
  box-shadow: 0 0 9px color-mix(in srgb, var(--a) 18%, transparent);
}

.u80-protractor {
  width: 70px;
  height: 36px;
  border: 2px solid var(--a);
  border-bottom: 0;
  border-radius: 70px 70px 0 0;
}
.u80-magnifier {
  width: 38px;
  height: 38px;
  border-radius: 999px;
  border: 2px solid var(--a);
  background: radial-gradient(circle, color-mix(in srgb, var(--a) 12%, transparent), transparent 68%);
}
.u80-level {
  width: 76px;
  height: 22px;
  border: 2px solid var(--a);
  border-radius: 999px;
  background: color-mix(in srgb, var(--a) 8%, transparent);
}
.u80-metronome-base {
  width: 48px;
  height: 20px;
  border: 2px solid var(--a);
  border-radius: 5px 5px 12px 12px;
}
.u80-pendulum-anchor,.u80-gauge,.u80-focus-ring,.u80-toggle-orbit,.u80-dns-ring,.u80-radar-ring,.u80-location-ring,.u80-map-ping,.u80-snip-ring,.u80-satellite-orbit,.u80-dial {
  width: 48px;
  height: 48px;
  border-radius: 999px;
  border: 1px solid color-mix(in srgb, var(--a) 55%, transparent);
  background: radial-gradient(circle, color-mix(in srgb, var(--a) 10%, transparent), transparent 66%);
}
.u80-gauge {
  border-bottom-color: transparent;
}
.u80-focus-corner,.u80-resize-corner {
  width: 22px;
  height: 22px;
  border: 2px solid var(--a);
  border-right-color: transparent;
  border-bottom-color: transparent;
}

.u80-rubber-loop {
  width: 70px;
  height: 38px;
  border: 2px solid var(--a);
  border-radius: 999px;
}
.u80-chain-link,.u80-pulley-wheel,.u80-bearing-ring {
  width: 28px;
  height: 18px;
  border: 2px solid var(--a);
  border-radius: 999px;
}
.u80-piston-head,.u80-piston-base,.u80-server-slot,.u80-window-card,.u80-dropdown-panel,.u80-command-palette,.u80-notify-card,.u80-ticket,.u80-type-slug,.u80-tooltip {
  min-width: 42px;
  min-height: 26px;
  padding: 5px 8px;
  border: 1px solid color-mix(in srgb, var(--a) 56%, transparent);
  border-radius: 9px;
  background: color-mix(in srgb, var(--ink) 16%, transparent);
  color: var(--a);
  font: 800 11px/1 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
}
.u80-tooltip { border-radius: 999px; }
.u80-toggle-pill {
  width: 62px;
  height: 26px;
  border: 2px solid var(--a);
  border-radius: 999px;
}
.u80-breadcrumb,.u80-dns-chip,.u80-api-brace,.u80-api-text,.u80-coordinate,.u80-type-slug,.u80-glyph,.u80-morse,.u80-suit {
  color: var(--a);
  font: 900 12px/1 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  text-shadow: 0 0 10px color-mix(in srgb, var(--a) 32%, transparent);
}
.u80-api-brace { font-size: 28px; }
.u80-db-ring,.u80-db-body {
  width: 46px;
  height: 16px;
  border: 2px solid var(--a);
  border-radius: 50%;
  background: color-mix(in srgb, var(--a) 8%, transparent);
}
.u80-db-body { height: 36px; border-radius: 50% / 18%; }
.u80-hook {
  width: 38px;
  height: 38px;
  border: 4px solid var(--a);
  border-left-color: transparent;
  border-top-color: transparent;
  border-radius: 999px;
}
.u80-chip {
  width: 34px;
  height: 34px;
  border: 2px solid var(--a);
  border-radius: 6px;
  background: color-mix(in srgb, var(--a) 12%, transparent);
}
.u80-qr-pixel,.u80-grid-cell {
  width: 8px;
  height: 8px;
  border-radius: 2px;
  background: var(--a);
}

.u80-gel {
  width: 56px;
  height: 38px;
  border-radius: 52% 48% 60% 40%;
  background: radial-gradient(circle at 36% 30%, color-mix(in srgb, white 30%, transparent), transparent 18%), linear-gradient(135deg, var(--a), var(--b));
}
.u80-wax,.u80-liquid-drop {
  width: 16px;
  height: 28px;
  border-radius: 60% 60% 70% 70% / 45% 45% 80% 80%;
  background: linear-gradient(180deg, var(--a), var(--b));
}
.u80-bubble,.u80-foam {
  background: radial-gradient(circle at 35% 30%, color-mix(in srgb, white 40%, transparent), transparent 22%), color-mix(in srgb, var(--a) 20%, transparent);
  border: 1px solid color-mix(in srgb, var(--a) 50%, transparent);
}
.u80-stone,.u80-crumb {
  width: 14px;
  height: 10px;
  border-radius: 60% 42% 52% 48%;
  background: linear-gradient(135deg, var(--a), var(--b));
}
.u80-map-pin {
  width: 22px;
  height: 28px;
  border-radius: 50% 50% 50% 0;
  background: linear-gradient(135deg, var(--a), var(--b));
  transform: translate(-50%, -50%) rotate(-45deg);
}
.u80-radar-wedge {
  width: 58px;
  height: 58px;
  border-radius: 999px;
  background: conic-gradient(from 0deg, color-mix(in srgb, var(--a) 42%, transparent), transparent 34%);
}
.u80-topo {
  width: var(--s, 50px);
  height: var(--s, 50px);
  border-radius: 44% 56% 48% 52%;
  border: 1px solid color-mix(in srgb, var(--a) 54%, transparent);
}
.u80-nav-arrow {
  width: 30px;
  height: 34px;
  background: var(--a);
  clip-path: polygon(50% 0, 100% 100%, 50% 78%, 0 100%);
}
.u80-origami,.u80-paper-bit,.u80-folded,.u80-paperclip,.u80-bookmark,.u80-pinwheel-blade,.u80-scroll,.u80-envelope,.u80-playing-card,.u80-puzzle {
  width: 24px;
  height: 30px;
  background: linear-gradient(135deg, var(--a), var(--b));
  clip-path: polygon(50% 0, 100% 45%, 50% 100%, 0 45%);
}
.u80-envelope { width: 46px; height: 30px; clip-path: polygon(0 0,100% 0,100% 100%,0 100%); border-radius: 5px; }
.u80-ticket { border-style: dashed; }
.u80-paperclip {
  background: transparent;
  border: 3px solid var(--a);
  border-radius: 999px;
  clip-path: none;
}
.u80-bookmark { clip-path: polygon(0 0,100% 0,100% 100%,50% 74%,0 100%); }
.u80-scissor {
  height: 3px;
}
.u80-wax-seal {
  width: 42px;
  height: 42px;
  border-radius: 45% 55% 52% 48%;
  background: linear-gradient(135deg, var(--a), var(--b));
}
.u80-scroll {
  border-radius: 999px 12px 12px 999px;
  clip-path: none;
}
.u80-hourglass {
  width: 28px;
  height: 38px;
  border: 2px solid var(--a);
  clip-path: polygon(0 0,100% 0,58% 50%,100% 100%,0 100%,42% 50%);
}
.u80-lock {
  width: 28px;
  height: 26px;
  border-radius: 5px;
  border: 2px solid var(--a);
}
.u80-lock::before {
  content: "";
  position: absolute;
  left: 5px;
  top: -14px;
  width: 14px;
  height: 15px;
  border: 2px solid var(--a);
  border-bottom: 0;
  border-radius: 999px 999px 0 0;
}
.u80-lock-shard,.u80-bolt,.u80-crystal,.u80-puzzle {
  width: 15px;
  height: 12px;
  background: linear-gradient(135deg, var(--a), var(--b));
  clip-path: polygon(50% 0,100% 40%,72% 100%,10% 78%,0 28%);
}
.u80-key {
  width: 42px;
  height: 13px;
  background: var(--a);
  clip-path: polygon(0 35%,58% 35%,58% 0,72% 0,72% 35%,100% 35%,100% 65%,72% 65%,72% 100%,58% 100%,58% 65%,0 65%);
}
.u80-chess {
  width: 24px;
  height: 34px;
  background: linear-gradient(180deg, var(--a), var(--b));
  clip-path: polygon(44% 0,56% 0,63% 18%,75% 30%,62% 50%,82% 100%,18% 100%,38% 50%,25% 30%,37% 18%);
}
.u80-dice,.u80-domino {
  width: 22px;
  height: 28px;
  border-radius: 5px;
  border: 1px solid var(--a);
  background: color-mix(in srgb, var(--ink) 16%, transparent);
}
.u80-dice::before,.u80-domino::before {
  content: "• •";
  color: var(--a);
  position: absolute;
  left: 4px;
  top: 5px;
  font: 900 10px/1 ui-monospace, monospace;
}
.u80-dice::after,.u80-domino::after {
  content: "•";
  color: var(--a);
  position: absolute;
  right: 5px;
  bottom: 5px;
  font: 900 10px/1 ui-monospace, monospace;
}
.u80-glyph {
  font-size: 18px;
}
.u80-braille,.u80-sand {
  background: var(--a);
}
.u80-playing-card {
  min-width: 26px;
  min-height: 36px;
  border-radius: 5px;
  border: 1px solid var(--a);
  background: color-mix(in srgb, var(--ink) 15%, transparent);
  color: var(--a);
  font: 900 18px/1 ui-serif, Georgia, serif;
  display: grid;
  place-items: center;
}

@keyframes u80Fly {
  0% { opacity: 0; transform: translate(-50%, -50%) scale(.45) rotate(0); }
  16% { opacity: .95; }
  100% { opacity: 0; transform: translate(-50%, -50%) translate(var(--dx), var(--dy)) scale(var(--sc,1)) rotate(var(--rot)); }
}
@keyframes u80Pulse {
  0% { opacity: 0; transform: translate(-50%, -50%) scale(.18) rotate(0); }
  30% { opacity: .86; }
  100% { opacity: 0; transform: translate(-50%, -50%) translate(var(--dx,0), var(--dy,0)) scale(var(--sc,1.55)) rotate(var(--rot,0deg)); }
}
@keyframes u80Elastic {
  0% { opacity: 0; transform: translate(-50%, -50%) scale(.25,.9); }
  25% { opacity: .9; transform: translate(-50%, -50%) scale(1.35,.7); }
  65% { opacity: .65; transform: translate(-50%, -50%) scale(.88,1.18); }
  100% { opacity: 0; transform: translate(-50%, -50%) scale(1.5,1.5); }
}
/* ===== ULTRA 80 ADD-ONLY CURSOR PACK END ===== */

'@

Save-Utf8 $stylePath ($style.TrimEnd() + "`r`n" + $css)

Write-Host "3) Patching preview handler..."

$appPath = ".\assets\app.js"
$app = Read-Utf8 $appPath
$app = [regex]::Replace($app, '(?s)\r?\n?/\* ===== ULTRA80 PREVIEW RESCUE START ===== \*/.*?/\* ===== ULTRA80 PREVIEW RESCUE END ===== \*/', '')

$previewPatch = @'

/* ===== ULTRA80 PREVIEW RESCUE START ===== */
(function () {
  if (window.__ultra80PreviewRescueApplied) return;
  window.__ultra80PreviewRescueApplied = true;

  if (typeof attachEffectPreview === "function") {
    attachEffectPreview = function (section, effect) {
      const layer = section.querySelector(".fx-layer");
      const target = section.querySelector(".preview-zone") || section;
      if (!layer || !target || !effect || typeof COLD_FX === "undefined") return;

      let last = 0;
      const persistentKinds = new Set(["snake", "centipede", "jelly", "fish", "wild-animal", "ultra-follow", "signature-basic", "mega-basic"]);

      function spawnAt(clientX, clientY, force) {
        const now = performance.now();
        const gap = persistentKinds.has(effect.kind) ? 0 : 46;
        if (!force && now - last < gap) return;
        last = now;

        const rect = layer.getBoundingClientRect();
        const x = clientX - rect.left;
        const y = clientY - rect.top;
        COLD_FX.spawn(effect, layer, x, y);
      }

      function spawnCenter() {
        const rect = target.getBoundingClientRect();
        spawnAt(rect.left + rect.width / 2, rect.top + rect.height / 2, true);
      }

      target.addEventListener("pointerenter", spawnCenter);
      target.addEventListener("pointerdown", (event) => spawnAt(event.clientX, event.clientY, true));
      target.addEventListener("pointermove", (event) => spawnAt(event.clientX, event.clientY, false));
      target.addEventListener("touchstart", (event) => {
        const touch = event.touches && event.touches[0];
        if (touch) spawnAt(touch.clientX, touch.clientY, true);
      }, { passive: true });

      target.addEventListener("pointerleave", () => {
        if (persistentKinds.has(effect.kind)) {
          setTimeout(() => COLD_FX.clear(layer), 240);
        }
      });

      // Make empty previews visibly start even before the first mouse move.
      window.setTimeout(spawnCenter, 160);
    };
  }
})();
/* ===== ULTRA80 PREVIEW RESCUE END ===== */

'@

Save-Utf8 $appPath ($app.TrimEnd() + "`r`n" + $previewPatch)

Write-Host "4) Creating Ultra 80 category/source pages..."

$json = @'
{
  "categories": [
    {
      "id": "u80-precision-instruments",
      "num": "01",
      "title": "Precision Instruments",
      "desc": "Measuring, scanning and instrument-like cursor mechanics.",
      "icon": "instrument",
      "effects": [
        "u80-caliper-snap",
        "u80-protractor-sweep",
        "u80-magnifier-bloom",
        "u80-level-bubble",
        "u80-metronome-tick",
        "u80-pendulum-arc",
        "u80-ruler-crawl",
        "u80-barcode-wipe",
        "u80-focus-reticle",
        "u80-gauge-needle"
      ]
    },
    {
      "id": "u80-kinetic-objects",
      "num": "02",
      "title": "Kinetic Objects",
      "desc": "Physical toys, springs, levers and weighted cursor motion.",
      "icon": "kinetic",
      "effects": [
        "u80-rubber-band",
        "u80-spring-coil",
        "u80-chain-link",
        "u80-piston-push",
        "u80-lever-snap",
        "u80-pulley-rope",
        "u80-bearing-orbit",
        "u80-bolt-scatter",
        "u80-domino-fall",
        "u80-dice-tumble"
      ]
    },
    {
      "id": "u80-ui-micro",
      "num": "03",
      "title": "UI Micro Motion",
      "desc": "Interface-inspired cursor animations with cards, chips and controls.",
      "icon": "ui",
      "effects": [
        "u80-tooltip-pop",
        "u80-dropdown-fold",
        "u80-toggle-orbit",
        "u80-progress-ticks",
        "u80-command-palette",
        "u80-notification-badge",
        "u80-drag-handle",
        "u80-resize-corners",
        "u80-breadcrumb-trail",
        "u80-window-dock"
      ]
    },
    {
      "id": "u80-network-systems",
      "num": "04",
      "title": "Network Systems",
      "desc": "Packets, servers, databases, APIs and signal behavior.",
      "icon": "network",
      "effects": [
        "u80-router-ping",
        "u80-dns-pulse",
        "u80-firewall-sparks",
        "u80-database-rings",
        "u80-api-braces",
        "u80-packet-ladder",
        "u80-server-rack",
        "u80-webhook-hook",
        "u80-circuit-branch",
        "u80-qr-pixels"
      ]
    },
    {
      "id": "u80-material-fields",
      "num": "05",
      "title": "Material Fields",
      "desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
      "icon": "material",
      "effects": [
        "u80-gel-squish",
        "u80-wax-drip",
        "u80-bubble-column",
        "u80-foam-pop",
        "u80-thread-needle",
        "u80-cloth-rip",
        "u80-stone-skip",
        "u80-metal-filings",
        "u80-crystal-crack",
        "u80-crumb-fall"
      ]
    },
    {
      "id": "u80-map-navigation",
      "num": "06",
      "title": "Map & Navigation",
      "desc": "Pins, routes, radar, coordinates and navigator UI motion.",
      "icon": "map",
      "effects": [
        "u80-map-ping",
        "u80-route-dashes",
        "u80-waypoint-chain",
        "u80-radar-sweep",
        "u80-compass-rose",
        "u80-coordinate-pop",
        "u80-location-beam",
        "u80-topography-lines",
        "u80-grid-locator",
        "u80-nav-arrow"
      ]
    },
    {
      "id": "u80-paper-tools",
      "num": "07",
      "title": "Paper Tools",
      "desc": "Origami, envelopes, clips, stamps and desk-object motion.",
      "icon": "paper",
      "effects": [
        "u80-origami-fold",
        "u80-envelope-tear",
        "u80-ticket-punch",
        "u80-paperclip-loop",
        "u80-bookmark-flip",
        "u80-scissor-snip",
        "u80-wax-seal",
        "u80-pinwheel-spin",
        "u80-scroll-curl",
        "u80-type-slug"
      ]
    },
    {
      "id": "u80-glyph-games",
      "num": "08",
      "title": "Glyphs & Games",
      "desc": "Glyphs, runes, game marks and playful symbolic effects.",
      "icon": "glyph",
      "effects": [
        "u80-glyph-wheel",
        "u80-morse-blips",
        "u80-braille-dots",
        "u80-chess-step",
        "u80-lock-shards",
        "u80-key-turn",
        "u80-hourglass-flip",
        "u80-playing-card",
        "u80-puzzle-pop",
        "u80-dial-combo"
      ]
    }
  ],
  "effects": [
    {
      "key": "u80-caliper-snap",
      "name": "Caliper Snap",
      "desc": "Two measuring jaws close and release around the pointer.",
      "kind": "ultra80",
      "mode": "caliperSnap",
      "cat_id": "u80-precision-instruments",
      "cat_num": "01",
      "cat_title": "Precision Instruments",
      "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
      "cat_icon": "instrument",
      "index": 1,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-protractor-sweep",
      "name": "Protractor Sweep",
      "desc": "A half-circle protractor sweep draws angle ticks.",
      "kind": "ultra80",
      "mode": "protractorSweep",
      "cat_id": "u80-precision-instruments",
      "cat_num": "01",
      "cat_title": "Precision Instruments",
      "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
      "cat_icon": "instrument",
      "index": 2,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-magnifier-bloom",
      "name": "Magnifier Bloom",
      "desc": "A small magnifier ring expands and focuses dust.",
      "kind": "ultra80",
      "mode": "magnifierBloom",
      "cat_id": "u80-precision-instruments",
      "cat_num": "01",
      "cat_title": "Precision Instruments",
      "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
      "cat_icon": "instrument",
      "index": 3,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-level-bubble",
      "name": "Level Bubble",
      "desc": "A bubble level capsule slides and balances.",
      "kind": "ultra80",
      "mode": "levelBubble",
      "cat_id": "u80-precision-instruments",
      "cat_num": "01",
      "cat_title": "Precision Instruments",
      "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
      "cat_icon": "instrument",
      "index": 4,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-metronome-tick",
      "name": "Metronome Tick",
      "desc": "A metronome needle swings with tiny base ticks.",
      "kind": "ultra80",
      "mode": "metronomeTick",
      "cat_id": "u80-precision-instruments",
      "cat_num": "01",
      "cat_title": "Precision Instruments",
      "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
      "cat_icon": "instrument",
      "index": 5,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-pendulum-arc",
      "name": "Pendulum Arc",
      "desc": "A pendulum bob swings under a tiny anchor point.",
      "kind": "ultra80",
      "mode": "pendulumArc",
      "cat_id": "u80-precision-instruments",
      "cat_num": "01",
      "cat_title": "Precision Instruments",
      "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
      "cat_icon": "instrument",
      "index": 6,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-ruler-crawl",
      "name": "Ruler Crawl",
      "desc": "Measured ruler ticks crawl outward from the cursor.",
      "kind": "ultra80",
      "mode": "rulerCrawl",
      "cat_id": "u80-precision-instruments",
      "cat_num": "01",
      "cat_title": "Precision Instruments",
      "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
      "cat_icon": "instrument",
      "index": 7,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-barcode-wipe",
      "name": "Barcode Wipe",
      "desc": "A barcode strip wipes across and breaks apart.",
      "kind": "ultra80",
      "mode": "barcodeWipe",
      "cat_id": "u80-precision-instruments",
      "cat_num": "01",
      "cat_title": "Precision Instruments",
      "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
      "cat_icon": "instrument",
      "index": 8,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-focus-reticle",
      "name": "Focus Reticle",
      "desc": "Camera focus brackets tighten then fade.",
      "kind": "ultra80",
      "mode": "focusReticle",
      "cat_id": "u80-precision-instruments",
      "cat_num": "01",
      "cat_title": "Precision Instruments",
      "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
      "cat_icon": "instrument",
      "index": 9,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-gauge-needle",
      "name": "Gauge Needle",
      "desc": "A gauge needle snaps across a mini dial.",
      "kind": "ultra80",
      "mode": "gaugeNeedle",
      "cat_id": "u80-precision-instruments",
      "cat_num": "01",
      "cat_title": "Precision Instruments",
      "cat_desc": "Measuring, scanning and instrument-like cursor mechanics.",
      "cat_icon": "instrument",
      "index": 10,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-rubber-band",
      "name": "Rubber Band",
      "desc": "An elastic loop stretches behind the cursor.",
      "kind": "ultra80",
      "mode": "rubberBand",
      "cat_id": "u80-kinetic-objects",
      "cat_num": "02",
      "cat_title": "Kinetic Objects",
      "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
      "cat_icon": "kinetic",
      "index": 1,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-spring-coil",
      "name": "Spring Coil",
      "desc": "A tiny spring coil compresses and releases.",
      "kind": "ultra80",
      "mode": "springCoil",
      "cat_id": "u80-kinetic-objects",
      "cat_num": "02",
      "cat_title": "Kinetic Objects",
      "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
      "cat_icon": "kinetic",
      "index": 2,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-chain-link",
      "name": "Chain Link",
      "desc": "Short chain links separate with staggered timing.",
      "kind": "ultra80",
      "mode": "chainLink",
      "cat_id": "u80-kinetic-objects",
      "cat_num": "02",
      "cat_title": "Kinetic Objects",
      "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
      "cat_icon": "kinetic",
      "index": 3,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-piston-push",
      "name": "Piston Push",
      "desc": "A piston shaft pushes forward then retracts.",
      "kind": "ultra80",
      "mode": "pistonPush",
      "cat_id": "u80-kinetic-objects",
      "cat_num": "02",
      "cat_title": "Kinetic Objects",
      "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
      "cat_icon": "kinetic",
      "index": 4,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-lever-snap",
      "name": "Lever Snap",
      "desc": "A lever bar pivots quickly from a hinge.",
      "kind": "ultra80",
      "mode": "leverSnap",
      "cat_id": "u80-kinetic-objects",
      "cat_num": "02",
      "cat_title": "Kinetic Objects",
      "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
      "cat_icon": "kinetic",
      "index": 5,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-pulley-rope",
      "name": "Pulley Rope",
      "desc": "A rope arc and pulley dot roll away.",
      "kind": "ultra80",
      "mode": "pulleyRope",
      "cat_id": "u80-kinetic-objects",
      "cat_num": "02",
      "cat_title": "Kinetic Objects",
      "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
      "cat_icon": "kinetic",
      "index": 6,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-bearing-orbit",
      "name": "Bearing Orbit",
      "desc": "Ball bearings orbit then scatter outward.",
      "kind": "ultra80",
      "mode": "bearingOrbit",
      "cat_id": "u80-kinetic-objects",
      "cat_num": "02",
      "cat_title": "Kinetic Objects",
      "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
      "cat_icon": "kinetic",
      "index": 7,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-bolt-scatter",
      "name": "Bolt Scatter",
      "desc": "Small bolt shapes tumble away from the cursor.",
      "kind": "ultra80",
      "mode": "boltScatter",
      "cat_id": "u80-kinetic-objects",
      "cat_num": "02",
      "cat_title": "Kinetic Objects",
      "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
      "cat_icon": "kinetic",
      "index": 8,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-domino-fall",
      "name": "Domino Fall",
      "desc": "Tiny domino tiles fall in sequence.",
      "kind": "ultra80",
      "mode": "dominoFall",
      "cat_id": "u80-kinetic-objects",
      "cat_num": "02",
      "cat_title": "Kinetic Objects",
      "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
      "cat_icon": "kinetic",
      "index": 9,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-dice-tumble",
      "name": "Dice Tumble",
      "desc": "Small dice squares tumble in different angles.",
      "kind": "ultra80",
      "mode": "diceTumble",
      "cat_id": "u80-kinetic-objects",
      "cat_num": "02",
      "cat_title": "Kinetic Objects",
      "cat_desc": "Physical toys, springs, levers and weighted cursor motion.",
      "cat_icon": "kinetic",
      "index": 10,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-tooltip-pop",
      "name": "Tooltip Pop",
      "desc": "A tiny tooltip bubble pops and slides away.",
      "kind": "ultra80",
      "mode": "tooltipPop",
      "cat_id": "u80-ui-micro",
      "cat_num": "03",
      "cat_title": "UI Micro Motion",
      "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
      "cat_icon": "ui",
      "index": 1,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-dropdown-fold",
      "name": "Dropdown Fold",
      "desc": "Stacked dropdown panels unfold downward.",
      "kind": "ultra80",
      "mode": "dropdownFold",
      "cat_id": "u80-ui-micro",
      "cat_num": "03",
      "cat_title": "UI Micro Motion",
      "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
      "cat_icon": "ui",
      "index": 2,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-toggle-orbit",
      "name": "Toggle Orbit",
      "desc": "A switch knob orbits around a small pill.",
      "kind": "ultra80",
      "mode": "toggleOrbit",
      "cat_id": "u80-ui-micro",
      "cat_num": "03",
      "cat_title": "UI Micro Motion",
      "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
      "cat_icon": "ui",
      "index": 3,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-progress-ticks",
      "name": "Progress Ticks",
      "desc": "Progress ticks fill and float from the cursor.",
      "kind": "ultra80",
      "mode": "progressTicks",
      "cat_id": "u80-ui-micro",
      "cat_num": "03",
      "cat_title": "UI Micro Motion",
      "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
      "cat_icon": "ui",
      "index": 4,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-command-palette",
      "name": "Command Palette",
      "desc": "A tiny command palette opens then fragments.",
      "kind": "ultra80",
      "mode": "commandPalette",
      "cat_id": "u80-ui-micro",
      "cat_num": "03",
      "cat_title": "UI Micro Motion",
      "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
      "cat_icon": "ui",
      "index": 5,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-notification-badge",
      "name": "Notification Badge",
      "desc": "A notification badge pops with unread dots.",
      "kind": "ultra80",
      "mode": "notificationBadge",
      "cat_id": "u80-ui-micro",
      "cat_num": "03",
      "cat_title": "UI Micro Motion",
      "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
      "cat_icon": "ui",
      "index": 6,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-drag-handle",
      "name": "Drag Handle",
      "desc": "Grip dots slide like a draggable handle.",
      "kind": "ultra80",
      "mode": "dragHandle",
      "cat_id": "u80-ui-micro",
      "cat_num": "03",
      "cat_title": "UI Micro Motion",
      "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
      "cat_icon": "ui",
      "index": 7,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-resize-corners",
      "name": "Resize Corners",
      "desc": "Resize handles shoot out from four corners.",
      "kind": "ultra80",
      "mode": "resizeCorners",
      "cat_id": "u80-ui-micro",
      "cat_num": "03",
      "cat_title": "UI Micro Motion",
      "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
      "cat_icon": "ui",
      "index": 8,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-breadcrumb-trail",
      "name": "Breadcrumb Trail",
      "desc": "Small breadcrumb chips step behind the pointer.",
      "kind": "ultra80",
      "mode": "breadcrumbTrail",
      "cat_id": "u80-ui-micro",
      "cat_num": "03",
      "cat_title": "UI Micro Motion",
      "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
      "cat_icon": "ui",
      "index": 9,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-window-dock",
      "name": "Window Dock",
      "desc": "Mini window cards dock and bounce upward.",
      "kind": "ultra80",
      "mode": "windowDock",
      "cat_id": "u80-ui-micro",
      "cat_num": "03",
      "cat_title": "UI Micro Motion",
      "cat_desc": "Interface-inspired cursor animations with cards, chips and controls.",
      "cat_icon": "ui",
      "index": 10,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-router-ping",
      "name": "Router Ping",
      "desc": "Router nodes ping outward with short packet dots.",
      "kind": "ultra80",
      "mode": "routerPing",
      "cat_id": "u80-network-systems",
      "cat_num": "04",
      "cat_title": "Network Systems",
      "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
      "cat_icon": "network",
      "index": 1,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-dns-pulse",
      "name": "DNS Pulse",
      "desc": "DNS label dots pulse and resolve into a line.",
      "kind": "ultra80",
      "mode": "dnsPulse",
      "cat_id": "u80-network-systems",
      "cat_num": "04",
      "cat_title": "Network Systems",
      "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
      "cat_icon": "network",
      "index": 2,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-firewall-sparks",
      "name": "Firewall Sparks",
      "desc": "A tiny wall blocks and throws sparks aside.",
      "kind": "ultra80",
      "mode": "firewallSparks",
      "cat_id": "u80-network-systems",
      "cat_num": "04",
      "cat_title": "Network Systems",
      "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
      "cat_icon": "network",
      "index": 3,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-database-rings",
      "name": "Database Rings",
      "desc": "Database cylinder rings lift upward.",
      "kind": "ultra80",
      "mode": "databaseRings",
      "cat_id": "u80-network-systems",
      "cat_num": "04",
      "cat_title": "Network Systems",
      "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
      "cat_icon": "network",
      "index": 4,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-api-braces",
      "name": "API Braces",
      "desc": "Curly API braces snap open around the cursor.",
      "kind": "ultra80",
      "mode": "apiBraces",
      "cat_id": "u80-network-systems",
      "cat_num": "04",
      "cat_title": "Network Systems",
      "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
      "cat_icon": "network",
      "index": 5,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-packet-ladder",
      "name": "Packet Ladder",
      "desc": "Packets hop through a stepped ladder path.",
      "kind": "ultra80",
      "mode": "packetLadder",
      "cat_id": "u80-network-systems",
      "cat_num": "04",
      "cat_title": "Network Systems",
      "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
      "cat_icon": "network",
      "index": 6,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-server-rack",
      "name": "Server Rack",
      "desc": "Server rack slots blink and slide away.",
      "kind": "ultra80",
      "mode": "serverRack",
      "cat_id": "u80-network-systems",
      "cat_num": "04",
      "cat_title": "Network Systems",
      "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
      "cat_icon": "network",
      "index": 7,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-webhook-hook",
      "name": "Webhook Hook",
      "desc": "A small hook catches and releases a packet.",
      "kind": "ultra80",
      "mode": "webhookHook",
      "cat_id": "u80-network-systems",
      "cat_num": "04",
      "cat_title": "Network Systems",
      "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
      "cat_icon": "network",
      "index": 8,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-circuit-branch",
      "name": "Circuit Branch",
      "desc": "Circuit branches grow from a central chip.",
      "kind": "ultra80",
      "mode": "circuitBranch",
      "cat_id": "u80-network-systems",
      "cat_num": "04",
      "cat_title": "Network Systems",
      "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
      "cat_icon": "network",
      "index": 9,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-qr-pixels",
      "name": "QR Pixels",
      "desc": "QR-like pixel blocks assemble and scatter.",
      "kind": "ultra80",
      "mode": "qrPixels",
      "cat_id": "u80-network-systems",
      "cat_num": "04",
      "cat_title": "Network Systems",
      "cat_desc": "Packets, servers, databases, APIs and signal behavior.",
      "cat_icon": "network",
      "index": 10,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-gel-squish",
      "name": "Gel Squish",
      "desc": "A soft gel blob squashes and rebounds.",
      "kind": "ultra80",
      "mode": "gelSquish",
      "cat_id": "u80-material-fields",
      "cat_num": "05",
      "cat_title": "Material Fields",
      "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
      "cat_icon": "material",
      "index": 1,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-wax-drip",
      "name": "Wax Drip",
      "desc": "Rounded wax drops stretch downward slowly.",
      "kind": "ultra80",
      "mode": "waxDrip",
      "cat_id": "u80-material-fields",
      "cat_num": "05",
      "cat_title": "Material Fields",
      "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
      "cat_icon": "material",
      "index": 2,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-bubble-column",
      "name": "Bubble Column",
      "desc": "Bubbles rise in a thin vertical column.",
      "kind": "ultra80",
      "mode": "bubbleColumn",
      "cat_id": "u80-material-fields",
      "cat_num": "05",
      "cat_title": "Material Fields",
      "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
      "cat_icon": "material",
      "index": 3,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-foam-pop",
      "name": "Foam Pop",
      "desc": "Foam circles pop at different sizes.",
      "kind": "ultra80",
      "mode": "foamPop",
      "cat_id": "u80-material-fields",
      "cat_num": "05",
      "cat_title": "Material Fields",
      "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
      "cat_icon": "material",
      "index": 4,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-thread-needle",
      "name": "Thread Needle",
      "desc": "A needle line pulls a soft thread behind it.",
      "kind": "ultra80",
      "mode": "threadNeedle",
      "cat_id": "u80-material-fields",
      "cat_num": "05",
      "cat_title": "Material Fields",
      "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
      "cat_icon": "material",
      "index": 5,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-cloth-rip",
      "name": "Cloth Rip",
      "desc": "Frayed cloth fibers pull apart sideways.",
      "kind": "ultra80",
      "mode": "clothRip",
      "cat_id": "u80-material-fields",
      "cat_num": "05",
      "cat_title": "Material Fields",
      "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
      "cat_icon": "material",
      "index": 6,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-stone-skip",
      "name": "Stone Skip",
      "desc": "Small stones skip with gravity and bounce.",
      "kind": "ultra80",
      "mode": "stoneSkip",
      "cat_id": "u80-material-fields",
      "cat_num": "05",
      "cat_title": "Material Fields",
      "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
      "cat_icon": "material",
      "index": 7,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-metal-filings",
      "name": "Metal Filings",
      "desc": "Metal filings align toward an invisible magnet.",
      "kind": "ultra80",
      "mode": "metalFilings",
      "cat_id": "u80-material-fields",
      "cat_num": "05",
      "cat_title": "Material Fields",
      "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
      "cat_icon": "material",
      "index": 8,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-crystal-crack",
      "name": "Crystal Crack",
      "desc": "Crystal cracks grow in angular branches.",
      "kind": "ultra80",
      "mode": "crystalCrack",
      "cat_id": "u80-material-fields",
      "cat_num": "05",
      "cat_title": "Material Fields",
      "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
      "cat_icon": "material",
      "index": 9,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-crumb-fall",
      "name": "Crumb Fall",
      "desc": "Tiny crumbs fall and rotate with weight.",
      "kind": "ultra80",
      "mode": "crumbFall",
      "cat_id": "u80-material-fields",
      "cat_num": "05",
      "cat_title": "Material Fields",
      "cat_desc": "Gel, wax, crumbs, bubbles, fabric and weighted particles.",
      "cat_icon": "material",
      "index": 10,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-map-ping",
      "name": "Map Ping",
      "desc": "A map pin drops with a circular ping.",
      "kind": "ultra80",
      "mode": "mapPing",
      "cat_id": "u80-map-navigation",
      "cat_num": "06",
      "cat_title": "Map & Navigation",
      "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
      "cat_icon": "map",
      "index": 1,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-route-dashes",
      "name": "Route Dashes",
      "desc": "Route dashes travel along a curved path.",
      "kind": "ultra80",
      "mode": "routeDashes",
      "cat_id": "u80-map-navigation",
      "cat_num": "06",
      "cat_title": "Map & Navigation",
      "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
      "cat_icon": "map",
      "index": 2,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-waypoint-chain",
      "name": "Waypoint Chain",
      "desc": "Waypoint dots link and break apart.",
      "kind": "ultra80",
      "mode": "waypointChain",
      "cat_id": "u80-map-navigation",
      "cat_num": "06",
      "cat_title": "Map & Navigation",
      "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
      "cat_icon": "map",
      "index": 3,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-radar-sweep",
      "name": "Radar Sweep",
      "desc": "A radar wedge sweeps through a circle.",
      "kind": "ultra80",
      "mode": "radarSweep",
      "cat_id": "u80-map-navigation",
      "cat_num": "06",
      "cat_title": "Map & Navigation",
      "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
      "cat_icon": "map",
      "index": 4,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-compass-rose",
      "name": "Compass Rose",
      "desc": "Compass rose ticks open in eight directions.",
      "kind": "ultra80",
      "mode": "compassRose",
      "cat_id": "u80-map-navigation",
      "cat_num": "06",
      "cat_title": "Map & Navigation",
      "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
      "cat_icon": "map",
      "index": 5,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-coordinate-pop",
      "name": "Coordinate Pop",
      "desc": "Coordinate numbers pop and drift upward.",
      "kind": "ultra80",
      "mode": "coordinatePop",
      "cat_id": "u80-map-navigation",
      "cat_num": "06",
      "cat_title": "Map & Navigation",
      "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
      "cat_icon": "map",
      "index": 6,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-location-beam",
      "name": "Location Beam",
      "desc": "A location beam shoots upward from the cursor.",
      "kind": "ultra80",
      "mode": "locationBeam",
      "cat_id": "u80-map-navigation",
      "cat_num": "06",
      "cat_title": "Map & Navigation",
      "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
      "cat_icon": "map",
      "index": 7,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-topography-lines",
      "name": "Topography Lines",
      "desc": "Contour lines ripple outward unevenly.",
      "kind": "ultra80",
      "mode": "topographyLines",
      "cat_id": "u80-map-navigation",
      "cat_num": "06",
      "cat_title": "Map & Navigation",
      "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
      "cat_icon": "map",
      "index": 8,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-grid-locator",
      "name": "Grid Locator",
      "desc": "Locator grid cells flash and vanish.",
      "kind": "ultra80",
      "mode": "gridLocator",
      "cat_id": "u80-map-navigation",
      "cat_num": "06",
      "cat_title": "Map & Navigation",
      "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
      "cat_icon": "map",
      "index": 9,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-nav-arrow",
      "name": "Navigation Arrow",
      "desc": "A navigation arrow glides and splits into ticks.",
      "kind": "ultra80",
      "mode": "navArrow",
      "cat_id": "u80-map-navigation",
      "cat_num": "06",
      "cat_title": "Map & Navigation",
      "cat_desc": "Pins, routes, radar, coordinates and navigator UI motion.",
      "cat_icon": "map",
      "index": 10,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-origami-fold",
      "name": "Origami Fold",
      "desc": "Paper triangles fold open like origami.",
      "kind": "ultra80",
      "mode": "origamiFold",
      "cat_id": "u80-paper-tools",
      "cat_num": "07",
      "cat_title": "Paper Tools",
      "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
      "cat_icon": "paper",
      "index": 1,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-envelope-tear",
      "name": "Envelope Tear",
      "desc": "Envelope flap tears into small paper pieces.",
      "kind": "ultra80",
      "mode": "envelopeTear",
      "cat_id": "u80-paper-tools",
      "cat_num": "07",
      "cat_title": "Paper Tools",
      "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
      "cat_icon": "paper",
      "index": 2,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-ticket-punch",
      "name": "Ticket Punch",
      "desc": "A ticket rectangle punches out tiny holes.",
      "kind": "ultra80",
      "mode": "ticketPunch",
      "cat_id": "u80-paper-tools",
      "cat_num": "07",
      "cat_title": "Paper Tools",
      "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
      "cat_icon": "paper",
      "index": 3,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-paperclip-loop",
      "name": "Paperclip Loop",
      "desc": "A paperclip shape loops and springs away.",
      "kind": "ultra80",
      "mode": "paperclipLoop",
      "cat_id": "u80-paper-tools",
      "cat_num": "07",
      "cat_title": "Paper Tools",
      "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
      "cat_icon": "paper",
      "index": 4,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-bookmark-flip",
      "name": "Bookmark Flip",
      "desc": "A bookmark ribbon flips downward.",
      "kind": "ultra80",
      "mode": "bookmarkFlip",
      "cat_id": "u80-paper-tools",
      "cat_num": "07",
      "cat_title": "Paper Tools",
      "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
      "cat_icon": "paper",
      "index": 5,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-scissor-snip",
      "name": "Scissor Snip",
      "desc": "Two scissor blades snip and fly away.",
      "kind": "ultra80",
      "mode": "scissorSnip",
      "cat_id": "u80-paper-tools",
      "cat_num": "07",
      "cat_title": "Paper Tools",
      "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
      "cat_icon": "paper",
      "index": 6,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-wax-seal",
      "name": "Wax Seal",
      "desc": "A wax seal stamp expands and cracks.",
      "kind": "ultra80",
      "mode": "waxSeal",
      "cat_id": "u80-paper-tools",
      "cat_num": "07",
      "cat_title": "Paper Tools",
      "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
      "cat_icon": "paper",
      "index": 7,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-pinwheel-spin",
      "name": "Pinwheel Spin",
      "desc": "A tiny pinwheel rotates and drifts.",
      "kind": "ultra80",
      "mode": "pinwheelSpin",
      "cat_id": "u80-paper-tools",
      "cat_num": "07",
      "cat_title": "Paper Tools",
      "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
      "cat_icon": "paper",
      "index": 8,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-scroll-curl",
      "name": "Scroll Curl",
      "desc": "A small scroll curl opens and rolls away.",
      "kind": "ultra80",
      "mode": "scrollCurl",
      "cat_id": "u80-paper-tools",
      "cat_num": "07",
      "cat_title": "Paper Tools",
      "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
      "cat_icon": "paper",
      "index": 9,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-type-slug",
      "name": "Type Slug",
      "desc": "Typewriter slug blocks strike and fade.",
      "kind": "ultra80",
      "mode": "typeSlug",
      "cat_id": "u80-paper-tools",
      "cat_num": "07",
      "cat_title": "Paper Tools",
      "cat_desc": "Origami, envelopes, clips, stamps and desk-object motion.",
      "cat_icon": "paper",
      "index": 10,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-glyph-wheel",
      "name": "Glyph Wheel",
      "desc": "A wheel of glyphs spins outward.",
      "kind": "ultra80",
      "mode": "glyphWheel",
      "cat_id": "u80-glyph-games",
      "cat_num": "08",
      "cat_title": "Glyphs & Games",
      "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
      "cat_icon": "glyph",
      "index": 1,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-morse-blips",
      "name": "Morse Blips",
      "desc": "Morse dot-dash marks blink in a line.",
      "kind": "ultra80",
      "mode": "morseBlips",
      "cat_id": "u80-glyph-games",
      "cat_num": "08",
      "cat_title": "Glyphs & Games",
      "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
      "cat_icon": "glyph",
      "index": 2,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-braille-dots",
      "name": "Braille Dots",
      "desc": "Braille-style dots lift in a small grid.",
      "kind": "ultra80",
      "mode": "brailleDots",
      "cat_id": "u80-glyph-games",
      "cat_num": "08",
      "cat_title": "Glyphs & Games",
      "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
      "cat_icon": "glyph",
      "index": 3,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-chess-step",
      "name": "Chess Step",
      "desc": "A chess-piece silhouette steps diagonally.",
      "kind": "ultra80",
      "mode": "chessStep",
      "cat_id": "u80-glyph-games",
      "cat_num": "08",
      "cat_title": "Glyphs & Games",
      "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
      "cat_icon": "glyph",
      "index": 4,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-lock-shards",
      "name": "Lock Shards",
      "desc": "A tiny lock cracks into angular shards.",
      "kind": "ultra80",
      "mode": "lockShards",
      "cat_id": "u80-glyph-games",
      "cat_num": "08",
      "cat_title": "Glyphs & Games",
      "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
      "cat_icon": "glyph",
      "index": 5,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-key-turn",
      "name": "Key Turn",
      "desc": "A key shape turns and releases small marks.",
      "kind": "ultra80",
      "mode": "keyTurn",
      "cat_id": "u80-glyph-games",
      "cat_num": "08",
      "cat_title": "Glyphs & Games",
      "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
      "cat_icon": "glyph",
      "index": 6,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-hourglass-flip",
      "name": "Hourglass Flip",
      "desc": "An hourglass flips while sand dots fall.",
      "kind": "ultra80",
      "mode": "hourglassFlip",
      "cat_id": "u80-glyph-games",
      "cat_num": "08",
      "cat_title": "Glyphs & Games",
      "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
      "cat_icon": "glyph",
      "index": 7,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-playing-card",
      "name": "Playing Card",
      "desc": "A playing card flips and leaves suit marks.",
      "kind": "ultra80",
      "mode": "playingCard",
      "cat_id": "u80-glyph-games",
      "cat_num": "08",
      "cat_title": "Glyphs & Games",
      "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
      "cat_icon": "glyph",
      "index": 8,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-puzzle-pop",
      "name": "Puzzle Pop",
      "desc": "Puzzle piece shapes pop away from the cursor.",
      "kind": "ultra80",
      "mode": "puzzlePop",
      "cat_id": "u80-glyph-games",
      "cat_num": "08",
      "cat_title": "Glyphs & Games",
      "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
      "cat_icon": "glyph",
      "index": 9,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    },
    {
      "key": "u80-dial-combo",
      "name": "Dial Combo",
      "desc": "Combination dial ticks rotate in layers.",
      "kind": "ultra80",
      "mode": "dialCombo",
      "cat_id": "u80-glyph-games",
      "cat_num": "08",
      "cat_title": "Glyphs & Games",
      "cat_desc": "Glyphs, runes, game marks and playful symbolic effects.",
      "cat_icon": "glyph",
      "index": 10,
      "dark": {
        "a": "#f0e7d4",
        "b": "#9b8a6d",
        "ink": "#16120e"
      },
      "light": {
        "a": "#1f1a14",
        "b": "#75654d",
        "ink": "#faf8f1"
      }
    }
  ]
}
'@
$pack = $json | ConvertFrom-Json

New-Item -ItemType Directory -Path ".\categories" -Force | Out-Null
New-Item -ItemType Directory -Path ".\sources" -Force | Out-Null

# Write pages from embedded content files generated by this installer.
$pagesJson = @'
[{"path":"categories/u80-precision-instruments.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UHJlY2lzaW9uIEluc3RydW1lbnRzIHwgQ29sZGJvb3QgQ3Vyc29yIExpYnJhcnk8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vaW5kZXguaHRtbCI+SG9tZTwvYT4KICAgICAgICA8YSBocmVmPSIjZWZmZWN0cyI+RWZmZWN0czwvYT4KICAgICAgICA8YSBocmVmPSIjY2F0ZWdvcmllcyI+Q2F0ZWdvcmllczwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LXN0cmlwIiBpZD0iY2F0ZWdvcmllcyI+CiAgICAgIDxkaXYgY2xhc3M9ImNhdGVnb3J5LWdyaWQiIGlkPSJjYXRlZ29yeUdyaWQiPjwvZGl2PgogICAgICA8YnV0dG9uIGNsYXNzPSJzZWUtbW9yZSIgaWQ9InNlZU1vcmVCdG4iIHR5cGU9ImJ1dHRvbiIgYXJpYS1leHBhbmRlZD0iZmFsc2UiPlNlZSBtb3JlPC9idXR0b24+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+dWx0cmEgODAgLyBjYXRlZ29yeTwvc3Bhbj4KICAgICAgICA8aDE+UHJlY2lzaW9uIEluc3RydW1lbnRzPC9oMT4KICAgICAgICA8cD5NZWFzdXJpbmcsIHNjYW5uaW5nIGFuZCBpbnN0cnVtZW50LWxpa2UgY3Vyc29yIG1lY2hhbmljcy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3RzLXN0YWNrIHNlY3Rpb24tZ2FwIiBpZD0iZWZmZWN0cyI+CiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWNhbGlwZXItc25hcCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+UHJlY2lzaW9uIEluc3RydW1lbnRzIC8gMDE8L3NwYW4+CiAgICAgICAgICA8aDI+Q2FsaXBlciBTbmFwPC9oMj4KICAgICAgICAgIDxwPlR3byBtZWFzdXJpbmcgamF3cyBjbG9zZSBhbmQgcmVsZWFzZSBhcm91bmQgdGhlIHBvaW50ZXIuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1jYWxpcGVyLXNuYXAuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1wcm90cmFjdG9yLXN3ZWVwIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QcmVjaXNpb24gSW5zdHJ1bWVudHMgLyAwMjwvc3Bhbj4KICAgICAgICAgIDxoMj5Qcm90cmFjdG9yIFN3ZWVwPC9oMj4KICAgICAgICAgIDxwPkEgaGFsZi1jaXJjbGUgcHJvdHJhY3RvciBzd2VlcCBkcmF3cyBhbmdsZSB0aWNrcy48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXByb3RyYWN0b3Itc3dlZXAuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1tYWduaWZpZXItYmxvb20iPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlByZWNpc2lvbiBJbnN0cnVtZW50cyAvIDAzPC9zcGFuPgogICAgICAgICAgPGgyPk1hZ25pZmllciBCbG9vbTwvaDI+CiAgICAgICAgICA8cD5BIHNtYWxsIG1hZ25pZmllciByaW5nIGV4cGFuZHMgYW5kIGZvY3VzZXMgZHVzdC48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLW1hZ25pZmllci1ibG9vbS5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWxldmVsLWJ1YmJsZSI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+UHJlY2lzaW9uIEluc3RydW1lbnRzIC8gMDQ8L3NwYW4+CiAgICAgICAgICA8aDI+TGV2ZWwgQnViYmxlPC9oMj4KICAgICAgICAgIDxwPkEgYnViYmxlIGxldmVsIGNhcHN1bGUgc2xpZGVzIGFuZCBiYWxhbmNlcy48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLWxldmVsLWJ1YmJsZS5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLW1ldHJvbm9tZS10aWNrIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QcmVjaXNpb24gSW5zdHJ1bWVudHMgLyAwNTwvc3Bhbj4KICAgICAgICAgIDxoMj5NZXRyb25vbWUgVGljazwvaDI+CiAgICAgICAgICA8cD5BIG1ldHJvbm9tZSBuZWVkbGUgc3dpbmdzIHdpdGggdGlueSBiYXNlIHRpY2tzLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtbWV0cm9ub21lLXRpY2suaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1wZW5kdWx1bS1hcmMiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlByZWNpc2lvbiBJbnN0cnVtZW50cyAvIDA2PC9zcGFuPgogICAgICAgICAgPGgyPlBlbmR1bHVtIEFyYzwvaDI+CiAgICAgICAgICA8cD5BIHBlbmR1bHVtIGJvYiBzd2luZ3MgdW5kZXIgYSB0aW55IGFuY2hvciBwb2ludC48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXBlbmR1bHVtLWFyYy5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXJ1bGVyLWNyYXdsIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QcmVjaXNpb24gSW5zdHJ1bWVudHMgLyAwNzwvc3Bhbj4KICAgICAgICAgIDxoMj5SdWxlciBDcmF3bDwvaDI+CiAgICAgICAgICA8cD5NZWFzdXJlZCBydWxlciB0aWNrcyBjcmF3bCBvdXR3YXJkIGZyb20gdGhlIGN1cnNvci48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXJ1bGVyLWNyYXdsLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtYmFyY29kZS13aXBlIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QcmVjaXNpb24gSW5zdHJ1bWVudHMgLyAwODwvc3Bhbj4KICAgICAgICAgIDxoMj5CYXJjb2RlIFdpcGU8L2gyPgogICAgICAgICAgPHA+QSBiYXJjb2RlIHN0cmlwIHdpcGVzIGFjcm9zcyBhbmQgYnJlYWtzIGFwYXJ0LjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtYmFyY29kZS13aXBlLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtZm9jdXMtcmV0aWNsZSI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+UHJlY2lzaW9uIEluc3RydW1lbnRzIC8gMDk8L3NwYW4+CiAgICAgICAgICA8aDI+Rm9jdXMgUmV0aWNsZTwvaDI+CiAgICAgICAgICA8cD5DYW1lcmEgZm9jdXMgYnJhY2tldHMgdGlnaHRlbiB0aGVuIGZhZGUuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1mb2N1cy1yZXRpY2xlLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtZ2F1Z2UtbmVlZGxlIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QcmVjaXNpb24gSW5zdHJ1bWVudHMgLyAxMDwvc3Bhbj4KICAgICAgICAgIDxoMj5HYXVnZSBOZWVkbGU8L2gyPgogICAgICAgICAgPHA+QSBnYXVnZSBuZWVkbGUgc25hcHMgYWNyb3NzIGEgbWluaSBkaWFsLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtZ2F1Z2UtbmVlZGxlLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPlByZWNpc2lvbiBJbnN0cnVtZW50cyBjb250YWlucyBuZXcgYWRkLW9ubHkgVWx0cmEgODAgY3Vyc29yIGVmZmVjdHMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdENhdGVnb3J5UGFnZSgidTgwLXByZWNpc2lvbi1pbnN0cnVtZW50cyIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"categories/u80-kinetic-objects.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+S2luZXRpYyBPYmplY3RzIHwgQ29sZGJvb3QgQ3Vyc29yIExpYnJhcnk8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vaW5kZXguaHRtbCI+SG9tZTwvYT4KICAgICAgICA8YSBocmVmPSIjZWZmZWN0cyI+RWZmZWN0czwvYT4KICAgICAgICA8YSBocmVmPSIjY2F0ZWdvcmllcyI+Q2F0ZWdvcmllczwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LXN0cmlwIiBpZD0iY2F0ZWdvcmllcyI+CiAgICAgIDxkaXYgY2xhc3M9ImNhdGVnb3J5LWdyaWQiIGlkPSJjYXRlZ29yeUdyaWQiPjwvZGl2PgogICAgICA8YnV0dG9uIGNsYXNzPSJzZWUtbW9yZSIgaWQ9InNlZU1vcmVCdG4iIHR5cGU9ImJ1dHRvbiIgYXJpYS1leHBhbmRlZD0iZmFsc2UiPlNlZSBtb3JlPC9idXR0b24+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+dWx0cmEgODAgLyBjYXRlZ29yeTwvc3Bhbj4KICAgICAgICA8aDE+S2luZXRpYyBPYmplY3RzPC9oMT4KICAgICAgICA8cD5QaHlzaWNhbCB0b3lzLCBzcHJpbmdzLCBsZXZlcnMgYW5kIHdlaWdodGVkIGN1cnNvciBtb3Rpb24uPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0cy1zdGFjayBzZWN0aW9uLWdhcCIgaWQ9ImVmZmVjdHMiPgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1ydWJiZXItYmFuZCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+S2luZXRpYyBPYmplY3RzIC8gMDE8L3NwYW4+CiAgICAgICAgICA8aDI+UnViYmVyIEJhbmQ8L2gyPgogICAgICAgICAgPHA+QW4gZWxhc3RpYyBsb29wIHN0cmV0Y2hlcyBiZWhpbmQgdGhlIGN1cnNvci48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXJ1YmJlci1iYW5kLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtc3ByaW5nLWNvaWwiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPktpbmV0aWMgT2JqZWN0cyAvIDAyPC9zcGFuPgogICAgICAgICAgPGgyPlNwcmluZyBDb2lsPC9oMj4KICAgICAgICAgIDxwPkEgdGlueSBzcHJpbmcgY29pbCBjb21wcmVzc2VzIGFuZCByZWxlYXNlcy48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXNwcmluZy1jb2lsLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtY2hhaW4tbGluayI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+S2luZXRpYyBPYmplY3RzIC8gMDM8L3NwYW4+CiAgICAgICAgICA8aDI+Q2hhaW4gTGluazwvaDI+CiAgICAgICAgICA8cD5TaG9ydCBjaGFpbiBsaW5rcyBzZXBhcmF0ZSB3aXRoIHN0YWdnZXJlZCB0aW1pbmcuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1jaGFpbi1saW5rLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtcGlzdG9uLXB1c2giPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPktpbmV0aWMgT2JqZWN0cyAvIDA0PC9zcGFuPgogICAgICAgICAgPGgyPlBpc3RvbiBQdXNoPC9oMj4KICAgICAgICAgIDxwPkEgcGlzdG9uIHNoYWZ0IHB1c2hlcyBmb3J3YXJkIHRoZW4gcmV0cmFjdHMuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1waXN0b24tcHVzaC5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWxldmVyLXNuYXAiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPktpbmV0aWMgT2JqZWN0cyAvIDA1PC9zcGFuPgogICAgICAgICAgPGgyPkxldmVyIFNuYXA8L2gyPgogICAgICAgICAgPHA+QSBsZXZlciBiYXIgcGl2b3RzIHF1aWNrbHkgZnJvbSBhIGhpbmdlLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtbGV2ZXItc25hcC5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXB1bGxleS1yb3BlIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5LaW5ldGljIE9iamVjdHMgLyAwNjwvc3Bhbj4KICAgICAgICAgIDxoMj5QdWxsZXkgUm9wZTwvaDI+CiAgICAgICAgICA8cD5BIHJvcGUgYXJjIGFuZCBwdWxsZXkgZG90IHJvbGwgYXdheS48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXB1bGxleS1yb3BlLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtYmVhcmluZy1vcmJpdCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+S2luZXRpYyBPYmplY3RzIC8gMDc8L3NwYW4+CiAgICAgICAgICA8aDI+QmVhcmluZyBPcmJpdDwvaDI+CiAgICAgICAgICA8cD5CYWxsIGJlYXJpbmdzIG9yYml0IHRoZW4gc2NhdHRlciBvdXR3YXJkLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtYmVhcmluZy1vcmJpdC5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWJvbHQtc2NhdHRlciI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+S2luZXRpYyBPYmplY3RzIC8gMDg8L3NwYW4+CiAgICAgICAgICA8aDI+Qm9sdCBTY2F0dGVyPC9oMj4KICAgICAgICAgIDxwPlNtYWxsIGJvbHQgc2hhcGVzIHR1bWJsZSBhd2F5IGZyb20gdGhlIGN1cnNvci48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLWJvbHQtc2NhdHRlci5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWRvbWluby1mYWxsIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5LaW5ldGljIE9iamVjdHMgLyAwOTwvc3Bhbj4KICAgICAgICAgIDxoMj5Eb21pbm8gRmFsbDwvaDI+CiAgICAgICAgICA8cD5UaW55IGRvbWlubyB0aWxlcyBmYWxsIGluIHNlcXVlbmNlLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtZG9taW5vLWZhbGwuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1kaWNlLXR1bWJsZSI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+S2luZXRpYyBPYmplY3RzIC8gMTA8L3NwYW4+CiAgICAgICAgICA8aDI+RGljZSBUdW1ibGU8L2gyPgogICAgICAgICAgPHA+U21hbGwgZGljZSBzcXVhcmVzIHR1bWJsZSBpbiBkaWZmZXJlbnQgYW5nbGVzLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtZGljZS10dW1ibGUuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+S2luZXRpYyBPYmplY3RzIGNvbnRhaW5zIG5ldyBhZGQtb25seSBVbHRyYSA4MCBjdXJzb3IgZWZmZWN0cy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0Q2F0ZWdvcnlQYWdlKCJ1ODAta2luZXRpYy1vYmplY3RzIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"categories/u80-ui-micro.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+VUkgTWljcm8gTW90aW9uIHwgQ29sZGJvb3QgQ3Vyc29yIExpYnJhcnk8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vaW5kZXguaHRtbCI+SG9tZTwvYT4KICAgICAgICA8YSBocmVmPSIjZWZmZWN0cyI+RWZmZWN0czwvYT4KICAgICAgICA8YSBocmVmPSIjY2F0ZWdvcmllcyI+Q2F0ZWdvcmllczwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LXN0cmlwIiBpZD0iY2F0ZWdvcmllcyI+CiAgICAgIDxkaXYgY2xhc3M9ImNhdGVnb3J5LWdyaWQiIGlkPSJjYXRlZ29yeUdyaWQiPjwvZGl2PgogICAgICA8YnV0dG9uIGNsYXNzPSJzZWUtbW9yZSIgaWQ9InNlZU1vcmVCdG4iIHR5cGU9ImJ1dHRvbiIgYXJpYS1leHBhbmRlZD0iZmFsc2UiPlNlZSBtb3JlPC9idXR0b24+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+dWx0cmEgODAgLyBjYXRlZ29yeTwvc3Bhbj4KICAgICAgICA8aDE+VUkgTWljcm8gTW90aW9uPC9oMT4KICAgICAgICA8cD5JbnRlcmZhY2UtaW5zcGlyZWQgY3Vyc29yIGFuaW1hdGlvbnMgd2l0aCBjYXJkcywgY2hpcHMgYW5kIGNvbnRyb2xzLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdHMtc3RhY2sgc2VjdGlvbi1nYXAiIGlkPSJlZmZlY3RzIj4KICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtdG9vbHRpcC1wb3AiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlVJIE1pY3JvIE1vdGlvbiAvIDAxPC9zcGFuPgogICAgICAgICAgPGgyPlRvb2x0aXAgUG9wPC9oMj4KICAgICAgICAgIDxwPkEgdGlueSB0b29sdGlwIGJ1YmJsZSBwb3BzIGFuZCBzbGlkZXMgYXdheS48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXRvb2x0aXAtcG9wLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtZHJvcGRvd24tZm9sZCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+VUkgTWljcm8gTW90aW9uIC8gMDI8L3NwYW4+CiAgICAgICAgICA8aDI+RHJvcGRvd24gRm9sZDwvaDI+CiAgICAgICAgICA8cD5TdGFja2VkIGRyb3Bkb3duIHBhbmVscyB1bmZvbGQgZG93bndhcmQuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1kcm9wZG93bi1mb2xkLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtdG9nZ2xlLW9yYml0Ij4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5VSSBNaWNybyBNb3Rpb24gLyAwMzwvc3Bhbj4KICAgICAgICAgIDxoMj5Ub2dnbGUgT3JiaXQ8L2gyPgogICAgICAgICAgPHA+QSBzd2l0Y2gga25vYiBvcmJpdHMgYXJvdW5kIGEgc21hbGwgcGlsbC48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXRvZ2dsZS1vcmJpdC5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXByb2dyZXNzLXRpY2tzIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5VSSBNaWNybyBNb3Rpb24gLyAwNDwvc3Bhbj4KICAgICAgICAgIDxoMj5Qcm9ncmVzcyBUaWNrczwvaDI+CiAgICAgICAgICA8cD5Qcm9ncmVzcyB0aWNrcyBmaWxsIGFuZCBmbG9hdCBmcm9tIHRoZSBjdXJzb3IuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1wcm9ncmVzcy10aWNrcy5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWNvbW1hbmQtcGFsZXR0ZSI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+VUkgTWljcm8gTW90aW9uIC8gMDU8L3NwYW4+CiAgICAgICAgICA8aDI+Q29tbWFuZCBQYWxldHRlPC9oMj4KICAgICAgICAgIDxwPkEgdGlueSBjb21tYW5kIHBhbGV0dGUgb3BlbnMgdGhlbiBmcmFnbWVudHMuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1jb21tYW5kLXBhbGV0dGUuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1ub3RpZmljYXRpb24tYmFkZ2UiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlVJIE1pY3JvIE1vdGlvbiAvIDA2PC9zcGFuPgogICAgICAgICAgPGgyPk5vdGlmaWNhdGlvbiBCYWRnZTwvaDI+CiAgICAgICAgICA8cD5BIG5vdGlmaWNhdGlvbiBiYWRnZSBwb3BzIHdpdGggdW5yZWFkIGRvdHMuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1ub3RpZmljYXRpb24tYmFkZ2UuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1kcmFnLWhhbmRsZSI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+VUkgTWljcm8gTW90aW9uIC8gMDc8L3NwYW4+CiAgICAgICAgICA8aDI+RHJhZyBIYW5kbGU8L2gyPgogICAgICAgICAgPHA+R3JpcCBkb3RzIHNsaWRlIGxpa2UgYSBkcmFnZ2FibGUgaGFuZGxlLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtZHJhZy1oYW5kbGUuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1yZXNpemUtY29ybmVycyI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+VUkgTWljcm8gTW90aW9uIC8gMDg8L3NwYW4+CiAgICAgICAgICA8aDI+UmVzaXplIENvcm5lcnM8L2gyPgogICAgICAgICAgPHA+UmVzaXplIGhhbmRsZXMgc2hvb3Qgb3V0IGZyb20gZm91ciBjb3JuZXJzLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtcmVzaXplLWNvcm5lcnMuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1icmVhZGNydW1iLXRyYWlsIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5VSSBNaWNybyBNb3Rpb24gLyAwOTwvc3Bhbj4KICAgICAgICAgIDxoMj5CcmVhZGNydW1iIFRyYWlsPC9oMj4KICAgICAgICAgIDxwPlNtYWxsIGJyZWFkY3J1bWIgY2hpcHMgc3RlcCBiZWhpbmQgdGhlIHBvaW50ZXIuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1icmVhZGNydW1iLXRyYWlsLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtd2luZG93LWRvY2siPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlVJIE1pY3JvIE1vdGlvbiAvIDEwPC9zcGFuPgogICAgICAgICAgPGgyPldpbmRvdyBEb2NrPC9oMj4KICAgICAgICAgIDxwPk1pbmkgd2luZG93IGNhcmRzIGRvY2sgYW5kIGJvdW5jZSB1cHdhcmQuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC13aW5kb3ctZG9jay5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5VSSBNaWNybyBNb3Rpb24gY29udGFpbnMgbmV3IGFkZC1vbmx5IFVsdHJhIDgwIGN1cnNvciBlZmZlY3RzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRDYXRlZ29yeVBhZ2UoInU4MC11aS1taWNybyIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"categories/u80-network-systems.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TmV0d29yayBTeXN0ZW1zIHwgQ29sZGJvb3QgQ3Vyc29yIExpYnJhcnk8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vaW5kZXguaHRtbCI+SG9tZTwvYT4KICAgICAgICA8YSBocmVmPSIjZWZmZWN0cyI+RWZmZWN0czwvYT4KICAgICAgICA8YSBocmVmPSIjY2F0ZWdvcmllcyI+Q2F0ZWdvcmllczwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LXN0cmlwIiBpZD0iY2F0ZWdvcmllcyI+CiAgICAgIDxkaXYgY2xhc3M9ImNhdGVnb3J5LWdyaWQiIGlkPSJjYXRlZ29yeUdyaWQiPjwvZGl2PgogICAgICA8YnV0dG9uIGNsYXNzPSJzZWUtbW9yZSIgaWQ9InNlZU1vcmVCdG4iIHR5cGU9ImJ1dHRvbiIgYXJpYS1leHBhbmRlZD0iZmFsc2UiPlNlZSBtb3JlPC9idXR0b24+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+dWx0cmEgODAgLyBjYXRlZ29yeTwvc3Bhbj4KICAgICAgICA8aDE+TmV0d29yayBTeXN0ZW1zPC9oMT4KICAgICAgICA8cD5QYWNrZXRzLCBzZXJ2ZXJzLCBkYXRhYmFzZXMsIEFQSXMgYW5kIHNpZ25hbCBiZWhhdmlvci48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3RzLXN0YWNrIHNlY3Rpb24tZ2FwIiBpZD0iZWZmZWN0cyI+CiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXJvdXRlci1waW5nIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5OZXR3b3JrIFN5c3RlbXMgLyAwMTwvc3Bhbj4KICAgICAgICAgIDxoMj5Sb3V0ZXIgUGluZzwvaDI+CiAgICAgICAgICA8cD5Sb3V0ZXIgbm9kZXMgcGluZyBvdXR3YXJkIHdpdGggc2hvcnQgcGFja2V0IGRvdHMuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1yb3V0ZXItcGluZy5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWRucy1wdWxzZSI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TmV0d29yayBTeXN0ZW1zIC8gMDI8L3NwYW4+CiAgICAgICAgICA8aDI+RE5TIFB1bHNlPC9oMj4KICAgICAgICAgIDxwPkROUyBsYWJlbCBkb3RzIHB1bHNlIGFuZCByZXNvbHZlIGludG8gYSBsaW5lLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtZG5zLXB1bHNlLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtZmlyZXdhbGwtc3BhcmtzIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5OZXR3b3JrIFN5c3RlbXMgLyAwMzwvc3Bhbj4KICAgICAgICAgIDxoMj5GaXJld2FsbCBTcGFya3M8L2gyPgogICAgICAgICAgPHA+QSB0aW55IHdhbGwgYmxvY2tzIGFuZCB0aHJvd3Mgc3BhcmtzIGFzaWRlLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtZmlyZXdhbGwtc3BhcmtzLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtZGF0YWJhc2UtcmluZ3MiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk5ldHdvcmsgU3lzdGVtcyAvIDA0PC9zcGFuPgogICAgICAgICAgPGgyPkRhdGFiYXNlIFJpbmdzPC9oMj4KICAgICAgICAgIDxwPkRhdGFiYXNlIGN5bGluZGVyIHJpbmdzIGxpZnQgdXB3YXJkLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtZGF0YWJhc2UtcmluZ3MuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1hcGktYnJhY2VzIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5OZXR3b3JrIFN5c3RlbXMgLyAwNTwvc3Bhbj4KICAgICAgICAgIDxoMj5BUEkgQnJhY2VzPC9oMj4KICAgICAgICAgIDxwPkN1cmx5IEFQSSBicmFjZXMgc25hcCBvcGVuIGFyb3VuZCB0aGUgY3Vyc29yLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtYXBpLWJyYWNlcy5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXBhY2tldC1sYWRkZXIiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk5ldHdvcmsgU3lzdGVtcyAvIDA2PC9zcGFuPgogICAgICAgICAgPGgyPlBhY2tldCBMYWRkZXI8L2gyPgogICAgICAgICAgPHA+UGFja2V0cyBob3AgdGhyb3VnaCBhIHN0ZXBwZWQgbGFkZGVyIHBhdGguPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1wYWNrZXQtbGFkZGVyLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtc2VydmVyLXJhY2siPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk5ldHdvcmsgU3lzdGVtcyAvIDA3PC9zcGFuPgogICAgICAgICAgPGgyPlNlcnZlciBSYWNrPC9oMj4KICAgICAgICAgIDxwPlNlcnZlciByYWNrIHNsb3RzIGJsaW5rIGFuZCBzbGlkZSBhd2F5LjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtc2VydmVyLXJhY2suaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC13ZWJob29rLWhvb2siPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk5ldHdvcmsgU3lzdGVtcyAvIDA4PC9zcGFuPgogICAgICAgICAgPGgyPldlYmhvb2sgSG9vazwvaDI+CiAgICAgICAgICA8cD5BIHNtYWxsIGhvb2sgY2F0Y2hlcyBhbmQgcmVsZWFzZXMgYSBwYWNrZXQuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC13ZWJob29rLWhvb2suaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1jaXJjdWl0LWJyYW5jaCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TmV0d29yayBTeXN0ZW1zIC8gMDk8L3NwYW4+CiAgICAgICAgICA8aDI+Q2lyY3VpdCBCcmFuY2g8L2gyPgogICAgICAgICAgPHA+Q2lyY3VpdCBicmFuY2hlcyBncm93IGZyb20gYSBjZW50cmFsIGNoaXAuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1jaXJjdWl0LWJyYW5jaC5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXFyLXBpeGVscyI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TmV0d29yayBTeXN0ZW1zIC8gMTA8L3NwYW4+CiAgICAgICAgICA8aDI+UVIgUGl4ZWxzPC9oMj4KICAgICAgICAgIDxwPlFSLWxpa2UgcGl4ZWwgYmxvY2tzIGFzc2VtYmxlIGFuZCBzY2F0dGVyLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtcXItcGl4ZWxzLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPk5ldHdvcmsgU3lzdGVtcyBjb250YWlucyBuZXcgYWRkLW9ubHkgVWx0cmEgODAgY3Vyc29yIGVmZmVjdHMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdENhdGVnb3J5UGFnZSgidTgwLW5ldHdvcmstc3lzdGVtcyIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"categories/u80-material-fields.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TWF0ZXJpYWwgRmllbGRzIHwgQ29sZGJvb3QgQ3Vyc29yIExpYnJhcnk8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vaW5kZXguaHRtbCI+SG9tZTwvYT4KICAgICAgICA8YSBocmVmPSIjZWZmZWN0cyI+RWZmZWN0czwvYT4KICAgICAgICA8YSBocmVmPSIjY2F0ZWdvcmllcyI+Q2F0ZWdvcmllczwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LXN0cmlwIiBpZD0iY2F0ZWdvcmllcyI+CiAgICAgIDxkaXYgY2xhc3M9ImNhdGVnb3J5LWdyaWQiIGlkPSJjYXRlZ29yeUdyaWQiPjwvZGl2PgogICAgICA8YnV0dG9uIGNsYXNzPSJzZWUtbW9yZSIgaWQ9InNlZU1vcmVCdG4iIHR5cGU9ImJ1dHRvbiIgYXJpYS1leHBhbmRlZD0iZmFsc2UiPlNlZSBtb3JlPC9idXR0b24+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+dWx0cmEgODAgLyBjYXRlZ29yeTwvc3Bhbj4KICAgICAgICA8aDE+TWF0ZXJpYWwgRmllbGRzPC9oMT4KICAgICAgICA8cD5HZWwsIHdheCwgY3J1bWJzLCBidWJibGVzLCBmYWJyaWMgYW5kIHdlaWdodGVkIHBhcnRpY2xlcy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3RzLXN0YWNrIHNlY3Rpb24tZ2FwIiBpZD0iZWZmZWN0cyI+CiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWdlbC1zcXVpc2giPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hdGVyaWFsIEZpZWxkcyAvIDAxPC9zcGFuPgogICAgICAgICAgPGgyPkdlbCBTcXVpc2g8L2gyPgogICAgICAgICAgPHA+QSBzb2Z0IGdlbCBibG9iIHNxdWFzaGVzIGFuZCByZWJvdW5kcy48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLWdlbC1zcXVpc2guaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC13YXgtZHJpcCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWF0ZXJpYWwgRmllbGRzIC8gMDI8L3NwYW4+CiAgICAgICAgICA8aDI+V2F4IERyaXA8L2gyPgogICAgICAgICAgPHA+Um91bmRlZCB3YXggZHJvcHMgc3RyZXRjaCBkb3dud2FyZCBzbG93bHkuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC13YXgtZHJpcC5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWJ1YmJsZS1jb2x1bW4iPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hdGVyaWFsIEZpZWxkcyAvIDAzPC9zcGFuPgogICAgICAgICAgPGgyPkJ1YmJsZSBDb2x1bW48L2gyPgogICAgICAgICAgPHA+QnViYmxlcyByaXNlIGluIGEgdGhpbiB2ZXJ0aWNhbCBjb2x1bW4uPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1idWJibGUtY29sdW1uLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtZm9hbS1wb3AiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hdGVyaWFsIEZpZWxkcyAvIDA0PC9zcGFuPgogICAgICAgICAgPGgyPkZvYW0gUG9wPC9oMj4KICAgICAgICAgIDxwPkZvYW0gY2lyY2xlcyBwb3AgYXQgZGlmZmVyZW50IHNpemVzLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtZm9hbS1wb3AuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC10aHJlYWQtbmVlZGxlIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXRlcmlhbCBGaWVsZHMgLyAwNTwvc3Bhbj4KICAgICAgICAgIDxoMj5UaHJlYWQgTmVlZGxlPC9oMj4KICAgICAgICAgIDxwPkEgbmVlZGxlIGxpbmUgcHVsbHMgYSBzb2Z0IHRocmVhZCBiZWhpbmQgaXQuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC10aHJlYWQtbmVlZGxlLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtY2xvdGgtcmlwIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXRlcmlhbCBGaWVsZHMgLyAwNjwvc3Bhbj4KICAgICAgICAgIDxoMj5DbG90aCBSaXA8L2gyPgogICAgICAgICAgPHA+RnJheWVkIGNsb3RoIGZpYmVycyBwdWxsIGFwYXJ0IHNpZGV3YXlzLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtY2xvdGgtcmlwLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtc3RvbmUtc2tpcCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWF0ZXJpYWwgRmllbGRzIC8gMDc8L3NwYW4+CiAgICAgICAgICA8aDI+U3RvbmUgU2tpcDwvaDI+CiAgICAgICAgICA8cD5TbWFsbCBzdG9uZXMgc2tpcCB3aXRoIGdyYXZpdHkgYW5kIGJvdW5jZS48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXN0b25lLXNraXAuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1tZXRhbC1maWxpbmdzIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXRlcmlhbCBGaWVsZHMgLyAwODwvc3Bhbj4KICAgICAgICAgIDxoMj5NZXRhbCBGaWxpbmdzPC9oMj4KICAgICAgICAgIDxwPk1ldGFsIGZpbGluZ3MgYWxpZ24gdG93YXJkIGFuIGludmlzaWJsZSBtYWduZXQuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1tZXRhbC1maWxpbmdzLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtY3J5c3RhbC1jcmFjayI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWF0ZXJpYWwgRmllbGRzIC8gMDk8L3NwYW4+CiAgICAgICAgICA8aDI+Q3J5c3RhbCBDcmFjazwvaDI+CiAgICAgICAgICA8cD5DcnlzdGFsIGNyYWNrcyBncm93IGluIGFuZ3VsYXIgYnJhbmNoZXMuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1jcnlzdGFsLWNyYWNrLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtY3J1bWItZmFsbCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWF0ZXJpYWwgRmllbGRzIC8gMTA8L3NwYW4+CiAgICAgICAgICA8aDI+Q3J1bWIgRmFsbDwvaDI+CiAgICAgICAgICA8cD5UaW55IGNydW1icyBmYWxsIGFuZCByb3RhdGUgd2l0aCB3ZWlnaHQuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1jcnVtYi1mYWxsLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPk1hdGVyaWFsIEZpZWxkcyBjb250YWlucyBuZXcgYWRkLW9ubHkgVWx0cmEgODAgY3Vyc29yIGVmZmVjdHMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdENhdGVnb3J5UGFnZSgidTgwLW1hdGVyaWFsLWZpZWxkcyIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"categories/u80-map-navigation.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TWFwICZhbXA7IE5hdmlnYXRpb24gfCBDb2xkYm9vdCBDdXJzb3IgTGlicmFyeTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9pbmRleC5odG1sIj5Ib21lPC9hPgogICAgICAgIDxhIGhyZWY9IiNlZmZlY3RzIj5FZmZlY3RzPC9hPgogICAgICAgIDxhIGhyZWY9IiNjYXRlZ29yaWVzIj5DYXRlZ29yaWVzPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktc3RyaXAiIGlkPSJjYXRlZ29yaWVzIj4KICAgICAgPGRpdiBjbGFzcz0iY2F0ZWdvcnktZ3JpZCIgaWQ9ImNhdGVnb3J5R3JpZCI+PC9kaXY+CiAgICAgIDxidXR0b24gY2xhc3M9InNlZS1tb3JlIiBpZD0ic2VlTW9yZUJ0biIgdHlwZT0iYnV0dG9uIiBhcmlhLWV4cGFuZGVkPSJmYWxzZSI+U2VlIG1vcmU8L2J1dHRvbj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj51bHRyYSA4MCAvIGNhdGVnb3J5PC9zcGFuPgogICAgICAgIDxoMT5NYXAgJmFtcDsgTmF2aWdhdGlvbjwvaDE+CiAgICAgICAgPHA+UGlucywgcm91dGVzLCByYWRhciwgY29vcmRpbmF0ZXMgYW5kIG5hdmlnYXRvciBVSSBtb3Rpb24uPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0cy1zdGFjayBzZWN0aW9uLWdhcCIgaWQ9ImVmZmVjdHMiPgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1tYXAtcGluZyI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWFwICZhbXA7IE5hdmlnYXRpb24gLyAwMTwvc3Bhbj4KICAgICAgICAgIDxoMj5NYXAgUGluZzwvaDI+CiAgICAgICAgICA8cD5BIG1hcCBwaW4gZHJvcHMgd2l0aCBhIGNpcmN1bGFyIHBpbmcuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1tYXAtcGluZy5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXJvdXRlLWRhc2hlcyI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWFwICZhbXA7IE5hdmlnYXRpb24gLyAwMjwvc3Bhbj4KICAgICAgICAgIDxoMj5Sb3V0ZSBEYXNoZXM8L2gyPgogICAgICAgICAgPHA+Um91dGUgZGFzaGVzIHRyYXZlbCBhbG9uZyBhIGN1cnZlZCBwYXRoLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtcm91dGUtZGFzaGVzLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtd2F5cG9pbnQtY2hhaW4iPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hcCAmYW1wOyBOYXZpZ2F0aW9uIC8gMDM8L3NwYW4+CiAgICAgICAgICA8aDI+V2F5cG9pbnQgQ2hhaW48L2gyPgogICAgICAgICAgPHA+V2F5cG9pbnQgZG90cyBsaW5rIGFuZCBicmVhayBhcGFydC48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXdheXBvaW50LWNoYWluLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtcmFkYXItc3dlZXAiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hcCAmYW1wOyBOYXZpZ2F0aW9uIC8gMDQ8L3NwYW4+CiAgICAgICAgICA8aDI+UmFkYXIgU3dlZXA8L2gyPgogICAgICAgICAgPHA+QSByYWRhciB3ZWRnZSBzd2VlcHMgdGhyb3VnaCBhIGNpcmNsZS48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXJhZGFyLXN3ZWVwLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtY29tcGFzcy1yb3NlIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXAgJmFtcDsgTmF2aWdhdGlvbiAvIDA1PC9zcGFuPgogICAgICAgICAgPGgyPkNvbXBhc3MgUm9zZTwvaDI+CiAgICAgICAgICA8cD5Db21wYXNzIHJvc2UgdGlja3Mgb3BlbiBpbiBlaWdodCBkaXJlY3Rpb25zLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtY29tcGFzcy1yb3NlLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtY29vcmRpbmF0ZS1wb3AiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hcCAmYW1wOyBOYXZpZ2F0aW9uIC8gMDY8L3NwYW4+CiAgICAgICAgICA8aDI+Q29vcmRpbmF0ZSBQb3A8L2gyPgogICAgICAgICAgPHA+Q29vcmRpbmF0ZSBudW1iZXJzIHBvcCBhbmQgZHJpZnQgdXB3YXJkLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtY29vcmRpbmF0ZS1wb3AuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1sb2NhdGlvbi1iZWFtIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXAgJmFtcDsgTmF2aWdhdGlvbiAvIDA3PC9zcGFuPgogICAgICAgICAgPGgyPkxvY2F0aW9uIEJlYW08L2gyPgogICAgICAgICAgPHA+QSBsb2NhdGlvbiBiZWFtIHNob290cyB1cHdhcmQgZnJvbSB0aGUgY3Vyc29yLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtbG9jYXRpb24tYmVhbS5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXRvcG9ncmFwaHktbGluZXMiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hcCAmYW1wOyBOYXZpZ2F0aW9uIC8gMDg8L3NwYW4+CiAgICAgICAgICA8aDI+VG9wb2dyYXBoeSBMaW5lczwvaDI+CiAgICAgICAgICA8cD5Db250b3VyIGxpbmVzIHJpcHBsZSBvdXR3YXJkIHVuZXZlbmx5LjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtdG9wb2dyYXBoeS1saW5lcy5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWdyaWQtbG9jYXRvciI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWFwICZhbXA7IE5hdmlnYXRpb24gLyAwOTwvc3Bhbj4KICAgICAgICAgIDxoMj5HcmlkIExvY2F0b3I8L2gyPgogICAgICAgICAgPHA+TG9jYXRvciBncmlkIGNlbGxzIGZsYXNoIGFuZCB2YW5pc2guPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1ncmlkLWxvY2F0b3IuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1uYXYtYXJyb3ciPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hcCAmYW1wOyBOYXZpZ2F0aW9uIC8gMTA8L3NwYW4+CiAgICAgICAgICA8aDI+TmF2aWdhdGlvbiBBcnJvdzwvaDI+CiAgICAgICAgICA8cD5BIG5hdmlnYXRpb24gYXJyb3cgZ2xpZGVzIGFuZCBzcGxpdHMgaW50byB0aWNrcy48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLW5hdi1hcnJvdy5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5NYXAgJmFtcDsgTmF2aWdhdGlvbiBjb250YWlucyBuZXcgYWRkLW9ubHkgVWx0cmEgODAgY3Vyc29yIGVmZmVjdHMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdENhdGVnb3J5UGFnZSgidTgwLW1hcC1uYXZpZ2F0aW9uIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"categories/u80-paper-tools.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UGFwZXIgVG9vbHMgfCBDb2xkYm9vdCBDdXJzb3IgTGlicmFyeTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9pbmRleC5odG1sIj5Ib21lPC9hPgogICAgICAgIDxhIGhyZWY9IiNlZmZlY3RzIj5FZmZlY3RzPC9hPgogICAgICAgIDxhIGhyZWY9IiNjYXRlZ29yaWVzIj5DYXRlZ29yaWVzPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktc3RyaXAiIGlkPSJjYXRlZ29yaWVzIj4KICAgICAgPGRpdiBjbGFzcz0iY2F0ZWdvcnktZ3JpZCIgaWQ9ImNhdGVnb3J5R3JpZCI+PC9kaXY+CiAgICAgIDxidXR0b24gY2xhc3M9InNlZS1tb3JlIiBpZD0ic2VlTW9yZUJ0biIgdHlwZT0iYnV0dG9uIiBhcmlhLWV4cGFuZGVkPSJmYWxzZSI+U2VlIG1vcmU8L2J1dHRvbj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj51bHRyYSA4MCAvIGNhdGVnb3J5PC9zcGFuPgogICAgICAgIDxoMT5QYXBlciBUb29sczwvaDE+CiAgICAgICAgPHA+T3JpZ2FtaSwgZW52ZWxvcGVzLCBjbGlwcywgc3RhbXBzIGFuZCBkZXNrLW9iamVjdCBtb3Rpb24uPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0cy1zdGFjayBzZWN0aW9uLWdhcCIgaWQ9ImVmZmVjdHMiPgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1vcmlnYW1pLWZvbGQiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlBhcGVyIFRvb2xzIC8gMDE8L3NwYW4+CiAgICAgICAgICA8aDI+T3JpZ2FtaSBGb2xkPC9oMj4KICAgICAgICAgIDxwPlBhcGVyIHRyaWFuZ2xlcyBmb2xkIG9wZW4gbGlrZSBvcmlnYW1pLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtb3JpZ2FtaS1mb2xkLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtZW52ZWxvcGUtdGVhciI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+UGFwZXIgVG9vbHMgLyAwMjwvc3Bhbj4KICAgICAgICAgIDxoMj5FbnZlbG9wZSBUZWFyPC9oMj4KICAgICAgICAgIDxwPkVudmVsb3BlIGZsYXAgdGVhcnMgaW50byBzbWFsbCBwYXBlciBwaWVjZXMuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1lbnZlbG9wZS10ZWFyLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtdGlja2V0LXB1bmNoIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QYXBlciBUb29scyAvIDAzPC9zcGFuPgogICAgICAgICAgPGgyPlRpY2tldCBQdW5jaDwvaDI+CiAgICAgICAgICA8cD5BIHRpY2tldCByZWN0YW5nbGUgcHVuY2hlcyBvdXQgdGlueSBob2xlcy48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXRpY2tldC1wdW5jaC5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXBhcGVyY2xpcC1sb29wIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QYXBlciBUb29scyAvIDA0PC9zcGFuPgogICAgICAgICAgPGgyPlBhcGVyY2xpcCBMb29wPC9oMj4KICAgICAgICAgIDxwPkEgcGFwZXJjbGlwIHNoYXBlIGxvb3BzIGFuZCBzcHJpbmdzIGF3YXkuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1wYXBlcmNsaXAtbG9vcC5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWJvb2ttYXJrLWZsaXAiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlBhcGVyIFRvb2xzIC8gMDU8L3NwYW4+CiAgICAgICAgICA8aDI+Qm9va21hcmsgRmxpcDwvaDI+CiAgICAgICAgICA8cD5BIGJvb2ttYXJrIHJpYmJvbiBmbGlwcyBkb3dud2FyZC48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLWJvb2ttYXJrLWZsaXAuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1zY2lzc29yLXNuaXAiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlBhcGVyIFRvb2xzIC8gMDY8L3NwYW4+CiAgICAgICAgICA8aDI+U2Npc3NvciBTbmlwPC9oMj4KICAgICAgICAgIDxwPlR3byBzY2lzc29yIGJsYWRlcyBzbmlwIGFuZCBmbHkgYXdheS48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXNjaXNzb3Itc25pcC5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXdheC1zZWFsIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QYXBlciBUb29scyAvIDA3PC9zcGFuPgogICAgICAgICAgPGgyPldheCBTZWFsPC9oMj4KICAgICAgICAgIDxwPkEgd2F4IHNlYWwgc3RhbXAgZXhwYW5kcyBhbmQgY3JhY2tzLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtd2F4LXNlYWwuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1waW53aGVlbC1zcGluIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QYXBlciBUb29scyAvIDA4PC9zcGFuPgogICAgICAgICAgPGgyPlBpbndoZWVsIFNwaW48L2gyPgogICAgICAgICAgPHA+QSB0aW55IHBpbndoZWVsIHJvdGF0ZXMgYW5kIGRyaWZ0cy48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXBpbndoZWVsLXNwaW4uaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1zY3JvbGwtY3VybCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+UGFwZXIgVG9vbHMgLyAwOTwvc3Bhbj4KICAgICAgICAgIDxoMj5TY3JvbGwgQ3VybDwvaDI+CiAgICAgICAgICA8cD5BIHNtYWxsIHNjcm9sbCBjdXJsIG9wZW5zIGFuZCByb2xscyBhd2F5LjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtc2Nyb2xsLWN1cmwuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC10eXBlLXNsdWciPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlBhcGVyIFRvb2xzIC8gMTA8L3NwYW4+CiAgICAgICAgICA8aDI+VHlwZSBTbHVnPC9oMj4KICAgICAgICAgIDxwPlR5cGV3cml0ZXIgc2x1ZyBibG9ja3Mgc3RyaWtlIGFuZCBmYWRlLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtdHlwZS1zbHVnLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPlBhcGVyIFRvb2xzIGNvbnRhaW5zIG5ldyBhZGQtb25seSBVbHRyYSA4MCBjdXJzb3IgZWZmZWN0cy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0Q2F0ZWdvcnlQYWdlKCJ1ODAtcGFwZXItdG9vbHMiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"categories/u80-glyph-games.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+R2x5cGhzICZhbXA7IEdhbWVzIHwgQ29sZGJvb3QgQ3Vyc29yIExpYnJhcnk8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vaW5kZXguaHRtbCI+SG9tZTwvYT4KICAgICAgICA8YSBocmVmPSIjZWZmZWN0cyI+RWZmZWN0czwvYT4KICAgICAgICA8YSBocmVmPSIjY2F0ZWdvcmllcyI+Q2F0ZWdvcmllczwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LXN0cmlwIiBpZD0iY2F0ZWdvcmllcyI+CiAgICAgIDxkaXYgY2xhc3M9ImNhdGVnb3J5LWdyaWQiIGlkPSJjYXRlZ29yeUdyaWQiPjwvZGl2PgogICAgICA8YnV0dG9uIGNsYXNzPSJzZWUtbW9yZSIgaWQ9InNlZU1vcmVCdG4iIHR5cGU9ImJ1dHRvbiIgYXJpYS1leHBhbmRlZD0iZmFsc2UiPlNlZSBtb3JlPC9idXR0b24+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+dWx0cmEgODAgLyBjYXRlZ29yeTwvc3Bhbj4KICAgICAgICA8aDE+R2x5cGhzICZhbXA7IEdhbWVzPC9oMT4KICAgICAgICA8cD5HbHlwaHMsIHJ1bmVzLCBnYW1lIG1hcmtzIGFuZCBwbGF5ZnVsIHN5bWJvbGljIGVmZmVjdHMuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0cy1zdGFjayBzZWN0aW9uLWdhcCIgaWQ9ImVmZmVjdHMiPgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1nbHlwaC13aGVlbCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+R2x5cGhzICZhbXA7IEdhbWVzIC8gMDE8L3NwYW4+CiAgICAgICAgICA8aDI+R2x5cGggV2hlZWw8L2gyPgogICAgICAgICAgPHA+QSB3aGVlbCBvZiBnbHlwaHMgc3BpbnMgb3V0d2FyZC48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLWdseXBoLXdoZWVsLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtbW9yc2UtYmxpcHMiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPkdseXBocyAmYW1wOyBHYW1lcyAvIDAyPC9zcGFuPgogICAgICAgICAgPGgyPk1vcnNlIEJsaXBzPC9oMj4KICAgICAgICAgIDxwPk1vcnNlIGRvdC1kYXNoIG1hcmtzIGJsaW5rIGluIGEgbGluZS48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLW1vcnNlLWJsaXBzLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtYnJhaWxsZS1kb3RzIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5HbHlwaHMgJmFtcDsgR2FtZXMgLyAwMzwvc3Bhbj4KICAgICAgICAgIDxoMj5CcmFpbGxlIERvdHM8L2gyPgogICAgICAgICAgPHA+QnJhaWxsZS1zdHlsZSBkb3RzIGxpZnQgaW4gYSBzbWFsbCBncmlkLjwvcD4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwcmV2aWV3LW5vdGUiPk1vdmUgY3Vyc29yIGluc2lkZSBwcmV2aWV3PC9zcGFuPgogICAgICAgIDwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxhIGNsYXNzPSJzb3VyY2UtbGluayIgaHJlZj0iLi4vc291cmNlcy91ODAtYnJhaWxsZS1kb3RzLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtY2hlc3Mtc3RlcCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+R2x5cGhzICZhbXA7IEdhbWVzIC8gMDQ8L3NwYW4+CiAgICAgICAgICA8aDI+Q2hlc3MgU3RlcDwvaDI+CiAgICAgICAgICA8cD5BIGNoZXNzLXBpZWNlIHNpbGhvdWV0dGUgc3RlcHMgZGlhZ29uYWxseS48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLWNoZXNzLXN0ZXAuaHRtbCI+U2VlIHNvdXJjZSBjb2RlPC9hPgogICAgICA8L3NlY3Rpb24+CgogICAgICA8c2VjdGlvbiBjbGFzcz0iZWZmZWN0LWJveCIgZGF0YS1lZmZlY3Q9InU4MC1sb2NrLXNoYXJkcyI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+R2x5cGhzICZhbXA7IEdhbWVzIC8gMDU8L3NwYW4+CiAgICAgICAgICA8aDI+TG9jayBTaGFyZHM8L2gyPgogICAgICAgICAgPHA+QSB0aW55IGxvY2sgY3JhY2tzIGludG8gYW5ndWxhciBzaGFyZHMuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1sb2NrLXNoYXJkcy5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWtleS10dXJuIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5HbHlwaHMgJmFtcDsgR2FtZXMgLyAwNjwvc3Bhbj4KICAgICAgICAgIDxoMj5LZXkgVHVybjwvaDI+CiAgICAgICAgICA8cD5BIGtleSBzaGFwZSB0dXJucyBhbmQgcmVsZWFzZXMgc21hbGwgbWFya3MuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1rZXktdHVybi5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLWhvdXJnbGFzcy1mbGlwIj4KICAgICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICAgIDxkaXYgY2xhc3M9ImVmZmVjdC1jb250ZW50Ij4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5HbHlwaHMgJmFtcDsgR2FtZXMgLyAwNzwvc3Bhbj4KICAgICAgICAgIDxoMj5Ib3VyZ2xhc3MgRmxpcDwvaDI+CiAgICAgICAgICA8cD5BbiBob3VyZ2xhc3MgZmxpcHMgd2hpbGUgc2FuZCBkb3RzIGZhbGwuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1ob3VyZ2xhc3MtZmxpcC5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXBsYXlpbmctY2FyZCI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+R2x5cGhzICZhbXA7IEdhbWVzIC8gMDg8L3NwYW4+CiAgICAgICAgICA8aDI+UGxheWluZyBDYXJkPC9oMj4KICAgICAgICAgIDxwPkEgcGxheWluZyBjYXJkIGZsaXBzIGFuZCBsZWF2ZXMgc3VpdCBtYXJrcy48L3A+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icHJldmlldy1ub3RlIj5Nb3ZlIGN1cnNvciBpbnNpZGUgcHJldmlldzwvc3Bhbj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8YSBjbGFzcz0ic291cmNlLWxpbmsiIGhyZWY9Ii4uL3NvdXJjZXMvdTgwLXBsYXlpbmctY2FyZC5odG1sIj5TZWUgc291cmNlIGNvZGU8L2E+CiAgICAgIDwvc2VjdGlvbj4KCiAgICAgIDxzZWN0aW9uIGNsYXNzPSJlZmZlY3QtYm94IiBkYXRhLWVmZmVjdD0idTgwLXB1enpsZS1wb3AiPgogICAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0iZWZmZWN0LWNvbnRlbnQiPgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPkdseXBocyAmYW1wOyBHYW1lcyAvIDA5PC9zcGFuPgogICAgICAgICAgPGgyPlB1enpsZSBQb3A8L2gyPgogICAgICAgICAgPHA+UHV6emxlIHBpZWNlIHNoYXBlcyBwb3AgYXdheSBmcm9tIHRoZSBjdXJzb3IuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1wdXp6bGUtcG9wLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgICAgPHNlY3Rpb24gY2xhc3M9ImVmZmVjdC1ib3giIGRhdGEtZWZmZWN0PSJ1ODAtZGlhbC1jb21ibyI+CiAgICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgICA8ZGl2IGNsYXNzPSJlZmZlY3QtY29udGVudCI+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+R2x5cGhzICZhbXA7IEdhbWVzIC8gMTA8L3NwYW4+CiAgICAgICAgICA8aDI+RGlhbCBDb21ibzwvaDI+CiAgICAgICAgICA8cD5Db21iaW5hdGlvbiBkaWFsIHRpY2tzIHJvdGF0ZSBpbiBsYXllcnMuPC9wPgogICAgICAgICAgPHNwYW4gY2xhc3M9InByZXZpZXctbm90ZSI+TW92ZSBjdXJzb3IgaW5zaWRlIHByZXZpZXc8L3NwYW4+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgICAgPGEgY2xhc3M9InNvdXJjZS1saW5rIiBocmVmPSIuLi9zb3VyY2VzL3U4MC1kaWFsLWNvbWJvLmh0bWwiPlNlZSBzb3VyY2UgY29kZTwvYT4KICAgICAgPC9zZWN0aW9uPgoKICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPkdseXBocyAmYW1wOyBHYW1lcyBjb250YWlucyBuZXcgYWRkLW9ubHkgVWx0cmEgODAgY3Vyc29yIGVmZmVjdHMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdENhdGVnb3J5UGFnZSgidTgwLWdseXBoLWdhbWVzIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-caliper-snap.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Q2FsaXBlciBTbmFwIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtcHJlY2lzaW9uLWluc3RydW1lbnRzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlByZWNpc2lvbiBJbnN0cnVtZW50cyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+Q2FsaXBlciBTbmFwPC9oMT4KICAgICAgICA8cD5Ud28gbWVhc3VyaW5nIGphd3MgY2xvc2UgYW5kIHJlbGVhc2UgYXJvdW5kIHRoZSBwb2ludGVyLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1jYWxpcGVyLXNuYXAiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLWNhbGlwZXItc25hcCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtY2FsaXBlci1zbmFwJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1jYWxpcGVyLXNuYXAmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPkNhbGlwZXIgU25hcCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtY2FsaXBlci1zbmFwIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-protractor-sweep.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UHJvdHJhY3RvciBTd2VlcCB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLXByZWNpc2lvbi1pbnN0cnVtZW50cy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QcmVjaXNpb24gSW5zdHJ1bWVudHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPlByb3RyYWN0b3IgU3dlZXA8L2gxPgogICAgICAgIDxwPkEgaGFsZi1jaXJjbGUgcHJvdHJhY3RvciBzd2VlcCBkcmF3cyBhbmdsZSB0aWNrcy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtcHJvdHJhY3Rvci1zd2VlcCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtcHJvdHJhY3Rvci1zd2VlcCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtcHJvdHJhY3Rvci1zd2VlcCZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtcHJvdHJhY3Rvci1zd2VlcCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+UHJvdHJhY3RvciBTd2VlcCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtcHJvdHJhY3Rvci1zd2VlcCIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-magnifier-bloom.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TWFnbmlmaWVyIEJsb29tIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtcHJlY2lzaW9uLWluc3RydW1lbnRzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlByZWNpc2lvbiBJbnN0cnVtZW50cyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+TWFnbmlmaWVyIEJsb29tPC9oMT4KICAgICAgICA8cD5BIHNtYWxsIG1hZ25pZmllciByaW5nIGV4cGFuZHMgYW5kIGZvY3VzZXMgZHVzdC48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtbWFnbmlmaWVyLWJsb29tIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1tYWduaWZpZXItYmxvb20mcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLW1hZ25pZmllci1ibG9vbSZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtbWFnbmlmaWVyLWJsb29tJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5NYWduaWZpZXIgQmxvb20gaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLW1hZ25pZmllci1ibG9vbSIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-level-bubble.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TGV2ZWwgQnViYmxlIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtcHJlY2lzaW9uLWluc3RydW1lbnRzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlByZWNpc2lvbiBJbnN0cnVtZW50cyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+TGV2ZWwgQnViYmxlPC9oMT4KICAgICAgICA8cD5BIGJ1YmJsZSBsZXZlbCBjYXBzdWxlIHNsaWRlcyBhbmQgYmFsYW5jZXMuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWxldmVsLWJ1YmJsZSI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtbGV2ZWwtYnViYmxlJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1sZXZlbC1idWJibGUmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWxldmVsLWJ1YmJsZSYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+TGV2ZWwgQnViYmxlIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1sZXZlbC1idWJibGUiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-metronome-tick.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TWV0cm9ub21lIFRpY2sgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1wcmVjaXNpb24taW5zdHJ1bWVudHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+UHJlY2lzaW9uIEluc3RydW1lbnRzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5NZXRyb25vbWUgVGljazwvaDE+CiAgICAgICAgPHA+QSBtZXRyb25vbWUgbmVlZGxlIHN3aW5ncyB3aXRoIHRpbnkgYmFzZSB0aWNrcy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtbWV0cm9ub21lLXRpY2siPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLW1ldHJvbm9tZS10aWNrJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1tZXRyb25vbWUtdGljayZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtbWV0cm9ub21lLXRpY2smI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPk1ldHJvbm9tZSBUaWNrIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1tZXRyb25vbWUtdGljayIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-pendulum-arc.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UGVuZHVsdW0gQXJjIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtcHJlY2lzaW9uLWluc3RydW1lbnRzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlByZWNpc2lvbiBJbnN0cnVtZW50cyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+UGVuZHVsdW0gQXJjPC9oMT4KICAgICAgICA8cD5BIHBlbmR1bHVtIGJvYiBzd2luZ3MgdW5kZXIgYSB0aW55IGFuY2hvciBwb2ludC48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtcGVuZHVsdW0tYXJjIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1wZW5kdWx1bS1hcmMmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLXBlbmR1bHVtLWFyYyZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtcGVuZHVsdW0tYXJjJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5QZW5kdWx1bSBBcmMgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLXBlbmR1bHVtLWFyYyIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-ruler-crawl.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UnVsZXIgQ3Jhd2wgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1wcmVjaXNpb24taW5zdHJ1bWVudHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+UHJlY2lzaW9uIEluc3RydW1lbnRzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5SdWxlciBDcmF3bDwvaDE+CiAgICAgICAgPHA+TWVhc3VyZWQgcnVsZXIgdGlja3MgY3Jhd2wgb3V0d2FyZCBmcm9tIHRoZSBjdXJzb3IuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXJ1bGVyLWNyYXdsIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1ydWxlci1jcmF3bCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtcnVsZXItY3Jhd2wmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXJ1bGVyLWNyYXdsJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5SdWxlciBDcmF3bCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtcnVsZXItY3Jhd2wiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-barcode-wipe.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+QmFyY29kZSBXaXBlIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtcHJlY2lzaW9uLWluc3RydW1lbnRzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlByZWNpc2lvbiBJbnN0cnVtZW50cyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+QmFyY29kZSBXaXBlPC9oMT4KICAgICAgICA8cD5BIGJhcmNvZGUgc3RyaXAgd2lwZXMgYWNyb3NzIGFuZCBicmVha3MgYXBhcnQuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWJhcmNvZGUtd2lwZSI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtYmFyY29kZS13aXBlJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1iYXJjb2RlLXdpcGUmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWJhcmNvZGUtd2lwZSYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+QmFyY29kZSBXaXBlIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1iYXJjb2RlLXdpcGUiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-focus-reticle.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Rm9jdXMgUmV0aWNsZSB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLXByZWNpc2lvbi1pbnN0cnVtZW50cy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QcmVjaXNpb24gSW5zdHJ1bWVudHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkZvY3VzIFJldGljbGU8L2gxPgogICAgICAgIDxwPkNhbWVyYSBmb2N1cyBicmFja2V0cyB0aWdodGVuIHRoZW4gZmFkZS48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtZm9jdXMtcmV0aWNsZSI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtZm9jdXMtcmV0aWNsZSZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtZm9jdXMtcmV0aWNsZSZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtZm9jdXMtcmV0aWNsZSYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+Rm9jdXMgUmV0aWNsZSBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtZm9jdXMtcmV0aWNsZSIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-gauge-needle.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+R2F1Z2UgTmVlZGxlIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtcHJlY2lzaW9uLWluc3RydW1lbnRzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlByZWNpc2lvbiBJbnN0cnVtZW50cyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+R2F1Z2UgTmVlZGxlPC9oMT4KICAgICAgICA8cD5BIGdhdWdlIG5lZWRsZSBzbmFwcyBhY3Jvc3MgYSBtaW5pIGRpYWwuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWdhdWdlLW5lZWRsZSI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtZ2F1Z2UtbmVlZGxlJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1nYXVnZS1uZWVkbGUmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWdhdWdlLW5lZWRsZSYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+R2F1Z2UgTmVlZGxlIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1nYXVnZS1uZWVkbGUiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-rubber-band.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UnViYmVyIEJhbmQgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1raW5ldGljLW9iamVjdHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+S2luZXRpYyBPYmplY3RzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5SdWJiZXIgQmFuZDwvaDE+CiAgICAgICAgPHA+QW4gZWxhc3RpYyBsb29wIHN0cmV0Y2hlcyBiZWhpbmQgdGhlIGN1cnNvci48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtcnViYmVyLWJhbmQiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLXJ1YmJlci1iYW5kJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1ydWJiZXItYmFuZCZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtcnViYmVyLWJhbmQmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPlJ1YmJlciBCYW5kIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1ydWJiZXItYmFuZCIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-spring-coil.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+U3ByaW5nIENvaWwgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1raW5ldGljLW9iamVjdHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+S2luZXRpYyBPYmplY3RzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5TcHJpbmcgQ29pbDwvaDE+CiAgICAgICAgPHA+QSB0aW55IHNwcmluZyBjb2lsIGNvbXByZXNzZXMgYW5kIHJlbGVhc2VzLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1zcHJpbmctY29pbCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtc3ByaW5nLWNvaWwmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLXNwcmluZy1jb2lsJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1zcHJpbmctY29pbCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+U3ByaW5nIENvaWwgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLXNwcmluZy1jb2lsIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-chain-link.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Q2hhaW4gTGluayB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLWtpbmV0aWMtb2JqZWN0cy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5LaW5ldGljIE9iamVjdHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkNoYWluIExpbms8L2gxPgogICAgICAgIDxwPlNob3J0IGNoYWluIGxpbmtzIHNlcGFyYXRlIHdpdGggc3RhZ2dlcmVkIHRpbWluZy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtY2hhaW4tbGluayI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtY2hhaW4tbGluayZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtY2hhaW4tbGluayZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtY2hhaW4tbGluayYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+Q2hhaW4gTGluayBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtY2hhaW4tbGluayIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-piston-push.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UGlzdG9uIFB1c2ggfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1raW5ldGljLW9iamVjdHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+S2luZXRpYyBPYmplY3RzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5QaXN0b24gUHVzaDwvaDE+CiAgICAgICAgPHA+QSBwaXN0b24gc2hhZnQgcHVzaGVzIGZvcndhcmQgdGhlbiByZXRyYWN0cy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtcGlzdG9uLXB1c2giPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLXBpc3Rvbi1wdXNoJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1waXN0b24tcHVzaCZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtcGlzdG9uLXB1c2gmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPlBpc3RvbiBQdXNoIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1waXN0b24tcHVzaCIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-lever-snap.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TGV2ZXIgU25hcCB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLWtpbmV0aWMtb2JqZWN0cy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5LaW5ldGljIE9iamVjdHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkxldmVyIFNuYXA8L2gxPgogICAgICAgIDxwPkEgbGV2ZXIgYmFyIHBpdm90cyBxdWlja2x5IGZyb20gYSBoaW5nZS48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtbGV2ZXItc25hcCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtbGV2ZXItc25hcCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtbGV2ZXItc25hcCZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtbGV2ZXItc25hcCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+TGV2ZXIgU25hcCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtbGV2ZXItc25hcCIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-pulley-rope.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UHVsbGV5IFJvcGUgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1raW5ldGljLW9iamVjdHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+S2luZXRpYyBPYmplY3RzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5QdWxsZXkgUm9wZTwvaDE+CiAgICAgICAgPHA+QSByb3BlIGFyYyBhbmQgcHVsbGV5IGRvdCByb2xsIGF3YXkuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXB1bGxleS1yb3BlIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1wdWxsZXktcm9wZSZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtcHVsbGV5LXJvcGUmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXB1bGxleS1yb3BlJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5QdWxsZXkgUm9wZSBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtcHVsbGV5LXJvcGUiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-bearing-orbit.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+QmVhcmluZyBPcmJpdCB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLWtpbmV0aWMtb2JqZWN0cy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5LaW5ldGljIE9iamVjdHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkJlYXJpbmcgT3JiaXQ8L2gxPgogICAgICAgIDxwPkJhbGwgYmVhcmluZ3Mgb3JiaXQgdGhlbiBzY2F0dGVyIG91dHdhcmQuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWJlYXJpbmctb3JiaXQiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLWJlYXJpbmctb3JiaXQmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLWJlYXJpbmctb3JiaXQmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWJlYXJpbmctb3JiaXQmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPkJlYXJpbmcgT3JiaXQgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLWJlYXJpbmctb3JiaXQiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-bolt-scatter.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Qm9sdCBTY2F0dGVyIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAta2luZXRpYy1vYmplY3RzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPktpbmV0aWMgT2JqZWN0cyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+Qm9sdCBTY2F0dGVyPC9oMT4KICAgICAgICA8cD5TbWFsbCBib2x0IHNoYXBlcyB0dW1ibGUgYXdheSBmcm9tIHRoZSBjdXJzb3IuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWJvbHQtc2NhdHRlciI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtYm9sdC1zY2F0dGVyJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1ib2x0LXNjYXR0ZXImcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWJvbHQtc2NhdHRlciYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+Qm9sdCBTY2F0dGVyIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1ib2x0LXNjYXR0ZXIiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-domino-fall.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+RG9taW5vIEZhbGwgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1raW5ldGljLW9iamVjdHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+S2luZXRpYyBPYmplY3RzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5Eb21pbm8gRmFsbDwvaDE+CiAgICAgICAgPHA+VGlueSBkb21pbm8gdGlsZXMgZmFsbCBpbiBzZXF1ZW5jZS48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtZG9taW5vLWZhbGwiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLWRvbWluby1mYWxsJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1kb21pbm8tZmFsbCZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtZG9taW5vLWZhbGwmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPkRvbWlubyBGYWxsIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1kb21pbm8tZmFsbCIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-dice-tumble.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+RGljZSBUdW1ibGUgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1raW5ldGljLW9iamVjdHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+S2luZXRpYyBPYmplY3RzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5EaWNlIFR1bWJsZTwvaDE+CiAgICAgICAgPHA+U21hbGwgZGljZSBzcXVhcmVzIHR1bWJsZSBpbiBkaWZmZXJlbnQgYW5nbGVzLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1kaWNlLXR1bWJsZSI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtZGljZS10dW1ibGUmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLWRpY2UtdHVtYmxlJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1kaWNlLXR1bWJsZSYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+RGljZSBUdW1ibGUgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLWRpY2UtdHVtYmxlIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-tooltip-pop.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+VG9vbHRpcCBQb3AgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC11aS1taWNyby5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5VSSBNaWNybyBNb3Rpb24gLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPlRvb2x0aXAgUG9wPC9oMT4KICAgICAgICA8cD5BIHRpbnkgdG9vbHRpcCBidWJibGUgcG9wcyBhbmQgc2xpZGVzIGF3YXkuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXRvb2x0aXAtcG9wIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC10b29sdGlwLXBvcCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtdG9vbHRpcC1wb3AmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXRvb2x0aXAtcG9wJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5Ub29sdGlwIFBvcCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtdG9vbHRpcC1wb3AiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-dropdown-fold.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+RHJvcGRvd24gRm9sZCB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLXVpLW1pY3JvLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlVJIE1pY3JvIE1vdGlvbiAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+RHJvcGRvd24gRm9sZDwvaDE+CiAgICAgICAgPHA+U3RhY2tlZCBkcm9wZG93biBwYW5lbHMgdW5mb2xkIGRvd253YXJkLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1kcm9wZG93bi1mb2xkIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1kcm9wZG93bi1mb2xkJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1kcm9wZG93bi1mb2xkJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1kcm9wZG93bi1mb2xkJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5Ecm9wZG93biBGb2xkIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1kcm9wZG93bi1mb2xkIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-toggle-orbit.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+VG9nZ2xlIE9yYml0IHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtdWktbWljcm8uaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+VUkgTWljcm8gTW90aW9uIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5Ub2dnbGUgT3JiaXQ8L2gxPgogICAgICAgIDxwPkEgc3dpdGNoIGtub2Igb3JiaXRzIGFyb3VuZCBhIHNtYWxsIHBpbGwuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXRvZ2dsZS1vcmJpdCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtdG9nZ2xlLW9yYml0JnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC10b2dnbGUtb3JiaXQmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXRvZ2dsZS1vcmJpdCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+VG9nZ2xlIE9yYml0IGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC10b2dnbGUtb3JiaXQiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-progress-ticks.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UHJvZ3Jlc3MgVGlja3MgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC11aS1taWNyby5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5VSSBNaWNybyBNb3Rpb24gLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPlByb2dyZXNzIFRpY2tzPC9oMT4KICAgICAgICA8cD5Qcm9ncmVzcyB0aWNrcyBmaWxsIGFuZCBmbG9hdCBmcm9tIHRoZSBjdXJzb3IuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXByb2dyZXNzLXRpY2tzIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1wcm9ncmVzcy10aWNrcyZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtcHJvZ3Jlc3MtdGlja3MmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXByb2dyZXNzLXRpY2tzJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5Qcm9ncmVzcyBUaWNrcyBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtcHJvZ3Jlc3MtdGlja3MiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-command-palette.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Q29tbWFuZCBQYWxldHRlIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtdWktbWljcm8uaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+VUkgTWljcm8gTW90aW9uIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5Db21tYW5kIFBhbGV0dGU8L2gxPgogICAgICAgIDxwPkEgdGlueSBjb21tYW5kIHBhbGV0dGUgb3BlbnMgdGhlbiBmcmFnbWVudHMuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWNvbW1hbmQtcGFsZXR0ZSI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtY29tbWFuZC1wYWxldHRlJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1jb21tYW5kLXBhbGV0dGUmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWNvbW1hbmQtcGFsZXR0ZSYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+Q29tbWFuZCBQYWxldHRlIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1jb21tYW5kLXBhbGV0dGUiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-notification-badge.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Tm90aWZpY2F0aW9uIEJhZGdlIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtdWktbWljcm8uaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+VUkgTWljcm8gTW90aW9uIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5Ob3RpZmljYXRpb24gQmFkZ2U8L2gxPgogICAgICAgIDxwPkEgbm90aWZpY2F0aW9uIGJhZGdlIHBvcHMgd2l0aCB1bnJlYWQgZG90cy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtbm90aWZpY2F0aW9uLWJhZGdlIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1ub3RpZmljYXRpb24tYmFkZ2UmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLW5vdGlmaWNhdGlvbi1iYWRnZSZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtbm90aWZpY2F0aW9uLWJhZGdlJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5Ob3RpZmljYXRpb24gQmFkZ2UgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLW5vdGlmaWNhdGlvbi1iYWRnZSIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-drag-handle.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+RHJhZyBIYW5kbGUgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC11aS1taWNyby5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5VSSBNaWNybyBNb3Rpb24gLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkRyYWcgSGFuZGxlPC9oMT4KICAgICAgICA8cD5HcmlwIGRvdHMgc2xpZGUgbGlrZSBhIGRyYWdnYWJsZSBoYW5kbGUuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWRyYWctaGFuZGxlIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1kcmFnLWhhbmRsZSZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtZHJhZy1oYW5kbGUmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWRyYWctaGFuZGxlJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5EcmFnIEhhbmRsZSBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtZHJhZy1oYW5kbGUiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-resize-corners.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UmVzaXplIENvcm5lcnMgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC11aS1taWNyby5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5VSSBNaWNybyBNb3Rpb24gLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPlJlc2l6ZSBDb3JuZXJzPC9oMT4KICAgICAgICA8cD5SZXNpemUgaGFuZGxlcyBzaG9vdCBvdXQgZnJvbSBmb3VyIGNvcm5lcnMuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXJlc2l6ZS1jb3JuZXJzIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1yZXNpemUtY29ybmVycyZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtcmVzaXplLWNvcm5lcnMmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXJlc2l6ZS1jb3JuZXJzJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5SZXNpemUgQ29ybmVycyBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtcmVzaXplLWNvcm5lcnMiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-breadcrumb-trail.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+QnJlYWRjcnVtYiBUcmFpbCB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLXVpLW1pY3JvLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlVJIE1pY3JvIE1vdGlvbiAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+QnJlYWRjcnVtYiBUcmFpbDwvaDE+CiAgICAgICAgPHA+U21hbGwgYnJlYWRjcnVtYiBjaGlwcyBzdGVwIGJlaGluZCB0aGUgcG9pbnRlci48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtYnJlYWRjcnVtYi10cmFpbCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtYnJlYWRjcnVtYi10cmFpbCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtYnJlYWRjcnVtYi10cmFpbCZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtYnJlYWRjcnVtYi10cmFpbCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+QnJlYWRjcnVtYiBUcmFpbCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtYnJlYWRjcnVtYi10cmFpbCIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-window-dock.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+V2luZG93IERvY2sgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC11aS1taWNyby5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5VSSBNaWNybyBNb3Rpb24gLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPldpbmRvdyBEb2NrPC9oMT4KICAgICAgICA8cD5NaW5pIHdpbmRvdyBjYXJkcyBkb2NrIGFuZCBib3VuY2UgdXB3YXJkLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC13aW5kb3ctZG9jayI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtd2luZG93LWRvY2smcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLXdpbmRvdy1kb2NrJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC13aW5kb3ctZG9jayYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+V2luZG93IERvY2sgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLXdpbmRvdy1kb2NrIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-router-ping.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Um91dGVyIFBpbmcgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1uZXR3b3JrLXN5c3RlbXMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TmV0d29yayBTeXN0ZW1zIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5Sb3V0ZXIgUGluZzwvaDE+CiAgICAgICAgPHA+Um91dGVyIG5vZGVzIHBpbmcgb3V0d2FyZCB3aXRoIHNob3J0IHBhY2tldCBkb3RzLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1yb3V0ZXItcGluZyI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtcm91dGVyLXBpbmcmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLXJvdXRlci1waW5nJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1yb3V0ZXItcGluZyYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+Um91dGVyIFBpbmcgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLXJvdXRlci1waW5nIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-dns-pulse.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+RE5TIFB1bHNlIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtbmV0d29yay1zeXN0ZW1zLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk5ldHdvcmsgU3lzdGVtcyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+RE5TIFB1bHNlPC9oMT4KICAgICAgICA8cD5ETlMgbGFiZWwgZG90cyBwdWxzZSBhbmQgcmVzb2x2ZSBpbnRvIGEgbGluZS48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtZG5zLXB1bHNlIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1kbnMtcHVsc2UmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLWRucy1wdWxzZSZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtZG5zLXB1bHNlJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5ETlMgUHVsc2UgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLWRucy1wdWxzZSIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-firewall-sparks.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+RmlyZXdhbGwgU3BhcmtzIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtbmV0d29yay1zeXN0ZW1zLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk5ldHdvcmsgU3lzdGVtcyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+RmlyZXdhbGwgU3BhcmtzPC9oMT4KICAgICAgICA8cD5BIHRpbnkgd2FsbCBibG9ja3MgYW5kIHRocm93cyBzcGFya3MgYXNpZGUuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWZpcmV3YWxsLXNwYXJrcyI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtZmlyZXdhbGwtc3BhcmtzJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1maXJld2FsbC1zcGFya3MmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWZpcmV3YWxsLXNwYXJrcyYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+RmlyZXdhbGwgU3BhcmtzIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1maXJld2FsbC1zcGFya3MiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-database-rings.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+RGF0YWJhc2UgUmluZ3MgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1uZXR3b3JrLXN5c3RlbXMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TmV0d29yayBTeXN0ZW1zIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5EYXRhYmFzZSBSaW5nczwvaDE+CiAgICAgICAgPHA+RGF0YWJhc2UgY3lsaW5kZXIgcmluZ3MgbGlmdCB1cHdhcmQuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWRhdGFiYXNlLXJpbmdzIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1kYXRhYmFzZS1yaW5ncyZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtZGF0YWJhc2UtcmluZ3MmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWRhdGFiYXNlLXJpbmdzJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5EYXRhYmFzZSBSaW5ncyBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtZGF0YWJhc2UtcmluZ3MiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-api-braces.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+QVBJIEJyYWNlcyB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW5ldHdvcmstc3lzdGVtcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5OZXR3b3JrIFN5c3RlbXMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkFQSSBCcmFjZXM8L2gxPgogICAgICAgIDxwPkN1cmx5IEFQSSBicmFjZXMgc25hcCBvcGVuIGFyb3VuZCB0aGUgY3Vyc29yLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1hcGktYnJhY2VzIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1hcGktYnJhY2VzJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1hcGktYnJhY2VzJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1hcGktYnJhY2VzJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5BUEkgQnJhY2VzIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1hcGktYnJhY2VzIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-packet-ladder.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UGFja2V0IExhZGRlciB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW5ldHdvcmstc3lzdGVtcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5OZXR3b3JrIFN5c3RlbXMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPlBhY2tldCBMYWRkZXI8L2gxPgogICAgICAgIDxwPlBhY2tldHMgaG9wIHRocm91Z2ggYSBzdGVwcGVkIGxhZGRlciBwYXRoLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1wYWNrZXQtbGFkZGVyIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1wYWNrZXQtbGFkZGVyJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1wYWNrZXQtbGFkZGVyJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1wYWNrZXQtbGFkZGVyJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5QYWNrZXQgTGFkZGVyIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1wYWNrZXQtbGFkZGVyIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-server-rack.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+U2VydmVyIFJhY2sgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1uZXR3b3JrLXN5c3RlbXMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TmV0d29yayBTeXN0ZW1zIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5TZXJ2ZXIgUmFjazwvaDE+CiAgICAgICAgPHA+U2VydmVyIHJhY2sgc2xvdHMgYmxpbmsgYW5kIHNsaWRlIGF3YXkuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXNlcnZlci1yYWNrIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1zZXJ2ZXItcmFjayZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtc2VydmVyLXJhY2smcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXNlcnZlci1yYWNrJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5TZXJ2ZXIgUmFjayBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtc2VydmVyLXJhY2siKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-webhook-hook.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+V2ViaG9vayBIb29rIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtbmV0d29yay1zeXN0ZW1zLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk5ldHdvcmsgU3lzdGVtcyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+V2ViaG9vayBIb29rPC9oMT4KICAgICAgICA8cD5BIHNtYWxsIGhvb2sgY2F0Y2hlcyBhbmQgcmVsZWFzZXMgYSBwYWNrZXQuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXdlYmhvb2staG9vayI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtd2ViaG9vay1ob29rJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC13ZWJob29rLWhvb2smcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXdlYmhvb2staG9vayYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+V2ViaG9vayBIb29rIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC13ZWJob29rLWhvb2siKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-circuit-branch.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Q2lyY3VpdCBCcmFuY2ggfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1uZXR3b3JrLXN5c3RlbXMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TmV0d29yayBTeXN0ZW1zIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5DaXJjdWl0IEJyYW5jaDwvaDE+CiAgICAgICAgPHA+Q2lyY3VpdCBicmFuY2hlcyBncm93IGZyb20gYSBjZW50cmFsIGNoaXAuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWNpcmN1aXQtYnJhbmNoIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1jaXJjdWl0LWJyYW5jaCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtY2lyY3VpdC1icmFuY2gmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWNpcmN1aXQtYnJhbmNoJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5DaXJjdWl0IEJyYW5jaCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtY2lyY3VpdC1icmFuY2giKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-qr-pixels.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UVIgUGl4ZWxzIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtbmV0d29yay1zeXN0ZW1zLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk5ldHdvcmsgU3lzdGVtcyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+UVIgUGl4ZWxzPC9oMT4KICAgICAgICA8cD5RUi1saWtlIHBpeGVsIGJsb2NrcyBhc3NlbWJsZSBhbmQgc2NhdHRlci48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtcXItcGl4ZWxzIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1xci1waXhlbHMmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLXFyLXBpeGVscyZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtcXItcGl4ZWxzJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5RUiBQaXhlbHMgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLXFyLXBpeGVscyIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-gel-squish.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+R2VsIFNxdWlzaCB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW1hdGVyaWFsLWZpZWxkcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXRlcmlhbCBGaWVsZHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkdlbCBTcXVpc2g8L2gxPgogICAgICAgIDxwPkEgc29mdCBnZWwgYmxvYiBzcXVhc2hlcyBhbmQgcmVib3VuZHMuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWdlbC1zcXVpc2giPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLWdlbC1zcXVpc2gmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLWdlbC1zcXVpc2gmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWdlbC1zcXVpc2gmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPkdlbCBTcXVpc2ggaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLWdlbC1zcXVpc2giKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-wax-drip.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+V2F4IERyaXAgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1tYXRlcmlhbC1maWVsZHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWF0ZXJpYWwgRmllbGRzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5XYXggRHJpcDwvaDE+CiAgICAgICAgPHA+Um91bmRlZCB3YXggZHJvcHMgc3RyZXRjaCBkb3dud2FyZCBzbG93bHkuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXdheC1kcmlwIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC13YXgtZHJpcCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtd2F4LWRyaXAmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXdheC1kcmlwJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5XYXggRHJpcCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtd2F4LWRyaXAiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-bubble-column.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+QnViYmxlIENvbHVtbiB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW1hdGVyaWFsLWZpZWxkcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXRlcmlhbCBGaWVsZHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkJ1YmJsZSBDb2x1bW48L2gxPgogICAgICAgIDxwPkJ1YmJsZXMgcmlzZSBpbiBhIHRoaW4gdmVydGljYWwgY29sdW1uLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1idWJibGUtY29sdW1uIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1idWJibGUtY29sdW1uJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1idWJibGUtY29sdW1uJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1idWJibGUtY29sdW1uJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5CdWJibGUgQ29sdW1uIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1idWJibGUtY29sdW1uIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-foam-pop.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Rm9hbSBQb3AgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1tYXRlcmlhbC1maWVsZHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWF0ZXJpYWwgRmllbGRzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5Gb2FtIFBvcDwvaDE+CiAgICAgICAgPHA+Rm9hbSBjaXJjbGVzIHBvcCBhdCBkaWZmZXJlbnQgc2l6ZXMuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWZvYW0tcG9wIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1mb2FtLXBvcCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtZm9hbS1wb3AmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWZvYW0tcG9wJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5Gb2FtIFBvcCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtZm9hbS1wb3AiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-thread-needle.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+VGhyZWFkIE5lZWRsZSB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW1hdGVyaWFsLWZpZWxkcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXRlcmlhbCBGaWVsZHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPlRocmVhZCBOZWVkbGU8L2gxPgogICAgICAgIDxwPkEgbmVlZGxlIGxpbmUgcHVsbHMgYSBzb2Z0IHRocmVhZCBiZWhpbmQgaXQuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXRocmVhZC1uZWVkbGUiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLXRocmVhZC1uZWVkbGUmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLXRocmVhZC1uZWVkbGUmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXRocmVhZC1uZWVkbGUmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPlRocmVhZCBOZWVkbGUgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLXRocmVhZC1uZWVkbGUiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-cloth-rip.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Q2xvdGggUmlwIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtbWF0ZXJpYWwtZmllbGRzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hdGVyaWFsIEZpZWxkcyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+Q2xvdGggUmlwPC9oMT4KICAgICAgICA8cD5GcmF5ZWQgY2xvdGggZmliZXJzIHB1bGwgYXBhcnQgc2lkZXdheXMuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWNsb3RoLXJpcCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtY2xvdGgtcmlwJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1jbG90aC1yaXAmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWNsb3RoLXJpcCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+Q2xvdGggUmlwIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1jbG90aC1yaXAiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-stone-skip.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+U3RvbmUgU2tpcCB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW1hdGVyaWFsLWZpZWxkcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXRlcmlhbCBGaWVsZHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPlN0b25lIFNraXA8L2gxPgogICAgICAgIDxwPlNtYWxsIHN0b25lcyBza2lwIHdpdGggZ3Jhdml0eSBhbmQgYm91bmNlLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1zdG9uZS1za2lwIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1zdG9uZS1za2lwJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1zdG9uZS1za2lwJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1zdG9uZS1za2lwJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5TdG9uZSBTa2lwIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1zdG9uZS1za2lwIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-metal-filings.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TWV0YWwgRmlsaW5ncyB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW1hdGVyaWFsLWZpZWxkcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXRlcmlhbCBGaWVsZHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPk1ldGFsIEZpbGluZ3M8L2gxPgogICAgICAgIDxwPk1ldGFsIGZpbGluZ3MgYWxpZ24gdG93YXJkIGFuIGludmlzaWJsZSBtYWduZXQuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLW1ldGFsLWZpbGluZ3MiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLW1ldGFsLWZpbGluZ3MmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLW1ldGFsLWZpbGluZ3MmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLW1ldGFsLWZpbGluZ3MmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPk1ldGFsIEZpbGluZ3MgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLW1ldGFsLWZpbGluZ3MiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-crystal-crack.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Q3J5c3RhbCBDcmFjayB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW1hdGVyaWFsLWZpZWxkcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXRlcmlhbCBGaWVsZHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkNyeXN0YWwgQ3JhY2s8L2gxPgogICAgICAgIDxwPkNyeXN0YWwgY3JhY2tzIGdyb3cgaW4gYW5ndWxhciBicmFuY2hlcy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtY3J5c3RhbC1jcmFjayI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtY3J5c3RhbC1jcmFjayZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtY3J5c3RhbC1jcmFjayZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtY3J5c3RhbC1jcmFjayYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+Q3J5c3RhbCBDcmFjayBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtY3J5c3RhbC1jcmFjayIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-crumb-fall.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Q3J1bWIgRmFsbCB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW1hdGVyaWFsLWZpZWxkcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXRlcmlhbCBGaWVsZHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkNydW1iIEZhbGw8L2gxPgogICAgICAgIDxwPlRpbnkgY3J1bWJzIGZhbGwgYW5kIHJvdGF0ZSB3aXRoIHdlaWdodC48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtY3J1bWItZmFsbCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtY3J1bWItZmFsbCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtY3J1bWItZmFsbCZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtY3J1bWItZmFsbCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+Q3J1bWIgRmFsbCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtY3J1bWItZmFsbCIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-map-ping.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TWFwIFBpbmcgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1tYXAtbmF2aWdhdGlvbi5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXAgJmFtcDsgTmF2aWdhdGlvbiAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+TWFwIFBpbmc8L2gxPgogICAgICAgIDxwPkEgbWFwIHBpbiBkcm9wcyB3aXRoIGEgY2lyY3VsYXIgcGluZy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtbWFwLXBpbmciPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLW1hcC1waW5nJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1tYXAtcGluZyZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtbWFwLXBpbmcmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPk1hcCBQaW5nIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1tYXAtcGluZyIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-route-dashes.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Um91dGUgRGFzaGVzIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtbWFwLW5hdmlnYXRpb24uaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWFwICZhbXA7IE5hdmlnYXRpb24gLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPlJvdXRlIERhc2hlczwvaDE+CiAgICAgICAgPHA+Um91dGUgZGFzaGVzIHRyYXZlbCBhbG9uZyBhIGN1cnZlZCBwYXRoLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1yb3V0ZS1kYXNoZXMiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLXJvdXRlLWRhc2hlcyZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtcm91dGUtZGFzaGVzJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1yb3V0ZS1kYXNoZXMmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPlJvdXRlIERhc2hlcyBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtcm91dGUtZGFzaGVzIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-waypoint-chain.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+V2F5cG9pbnQgQ2hhaW4gfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1tYXAtbmF2aWdhdGlvbi5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXAgJmFtcDsgTmF2aWdhdGlvbiAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+V2F5cG9pbnQgQ2hhaW48L2gxPgogICAgICAgIDxwPldheXBvaW50IGRvdHMgbGluayBhbmQgYnJlYWsgYXBhcnQuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXdheXBvaW50LWNoYWluIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC13YXlwb2ludC1jaGFpbiZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtd2F5cG9pbnQtY2hhaW4mcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXdheXBvaW50LWNoYWluJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5XYXlwb2ludCBDaGFpbiBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtd2F5cG9pbnQtY2hhaW4iKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-radar-sweep.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UmFkYXIgU3dlZXAgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1tYXAtbmF2aWdhdGlvbi5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXAgJmFtcDsgTmF2aWdhdGlvbiAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+UmFkYXIgU3dlZXA8L2gxPgogICAgICAgIDxwPkEgcmFkYXIgd2VkZ2Ugc3dlZXBzIHRocm91Z2ggYSBjaXJjbGUuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXJhZGFyLXN3ZWVwIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1yYWRhci1zd2VlcCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtcmFkYXItc3dlZXAmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXJhZGFyLXN3ZWVwJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5SYWRhciBTd2VlcCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtcmFkYXItc3dlZXAiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-compass-rose.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Q29tcGFzcyBSb3NlIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtbWFwLW5hdmlnYXRpb24uaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWFwICZhbXA7IE5hdmlnYXRpb24gLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkNvbXBhc3MgUm9zZTwvaDE+CiAgICAgICAgPHA+Q29tcGFzcyByb3NlIHRpY2tzIG9wZW4gaW4gZWlnaHQgZGlyZWN0aW9ucy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtY29tcGFzcy1yb3NlIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1jb21wYXNzLXJvc2UmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLWNvbXBhc3Mtcm9zZSZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtY29tcGFzcy1yb3NlJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5Db21wYXNzIFJvc2UgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLWNvbXBhc3Mtcm9zZSIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-coordinate-pop.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Q29vcmRpbmF0ZSBQb3AgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1tYXAtbmF2aWdhdGlvbi5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5NYXAgJmFtcDsgTmF2aWdhdGlvbiAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+Q29vcmRpbmF0ZSBQb3A8L2gxPgogICAgICAgIDxwPkNvb3JkaW5hdGUgbnVtYmVycyBwb3AgYW5kIGRyaWZ0IHVwd2FyZC48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtY29vcmRpbmF0ZS1wb3AiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLWNvb3JkaW5hdGUtcG9wJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1jb29yZGluYXRlLXBvcCZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtY29vcmRpbmF0ZS1wb3AmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPkNvb3JkaW5hdGUgUG9wIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1jb29yZGluYXRlLXBvcCIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-location-beam.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TG9jYXRpb24gQmVhbSB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW1hcC1uYXZpZ2F0aW9uLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hcCAmYW1wOyBOYXZpZ2F0aW9uIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5Mb2NhdGlvbiBCZWFtPC9oMT4KICAgICAgICA8cD5BIGxvY2F0aW9uIGJlYW0gc2hvb3RzIHVwd2FyZCBmcm9tIHRoZSBjdXJzb3IuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWxvY2F0aW9uLWJlYW0iPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLWxvY2F0aW9uLWJlYW0mcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLWxvY2F0aW9uLWJlYW0mcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWxvY2F0aW9uLWJlYW0mI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPkxvY2F0aW9uIEJlYW0gaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLWxvY2F0aW9uLWJlYW0iKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-topography-lines.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+VG9wb2dyYXBoeSBMaW5lcyB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW1hcC1uYXZpZ2F0aW9uLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hcCAmYW1wOyBOYXZpZ2F0aW9uIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5Ub3BvZ3JhcGh5IExpbmVzPC9oMT4KICAgICAgICA8cD5Db250b3VyIGxpbmVzIHJpcHBsZSBvdXR3YXJkIHVuZXZlbmx5LjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC10b3BvZ3JhcGh5LWxpbmVzIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC10b3BvZ3JhcGh5LWxpbmVzJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC10b3BvZ3JhcGh5LWxpbmVzJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC10b3BvZ3JhcGh5LWxpbmVzJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5Ub3BvZ3JhcGh5IExpbmVzIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC10b3BvZ3JhcGh5LWxpbmVzIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-grid-locator.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+R3JpZCBMb2NhdG9yIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtbWFwLW5hdmlnYXRpb24uaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+TWFwICZhbXA7IE5hdmlnYXRpb24gLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkdyaWQgTG9jYXRvcjwvaDE+CiAgICAgICAgPHA+TG9jYXRvciBncmlkIGNlbGxzIGZsYXNoIGFuZCB2YW5pc2guPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWdyaWQtbG9jYXRvciI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtZ3JpZC1sb2NhdG9yJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1ncmlkLWxvY2F0b3ImcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWdyaWQtbG9jYXRvciYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+R3JpZCBMb2NhdG9yIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1ncmlkLWxvY2F0b3IiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-nav-arrow.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TmF2aWdhdGlvbiBBcnJvdyB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLW1hcC1uYXZpZ2F0aW9uLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPk1hcCAmYW1wOyBOYXZpZ2F0aW9uIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5OYXZpZ2F0aW9uIEFycm93PC9oMT4KICAgICAgICA8cD5BIG5hdmlnYXRpb24gYXJyb3cgZ2xpZGVzIGFuZCBzcGxpdHMgaW50byB0aWNrcy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtbmF2LWFycm93Ij4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1uYXYtYXJyb3cmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLW5hdi1hcnJvdyZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtbmF2LWFycm93JiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5OYXZpZ2F0aW9uIEFycm93IGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1uYXYtYXJyb3ciKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-origami-fold.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+T3JpZ2FtaSBGb2xkIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtcGFwZXItdG9vbHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+UGFwZXIgVG9vbHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPk9yaWdhbWkgRm9sZDwvaDE+CiAgICAgICAgPHA+UGFwZXIgdHJpYW5nbGVzIGZvbGQgb3BlbiBsaWtlIG9yaWdhbWkuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLW9yaWdhbWktZm9sZCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtb3JpZ2FtaS1mb2xkJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1vcmlnYW1pLWZvbGQmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLW9yaWdhbWktZm9sZCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+T3JpZ2FtaSBGb2xkIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1vcmlnYW1pLWZvbGQiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-envelope-tear.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+RW52ZWxvcGUgVGVhciB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLXBhcGVyLXRvb2xzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlBhcGVyIFRvb2xzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5FbnZlbG9wZSBUZWFyPC9oMT4KICAgICAgICA8cD5FbnZlbG9wZSBmbGFwIHRlYXJzIGludG8gc21hbGwgcGFwZXIgcGllY2VzLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1lbnZlbG9wZS10ZWFyIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1lbnZlbG9wZS10ZWFyJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1lbnZlbG9wZS10ZWFyJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1lbnZlbG9wZS10ZWFyJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5FbnZlbG9wZSBUZWFyIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1lbnZlbG9wZS10ZWFyIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-ticket-punch.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+VGlja2V0IFB1bmNoIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtcGFwZXItdG9vbHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+UGFwZXIgVG9vbHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPlRpY2tldCBQdW5jaDwvaDE+CiAgICAgICAgPHA+QSB0aWNrZXQgcmVjdGFuZ2xlIHB1bmNoZXMgb3V0IHRpbnkgaG9sZXMuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXRpY2tldC1wdW5jaCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtdGlja2V0LXB1bmNoJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC10aWNrZXQtcHVuY2gmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXRpY2tldC1wdW5jaCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+VGlja2V0IFB1bmNoIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC10aWNrZXQtcHVuY2giKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-paperclip-loop.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UGFwZXJjbGlwIExvb3AgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1wYXBlci10b29scy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QYXBlciBUb29scyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+UGFwZXJjbGlwIExvb3A8L2gxPgogICAgICAgIDxwPkEgcGFwZXJjbGlwIHNoYXBlIGxvb3BzIGFuZCBzcHJpbmdzIGF3YXkuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXBhcGVyY2xpcC1sb29wIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1wYXBlcmNsaXAtbG9vcCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtcGFwZXJjbGlwLWxvb3AmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXBhcGVyY2xpcC1sb29wJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5QYXBlcmNsaXAgTG9vcCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtcGFwZXJjbGlwLWxvb3AiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-bookmark-flip.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Qm9va21hcmsgRmxpcCB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLXBhcGVyLXRvb2xzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlBhcGVyIFRvb2xzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5Cb29rbWFyayBGbGlwPC9oMT4KICAgICAgICA8cD5BIGJvb2ttYXJrIHJpYmJvbiBmbGlwcyBkb3dud2FyZC48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtYm9va21hcmstZmxpcCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtYm9va21hcmstZmxpcCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtYm9va21hcmstZmxpcCZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtYm9va21hcmstZmxpcCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+Qm9va21hcmsgRmxpcCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtYm9va21hcmstZmxpcCIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-scissor-snip.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+U2Npc3NvciBTbmlwIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtcGFwZXItdG9vbHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+UGFwZXIgVG9vbHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPlNjaXNzb3IgU25pcDwvaDE+CiAgICAgICAgPHA+VHdvIHNjaXNzb3IgYmxhZGVzIHNuaXAgYW5kIGZseSBhd2F5LjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1zY2lzc29yLXNuaXAiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLXNjaXNzb3Itc25pcCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtc2Npc3Nvci1zbmlwJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1zY2lzc29yLXNuaXAmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPlNjaXNzb3IgU25pcCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtc2Npc3Nvci1zbmlwIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-wax-seal.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+V2F4IFNlYWwgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1wYXBlci10b29scy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QYXBlciBUb29scyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+V2F4IFNlYWw8L2gxPgogICAgICAgIDxwPkEgd2F4IHNlYWwgc3RhbXAgZXhwYW5kcyBhbmQgY3JhY2tzLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC13YXgtc2VhbCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtd2F4LXNlYWwmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLXdheC1zZWFsJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC13YXgtc2VhbCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+V2F4IFNlYWwgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLXdheC1zZWFsIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-pinwheel-spin.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UGlud2hlZWwgU3BpbiB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLXBhcGVyLXRvb2xzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPlBhcGVyIFRvb2xzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5QaW53aGVlbCBTcGluPC9oMT4KICAgICAgICA8cD5BIHRpbnkgcGlud2hlZWwgcm90YXRlcyBhbmQgZHJpZnRzLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1waW53aGVlbC1zcGluIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1waW53aGVlbC1zcGluJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1waW53aGVlbC1zcGluJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1waW53aGVlbC1zcGluJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5QaW53aGVlbCBTcGluIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1waW53aGVlbC1zcGluIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-scroll-curl.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+U2Nyb2xsIEN1cmwgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1wYXBlci10b29scy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5QYXBlciBUb29scyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+U2Nyb2xsIEN1cmw8L2gxPgogICAgICAgIDxwPkEgc21hbGwgc2Nyb2xsIGN1cmwgb3BlbnMgYW5kIHJvbGxzIGF3YXkuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXNjcm9sbC1jdXJsIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1zY3JvbGwtY3VybCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtc2Nyb2xsLWN1cmwmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXNjcm9sbC1jdXJsJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5TY3JvbGwgQ3VybCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtc2Nyb2xsLWN1cmwiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-type-slug.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+VHlwZSBTbHVnIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtcGFwZXItdG9vbHMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+UGFwZXIgVG9vbHMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPlR5cGUgU2x1ZzwvaDE+CiAgICAgICAgPHA+VHlwZXdyaXRlciBzbHVnIGJsb2NrcyBzdHJpa2UgYW5kIGZhZGUuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXR5cGUtc2x1ZyI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtdHlwZS1zbHVnJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC10eXBlLXNsdWcmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXR5cGUtc2x1ZyYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+VHlwZSBTbHVnIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC10eXBlLXNsdWciKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-glyph-wheel.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+R2x5cGggV2hlZWwgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1nbHlwaC1nYW1lcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5HbHlwaHMgJmFtcDsgR2FtZXMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkdseXBoIFdoZWVsPC9oMT4KICAgICAgICA8cD5BIHdoZWVsIG9mIGdseXBocyBzcGlucyBvdXR3YXJkLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1nbHlwaC13aGVlbCI+CiAgICAgIDxkaXYgY2xhc3M9ImZ4LWxheWVyIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICAgIDxkaXYgY2xhc3M9InByZXZpZXctem9uZSIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjb2RlLWNhcmQgc2VjdGlvbi1nYXAiIGlkPSJjb2RlIj4KICAgICAgPGRpdiBjbGFzcz0iY29kZS1oZWFkIj4KICAgICAgICA8ZGl2PgogICAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPmNvcHkgc291cmNlPC9zcGFuPgogICAgICAgICAgPGgyPlVzZSB0aGlzIGVmZmVjdDwvaDI+CiAgICAgICAgPC9kaXY+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29weS1idG4iIGlkPSJjb3B5QWxsIiB0eXBlPSJidXR0b24iPkNvcHkgYWxsPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPGRpdiBjbGFzcz0iY29kZS10YWJzIj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiBhY3RpdmUiIGRhdGEtdGFiPSJodG1sIiB0eXBlPSJidXR0b24iPkhUTUw8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImNzcyIgdHlwZT0iYnV0dG9uIj5DU1M8L2J1dHRvbj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb2RlLXRhYiIgZGF0YS10YWI9ImpzIiB0eXBlPSJidXR0b24iPkpTPC9idXR0b24+CiAgICAgIDwvZGl2PgoKICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9Imh0bWwiPjxjb2RlPiZsdDtzZWN0aW9uIGNsYXNzPSZxdW90O2N1cnNvci1kZW1vJnF1b3Q7IGRhdGEtY3Vyc29yLWVmZmVjdD0mcXVvdDt1ODAtZ2x5cGgtd2hlZWwmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLWdseXBoLXdoZWVsJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1nbHlwaC13aGVlbCYjeDI3O10mcXVvdDspOwpjb25zdCBsYXllciA9IHRhcmdldC5xdWVyeVNlbGVjdG9yKCZxdW90Oy5meC1sYXllciZxdW90Oyk7Cgp0YXJnZXQuYWRkRXZlbnRMaXN0ZW5lcigmcXVvdDtwb2ludGVybW92ZSZxdW90OywgKGV2ZW50KSA9Jmd0OyB7CiAgY29uc3QgcmVjdCA9IGxheWVyLmdldEJvdW5kaW5nQ2xpZW50UmVjdCgpOwogIENPTERfRlguc3Bhd24oZWZmZWN0LCBsYXllciwgZXZlbnQuY2xpZW50WCAtIHJlY3QubGVmdCwgZXZlbnQuY2xpZW50WSAtIHJlY3QudG9wKTsKfSk7PC9jb2RlPjwvcHJlPgogICAgPC9zZWN0aW9uPgoKICAgIDxmb290ZXI+R2x5cGggV2hlZWwgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLWdseXBoLXdoZWVsIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="},{"path":"sources/u80-morse-blips.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TW9yc2UgQmxpcHMgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1nbHlwaC1nYW1lcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5HbHlwaHMgJmFtcDsgR2FtZXMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPk1vcnNlIEJsaXBzPC9oMT4KICAgICAgICA8cD5Nb3JzZSBkb3QtZGFzaCBtYXJrcyBibGluayBpbiBhIGxpbmUuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLW1vcnNlLWJsaXBzIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1tb3JzZS1ibGlwcyZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtbW9yc2UtYmxpcHMmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLW1vcnNlLWJsaXBzJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5Nb3JzZSBCbGlwcyBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtbW9yc2UtYmxpcHMiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-braille-dots.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+QnJhaWxsZSBEb3RzIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtZ2x5cGgtZ2FtZXMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+R2x5cGhzICZhbXA7IEdhbWVzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5CcmFpbGxlIERvdHM8L2gxPgogICAgICAgIDxwPkJyYWlsbGUtc3R5bGUgZG90cyBsaWZ0IGluIGEgc21hbGwgZ3JpZC48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtYnJhaWxsZS1kb3RzIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1icmFpbGxlLWRvdHMmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLWJyYWlsbGUtZG90cyZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtYnJhaWxsZS1kb3RzJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5CcmFpbGxlIERvdHMgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLWJyYWlsbGUtZG90cyIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-chess-step.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+Q2hlc3MgU3RlcCB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLWdseXBoLWdhbWVzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPkdseXBocyAmYW1wOyBHYW1lcyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+Q2hlc3MgU3RlcDwvaDE+CiAgICAgICAgPHA+QSBjaGVzcy1waWVjZSBzaWxob3VldHRlIHN0ZXBzIGRpYWdvbmFsbHkuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWNoZXNzLXN0ZXAiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLWNoZXNzLXN0ZXAmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLWNoZXNzLXN0ZXAmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWNoZXNzLXN0ZXAmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPkNoZXNzIFN0ZXAgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLWNoZXNzLXN0ZXAiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-lock-shards.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+TG9jayBTaGFyZHMgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1nbHlwaC1nYW1lcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5HbHlwaHMgJmFtcDsgR2FtZXMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkxvY2sgU2hhcmRzPC9oMT4KICAgICAgICA8cD5BIHRpbnkgbG9jayBjcmFja3MgaW50byBhbmd1bGFyIHNoYXJkcy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtbG9jay1zaGFyZHMiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLWxvY2stc2hhcmRzJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1sb2NrLXNoYXJkcyZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtbG9jay1zaGFyZHMmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPkxvY2sgU2hhcmRzIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1sb2NrLXNoYXJkcyIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-key-turn.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+S2V5IFR1cm4gfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1nbHlwaC1nYW1lcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5HbHlwaHMgJmFtcDsgR2FtZXMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPktleSBUdXJuPC9oMT4KICAgICAgICA8cD5BIGtleSBzaGFwZSB0dXJucyBhbmQgcmVsZWFzZXMgc21hbGwgbWFya3MuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWtleS10dXJuIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1rZXktdHVybiZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAta2V5LXR1cm4mcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWtleS10dXJuJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5LZXkgVHVybiBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAta2V5LXR1cm4iKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-hourglass-flip.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+SG91cmdsYXNzIEZsaXAgfCBTb3VyY2UgQ29kZTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSIuLi9hc3NldHMvc3R5bGUuY3NzIj4KPC9oZWFkPgo8Ym9keT4KICA8ZGl2IGNsYXNzPSJzaGVsbCI+CiAgICA8aGVhZGVyIGNsYXNzPSJuYXYiPgogICAgICA8YSBjbGFzcz0iYnJhbmQiIGhyZWY9Ii4uL2luZGV4Lmh0bWwiPjxzcGFuIGNsYXNzPSJicmFuZC1kb3QiPjwvc3Bhbj5Db2xkYm9vdDwvYT4KICAgICAgPG5hdiBjbGFzcz0ibmF2LWxpbmtzIj4KICAgICAgICA8YSBocmVmPSIuLi9jYXRlZ29yaWVzL3U4MC1nbHlwaC1nYW1lcy5odG1sIj5CYWNrPC9hPgogICAgICAgIDxhIGhyZWY9IiNwcmV2aWV3Ij5QcmV2aWV3PC9hPgogICAgICAgIDxhIGhyZWY9IiNjb2RlIj5Db2RlPC9hPgogICAgICAgIDxidXR0b24gY2xhc3M9InRoZW1lLXRvZ2dsZSIgZGF0YS10aGVtZS10b2dnbGUgdHlwZT0iYnV0dG9uIiBhcmlhLWxhYmVsPSJUb2dnbGUgdGhlbWUiPiYjOTc4OTs8L2J1dHRvbj4KICAgICAgPC9uYXY+CiAgICA8L2hlYWRlcj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY2F0ZWdvcnktaGVybyI+CiAgICAgIDxkaXYgY2xhc3M9InRleHQiPgogICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5HbHlwaHMgJmFtcDsgR2FtZXMgLyBzb3VyY2U8L3NwYW4+CiAgICAgICAgPGgxPkhvdXJnbGFzcyBGbGlwPC9oMT4KICAgICAgICA8cD5BbiBob3VyZ2xhc3MgZmxpcHMgd2hpbGUgc2FuZCBkb3RzIGZhbGwuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLWhvdXJnbGFzcy1mbGlwIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1ob3VyZ2xhc3MtZmxpcCZxdW90OyZndDsKICAmbHQ7ZGl2IGNsYXNzPSZxdW90O2Z4LWxheWVyJnF1b3Q7IGFyaWEtaGlkZGVuPSZxdW90O3RydWUmcXVvdDsmZ3Q7Jmx0Oy9kaXYmZ3Q7CiZsdDsvc2VjdGlvbiZndDsKCiZsdDtsaW5rIHJlbD0mcXVvdDtzdHlsZXNoZWV0JnF1b3Q7IGhyZWY9JnF1b3Q7YXNzZXRzL3N0eWxlLmNzcyZxdW90OyZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2RhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWRhdGEuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9meC5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDs8L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJjc3MiIGhpZGRlbj48Y29kZT4uY3Vyc29yLWRlbW8gewogIHBvc2l0aW9uOiByZWxhdGl2ZTsKICBtaW4taGVpZ2h0OiAzMjBweDsKICBvdmVyZmxvdzogaGlkZGVuOwogIGJvcmRlci1yYWRpdXM6IDI0cHg7Cn0KCi5meC1sYXllciB7CiAgcG9zaXRpb246IGFic29sdXRlOwogIGluc2V0OiAwOwogIHBvaW50ZXItZXZlbnRzOiBub25lOwp9CgovKiBFZmZlY3Qgc3R5bGVzIGFyZSBpbiBhc3NldHMvc3R5bGUuY3NzIHVuZGVyOgogICBVTFRSQSA4MCBBREQtT05MWSBDVVJTT1IgUEFDSyAqLzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImpzIiBoaWRkZW4+PGNvZGU+Y29uc3QgZWZmZWN0ID0gQ09MRF9FRkZFQ1RTLmZpbmQoKGl0ZW0pID0mZ3Q7IGl0ZW0ua2V5ID09PSAmcXVvdDt1ODAtaG91cmdsYXNzLWZsaXAmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLWhvdXJnbGFzcy1mbGlwJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5Ib3VyZ2xhc3MgRmxpcCBpcyByZW5kZXJlZCBieSBhc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzLjwvZm9vdGVyPgogIDwvZGl2PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2Z4LmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9maW5hbC1zaXRlLXNuYWtlLXBoeXNpY3MuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZXh0cmEtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvYXBwLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0PmluaXRTb3VyY2VQYWdlKCJ1ODAtaG91cmdsYXNzLWZsaXAiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-playing-card.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UGxheWluZyBDYXJkIHwgU291cmNlIENvZGU8L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iLi4vYXNzZXRzL3N0eWxlLmNzcyI+CjwvaGVhZD4KPGJvZHk+CiAgPGRpdiBjbGFzcz0ic2hlbGwiPgogICAgPGhlYWRlciBjbGFzcz0ibmF2Ij4KICAgICAgPGEgY2xhc3M9ImJyYW5kIiBocmVmPSIuLi9pbmRleC5odG1sIj48c3BhbiBjbGFzcz0iYnJhbmQtZG90Ij48L3NwYW4+Q29sZGJvb3Q8L2E+CiAgICAgIDxuYXYgY2xhc3M9Im5hdi1saW5rcyI+CiAgICAgICAgPGEgaHJlZj0iLi4vY2F0ZWdvcmllcy91ODAtZ2x5cGgtZ2FtZXMuaHRtbCI+QmFjazwvYT4KICAgICAgICA8YSBocmVmPSIjcHJldmlldyI+UHJldmlldzwvYT4KICAgICAgICA8YSBocmVmPSIjY29kZSI+Q29kZTwvYT4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJ0aGVtZS10b2dnbGUiIGRhdGEtdGhlbWUtdG9nZ2xlIHR5cGU9ImJ1dHRvbiIgYXJpYS1sYWJlbD0iVG9nZ2xlIHRoZW1lIj4mIzk3ODk7PC9idXR0b24+CiAgICAgIDwvbmF2PgogICAgPC9oZWFkZXI+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNhdGVnb3J5LWhlcm8iPgogICAgICA8ZGl2IGNsYXNzPSJ0ZXh0Ij4KICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+R2x5cGhzICZhbXA7IEdhbWVzIC8gc291cmNlPC9zcGFuPgogICAgICAgIDxoMT5QbGF5aW5nIENhcmQ8L2gxPgogICAgICAgIDxwPkEgcGxheWluZyBjYXJkIGZsaXBzIGFuZCBsZWF2ZXMgc3VpdCBtYXJrcy48L3A+CiAgICAgIDwvZGl2PgogICAgPC9zZWN0aW9uPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJzb3VyY2UtcHJldmlldyBzZWN0aW9uLWdhcCIgaWQ9InNvdXJjZVByZXZpZXciIGRhdGEtZWZmZWN0PSJ1ODAtcGxheWluZy1jYXJkIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1wbGF5aW5nLWNhcmQmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLXBsYXlpbmctY2FyZCZxdW90Oyk7CmNvbnN0IHRhcmdldCA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7W2RhdGEtY3Vyc29yLWVmZmVjdD0mI3gyNzt1ODAtcGxheWluZy1jYXJkJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5QbGF5aW5nIENhcmQgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLXBsYXlpbmctY2FyZCIpOzwvc2NyaXB0Pgo8L2JvZHk+CjwvaHRtbD4K"},{"path":"sources/u80-puzzle-pop.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+UHV6emxlIFBvcCB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLWdseXBoLWdhbWVzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPkdseXBocyAmYW1wOyBHYW1lcyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+UHV6emxlIFBvcDwvaDE+CiAgICAgICAgPHA+UHV6emxlIHBpZWNlIHNoYXBlcyBwb3AgYXdheSBmcm9tIHRoZSBjdXJzb3IuPC9wPgogICAgICA8L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0ic291cmNlLXByZXZpZXcgc2VjdGlvbi1nYXAiIGlkPSJzb3VyY2VQcmV2aWV3IiBkYXRhLWVmZmVjdD0idTgwLXB1enpsZS1wb3AiPgogICAgICA8ZGl2IGNsYXNzPSJmeC1sYXllciIgYXJpYS1oaWRkZW49InRydWUiPjwvZGl2PgogICAgICA8ZGl2IGNsYXNzPSJwcmV2aWV3LXpvbmUiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgIDwvc2VjdGlvbj4KCiAgICA8c2VjdGlvbiBjbGFzcz0iY29kZS1jYXJkIHNlY3Rpb24tZ2FwIiBpZD0iY29kZSI+CiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtaGVhZCI+CiAgICAgICAgPGRpdj4KICAgICAgICAgIDxzcGFuIGNsYXNzPSJwaWxsIj5jb3B5IHNvdXJjZTwvc3Bhbj4KICAgICAgICAgIDxoMj5Vc2UgdGhpcyBlZmZlY3Q8L2gyPgogICAgICAgIDwvZGl2PgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvcHktYnRuIiBpZD0iY29weUFsbCIgdHlwZT0iYnV0dG9uIj5Db3B5IGFsbDwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxkaXYgY2xhc3M9ImNvZGUtdGFicyI+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIgYWN0aXZlIiBkYXRhLXRhYj0iaHRtbCIgdHlwZT0iYnV0dG9uIj5IVE1MPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJjc3MiIHR5cGU9ImJ1dHRvbiI+Q1NTPC9idXR0b24+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0iY29kZS10YWIiIGRhdGEtdGFiPSJqcyIgdHlwZT0iYnV0dG9uIj5KUzwvYnV0dG9uPgogICAgICA8L2Rpdj4KCiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJodG1sIj48Y29kZT4mbHQ7c2VjdGlvbiBjbGFzcz0mcXVvdDtjdXJzb3ItZGVtbyZxdW90OyBkYXRhLWN1cnNvci1lZmZlY3Q9JnF1b3Q7dTgwLXB1enpsZS1wb3AmcXVvdDsmZ3Q7CiAgJmx0O2RpdiBjbGFzcz0mcXVvdDtmeC1sYXllciZxdW90OyBhcmlhLWhpZGRlbj0mcXVvdDt0cnVlJnF1b3Q7Jmd0OyZsdDsvZGl2Jmd0OwombHQ7L3NlY3Rpb24mZ3Q7CgombHQ7bGluayByZWw9JnF1b3Q7c3R5bGVzaGVldCZxdW90OyBocmVmPSZxdW90O2Fzc2V0cy9zdHlsZS5jc3MmcXVvdDsmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy9kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1kYXRhLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZnguanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7CiZsdDtzY3JpcHQgc3JjPSZxdW90O2Fzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMmcXVvdDsmZ3Q7Jmx0Oy9zY3JpcHQmZ3Q7PC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iY3NzIiBoaWRkZW4+PGNvZGU+LmN1cnNvci1kZW1vIHsKICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgbWluLWhlaWdodDogMzIwcHg7CiAgb3ZlcmZsb3c6IGhpZGRlbjsKICBib3JkZXItcmFkaXVzOiAyNHB4Owp9CgouZngtbGF5ZXIgewogIHBvc2l0aW9uOiBhYnNvbHV0ZTsKICBpbnNldDogMDsKICBwb2ludGVyLWV2ZW50czogbm9uZTsKfQoKLyogRWZmZWN0IHN0eWxlcyBhcmUgaW4gYXNzZXRzL3N0eWxlLmNzcyB1bmRlcjoKICAgVUxUUkEgODAgQURELU9OTFkgQ1VSU09SIFBBQ0sgKi88L2NvZGU+PC9wcmU+CiAgICAgIDxwcmUgY2xhc3M9ImNvZGUtcGFuZSIgZGF0YS1jb2RlPSJqcyIgaGlkZGVuPjxjb2RlPmNvbnN0IGVmZmVjdCA9IENPTERfRUZGRUNUUy5maW5kKChpdGVtKSA9Jmd0OyBpdGVtLmtleSA9PT0gJnF1b3Q7dTgwLXB1enpsZS1wb3AmcXVvdDspOwpjb25zdCB0YXJnZXQgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCZxdW90O1tkYXRhLWN1cnNvci1lZmZlY3Q9JiN4Mjc7dTgwLXB1enpsZS1wb3AmI3gyNztdJnF1b3Q7KTsKY29uc3QgbGF5ZXIgPSB0YXJnZXQucXVlcnlTZWxlY3RvcigmcXVvdDsuZngtbGF5ZXImcXVvdDspOwoKdGFyZ2V0LmFkZEV2ZW50TGlzdGVuZXIoJnF1b3Q7cG9pbnRlcm1vdmUmcXVvdDssIChldmVudCkgPSZndDsgewogIGNvbnN0IHJlY3QgPSBsYXllci5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKTsKICBDT0xEX0ZYLnNwYXduKGVmZmVjdCwgbGF5ZXIsIGV2ZW50LmNsaWVudFggLSByZWN0LmxlZnQsIGV2ZW50LmNsaWVudFkgLSByZWN0LnRvcCk7Cn0pOzwvY29kZT48L3ByZT4KICAgIDwvc2VjdGlvbj4KCiAgICA8Zm9vdGVyPlB1enpsZSBQb3AgaXMgcmVuZGVyZWQgYnkgYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcy48L2Zvb3Rlcj4KICA8L2Rpdj4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2RhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9meC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9tZWdhLW1vdGlvbi1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3NpZ25hdHVyZS1wYWNrLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZmluYWwtc2l0ZS1zbmFrZS1waHlzaWNzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2V4dHJhLWN1cnNvcnMuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2FwcC5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdD5pbml0U291cmNlUGFnZSgidTgwLXB1enpsZS1wb3AiKTs8L3NjcmlwdD4KPC9ib2R5Pgo8L2h0bWw+Cg=="},{"path":"sources/u80-dial-combo.html","content_b64":"PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIiBkYXRhLXRoZW1lPSJkYXJrIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPG1ldGEgbmFtZT0icm9ib3RzIiBjb250ZW50PSJub2luZGV4LG5vZm9sbG93Ij4KICA8dGl0bGU+RGlhbCBDb21ibyB8IFNvdXJjZSBDb2RlPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ii4uL2Fzc2V0cy9zdHlsZS5jc3MiPgo8L2hlYWQ+Cjxib2R5PgogIDxkaXYgY2xhc3M9InNoZWxsIj4KICAgIDxoZWFkZXIgY2xhc3M9Im5hdiI+CiAgICAgIDxhIGNsYXNzPSJicmFuZCIgaHJlZj0iLi4vaW5kZXguaHRtbCI+PHNwYW4gY2xhc3M9ImJyYW5kLWRvdCI+PC9zcGFuPkNvbGRib290PC9hPgogICAgICA8bmF2IGNsYXNzPSJuYXYtbGlua3MiPgogICAgICAgIDxhIGhyZWY9Ii4uL2NhdGVnb3JpZXMvdTgwLWdseXBoLWdhbWVzLmh0bWwiPkJhY2s8L2E+CiAgICAgICAgPGEgaHJlZj0iI3ByZXZpZXciPlByZXZpZXc8L2E+CiAgICAgICAgPGEgaHJlZj0iI2NvZGUiPkNvZGU8L2E+CiAgICAgICAgPGJ1dHRvbiBjbGFzcz0idGhlbWUtdG9nZ2xlIiBkYXRhLXRoZW1lLXRvZ2dsZSB0eXBlPSJidXR0b24iIGFyaWEtbGFiZWw9IlRvZ2dsZSB0aGVtZSI+JiM5Nzg5OzwvYnV0dG9uPgogICAgICA8L25hdj4KICAgIDwvaGVhZGVyPgoKICAgIDxzZWN0aW9uIGNsYXNzPSJjYXRlZ29yeS1oZXJvIj4KICAgICAgPGRpdiBjbGFzcz0idGV4dCI+CiAgICAgICAgPHNwYW4gY2xhc3M9InBpbGwiPkdseXBocyAmYW1wOyBHYW1lcyAvIHNvdXJjZTwvc3Bhbj4KICAgICAgICA8aDE+RGlhbCBDb21ibzwvaDE+CiAgICAgICAgPHA+Q29tYmluYXRpb24gZGlhbCB0aWNrcyByb3RhdGUgaW4gbGF5ZXJzLjwvcD4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9InNvdXJjZS1wcmV2aWV3IHNlY3Rpb24tZ2FwIiBpZD0ic291cmNlUHJldmlldyIgZGF0YS1lZmZlY3Q9InU4MC1kaWFsLWNvbWJvIj4KICAgICAgPGRpdiBjbGFzcz0iZngtbGF5ZXIiIGFyaWEtaGlkZGVuPSJ0cnVlIj48L2Rpdj4KICAgICAgPGRpdiBjbGFzcz0icHJldmlldy16b25lIiBhcmlhLWhpZGRlbj0idHJ1ZSI+PC9kaXY+CiAgICA8L3NlY3Rpb24+CgogICAgPHNlY3Rpb24gY2xhc3M9ImNvZGUtY2FyZCBzZWN0aW9uLWdhcCIgaWQ9ImNvZGUiPgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLWhlYWQiPgogICAgICAgIDxkaXY+CiAgICAgICAgICA8c3BhbiBjbGFzcz0icGlsbCI+Y29weSBzb3VyY2U8L3NwYW4+CiAgICAgICAgICA8aDI+VXNlIHRoaXMgZWZmZWN0PC9oMj4KICAgICAgICA8L2Rpdj4KICAgICAgICA8YnV0dG9uIGNsYXNzPSJjb3B5LWJ0biIgaWQ9ImNvcHlBbGwiIHR5cGU9ImJ1dHRvbiI+Q29weSBhbGw8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8ZGl2IGNsYXNzPSJjb2RlLXRhYnMiPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIGFjdGl2ZSIgZGF0YS10YWI9Imh0bWwiIHR5cGU9ImJ1dHRvbiI+SFRNTDwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0iY3NzIiB0eXBlPSJidXR0b24iPkNTUzwvYnV0dG9uPgogICAgICAgIDxidXR0b24gY2xhc3M9ImNvZGUtdGFiIiBkYXRhLXRhYj0ianMiIHR5cGU9ImJ1dHRvbiI+SlM8L2J1dHRvbj4KICAgICAgPC9kaXY+CgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0iaHRtbCI+PGNvZGU+Jmx0O3NlY3Rpb24gY2xhc3M9JnF1b3Q7Y3Vyc29yLWRlbW8mcXVvdDsgZGF0YS1jdXJzb3ItZWZmZWN0PSZxdW90O3U4MC1kaWFsLWNvbWJvJnF1b3Q7Jmd0OwogICZsdDtkaXYgY2xhc3M9JnF1b3Q7ZngtbGF5ZXImcXVvdDsgYXJpYS1oaWRkZW49JnF1b3Q7dHJ1ZSZxdW90OyZndDsmbHQ7L2RpdiZndDsKJmx0Oy9zZWN0aW9uJmd0OwoKJmx0O2xpbmsgcmVsPSZxdW90O3N0eWxlc2hlZXQmcXVvdDsgaHJlZj0mcXVvdDthc3NldHMvc3R5bGUuY3NzJnF1b3Q7Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL3VsdHJhODAtZGF0YS5qcyZxdW90OyZndDsmbHQ7L3NjcmlwdCZndDsKJmx0O3NjcmlwdCBzcmM9JnF1b3Q7YXNzZXRzL2Z4LmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OwombHQ7c2NyaXB0IHNyYz0mcXVvdDthc3NldHMvdWx0cmE4MC1jdXJzb3JzLmpzJnF1b3Q7Jmd0OyZsdDsvc2NyaXB0Jmd0OzwvY29kZT48L3ByZT4KICAgICAgPHByZSBjbGFzcz0iY29kZS1wYW5lIiBkYXRhLWNvZGU9ImNzcyIgaGlkZGVuPjxjb2RlPi5jdXJzb3ItZGVtbyB7CiAgcG9zaXRpb246IHJlbGF0aXZlOwogIG1pbi1oZWlnaHQ6IDMyMHB4OwogIG92ZXJmbG93OiBoaWRkZW47CiAgYm9yZGVyLXJhZGl1czogMjRweDsKfQoKLmZ4LWxheWVyIHsKICBwb3NpdGlvbjogYWJzb2x1dGU7CiAgaW5zZXQ6IDA7CiAgcG9pbnRlci1ldmVudHM6IG5vbmU7Cn0KCi8qIEVmZmVjdCBzdHlsZXMgYXJlIGluIGFzc2V0cy9zdHlsZS5jc3MgdW5kZXI6CiAgIFVMVFJBIDgwIEFERC1PTkxZIENVUlNPUiBQQUNLICovPC9jb2RlPjwvcHJlPgogICAgICA8cHJlIGNsYXNzPSJjb2RlLXBhbmUiIGRhdGEtY29kZT0ianMiIGhpZGRlbj48Y29kZT5jb25zdCBlZmZlY3QgPSBDT0xEX0VGRkVDVFMuZmluZCgoaXRlbSkgPSZndDsgaXRlbS5rZXkgPT09ICZxdW90O3U4MC1kaWFsLWNvbWJvJnF1b3Q7KTsKY29uc3QgdGFyZ2V0ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigmcXVvdDtbZGF0YS1jdXJzb3ItZWZmZWN0PSYjeDI3O3U4MC1kaWFsLWNvbWJvJiN4Mjc7XSZxdW90Oyk7CmNvbnN0IGxheWVyID0gdGFyZ2V0LnF1ZXJ5U2VsZWN0b3IoJnF1b3Q7LmZ4LWxheWVyJnF1b3Q7KTsKCnRhcmdldC5hZGRFdmVudExpc3RlbmVyKCZxdW90O3BvaW50ZXJtb3ZlJnF1b3Q7LCAoZXZlbnQpID0mZ3Q7IHsKICBjb25zdCByZWN0ID0gbGF5ZXIuZ2V0Qm91bmRpbmdDbGllbnRSZWN0KCk7CiAgQ09MRF9GWC5zcGF3bihlZmZlY3QsIGxheWVyLCBldmVudC5jbGllbnRYIC0gcmVjdC5sZWZ0LCBldmVudC5jbGllbnRZIC0gcmVjdC50b3ApOwp9KTs8L2NvZGU+PC9wcmU+CiAgICA8L3NlY3Rpb24+CgogICAgPGZvb3Rlcj5EaWFsIENvbWJvIGlzIHJlbmRlcmVkIGJ5IGFzc2V0cy91bHRyYTgwLWN1cnNvcnMuanMuPC9mb290ZXI+CiAgPC9kaXY+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9kYXRhLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL21lZ2EtbW90aW9uLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvc2lnbmF0dXJlLXBhY2stZGF0YS5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy91bHRyYTgwLWRhdGEuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvZnguanMiPjwvc2NyaXB0PgogIDxzY3JpcHQgc3JjPSIuLi9hc3NldHMvbWVnYS1tb3Rpb24tY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9zaWduYXR1cmUtcGFjay1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL2ZpbmFsLXNpdGUtc25ha2UtcGh5c2ljcy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9leHRyYS1jdXJzb3JzLmpzIj48L3NjcmlwdD4KICA8c2NyaXB0IHNyYz0iLi4vYXNzZXRzL3VsdHJhODAtY3Vyc29ycy5qcyI+PC9zY3JpcHQ+CiAgPHNjcmlwdCBzcmM9Ii4uL2Fzc2V0cy9hcHAuanMiPjwvc2NyaXB0PgogIDxzY3JpcHQ+aW5pdFNvdXJjZVBhZ2UoInU4MC1kaWFsLWNvbWJvIik7PC9zY3JpcHQ+CjwvYm9keT4KPC9odG1sPgo="}]
'@
$pages = $pagesJson | ConvertFrom-Json
foreach ($page in $pages) {
  $target = Join-Path $root $page.path
  $dir = Split-Path $target -Parent
  if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  Save-Utf8 $target ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($page.content_b64)))
}

Write-Host "5) Loading Ultra 80 scripts on all HTML pages..."

Get-ChildItem -Path $root -Recurse -File -Filter "*.html" |
Where-Object { $_.FullName -notmatch "\\\.git\\" -and $_.FullName -notmatch "\\_backup" } |
ForEach-Object {
  $html = Read-Utf8 $_.FullName

  # Remove only previous Ultra 80 script tags, then add fresh cache-busted tags.
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+ultra80-data\.js[^>]*></script>\s*', '')
  $html = [regex]::Replace($html, '(?im)^\s*<script[^>]+ultra80-cursors\.js[^>]*></script>\s*', '')

  $relativeDir = $_.DirectoryName.Substring($root.Length).TrimStart('\')
  $depth = if ([string]::IsNullOrWhiteSpace($relativeDir)) { 0 } else { ($relativeDir -split '[\\/]').Count }
  $dataSrc = (('../' * $depth) + "assets/ultra80-data.js?v=$stamp").Replace('\','/')
  $cursorSrc = (('../' * $depth) + "assets/ultra80-cursors.js?v=$stamp").Replace('\','/')
  $dataTag = "  <script src=""$dataSrc""></script>"
  $cursorTag = "  <script src=""$cursorSrc""></script>"

  if ($html -match 'assets/data\.js') {
    $html = [regex]::Replace($html, '(?im)(^\s*<script[^>]+assets/data\.js[^>]*></script>\s*)', "`$1$dataTag`r`n", 1)
  } else {
    $html = $html -replace '(?i)</body>', "$dataTag`r`n</body>"
  }

  if ($html -match 'assets/fx\.js') {
    $html = [regex]::Replace($html, '(?im)(^\s*<script[^>]+assets/fx\.js[^>]*></script>\s*)', "`$1$cursorTag`r`n", 1)
  } else {
    $html = $html -replace '(?i)</body>', "$cursorTag`r`n</body>"
  }

  Save-Utf8 $_.FullName $html
}

Write-Host "6) Adding Ultra 80 cards to home page without deleting old cards..."

$indexPath = ".\index.html"
$index = Read-Utf8 $indexPath

# Remove only old Ultra 80 cards if installer is run again.
foreach ($cat in $pack.categories) {
  $link = "categories/$($cat.id).html"
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
        <span class="pill">ULTRA 80 / category</span>
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

Save-Utf8 $indexPath $index

Write-Host "7) Syntax check..."

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\ultra80-data.js" | Out-Null
  node --check ".\assets\ultra80-cursors.js" | Out-Null
  node --check ".\assets\app.js" | Out-Null
  node --check ".\assets\fx.js" | Out-Null
}

Write-Host ""
Write-Host "DONE:"
Write-Host "- added 80 new Ultra cursor animations"
Write-Host "- did not remove old categories or old effects"
Write-Host "- added working source pages with HTML/CSS/JS code"
Write-Host "- patched preview start/move/touch behavior"
Write-Host "- backup saved here:"
Write-Host $backup
