import Foundation

struct ClipItem: Identifiable, Codable, Equatable {
    let id: UUID
    var content: String
    var preview: String
    var type: ClipType
    var pasteboardPayload: PasteboardPayload?
    var sourceApp: String?
    var sourceBundleIdentifier: String?
    var createdAt: Date
    var lastUsedAt: Date
    var isPinned: Bool
    var slotNumber: Int?
    
    init(
        id: UUID = UUID(),
        content: String,
        preview: String? = nil,
        type: ClipType = .plainText,
        pasteboardPayload: PasteboardPayload? = nil,
        sourceApp: String? = nil,
        sourceBundleIdentifier: String? = nil,
        createdAt: Date = Date(),
        lastUsedAt: Date = Date(),
        isPinned: Bool = false,
        slotNumber: Int? = nil
    ) {
        self.id = id
        self.content = content
        self.preview = preview ?? StringPreviewUtility.makePreview(from: content)
        self.type = type
        self.pasteboardPayload = pasteboardPayload
        self.sourceApp = sourceApp
        self.sourceBundleIdentifier = sourceBundleIdentifier
        self.createdAt = createdAt
        self.lastUsedAt = lastUsedAt
        self.isPinned = isPinned
        self.slotNumber = slotNumber
    }

    init(
        id: UUID = UUID(),
        pasteboardPayload: PasteboardPayload,
        sourceApp: String? = nil,
        sourceBundleIdentifier: String? = nil,
        createdAt: Date = Date(),
        lastUsedAt: Date = Date(),
        isPinned: Bool = false,
        slotNumber: Int? = nil
    ) {
        let searchableText = pasteboardPayload.searchableText
        self.init(
            id: id,
            content: searchableText.isEmpty ? pasteboardPayload.preview : searchableText,
            preview: pasteboardPayload.preview,
            type: pasteboardPayload.inferredType,
            pasteboardPayload: pasteboardPayload,
            sourceApp: sourceApp,
            sourceBundleIdentifier: sourceBundleIdentifier,
            createdAt: createdAt,
            lastUsedAt: lastUsedAt,
            isPinned: isPinned,
            slotNumber: slotNumber
        )
    }
}
