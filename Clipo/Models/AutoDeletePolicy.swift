import Foundation

enum AutoDeletePolicy: String, Codable, CaseIterable, Identifiable {
    case never = "never"
    case oneDay = "oneDay"
    case sevenDays = "sevenDays"
    case thirtyDays = "thirtyDays"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .never: return L10n.string(.autoDeleteNever)
        case .oneDay: return L10n.string(.autoDeleteOneDay)
        case .sevenDays: return L10n.string(.autoDeleteSevenDays)
        case .thirtyDays: return L10n.string(.autoDeleteThirtyDays)
        }
    }

    func cutoffDate(relativeTo date: Date = Date()) -> Date? {
        let calendar = Calendar.current
        switch self {
        case .never:
            return nil
        case .oneDay:
            return calendar.date(byAdding: .day, value: -1, to: date)
        case .sevenDays:
            return calendar.date(byAdding: .day, value: -7, to: date)
        case .thirtyDays:
            return calendar.date(byAdding: .day, value: -30, to: date)
        }
    }
}
