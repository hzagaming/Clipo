import Foundation

struct CodeLikeDetector {
    static let codeIndicators = [
        ";", "{", "}", "import ", "function ", "class ", "const ", "let ", "var ",
        "return", "=>", "public ", "private ", "struct ", "enum ", "func ", "def ",
        "#include", "using namespace", "console.log", "print(", "printf(", "async ",
        "await", "try {", "catch", "throw ", "new ", "typeof ", "instanceof", "package ",
        "extension ", "protocol ", "interface ", "delegate ", "override ", "init(", "self."
    ]
    
    static func isCodeLike(_ text: String) -> Bool {
        let lines = text.components(separatedBy: .newlines)
        
        // Multi-line with indentation is a strong indicator.
        if lines.count >= 3 {
            let indentedLines = lines.filter { $0.hasPrefix("    ") || $0.hasPrefix("\t") }
            if indentedLines.count >= 2 {
                return true
            }
        }
        
        let lower = text.lowercased()
        let matches = codeIndicators.filter { lower.contains($0.lowercased()) }
        return matches.count >= 2 || (lines.count > 2 && matches.count >= 1)
    }
}
