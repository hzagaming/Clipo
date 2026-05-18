import Foundation
import Combine

class ClipStore: ObservableObject {
    @Published var slots: [Int: ClipItem] = [:]
    @Published var history: [ClipItem] = []
    
    /// Automatically persists settings whenever they change.
    @Published var settings: AppSettings = AppSettings() {
        didSet {
            if !isLoading {
                if oldValue.maxHistoryItems != settings.maxHistoryItems {
                    trimHistory()
                }
                if oldValue.language != settings.language {
                    NotificationCenter.default.post(name: .languageChanged, object: settings.language)
                }
                save()
            }
        }
    }
    
    /// Prevents triggering save() during initial load().
    private var isLoading = false
    
    private let storageService = StorageService.shared
    static let shared = ClipStore()
    
    private init() {
        load()
    }
    
    func load() {
        isLoading = true
        defer { isLoading = false }
        
        let store = storageService.loadStore()
        self.slots = store.slots
        self.history = store.history
        self.settings = store.settings
        
        // Ensure loaded history respects the current max limit.
        trimHistory()
    }
    
    func save() {
        storageService.saveStore(slots: slots, history: history, settings: settings)
    }
    
    func saveToSlot(number: Int, content: String, sourceApp: String? = nil, sourceBundleIdentifier: String? = nil) {
        // Reject empty or whitespace-only content.
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let type = detectType(content: content)
        let preview = StringPreviewUtility.makePreview(from: content)
        
        let item = ClipItem(
            content: content,
            preview: preview,
            type: type,
            sourceApp: sourceApp,
            sourceBundleIdentifier: sourceBundleIdentifier,
            slotNumber: number
        )
        
        slots[number] = item
        addToHistory(item: item)
        save()
    }

    func saveItemToSlot(number: Int, item: ClipItem) {
        var slotItem = item
        slotItem.slotNumber = number
        slotItem.lastUsedAt = Date()

        slots[number] = slotItem
        addToHistory(item: slotItem)
        save()
    }
    
    func addToHistory(item: ClipItem) {
        var newItem = item
        newItem.slotNumber = nil
        
        if settings.ignoreDuplicateHistory,
           let mostRecent = history.first(where: { !$0.isPinned }),
           mostRecent.content == newItem.content {
            // Update timestamp of existing duplicate instead of adding a new entry.
            if let index = history.firstIndex(where: { $0.id == mostRecent.id }) {
                history[index].lastUsedAt = Date()
            }
            return
        }
        
        history.insert(newItem, at: 0)
        trimHistory()
    }

    func recordHistoryItem(_ item: ClipItem) {
        addToHistory(item: item)
        save()
    }
    
    func trimHistory() {
        let maxItems = settings.maxHistoryItems
        var pinned = history.filter { $0.isPinned }
        var unpinned = history.filter { !$0.isPinned }
        
        // Respect the total limit: cap pinned at maxItems, then fill remainder with unpinned.
        if pinned.count > maxItems {
            pinned = Array(pinned.prefix(maxItems))
        }
        let availableForUnpinned = max(0, maxItems - pinned.count)
        if unpinned.count > availableForUnpinned {
            unpinned = Array(unpinned.prefix(availableForUnpinned))
        }
        
        // Sort pinned by lastUsedAt descending, then unpinned by order (already newest first).
        pinned.sort { $0.lastUsedAt > $1.lastUsedAt }
        history = pinned + unpinned
    }
    
    func togglePin(id: UUID) {
        guard let index = history.firstIndex(where: { $0.id == id }) else { return }
        var item = history[index]
        item.isPinned.toggle()
        item.lastUsedAt = Date()
        history[index] = item
        trimHistory()
        save()
    }
    
    func deleteHistoryItem(id: UUID) {
        history.removeAll { $0.id == id }
        save()
    }
    
    func clearHistory() {
        let pinned = history.filter { $0.isPinned }
        history = pinned
        trimHistory()
        save()
    }
    
    func deleteSlot(number: Int) {
        slots.removeValue(forKey: number)
        save()
    }
    
    func resetSlots() {
        slots = [:]
        save()
    }
    
    func resetAllData() {
        let wasLaunchAtLogin = settings.launchAtLogin
        slots = [:]
        history = []
        FileBackupService.shared.removeAllBackups()
        // Temporarily suppress didSet to avoid a redundant save() call.
        isLoading = true
        settings = AppSettings()
        isLoading = false
        if wasLaunchAtLogin {
            LaunchAtLoginService.shared.setLaunchAtLogin(false)
        }
        save()
    }
    
    /// Replaces in-memory data with imported values and persists immediately.
    /// Used by Settings > Data > Import JSON.
    func importData(slots: [Int: ClipItem], history: [ClipItem], settings: AppSettings) {
        isLoading = true
        self.slots = slots
        self.history = history
        self.settings = settings
        isLoading = false
        save()
    }
    
    private func detectType(content: String) -> ClipType {
        if URLDetector.isValidURL(content) {
            return .url
        }
        if CodeLikeDetector.isCodeLike(content) {
            return .codeLikeText
        }
        return .plainText
    }
}
