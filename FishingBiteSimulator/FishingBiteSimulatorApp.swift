import SwiftUI

@main
struct FishingBiteSimulatorApp: App {
    @StateObject private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .preferredColorScheme(.dark)
        }
    }
}
