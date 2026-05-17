import SwiftUI
import AppKit

@main
struct ClipoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Use a Settings scene instead of WindowGroup to avoid creating
        // a visible main window. All UI is managed via AppKit in AppDelegate.
        Settings {
            EmptyView()
        }
    }
}

// MARK: - SplashWindow

/// A borderless window that can become key, used for the splash screen.
class SplashWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
}

// MARK: - AppDelegate

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate, NSWindowDelegate {
    var statusItem: NSStatusItem?
    var settingsWindow: NSWindow?
    var permissionWindow: NSWindow?
    var splashWindow: NSWindow?
    private var hasFinishedSplash = false
    private var splashCloseTimer: Timer?
    private var permissionCheckTimer: Timer?
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        // Set activation policy as early as possible to prevent any Dock icon flicker
        // before SwiftUI creates its default WindowGroup.
        let policy: NSApplication.ActivationPolicy = ClipStore.shared.settings.showDockIcon ? .regular : .accessory
        NSApp.setActivationPolicy(policy)
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide any stray system windows created by SwiftUI internals.
        // orderOut is safer than close because it avoids triggering dealloc
        // of windows whose delegates may still be referenced by the runtime.
        NSApp.windows
            .filter { $0 !== settingsWindow && $0 !== permissionWindow && $0 !== PanelWindowService.shared.panelWindow && $0 !== splashWindow }
            .forEach { $0.orderOut(nil) }
        
        showSplashScreen()
    }
    
    private func continueLaunch(skippingPermission: Bool = false) {
        guard !hasFinishedSplash else { return }
        
        if PermissionService.shared.hasAccessibilityPermission() || skippingPermission {
            // Permission already granted — or user chose to skip — proceed with launch
            hasFinishedSplash = true
            setupStatusItem()
            HotkeyService.shared.registerAllHotkeys()
            
            if skippingPermission && !PermissionService.shared.hasAccessibilityPermission() {
                NotificationService.shared.showNotification(
                    title: "Clipo is Running",
                    body: "Look for the clipboard icon in your menu bar. You can enable Accessibility later via the menu."
                )
            }
        } else {
            // No permission — show permission window with live monitoring
            showPermissionWindow()
            startPermissionMonitoring()
        }
    }
    
    private func startPermissionMonitoring() {
        permissionCheckTimer?.invalidate()
        permissionCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if PermissionService.shared.hasAccessibilityPermission() {
                self.permissionCheckTimer?.invalidate()
                self.permissionCheckTimer = nil
                
                // Animate the granted state in the permission view
                DispatchQueue.main.async {
                    self.permissionWindow?.close()
                    self.permissionWindow = nil
                    
                    // Now continue with full launch
                    if !self.hasFinishedSplash {
                        self.hasFinishedSplash = true
                        self.setupStatusItem()
                        HotkeyService.shared.registerAllHotkeys()
                        NotificationService.shared.showNotification(
                            title: "Clipo Ready",
                            body: "Accessibility permission granted. Hotkeys are now active."
                        )
                    }
                }
            }
        }
    }
    
    private func showSplashScreen() {
        let window = SplashWindow(
            contentRect: NSRect(x: 0, y: 0, width: 420, height: 520),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = true
        window.level = .floating
        window.center()
        window.contentView = NSHostingView(rootView: SplashScreenView())
        window.isReleasedWhenClosed = false
        window.orderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        splashWindow = window
        
        // Close after animation completes (2.8s total)
        splashCloseTimer = Timer.scheduledTimer(withTimeInterval: 2.8, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.splashCloseTimer = nil
            
            // Resign first responder so SwiftUI view hierarchy tears down safely
            // before the window closes. Let NSWindow handle contentView lifecycle.
            self.splashWindow?.makeFirstResponder(nil)
            self.splashWindow?.close()
            self.splashWindow = nil
            
            self.continueLaunch()
        }
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // As a menu-bar-only app, we do not want to show any window when the user
        // double-clicks the app icon in Finder.
        return false
    }
    
    // MARK: - Status Item Setup
    
    func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let button = statusItem?.button
        button?.image = NSImage(systemSymbolName: "clipboard", accessibilityDescription: "Clipo")
            ?? NSImage(named: NSImage.Name("NSActionTemplate"))
        button?.toolTip = "Clipo – Multi-slot Clipboard"
        
        let menu = NSMenu()
        menu.delegate = self
        
        // Title
        let titleItem = NSMenuItem(title: "Clipo", action: nil, keyEquivalent: "")
        titleItem.isEnabled = false
        menu.addItem(titleItem)
        menu.addItem(NSMenuItem.separator())
        
        // Slots with Copy / Paste submenu
        for i in 1...9 {
            let item = NSMenuItem(title: "Slot \(i): Empty", action: nil, keyEquivalent: "")
            item.tag = i
            
            let submenu = NSMenu()
            
            let copyAction = NSMenuItem(title: "Copy to Clipboard", action: #selector(slotCopyClicked(_:)), keyEquivalent: "")
            copyAction.tag = i
            copyAction.target = self
            submenu.addItem(copyAction)
            
            let pasteAction = NSMenuItem(title: "Paste", action: #selector(slotPasteClicked(_:)), keyEquivalent: "")
            pasteAction.tag = i
            pasteAction.target = self
            submenu.addItem(pasteAction)
            
            item.submenu = submenu
            menu.addItem(item)
        }
        
        menu.addItem(NSMenuItem.separator())
        
        // History header
        let historyHeader = NSMenuItem(title: "Recent History", action: nil, keyEquivalent: "")
        historyHeader.isEnabled = false
        menu.addItem(historyHeader)
        
        // Placeholder separator; history items will be injected here dynamically.
        menu.addItem(NSMenuItem.separator())
        
        // Actions
        let openPanelItem = NSMenuItem(title: openPanelMenuTitle(), action: #selector(openPanel), keyEquivalent: "")
        openPanelItem.target = self
        menu.addItem(openPanelItem)
        
        let settingsItem = NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let clearHistoryItem = NSMenuItem(title: "Clear History", action: #selector(clearHistory), keyEquivalent: "")
        clearHistoryItem.target = self
        menu.addItem(clearHistoryItem)
        
        let resetSlotsItem = NSMenuItem(title: "Reset Slots", action: #selector(resetSlots), keyEquivalent: "")
        resetSlotsItem.target = self
        menu.addItem(resetSlotsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let permissionItem = NSMenuItem(title: "Request Accessibility Permission…", action: #selector(showPermissionWindowFromMenu), keyEquivalent: "")
        permissionItem.target = self
        menu.addItem(permissionItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem?.menu = menu
    }
    
    // MARK: - Menu Actions
    
    @objc func slotCopyClicked(_ sender: NSMenuItem) {
        let slotNumber = sender.tag
        guard let item = ClipStore.shared.slots[slotNumber] else {
            SoundService.shared.playError()
            return
        }
        SoundService.shared.playCopy()
        ClipboardService.shared.writeTextToPasteboard(item.content)
        NotificationService.shared.showNotification(title: "Copied", body: item.preview)
        
        if var updated = ClipStore.shared.slots[slotNumber] {
            updated.lastUsedAt = Date()
            ClipStore.shared.slots[slotNumber] = updated
            ClipStore.shared.save()
        }
    }
    
    @objc func slotPasteClicked(_ sender: NSMenuItem) {
        let slotNumber = sender.tag
        guard let item = ClipStore.shared.slots[slotNumber] else {
            SoundService.shared.playError()
            NotificationService.shared.showNotification(title: "Slot \(slotNumber) Empty", body: "Nothing has been saved to this slot yet.")
            return
        }
        SoundService.shared.playPaste()
        let shouldRestore = ClipStore.shared.settings.restoreClipboardAfterPaste
        PasteService.shared.pasteText(item.content, restorePrevious: shouldRestore)
        
        if var updated = ClipStore.shared.slots[slotNumber] {
            updated.lastUsedAt = Date()
            ClipStore.shared.slots[slotNumber] = updated
        }
        if let histIndex = ClipStore.shared.history.firstIndex(where: { $0.content == item.content }) {
            ClipStore.shared.history[histIndex].lastUsedAt = Date()
        }
        ClipStore.shared.save()
    }
    
    @objc func openPanel() {
        SoundService.shared.playOpen()
        PanelWindowService.shared.showPanel()
    }
    
    @objc func openSettings() {
        if settingsWindow == nil {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 560, height: 440),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            window.title = "Clipo Settings"
            window.contentView = NSHostingView(rootView: SettingsView())
            window.delegate = self
            window.isReleasedWhenClosed = false
            window.center()
            settingsWindow = window
        }
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func clearHistory() {
        SoundService.shared.playReset()
        ClipStore.shared.clearHistory()
        NotificationService.shared.showNotification(title: "History Cleared", body: "All unpinned history items removed.")
    }
    
    @objc func resetSlots() {
        SoundService.shared.playReset()
        ClipStore.shared.resetSlots()
        NotificationService.shared.showNotification(title: "Slots Reset", body: "All slots cleared.")
    }
    
    @objc func showPermissionWindowFromMenu() {
        showPermissionWindow()
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
    
    @objc func historyItemClicked(_ sender: NSMenuItem) {
        guard let uuidString = sender.representedObject as? String,
              let uuid = UUID(uuidString: uuidString),
              let item = ClipStore.shared.history.first(where: { $0.id == uuid }) else {
            return
        }
        SoundService.shared.playCopy()
        ClipboardService.shared.writeTextToPasteboard(item.content)
        NotificationService.shared.showNotification(title: "Copied", body: item.preview)
    }
    
    // MARK: - Dynamic Menu Labels
    
    private func openPanelMenuTitle() -> String {
        let prefs = ClipStore.shared.settings.hotkeyPreferences
        let keyLabel = HotkeyPreferences.label(forKeyCode: prefs.openPanelKeyCode)
        let modLabel = HotkeyPreferences.shortMenuLabel(forModifiers: prefs.openPanelModifiers)
        let shortcut = modLabel.isEmpty ? keyLabel : "\(modLabel)\(keyLabel)"
        return "Open Clipo Panel    \(shortcut)"
    }
    
    // MARK: - Permission Window
    
    func showPermissionWindow() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 420),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Clipo Permissions"
        window.contentView = NSHostingView(rootView: PermissionView(onSkip: { [weak self] in
            guard let self = self else { return }
            self.permissionCheckTimer?.invalidate()
            self.permissionCheckTimer = nil
            self.permissionWindow?.close()
            self.permissionWindow = nil
            self.continueLaunch(skippingPermission: true)
        }))
        window.delegate = self
        window.isReleasedWhenClosed = false
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        permissionWindow = window
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        splashCloseTimer?.invalidate()
        splashCloseTimer = nil
        permissionCheckTimer?.invalidate()
        permissionCheckTimer = nil
        PanelWindowService.shared.tearDown()
        HotkeyService.shared.unregisterAllHotkeys()
    }
    
    // MARK: - NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if window == settingsWindow {
            // Break delegate / contentView references before nulling our strong ref
            // to avoid any stale callbacks during deallocation.
            window.delegate = nil
            window.contentView = nil
            settingsWindow = nil
        } else if window == permissionWindow {
            window.delegate = nil
            window.contentView = nil
            permissionWindow = nil
        }
    }
    
    // MARK: - NSMenuDelegate
    
    func menuWillOpen(_ menu: NSMenu) {
        // 1. Rebuild history items dynamically.
        let recentHistory = Array(ClipStore.shared.history.prefix(5))
        
        if let historyHeaderIndex = menu.items.firstIndex(where: { $0.title == "Recent History" }) {
            var indicesToRemove: [Int] = []
            var i = historyHeaderIndex + 1
            while i < menu.items.count {
                if menu.items[i].isSeparatorItem {
                    break
                }
                indicesToRemove.append(i)
                i += 1
            }
            for idx in indicesToRemove.reversed() {
                menu.removeItem(at: idx)
            }
            
            var insertIndex = historyHeaderIndex + 1
            for item in recentHistory {
                let menuItem = NSMenuItem(title: item.preview, action: #selector(historyItemClicked(_:)), keyEquivalent: "")
                menuItem.representedObject = item.id.uuidString
                menuItem.target = self
                menu.insertItem(menuItem, at: insertIndex)
                insertIndex += 1
            }
            if recentHistory.isEmpty {
                let emptyItem = NSMenuItem(title: "No history", action: nil, keyEquivalent: "")
                emptyItem.isEnabled = false
                menu.insertItem(emptyItem, at: insertIndex)
            }
        }
        
        // 2. Update slot titles and submenu enabled state.
        for item in menu.items {
            if item.tag >= 1 && item.tag <= 9 {
                let slot = item.tag
                if let clip = ClipStore.shared.slots[slot] {
                    item.title = "Slot \(slot): \(clip.preview)"
                    item.isEnabled = true
                    item.submenu?.items.forEach { $0.isEnabled = true }
                } else {
                    item.title = "Slot \(slot): Empty"
                    item.isEnabled = true
                    item.submenu?.items.forEach { $0.isEnabled = false }
                }
            }
        }
        
        // 3. Update Open Panel title to reflect current shortcut.
        if let openPanelItem = menu.items.first(where: { $0.action == #selector(openPanel) }) {
            openPanelItem.title = openPanelMenuTitle()
        }
        
        // 4. Update permission reminder state.
        let hasPermission = PermissionService.shared.hasAccessibilityPermission()
        for item in menu.items {
            if item.action == #selector(showPermissionWindowFromMenu) {
                if hasPermission {
                    item.title = "Accessibility Permission Granted"
                    item.isEnabled = false
                } else {
                    item.title = "Request Accessibility Permission…"
                    item.isEnabled = true
                }
            }
        }
    }
}
