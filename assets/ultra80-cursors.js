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
    caliperSnap(effect, layer, x, y) { line(layer,"u80-caliper-jaw",x-18,y,effect,36,90,-26,0,720); line(layer,"u80-caliper-jaw",x+18,y,effect,36,90,26,0,720); line(layer,"u80-caliper-bar",x,y-18,effect,60,0,0,-14,720); },
    protractorSweep(effect, layer, x, y) { shape(layer,"u80-protractor",x,y,effect,0,0,820,0,"u80Pulse"); for(let i=0;i<9;i++){let a=(-160+i*20)*Math.PI/180; line(layer,"u80-tick",x+Math.cos(a)*32,y+Math.sin(a)*32,effect,i%2?8:14,a*180/Math.PI,Math.cos(a)*22,Math.sin(a)*22,700+i*24);} },
    magnifierBloom(effect, layer, x, y) { shape(layer,"u80-magnifier",x,y,effect,0,0,780,0,"u80Pulse"); line(layer,"u80-handle",x+22,y+22,effect,28,45,25,24,780); for(let i=0;i<5;i++) dot(layer,"u80-focus-dot",x+rand(-10,10),y+rand(-10,10),effect,4,rand(-35,35),rand(-35,35),680+i*35); },
    levelBubble(effect, layer, x, y) { shape(layer,"u80-level",x,y,effect,0,0,760,0); dot(layer,"u80-level-bubble",x-20,y,effect,10,40,0,760); line(layer,"u80-level-mark",x,y,effect,70,0,0,0,760); },
    metronomeTick(effect, layer, x, y) { shape(layer,"u80-metronome-base",x,y+18,effect,0,20,820,0); line(layer,"u80-metronome-arm",x,y,effect,54,-24,-12,-30,820); dot(layer,"u80-metronome-bob",x-12,y-26,effect,9,-18,-30,820); },
    pendulumArc(effect, layer, x, y) { line(layer,"u80-pendulum-string",x,y-5,effect,52,80,28,12,860); dot(layer,"u80-pendulum-bob",x+24,y+26,effect,13,36,8,860); shape(layer,"u80-pendulum-anchor",x,y-28,effect,0,-10,760,0); },
    rulerCrawl(effect, layer, x, y) { for(let i=0;i<12;i++) line(layer,"u80-ruler-tick",x-46+i*8,y+rand(-2,2),effect,i%4===0?20:10,90,rand(-5,5),rand(-24,24),620+i*22); line(layer,"u80-ruler-base",x,y+12,effect,96,0,0,20,760); },
    barcodeWipe(effect, layer, x, y) { for(let i=0;i<12;i++){let h=rand(18,42); line(layer,"u80-barcode",x-36+i*6,y,effect,h,90,rand(-18,18),rand(-26,26),620+i*18);} line(layer,"u80-scan-beam",x,y,effect,110,0,40,0,580); },
    focusReticle(effect, layer, x, y) { [[-1,-1], [1,-1], [-1,1], [1,1]].forEach((p,i)=>shape(layer,"u80-focus-corner",x+p[0]*22,y+p[1]*22,effect,p[0]*16,p[1]*16,720+i*30,p[0]*p[1]*10)); pulse(layer,"u80-focus-ring",x,y,effect,700); },
    gaugeNeedle(effect, layer, x, y) { shape(layer,"u80-gauge",x,y,effect,0,0,760,0,"u80Pulse"); line(layer,"u80-gauge-needle",x,y,effect,38,-35,25,-12,760); for(let i=0;i<5;i++) line(layer,"u80-gauge-tick",x-24+i*12,y-18,effect,8,90,0,-18,650+i*30); },
    rubberBand(effect, layer, x, y) { shape(layer,"u80-rubber-loop",x,y,effect,0,0,820,0,"u80Elastic"); dot(layer,"u80-band-pin",x-34,y,effect,6,-34,0,720); dot(layer,"u80-band-pin",x+34,y,effect,6,34,0,720); },
    springCoil(effect, layer, x, y) { for(let i=0;i<9;i++) line(layer,"u80-spring-seg",x-32+i*8,y+Math.sin(i)*5,effect,15,i%2?55:-55,rand(-10,10),rand(-30,20),720+i*20); },
    chainLink(effect, layer, x, y) { for(let i=0;i<6;i++) shape(layer,"u80-chain-link",x-25+i*10,y+Math.sin(i)*4,effect,rand(-30,30),rand(-32,32),760+i*28,i*18); },
    pistonPush(effect, layer, x, y) { line(layer,"u80-piston-rod",x,y,effect,68,0,42,0,760); shape(layer,"u80-piston-head",x+36,y,effect,45,0,760,0); shape(layer,"u80-piston-base",x-28,y,effect,-18,0,760,0); },
    leverSnap(effect, layer, x, y) { shape(layer,"u80-lever-hinge",x-18,y+12,effect,-12,18,740,0); line(layer,"u80-lever-bar",x,y,effect,76,-22,32,-22,760); dot(layer,"u80-lever-knob",x+34,y-15,effect,9,45,-28,760); },
    pulleyRope(effect, layer, x, y) { shape(layer,"u80-pulley-wheel",x,y,effect,0,0,820,0,"u80Pulse"); line(layer,"u80-rope",x-24,y,effect,52,90,-24,35,820); line(layer,"u80-rope",x+24,y,effect,52,90,24,-35,820); },
    bearingOrbit(effect, layer, x, y) { pulse(layer,"u80-bearing-ring",x,y,effect,760); for(let i=0;i<8;i++){let a=i*Math.PI/4+performance.now()/220;dot(layer,"u80-bearing-ball",x+Math.cos(a)*26,y+Math.sin(a)*26,effect,7,Math.cos(a)*45,Math.sin(a)*45,720+i*20);} },
    boltScatter(effect, layer, x, y) { for(let i=0;i<6;i++) shape(layer,"u80-bolt",x+rand(-4,4),y+rand(-4,4),effect,rand(-55,55),rand(-50,50),760+i*35,rand(-220,220)); },
    dominoFall(effect, layer, x, y) { for(let i=0;i<6;i++) shape(layer,"u80-domino",x-28+i*11,y,effect,rand(-6,36),rand(-22,28),740+i*55,18+i*14); },
    diceTumble(effect, layer, x, y) { for(let i=0;i<4;i++) shape(layer,"u80-dice",x+rand(-6,6),y+rand(-6,6),effect,rand(-48,48),rand(-48,28),820+i*45,rand(-180,180)); },
    tooltipPop(effect, layer, x, y) { card(layer,"u80-tooltip",x,y,effect,"tip",rand(-14,14),-48,760,0); dot(layer,"u80-tooltip-tail",x,y+12,effect,6,0,-20,680); },
    dropdownFold(effect, layer, x, y) { for(let i=0;i<4;i++) card(layer,"u80-dropdown-panel",x,y+i*9,effect,"",0,30+i*10,760+i*45,0); },
    toggleOrbit(effect, layer, x, y) { shape(layer,"u80-toggle-pill",x,y,effect,0,0,760,0); dot(layer,"u80-toggle-knob",x-18,y,effect,12,38,0,760); pulse(layer,"u80-toggle-orbit",x,y,effect,740); },
    progressTicks(effect, layer, x, y) { for(let i=0;i<8;i++) line(layer,"u80-progress-tick",x-32+i*9,y,effect,12,90,rand(-6,6),rand(-42,-10),640+i*28); line(layer,"u80-progress-base",x,y+10,effect,80,0,0,10,760); },
    commandPalette(effect, layer, x, y) { card(layer,"u80-command-palette",x,y,effect,"> run",0,-30,820,0); for(let i=0;i<3;i++) line(layer,"u80-command-line",x,y-6+i*10,effect,42,0,rand(-10,10),-30+i*10,720+i*35); },
    notificationBadge(effect, layer, x, y) { card(layer,"u80-notify-card",x,y,effect,"",0,-24,800,0); dot(layer,"u80-badge",x+22,y-18,effect,13,28,-36,760); for(let i=0;i<3;i++) dot(layer,"u80-badge-dot",x,y,effect,4,rand(-32,32),rand(-40,10),680+i*30); },
    dragHandle(effect, layer, x, y) { for(let i=0;i<6;i++) dot(layer,"u80-grip-dot",x+(i%2)*8-4,y+Math.floor(i/2)*8-8,effect,4,rand(-20,20),rand(-35,35),620+i*35); },
    resizeCorners(effect, layer, x, y) { [[-1,-1],[1,-1],[-1,1],[1,1]].forEach((p,i)=>shape(layer,"u80-resize-corner",x+p[0]*18,y+p[1]*18,effect,p[0]*34,p[1]*34,720+i*30,p[0]*p[1]*45)); },
    breadcrumbTrail(effect, layer, x, y) { ["home","/","page","/","fx"].forEach((t,i)=>textMark(layer,"u80-breadcrumb",x-34+i*17,y,effect,t,rand(-8,28),rand(-35,20),720+i*35,0)); },
    windowDock(effect, layer, x, y) { for(let i=0;i<4;i++) card(layer,"u80-window-card",x-24+i*16,y,effect,"",rand(-16,16),-44-Math.abs(i-1.5)*8,780+i*35,rand(-10,10)); },
    routerPing(effect, layer, x, y) { for(let i=0;i<4;i++){let a=i*Math.PI/2; line(layer,"u80-network-line",x,y,effect,44,a*180/Math.PI,Math.cos(a)*45,Math.sin(a)*45,760+i*30); dot(layer,"u80-node",x+Math.cos(a)*25,y+Math.sin(a)*25,effect,7,Math.cos(a)*48,Math.sin(a)*48,760+i*30);} dot(layer,"u80-router-core",x,y,effect,10,0,0,560); },
    dnsPulse(effect, layer, x, y) { ["DNS","A","MX","IP"].forEach((t,i)=>textMark(layer,"u80-dns-chip",x+rand(-8,8),y+rand(-8,8),effect,t,rand(-52,52),rand(-42,42),760+i*55,0)); pulse(layer,"u80-dns-ring",x,y,effect,760); },
    firewallSparks(effect, layer, x, y) { for(let i=0;i<5;i++) line(layer,"u80-firewall-brick",x,y-14+i*7,effect,42,0,-20,rand(-5,5),720+i*20); for(let i=0;i<7;i++) dot(layer,"u80-fire-spark",x+22,y,effect,4,rand(20,58),rand(-40,40),650+i*25); },
    databaseRings(effect, layer, x, y) { for(let i=0;i<4;i++) shape(layer,"u80-db-ring",x,y-i*5,effect,0,-30-i*8,780+i*60,0); shape(layer,"u80-db-body",x,y,effect,0,-20,820,0); },
    apiBraces(effect, layer, x, y) { textMark(layer,"u80-api-brace",x-15,y,effect,"{",-38,0,720,-12); textMark(layer,"u80-api-brace",x+15,y,effect,"}",38,0,720,12); textMark(layer,"u80-api-text",x,y,effect,"API",0,-38,760,0); },
    packetLadder(effect, layer, x, y) { for(let i=0;i<6;i++){line(layer,"u80-ladder-step",x+i*8-22,y-i*7,effect,20,0,30,-24,720+i*35); dot(layer,"u80-packet",x+i*8-22,y-i*7,effect,6,38,-28,720+i*35);} },
    serverRack(effect, layer, x, y) { for(let i=0;i<5;i++) card(layer,"u80-server-slot",x,y-18+i*8,effect,"",rand(-28,28),rand(-24,24),720+i*40,0); },
    webhookHook(effect, layer, x, y) { shape(layer,"u80-hook",x,y,effect,42,-16,780,24); dot(layer,"u80-hook-packet",x-20,y+8,effect,8,55,-22,780); },
    circuitBranch(effect, layer, x, y) { shape(layer,"u80-chip",x,y,effect,0,0,760,0); [[1,0],[-1,0],[0,1],[0,-1],[1,1],[-1,-1]].forEach((p,i)=>line(layer,"u80-circuit",x,y,effect,38,Math.atan2(p[1],p[0])*180/Math.PI,p[0]*45,p[1]*45,720+i*25)); },
    qrPixels(effect, layer, x, y) { for(let i=0;i<16;i++) shape(layer,"u80-qr-pixel",x+(i%4-1.5)*8,y+(Math.floor(i/4)-1.5)*8,effect,rand(-36,36),rand(-36,36),700+i*18,0); },
    gelSquish(effect, layer, x, y) { shape(layer,"u80-gel",x,y,effect,0,0,850,0,"u80Elastic"); for(let i=0;i<3;i++) dot(layer,"u80-gel-dot",x+rand(-10,10),y+rand(-7,7),effect,5,rand(-18,18),rand(-20,20),760+i*40); },
    waxDrip(effect, layer, x, y) { for(let i=0;i<5;i++) shape(layer,"u80-wax",x+rand(-16,16),y+rand(-6,6),effect,rand(-8,8),rand(45,86),900+i*45,0); },
    bubbleColumn(effect, layer, x, y) { for(let i=0;i<7;i++) dot(layer,"u80-bubble",x+rand(-9,9),y+rand(-8,8),effect,rand(6,14),rand(-18,18),rand(-80,-30),920+i*40); },
    foamPop(effect, layer, x, y) { for(let i=0;i<6;i++) pulse(layer,"u80-foam",x+rand(-18,18),y+rand(-12,12),effect,680+i*50); },
    threadNeedle(effect, layer, x, y) { line(layer,"u80-needle",x,y,effect,64,rand(-18,18),55,-10,760); line(layer,"u80-thread",x-20,y+12,effect,84,rand(12,42),rand(-38,38),rand(20,54),900); },
    clothRip(effect, layer, x, y) { for(let i=0;i<8;i++) line(layer,"u80-cloth-fiber",x+rand(-16,16),y+rand(-8,8),effect,rand(18,42),rand(60,120),rand(-48,48),rand(-38,38),780+i*25); },
    stoneSkip(effect, layer, x, y) { for(let i=0;i<5;i++) shape(layer,"u80-stone",x+rand(-8,8),y+rand(-4,6),effect,rand(22,70),rand(-60,32),840+i*50,rand(-140,140)); },
    metalFilings(effect, layer, x, y) { for(let i=0;i<12;i++){let a=i*Math.PI/6; line(layer,"u80-filing",x+Math.cos(a)*rand(16,42),y+Math.sin(a)*rand(16,42),effect,rand(8,18),a*180/Math.PI+90,-Math.cos(a)*rand(10,28),-Math.sin(a)*rand(10,28),760+i*18);} },
    crystalCrack(effect, layer, x, y) { for(let i=0;i<7;i++){let a=rand(-160,160); line(layer,"u80-crack",x,y,effect,rand(22,54),a,Math.cos(a*Math.PI/180)*rand(24,58),Math.sin(a*Math.PI/180)*rand(24,58),660+i*35);} },
    crumbFall(effect, layer, x, y) { for(let i=0;i<9;i++) shape(layer,"u80-crumb",x+rand(-14,14),y+rand(-10,8),effect,rand(-30,30),rand(35,88),820+i*25,rand(-180,180)); },
    mapPing(effect, layer, x, y) { shape(layer,"u80-map-pin",x,y,effect,0,-34,780,0); pulse(layer,"u80-map-ping",x,y+12,effect,760); },
    routeDashes(effect, layer, x, y) { for(let i=0;i<8;i++) line(layer,"u80-route-dash",x-35+i*10,y+Math.sin(i)*10,effect,14,rand(-20,20),rand(20,55),rand(-24,24),720+i*25); },
    waypointChain(effect, layer, x, y) { for(let i=0;i<5;i++){dot(layer,"u80-waypoint",x-24+i*12,y+Math.sin(i)*9,effect,7,rand(-28,42),rand(-34,34),760+i*35); if(i<4) line(layer,"u80-way-link",x-18+i*12,y+Math.sin(i)*8,effect,18,rand(-25,25),rand(-20,35),rand(-30,30),760+i*35);} },
    radarSweep(effect, layer, x, y) { pulse(layer,"u80-radar-ring",x,y,effect,840); shape(layer,"u80-radar-wedge",x,y,effect,0,0,840,rand(60,140)); },
    compassRose(effect, layer, x, y) { for(let i=0;i<8;i++){let a=i*Math.PI/4; line(layer,"u80-compass-tick",x,y,effect,i%2?18:30,a*180/Math.PI,Math.cos(a)*55,Math.sin(a)*55,720+i*20);} },
    coordinatePop(effect, layer, x, y) { [`x:${Math.floor(rand(10,99))}`,`y:${Math.floor(rand(10,99))}`,'lat','lng'].forEach((t,i)=>textMark(layer,'u80-coordinate',x+rand(-6,6),y+rand(-6,6),effect,t,rand(-38,38),rand(-58,20),760+i*50,0)); },
    locationBeam(effect, layer, x, y) { line(layer,"u80-location-beam",x,y,effect,86,90,0,-68,760); dot(layer,"u80-location-core",x,y,effect,9,0,-42,760); pulse(layer,"u80-location-ring",x,y,effect,760); },
    topographyLines(effect, layer, x, y) { for(let i=0;i<5;i++){let el=piece(layer,'u80-topo',x,y,effect);el.style.setProperty('--s',(38+i*18)+'px');fly(el,rand(-10,10),rand(-10,10),840+i*50,1,rand(-12,12),'u80Pulse');} },
    gridLocator(effect, layer, x, y) { for(let i=0;i<16;i++) shape(layer,"u80-grid-cell",x+(i%4-1.5)*11,y+(Math.floor(i/4)-1.5)*11,effect,rand(-18,18),rand(-18,18),620+i*18,0); },
    navArrow(effect, layer, x, y) { shape(layer,"u80-nav-arrow",x,y,effect,52,-20,820,rand(-24,24)); for(let i=0;i<4;i++) line(layer,"u80-nav-tick",x,y,effect,16,rand(-60,60),rand(-30,20),rand(-30,20),700+i*30); },
    origamiFold(effect, layer, x, y) { for(let i=0;i<4;i++) shape(layer,"u80-origami",x+rand(-4,4),y+rand(-4,4),effect,rand(-42,42),rand(-42,42),760+i*45,rand(-180,180)); },
    envelopeTear(effect, layer, x, y) { shape(layer,"u80-envelope",x,y,effect,0,-30,780,0); for(let i=0;i<6;i++) shape(layer,"u80-paper-bit",x,y,effect,rand(-50,50),rand(-46,24),700+i*35,rand(-180,180)); },
    ticketPunch(effect, layer, x, y) { card(layer,"u80-ticket",x,y,effect,"TKT",0,-28,820,0); for(let i=0;i<5;i++) dot(layer,"u80-ticket-hole",x-20+i*10,y,effect,4,rand(-16,16),rand(-48,-10),700+i*30); },
    paperclipLoop(effect, layer, x, y) { shape(layer,"u80-paperclip",x,y,effect,36,-20,820,rand(20,60)); line(layer,"u80-clip-shadow",x,y,effect,40,rand(20,60),28,-20,820); },
    bookmarkFlip(effect, layer, x, y) { shape(layer,"u80-bookmark",x,y,effect,0,42,820,rand(-18,18)); line(layer,"u80-bookmark-fold",x,y-10,effect,24,0,0,34,820); },
    scissorSnip(effect, layer, x, y) { line(layer,"u80-scissor",x,y,effect,46,-35,-40,-20,760); line(layer,"u80-scissor",x,y,effect,46,35,40,-20,760); pulse(layer,"u80-snip-ring",x,y,effect,620); },
    waxSeal(effect, layer, x, y) { shape(layer,"u80-wax-seal",x,y,effect,0,0,820,0,'u80Pulse'); for(let i=0;i<6;i++) line(layer,'u80-seal-crack',x,y,effect,rand(10,24),rand(-180,180),rand(-20,20),rand(-20,20),700+i*30); },
    pinwheelSpin(effect, layer, x, y) { for(let i=0;i<4;i++) shape(layer,'u80-pinwheel-blade',x,y,effect,Math.cos(i*Math.PI/2)*36,Math.sin(i*Math.PI/2)*36,820,i*90+rand(0,30)); dot(layer,'u80-pinwheel-pin',x,y,effect,6,0,0,620); },
    scrollCurl(effect, layer, x, y) { shape(layer,'u80-scroll',x,y,effect,20,-35,860,rand(-20,20)); line(layer,'u80-scroll-line',x,y+8,effect,42,0,20,-30,820); },
    typeSlug(effect, layer, x, y) { ['A','B','/','*'].forEach((t,i)=>card(layer,'u80-type-slug',x+rand(-5,5),y+rand(-5,5),effect,t,rand(-42,42),rand(-52,18),760+i*45,rand(-14,14))); },
    glyphWheel(effect, layer, x, y) { const glyphs=['✕','◇','△','○','+','//','*','□']; glyphs.forEach((g,i)=>{let a=i*Math.PI/4; textMark(layer,'u80-glyph',x+Math.cos(a)*18,y+Math.sin(a)*18,effect,g,Math.cos(a)*48,Math.sin(a)*48,760+i*20,a*180/Math.PI);}); },
    morseBlips(effect, layer, x, y) { ['•','— ','•','•','— '].forEach((t,i)=>textMark(layer,'u80-morse',x-24+i*12,y,effect,t,rand(-10,10),rand(-45,25),700+i*50,0)); },
    brailleDots(effect, layer, x, y) { for(let i=0;i<6;i++) dot(layer,'u80-braille',x+(i%2)*9-4,y+Math.floor(i/2)*9-9,effect,5,rand(-25,25),rand(-40,25),700+i*35); },
    chessStep(effect, layer, x, y) { shape(layer,'u80-chess',x,y,effect,34,-34,820,0); for(let i=0;i<3;i++) dot(layer,'u80-chess-dot',x+i*10,y-i*10,effect,4,30+i*10,-30-i*10,740+i*40); },
    lockShards(effect, layer, x, y) { shape(layer,'u80-lock',x,y,effect,0,-20,760,0); for(let i=0;i<6;i++) shape(layer,'u80-lock-shard',x,y,effect,rand(-50,50),rand(-45,45),700+i*35,rand(-180,180)); },
    keyTurn(effect, layer, x, y) { shape(layer,'u80-key',x,y,effect,42,-8,820,70); for(let i=0;i<4;i++) dot(layer,'u80-key-spark',x+18,y,effect,4,rand(20,55),rand(-30,30),680+i*30); },
    hourglassFlip(effect, layer, x, y) { shape(layer,'u80-hourglass',x,y,effect,0,0,860,180); for(let i=0;i<7;i++) dot(layer,'u80-sand',x+rand(-8,8),y+rand(-6,6),effect,3,rand(-10,10),rand(25,55),760+i*25); },
    playingCard(effect, layer, x, y) { card(layer,'u80-playing-card',x,y,effect,pick(['♠','♥','♦','♣']),rand(-20,20),-42,820,rand(-40,40)); for(let i=0;i<4;i++) textMark(layer,'u80-suit',x,y,effect,pick(['♠','♥','♦','♣']),rand(-45,45),rand(-45,20),720+i*30,rand(-60,60)); },
    puzzlePop(effect, layer, x, y) { for(let i=0;i<5;i++) shape(layer,'u80-puzzle',x+rand(-6,6),y+rand(-6,6),effect,rand(-46,46),rand(-46,36),760+i*35,rand(-120,120)); },
    dialCombo(effect, layer, x, y) { pulse(layer,'u80-dial',x,y,effect,820); for(let i=0;i<10;i++){let a=i*Math.PI/5; line(layer,'u80-dial-tick',x+Math.cos(a)*24,y+Math.sin(a)*24,effect,i%2?10:17,a*180/Math.PI,Math.cos(a)*40,Math.sin(a)*40,720+i*20);} }
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
