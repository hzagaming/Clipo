import Foundation

/// Aggregates clipboard usage statistics from existing ClipStore data.
/// No persistent state — all metrics are computed on-demand from memory.
class InsightsService {
    static let shared = InsightsService()
    private init() {}
    
    // MARK: - Top-Level Metrics
    
    func copiesToday() -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        return ClipStore.shared.history.filter { $0.createdAt >= startOfDay }.count
    }
    
    func copiesThisWeek() -> Int {
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
        
        var best: (number: Int, item: ClipItem, useCount: Int)?
        for (num, item) in slots {
            let count = ClipStore.shared.history.filter { $0.content == item.content }.count
            if best == nil || count > best!.useCount {
                best = (num, item, count)
            }
        }
        return best
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
            let name = item.sourceApp ?? L10n.string(.unknownSource)
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
        
        for offset in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { continue }
            let nextDay = calendar.date(byAdding: .day, value: 1, to: date)!
            let count = ClipStore.shared.history.filter { $0.createdAt >= date && $0.createdAt < nextDay }.count
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            let label = offset == 0 ? L10n.string(.todayLabel) : formatter.string(from: date)
            result.append((date: date, label: label, count: count))
        }
        return result
    }
    
    // MARK: - Slot Utilization
    
    func slotUtilization() -> [(number: Int, isFilled: Bool, useCount: Int)] {
        let history = ClipStore.shared.history
        return (1...9).map { num in
            let isFilled = ClipStore.shared.slots[num] != nil
            let count = isFilled ? history.filter { $0.content == ClipStore.shared.slots[num]!.content }.count : 0
            return (number: num, isFilled: isFilled, useCount: count)
        }
    }
    
    func filledSlotCount() -> Int {
        return ClipStore.shared.slots.values.compactMap { $0 }.count
    }
}
