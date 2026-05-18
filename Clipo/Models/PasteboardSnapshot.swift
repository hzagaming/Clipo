import AppKit

/// A runtime snapshot of the system pasteboard for restoration.
/// Stores only plain Swift data — no long-term Objective-C object references —
/// to avoid use-after-free crashes when the pasteboard changes or items are
/// deallocated on a background queue.
///
/// **Note on NSSecureCoding warnings:**
/// `NSPasteboard.writeObjects(_:)` internally serialises `NSPasteboardItem`
/// via `NSSecureCoding`, which triggers an Apple system-framework warning:
/// `-[NSXPCDecoder validateAllowedClass:forKey:] ... contains [NSObject class]`.
/// To avoid that, `restore()` writes data directly to the pasteboard with
/// `setData(_:forType:)` instead of creating temporary `NSPasteboardItem`s.
class PasteboardSnapshot {
    private let items: [[(type: NSPasteboard.PasteboardType, data: Data)]]
    
    /// Text-first strategy: only snapshot common textual / transferable types.
    /// This avoids iterating every `NSPasteboardItem` type, which can trigger
    /// `-[NSXPCDecoder validateAllowedClass:forKey:]` system warnings.
    private static let allowedTypes: [NSPasteboard.PasteboardType] = [
        .string,
        .rtf,
        NSPasteboard.PasteboardType("public.html"),
        NSPasteboard.PasteboardType("public.url"),
        NSPasteboard.PasteboardType("public.file-url"),
        NSPasteboard.PasteboardType("public.utf16-external-plain-text"),
        NSPasteboard.PasteboardType("public.utf16-plain-text"),
    ]
    
    init() {
        guard let pbItems = NSPasteboard.general.pasteboardItems else {
            self.items = []
            return
        }
        self.items = pbItems.map { item in
            Self.allowedTypes.compactMap { type in
                guard item.types.contains(type), let data = item.data(forType: type) else { return nil }
                return (type: type, data: data)
            }
        }
    }
    
    func restore() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        // Write the first item's types directly to the pasteboard.
        // Multi-item pasteboards are rare for a text-centric tool; if the
        // snapshot contains more than one item we still restore only the
        // first to avoid `writeObjects` and its accompanying NSSecureCoding
        // system warnings.
        guard let firstItem = items.first else { return }
        for (type, data) in firstItem {
            pasteboard.setData(data, forType: type)
        }
    }
}
