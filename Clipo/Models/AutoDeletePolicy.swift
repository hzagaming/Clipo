enum AutoDeletePolicy: String, Codable, CaseIterable, Identifiable {
    case never = "never"
    case oneDay = "oneDay"
    case sevenDays = "sevenDays"
    case thirtyDays = "thirtyDays"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .never: return "Never"
        case .oneDay: return "1 Day"
        case .sevenDays: return "7 Days"
        case .thirtyDays: return "30 Days"
        }
    }
}
