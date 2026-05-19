# Clipo v1.8.0 — Deep Customization

**Five new settings for power users who want full control.**

---

## What's New

### 🔍 Case-Sensitive Search
A new toggle in **Settings → Clipboard → History Behavior** lets you switch search from the default case-insensitive mode to exact case matching. Developers working with code snippets will find this especially useful.

### ⏱ Paste Delay
In **Settings → Clipboard → Paste Behavior**, a new slider lets you add a delay (0–1 second, in 0.05s steps) before Clipo simulates the Command+V keystrokes. This helps with:
- Remote desktop clients that need time to focus
- Terminal emulators with slow input handling
- Heavy apps that lag between focus and paste

### 🔔 Configurable Notification Duration
In **Settings → General → Appearance**, a slider controls how long toast alerts stay on screen:
- Range: **1.0–5.0 seconds** (0.5s steps)
- Error toasts automatically add +1.0s for readability

### ⚡ Animation Speed Multiplier
Also in **Settings → General → Appearance**, a slider adjusts panel open/close animation speed:
- **0.5×** for instant snap
- **1.0×** for default smoothness
- **2.0×** for slow dramatic motion

When "Reduce Animations" is enabled, the slider dims and animations are skipped entirely.

### 🏷 Show / Hide Source App
In **Settings → General → Appearance**, a toggle controls whether each history row displays the originating app name (e.g., "Safari", "Xcode"). Turn it off for a cleaner, more minimal list.

---

## Download

**[⬇ Clipo-v1.8.0.dmg](https://github.com/hanazar/clipo/releases/download/v1.8.0/Clipo.dmg)**

Requires **macOS 13.0+**.

---

## Install

1. Download `Clipo.dmg`.
2. Drag **Clipo** into your **Applications** folder.
3. Launch and grant **Accessibility** permission when prompted.

---

## Full Changelog

- Add `searchCaseSensitive` toggle (Settings → Clipboard)
- Add `pasteDelay` slider 0–1s (Settings → Clipboard → Paste Behavior)
- Add `notificationDuration` slider 1.0–5.0s (Settings → General → Appearance)
- Add `panelAnimationSpeed` multiplier 0.5×–2.0× (Settings → General → Appearance)
- Add `showSourceApp` toggle (Settings → General → Appearance)
- Wire all new settings into PanelWindowService, NotificationService, PasteService, ClipoPanelView, HistoryRowView
- Add 10 localization keys × 10 languages for new settings

---

Built with Swift, SwiftUI, AppKit, and Carbon. No third-party dependencies.
