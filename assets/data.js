window.COLD_DATA = [
  {
    "id": "particle-craft",
    "num": "01",
    "title": "Particle Craft",
    "desc": "Pixels, dust, sparks, pollen and confetti effects.",
    "icon": "*",
    "effects": [
      "pixel-fracture",
      "ember-dust",
      "orbit-sparks",
      "pollen-field",
      "prism-confetti"
    ]
  },
  {
    "id": "trails-echo",
    "num": "02",
    "title": "Trails & Echo",
    "desc": "Ribbon, comet, ink, halo and elastic trail effects.",
    "icon": "~",
    "effects": [
      "ghost-ribbon",
      "comet-thread",
      "ink-silk",
      "halo-pulse",
      "elastic-line"
    ]
  },
  {
    "id": "creature-motion",
    "num": "03",
    "title": "Creature Motion",
    "desc": "Snake, centipede, larva, beetle and fish follower effects.",
    "icon": "S",
    "effects": [
      "spine-serpent",
      "neon-centipede",
      "jelly-larva",
      "beetle-steps",
      "fish-chain"
    ]
  },
  {
    "id": "fluid-smoke",
    "num": "04",
    "title": "Fluid & Smoke",
    "desc": "Smoke, ink, water, vapor and oil-cell effects.",
    "icon": "O",
    "effects": [
      "smoke-bloom",
      "ink-drop",
      "water-ripple",
      "vapor-curl",
      "oil-cell"
    ]
  },
  {
    "id": "geometry-light",
    "num": "05",
    "title": "Geometry & Light",
    "desc": "Portal rings, lasers, scan grids, triangles and cubes.",
    "icon": "G",
    "effects": [
      "portal-ring",
      "laser-slice",
      "scan-grid",
      "triangle-swarm",
      "cube-pop"
    ]
  },
  {
    "id": "code-data",
    "num": "06",
    "title": "Code & Data",
    "desc": "Syntax tokens, binary rain, terminal cursor and matrix effects.",
    "icon": "{}",
    "effects": [
      "token-burst",
      "binary-rain",
      "terminal-caret",
      "matrix-beads",
      "bracket-orbit"
    ]
  },
  {
    "id": "nature-motion",
    "num": "07",
    "title": "Nature Motion",
    "desc": "Fireflies, leaf spin, snow crystals, rain streaks and petals.",
    "icon": "N",
    "effects": [
      "fireflies",
      "leaf-spin",
      "snow-crystal",
      "rain-streak",
      "petal-drift"
    ]
  },
  {
    "id": "ui-objects",
    "num": "08",
    "title": "UI Objects",
    "desc": "Keycaps, app cards, windows, toggles and magnetic cards.",
    "icon": "UI",
    "effects": [
      "keycap-pop",
      "app-vault-cards",
      "window-stack",
      "toggle-switch",
      "card-magnet"
    ]
  },
  {
    "id": "addon-ash-smoke",
    "num": "09",
    "title": "Ash Smoke",
    "desc": "Dry ash, soot, vapor, cinder and ember-style cursor motion.",
    "icon": "◌",
    "effects": [
      "cb-ash-spiral",
      "cb-ember-veil",
      "cb-smoke-knot",
      "cb-cinder-lift",
      "cb-soot-comet",
      "cb-burnt-pollen",
      "cb-charcoal-rain",
      "cb-vapor-stitch",
      "cb-ghost-ash",
      "cb-coal-flicker"
    ]
  },
  {
    "id": "addon-structure",
    "num": "10",
    "title": "Structure",
    "desc": "Grids, brackets, cursor ghosts and structural cursor marks.",
    "icon": "▦",
    "effects": [
      "cb-fractured-cursor",
      "cb-hinge-bracket",
      "cb-dotted-lasso",
      "cb-blueprint-corner",
      "cb-ruler-snap",
      "cb-folded-grid",
      "cb-anchor-pin",
      "cb-cross-section",
      "cb-orbit-stamp",
      "cb-elastic-box"
    ]
  },
  {
    "id": "addon-energy",
    "num": "11",
    "title": "Signal",
    "desc": "Wave, signal, electric and pulse-based cursor effects.",
    "icon": "ϟ",
    "effects": [
      "cb-pulse-beacon",
      "cb-wave-ladder",
      "cb-signal-fan",
      "cb-electric-fork",
      "cb-sonar-bubble",
      "cb-phase-rings",
      "cb-storm-ticks",
      "cb-voltage-teeth",
      "cb-ripple-gate",
      "cb-light-drift"
    ]
  },
  {
    "id": "u80-precision-instruments",
    "num": "12",
    "title": "Precision",
    "desc": "Measuring, scanning and instrument-like cursor mechanics.",
    "icon": "⌖",
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
    "num": "13",
    "title": "Kinetic",
    "desc": "Physical toys, springs, levers and weighted cursor motion.",
    "icon": "◆",
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
  }
];

