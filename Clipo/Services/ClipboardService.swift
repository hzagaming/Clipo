import AppKit

class ClipboardService {
    static let shared = ClipboardService()
    
    func readTextFromPasteboard() -> String? {
        return NSPasteboard.general.string(forType: .string)
    }
    
    func writeTextToPasteboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
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
