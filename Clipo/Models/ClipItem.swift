import Foundation

struct ClipItem: Identifiable, Codable, Equatable {
    let id: UUID
    var content: String
    var preview: String
    var type: ClipType
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
        self.sourceApp = sourceApp
        self.sourceBundleIdentifier = sourceBundleIdentifier
        self.createdAt = createdAt
        self.lastUsedAt = lastUsedAt
        self.isPinned = isPinned
        self.slotNumber = slotNumber
    }
}
