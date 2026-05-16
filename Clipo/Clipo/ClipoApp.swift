import SwiftUI
import AppKit

@main
struct ClipoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // SwiftUI requires at least one Scene. We use a minimal WindowGroup
        // and manage all UI via AppKit (NSStatusItem, NSPanel) in AppDelegate.
        WindowGroup {
            EmptyView()
                .frame(width: 0, height: 0)
                .hidden()
        }
        .windowStyle(.hiddenTitleBar)
    }
}

// MARK: - AppDelegate

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate, NSWindowDelegate {
    var statusItem: NSStatusItem?
    var settingsWindow: NSWindow?
    var permissionWindow: NSWindow?
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        // Set activation policy as early as possible to prevent any Dock icon flicker
        // before SwiftUI creates its default WindowGroup.
        NSApp.setActivationPolicy(.accessory)
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // SwiftUI WindowGroup creates a default window even with hidden content.
        // Close any window that is not one of our explicitly managed windows.
        NSApp.windows
            .filter { $0 !== settingsWindow && $0 !== permissionWindow && $0 !== PanelWindowService.shared.panelWindow }
            .forEach { $0.close() }
        
        setupStatusItem()
        HotkeyService.shared.registerAllHotkeys()
        
        if !PermissionService.shared.hasAccessibilityPermission() {
            showPermissionWindow()
        }
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // As a menu-bar-only app, we do not want to show any window when the user
        // double-clicks the app icon in Finder.
        return false
    }
    
    // MARK: - Status Item Setup
    
    func setupStatusItem() {
        statusItem = NSStatusBar.shared.statusItem(withLength: NSStatusItem.variableLength)
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
        let openPanelItem = NSMenuItem(title: "Open Clipo Panel    ⌥Space", action: #selector(openPanel), keyEquivalent: "")
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
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem?.menu = menu
    }
    
    // MARK: - Menu Actions
    
    @objc func slotCopyClicked(_ sender: NSMenuItem) {
        let slotNumber = sender.tag
        if let item = ClipStore.shared.slots[slotNumber] {
            ClipboardService.shared.writeTextToPasteboard(item.content)
            NotificationService.shared.showNotification(title: "Copied", body: item.preview)
        }
    }
    
    @objc func slotPasteClicked(_ sender: NSMenuItem) {
        let slotNumber = sender.tag
        guard let item = ClipStore.shared.slots[slotNumber] else {
            NotificationService.shared.showNotification(title: "Slot \(slotNumber) Empty", body: "Nothing has been saved to this slot yet.")
            return
        }
        let shouldRestore = ClipStore.shared.settings.restoreClipboardAfterPaste
        PasteService.shared.pasteText(item.content, restorePrevious: shouldRestore)
    }
    
    @objc func openPanel() {
        PanelWindowService.shared.showPanel()
    }
    
    @objc func openSettings() {
        if settingsWindow == nil {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 520, height: 380),
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
        ClipStore.shared.clearHistory()
        NotificationService.shared.showNotification(title: "History Cleared", body: "All unpinned history items removed.")
    }
    
    @objc func resetSlots() {
        ClipStore.shared.resetSlots()
        NotificationService.shared.showNotification(title: "Slots Reset", body: "All slots cleared.")
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
        ClipboardService.shared.writeTextToPasteboard(item.content)
        NotificationService.shared.showNotification(title: "Copied", body: item.preview)
    }
    
    // MARK: - Permission Window
    
    func showPermissionWindow() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 280),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Clipo Permissions"
        window.contentView = NSHostingView(rootView: PermissionView())
        window.delegate = self
        window.isReleasedWhenClosed = false
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        permissionWindow = window
    }
    
    // MARK: - NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if window == settingsWindow {
            settingsWindow = nil
        } else if window == permissionWindow {
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
    }
}
