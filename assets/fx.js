const COLD_FX = (() => {
  const tails = new WeakMap();
  const rand = (a, b) => a + Math.random() * (b - a);
  const pick = (list) => list[Math.floor(Math.random() * list.length)];

  function palette(effect) {
    const theme = document.documentElement.getAttribute("data-theme") === "light" ? "light" : "dark";
    return effect[theme] || effect.dark || { a: "#b9ff34", b: "#fff", ink: "#111" };
  }

  function add(layer, className, x, y, effect, text = "") {
    const p = palette(effect);
    const node = document.createElement("span");
    node.className = `fx-piece ${className}`;
    node.textContent = text;
    node.style.left = `${x}px`;
    node.style.top = `${y}px`;
    node.style.setProperty("--a", p.a);
    node.style.setProperty("--b", p.b);
    node.style.setProperty("--ink", p.ink);
    layer.appendChild(node);
    return node;
  }

  function css(node, values) { Object.entries(values).forEach(([k, v]) => node.style.setProperty(k, v)); }
  function removeAfter(node, ms) { setTimeout(() => node.remove(), ms + 80); }
  function drift(node, dx, dy, duration = 900, scale = 1.3, rot = 0) {
    css(node, { "--dx": `${dx}px`, "--dy": `${dy}px`, "--sc": scale, "--rot": `${rot}deg` });
    node.style.animation = `fxDrift ${duration}ms ease-out forwards`;
    removeAfter(node, duration);
  }
  function grow(node, duration = 900) { node.style.animation = `fxGrow ${duration}ms ease-out forwards`; removeAfter(node, duration); }
  function drop(node, dx, dy, duration = 900, rot = 0) {
    css(node, { "--dx": `${dx}px`, "--dy": `${dy}px`, "--rot": `${rot}deg` });
    node.style.animation = `fxDrop ${duration}ms cubic-bezier(.16,.82,.28,1) forwards`;
    removeAfter(node, duration);
  }
  function flip(node, dx, dy, duration = 850, rot = 0) {
    css(node, { "--dx": `${dx}px`, "--dy": `${dy}px`, "--rot": `${rot}deg` });
    node.style.animation = `fxFlip ${duration}ms ease-out forwards`;
    removeAfter(node, duration);
  }
  function updateTail(layer, key, effect, x, y, count, className, options = {}) {
    let store = tails.get(layer);

    const spacing = options.spacing || 12;
    const follow = options.follow == null ? 1 : options.follow;
    const rigidity = options.rigidity || .92;
    const iterations = options.iterations || 3;
    const waveAmount = options.wave || 0;
    const baseW = options.baseW || 17;
    const baseH = options.baseH || 9;
    const shrink = options.shrink || .12;

    if (!store || store.key !== key) {
      clear(layer);

      store = {
        key,
        parts: [],
        angle: 0,
        lastX: x,
        lastY: y
      };

      for (let i = 0; i < count; i++) {
        const node = add(layer, className(i), 0, 0, effect);

        /* Important:
           add() normally writes left/top = cursor position because normal particles
           animate from left/top. A snake uses transform coordinates instead.
           If left/top is not reset to 0, the snake position becomes doubled and
           feels far away from the pointer.
        */
        node.style.left = "0px";
        node.style.top = "0px";

        node.dataset.x = String(x - i * spacing);
        node.dataset.y = String(y);
        node.dataset.angle = "0";
        node.style.opacity = "1";

        const w = Math.max(8, baseW - i * shrink);
        const h = Math.max(6, baseH - i * .05);
        css(node, {
          "--w": `${w}px`,
          "--h": `${h}px`,
          "--snake-i": i
        });

        store.parts.push(node);
      }

      tails.set(layer, store);
    }

    const head = store.parts[0];
    const oldHeadX = Number(head.dataset.x) || x;
    const oldHeadY = Number(head.dataset.y) || y;

    const headX = oldHeadX + (x - oldHeadX) * follow;
    const headY = oldHeadY + (y - oldHeadY) * follow;

    let headAngle = Math.atan2(headY - oldHeadY, headX - oldHeadX);
    if (!Number.isFinite(headAngle) || Math.abs(headX - oldHeadX) + Math.abs(headY - oldHeadY) < .05) {
      headAngle = store.angle || 0;
    }

    store.angle = headAngle;
    store.lastX = headX;
    store.lastY = headY;

    head.dataset.x = String(headX);
    head.dataset.y = String(headY);
    head.dataset.angle = String(headAngle);

    for (let pass = 0; pass < iterations; pass++) {
      for (let i = 1; i < store.parts.length; i++) {
        const prev = store.parts[i - 1];
        const node = store.parts[i];

        const px = Number(prev.dataset.x);
        const py = Number(prev.dataset.y);
        let cx = Number(node.dataset.x);
        let cy = Number(node.dataset.y);

        let dx = cx - px;
        let dy = cy - py;
        let dist = Math.hypot(dx, dy);

        if (!Number.isFinite(dist) || dist < .001) {
          const fallbackAngle = (Number(prev.dataset.angle) || store.angle || 0) + Math.PI;
          dx = Math.cos(fallbackAngle);
          dy = Math.sin(fallbackAngle);
          dist = 1;
        }

        const nx = dx / dist;
        const ny = dy / dist;

        const targetX = px + nx * spacing;
        const targetY = py + ny * spacing;

        cx += (targetX - cx) * rigidity;
        cy += (targetY - cy) * rigidity;

        if (waveAmount && pass === iterations - 1) {
          const wave = Math.sin(performance.now() / 150 + i * .65) * waveAmount;
          cx += -ny * wave;
          cy += nx * wave;
        }

        const angle = Math.atan2(py - cy, px - cx);

        node.dataset.x = String(cx);
        node.dataset.y = String(cy);
        node.dataset.angle = String(angle);
      }
    }

    store.parts.forEach((node, i) => {
      const cx = Number(node.dataset.x);
      const cy = Number(node.dataset.y);
      const angle = Number(node.dataset.angle) || 0;

      node.style.transform = `translate(${cx}px, ${cy}px) translate(-50%,-50%) rotate(${angle * 180 / Math.PI}deg)`;
      node.style.zIndex = String(80 - i);
    });
  }
const renderers = {
    "pixel-fracture": (e,l,x,y) => { for(let i=0;i<7;i++){ const n=add(l,"fx-square",x+rand(-4,4),y+rand(-4,4),e); css(n,{"--s":`${rand(7,14)}px`,"--r":"2px"}); drift(n,rand(-56,56),rand(-44,42),650+i*28,rand(.8,1.4),rand(-160,160)); } },
    "ember-dust": (e,l,x,y) => { for(let i=0;i<6;i++){ const n=add(l,"fx-dot",x+rand(-6,6),y+rand(-6,6),e); css(n,{"--s":`${rand(5,13)}px`}); drift(n,rand(-30,30),rand(-82,-20),900+i*40,rand(.8,1.7),rand(-90,90)); } },
    "orbit-sparks": (e,l,x,y) => { for(let i=0;i<5;i++){ const n=add(l,"fx-dot",x,y,e); const a=(Math.PI*2/5)*i; css(n,{"--s":`${rand(7,12)}px`}); drift(n,Math.cos(a)*rand(42,72),Math.sin(a)*rand(42,72),780,1.1,0); } const r=add(l,"fx-ring",x,y,e); css(r,{"--s":"70px"}); grow(r,740); },
    "pollen-field": (e,l,x,y) => { for(let i=0;i<9;i++){ const n=add(l,"fx-dot",x+rand(-20,20),y+rand(-20,20),e); css(n,{"--s":`${rand(4,10)}px`}); drift(n,rand(-38,38),rand(-52,24),1200,rand(1.2,2.1),rand(-70,70)); } },
    "prism-confetti": (e,l,x,y) => { for(let i=0;i<6;i++){ const n=add(l,i%2?"fx-tri":"fx-square",x,y,e); css(n,{"--s":`${rand(8,14)}px`}); drift(n,rand(-52,52),rand(-46,40),860,rand(.9,1.4),rand(-220,220)); } },
    "ghost-ribbon": (e,l,x,y) => { for(let i=0;i<3;i++){ const n=add(l,"fx-line",x-i*12,y+i*5,e); css(n,{"--w":`${rand(68,108)}px`,"--h":"4px"}); drift(n,rand(-28,28),rand(-18,18),780+i*80,1,rand(-24,24)); } },
    "comet-thread": (e,l,x,y) => { const n=add(l,"fx-line",x,y,e); css(n,{"--w":"128px","--h":"3px"}); drift(n,rand(54,94),rand(-14,14),650,1,rand(-12,12)); const d=add(l,"fx-dot",x,y,e); css(d,{"--s":"14px"}); drift(d,rand(40,72),rand(-12,12),620,1.1,0); },
    "ink-silk": (e,l,x,y) => { for(let i=0;i<4;i++){ const n=add(l,"fx-blob",x+rand(-6,6),y+rand(-6,6),e); css(n,{"--s":`${rand(18,38)}px`}); drift(n,rand(-34,28),rand(-22,36),1050,rand(1.2,1.8),rand(-80,80)); } },
    "halo-pulse": (e,l,x,y) => { for(let i=0;i<2;i++){ const n=add(l,"fx-ring",x,y,e); css(n,{"--s":`${70+i*42}px`}); grow(n,900+i*180); } },
    "elastic-line": (e,l,x,y) => { for(let i=0;i<2;i++){ const n=add(l,"fx-line",x,y,e); css(n,{"--w":`${rand(86,126)}px`,"--h":"3px"}); drift(n,rand(-32,32),rand(-18,18),720,1,rand(-48,48)); } },
    "spine-serpent": (e,l,x,y) => updateTail(l,"spine-serpent",e,x,y,24,(i)=>`fx-snake ${i===0?"head":""}`,{follow:1,rigidity:.96,iterations:4,spacing:12,wave:.22,baseW:16,baseH:9,shrink:.08}),
    "neon-centipede": (e,l,x,y) => updateTail(l,"neon-centipede",e,x,y,20,(i)=>`fx-snake ${i===0?"head":""}`,{follow:.98,rigidity:.93,iterations:3,spacing:11,wave:.9,baseW:15,baseH:8,shrink:.1}),
    "jelly-larva": (e,l,x,y) => updateTail(l,"jelly-larva",e,x,y,16,()=>"fx-blob",{follow:.94,rigidity:.86,iterations:3,spacing:13,wave:1.4,baseW:17,baseH:10,shrink:.15}),
    "beetle-steps": (e,l,x,y) => { for(let i=0;i<2;i++){ const side=i?1:-1; const n=add(l,"fx-line",x+side*11,y,e); css(n,{"--w":"18px","--h":"3px"}); drift(n,side*rand(16,32),rand(14,32),650,1,side*rand(20,60)); } },
    "fish-chain": (e,l,x,y) => updateTail(l,"fish-chain",e,x,y,15,(i)=> i===0?"fx-tri":"fx-dot",{follow:.96,rigidity:.9,iterations:3,spacing:13,wave:1.8,baseW:16,baseH:8,shrink:.1}),
    "smoke-bloom": (e,l,x,y) => { for(let i=0;i<2;i++){ const n=add(l,"fx-smoke",x+rand(-8,8),y+rand(-8,8),e); css(n,{"--s":`${rand(52,94)}px`}); drift(n,rand(-26,26),rand(-74,-28),1300,rand(1.2,1.8),rand(-30,30)); } },
    "ink-drop": (e,l,x,y) => { const n=add(l,"fx-blob",x,y,e); css(n,{"--s":`${rand(56,86)}px`}); drift(n,rand(-12,12),rand(14,34),1000,1.8,rand(-20,20)); },
    "water-ripple": (e,l,x,y) => { for(let i=0;i<2;i++){ const n=add(l,"fx-ring",x,y,e); css(n,{"--s":`${58+i*30}px`}); grow(n,820+i*130); } for(let i=0;i<4;i++){ const d=add(l,"fx-dot",x,y,e); css(d,{"--s":`${rand(5,9)}px`}); drift(d,rand(-44,44),rand(-38,38),760,1,0); } },
    "vapor-curl": (e,l,x,y) => { for(let i=0;i<3;i++){ const n=add(l,"fx-smoke",x+rand(-10,10),y+rand(-10,10),e); css(n,{"--s":`${rand(34,64)}px`}); drift(n,rand(-48,48),rand(-82,-32),1200,rand(1.4,2),rand(-70,70)); } },
    "oil-cell": (e,l,x,y) => { for(let i=0;i<2;i++){ const n=add(l,"fx-blob",x+rand(-8,8),y+rand(-8,8),e); css(n,{"--s":`${rand(46,78)}px`}); drift(n,rand(-28,28),rand(-32,28),1180,rand(1.2,1.7),rand(-120,120)); } },
    "portal-ring": (e,l,x,y) => { for(let i=0;i<3;i++){ const n=add(l,"fx-ring",x,y,e); css(n,{"--s":`${44+i*32}px`}); grow(n,780+i*130); } },
    "laser-slice": (e,l,x,y) => { for(let i=0;i<3;i++){ const n=add(l,"fx-line",x,y+rand(-20,20),e); css(n,{"--w":`${rand(96,150)}px`,"--h":"2px"}); drift(n,rand(48,96),rand(-6,6),520+i*50,1,rand(-8,8)); } },
    "scan-grid": (e,l,x,y) => { const line=add(l,"fx-line",x,y,e); css(line,{"--w":"160px","--h":"4px"}); drift(line,0,rand(28,46),650,1,0); for(let i=0;i<8;i++){ const n=add(l,"fx-square",x+rand(-58,58),y+rand(-28,28),e); css(n,{"--s":"6px","--r":"1px"}); drift(n,rand(-14,14),rand(-12,26),760,1,0); } },
    "triangle-swarm": (e,l,x,y) => { for(let i=0;i<6;i++){ const n=add(l,"fx-tri",x,y,e); drift(n,rand(-60,60),rand(-54,46),900,rand(.8,1.3),rand(-260,260)); } },
    "cube-pop": (e,l,x,y) => { for(let i=0;i<4;i++){ const n=add(l,"fx-card",x+rand(-4,4),y+rand(-4,4),e,"BOX"); css(n,{"--w":"38px","--h":"32px"}); drift(n,rand(-46,46),rand(-42,34),820,1,rand(-28,28)); } },
    "token-burst": (e,l,x,y) => { ["JS","CSS","{}","API"].forEach((t,i)=>{ const n=add(l,"fx-text",x,y,e,t); css(n,{"--s":`${rand(12,16)}px`}); drift(n,rand(-56,56),rand(-48,38),780+i*45,1,rand(-20,20)); }); },
    "binary-rain": (e,l,x,y) => { for(let i=0;i<7;i++){ const n=add(l,"fx-text",x+rand(-34,34),y+rand(-10,10),e,pick(["0","1","01"])); css(n,{"--s":"13px"}); drop(n,rand(-8,8),rand(48,104),900,0); } },
    "terminal-caret": (e,l,x,y) => { [">","$","_","run"].forEach((t,i)=>{ const n=add(l,"fx-text",x+i*12,y+rand(-8,8),e,t); css(n,{"--s":"14px"}); drift(n,rand(-20,24),rand(-36,24),760,1,0); }); },
    "matrix-beads": (e,l,x,y) => { for(let c=0;c<3;c++){ for(let r=0;r<4;r++){ const n=add(l,"fx-text",x+c*16-16,y+r*16,e,pick(["0","1"])); css(n,{"--s":"12px"}); drop(n,0,rand(44,86),900+r*40,0); } } },
    "bracket-orbit": (e,l,x,y) => { ["[ ]","{ }","( )"].forEach((t,i)=>{ const a=i*Math.PI*2/3; const n=add(l,"fx-text",x,y,e,t); css(n,{"--s":"14px"}); drift(n,Math.cos(a)*58,Math.sin(a)*48,860,1,rand(-90,90)); }); },
    "fireflies": (e,l,x,y) => { for(let i=0;i<6;i++){ const n=add(l,"fx-dot",x+rand(-20,20),y+rand(-20,20),e); css(n,{"--s":`${rand(5,9)}px`}); drift(n,rand(-44,44),rand(-62,20),1200,rand(1.1,1.6),0); } },
    "leaf-spin": (e,l,x,y) => { for(let i=0;i<4;i++){ const n=add(l,"fx-blob",x,y,e); css(n,{"--s":"24px"}); drift(n,rand(-54,54),rand(-58,34),950,1,rand(-260,260)); } },
    "snow-crystal": (e,l,x,y) => { for(let i=0;i<5;i++){ const n=add(l,"fx-text",x+rand(-8,8),y+rand(-8,8),e,"*"); css(n,{"--s":`${rand(12,18)}px`}); drop(n,rand(-38,38),rand(34,78),1100,rand(-180,180)); } },
    "rain-streak": (e,l,x,y) => { for(let i=0;i<5;i++){ const n=add(l,"fx-line",x+rand(-38,38),y+rand(-20,10),e); css(n,{"--w":"3px","--h":"32px"}); drop(n,rand(-6,8),rand(70,132),650,8); } },
    "petal-drift": (e,l,x,y) => { for(let i=0;i<4;i++){ const n=add(l,"fx-blob",x,y,e); css(n,{"--s":"28px"}); drift(n,rand(-56,56),rand(-64,36),1200,1,rand(-180,180)); } },
    "keycap-pop": (e,l,x,y) => { ["TAB","JS","CSS"].forEach((t,i)=>{ const n=add(l,"fx-key",x,y,e,t); css(n,{"--w":"48px","--h":"32px"}); drift(n,rand(-48,48),rand(-52,28),850,1,rand(-16,16)); }); },
    "app-vault-cards": (e,l,x,y) => { [[-58,14,-8,"QR"],[0,-18,0,"ZIP"],[58,14,8,"APP"]].forEach(([ox,oy,rot,t],i)=>{ const n=add(l,"fx-card",x+ox*.18,y+oy*.18,e,t); css(n,{"--w":"82px","--h":"70px"}); drift(n,ox,oy-18,980+i*120,1.04,rot); }); },
    "window-stack": (e,l,x,y) => { [0,1,2].forEach((_,i)=>{ const n=add(l,"fx-card",x+i*10,y+i*8,e,"WIN"); css(n,{"--w":"64px","--h":"42px"}); drift(n,rand(-20,40),rand(-38,24),850+i*80,1,rand(-10,10)); }); },
    "toggle-switch": (e,l,x,y) => { ["ON","OFF"].forEach((t,i)=>{ const n=add(l,"fx-key",x+i*18,y,e,t); css(n,{"--w":"56px","--h":"28px"}); drift(n,rand(-28,28),rand(-46,24),760,1,0); }); },
    "card-magnet": (e,l,x,y) => { for(let i=0;i<4;i++){ const n=add(l,"fx-card",x+rand(-80,80),y+rand(-60,60),e,"UI"); css(n,{"--w":"52px","--h":"36px"}); drift(n,rand(-12,12),rand(-12,12),720,.25,rand(-8,8)); } },
    "dollar-spread": (e,l,x,y) => { for(let i=0;i<5;i++){ const n=add(l,"fx-text",x+rand(-5,5),y+rand(-5,5),e,pick(["$","$","BDT"])); css(n,{"--s":`${rand(14,22)}px`}); const a=rand(0,Math.PI*2),d=rand(34,86); drift(n,Math.cos(a)*d,Math.sin(a)*d-rand(10,30),760+i*30,1.1,rand(-34,34)); } },
    "coin-flip": (e,l,x,y) => { for(let i=0;i<4;i++){ const n=add(l,"fx-dot",x,y,e); css(n,{"--s":`${rand(18,26)}px`}); flip(n,rand(-52,52),rand(-64,24),850+i*60,rand(-40,40)); } },
    "receipt-slip": (e,l,x,y) => { for(let i=0;i<3;i++){ const n=add(l,"fx-card",x,y,e,"SLIP"); css(n,{"--w":"46px","--h":"62px"}); drift(n,rand(-48,48),rand(-54,28),900,1,rand(-22,22)); } },
    "invoice-card": (e,l,x,y) => { const n=add(l,"fx-card",x,y,e,"INV"); css(n,{"--w":"72px","--h":"52px"}); drift(n,rand(-42,42),rand(-50,24),900,1,rand(-18,18)); },
    "chart-blip": (e,l,x,y) => { [18,30,44].forEach((h,i)=>{ const n=add(l,"fx-card",x+i*12-12,y,e,""); css(n,{"--w":"9px","--h":`${h}px`}); drift(n,rand(-12,12),rand(-50,-20),780+i*60,1,0); }); }
  };

  function spawn(effect, layer, x, y) {
    const renderer = renderers[effect.key];
    if (renderer) renderer(effect, layer, x, y);
  }

  function clear(layer) {
    layer.innerHTML = "";
    tails.delete(layer);
  }

  return { spawn, clear };
})();