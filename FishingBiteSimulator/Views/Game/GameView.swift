import SwiftUI

struct GameView: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var gameManager = GameManager()
    @Environment(\.presentationMode) var presentationMode
    @State private var showResults = false
    
    var body: some View {
        ZStack {
            // Background
            backgroundView
            
            // Content
            VStack {
                // Header
                gameHeader
                
                Spacer()
                
                // Main game area
                gameContent
                
                Spacer()
                
                // Bottom controls
                bottomControls
            }
            .padding()
        }
        .onAppear {
            gameManager.startGame(
                difficulty: dataManager.settings.selectedDifficulty,
                settings: dataManager.settings
            )
        }
        .onChange(of: gameManager.gameState) { newState in
            if case .finished = newState {
                if let session = gameManager.currentSession {
                    dataManager.addSession(session)
                }
                showResults = true
            }
        }
        .fullScreenCover(isPresented: $showResults) {
            if let session = gameManager.currentSession {
                ResultsView(session: session) {
                    showResults = false
                    presentationMode.wrappedValue.dismiss()
                } onRetry: {
                    showResults = false
                    gameManager.startGame(
                        difficulty: dataManager.settings.selectedDifficulty,
                        settings: dataManager.settings
                    )
                }
            }
        }
    }
    
    // MARK: - Background
    
    @ViewBuilder
    private var backgroundView: some View {
        switch gameManager.gameState {
        case .bite:
            LinearGradient(
                colors: [Color(hex: "FF6B35"), Color(hex: "F7931E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        case .caught:
            LinearGradient(
                colors: [AppTheme.success, AppTheme.successDark],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        case .missed:
            LinearGradient(
                colors: [AppTheme.danger, AppTheme.dangerDark],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        default:
            AppTheme.backgroundGradient
                .ignoresSafeArea()
        }
    }
    
    // MARK: - Header
    
    private var gameHeader: some View {
        HStack {
            Button(action: {
                gameManager.endGame()
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack(spacing: 6) {
                    IconView(name: "arrow_left", size: 20, color: .white)
                    Text("Exit")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            // Round counter
            VStack(spacing: 2) {
                Text("Round \(gameManager.currentRound)/\(gameManager.totalRounds)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.2))
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(width: geo.size.width * gameManager.progressPercentage)
                    }
                }
                .frame(width: 100, height: 4)
            }
            
            Spacer()
            
            // Caught counter
            HStack(spacing: 4) {
                IconView(name: "fish_medium", size: 20, color: .white)
                Text("\(gameManager.caughtCount)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Game Content
    
    @ViewBuilder
    private var gameContent: some View {
        switch gameManager.gameState {
        case .idle:
            EmptyView()
            
        case .countdown(let count):
            CountdownView(count: count)
            
        case .waiting:
            WaitingView()
            
        case .bite:
            BiteView(onCatch: {
                gameManager.catchFish()
            })
            
        case .caught(let time):
            CaughtView(reactionTime: time)
            
        case .missed:
            MissedView()
            
        case .finished:
            EmptyView()
        }
    }
    
    // MARK: - Bottom Controls
    
    @ViewBuilder
    private var bottomControls: some View {
        switch gameManager.gameState {
        case .caught, .missed:
            if !dataManager.settings.autoNextRound {
                CustomButton(
                    title: gameManager.currentRound >= gameManager.totalRounds ? "Finish" : "Next Round",
                    iconName: "play",
                    style: .secondary
                ) {
                    gameManager.continueAfterResult()
                }
            }
        default:
            EmptyView()
        }
    }
}

// MARK: - Countdown View

struct CountdownView: View {
    let count: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(count)")
                .font(.system(size: 120, weight: .bold))
                .foregroundColor(.white)
                .scaleEffect(1.0)
                .animation(.easeOut(duration: 0.3), value: count)
            
            Text("Get Ready...")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// MARK: - Waiting View

struct WaitingView: View {
    @State private var rodAngle: Double = 0
    @State private var rippleScale: CGFloat = 0.5
    @State private var rippleOpacity: Double = 0.5
    
    var body: some View {
        VStack(spacing: 40) {
            // Animated fishing rod
            FishingRodView(isShaking: false)
                .rotationEffect(.degrees(rodAngle))
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        rodAngle = 3
                    }
                }
            
            // Water ripples
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .stroke(AppTheme.accent.opacity(0.3), lineWidth: 2)
                        .frame(width: 100 + CGFloat(index) * 40)
                        .scaleEffect(rippleScale)
                        .opacity(rippleOpacity)
                        .animation(
                            Animation.easeOut(duration: 2)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 0.5),
                            value: rippleScale
                        )
                }
            }
            .frame(height: 100)
            .onAppear {
                rippleScale = 1.2
                rippleOpacity = 0
            }
            
            Text("Focus... waiting for bite")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
        }
    }
}

// MARK: - Bite View

struct BiteView: View {
    let onCatch: () -> Void
    @State private var pulseScale: CGFloat = 1.0
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 30) {
            // Shaking rod
            FishingRodView(isShaking: true)
                .offset(x: shakeOffset)
                .onAppear {
                    // Rapid shake animation
                    withAnimation(Animation.linear(duration: 0.05).repeatForever(autoreverses: true)) {
                        shakeOffset = 8
                    }
                }
            
            Text("BITE!")
                .font(.system(size: 48, weight: .black))
                .foregroundColor(.white)
                .scaleEffect(pulseScale)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 0.3).repeatForever(autoreverses: true)) {
                        pulseScale = 1.1
                    }
                }
            
            // Catch button
            LargeCatchButton(action: onCatch)
                .padding(.top, 20)
        }
    }
}

// MARK: - Caught View

struct CaughtView: View {
    let reactionTime: Double
    @State private var showContent = false
    
    private var rating: ReactionRating {
        ReactionRating.fromReactionTime(reactionTime)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            IconView(name: "fish_medium", size: 80, color: .white)
                .scaleEffect(showContent ? 1 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showContent)
            
            Text(rating.description)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.3).delay(0.2), value: showContent)
            
            Text(String(format: "%.3f seconds", reactionTime))
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.3).delay(0.3), value: showContent)
        }
        .onAppear {
            showContent = true
        }
    }
}

