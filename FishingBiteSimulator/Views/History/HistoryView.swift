import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedMonth = Date()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Streak
                if dataManager.currentStreak > 0 {
                    streakCard
                }
                
                // Calendar
                calendarSection
                
                // Recent sessions
                recentSessionsSection
                
                // All-time stats
                allTimeStatsSection
            }
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 16)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Training History")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Text("Track your progress over time")
                .font(.system(size: 16))
                .foregroundColor(AppTheme.textSecondary)
        }
    }
    
    // MARK: - Streak Card
    
    private var streakCard: some View {
        HStack(spacing: 16) {
            IconView(name: "flame", size: 40, color: AppTheme.warning)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(dataManager.currentStreak) Day Streak!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Keep training to maintain your streak")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                        .strokeBorder(AppTheme.warning.opacity(0.5), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Calendar
    
    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity Calendar")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            CalendarGridView(
                selectedMonth: $selectedMonth,
                dataManager: dataManager
            )
        }
    }
    
    // MARK: - Recent Sessions
    
    private var recentSessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Sessions")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            if dataManager.sessions.isEmpty {
                emptyStateCard
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(dataManager.sessions.prefix(10))) { session in
                        SessionRow(session: session)
                    }
                }
            }
        }
    }
    
    private var emptyStateCard: some View {
        VStack(spacing: 12) {
            IconView(name: "history", size: 48, color: AppTheme.textMuted)
            Text("No training sessions yet")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppTheme.textMuted)
            Text("Start training to see your history")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textMuted.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
    
    // MARK: - All-time Stats
    
    private var allTimeStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All-Time Statistics")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            let columns = [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ]
            
            LazyVGrid(columns: columns, spacing: 12) {
                StatCard(
                    title: "Total Sessions",
                    value: "\(dataManager.totalSessions)",
                    iconName: "target",
                    color: AppTheme.primary
                )
                
                StatCard(
                    title: "Total Rounds",
                    value: "\(dataManager.totalRounds)",
                    iconName: "hook",
                    color: AppTheme.accent
                )
                
                StatCard(
                    title: "Total Caught",
                    value: "\(dataManager.totalCaught)",
                    iconName: "fish_medium",
                    color: AppTheme.success
                )
                
                StatCard(
                    title: "Success Rate",
                    value: String(format: "%.0f%%", dataManager.overallSuccessRate),
                    iconName: "chart",
                    color: AppTheme.warning
                )
                
                StatCard(
                    title: "Best Time",
                    value: dataManager.bestReactionTimeFormatted,
                    iconName: "lightning",
                    color: Color(hex: "FFD700")
                )
                
                StatCard(
                    title: "Average Time",
                    value: dataManager.averageReactionTimeFormatted,
                    iconName: "timer",
                    color: AppTheme.primary
                )
            }
        }
    }
}

// MARK: - Calendar Grid

struct CalendarGridView: View {
    @Binding var selectedMonth: Date
    let dataManager: DataManager
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let weekdays = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        VStack(spacing: 12) {
            // Month navigation
            HStack {
                Button(action: previousMonth) {
                    IconView(name: "arrow_left", size: 20, color: AppTheme.textSecondary)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Button(action: nextMonth) {
                    IconView(name: "arrow_left", size: 20, color: AppTheme.textSecondary)
                        .rotationEffect(.degrees(180))
                }
            }
            .padding(.horizontal, 8)
            
            // Weekday headers
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppTheme.textMuted)
                        .frame(height: 30)
                }
            }
            
            // Days grid
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(daysInMonth(), id: \.self) { date in
                    if let date = date {
                        CalendarDayView(date: date, dataManager: dataManager)
                    } else {
                        Color.clear
                            .frame(height: 36)
                    }
                }
            }
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: selectedMonth)
    }
    
    private func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) {
            selectedMonth = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) {
            selectedMonth = newDate
        }
    }
    
    private func daysInMonth() -> [Date?] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: selectedMonth)!
        
        var components = calendar.dateComponents([.year, .month], from: selectedMonth)
        components.day = 1
        let firstDay = calendar.date(from: components)!
        
        // Get weekday of first day (1 = Sunday, so we need to adjust for Monday start)
        var firstWeekday = calendar.component(.weekday, from: firstDay) - 2
        if firstWeekday < 0 { firstWeekday += 7 }
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday)
        
        for day in range {
            components.day = day
            if let date = calendar.date(from: components) {
                days.append(date)
            }
        }
        
        return days
    }
}

struct CalendarDayView: View {
    let date: Date
    let dataManager: DataManager
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var performance: Double? {
        dataManager.performanceForDate(date)
    }
    
    private var dayColor: Color {
        guard let perf = performance else {
            return Color.clear
        }
        if perf >= 80 {
            return AppTheme.success
        } else if perf >= 50 {
            return AppTheme.warning
        } else {
            return AppTheme.danger
        }
    }
    
    var body: some View {
        ZStack {
            if performance != nil {
                Circle()
                    .fill(dayColor.opacity(0.3))
            }
            
            if isToday {
                Circle()
                    .strokeBorder(AppTheme.primary, lineWidth: 2)
            }
            
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 14, weight: isToday ? .bold : .regular))
                .foregroundColor(
                    isToday ? AppTheme.primary :
                    performance != nil ? AppTheme.textPrimary : AppTheme.textMuted
                )
        }
        .frame(height: 36)
    }
}

// MARK: - Session Row

struct SessionRow: View {
    let session: GameSession
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.date.formattedDateTime())
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(session.difficulty.displayName)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textMuted)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    IconView(name: "timer", size: 14, color: AppTheme.primary)
                    Text(session.averageReactionTimeFormatted)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                Text("\(session.caughtCount)/\(session.totalRounds) (\(session.successRateFormatted))")
                    .font(.system(size: 12))
                    .foregroundColor(
                        session.successRate >= 80 ? AppTheme.success :
                        session.successRate >= 50 ? AppTheme.warning : AppTheme.danger
                    )
            }
        }
        .padding(12)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusSmall)
    }
}
