import Foundation

enum Difficulty: String, Codable, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case medium = "Medium"
    case expert = "Expert"
    case pro = "Pro"
    
    var id: String { rawValue }
    
    var displayName: String { rawValue }
    
    var description: String {
        switch self {
        case .beginner:
            return "5-15s wait, 3s reaction, 5 rounds"
        case .medium:
            return "3-10s wait, 2s reaction, 10 rounds"
        case .expert:
            return "1-5s wait, 1.5s reaction, 15 rounds"
        case .pro:
            return "0.5-3s wait, 1s reaction, 20 rounds"
        }
    }
    
    var waitTimeRange: ClosedRange<Double> {
        switch self {
        case .beginner: return 5.0...15.0
        case .medium: return 3.0...10.0
        case .expert: return 1.0...5.0
        case .pro: return 0.5...3.0
        }
    }
    
    var reactionTimeLimit: Double {
        switch self {
        case .beginner: return 3.0
        case .medium: return 2.0
        case .expert: return 1.5
        case .pro: return 1.0
        }
    }
    
    var roundCount: Int {
        switch self {
        case .beginner: return 5
        case .medium: return 10
        case .expert: return 15
        case .pro: return 20
        }
    }
    
    var iconName: String {
        switch self {
        case .beginner: return "fish_small"
        case .medium: return "fish_medium"
        case .expert: return "fish_large"
        case .pro: return "fish_trophy"
        }
    }
}