// MARK: - Missed View

struct MissedView: View {
    @State private var showContent = false
    @State private var fishOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 20) {
            IconView(name: "fish_medium", size: 80, color: .white.opacity(0.5))
                .offset(y: fishOffset)
                .opacity(showContent ? 0.3 : 1)
                .onAppear {
                    withAnimation(.easeIn(duration: 1)) {
                        fishOffset = 200
                    }
                }
            
            Text("Missed!")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
            
            Text("Too slow - the fish got away")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .onAppear {
            showContent = true
        }
    }
}

// MARK: - Fishing Rod View

struct FishingRodView: View {
    let isShaking: Bool
    
    var body: some View {
        Canvas { context, size in
            let scale = min(size.width, size.height) / 200
            
            // Rod
            var rodPath = Path()
            rodPath.move(to: CGPoint(x: 40 * scale, y: 180 * scale))
            rodPath.addQuadCurve(
                to: CGPoint(x: 160 * scale, y: 20 * scale),
                control: CGPoint(x: 100 * scale, y: 80 * scale)
            )
            context.stroke(
                rodPath,
                with: .color(Color(hex: "8B4513")),
                lineWidth: 6 * scale
            )
            
            // Reel
            let reelRect = CGRect(
                x: 55 * scale, y: 140 * scale,
                width: 25 * scale, height: 25 * scale
            )
            context.fill(Path(ellipseIn: reelRect), with: .color(Color(hex: "333333")))
            
            // Line
            var linePath = Path()
            linePath.move(to: CGPoint(x: 160 * scale, y: 20 * scale))
            linePath.addLine(to: CGPoint(x: 160 * scale, y: 80 * scale))
            context.stroke(linePath, with: .color(.white.opacity(0.6)), lineWidth: 1 * scale)
            
            // Hook
            var hookPath = Path()
            hookPath.move(to: CGPoint(x: 160 * scale, y: 80 * scale))
            hookPath.addQuadCurve(
                to: CGPoint(x: 145 * scale, y: 110 * scale),
                control: CGPoint(x: 160 * scale, y: 100 * scale)
            )
            hookPath.addQuadCurve(
                to: CGPoint(x: 170 * scale, y: 95 * scale),
                control: CGPoint(x: 130 * scale, y: 120 * scale)
            )
            context.stroke(hookPath, with: .color(Color(hex: "C0C0C0")), lineWidth: 2 * scale)
        }
        .frame(width: 200, height: 200)
    }
}
