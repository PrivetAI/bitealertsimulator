import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    private var unlockedCount: Int {
        dataManager.achievements.filter { $0.isUnlocked }.count
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Progress
                progressSection
                
                // Achievements grid
                achievementsGrid
            }
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 16)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            IconView(name: "trophy", size: 48, color: Color(hex: "FFD700"))
            
            Text("Achievements")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Text("Unlock rewards as you train")
                .font(.system(size: 16))
                .foregroundColor(AppTheme.textSecondary)
        }
    }
    
    // MARK: - Progress
    
    private var progressSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Progress")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                
                Spacer()
                
                Text("\(unlockedCount)/\(dataManager.achievements.count)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppTheme.cardBackground)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppTheme.primaryGradient)
                        .frame(width: geo.size.width * CGFloat(unlockedCount) / CGFloat(max(1, dataManager.achievements.count)))
                }
            }
            .frame(height: 12)
        }
        .padding(16)
        .background(AppTheme.cardBackgroundLight)
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
    
    // MARK: - Grid
    
    private var achievementsGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
        
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(dataManager.achievements) { achievement in
                AchievementCard(achievement: achievement)
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    private var iconColor: Color {
        achievement.isUnlocked ? Color(hex: "FFD700") : AppTheme.textMuted
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ?
                          Color(hex: "FFD700").opacity(0.2) :
                          AppTheme.cardBackgroundLight)
                    .frame(width: 60, height: 60)
                
                achievementIcon
            }
            
            // Title
            Text(achievement.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(achievement.isUnlocked ? AppTheme.textPrimary : AppTheme.textMuted)
                .multilineTextAlignment(.center)
            
            // Description
            Text(achievement.description)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.textMuted)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Progress or date
            if achievement.isUnlocked {
                if let date = achievement.unlockedDate {
                    Text("Unlocked \(date.daysAgo())")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.success)
                }
            } else {
                // Progress bar
                VStack(spacing: 4) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppTheme.cardBackgroundLight)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppTheme.primary)
                                .frame(width: geo.size.width * achievement.progressPercentage / 100)
                        }
                    }
                    .frame(height: 6)
                    
                    Text("\(achievement.progress)/\(achievement.target)")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textMuted)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
        .opacity(achievement.isUnlocked ? 1 : 0.7)
    }
    
    @ViewBuilder
    private var achievementIcon: some View {
        switch achievement.iconName {
        case "achievement_fish":
            IconView(name: "fish_medium", size: 28, color: iconColor)
        case "achievement_lightning":
            IconView(name: "lightning", size: 28, color: iconColor)
        case "achievement_fire":
            IconView(name: "flame", size: 28, color: iconColor)
        case "achievement_calendar":
            IconView(name: "calendar", size: 28, color: iconColor)
        case "achievement_hundred":
            Text("100")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(iconColor)
        case "achievement_bolt":
            IconView(name: "lightning", size: 28, color: iconColor)
        case "achievement_star":
            IconView(name: "star", size: 28, color: iconColor)
        case "achievement_medal":
            IconView(name: "medal", size: 28, color: iconColor)
        default:
            IconView(name: "trophy", size: 28, color: iconColor)
        }
    }
}
