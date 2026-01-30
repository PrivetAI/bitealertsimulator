import UIKit

class HapticManager {
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    init() {
        lightGenerator.prepare()
        mediumGenerator.prepare()
        heavyGenerator.prepare()
        notificationGenerator.prepare()
    }
    
    func bite(intensity: AppSettings.VibrationIntensity) {
        switch intensity {
        case .light:
            lightGenerator.impactOccurred()
        case .medium:
            mediumGenerator.impactOccurred()
        case .strong:
            heavyGenerator.impactOccurred()
        }
        
        // Double tap for bite emphasis
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            switch intensity {
            case .light:
                self?.lightGenerator.impactOccurred()
            case .medium:
                self?.mediumGenerator.impactOccurred()
            case .strong:
                self?.heavyGenerator.impactOccurred()
            }
        }
    }
    
    func success() {
        notificationGenerator.notificationOccurred(.success)
    }
    
    func warning() {
        notificationGenerator.notificationOccurred(.warning)
    }
    
    func error() {
        notificationGenerator.notificationOccurred(.error)
    }
    
    func light() {
        lightGenerator.impactOccurred()
    }
    
    func medium() {
        mediumGenerator.impactOccurred()
    }
    
    func heavy() {
        heavyGenerator.impactOccurred()
    }
}
