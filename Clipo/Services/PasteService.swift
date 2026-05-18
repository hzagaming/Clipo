import Cocoa
import CoreGraphics

class PasteService {
    static let shared = PasteService()
    
    /// Simulates Cmd+C, waits for the pasteboard to update, reads text,
    /// then optionally restores the previous pasteboard contents.
    func copySelectionAndReadText(completion: @escaping (String?) -> Void) {
        guard PermissionService.shared.hasAccessibilityPermission() else {
            completion(nil)
            return
        }
        
        let previousSnapshot = ClipboardService.shared.snapshotPasteboard()
        let previousChangeCount = NSPasteboard.general.changeCount
        simulateCommandC()

        // Some apps update the pasteboard slowly after a synthetic Cmd+C.
        // Poll briefly instead of using a single fixed delay.
        waitForPasteboardChange(previousChangeCount: previousChangeCount, deadline: Date().addingTimeInterval(0.8)) { didCopyNewContent, text in
            if didCopyNewContent && ClipStore.shared.settings.restoreClipboardAfterSave {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    ClipboardService.shared.restorePasteboard(previousSnapshot)
                }
            }
            
            completion(text)
        }
    }
    
    /// Writes text to the pasteboard, simulates Cmd+V, then optionally restores previous contents.
    func pasteText(_ text: String, restorePrevious: Bool = true) {
        guard PermissionService.shared.hasAccessibilityPermission() else {
            NotificationService.shared.showNotification(
                title: "Permission Required",
                body: "Clipo needs Accessibility permission to paste text.",
                isError: true
            )
            return
        }
        
        let previousSnapshot = restorePrevious ? ClipboardService.shared.snapshotPasteboard() : nil
        ClipboardService.shared.writeTextToPasteboard(text)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.simulateCommandV()
            
            if let snapshot = previousSnapshot, restorePrevious {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
                    ClipboardService.shared.restorePasteboard(snapshot)
                }
            }
        }
    }
    
    func simulateCommandC() {
        // CGKeyCode 8 == 'c'
        simulateKeyPress(keyCode: 8, flags: .maskCommand)
    }
    
    func simulateCommandV() {
        // CGKeyCode 9 == 'v'
        simulateKeyPress(keyCode: 9, flags: .maskCommand)
    }

    private func waitForPasteboardChange(
        previousChangeCount: Int,
        deadline: Date,
        completion: @escaping (Bool, String?) -> Void
    ) {
        let pasteboard = NSPasteboard.general
        if pasteboard.changeCount != previousChangeCount {
            completion(true, ClipboardService.shared.readTextFromPasteboard())
            return
        }

        guard Date() < deadline else {
            completion(false, nil)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.waitForPasteboardChange(
                previousChangeCount: previousChangeCount,
                deadline: deadline,
                completion: completion
            )
        }
    }
    
    private func simulateKeyPress(keyCode: CGKeyCode, flags: CGEventFlags) {
        let source = CGEventSource(stateID: .combinedSessionState)
        guard let keyDown = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true),
              let keyUp = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false) else {
            return
        }
        keyDown.flags = flags
        keyUp.flags = flags
        keyDown.post(tap: .cghidEventTap)
        keyUp.post(tap: .cghidEventTap)
    }
}
