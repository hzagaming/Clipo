import Foundation

class ClipboardViewModel: ObservableObject {
    @Published var store = ClipStore.shared
    
    func copySlotToClipboard(slotNumber: Int) {
        if let item = store.slots[slotNumber] {
            ClipboardService.shared.writeTextToPasteboard(item.content)
            NotificationService.shared.showNotification(title: "Copied", body: item.preview)
        }
    }
    
    func pasteSlot(slotNumber: Int) {
        if let item = store.slots[slotNumber] {
            let shouldRestore = store.settings.restoreClipboardAfterPaste
            PasteService.shared.pasteText(item.content, restorePrevious: shouldRestore)
        }
    }
}
