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
    private var isReplacingPermissionWindow = false
    private var isClosingPermissionAfterGrant = false
    
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
        
        // Listen for in-panel Settings requests.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(openSettings),
            name: .openClipoSettings,
            object: nil
        )
        
        // Rebuild menu bar when language changes.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setupStatusItem),
            name: .languageChanged,
            object: nil
        )
        
        showSplashScreen()
    }
    
    private func continueLaunch(skippingPermission: Bool = false) {
        guard !hasFinishedSplash else { return }
        
        // Always show the main panel first. If permission is missing,
        // an in-panel overlay will prompt the user.
        finishLaunch(showPanel: true, showReadyToast: false)
        
        if skippingPermission {
            NotificationService.shared.showNotification(
                title: L10n.string(.runningTitle),
                body: L10n.string(.runningBody)
            )
        } else if !PermissionService.shared.hasAccessibilityPermission() {
            startPermissionMonitoring()
        }
    }
    
    /// Unified launch-completion path. Prevents duplicate setup and optionally
    /// shows the main panel or a ready toast.
    private func finishLaunch(showPanel: Bool, showReadyToast: Bool) {
        guard !hasFinishedSplash else { return }
        hasFinishedSplash = true
        setupStatusItem()
        HotkeyService.shared.registerAllHotkeys()
        ClipboardHistoryService.shared.start()
        
        if showPanel {
            // Small delay so the permission window has time to close
            // and the UI doesn't feel jarring.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                PanelWindowService.shared.showPanel()
            }
        }
        
        if showReadyToast {
            NotificationService.shared.showNotification(
                title: L10n.string(.notificationClipoReadyTitle),
                body: L10n.string(.notificationClipoReadyBody)
            )
        }
    }
    
    private func startPermissionMonitoring() {
        permissionCheckTimer?.invalidate()
        permissionCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if PermissionService.shared.hasAccessibilityPermission() {
                self.permissionCheckTimer?.invalidate()
                self.permissionCheckTimer = nil
                NotificationService.shared.showNotification(
                    title: L10n.string(.notificationClipoReadyTitle),
                    body: L10n.string(.notificationClipoReadyBody)
                )
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
        // When the Dock icon is visible, let the user reopen the app by
        // showing the Clipo panel. Otherwise ignore the Dock click.
        if ClipStore.shared.settings.showDockIcon {
            PanelWindowService.shared.showPanel()
            return true
        }
        return false
    }
    
    // MARK: - Status Item Setup
    
    @objc func setupStatusItem() {
        if let existing = statusItem {
            NSStatusBar.system.removeStatusItem(existing)
        }
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let button = statusItem?.button
        button?.image = NSImage(systemSymbolName: "clipboard", accessibilityDescription: "Clipo")
            ?? NSImage(named: NSImage.Name("NSActionTemplate"))
        button?.toolTip = "Clipo – " + L10n.string(.appNameMenuTitle)
        
        let menu = NSMenu()
        menu.delegate = self
        
        // Title
        let titleItem = NSMenuItem(title: L10n.string(.appNameMenuTitle), action: nil, keyEquivalent: "")
        titleItem.isEnabled = false
        menu.addItem(titleItem)
        menu.addItem(NSMenuItem.separator())
        
        // Slots with Copy / Paste submenu
        for i in 1...9 {
            let item = NSMenuItem(title: L10n.string(.slotEmptyTemplate, i), action: nil, keyEquivalent: "")
            item.tag = i
            
            let submenu = NSMenu()
            
            let copyAction = NSMenuItem(title: L10n.string(.slotCopyMenuTitle), action: #selector(slotCopyClicked(_:)), keyEquivalent: "")
            copyAction.tag = i
            copyAction.target = self
            submenu.addItem(copyAction)
            
            let pasteAction = NSMenuItem(title: L10n.string(.slotPasteMenuTitle), action: #selector(slotPasteClicked(_:)), keyEquivalent: "")
            pasteAction.tag = i
            pasteAction.target = self
            submenu.addItem(pasteAction)
            
            item.submenu = submenu
            menu.addItem(item)
        }
        
        menu.addItem(NSMenuItem.separator())
        
        // History header
        let historyHeader = NSMenuItem(title: L10n.string(.recentHistoryMenuTitle), action: nil, keyEquivalent: "")
        historyHeader.isEnabled = false
        menu.addItem(historyHeader)
        
        // Placeholder separator; history items will be injected here dynamically.
        menu.addItem(NSMenuItem.separator())
        
        // Actions
        let openPanelItem = NSMenuItem(title: L10n.string(.openPanelMenuTitle), action: #selector(openPanel), keyEquivalent: "")
        openPanelItem.target = self
        menu.addItem(openPanelItem)
        
        let settingsItem = NSMenuItem(title: L10n.string(.settingsMenuItem), action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let clearHistoryItem = NSMenuItem(title: L10n.string(.clearHistoryMenuItem), action: #selector(clearHistory), keyEquivalent: "")
        clearHistoryItem.target = self
        menu.addItem(clearHistoryItem)
        
        let resetSlotsItem = NSMenuItem(title: L10n.string(.resetSlotsMenuItem), action: #selector(resetSlots), keyEquivalent: "")
        resetSlotsItem.target = self
        menu.addItem(resetSlotsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let permissionItem = NSMenuItem(title: L10n.string(.requestAccessibilityMenuItem), action: #selector(showPermissionWindowFromMenu), keyEquivalent: "")
        permissionItem.target = self
        menu.addItem(permissionItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: L10n.string(.quitMenuItem), action: #selector(quitApp), keyEquivalent: "q")
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
        let changeCount = ClipboardService.shared.writeClipItemToPasteboard(item)
        ClipboardHistoryService.shared.ignoreChangeCount(changeCount)
        ClipStore.shared.recordHistoryItem(item)
        NotificationService.shared.showNotification(title: L10n.string(.notificationCopiedTitle), body: item.preview)
        
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
            NotificationService.shared.showNotification(title: L10n.string(.notificationSlotEmptyTemplate, slotNumber), body: L10n.string(.notificationSlotEmptyBody))
            return
        }
        guard PermissionService.shared.hasAccessibilityPermission() else {
            NotificationService.shared.showNotification(
                title: L10n.string(.notificationPastePermissionTitle),
                body: PermissionService.shared.accessibilityRequiredMessage(action: L10n.string(.footerPaste).lowercased()),
                isError: true
            )
            return
        }
        SoundService.shared.playPaste()
        let shouldRestore = ClipStore.shared.settings.restoreClipboardAfterPaste
        PasteService.shared.pasteItem(item, restorePrevious: shouldRestore)
        
        if var updated = ClipStore.shared.slots[slotNumber] {
            updated.lastUsedAt = Date()
            ClipStore.shared.slots[slotNumber] = updated
        }
        if let histIndex = ClipStore.shared.history.firstIndex(where: { $0.content == item.content }) {
            var histItem = ClipStore.shared.history[histIndex]
            histItem.lastUsedAt = Date()
            ClipStore.shared.history[histIndex] = histItem
        }
        ClipStore.shared.save()
    }
    
    @objc func openPanel() {
        PanelWindowService.shared.showPanel()
    }
    
    @objc func openSettings() {
        if settingsWindow == nil {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 760, height: 520),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            window.title = L10n.string(.settingsTitle)
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
        NotificationService.shared.showNotification(title: L10n.string(.notificationHistoryClearedTitle), body: L10n.string(.notificationHistoryClearedBody))
    }
    
    @objc func resetSlots() {
        SoundService.shared.playReset()
        ClipStore.shared.resetSlots()
        NotificationService.shared.showNotification(title: L10n.string(.notificationSlotsResetTitle), body: L10n.string(.notificationSlotsResetBody))
    }
    
    @objc func showPermissionWindowFromMenu() {
        PanelWindowService.shared.showPanel()
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
        let changeCount = ClipboardService.shared.writeClipItemToPasteboard(item)
        ClipboardHistoryService.shared.ignoreChangeCount(changeCount)
        ClipStore.shared.recordHistoryItem(item)
        NotificationService.shared.showNotification(title: L10n.string(.notificationCopiedTitle), body: item.preview)
    }
    
    // MARK: - Dynamic Menu Labels
    
    private func openPanelMenuTitle() -> String {
        let prefs = ClipStore.shared.settings.hotkeyPreferences
        let keyLabel = HotkeyPreferences.label(forKeyCode: prefs.openPanelKeyCode)
        let modLabel = HotkeyPreferences.shortMenuLabel(forModifiers: prefs.openPanelModifiers)
        let shortcut = modLabel.isEmpty ? keyLabel : "\(modLabel)\(keyLabel)"
        return L10n.string(.openPanelMenuTitle) + "    \(shortcut)"
    }
    
    // MARK: - Permission Window
    
    func showPermissionWindow() {
        // Tear down any existing permission window / timer before creating a new one.
        // Do NOT nil delegate before close(); windowWillClose handles cleanup.
        if let existing = permissionWindow {
            isReplacingPermissionWindow = true
            existing.close()
            isReplacingPermissionWindow = false
        }
        permissionCheckTimer?.invalidate()
        permissionCheckTimer = nil
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 420),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = L10n.string(.permissionTitle)
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
        ClipboardHistoryService.shared.stop()
        HotkeyService.shared.unregisterAllHotkeys()
    }
    
    // MARK: - NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if window == settingsWindow {
            // Break delegate reference before nulling our strong ref
            // to avoid any stale callbacks during deallocation.
            // Do NOT set contentView = nil; it can crash NSHostingView.
            window.delegate = nil
            settingsWindow = nil
        } else if window == permissionWindow {
            window.delegate = nil
            // Do NOT set contentView = nil here; it can trigger deallocation
            // crashes on NSHostingView. Let isReleasedWhenClosed=false handle it.
            permissionWindow = nil
            
            // If the user closes the permission window via the close button
            // without clicking Skip, treat it as a skip so the app doesn't hang.
            // Don't trigger this when we are closing the window programmatically
            // after granting permission or when replacing the window.
            if !hasFinishedSplash && !isReplacingPermissionWindow && !isClosingPermissionAfterGrant {
                permissionCheckTimer?.invalidate()
                permissionCheckTimer = nil
                continueLaunch(skippingPermission: true)
            }
        }
    }
    
    // MARK: - NSMenuDelegate
    
    func menuWillOpen(_ menu: NSMenu) {
        // 1. Rebuild history items dynamically.
        let recentHistory = Array(ClipStore.shared.history.prefix(5))
        
        if let historyHeaderIndex = menu.items.firstIndex(where: { $0.title == L10n.string(.recentHistoryMenuTitle) }) {
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
                let emptyItem = NSMenuItem(title: L10n.string(.noHistoryMenuItem), action: nil, keyEquivalent: "")
                emptyItem.isEnabled = false
                menu.insertItem(emptyItem, at: insertIndex)
            }
        }
        
        // 2. Update slot titles and submenu enabled state.
        for item in menu.items {
            if item.tag >= 1 && item.tag <= 9 {
                let slot = item.tag
                if let clip = ClipStore.shared.slots[slot] {
                    item.title = L10n.string(.slotTitleTemplate, slot, clip.preview)
                    item.isEnabled = true
                    item.submenu?.items.forEach { $0.isEnabled = true }
                } else {
                    item.title = L10n.string(.slotEmptyTemplate, slot)
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
                    item.title = L10n.string(.accessibilityGrantedMenuItem)
                    item.isEnabled = false
                } else if PermissionService.shared.isWaitingForAccessibilityGrant {
                    item.title = L10n.string(.checkingAccessibilityPermissionMenu)
                    item.isEnabled = true
                } else {
                    item.title = L10n.string(.requestAccessibilityMenuItem)
                    item.isEnabled = true
                }
            }
        }
    }
}
