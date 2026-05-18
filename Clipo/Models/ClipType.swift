enum ClipType: String, Codable, CaseIterable {
    case plainText
    case url
    case codeLikeText
}

extension ClipType {
    var displayName: String {
        switch self {
        case .plainText: return "Text"
        case .url: return "URL"
        case .codeLikeText: return "Code"
        }
    }
}
