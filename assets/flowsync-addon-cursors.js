
(function () {
  if (typeof COLD_FX === "undefined") return;

  const oldSpawn = COLD_FX.spawn.bind(COLD_FX);
  const oldClear = COLD_FX.clear ? COLD_FX.clear.bind(COLD_FX) : null;
  const SIGNATURE_KEYS = new Set((window.COLD_ADDON_EFFECTS || []).map((fx) => fx.key));
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

    ashSpiral(effect, layer, x, y) {
      const base = performance.now() / 260;
      for (let i = 0; i < 5; i++) {
        const a = base + i * 1.22 + rand(-.16, .16);
        const d = rand(22, 62);
        dot(layer, "sig-ash-dot", x + Math.cos(a) * 8, y + Math.sin(a) * 8, effect, rand(3,7), Math.cos(a)*d, Math.sin(a)*d-rand(22,54), 860+i*45, rand(-180,180));
      }
    },
    emberVeil(effect, layer, x, y) {
      for (let i=0;i<6;i++) line(layer,"sig-warm-ember",x+rand(-14,14),y+rand(-8,10),effect,rand(8,22),rand(-90,90),rand(-28,28),rand(-86,-28),760+i*45);
    },
    smokeKnot(effect, layer, x, y) {
      for (let i=0;i<4;i++) dot(layer,"sig-smoke-blob",x+rand(-8,8),y+rand(-8,8),effect,rand(20,44),rand(-34,34),rand(-48,8),920+i*70,rand(-90,90));
    },
    cinderLift(effect, layer, x, y) {
      for (let i=0;i<6;i++) shape(layer,"sig-cinder",x+rand(-7,7),y+rand(-7,7),effect,rand(-40,40),rand(-95,-20),720+i*35,rand(-180,180));
    },
    sootComet(effect, layer, x, y) {
      for (let i=0;i<4;i++) line(layer,"sig-soot-comet",x,y,effect,rand(26,48),rand(-30,30),rand(-70,-20),rand(-22,22),680+i*50);
    },
    burntPollen(effect, layer, x, y) {
      for (let i=0;i<8;i++) dot(layer,"sig-pollen",x+rand(-12,12),y+rand(-12,12),effect,rand(3,6),rand(-55,55),rand(-55,20),780+i*30);
    },
    charcoalRain(effect, layer, x, y) {
      for (let i=0;i<7;i++) dot(layer,"sig-charcoal",x+rand(-18,18),y+rand(-10,8),effect,rand(4,8),rand(-16,16),rand(34,86),940+i*40,rand(-100,100));
    },
    vaporStitch(effect, layer, x, y) {
      for (let i=0;i<5;i++) line(layer,"sig-vapor-stitch",x+i*6-12,y+rand(-10,10),effect,rand(12,26),rand(-20,20),rand(-36,36),rand(-28,28),700+i*35);
    },
    ghostAsh(effect, layer, x, y) {
      for (let i=0;i<3;i++) pulse(layer,"sig-ghost-ring",x+rand(-8,8),y+rand(-8,8),effect,860+i*80);
    },
    coalFlicker(effect, layer, x, y) {
      for (let i=0;i<5;i++) dot(layer,"sig-coal",x+rand(-6,6),y+rand(-6,6),effect,rand(5,10),rand(-24,24),rand(-32,12),620+i*30);
    },
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
    const basicClass = String(effect.key).replace(/^cb-basic-/, "bc-");
    node.className = "signature-basic-follow " + effect.key + " " + basicClass;
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
      if (effect.kind === "signature-basic" || effect.kind === "coldboot-basic") {
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
