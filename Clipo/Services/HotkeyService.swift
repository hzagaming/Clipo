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
    func registerAllHotkeys() {
        unregisterAllHotkeys()
        
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
        
        // Save hotkeys: Cmd + Option + 1..9
        for i in 1...9 {
            let keyCode = keyCodeForNumber(i)
            let id = UInt32(i)
            registerHotkey(keyCode: keyCode, modifiers: UInt32(cmdKey) | UInt32(optionKey), id: id) { [weak self] in
                self?.onSaveSlot(slotNumber: i)
            }
        }
        
        // Paste hotkeys: Ctrl + Option + 1..9
        for i in 1...9 {
            let keyCode = keyCodeForNumber(i)
            let id = UInt32(100 + i)
            registerHotkey(keyCode: keyCode, modifiers: UInt32(controlKey) | UInt32(optionKey), id: id) { [weak self] in
                self?.onPasteSlot(slotNumber: i)
            }
        }
        
        // Open Panel: Option + Space
        registerHotkey(keyCode: 49, modifiers: UInt32(optionKey), id: 200) { [weak self] in
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
                title: "Hotkey Registration Failed",
                body: "Shortcut id \(id) could not be registered. It may conflict with another app."
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
        guard PermissionService.shared.hasAccessibilityPermission() else {
            NotificationService.shared.showNotification(
                title: "Permission Required",
                body: "Clipo needs Accessibility permission to save text."
            )
            return
        }
        
        if AppDetectionService.shared.isCurrentAppSensitive() && ClipStore.shared.settings.ignoreSensitiveApps {
            NotificationService.shared.showNotification(
                title: "Sensitive App Ignored",
                body: "Clipo does not auto-save from password managers."
            )
            return
        }
        
        PasteService.shared.copySelectionAndReadText { text in
            guard let text = text, !text.isEmpty else {
                NotificationService.shared.showNotification(
                    title: "Save Failed",
                    body: "No text selected or clipboard is empty."
                )
                return
            }
            
            let appName = AppDetectionService.shared.currentFrontmostAppName()
            let bundleId = AppDetectionService.shared.currentFrontmostBundleIdentifier()
            
            ClipStore.shared.saveToSlot(
                number: slotNumber,
                content: text,
                sourceApp: appName,
                sourceBundleIdentifier: bundleId
            )
            SoundService.shared.playSave()
            NotificationService.shared.showNotification(
                title: "Saved to Slot \(slotNumber)",
                body: StringPreviewUtility.makePreview(from: text)
            )
        }
    }
    
    private func onPasteSlot(slotNumber: Int) {
        guard let item = ClipStore.shared.slots[slotNumber] else {
            NotificationService.shared.showNotification(
                title: "Slot \(slotNumber) Empty",
                body: "Nothing has been saved to this slot yet."
            )
            return
        }
        
        let shouldRestore = ClipStore.shared.settings.restoreClipboardAfterPaste
        SoundService.shared.playPaste()
        PasteService.shared.pasteText(item.content, restorePrevious: shouldRestore)
        
        // Update lastUsedAt timestamp.
        if var item = ClipStore.shared.slots[slotNumber] {
            item.lastUsedAt = Date()
            ClipStore.shared.slots[slotNumber] = item
        }
        ClipStore.shared.save()
    }
    
    private func onOpenPanel() {
        SoundService.shared.playOpen()
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
