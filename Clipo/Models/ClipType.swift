enum ClipType: String, Codable, CaseIterable {
    case plainText
    case url
    case codeLikeText
    case image
    case file
    case richText
    case data
}

extension ClipType {
    var displayName: String {
        switch self {
        case .plainText: return L10n.string(.typeText)
        case .url: return L10n.string(.typeURL)
        case .codeLikeText: return L10n.string(.typeCode)
        case .image: return L10n.string(.typeImage)
        case .file: return L10n.string(.typeFile)
        case .richText: return L10n.string(.typeRich)
        case .data: return L10n.string(.typeData)
        }
    }
}
