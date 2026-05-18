# Clipo v1.2.0 — Rock Solid

**Stable, silent, and always ready.**

---

## What's New

### 🔒 Stability Overhaul
- Fixed `objc_release` crashes during panel teardown and hotkey re-registration
- Eliminated Carbon event handler leaks on repeated hotkey refreshes
- Hardened `NSWindowDelegate` lifecycle to prevent dangling delegate callbacks

### 🧠 Smarter History
- Pinned items now correctly respect the global history cap (`maxHistoryItems`)
- `trimHistory()` no longer orphans pinned clips when the limit is lowered

### ✍️ UX Polish
- Refined empty-state copy and menu bar labels for clarity
- Consistent error messaging across panel, menu, and toast surfaces

---

## Download

**[⬇ Clipo-v1.2.0.dmg](https://github.com/hanazar/clipo/releases/download/v1.2.0/Clipo.dmg)**

Requires **macOS 13.0+**.

---

## Install

1. Download `Clipo.dmg`.
2. Drag **Clipo** into your **Applications** folder.
3. Launch and grant **Accessibility** permission when prompted.

---

## Full Changelog

- Fix `objc_release` use-after-free in `PanelWindowService.tearDown()`
- Fix Carbon event handler leak in `HotkeyService.unregisterAllHotkeys()`
- Fix `windowWillClose` delegate dangling reference crash
- Fix pinned history overflow beyond `maxHistoryItems`
- Refine menu bar and empty-state copy text

---

Built with Swift, SwiftUI, AppKit, and Carbon. No third-party dependencies.
