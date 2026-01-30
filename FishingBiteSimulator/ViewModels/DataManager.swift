import Foundation
import SwiftUI

struct AppSettings: Codable {
    var vibrationEnabled: Bool = true
    var vibrationIntensity: VibrationIntensity = .medium
    var soundEnabled: Bool = true
    var showCountdown: Bool = true
    var autoNextRound: Bool = true
    var selectedDifficulty: Difficulty = .medium
    
    enum VibrationIntensity: String, Codable, CaseIterable {
        case light = "Light"
        case medium = "Medium"
        case strong = "Strong"
    }
}

class DataManager: ObservableObject {
    @Published var sessions: [GameSession] = []
    @Published var achievements: [Achievement] = []
    @Published var settings: AppSettings = AppSettings()
    @Published var currentStreak: Int = 0
    
    private let sessionsKey = "bite_sessions"
    private let achievementsKey = "bite_achievements"
    private let settingsKey = "bite_settings"
    private let lastTrainingDateKey = "bite_last_training_date"
    
    init() {
        loadData()
    }
    
    // MARK: - Persistence
    
    private func loadData() {
        // Load sessions
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([GameSession].self, from: data) {
            sessions = decoded
        }
        
        // Load achievements
        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        } else {
            achievements = Achievement.allAchievements
        }
        
        // Load settings
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decoded
        }
        
        calculateStreak()
    }
    
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }
    
    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: achievementsKey)
        }
    }
    
    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
    
    // MARK: - Session Operations
    
    func addSession(_ session: GameSession) {
        sessions.insert(session, at: 0)
        saveSessions()
        updateAchievements(with: session)
        calculateStreak()
    }
    
    // MARK: - Statistics
    
    var totalSessions: Int { sessions.count }
    
    var totalRounds: Int {
        sessions.reduce(0) { $0 + $1.rounds.count }
    }
    
    var totalCaught: Int {
        sessions.reduce(0) { $0 + $1.caughtCount }
    }
    
    var totalMissed: Int {
        sessions.reduce(0) { $0 + $1.missedCount }
    }
    
    var overallSuccessRate: Double {
        let total = totalCaught + totalMissed
        guard total > 0 else { return 0 }
        return Double(totalCaught) / Double(total) * 100
    }
    
    var bestReactionTime: Double? {
        sessions.compactMap { $0.bestReactionTime }.min()
    }
    
    var bestReactionTimeFormatted: String {
        guard let best = bestReactionTime else { return "-" }
        return String(format: "%.3fs", best)
    }
    
    var averageReactionTime: Double? {
        let allTimes = sessions.flatMap { session in
            session.rounds.filter { $0.caught }.compactMap { $0.reactionTime }
        }
        guard !allTimes.isEmpty else { return nil }
        return allTimes.reduce(0, +) / Double(allTimes.count)
    }
    
    var averageReactionTimeFormatted: String {
        guard let avg = averageReactionTime else { return "-" }
        return String(format: "%.3fs", avg)
    }
    
    var todaySessions: [GameSession] {
        let calendar = Calendar.current
        return sessions.filter { calendar.isDateInToday($0.date) }
    }
    
    var todayRounds: Int {
        todaySessions.reduce(0) { $0 + $1.rounds.count }
    }
    
    var todayCaught: Int {
        todaySessions.reduce(0) { $0 + $1.caughtCount }
    }
    
    var todaySuccessRate: Double {
        let caught = todayCaught
        let total = todayRounds
        guard total > 0 else { return 0 }
        return Double(caught) / Double(total) * 100
    }
    
    // MARK: - Streak
    
    private func calculateStreak() {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()
        
        // Check if trained today
        let trainedToday = sessions.contains { calendar.isDateInToday($0.date) }
        if !trainedToday {
            // Check yesterday
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                currentStreak = 0
                return
            }
            currentDate = yesterday
        }
        
        // Count consecutive days
        while true {
            let trainedOnDay = sessions.contains { calendar.isDate($0.date, inSameDayAs: currentDate) }
            if trainedOnDay {
                streak += 1
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
                currentDate = previousDay
            } else {
                break
            }
        }
        
        currentStreak = streak
    }
    
    // MARK: - Personal Records
    
    var topRecords: [(rank: Int, time: Double, date: Date)] {
        let allRounds = sessions.flatMap { session in
            session.rounds.filter { $0.caught && $0.reactionTime != nil }.map { ($0.reactionTime!, session.date) }
        }
        let sorted = allRounds.sorted { $0.0 < $1.0 }
        return Array(sorted.prefix(10).enumerated().map { (index, element) in
            (rank: index + 1, time: element.0, date: element.1)
        })
    }
    
    // MARK: - Achievements
    
    private func updateAchievements(with session: GameSession) {
        // First catch
        if let index = achievements.firstIndex(where: { $0.id == "first_catch" }) {
            if session.caughtCount > 0 && !achievements[index].isUnlocked {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
                achievements[index].progress = 1
            }
        }
        
        // Quick hands - catches under 0.25s
        if let index = achievements.firstIndex(where: { $0.id == "quick_hands" }) {
            let quickCatches = session.rounds.filter { $0.caught && ($0.reactionTime ?? 1) < 0.25 }.count
            achievements[index].progress += quickCatches
            if achievements[index].progress >= achievements[index].target && !achievements[index].isUnlocked {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
            }
        }
        
        // Century - 100 rounds
        if let index = achievements.firstIndex(where: { $0.id == "century" }) {
            achievements[index].progress = totalRounds
            if achievements[index].progress >= achievements[index].target && !achievements[index].isUnlocked {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
            }
        }
        
        // Marathon - 500 rounds
        if let index = achievements.firstIndex(where: { $0.id == "marathon" }) {
            achievements[index].progress = totalRounds
            if achievements[index].progress >= achievements[index].target && !achievements[index].isUnlocked {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
            }
        }
        
        // Lightning reflexes - under 0.15s
        if let index = achievements.firstIndex(where: { $0.id == "lightning_god" }) {
            let hasLightning = session.rounds.contains { $0.caught && ($0.reactionTime ?? 1) < 0.15 }
            if hasLightning && !achievements[index].isUnlocked {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
                achievements[index].progress = 1
            }
        }
        
        // Perfectionist - 100% success
        if let index = achievements.firstIndex(where: { $0.id == "perfectionist" }) {
            if session.successRate >= 100 && session.rounds.count >= 5 && !achievements[index].isUnlocked {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
                achievements[index].progress = 1
            }
        }
        
        // Dedicated - 7 day streak
        if let index = achievements.firstIndex(where: { $0.id == "dedicated" }) {
            achievements[index].progress = currentStreak
            if currentStreak >= 7 && !achievements[index].isUnlocked {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
            }
        }
        
        saveAchievements()
    }
    
    // MARK: - Calendar Data
    
    func sessionsForDate(_ date: Date) -> [GameSession] {
        let calendar = Calendar.current
        return sessions.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func performanceForDate(_ date: Date) -> Double? {
        let daySessions = sessionsForDate(date)
        guard !daySessions.isEmpty else { return nil }
        let totalCaught = daySessions.reduce(0) { $0 + $1.caughtCount }
        let totalRounds = daySessions.reduce(0) { $0 + $1.rounds.count }
        guard totalRounds > 0 else { return nil }
        return Double(totalCaught) / Double(totalRounds) * 100
    }
}
