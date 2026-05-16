import AppKit

/// A runtime snapshot of the system pasteboard for restoration.
/// Stores only plain Swift data — no long-term Objective-C object references —
/// to avoid use-after-free crashes when the pasteboard changes or items are
/// deallocated on a background queue.
class PasteboardSnapshot {
    private let items: [[(type: NSPasteboard.PasteboardType, data: Data)]]
    
    init() {
        guard let pbItems = NSPasteboard.general.pasteboardItems else {
            self.items = []
            return
        }
        self.items = pbItems.map { item in
            item.types.compactMap { type in
                guard let data = item.data(forType: type) else { return nil }
                return (type: type, data: data)
            }
        }
    }
    
    func restore() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        let newItems: [NSPasteboardItem] = items.map { typesAndData in
            let newItem = NSPasteboardItem()
            for (type, data) in typesAndData {
                newItem.setData(data, forType: type)
            }
            return newItem
        }
        if !newItems.isEmpty {
            pasteboard.writeObjects(newItems)
        }
    }
}
