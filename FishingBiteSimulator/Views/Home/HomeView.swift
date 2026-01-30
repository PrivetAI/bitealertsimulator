import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var showGame: Bool
    @State private var selectedDifficulty: Difficulty = .medium
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                headerSection
                
                // Personal Best
                if dataManager.bestReactionTime != nil {
                    personalBestCard
                }
                
                // Today's Stats
                todayStatsSection
                
                // Difficulty Selector
                difficultySection
                
                // Start Button
                startButton
                
                // Records
                if !dataManager.topRecords.isEmpty {
                    recordsSection
                }
            }
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 16)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            IconView(name: "rod", size: 48, color: AppTheme.primary)
            
            Text("Bite Alert")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Text("Train your reaction speed")
                .font(.system(size: 16))
                .foregroundColor(AppTheme.textSecondary)
            
            if dataManager.currentStreak > 0 {
                HStack(spacing: 6) {
                    IconView(name: "flame", size: 16, color: AppTheme.warning)
                    Text("\(dataManager.currentStreak) day streak")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.warning)
                }
                .padding(.top, 4)
            }
        }
        .padding(.bottom, 10)
    }
    
    // MARK: - Personal Best
    
    private var personalBestCard: some View {
        VStack(spacing: 12) {
            HStack {
                IconView(name: "lightning", size: 24, color: Color(hex: "FFD700"))
                Text("Personal Best")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }
            
            Text(dataManager.bestReactionTimeFormatted)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(AppTheme.primary)
            
            if let record = dataManager.topRecords.first {
                Text("Set on \(record.date.formatted())")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textMuted)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge)
                        .strokeBorder(
                            LinearGradient(
                                colors: [AppTheme.primary.opacity(0.5), AppTheme.primary.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    // MARK: - Today's Stats
    
    private var todayStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            let columns = [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ]
            
            LazyVGrid(columns: columns, spacing: 12) {
                CompactStatCard(
                    title: "Sessions",
                    value: "\(dataManager.todaySessions.count)",
                    iconName: "target",
                    color: AppTheme.primary
                )
                
                CompactStatCard(
                    title: "Rounds",
                    value: "\(dataManager.todayRounds)",
                    iconName: "hook",
                    color: AppTheme.accent
                )
                
                CompactStatCard(
                    title: "Caught",
                    value: "\(dataManager.todayCaught)",
                    iconName: "fish_medium",
                    color: AppTheme.success
                )
                
                CompactStatCard(
                    title: "Success Rate",
                    value: String(format: "%.0f%%", dataManager.todaySuccessRate),
                    iconName: "chart",
                    color: AppTheme.warning
                )
            }
        }
    }
    
    // MARK: - Difficulty
    
    private var difficultySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Difficulty")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            VStack(spacing: 8) {
                ForEach(Difficulty.allCases) { difficulty in
                    DifficultyButton(
                        difficulty: difficulty,
                        isSelected: selectedDifficulty == difficulty
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedDifficulty = difficulty
                            dataManager.settings.selectedDifficulty = difficulty
                            dataManager.saveSettings()
                        }
                    }
                }
            }
        }
        .onAppear {
            selectedDifficulty = dataManager.settings.selectedDifficulty
        }
    }
    
    // MARK: - Start Button
    
    private var startButton: some View {
        CustomButton(
            title: "Start Training",
            iconName: "play",
            style: .primary
        ) {
            showGame = true
        }
        .padding(.top, 8)
    }
    
    // MARK: - Records
    
    private var recordsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Records")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            VStack(spacing: 8) {
                ForEach(Array(dataManager.topRecords.prefix(5)), id: \.rank) { record in
                    RecordRow(rank: record.rank, time: record.time, date: record.date)
                }
            }
            .padding(16)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
}

struct DifficultyButton: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    private var difficultyColor: Color {
        switch difficulty {
        case .beginner: return AppTheme.success
        case .medium: return AppTheme.warning
        case .expert: return AppTheme.danger
        case .pro: return Color(hex: "9B59B6")
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                IconView(name: difficulty.iconName, size: 24, color: difficultyColor)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(difficulty.displayName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text(difficulty.description)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textMuted)
                }
                
                Spacer()
                
                if isSelected {
                    IconView(name: "check", size: 20, color: AppTheme.primary)
                }
            }
            .padding(14)
            .background(isSelected ? AppTheme.cardBackgroundLight : AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                    .strokeBorder(isSelected ? AppTheme.primary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct RecordRow: View {
    let rank: Int
    let time: Double
    let date: Date
    
    private var rankColor: Color {
        switch rank {
        case 1: return Color(hex: "FFD700")
        case 2: return Color(hex: "C0C0C0")
        case 3: return Color(hex: "CD7F32")
        default: return AppTheme.textMuted
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text("#\(rank)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(rankColor)
                .frame(width: 30)
            
            Text(String(format: "%.3fs", time))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
            
            Text(date.formatted())
                .font(.system(size: 12))
                .foregroundColor(AppTheme.textMuted)
        }
    }
}
