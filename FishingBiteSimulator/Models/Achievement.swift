import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    var isUnlocked: Bool
    var unlockedDate: Date?
    var progress: Int
    var target: Int
    
    init(
        id: String,
        title: String,
        description: String,
        iconName: String,
        isUnlocked: Bool = false,
        unlockedDate: Date? = nil,
        progress: Int = 0,
        target: Int = 1
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.isUnlocked = isUnlocked
        self.unlockedDate = unlockedDate
        self.progress = progress
        self.target = target
    }
    
    var progressPercentage: Double {
        guard target > 0 else { return 0 }
        return min(Double(progress) / Double(target) * 100, 100)
    }
    
    static let allAchievements: [Achievement] = [
        Achievement(
            id: "first_catch",
            title: "First Catch",
            description: "Successfully catch your first fish",
            iconName: "achievement_fish",
            target: 1
        ),
        Achievement(
            id: "quick_hands",
            title: "Quick Hands",
            description: "Catch 10 fish faster than 0.25 seconds",
            iconName: "achievement_lightning",
            target: 10
        ),
        Achievement(
            id: "streak_master",
            title: "Streak Master",
            description: "Catch 50 fish in a row without missing",
            iconName: "achievement_fire",
            target: 50
        ),
        Achievement(
            id: "dedicated",
            title: "Dedicated",
            description: "Train for 7 days in a row",
            iconName: "achievement_calendar",
            target: 7
        ),
        Achievement(
            id: "century",
            title: "Century",
            description: "Complete 100 rounds total",
            iconName: "achievement_hundred",
            target: 100
        ),
        Achievement(
            id: "lightning_god",
            title: "Lightning Reflexes",
            description: "Catch a fish in under 0.15 seconds",
            iconName: "achievement_bolt",
            target: 1
        ),
        Achievement(
            id: "perfectionist",
            title: "Perfectionist",
            description: "Complete a session with 100% success rate",
            iconName: "achievement_star",
            target: 1
        ),
        Achievement(
            id: "marathon",
            title: "Marathon Fisher",
            description: "Complete 500 rounds total",
            iconName: "achievement_medal",
            target: 500
        )
    ]
}
