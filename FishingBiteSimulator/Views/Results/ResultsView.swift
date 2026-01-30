import SwiftUI

struct ResultsView: View {
    let session: GameSession
    let onDismiss: () -> Void
    let onRetry: () -> Void
    
    @EnvironmentObject var dataManager: DataManager
    @State private var showContent = false
    
    private var isNewRecord: Bool {
        guard let best = session.bestReactionTime,
              let allTimeBest = dataManager.bestReactionTime else {
            return false
        }
        return best <= allTimeBest
    }
    
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Main stats
                    mainStatsSection
                    
                    // Speed stats
                    speedStatsSection
                    
                    // Rounds list
                    roundsListSection
                    
                    // Buttons
                    actionButtons
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 16)
                .padding(.top, 40)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showContent = true
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            if isNewRecord {
                HStack(spacing: 8) {
                    IconView(name: "star", size: 24, color: Color(hex: "FFD700"))
                    Text("New Record!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "FFD700"))
                    IconView(name: "star", size: 24, color: Color(hex: "FFD700"))
                }
            }
            
            Text("Training Complete")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Text(session.difficulty.displayName)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(AppTheme.cardBackground)
                .cornerRadius(16)
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 20)
    }
    
    // MARK: - Main Stats
    
    private var mainStatsSection: some View {
        VStack(spacing: 16) {
            // Success rate ring
            ZStack {
                Circle()
                    .stroke(AppTheme.cardBackground, lineWidth: 12)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: showContent ? session.successRate / 100 : 0)
                    .stroke(
                        session.successRate >= 80 ? AppTheme.success :
                        session.successRate >= 50 ? AppTheme.warning : AppTheme.danger,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 1), value: showContent)
                
                VStack(spacing: 2) {
                    Text(session.successRateFormatted)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    Text("Success")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textMuted)
                }
            }
            
            // Stats row
            HStack(spacing: 0) {
                StatItem(
                    value: "\(session.caughtCount)",
                    label: "Caught",
                    iconName: "check",
                    color: AppTheme.success
                )
                
                Divider()
                    .background(AppTheme.textMuted)
                    .frame(height: 40)
                
                StatItem(
                    value: "\(session.missedCount)",
                    label: "Missed",
                    iconName: "cross",
                    color: AppTheme.danger
                )
                
                Divider()
                    .background(AppTheme.textMuted)
                    .frame(height: 40)
                
                StatItem(
                    value: session.durationFormatted,
                    label: "Duration",
                    iconName: "timer",
                    color: AppTheme.primary
                )
            }
            .padding(.vertical, 16)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 20)
        .animation(.easeOut(duration: 0.5).delay(0.1), value: showContent)
    }
    
    // MARK: - Speed Stats
    
    private var speedStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reaction Times")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            HStack(spacing: 12) {
                SpeedStatCard(
                    title: "Average",
                    value: session.averageReactionTimeFormatted,
                    iconName: "chart",
                    color: AppTheme.primary
                )
                
                SpeedStatCard(
                    title: "Best",
                    value: session.bestReactionTimeFormatted,
                    iconName: "lightning",
                    color: AppTheme.success
                )
                
                SpeedStatCard(
                    title: "Worst",
                    value: session.worstReactionTimeFormatted,
                    iconName: "timer",
                    color: AppTheme.warning
                )
            }
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 20)
        .animation(.easeOut(duration: 0.5).delay(0.2), value: showContent)
    }
    
    // MARK: - Rounds List
    
    private var roundsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Round Details")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            VStack(spacing: 0) {
                ForEach(Array(session.rounds.enumerated()), id: \.element.id) { index, round in
                    RoundResultRow(
                        round: round,
                        isBest: index == session.bestRoundIndex
                    )
                    
                    if index < session.rounds.count - 1 {
                        Divider()
                            .background(AppTheme.textMuted.opacity(0.3))
                    }
                }
            }
            .padding(12)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 20)
        .animation(.easeOut(duration: 0.5).delay(0.3), value: showContent)
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            CustomButton(
                title: "Try Again",
                iconName: "refresh",
                style: .primary
            ) {
                onRetry()
            }
            
            CustomButton(
                title: "Back to Home",
                iconName: "home",
                style: .ghost
            ) {
                onDismiss()
            }
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 20)
        .animation(.easeOut(duration: 0.5).delay(0.4), value: showContent)
    }
}

// MARK: - Supporting Views

struct StatItem: View {
    let value: String
    let label: String
    let iconName: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                IconView(name: iconName, size: 16, color: color)
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
            }
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.textMuted)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SpeedStatCard: View {
    let title: String
    let value: String
    let iconName: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            IconView(name: iconName, size: 24, color: color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
}

struct RoundResultRow: View {
    let round: GameRound
    let isBest: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Text("Round \(round.roundNumber)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .frame(width: 70, alignment: .leading)
            
            if round.caught {
                IconView(name: "check", size: 16, color: AppTheme.success)
            } else {
                IconView(name: "cross", size: 16, color: AppTheme.danger)
            }
            
            Text(round.reactionTimeFormatted)
                .font(.system(size: 16, weight: round.caught ? .semibold : .regular))
                .foregroundColor(round.caught ? AppTheme.textPrimary : AppTheme.textMuted)
            
            Spacer()
            
            if isBest && round.caught {
                HStack(spacing: 4) {
                    IconView(name: "lightning", size: 14, color: Color(hex: "FFD700"))
                    Text("Best")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "FFD700"))
                }
            } else if round.caught {
                Text(round.rating.description)
                    .font(.system(size: 12))
                    .foregroundColor(ratingColor(for: round.rating))
            }
        }
        .padding(.vertical, 8)
    }
    
    private func ratingColor(for rating: ReactionRating) -> Color {
        switch rating {
        case .lightning, .excellent:
            return AppTheme.success
        case .good, .normal:
            return AppTheme.warning
        case .slow, .missed:
            return AppTheme.danger
        }
    }
}
