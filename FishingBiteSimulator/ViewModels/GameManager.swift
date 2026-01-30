import Foundation
import SwiftUI
import Combine

enum GameState: Equatable {
    case idle
    case countdown(Int)
    case waiting
    case bite
    case caught(Double)
    case missed
    case finished
}

class GameManager: ObservableObject {
    @Published var gameState: GameState = .idle
    @Published var currentRound: Int = 0
    @Published var rounds: [GameRound] = []
    @Published var currentSession: GameSession?
    
    private var difficulty: Difficulty = .medium
    private var biteTimer: Timer?
    private var missTimer: Timer?
    private var countdownTimer: Timer?
    private var biteStartTime: Date?
    private var waitStartTime: Date?
    private var currentWaitDuration: Double = 0
    
    private let hapticManager = HapticManager()
    private let soundManager = SoundManager()
    
    var settings: AppSettings = AppSettings()
    
    // MARK: - Game Control
    
    func startGame(difficulty: Difficulty, settings: AppSettings) {
        self.difficulty = difficulty
        self.settings = settings
        self.currentRound = 0
        self.rounds = []
        
        let session = GameSession(difficulty: difficulty)
        self.currentSession = session
        
        if settings.showCountdown {
            startCountdown()
        } else {
            startNextRound()
        }
    }
    
    private func startCountdown() {
        var count = 3
        gameState = .countdown(count)
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            count -= 1
            if count > 0 {
                self?.gameState = .countdown(count)
            } else {
                timer.invalidate()
                self?.startNextRound()
            }
        }
    }
    
    func startNextRound() {
        currentRound += 1
        gameState = .waiting
        waitStartTime = Date()
        
        // Random wait time within difficulty range
        let range = difficulty.waitTimeRange
        let waitTime = Double.random(in: range)
        currentWaitDuration = waitTime
        
        biteTimer = Timer.scheduledTimer(withTimeInterval: waitTime, repeats: false) { [weak self] _ in
            self?.triggerBite()
        }
    }
    
    private func triggerBite() {
        biteStartTime = Date()
        gameState = .bite
        
        // Haptic feedback
        if settings.vibrationEnabled {
            hapticManager.bite(intensity: settings.vibrationIntensity)
        }
        
        // Sound
        if settings.soundEnabled {
            soundManager.playBite()
        }
        
        // Start miss timer
        let reactionLimit = difficulty.reactionTimeLimit
        missTimer = Timer.scheduledTimer(withTimeInterval: reactionLimit, repeats: false) { [weak self] _ in
            self?.handleMiss()
        }
    }
    
    func catchFish() {
        guard gameState == .bite, let biteTime = biteStartTime else { return }
        
        missTimer?.invalidate()
        missTimer = nil
        
        let reactionTime = Date().timeIntervalSince(biteTime)
        
        // Record round
        let round = GameRound(
            roundNumber: currentRound,
            waitDuration: currentWaitDuration,
            reactionTime: reactionTime,
            caught: true
        )
        rounds.append(round)
        
        gameState = .caught(reactionTime)
        
        // Haptic feedback
        if settings.vibrationEnabled {
            hapticManager.success()
        }
        
        // Sound
        if settings.soundEnabled {
            soundManager.playSuccess()
        }
        
        // Continue or finish
        if currentRound >= difficulty.roundCount {
            finishGame()
        } else if settings.autoNextRound {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.startNextRound()
            }
        }
    }
    
    private func handleMiss() {
        let round = GameRound(
            roundNumber: currentRound,
            waitDuration: currentWaitDuration,
            reactionTime: nil,
            caught: false
        )
        rounds.append(round)
        
        gameState = .missed
        
        // Sound
        if settings.soundEnabled {
            soundManager.playMiss()
        }
        
        // Continue or finish
        if currentRound >= difficulty.roundCount {
            finishGame()
        } else if settings.autoNextRound {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.startNextRound()
            }
        }
    }
    
    func continueAfterResult() {
        if currentRound >= difficulty.roundCount {
            finishGame()
        } else {
            startNextRound()
        }
    }
    
    private func finishGame() {
        biteTimer?.invalidate()
        missTimer?.invalidate()
        countdownTimer?.invalidate()
        
        if var session = currentSession {
            session.rounds = rounds
            session.endTime = Date()
            currentSession = session
        }
        
        gameState = .finished
    }
    
    func endGame() {
        biteTimer?.invalidate()
        missTimer?.invalidate()
        countdownTimer?.invalidate()
        
        gameState = .idle
        currentRound = 0
        rounds = []
        currentSession = nil
    }
    
    // MARK: - Computed Properties
    
    var totalRounds: Int {
        difficulty.roundCount
    }
    
    var caughtCount: Int {
        rounds.filter { $0.caught }.count
    }
    
    var progressPercentage: Double {
        guard totalRounds > 0 else { return 0 }
        return Double(currentRound) / Double(totalRounds)
    }
}
