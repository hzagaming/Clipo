import AppKit

/// A runtime snapshot of the system pasteboard for restoration.
/// Stores only plain Swift data — no long-term Objective-C object references —
/// to avoid use-after-free crashes when the pasteboard changes or items are
/// deallocated on a background queue.
///
/// Captures pasteboard item representations as data so text, URLs, images,
/// rich text, and file references can be restored without keeping pasteboard
/// objects alive across changes.
class PasteboardSnapshot {
    private let payload: PasteboardPayload?
    
    init() {
        self.payload = PasteboardPayload.capture()
    }
    
    func restore() {
        payload?.write()
    }
}
