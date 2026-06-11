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
