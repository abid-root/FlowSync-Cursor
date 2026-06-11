/* Fix for FlowSync addon preview categories.
   The cleaned data file keeps the CB effects inside COLD_EFFECTS, but the addon
   renderer expects COLD_ADDON_EFFECTS. This bridge makes Ash/Structure/Signal previews work. */
(function () {
  const current = Array.isArray(window.COLD_ADDON_EFFECTS) ? window.COLD_ADDON_EFFECTS : [];
  const all = Array.isArray(window.COLD_EFFECTS) ? window.COLD_EFFECTS : [];
  const byKey = new Map();

  current.forEach((item) => {
    if (item && item.key) byKey.set(item.key, item);
  });

  all.forEach((item) => {
    if (!item || !item.key) return;

    const key = String(item.key);
    const kind = String(item.kind || "");

    if (
      key.startsWith("cb-") ||
      kind.includes("coldboot") ||
      kind.includes("signature")
    ) {
      byKey.set(key, item);
    }
  });

  window.COLD_ADDON_EFFECTS = Array.from(byKey.values());
})();