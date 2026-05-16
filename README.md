# Clipo

Clipo is a lightweight macOS multi-slot clipboard tool that lets users save selected text into shortcut slots and paste any saved item anywhere using global hotkeys.

**Clipo** 是一个轻量级 macOS 多槽位剪贴板工具。用户可以用全局快捷键把不同内容保存到不同槽位，并在任何地方快速粘贴指定内容。

---

## Features

- **Menu Bar App**: Runs entirely in the macOS menu bar with no Dock icon by default.
- **9 Fixed Slots**: Save text to Slot 1–9 with instant global shortcuts.
- **Quick Paste**: Paste any saved slot back into the current app with a single keystroke.
- **Clipboard History**: Automatically saves every slot item into a local history (up to 200 items).
- **Search Panel**: Spotlight-style panel to browse slots and history, searchable in real time.
- **Privacy First**:
  - No background clipboard monitoring.
  - Ignores sensitive apps (1Password, Bitwarden, Keychain Access, etc.) by default.
  - All data stored locally in JSON. No network, no cloud, no analytics.
- **Restore Clipboard**: Optionally restore your previous clipboard contents after saving or pasting.
- **Launch at Login**: Built-in support for starting with macOS (macOS 13+).

---

## Hotkeys

| Action | Shortcut |
|---|---|
| Save selected text to Slot 1 | `⌥⌘1` (Option + Command + 1) |
| Save selected text to Slot 2 | `⌥⌘2` |
| Save selected text to Slot 3 | `⌥⌘3` |
| Save selected text to Slot 4 | `⌥⌘4` |
| Save selected text to Slot 5 | `⌥⌘5` |
| Save selected text to Slot 6 | `⌥⌘6` |
| Save selected text to Slot 7 | `⌥⌘7` |
| Save selected text to Slot 8 | `⌥⌘8` |
| Save selected text to Slot 9 | `⌥⌘9` |
| Paste Slot 1 | `⌃⌥1` (Control + Option + 1) |
| Paste Slot 2 | `⌃⌥2` |
| Paste Slot 3 | `⌃⌥3` |
| Paste Slot 4 | `⌃⌥4` |
| Paste Slot 5 | `⌃⌥5` |
| Paste Slot 6 | `⌃⌥6` |
| Paste Slot 7 | `⌃⌥7` |
| Paste Slot 8 | `⌃⌥8` |
| Paste Slot 9 | `⌃⌥9` |
| Open Clipo Panel | `⌥Space` (Option + Space) |

> **Note:** Hotkeys require Accessibility permission to simulate copy/paste keystrokes.

---

## Installation

