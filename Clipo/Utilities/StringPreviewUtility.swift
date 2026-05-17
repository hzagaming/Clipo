import Foundation

struct StringPreviewUtility {
    static func makePreview(from content: String, maxLength: Int = 60) -> String {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        // Normalize all line endings (\r\n, \r, \n) to spaces, then collapse
        // multiple consecutive spaces into a single space.
        let singleLine = trimmed
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
            .components(separatedBy: "\n")
            .joined(separator: " ")
            .replacingOccurrences(of: "  +", with: " ", options: .regularExpression)
        if singleLine.count <= maxLength {
            return singleLine
        }
        let index = singleLine.index(singleLine.startIndex, offsetBy: maxLength)
        return String(singleLine[..<index]) + "..."
    }
}
