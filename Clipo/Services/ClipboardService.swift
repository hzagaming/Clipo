import AppKit

class ClipboardService {
    static let shared = ClipboardService()
    
    func readTextFromPasteboard() -> String? {
        return NSPasteboard.general.string(forType: .string)
    }

    func readClipItemFromPasteboard(
        sourceApp: String? = nil,
        sourceBundleIdentifier: String? = nil,
        slotNumber: Int? = nil
    ) -> ClipItem? {
        guard let payload = PasteboardPayload.capture() else { return nil }
        let backedUpPayload = FileBackupService.shared.backupFiles(in: payload)
        return ClipItem(
            pasteboardPayload: backedUpPayload,
            sourceApp: sourceApp,
            sourceBundleIdentifier: sourceBundleIdentifier,
            slotNumber: slotNumber
        )
    }
    
    func writeTextToPasteboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }

    @discardableResult
    func writeClipItemToPasteboard(_ item: ClipItem) -> Int {
        if let payload = item.pasteboardPayload {
            payload.write()
        } else {
            writeTextToPasteboard(item.content)
        }
        return NSPasteboard.general.changeCount
    }
    
    func snapshotPasteboard() -> PasteboardSnapshot {
        return PasteboardSnapshot()
    }
    
    func restorePasteboard(_ snapshot: PasteboardSnapshot) {
        snapshot.restore()
    }
    
    func clearPasteboard() {
        NSPasteboard.general.clearContents()
    }
}
