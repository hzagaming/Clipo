import Foundation
import Carbon

// MARK: - Global Carbon Callback

/// Explicitly typed as EventHandlerProcPtr to guarantee C calling convention bridging.
private let carbonHotkeyCallback: EventHandlerProcPtr = { nextHandler, event, userData in
    guard let event = event else { return noErr }
    
    var hotKeyID = EventHotKeyID()
    let err = GetEventParameter(
        event,
        EventParamName(kEventParamDirectObject),
        EventParamType(typeEventHotKeyID),
        nil,
        MemoryLayout<EventHotKeyID>.size,
        nil,
        &hotKeyID
    )
    guard err == noErr else { return err }
    
    HotkeyService.shared.handleHotkeyEvent(id: hotKeyID.id)
    return noErr
}

// MARK: - HotkeyService

class HotkeyService {
    static let shared = HotkeyService()
    
    private var hotkeys: [EventHotKeyRef] = []
    private var handlers: [UInt32: () -> Void] = [:]
    private var eventHandlerRef: EventHandlerRef?
    private var eventHandlerUPP: EventHandlerUPP?
    
    /// Registers all global hotkeys used by Clipo.
    /// Reads modifier/key configuration from AppSettings so changes
    /// made in Settings take effect immediately after re-registration.
    func registerAllHotkeys() {
        unregisterAllHotkeys()
        
        let prefs = ClipStore.shared.settings.hotkeyPreferences
        
        // Install a single Carbon event handler for hotkey presses.
        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: OSType(kEventHotKeyPressed)
        )
        let callback: EventHandlerUPP = carbonHotkeyCallback
        self.eventHandlerUPP = callback
        let installStatus = InstallEventHandler(
            GetEventDispatcherTarget(),
            callback,
            1,
            &eventType,
            nil,
            &eventHandlerRef
        )
        
        guard installStatus == noErr else {
            print("[Clipo] Failed to install Carbon event handler, status: \(installStatus)")
            eventHandlerUPP = nil
            return
        }
        
        // Save hotkeys: user-configured modifier + 1..9
        for i in 1...9 {
            let keyCode = keyCodeForNumber(i)
            let id = UInt32(i)
            registerHotkey(keyCode: keyCode, modifiers: prefs.saveSlotModifiers, id: id) { [weak self] in
                self?.onSaveSlot(slotNumber: i)
            }
        }
        
        // Copy slot hotkeys: user-configured modifier + 1..9
        for i in 1...9 {
            let keyCode = keyCodeForNumber(i)
            let id = UInt32(100 + i)
            registerHotkey(keyCode: keyCode, modifiers: prefs.pasteSlotModifiers, id: id) { [weak self] in
                self?.onCopySlotToClipboard(slotNumber: i)
            }
        }
        