### Download (Recommended)
1. Go to the [Releases](https://github.com/hanazar/clipo/releases) page.
2. Download the latest `Clipo.dmg`.
3. Open the `.dmg` and drag **Clipo** into your **Applications** folder.
4. Launch Clipo from Applications.
5. Grant **Accessibility** permission when prompted (see below).

### Build from Source
Requires **macOS 13.0+** and **Xcode 14+**.

```bash
git clone https://github.com/hanazar/clipo.git
cd clipo/Clipo
open Clipo.xcodeproj
```

1. In Xcode, select the **Clipo** target.
2. Ensure **Signing & Capabilities** has a valid Team or is set to "Sign to Run Locally".
3. Add `Carbon.framework` and `ServiceManagement.framework` in **General > Frameworks**.
4. Set **Build Settings > LSUIElement** to `YES`.
5. Press `⌘R` to run.

---

## Permissions

Clipo requires **Accessibility** permission to send global copy (`⌘C`) and paste (`⌘V`) events on your behalf.

**How to enable:**
1. When Clipo first launches, click **"Open System Settings"** in the permission window.
2. Navigate to **Privacy & Security > Accessibility**.
3. Click the **+** button and add **Clipo**.
4. **Quit and restart** Clipo.

If you run Clipo directly from Xcode, you may need to add the specific build product path (inside `DerivedData`) to Accessibility. For convenience, you can find the built app by right-clicking the Clipo product in Xcode > Show in Finder.

---

## Privacy Policy

Clipo takes your privacy seriously:

- **Local Only**: All clipboard data is saved to a local JSON file (`~/Library/Application Support/Clipo/clips.json`).
- **No Upload**: Clipo does not upload, sync, or transmit any clipboard data.
- **No Analytics**: Clipo does not use analytics, telemetry, or crash reporters.
- **No Network**: Clipo does not connect to any remote server.
- **No Background Monitoring**: V1 does not observe the system pasteboard in the background. Data is only read when you press a Clipo hotkey.
- **Sensitive App Protection**: By default, Clipo refuses to save text from password managers and keychain utilities.

---

## Data Storage

Clipo stores everything locally:

```
~/Library/Application Support/Clipo/
├── clips.json                    # Main data file (slots, history, settings)
└── clips_corrupted_backup.json   # Auto-generated if clips.json is corrupted
```

You can open this folder directly from **Settings > Data > Open Data Folder**.

---

## Building a Release DMG

### Method 1: Manual with hdiutil

```bash
# 1. Build and archive
xcodebuild archive \
  -project Clipo.xcodeproj \
  -scheme Clipo \
  -archivePath build/Clipo.xcarchive

# 2. Extract the .app
cp -R build/Clipo.xcarchive/Products/Applications/Clipo.app ./Clipo.app

# 3. Prepare DMG contents
mkdir -p Clipo-DMG
cp -R Clipo.app Clipo-DMG/
ln -s /Applications Clipo-DMG/Applications

# 4. Create compressed DMG
hdiutil create -volname "Clipo" -srcfolder Clipo-DMG -ov -format UDZO Clipo.dmg
```

### Method 2: create-dmg (Better UX)

Install [create-dmg](https://github.com/create-dmg/create-dmg):

```bash
brew install create-dmg
```

Then run:

```bash
create-dmg \
  --volname "Clipo" \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "Clipo.app" 200 185 \
  --app-drop-link 600 185 \
  "Clipo.dmg" \
  "Clipo.app"
```

This produces a draggable `.dmg` with a background window, app icon, and Applications folder alias.

### Code Signing & Notarization (For Distribution)

If you plan to distribute outside the Mac App Store:

1. Join the [Apple Developer Program](https://developer.apple.com/programs/) ($99/year).
2. Obtain a **Developer ID Application** certificate.
3. Sign the app:
   ```bash
   codesign --deep --force --verify --verbose \
     --sign "Developer ID Application: Your Name (TEAM_ID)" \
     Clipo.app
   ```
4. Notarize:
   ```bash
   xcrun notarytool submit Clipo.dmg \
     --apple-id "your@email.com" \
     --team-id "TEAM_ID" \
     --password "app-specific-password" \
     --wait
   ```
5. Staple the ticket:
   ```bash
   xcrun stapler staple Clipo.dmg
   ```

> If the app is **unsigned**, users must right-click the app and select **Open** the first time they run it.

---

## GitHub Release Workflow

1. **Create a GitHub repository** named `clipo` (or `clipo-mac`).
2. Push your code:
   ```bash
   git init
git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/clipo.git
   git push -u origin main
   ```
3. **Tag a version**:
   ```bash
   git tag -a v0.1.0 -m "First MVP release"
   git push origin v0.1.0
   ```
4. Go to **GitHub > Releases > Draft a new release**.
5. Choose the tag `v0.1.0`.
6. Upload `Clipo.dmg` as a release asset.
7. Publish the release.

### Suggested Versioning

| Version | Milestone |
|---|---|
| v0.1.0 | MVP: slots, hotkeys, history, panel |
| v0.2.0 | Customizable hotkeys, improved search |
| v0.3.0 | Import/export JSON, auto-cleanup policies |
| v0.4.0 | Rich text/images support, Dock icon toggle |
| v1.0.0 | Stable release, signed & notarized DMG |

---

## Roadmap

- [x] Menu bar integration
- [x] 9-slot save & paste with global hotkeys
- [x] Clipboard history with search
- [x] Accessibility permission handling
- [x] Local JSON persistence
- [x] Sensitive app blacklist
- [ ] Custom hotkey configuration
- [ ] Import / Export JSON
- [ ] Auto-delete old unpinned history
- [ ] Image & file support
- [ ] Apple Silicon & Intel universal binary

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

## Acknowledgements

Built with Swift, SwiftUI, AppKit, and Carbon. No third-party dependencies.
