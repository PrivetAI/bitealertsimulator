import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var sounds: [String: AVAudioPlayer] = [:]
    
    init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func preloadSound(named name: String, withExtension ext: String = "wav") {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            sounds[name] = player
        } catch {
            print("Failed to preload sound \(name): \(error)")
        }
    }
    
    private func playSound(named name: String) {
        if let player = sounds[name] {
            player.currentTime = 0
            player.play()
        } else {
            // Try to load and play
            guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
                // Fallback to system sound simulation
                playSystemSound()
                return
            }
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.play()
                sounds[name] = player
            } catch {
                playSystemSound()
            }
        }
    }
    
    private func playSystemSound() {
        // Fallback haptic-only feedback when no sound files
        AudioServicesPlaySystemSound(1519) // Peek sound
    }
    
    func playBite() {
        // Use system sound as fallback
        AudioServicesPlaySystemSound(1520) // Pop sound
    }
    
    func playSuccess() {
        AudioServicesPlaySystemSound(1519) // Peek sound
    }
    
    func playMiss() {
        AudioServicesPlaySystemSound(1521) // Nope sound
    }
    
    func playCountdown() {
        AudioServicesPlaySystemSound(1104) // Tick
    }
}
