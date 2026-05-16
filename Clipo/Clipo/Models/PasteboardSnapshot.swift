import AppKit

/// A runtime snapshot of the system pasteboard for restoration.
/// This is intentionally not Codable because NSPasteboardItem is an AppKit object.
class PasteboardSnapshot {
    private let items: [NSPasteboardItem]
    
    init() {
        guard let pbItems = NSPasteboard.general.pasteboardItems else {
            self.items = []
            return
        }
        // Deep copy pasteboard items because NSPasteboard general may change.
        self.items = pbItems.compactMap { item in
            let newItem = NSPasteboardItem()
            for type in item.types {
                if let data = item.data(forType: type) {
                    newItem.setData(data, forType: type)
                }
            }
            return newItem
        }
    }
    
    func restore() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        if !items.isEmpty {
            pasteboard.writeObjects(items)
        }
    }
}
