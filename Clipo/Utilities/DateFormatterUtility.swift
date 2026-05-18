import Foundation

struct DateFormatterUtility {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func formattedString(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        if interval < 60 {
            return L10n.string(.justNow)
        } else if interval < 3600 {
            return L10n.string(.minutesAgoTemplate, Int(interval / 60))
        } else if interval < 86400 {
            return L10n.string(.hoursAgoTemplate, Int(interval / 3600))
        } else {
            return dateFormatter.string(from: date)
        }
    }
}
