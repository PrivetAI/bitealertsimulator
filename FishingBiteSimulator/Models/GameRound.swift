import Foundation

enum ReactionRating: String, Codable {
    case lightning = "Lightning!"
    case excellent = "Excellent!"
    case good = "Good!"
    case normal = "Normal"
    case slow = "Too Slow"
    case missed = "Missed!"
    
    var description: String { rawValue }
    
    static func fromReactionTime(_ time: Double?) -> ReactionRating {
        guard let time = time else { return .missed }
        
        switch time {
        case ..<0.2:
            return .lightning
        case 0.2..<0.3:
            return .excellent
        case 0.3..<0.5:
            return .good
        case 0.5..<0.8:
            return .normal
        default:
            return .slow
        }
    }
}

struct GameRound: Identifiable, Codable {
    let id: UUID
    let roundNumber: Int
    let waitDuration: Double
    let reactionTime: Double?
    let caught: Bool
    let timestamp: Date
    
    init(
        id: UUID = UUID(),
        roundNumber: Int,
        waitDuration: Double,
        reactionTime: Double?,
        caught: Bool,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.roundNumber = roundNumber
        self.waitDuration = waitDuration
        self.reactionTime = reactionTime
        self.caught = caught
        self.timestamp = timestamp
    }
    
    var rating: ReactionRating {
        ReactionRating.fromReactionTime(caught ? reactionTime : nil)
    }
    
    var reactionTimeFormatted: String {
        guard let time = reactionTime else { return "-" }
        return String(format: "%.3fs", time)
    }
}
