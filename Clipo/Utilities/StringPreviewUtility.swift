import Foundation

struct StringPreviewUtility {
    static func makePreview(from content: String, maxLength: Int = 60) -> String {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        let singleLine = trimmed.components(separatedBy: .newlines).joined(separator: " ")
        if singleLine.count <= maxLength {
            return singleLine
        }
        let index = singleLine.index(singleLine.startIndex, offsetBy: maxLength)
        return String(singleLine[..<index]) + "..."
    }
}
