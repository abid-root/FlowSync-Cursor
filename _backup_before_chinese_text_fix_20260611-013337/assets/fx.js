
const COLD_FX = (() => {
  const snakeMap = new WeakMap();
  const tokenMap = {
    star:["✦","✧","✶"],
    "code-token":["JS","CSS","HTML","{}"],
    binary:["0","1","01"],
    terminal:[">","$","_"],
    bracket:["[ ]","{ }","( )"],
    prompt:["█","▌","_"],
    leaf:["🍃"],
    petal:["❧"],
    coin:["৳","$","¢"],
    "money-text":["৳","$","€"],
    keycap:["TAB","JS","CSS"],
    "mini-card":["UI","UX","CARD"],
    badge:["⚙","⌘","⌗"],
    window:["WIN"],
    toggle:["ON","OFF"],
    tile:["APP"],
    receipt:["SLIP"],
    invoice:["INV"],
    tag:["TAG"],
    chart:["▃▆"],
    cross:["✕"],
    hex:["⬡"]
  };
  const rand = (a,b) => a + Math.random() * (b - a);

  function make(layer, className, x, y, content = "") {
    const node = document.createElement('span');
    node.className = `fx-piece ${className}`;
    node.innerHTML = content;
    node.style.left = `${x}px`;
    node.style.top = `${y}px`;
    layer.appendChild(node);
    return node;
  }

  function fadeDrift(node, duration = 1200, spread = 52) {
    node.style.setProperty('--dx', `${rand(-spread, spread)}px`);
    node.style.setProperty('--dy', `${rand(-spread - 20, 24)}px`);
    node.style.setProperty('--rot', `${rand(-180, 180)}deg`);
    node.style.setProperty('--scale', `${rand(1.02, 1.82)}`);
    node.style.animation = `driftOut ${duration}ms ease-out forwards`;
    setTimeout(() => node.remove(), duration + 60);
  }

  function ringFade(node, duration = 950) {
    node.style.animation = `growFade ${duration}ms ease-out forwards`;
    setTimeout(() => node.remove(), duration + 60);
  }

  function spawn(effect, layer, x, y) {
    const kind = effect.kind;

    if (kind.startsWith('snake')) {
      let parts = snakeMap.get(layer);
      if (!parts) {
        const count = kind === 'snake-cyber' ? 11 : 14;
        parts = [];
        for (let i = 0; i < count; i++) {
          const node = make(layer, 'fx-seg', x, y);
          const size = Math.max(7, 19 - i * 0.72);
          node.style.setProperty('--s', `${size}px`);
          if (kind === 'snake-cyber') node.style.background = i === 0 ? '#fff7ea' : 'rgba(185,255,87,.72)';
          else if (kind === 'snake-soft') node.style.background = i === 0 ? '#fff7ea' : 'rgba(125,225,188,.62)';
          else if (kind === 'snake-jelly') node.style.background = 'rgba(255,255,255,.36)';
          else node.style.background = 'rgba(242,237,228,.86)';
          if (kind === 'snake-chain') node.style.borderRadius = '8px';
          node.dataset.x = x;
          node.dataset.y = y;
          parts.push(node);
        }
        snakeMap.set(layer, parts);
      }
      let tx = x;
      let ty = y;
      parts.forEach((node, index) => {
        const px = Number(node.dataset.x);
        const py = Number(node.dataset.y);
        const ease = index === 0 ? 0.28 : 0.18;
        const nx = px + (tx - px) * ease;
        const ny = py + (ty - py) * ease;
        node.dataset.x = nx;
        node.dataset.y = ny;
        node.style.transform = `translate(${nx}px, ${ny}px) translate(-50%, -50%)`;
        tx = nx;
        ty = ny;
      });
      return;
    }

    const count = ({dust:2,pixel:3,star:2,ash:2,glass:2,pollen:3,noise:4,rgb:3,matrix:3}).hasOwnProperty(kind)
      ? ({dust:2,pixel:3,star:2,ash:2,glass:2,pollen:3,noise:4,rgb:3,matrix:3})[kind]
      : 1;

    for (let i = 0; i < count; i++) {
      let className = 'fx-dot';
      let content = '';
      if (["pixel","grid","static"].includes(kind)) className = 'fx-square';
      if (["echo","halo","fogr","bubble","ring","water","portal","orbit"].includes(kind)) className = 'fx-ring';
      if (["ribbon","comet","thread","scan","laser","aurora","rope","rain","steps"].includes(kind)) className = 'fx-line';
      if (["smoke","ink","vapor"].includes(kind)) className = 'fx-smoke';
      if (["cell","metal"].includes(kind)) className = 'fx-blob';
      if (["triangle","shard"].includes(kind)) className = 'fx-triangle';
      if (tokenMap[kind]) {
        className = ['keycap','mini-card','badge','window','toggle','tile','receipt','invoice','tag','chart'].includes(kind) ? 'fx-key' : 'fx-text';
        const list = tokenMap[kind];
        content = list[Math.floor(Math.random() * list.length)];
      }
      const node = make(layer, className, x + rand(-5,5), y + rand(-5,5), content);
      node.style.transform = 'translate(-50%, -50%)';
      node.style.setProperty('--s', `${rand(9, 18)}px`);
      node.style.setProperty('--w', `${rand(42, 92)}px`);
      node.style.setProperty('--h', kind === 'rain' ? '18px' : '2px');

      if (['smoke','ink','vapor','cell','bubble'].includes(kind)) node.style.setProperty('--s', `${rand(38, 76)}px`);
      if (kind === 'ink' || kind === 'inktail') node.style.setProperty('--c', 'rgba(15,18,24,.42)');
      if (kind === 'ash') node.style.setProperty('--c', 'rgba(160,160,152,.72)');
      if (kind === 'glass') {
        node.style.setProperty('--c', 'rgba(255,255,255,.20)');
        node.style.border = '1px solid rgba(255,255,255,.44)';
      }
      if (kind === 'rgb') {
        const colors = ['#ff5b8a','#61d9ff','#b9ff57'];
        node.style.setProperty('--c', colors[Math.floor(Math.random() * colors.length)]);
      }
      if (kind === 'firefly' || kind === 'neon') {
        node.style.setProperty('--c', 'rgba(185,255,87,.95)');
        node.style.setProperty('--glow', '0 0 18px rgba(185,255,87,.75)');
      }
      if (kind === 'water') node.style.setProperty('--c', 'rgba(125,225,188,.92)');
      if (kind === 'spotlight') {
        node.style.setProperty('--s', '58px');
        node.style.background = 'rgba(255,255,255,.18)';
        node.style.filter = 'blur(6px)';
      }

      if (className === 'fx-ring') ringFade(node, kind === 'halo' ? 1150 : 950);
      else if (['scan','laser'].includes(kind)) {
        node.style.setProperty('--dx', `${rand(24, 70)}px`);
        node.style.setProperty('--dy', `${rand(-4, 4)}px`);
        node.style.animation = 'driftOut 760ms ease-out forwards';
        setTimeout(() => node.remove(), 820);
      } else if (['gravity','bounce','rain'].includes(kind)) {
        node.style.setProperty('--dx', `${rand(-30, 30)}px`);
        node.style.setProperty('--dy', `${rand(70, 130)}px`);
        node.style.setProperty('--rot', `${rand(-90, 90)}deg`);
        node.style.setProperty('--scale', `${rand(.9, 1.3)}`);
        node.style.animation = 'driftOut 1040ms cubic-bezier(.16,.8,.28,1.12) forwards';
        setTimeout(() => node.remove(), 1100);
      } else if (kind === 'magnet') {
        node.style.setProperty('--dx', `${rand(-16, 16)}px`);
        node.style.setProperty('--dy', `${rand(-16, 16)}px`);
        node.style.setProperty('--scale', '.08');
        node.style.animation = 'driftOut 900ms ease-in forwards';
        setTimeout(() => node.remove(), 940);
      } else {
        fadeDrift(node, ['smoke','ink','vapor','cell','bubble'].includes(kind) ? 1500 : 1200, ['smoke','ink','vapor','cell','bubble'].includes(kind) ? 32 : 52);
      }
    }
  }

  function clear(layer) {
    layer.innerHTML = '';
    snakeMap.delete(layer);
  }

  return { spawn, clear };
})();
