import Foundation

enum AppLanguage: String, Codable, CaseIterable, Identifiable {
    case english = "en"
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"
    case japanese = "ja"
    case korean = "ko"
    case french = "fr"
    case german = "de"
    case spanish = "es"
    case russian = "ru"
    case portuguese = "pt"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english:            return "English"
        case .simplifiedChinese:  return "简体中文"
        case .traditionalChinese: return "繁體中文"
        case .japanese:           return "日本語"
        case .korean:             return "한국어"
        case .french:             return "Français"
        case .german:             return "Deutsch"
        case .spanish:            return "Español"
        case .russian:            return "Русский"
        case .portuguese:         return "Português"
        }
    }
    
    var localeIdentifier: String {
        switch self {
        case .english:            return "en"
        case .simplifiedChinese:  return "zh-Hans"
        case .traditionalChinese: return "zh-Hant"
        case .japanese:           return "ja"
        case .korean:             return "ko"
        case .french:             return "fr"
        case .german:             return "de"
        case .spanish:            return "es"
        case .russian:            return "ru"
        case .portuguese:         return "pt"
        }
    }
}
