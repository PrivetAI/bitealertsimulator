import Foundation

struct GameSession: Identifiable, Codable {
    let id: UUID
    let date: Date
    let difficulty: Difficulty
    var rounds: [GameRound]
    let startTime: Date
    var endTime: Date?
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        difficulty: Difficulty,
        rounds: [GameRound] = [],
        startTime: Date = Date(),
        endTime: Date? = nil
    ) {
        self.id = id
        self.date = date
        self.difficulty = difficulty
        self.rounds = rounds
        self.startTime = startTime
        self.endTime = endTime
    }
    
    // MARK: - Computed Properties
    
    var duration: TimeInterval {
        guard let endTime = endTime else {
            return Date().timeIntervalSince(startTime)
        }
        return endTime.timeIntervalSince(startTime)
    }
    
    var durationFormatted: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var totalRounds: Int {
        rounds.count
    }
    
    var caughtCount: Int {
        rounds.filter { $0.caught }.count
    }
    
    var missedCount: Int {
        rounds.filter { !$0.caught }.count
    }
    
    var successRate: Double {
        guard !rounds.isEmpty else { return 0 }
        return Double(caughtCount) / Double(rounds.count) * 100
    }
    
    var successRateFormatted: String {
        String(format: "%.0f%%", successRate)
    }
    
    var averageReactionTime: Double? {
        let caughtRounds = rounds.filter { $0.caught && $0.reactionTime != nil }
        guard !caughtRounds.isEmpty else { return nil }
        let total = caughtRounds.compactMap { $0.reactionTime }.reduce(0, +)
        return total / Double(caughtRounds.count)
    }
    
    var averageReactionTimeFormatted: String {
        guard let avg = averageReactionTime else { return "-" }
        return String(format: "%.3fs", avg)
    }
    
    var bestReactionTime: Double? {
        rounds.filter { $0.caught }.compactMap { $0.reactionTime }.min()
    }
    
    var bestReactionTimeFormatted: String {
        guard let best = bestReactionTime else { return "-" }
        return String(format: "%.3fs", best)
    }
    
    var worstReactionTime: Double? {
        rounds.filter { $0.caught }.compactMap { $0.reactionTime }.max()
    }
    
    var worstReactionTimeFormatted: String {
        guard let worst = worstReactionTime else { return "-" }
        return String(format: "%.3fs", worst)
    }
    
    var bestRoundIndex: Int? {
        guard let best = bestReactionTime else { return nil }
        return rounds.firstIndex { $0.reactionTime == best }
    }
}
