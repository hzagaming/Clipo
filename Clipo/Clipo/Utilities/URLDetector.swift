import Foundation

struct URLDetector {
    static func isValidURL(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed),
              let scheme = url.scheme else {
            return false
        }
        return (scheme == "http" || scheme == "https") && !(url.host?.isEmpty ?? true)
    }
}
