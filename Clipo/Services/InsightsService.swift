import Foundation

/// Aggregates clipboard usage statistics from existing ClipStore data.
/// No persistent state — all metrics are computed on-demand from memory.
class InsightsService {
    static let shared = InsightsService()
    private init() {}
    
    // MARK: - Cached Formatter
    
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    // MARK: - Top-Level Metrics
    
    func copiesToday() -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        return ClipStore.shared.history.filter { $0.createdAt >= startOfDay }.count
    }
    
    func copiesLast7Days() -> Int {
        guard let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return 0 }
        return ClipStore.shared.history.filter { $0.createdAt >= weekAgo }.count
    }
    
    func totalCopies() -> Int {
        return ClipStore.shared.history.count
    }
    
    func uniqueSourcesCount() -> Int {
        let sources = ClipStore.shared.history.compactMap { $0.sourceApp }
        return Set(sources).count
    }
    
    // MARK: - Most Used Slot
    
    func mostUsedSlot() -> (number: Int, item: ClipItem, useCount: Int)? {
        let slots = ClipStore.shared.slots
        guard !slots.isEmpty else { return nil }
        let freq = contentFrequencies()
        
        return slots.compactMap { num, item in
            (number: num, item: item, useCount: freq[item.content] ?? 0)
        }.max { $0.useCount < $1.useCount }
    }
    
    // MARK: - Hourly Activity
    
    func hourlyActivity() -> [Int: Int] {
        var buckets = [Int: Int]()
        let calendar = Calendar.current
        for item in ClipStore.shared.history {
            let hour = calendar.component(.hour, from: item.createdAt)
            buckets[hour, default: 0] += 1
        }
        return buckets
    }
    
    func peakHour() -> Int? {
        let activity = hourlyActivity()
        guard !activity.isEmpty else { return nil }
        return activity.max { $0.value < $1.value }?.key
    }
    
    // MARK: - Content Type Distribution
    
    func typeDistribution() -> [(type: ClipType, count: Int, percentage: Double)] {
        let history = ClipStore.shared.history
        guard !history.isEmpty else { return [] }
        
        var counts = [ClipType: Int]()
        for item in history {
            counts[item.type, default: 0] += 1
        }
        
        let total = Double(history.count)
        return counts.map { (type: $0.key, count: $0.value, percentage: Double($0.value) / total) }
            .sorted { $0.count > $1.count }
    }
    
    // MARK: - Top Source Apps
    
    func topSourceApps(limit: Int = 5) -> [(name: String, count: Int, percentage: Double)] {
        let history = ClipStore.shared.history
        guard !history.isEmpty else { return [] }
        
        var counts = [String: Int]()
        for item in history {
            let name = item.sourceApp?.isEmpty == false ? item.sourceApp! : L10n.string(.unknownSource)
            counts[name, default: 0] += 1
        }
        
        let total = Double(history.count)
        return counts.map { (name: $0.key, count: $0.value, percentage: Double($0.value) / total) }
            .sorted { $0.count > $1.count }
            .prefix(limit)
            .map { $0 }
    }
    
    // MARK: - Daily Trend (Last 7 Days)
    
    func dailyTrend() -> [(date: Date, label: String, count: Int)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var result = [(date: Date, label: String, count: Int)]()
        
        // Pre-compute: group history by day
        var countsByDay = [Date: Int]()
        for item in ClipStore.shared.history {
            let day = calendar.startOfDay(for: item.createdAt)
            countsByDay[day, default: 0] += 1
        }
        
        let formatter = Self.dayFormatter
        formatter.locale = Locale(identifier: ClipStore.shared.settings.language.rawValue)
        
        for offset in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today),
                  let nextDay = calendar.date(byAdding: .day, value: 1, to: date) else { continue }
            let count = countsByDay.filter { $0.key >= date && $0.key < nextDay }.reduce(0) { $0 + $1.value }
            
            let label = offset == 0 ? L10n.string(.todayLabel) : formatter.string(from: date)
            result.append((date: date, label: label, count: count))
        }
        return result
    }
    
    // MARK: - Slot Utilization
    
    func slotUtilization() -> [(number: Int, isFilled: Bool, useCount: Int)] {
        let freq = contentFrequencies()
        return (1...9).map { num in
            guard let item = ClipStore.shared.slots[num] else {
                return (number: num, isFilled: false, useCount: 0)
            }
            return (number: num, isFilled: true, useCount: freq[item.content] ?? 0)
        }
    }
    
    func filledSlotCount() -> Int {
        return ClipStore.shared.slots.values.compactMap { $0 }.count
    }
    
    // MARK: - Private Helpers
    
    private func contentFrequencies() -> [String: Int] {
        var dict = [String: Int]()
        for item in ClipStore.shared.history {
            dict[item.content, default: 0] += 1
        }
        return dict
    }
}
