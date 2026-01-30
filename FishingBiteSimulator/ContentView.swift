import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab: Int = 0
    @State private var showGame = false
    
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Content area
                Group {
                    switch selectedTab {
                    case 0:
                        HomeView(showGame: $showGame)
                    case 1:
                        HistoryView()
                    case 2:
                        AchievementsView()
                    case 3:
                        SettingsView()
                    default:
                        HomeView(showGame: $showGame)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Custom Tab Bar
                CustomTabBar(selectedTab: $selectedTab)
            }
            .fullScreenCover(isPresented: $showGame) {
                GameView()
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs: [(icon: String, label: String)] = [
        ("home", "Home"),
        ("history", "History"),
        ("trophy", "Achievements"),
        ("settings", "Settings")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    iconName: tabs[index].icon,
                    label: tabs[index].label,
                    isSelected: selectedTab == index
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(AppTheme.cardBackground)
    }
}

struct TabBarButton: View {
    let iconName: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                IconView(
                    name: iconName,
                    size: 24,
                    color: isSelected ? AppTheme.primary : AppTheme.textMuted
                )
                
                Text(label)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppTheme.primary : AppTheme.textMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
