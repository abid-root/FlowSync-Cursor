
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
