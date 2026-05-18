import SwiftUI

struct InsightsView: View {
    @StateObject private var store = ClipStore.shared
    @State private var appearAnimation = false
    
    private var service: InsightsService { InsightsService.shared }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // Top stat cards
                statCardsRow
                
                // Daily trend chart
                trendSection
                
                // Hourly activity
                hourlySection
                
                // Content type distribution
                typeDistributionSection
                
                // Top source apps
                topSourcesSection
                
                // Slot utilization grid
                slotGridSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .opacity(appearAnimation ? 1 : 0)
            .offset(y: appearAnimation ? 0 : 12)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                appearAnimation = true
            }
        }
        .onDisappear {
            appearAnimation = false
        }
    }
    
    // MARK: - Stat Cards
    
    private var statCardsRow: some View {
        let stats: [(value: String, label: String, icon: String, color: Color)] = [
            ("\(service.copiesToday())", L10n.string(.statTodayLabel), "doc.on.clipboard", .blue),
            ("\(service.copiesThisWeek())", L10n.string(.statWeekLabel), "calendar", .purple),
            ("\(service.totalCopies())", L10n.string(.statTotalLabel), "archivebox", .green),
            ("\(service.uniqueSourcesCount())", L10n.string(.statSourcesLabel), "app.badge", .orange)
        ]
        
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(Array(stats.enumerated()), id: \.offset) { index, stat in
                StatCard(value: stat.value, label: stat.label, icon: stat.icon, color: stat.color)
                    .opacity(appearAnimation ? 1 : 0)
                    .offset(y: appearAnimation ? 0 : 8)
                    .animation(.easeOut(duration: 0.25).delay(Double(index) * 0.05), value: appearAnimation)
            }
        }
    }
    
    // MARK: - Daily Trend
    
    private var trendSection: some View {
        let data = service.dailyTrend()
        let maxCount = max(data.map(\.count).max() ?? 1, 1)
        
        return InsightCard(title: L10n.string(.trendTitle), icon: "chart.line.uptrend.xyaxis") {
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(Color.accentColor.opacity(point.count == 0 ? 0.15 : 0.7))
                            .frame(width: 28, height: CGFloat(point.count) / CGFloat(maxCount) * 100)
                            .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.04), value: appearAnimation)
                        
                        Text(point.label)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.6))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
    
    // MARK: - Hourly Activity
    
    private var hourlySection: some View {
        let data = service.hourlyActivity()
        let maxCount = max(data.values.max() ?? 1, 1)
        let peak = service.peakHour()
        
        return InsightCard(title: L10n.string(.hourlyTitle), icon: "clock") {
            VStack(spacing: 6) {
                HStack(spacing: 2) {
                    ForEach(0..<24) { hour in
                        let count = data[hour] ?? 0
                        RoundedRectangle(cornerRadius: 1.5, style: .continuous)
                            .fill(
                                hour == peak
                                ? Color.accentColor
                                : Color.accentColor.opacity(count == 0 ? 0.08 : 0.5)
                            )
                            .frame(height: CGFloat(count) / CGFloat(maxCount) * 60)
                    }
                }
                
                HStack {
                    Text("00:00")
                    Spacer()
                    if let peak = peak {
                        Text(L10n.string(.peakHourTemplate, peak))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.accentColor)
                    }
                    Spacer()
                    Text("23:00")
                }
                .font(.system(size: 9))
                .foregroundColor(.secondary.opacity(0.4))
            }
            .padding(.vertical, 4)
        }
    }
    
    // MARK: - Type Distribution
    
    private var typeDistributionSection: some View {
        let data = service.typeDistribution()
        
        return InsightCard(title: L10n.string(.typeDistTitle), icon: "chart.pie") {
            if data.isEmpty {
                Text(L10n.string(.noDataLabel))
                    .font(.system(size: 13))
                    .foregroundColor(.secondary.opacity(0.5))
                    .frame(maxWidth: .infinity, minHeight: 80)
            } else {
                HStack(spacing: 20) {
                    // Donut chart
                    ZStack {
                        Circle()
                            .stroke(Color.secondary.opacity(0.08), lineWidth: 16)
                        
                        let total = data.reduce(0) { $0 + $1.percentage }
                        let normalized = data.map { (type: $0.type, percentage: $0.percentage / total) }
                        
                        DonutChart(segments: normalized)
                            .frame(width: 80, height: 80)
                    }
                    
                    // Legend
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(Array(data.prefix(4).enumerated()), id: \.offset) { _, segment in
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(segment.type.filterColor)
                                    .frame(width: 8, height: 8)
                                Text(segment.type.displayName)
                                    .font(.system(size: 11))
                                Text("\(Int(segment.percentage * 100))%")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    // MARK: - Top Sources
    
    private var topSourcesSection: some View {
        let data = service.topSourceApps(limit: 5)
        let maxCount = max(data.map(\.count).max() ?? 1, 1)
        
        return InsightCard(title: L10n.string(.topSourcesTitle), icon: "app") {
            if data.isEmpty {
                Text(L10n.string(.noDataLabel))
                    .font(.system(size: 13))
                    .foregroundColor(.secondary.opacity(0.5))
                    .frame(maxWidth: .infinity, minHeight: 60)
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, source in
                        HStack(spacing: 8) {
                            Text("\(index + 1)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 18, height: 18)
                                .background(
                                    Circle()
                                        .fill(Color.accentColor.opacity(0.7))
                                )
                            
                            Text(source.name)
                                .font(.system(size: 12))
                                .lineLimit(1)
                            
                            Spacer()
                            
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                                        .fill(Color.secondary.opacity(0.08))
                                        .frame(width: geo.size.width, height: 6)
                                    
                                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                                        .fill(Color.accentColor.opacity(0.6))
                                        .frame(
                                            width: CGFloat(source.count) / CGFloat(maxCount) * geo.size.width,
                                            height: 6
                                        )
                                        .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.06), value: appearAnimation)
                                }
                            }
                            .frame(width: 80, height: 6)
                            
                            Text("\(source.count)")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary.opacity(0.7))
                                .frame(width: 24, alignment: .trailing)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    // MARK: - Slot Grid
    
    private var slotGridSection: some View {
        let slots = service.slotUtilization()
        let filled = service.filledSlotCount()
        
        return InsightCard(title: L10n.string(.slotUtilTitle), icon: "square.grid.2x2") {
            VStack(spacing: 10) {
                HStack(spacing: 8) {
                    ForEach(slots, id: \.number) { slot in
                        VStack(spacing: 3) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(
                                        slot.isFilled
                                        ? Color.accentColor.opacity(0.15)
                                        : Color.secondary.opacity(0.06)
                                    )
                                    .frame(width: 36, height: 36)
                                
                                if slot.isFilled {
                                    Text("\(slot.number)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.accentColor)
                                } else {
                                    Text("\(slot.number)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary.opacity(0.3))
                                }
                            }
                            
                            if slot.isFilled {
                                Text("\(slot.useCount)")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(.accentColor.opacity(0.8))
                            } else {
                                Text("—")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary.opacity(0.25))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Text(L10n.string(.slotUtilTemplate, filled, 9))
                    .font(.system(size: 11))
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Subviews

private struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(color.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor))
        )
    }
}

private struct InsightCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary.opacity(0.7))
                    .textCase(.uppercase)
                    .tracking(0.5)
                Spacer()
            }
            
            content
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor))
        )
    }
}

// MARK: - Donut Chart

private struct DonutChart: View {
    let segments: [(type: ClipType, percentage: Double)]
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - 8
            let lineWidth: CGFloat = 14
            
            var startAngle = -Double.pi / 2
            
            for segment in segments {
                let sweep = segment.percentage * 2 * Double.pi
                let endAngle = startAngle + sweep
                
                var path = Path()
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: .radians(startAngle),
                    endAngle: .radians(endAngle),
                    clockwise: false
                )
                
                context.stroke(path, with: .color(segment.type.filterColor), lineWidth: lineWidth)
                startAngle = endAngle
            }
        }
    }
}