        // Open Panel: user-configured key + modifier
        registerHotkey(keyCode: prefs.openPanelKeyCode, modifiers: prefs.openPanelModifiers, id: 200) { [weak self] in
            self?.onOpenPanel()
        }
    }
    
    func unregisterAllHotkeys() {
        // Remove the event handler first, so no further callbacks can arrive.
        if let ref = eventHandlerRef {
            RemoveEventHandler(ref)
            eventHandlerRef = nil
        }
        eventHandlerUPP = nil
        
        // Unregister individual hotkeys after the handler is gone.
        for hotkey in hotkeys {
            UnregisterEventHotKey(hotkey)
        }
        hotkeys.removeAll()
        handlers.removeAll()
    }
    
    private func registerHotkey(
        keyCode: UInt32,
        modifiers: UInt32,
        id: UInt32,
        action: @escaping () -> Void
    ) {
        var eventHotKey: EventHotKeyRef?
        let signature = FourCharCode(string: "CLIP")
        let gHotKeyID = EventHotKeyID(signature: OSType(signature), id: id)
        let status = RegisterEventHotKey(
            keyCode,
            modifiers,
            gHotKeyID,
            GetEventDispatcherTarget(),
            0,
            &eventHotKey
        )
        if status == noErr, let eventHotKey = eventHotKey {
            hotkeys.append(eventHotKey)
            handlers[id] = action
        } else {
            print("[Clipo] Failed to register hotkey id \(id), status: \(status)")
            NotificationService.shared.showNotification(
                title: L10n.string(.hotkeyRegistrationFailedTitle),
                body: L10n.string(.hotkeyRegistrationFailedTemplate, id),
                isError: true
            )
        }
    }
    
    func handleHotkeyEvent(id: UInt32) {
        DispatchQueue.main.async { [weak self] in
            self?.handlers[id]?()
        }
    }
    
    // MARK: - Actions
    
    private func onSaveSlot(slotNumber: Int) {
        saveSelectionToSlot(number: slotNumber)
    }

    func saveSelectionToSlot(number slotNumber: Int) {
        guard PermissionService.shared.hasAccessibilityPermission() else {
            NotificationService.shared.showNotification(
                title: L10n.string(.notificationPermissionRequiredTitle),
                body: PermissionService.shared.accessibilityRequiredMessage(action: L10n.string(.footerSave).lowercased()),
                isError: true
            )
            return
        }
        
        if AppDetectionService.shared.isCurrentAppSensitive() && ClipStore.shared.settings.ignoreSensitiveApps {
            NotificationService.shared.showNotification(
                title: L10n.string(.notificationSensitiveAppIgnoredTitle),
                body: L10n.string(.notificationSensitiveAppIgnoredBody)
            )
            return
        }
        
        // Capture the frontmost app *before* the async copy delay
        // so we record the correct source even if the user switches apps.
        let appName = AppDetectionService.shared.currentFrontmostAppName()
        let bundleId = AppDetectionService.shared.currentFrontmostBundleIdentifier()
        
        PasteService.shared.copySelectionAndReadItem(sourceApp: appName, sourceBundleIdentifier: bundleId) { item in
            guard let item = item else {
                NotificationService.shared.showNotification(
                    title: L10n.string(.notificationSaveFailedTitle),
                    body: L10n.string(.notificationSaveFailedBody),
                    isError: true
                )
                return
            }

            ClipStore.shared.saveItemToSlot(number: slotNumber, item: item)
            SoundService.shared.playSave()
            NotificationService.shared.showNotification(
                title: L10n.string(.notificationSavedToSlotTemplate, slotNumber),
                body: item.preview
            )
        }
    }
    
    private func onCopySlotToClipboard(slotNumber: Int) {
        guard let item = ClipStore.shared.slots[slotNumber] else {
            NotificationService.shared.showNotification(
                title: L10n.string(.notificationSlotEmptyTemplate, slotNumber),
                body: L10n.string(.notificationCopiedBody)
            )
            return
        }
        
        let changeCount = ClipboardService.shared.writeClipItemToPasteboard(item)
        ClipboardHistoryService.shared.ignoreChangeCount(changeCount)
        ClipStore.shared.recordHistoryItem(item)
        SoundService.shared.playCopy()
        NotificationService.shared.showNotification(
            title: L10n.string(.notificationCopiedTitle),
            body: L10n.string(.notificationCopiedBody)
        )
        
        // Update lastUsedAt timestamp in both slot and matching history.
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
    
    private func onOpenPanel() {
        PanelWindowService.shared.togglePanel()
    }
    
    // MARK: - Key Code Mapping
    
    private func keyCodeForNumber(_ number: Int) -> UInt32 {
        switch number {
        case 1: return 18
        case 2: return 19
        case 3: return 20
        case 4: return 21
        case 5: return 23
        case 6: return 22
        case 7: return 26
        case 8: return 28
        case 9: return 25
        default: return 0
        }
    }
}

// MARK: - FourCharCode Helper

extension FourCharCode {
    init(string: String) {
        self = string.utf8.reduce(0) { soFar, byte in
            (soFar << 8) | FourCharCode(byte)
        }
    }
}