window.COLD_EFFECTS = [
  {
    "key": "pixel-fracture",
    "name": "Pixel Fracture",
    "desc": "Blocks crack outward from the cursor.",
    "kind": "pixel",
    "cat_id": "particle-craft",
    "cat_num": "01",
    "cat_title": "Particle Craft",
    "cat_desc": "Pixels, dust, sparks, pollen and confetti effects.",
    "cat_icon": "*",
    "index": 1,
    "dark": {
      "a": "#5cf28b",
      "b": "#c89cff",
      "ink": "#f4f4ef"
    },
    "light": {
      "a": "#2d7b49",
      "b": "#6b4d9e",
      "ink": "#15191e"
    }
  },
  {
    "key": "ember-dust",
    "name": "Ember Dust",
    "desc": "Warm dust sparks rise and fade.",
    "kind": "ember",
    "cat_id": "particle-craft",
    "cat_num": "01",
    "cat_title": "Particle Craft",
    "cat_desc": "Pixels, dust, sparks, pollen and confetti effects.",
    "cat_icon": "*",
    "index": 2,
    "dark": {
      "a": "#ff8b3d",
      "b": "#ffd08a",
      "ink": "#fff8e8"
    },
    "light": {
      "a": "#8f4e23",
      "b": "#a56b28",
      "ink": "#1d160f"
    }
  },
  {
    "key": "orbit-sparks",
    "name": "Orbit Sparks",
    "desc": "Tiny particles orbit before escaping.",
    "kind": "orbit",
    "cat_id": "particle-craft",
    "cat_num": "01",
    "cat_title": "Particle Craft",
    "cat_desc": "Pixels, dust, sparks, pollen and confetti effects.",
    "cat_icon": "*",
    "index": 3,
    "dark": {
      "a": "#6ee7ff",
      "b": "#b9ff34",
      "ink": "#f8fff0"
    },
    "light": {
      "a": "#2f7182",
      "b": "#5e8026",
      "ink": "#121914"
    }
  },
  {
    "key": "pollen-field",
    "name": "Pollen Field",
    "desc": "Soft organic dots drift around the pointer.",
    "kind": "pollen",
    "cat_id": "particle-craft",
    "cat_num": "01",
    "cat_title": "Particle Craft",
    "cat_desc": "Pixels, dust, sparks, pollen and confetti effects.",
    "cat_icon": "*",
    "index": 4,
    "dark": {
      "a": "#b9ff34",
      "b": "#fff58a",
      "ink": "#f8ffe8"
    },
    "light": {
      "a": "#698a22",
      "b": "#9a8427",
      "ink": "#171a10"
    }
  },
  {
    "key": "prism-confetti",
    "name": "Prism Confetti",
    "desc": "Small prismatic chips pop in different angles.",
    "kind": "prism",
    "cat_id": "particle-craft",
    "cat_num": "01",
    "cat_title": "Particle Craft",
    "cat_desc": "Pixels, dust, sparks, pollen and confetti effects.",
    "cat_icon": "*",
    "index": 5,
    "dark": {
      "a": "#ff5b8a",
      "b": "#61d9ff",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#9a3658",
      "b": "#387486",
      "ink": "#16191f"
    }
  },
  {
    "key": "ghost-ribbon",
    "name": "Ghost Ribbon",
    "desc": "Fading ribbon strips follow the cursor.",
    "kind": "ribbon",
    "cat_id": "trails-echo",
    "cat_num": "02",
    "cat_title": "Trails & Echo",
    "cat_desc": "Ribbon, comet, ink, halo and elastic trail effects.",
    "cat_icon": "~",
    "index": 1,
    "dark": {
      "a": "#c89cff",
      "b": "#e8dcff",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#6b4d9e",
      "b": "#8a7ba8",
      "ink": "#17151d"
    }
  },
  {
    "key": "comet-thread",
    "name": "Comet Thread",
    "desc": "A bright comet stroke shoots forward.",
    "kind": "comet",
    "cat_id": "trails-echo",
    "cat_num": "02",
    "cat_title": "Trails & Echo",
    "cat_desc": "Ribbon, comet, ink, halo and elastic trail effects.",
    "cat_icon": "~",
    "index": 2,
    "dark": {
      "a": "#b9ff34",
      "b": "#ffffff",
      "ink": "#f8ffe8"
    },
    "light": {
      "a": "#64822b",
      "b": "#f0f0df",
      "ink": "#15191e"
    }
  },
  {
    "key": "ink-silk",
    "name": "Ink Silk",
    "desc": "Dark silky ink droplets stretch behind the cursor.",
    "kind": "inktail",
    "cat_id": "trails-echo",
    "cat_num": "02",
    "cat_title": "Trails & Echo",
    "cat_desc": "Ribbon, comet, ink, halo and elastic trail effects.",
    "cat_icon": "~",
    "index": 3,
    "dark": {
      "a": "#c6b7ff",
      "b": "#1c2030",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#554a7c",
      "b": "#303036",
      "ink": "#16191f"
    }
  },
  {
    "key": "halo-pulse",
    "name": "Halo Pulse",
    "desc": "Large quiet halo rings expand from the pointer.",
    "kind": "halo",
    "cat_id": "trails-echo",
    "cat_num": "02",
    "cat_title": "Trails & Echo",
    "cat_desc": "Ribbon, comet, ink, halo and elastic trail effects.",
    "cat_icon": "~",
    "index": 4,
    "dark": {
      "a": "#b9ff34",
      "b": "#6ee7ff",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#5a7c2a",
      "b": "#3b7882",
      "ink": "#121914"
    }
  },
  {
    "key": "elastic-line",
    "name": "Elastic Line",
    "desc": "Rubber-like short lines stretch and snap back.",
    "kind": "elastic",
    "cat_id": "trails-echo",
    "cat_num": "02",
    "cat_title": "Trails & Echo",
    "cat_desc": "Ribbon, comet, ink, halo and elastic trail effects.",
    "cat_icon": "~",
    "index": 5,
    "dark": {
      "a": "#ffcf5d",
      "b": "#f5f1e8",
      "ink": "#15191e"
    },
    "light": {
      "a": "#816b2f",
      "b": "#f2eadb",
      "ink": "#15191e"
    }
  },
  {
    "key": "spine-serpent",
    "name": "Spine Serpent",
    "desc": "A clean segmented snake with a visible head and spine.",
    "kind": "snake",
    "cat_id": "creature-motion",
    "cat_num": "03",
    "cat_title": "Creature Motion",
    "cat_desc": "Snake, centipede, larva, beetle and fish follower effects.",
    "cat_icon": "S",
    "index": 1,
    "dark": {
      "a": "#d7e8be",
      "b": "#8cff77",
      "ink": "#07100b"
    },
    "light": {
      "a": "#536b36",
      "b": "#89a956",
      "ink": "#f5f1e8"
    }
  },
  {
    "key": "neon-centipede",
    "name": "Neon Centipede",
    "desc": "Small neon body segments chase the cursor.",
    "kind": "centipede",
    "cat_id": "creature-motion",
    "cat_num": "03",
    "cat_title": "Creature Motion",
    "cat_desc": "Snake, centipede, larva, beetle and fish follower effects.",
    "cat_icon": "S",
    "index": 2,
    "dark": {
      "a": "#5cf28b",
      "b": "#61d9ff",
      "ink": "#07100b"
    },
    "light": {
      "a": "#2c7c49",
      "b": "#337583",
      "ink": "#f5f1e8"
    }
  },
  {
    "key": "jelly-larva",
    "name": "Jelly Larva",
    "desc": "Transparent jelly body blobs wobble behind the cursor.",
    "kind": "jelly",
    "cat_id": "creature-motion",
    "cat_num": "03",
    "cat_title": "Creature Motion",
    "cat_desc": "Snake, centipede, larva, beetle and fish follower effects.",
    "cat_icon": "S",
    "index": 3,
    "dark": {
      "a": "#9fe7ff",
      "b": "#f2d2ff",
      "ink": "#111827"
    },
    "light": {
      "a": "#4d7d87",
      "b": "#8e77a1",
      "ink": "#f5f1e8"
    }
  },
  {
    "key": "beetle-steps",
    "name": "Beetle Steps",
    "desc": "Tiny step marks appear left and right.",
    "kind": "steps",
    "cat_id": "creature-motion",
    "cat_num": "03",
    "cat_title": "Creature Motion",
    "cat_desc": "Snake, centipede, larva, beetle and fish follower effects.",
    "cat_icon": "S",
    "index": 4,
    "dark": {
      "a": "#f5f1e8",
      "b": "#b9ff34",
      "ink": "#07100b"
    },
    "light": {
      "a": "#3f4039",
      "b": "#6b8a2c",
      "ink": "#f5f1e8"
    }
  },
  {
    "key": "fish-chain",
    "name": "Fish Chain",
    "desc": "Linked tail pieces swim behind the pointer.",
    "kind": "fish",
    "cat_id": "creature-motion",
    "cat_num": "03",
    "cat_title": "Creature Motion",
    "cat_desc": "Snake, centipede, larva, beetle and fish follower effects.",
    "cat_icon": "S",
    "index": 5,
    "dark": {
      "a": "#61d9ff",
      "b": "#b9ff34",
      "ink": "#07100b"
    },
    "light": {
      "a": "#337583",
      "b": "#6b8a2c",
      "ink": "#f5f1e8"
    }
  },
  {
    "key": "smoke-bloom",
    "name": "Smoke Bloom",
    "desc": "Soft smoke circles bloom and dissolve.",
    "kind": "smoke",
    "cat_id": "fluid-smoke",
    "cat_num": "04",
    "cat_title": "Fluid & Smoke",
    "cat_desc": "Smoke, ink, water, vapor and oil-cell effects.",
    "cat_icon": "O",
    "index": 1,
    "dark": {
      "a": "#d9dde8",
      "b": "#8790a8",
      "ink": "#f4f5fb"
    },
    "light": {
      "a": "#6f726d",
      "b": "#9a9388",
      "ink": "#16191f"
    }
  },
  {
    "key": "ink-drop",
    "name": "Ink Drop",
    "desc": "Heavy ink drops spread into soft stains.",
    "kind": "inkdrop",
    "cat_id": "fluid-smoke",
    "cat_num": "04",
    "cat_title": "Fluid & Smoke",
    "cat_desc": "Smoke, ink, water, vapor and oil-cell effects.",
    "cat_icon": "O",
    "index": 2,
    "dark": {
      "a": "#0e1118",
      "b": "#c89cff",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#2f3035",
      "b": "#69509c",
      "ink": "#ffffff"
    }
  },
  {
    "key": "water-ripple",
    "name": "Water Ripple",
    "desc": "Ripple rings and small droplets expand outward.",
    "kind": "water",
    "cat_id": "fluid-smoke",
    "cat_num": "04",
    "cat_title": "Fluid & Smoke",
    "cat_desc": "Smoke, ink, water, vapor and oil-cell effects.",
    "cat_icon": "O",
    "index": 3,
    "dark": {
      "a": "#7de1bc",
      "b": "#6ee7ff",
      "ink": "#06100d"
    },
    "light": {
      "a": "#347e69",
      "b": "#3b7882",
      "ink": "#f5f1e8"
    }
  },
  {
    "key": "vapor-curl",
    "name": "Vapor Curl",
    "desc": "Curved vapor puffs drift upward.",
    "kind": "vapor",
    "cat_id": "fluid-smoke",
    "cat_num": "04",
    "cat_title": "Fluid & Smoke",
    "cat_desc": "Smoke, ink, water, vapor and oil-cell effects.",
    "cat_icon": "O",
    "index": 4,
    "dark": {
      "a": "#e0e7ff",
      "b": "#aab7d9",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#777d8f",
      "b": "#989ea8",
      "ink": "#15191e"
    }
  },
  {
    "key": "oil-cell",
    "name": "Oil Cell",
    "desc": "Iridescent organic cells inflate and fade.",
    "kind": "oil",
    "cat_id": "fluid-smoke",
    "cat_num": "04",
    "cat_title": "Fluid & Smoke",
    "cat_desc": "Smoke, ink, water, vapor and oil-cell effects.",
    "cat_icon": "O",
    "index": 5,
    "dark": {
      "a": "#ff5b8a",
      "b": "#61d9ff",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#7a3b52",
      "b": "#3b7882",
      "ink": "#15191e"
    }
  },
  {
    "key": "portal-ring",
    "name": "Portal Ring",
    "desc": "Double portal rings open around the cursor.",
    "kind": "portal",
    "cat_id": "geometry-light",
    "cat_num": "05",
    "cat_title": "Geometry & Light",
    "cat_desc": "Portal rings, lasers, scan grids, triangles and cubes.",
    "cat_icon": "G",
    "index": 1,
    "dark": {
      "a": "#b9ff34",
      "b": "#c89cff",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#5f7d1c",
      "b": "#6b4d9e",
      "ink": "#15191e"
    }
  },
  {
    "key": "laser-slice",
    "name": "Laser Slice",
    "desc": "Sharp light slices cut across the preview.",
    "kind": "laser",
    "cat_id": "geometry-light",
    "cat_num": "05",
    "cat_title": "Geometry & Light",
    "cat_desc": "Portal rings, lasers, scan grids, triangles and cubes.",
    "cat_icon": "G",
    "index": 2,
    "dark": {
      "a": "#ff5b8a",
      "b": "#ffffff",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#9a3658",
      "b": "#f2eadb",
      "ink": "#15191e"
    }
  },
  {
    "key": "scan-grid",
    "name": "Scan Grid",
    "desc": "A scanner bar and small grid bits appear.",
    "kind": "scan",
    "cat_id": "geometry-light",
    "cat_num": "05",
    "cat_title": "Geometry & Light",
    "cat_desc": "Portal rings, lasers, scan grids, triangles and cubes.",
    "cat_icon": "G",
    "index": 3,
    "dark": {
      "a": "#61d9ff",
      "b": "#b9ff34",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#337583",
      "b": "#6b8a2c",
      "ink": "#15191e"
    }
  },
  {
    "key": "triangle-swarm",
    "name": "Triangle Swarm",
    "desc": "Tiny triangles rotate and scatter.",
    "kind": "tri",
    "cat_id": "geometry-light",
    "cat_num": "05",
    "cat_title": "Geometry & Light",
    "cat_desc": "Portal rings, lasers, scan grids, triangles and cubes.",
    "cat_icon": "G",
    "index": 4,
    "dark": {
      "a": "#ffd166",
      "b": "#ff5b8a",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#8a6b24",
      "b": "#9a3658",
      "ink": "#15191e"
    }
  },
  {
    "key": "cube-pop",
    "name": "Cube Pop",
    "desc": "Isometric cube blocks pop out from the pointer.",
    "kind": "cube",
    "cat_id": "geometry-light",
    "cat_num": "05",
    "cat_title": "Geometry & Light",
    "cat_desc": "Portal rings, lasers, scan grids, triangles and cubes.",
    "cat_icon": "G",
    "index": 5,
    "dark": {
      "a": "#c89cff",
      "b": "#6ee7ff",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#6b4d9e",
      "b": "#3b7882",
      "ink": "#15191e"
    }
  },
  {
    "key": "token-burst",
    "name": "Token Burst",
    "desc": "Code tokens jump out like syntax fragments.",
    "kind": "token",
    "cat_id": "code-data",
    "cat_num": "06",
    "cat_title": "Code & Data",
    "cat_desc": "Syntax tokens, binary rain, terminal cursor and matrix effects.",
    "cat_icon": "{}",
    "index": 1,
    "dark": {
      "a": "#b9ff34",
      "b": "#c89cff",
      "ink": "#07100b"
    },
    "light": {
      "a": "#5f7d1c",
      "b": "#6b4d9e",
      "ink": "#ffffff"
    }
  },
  {
    "key": "binary-rain",
    "name": "Binary Rain",
    "desc": "Binary marks fall downward from the cursor.",
    "kind": "binary",
    "cat_id": "code-data",
    "cat_num": "06",
    "cat_title": "Code & Data",
    "cat_desc": "Syntax tokens, binary rain, terminal cursor and matrix effects.",
    "cat_icon": "{}",
    "index": 2,
    "dark": {
      "a": "#5cf28b",
      "b": "#0d121a",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#2d7b49",
      "b": "#c7c0b1",
      "ink": "#15191e"
    }
  },
  {
    "key": "terminal-caret",
    "name": "Terminal Caret",
    "desc": "Terminal prompts and carets blink and fade.",
    "kind": "terminal",
    "cat_id": "code-data",
    "cat_num": "06",
    "cat_title": "Code & Data",
    "cat_desc": "Syntax tokens, binary rain, terminal cursor and matrix effects.",
    "cat_icon": "{}",
    "index": 3,
    "dark": {
      "a": "#b9ff34",
      "b": "#f5f1e8",
      "ink": "#07100b"
    },
    "light": {
      "a": "#5f7d1c",
      "b": "#c7c0b1",
      "ink": "#15191e"
    }
  },
  {
    "key": "matrix-beads",
    "name": "Matrix Beads",
    "desc": "Data beads fall in short vertical chains.",
    "kind": "matrix",
    "cat_id": "code-data",
    "cat_num": "06",
    "cat_title": "Code & Data",
    "cat_desc": "Syntax tokens, binary rain, terminal cursor and matrix effects.",
    "cat_icon": "{}",
    "index": 4,
    "dark": {
      "a": "#5cf28b",
      "b": "#b9ff34",
      "ink": "#07100b"
    },
    "light": {
      "a": "#2d7b49",
      "b": "#5f7d1c",
      "ink": "#f5f1e8"
    }
  },
  {
    "key": "bracket-orbit",
    "name": "Bracket Orbit",
    "desc": "Brackets rotate around the pointer.",
    "kind": "bracket",
    "cat_id": "code-data",
    "cat_num": "06",
    "cat_title": "Code & Data",
    "cat_desc": "Syntax tokens, binary rain, terminal cursor and matrix effects.",
    "cat_icon": "{}",
    "index": 5,
    "dark": {
      "a": "#61d9ff",
      "b": "#c89cff",
      "ink": "#ffffff"
    },
    "light": {
      "a": "#337583",
      "b": "#6b4d9e",
      "ink": "#15191e"
    }
  },
  {
    "key": "fireflies",
    "name": "Fireflies",
    "desc": "Glowing fireflies float with soft trails.",
    "kind": "firefly",
    "cat_id": "nature-motion",
    "cat_num": "07",
    "cat_title": "Nature Motion",
    "cat_desc": "Fireflies, leaf spin, snow crystals, rain streaks and petals.",
    "cat_icon": "N",
    "index": 1,
    "dark": {
      "a": "#fff58a",
      "b": "#b9ff34",
      "ink": "#07100b"
    },
    "light": {
      "a": "#9a8427",
      "b": "#6b8a2c",
      "ink": "#15191e"
    }
  },
  {
    "key": "leaf-spin",
    "name": "Leaf Spin",
    "desc": "Leaf-like marks spin away from the cursor.",
    "kind": "leaf",
    "cat_id": "nature-motion",
    "cat_num": "07",
    "cat_title": "Nature Motion",
    "cat_desc": "Fireflies, leaf spin, snow crystals, rain streaks and petals.",
    "cat_icon": "N",
    "index": 2,
    "dark": {
      "a": "#5cf28b",
      "b": "#b9ff34",
      "ink": "#07100b"
    },
    "light": {
      "a": "#2d7b49",
      "b": "#6b8a2c",
      "ink": "#15191e"
    }
  },
  {
    "key": "snow-crystal",
    "name": "Snow Crystal",
    "desc": "Small crystal flakes drift and rotate.",
    "kind": "snow",
    "cat_id": "nature-motion",
    "cat_num": "07",
    "cat_title": "Nature Motion",
    "cat_desc": "Fireflies, leaf spin, snow crystals, rain streaks and petals.",
    "cat_icon": "N",
    "index": 3,
    "dark": {
      "a": "#e7f6ff",
      "b": "#9fdfff",
      "ink": "#111827"
    },
    "light": {
      "a": "#82929b",
      "b": "#5d7f8b",
      "ink": "#15191e"
    }
  },
  {
    "key": "rain-streak",
    "name": "Rain Streak",
    "desc": "Thin rain lines drop quickly downward.",
    "kind": "rain",
    "cat_id": "nature-motion",
    "cat_num": "07",
    "cat_title": "Nature Motion",
    "cat_desc": "Fireflies, leaf spin, snow crystals, rain streaks and petals.",
    "cat_icon": "N",
    "index": 4,
    "dark": {
      "a": "#6ee7ff",
      "b": "#d8f8ff",
      "ink": "#111827"
    },
    "light": {
      "a": "#3b7882",
      "b": "#b6cfd5",
      "ink": "#15191e"
    }
  },
  {
    "key": "petal-drift",
    "name": "Petal Drift",
    "desc": "Petal shapes drift gently in the air.",
    "kind": "petal",
    "cat_id": "nature-motion",
    "cat_num": "07",
    "cat_title": "Nature Motion",
    "cat_desc": "Fireflies, leaf spin, snow crystals, rain streaks and petals.",
    "cat_icon": "N",
    "index": 5,
    "dark": {
      "a": "#ff9bc6",
      "b": "#ffd7e8",
      "ink": "#111827"
    },
    "light": {
      "a": "#a54e70",
      "b": "#bd879a",
      "ink": "#15191e"
    }
  },
  {
    "key": "keycap-pop",
    "name": "Keycap Pop",
    "desc": "Tiny keycaps lift and fade.",
    "kind": "keycap",
    "cat_id": "ui-objects",
    "cat_num": "08",
    "cat_title": "UI Objects",
    "cat_desc": "Keycaps, app cards, windows, toggles and magnetic cards.",
    "cat_icon": "UI",
    "index": 1,
    "dark": {
      "a": "#f5f1e8",
      "b": "#b9ff34",
      "ink": "#111827"
    },
    "light": {
      "a": "#d0c7b7",
      "b": "#6b8a2c",
      "ink": "#15191e"
    }
  },
  {
    "key": "app-vault-cards",
    "name": "App Vault Cards",
    "desc": "Three app cards rise like your essentials preview.",
    "kind": "vault",
    "cat_id": "ui-objects",
    "cat_num": "08",
    "cat_title": "UI Objects",
    "cat_desc": "Keycaps, app cards, windows, toggles and magnetic cards.",
    "cat_icon": "UI",
    "index": 2,
    "dark": {
      "a": "#b9ff34",
      "b": "#ffffff",
      "ink": "#0d121a"
    },
    "light": {
      "a": "#66832d",
      "b": "#ffffff",
      "ink": "#16191f"
    }
  },
  {
    "key": "window-stack",
    "name": "Window Stack",
    "desc": "Mini windows stack and slide out.",
    "kind": "window",
    "cat_id": "ui-objects",
    "cat_num": "08",
    "cat_title": "UI Objects",
    "cat_desc": "Keycaps, app cards, windows, toggles and magnetic cards.",
    "cat_icon": "UI",
    "index": 3,
    "dark": {
      "a": "#61d9ff",
      "b": "#f5f1e8",
      "ink": "#111827"
    },
    "light": {
      "a": "#337583",
      "b": "#c7c0b1",
      "ink": "#15191e"
    }
  },
  {
    "key": "toggle-switch",
    "name": "Toggle Switch",
    "desc": "Small toggle pills blink between on and off.",
    "kind": "toggle",
    "cat_id": "ui-objects",
    "cat_num": "08",
    "cat_title": "UI Objects",
    "cat_desc": "Keycaps, app cards, windows, toggles and magnetic cards.",
    "cat_icon": "UI",
    "index": 4,
    "dark": {
      "a": "#b9ff34",
      "b": "#61d9ff",
      "ink": "#111827"
    },
    "light": {
      "a": "#6b8a2c",
      "b": "#337583",
      "ink": "#15191e"
    }
  },
  {
    "key": "card-magnet",
    "name": "Card Magnet",
    "desc": "Cards pull inward like magnetic UI pieces.",
    "kind": "magnet",
    "cat_id": "ui-objects",
    "cat_num": "08",
    "cat_title": "UI Objects",
    "cat_desc": "Keycaps, app cards, windows, toggles and magnetic cards.",
    "cat_icon": "UI",
    "index": 5,
    "dark": {
      "a": "#c89cff",
      "b": "#f5f1e8",
      "ink": "#111827"
    },
    "light": {
      "a": "#6b4d9e",
      "b": "#c7c0b1",
      "ink": "#15191e"
    }
  },
  {
    "key": "cb-ash-spiral",
    "name": "Ash Spiral",
    "desc": "Ash dots spiral outward like burnt paper.",
    "kind": "coldboot-rich",
    "mode": "ashSpiral",
    "cat_id": "addon-ash-smoke",
    "cat_num": "09",
    "cat_title": "Ash & Smoke",
    "cat_desc": "Dry ash, soot, vapor, cinder and ember-style cursor motion.",
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
    "key": "cb-ember-veil",
    "name": "Ember Veil",
    "desc": "Warm ember specks lift and vanish in a loose veil.",
    "kind": "coldboot-rich",
    "mode": "emberVeil",
    "cat_id": "addon-ash-smoke",
    "cat_num": "09",
    "cat_title": "Ash & Smoke",
    "cat_desc": "Dry ash, soot, vapor, cinder and ember-style cursor motion.",
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
    "key": "cb-smoke-knot",
    "name": "Smoke Knot",
    "desc": "Soft smoke blobs fold around the cursor before fading.",
    "kind": "coldboot-rich",
    "mode": "smokeKnot",
    "cat_id": "addon-ash-smoke",
    "cat_num": "09",
    "cat_title": "Ash & Smoke",
    "cat_desc": "Dry ash, soot, vapor, cinder and ember-style cursor motion.",
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
    "key": "cb-cinder-lift",
    "name": "Cinder Lift",
    "desc": "Sharp cinder flakes rise with a dry upward pull.",
    "kind": "coldboot-rich",
    "mode": "cinderLift",
    "cat_id": "addon-ash-smoke",
    "cat_num": "09",
    "cat_title": "Ash & Smoke",
    "cat_desc": "Dry ash, soot, vapor, cinder and ember-style cursor motion.",
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
    "key": "cb-soot-comet",
    "name": "Soot Comet",
    "desc": "Dark soot marks shoot away with a tiny comet tail.",
    "kind": "coldboot-rich",
    "mode": "sootComet",
    "cat_id": "addon-ash-smoke",
    "cat_num": "09",
    "cat_title": "Ash & Smoke",
    "cat_desc": "Dry ash, soot, vapor, cinder and ember-style cursor motion.",
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
    "key": "cb-burnt-pollen",
    "name": "Burnt Pollen",
    "desc": "Small pollen-like ash clusters scatter in uneven groups.",
    "kind": "coldboot-rich",
    "mode": "burntPollen",
    "cat_id": "addon-ash-smoke",
    "cat_num": "09",
    "cat_title": "Ash & Smoke",
    "cat_desc": "Dry ash, soot, vapor, cinder and ember-style cursor motion.",
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
    "key": "cb-charcoal-rain",
    "name": "Charcoal Rain",
    "desc": "Muted charcoal grains fall down with gravity.",
    "kind": "coldboot-rich",
    "mode": "charcoalRain",
    "cat_id": "addon-ash-smoke",
    "cat_num": "09",
    "cat_title": "Ash & Smoke",
    "cat_desc": "Dry ash, soot, vapor, cinder and ember-style cursor motion.",
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
    "key": "cb-vapor-stitch",
    "name": "Vapor Stitch",
    "desc": "Broken vapor stitches trail behind the pointer.",
    "kind": "coldboot-rich",
    "mode": "vaporStitch",
    "cat_id": "addon-ash-smoke",
    "cat_num": "09",
    "cat_title": "Ash & Smoke",
    "cat_desc": "Dry ash, soot, vapor, cinder and ember-style cursor motion.",
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
    "key": "cb-ghost-ash",
    "name": "Ghost Ash",
    "desc": "Pale ghost-ash rings drift and dissolve slowly.",
    "kind": "coldboot-rich",
    "mode": "ghostAsh",
    "cat_id": "addon-ash-smoke",
    "cat_num": "09",
    "cat_title": "Ash & Smoke",
    "cat_desc": "Dry ash, soot, vapor, cinder and ember-style cursor motion.",
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
    "key": "cb-coal-flicker",
    "name": "Coal Flicker",
    "desc": "Tiny coal sparks flicker close to the cursor.",
    "kind": "coldboot-rich",
    "mode": "coalFlicker",
    "cat_id": "addon-ash-smoke",
    "cat_num": "09",
    "cat_title": "Ash & Smoke",
    "cat_desc": "Dry ash, soot, vapor, cinder and ember-style cursor motion.",
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
    "key": "cb-fractured-cursor",
    "name": "Fractured Cursor",
    "desc": "Cursor-arrow fragments split away from the pointer.",
    "kind": "coldboot-rich",
    "mode": "fracturedCursor",
    "cat_id": "addon-structure",
    "cat_num": "10",
    "cat_title": "Signature Structure",
    "cat_desc": "Grids, brackets, cursor ghosts and structural cursor marks.",
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
    "key": "cb-hinge-bracket",
    "name": "Hinge Bracket",
    "desc": "Four hinged brackets fold open around the cursor.",
    "kind": "coldboot-rich",
    "mode": "hingeBracket",
    "cat_id": "addon-structure",
    "cat_num": "10",
    "cat_title": "Signature Structure",
    "cat_desc": "Grids, brackets, cursor ghosts and structural cursor marks.",
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
    "key": "cb-dotted-lasso",
    "name": "Dotted Lasso",
    "desc": "A dotted rope circle wraps and breaks apart.",
    "kind": "coldboot-rich",
    "mode": "dottedLasso",
    "cat_id": "addon-structure",
    "cat_num": "10",
    "cat_title": "Signature Structure",
    "cat_desc": "Grids, brackets, cursor ghosts and structural cursor marks.",
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
    "key": "cb-blueprint-corner",
    "name": "Blueprint Corner",
    "desc": "Technical blueprint corners draw and fade.",
    "kind": "coldboot-rich",
    "mode": "blueprintCorner",
    "cat_id": "addon-structure",
    "cat_num": "10",
    "cat_title": "Signature Structure",
    "cat_desc": "Grids, brackets, cursor ghosts and structural cursor marks.",
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
    "key": "cb-ruler-snap",
    "name": "Ruler Snap",
    "desc": "Tiny ruler ticks snap in measured steps.",
    "kind": "coldboot-rich",
    "mode": "rulerSnap",
    "cat_id": "addon-structure",
    "cat_num": "10",
    "cat_title": "Signature Structure",
    "cat_desc": "Grids, brackets, cursor ghosts and structural cursor marks.",
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
    "key": "cb-folded-grid",
    "name": "Folded Grid",
    "desc": "Small grid tiles flip like folded panels.",
    "kind": "coldboot-rich",
    "mode": "foldedGrid",
    "cat_id": "addon-structure",
    "cat_num": "10",
    "cat_title": "Signature Structure",
    "cat_desc": "Grids, brackets, cursor ghosts and structural cursor marks.",
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
    "key": "cb-anchor-pin",
    "name": "Anchor Pin",
    "desc": "A small pin drops with a grounded pulse.",
    "kind": "coldboot-rich",
    "mode": "anchorPin",
    "cat_id": "addon-structure",
    "cat_num": "10",
    "cat_title": "Signature Structure",
    "cat_desc": "Grids, brackets, cursor ghosts and structural cursor marks.",
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
    "key": "cb-cross-section",
    "name": "Cross Section",
    "desc": "Cross-hatched section lines slice through the cursor.",
    "kind": "coldboot-rich",
    "mode": "crossSection",
    "cat_id": "addon-structure",
    "cat_num": "10",
    "cat_title": "Signature Structure",
    "cat_desc": "Grids, brackets, cursor ghosts and structural cursor marks.",
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
    "key": "cb-orbit-stamp",
    "name": "Orbit Stamp",
    "desc": "A square stamp rotates with dusty edges.",
    "kind": "coldboot-rich",
    "mode": "orbitStamp",
    "cat_id": "addon-structure",
    "cat_num": "10",
    "cat_title": "Signature Structure",
    "cat_desc": "Grids, brackets, cursor ghosts and structural cursor marks.",
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
    "key": "cb-elastic-box",
    "name": "Elastic Box",
    "desc": "A box stretches and rebounds around movement.",
    "kind": "coldboot-rich",
    "mode": "elasticBox",
    "cat_id": "addon-structure",
    "cat_num": "10",
    "cat_title": "Signature Structure",
    "cat_desc": "Grids, brackets, cursor ghosts and structural cursor marks.",
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
    "key": "cb-pulse-beacon",
    "name": "Pulse Beacon",
    "desc": "A beacon dot sends two clean pulse rings.",
    "kind": "coldboot-rich",
    "mode": "pulseBeacon",
    "cat_id": "addon-energy",
    "cat_num": "11",
    "cat_title": "Signal & Energy",
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
    "key": "cb-wave-ladder",
    "name": "Wave Ladder",
    "desc": "A ladder of waveform bars rises around the cursor.",
    "kind": "coldboot-rich",
    "mode": "waveLadder",
    "cat_id": "addon-energy",
    "cat_num": "11",
    "cat_title": "Signal & Energy",
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
    "key": "cb-signal-fan",
    "name": "Signal Fan",
    "desc": "Signal arcs fan out from one side of the pointer.",
    "kind": "coldboot-rich",
    "mode": "signalFan",
    "cat_id": "addon-energy",
    "cat_num": "11",
    "cat_title": "Signal & Energy",
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
    "key": "cb-electric-fork",
    "name": "Electric Fork",
    "desc": "Forked electric branches snap outward.",
    "kind": "coldboot-rich",
    "mode": "electricFork",
    "cat_id": "addon-energy",
    "cat_num": "11",
    "cat_title": "Signal & Energy",
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
    "key": "cb-sonar-bubble",
    "name": "Sonar Bubble",
    "desc": "A sonar bubble expands with small echo dots.",
    "kind": "coldboot-rich",
    "mode": "sonarBubble",
    "cat_id": "addon-energy",
    "cat_num": "11",
    "cat_title": "Signal & Energy",
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
    "key": "cb-phase-rings",
    "name": "Phase Rings",
    "desc": "Two offset phase rings pass through each other.",
    "kind": "coldboot-rich",
    "mode": "phaseRings",
    "cat_id": "addon-energy",
    "cat_num": "11",
    "cat_title": "Signal & Energy",
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
    "key": "cb-storm-ticks",
    "name": "Storm Ticks",
    "desc": "Short storm ticks rotate in broken bursts.",
    "kind": "coldboot-rich",
    "mode": "stormTicks",
    "cat_id": "addon-energy",
    "cat_num": "11",
    "cat_title": "Signal & Energy",
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
    "key": "cb-voltage-teeth",
    "name": "Voltage Teeth",
    "desc": "Small zigzag teeth jump away from the cursor.",
    "kind": "coldboot-rich",
    "mode": "voltageTeeth",
    "cat_id": "addon-energy",
    "cat_num": "11",
    "cat_title": "Signal & Energy",
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
    "key": "cb-ripple-gate",
    "name": "Ripple Gate",
    "desc": "Two gate lines open while ripples pass through.",
    "kind": "coldboot-rich",
    "mode": "rippleGate",
    "cat_id": "addon-energy",
    "cat_num": "11",
    "cat_title": "Signal & Energy",
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
    "key": "cb-light-drift",
    "name": "Light Drift",
    "desc": "Soft light motes drift slowly behind movement.",
    "kind": "coldboot-rich",
    "mode": "lightDrift",
    "cat_id": "addon-energy",
    "cat_num": "11",
    "cat_title": "Signal & Energy",
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
    "key": "u80-caliper-snap",
    "name": "Caliper Snap",
    "desc": "Two measuring jaws close and release around the pointer.",
    "kind": "ultra80",
    "mode": "caliperSnap",
    "cat_id": "u80-precision-instruments",
    "cat_num": "12",
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
    "cat_num": "12",
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
    "cat_num": "12",
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
    "cat_num": "12",
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
    "cat_num": "12",
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
    "cat_num": "12",
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
    "cat_num": "12",
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
    "cat_num": "12",
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
    "cat_num": "12",
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
    "cat_num": "12",
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
    "cat_num": "13",
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
    "cat_num": "13",
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
    "cat_num": "13",
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
    "cat_num": "13",
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
    "cat_num": "13",
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
    "cat_num": "13",
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
    "cat_num": "13",
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
    "cat_num": "13",
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
    "cat_num": "13",
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
    "cat_num": "13",
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
  }
];
