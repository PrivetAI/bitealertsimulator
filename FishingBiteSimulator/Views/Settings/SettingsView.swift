import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Sound & Vibration
                hapticSection
                
                // Game settings
                gameSettingsSection
                
                // About
                aboutSection
            }
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 16)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            IconView(name: "settings", size: 48, color: AppTheme.primary)
            
            Text("Settings")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
        }
    }
    
    // MARK: - Haptic Section
    
    private var hapticSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sound & Vibration")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            VStack(spacing: 0) {
                // Vibration toggle
                SettingsToggleRow(
                    title: "Vibration",
                    subtitle: "Feel the bite alerts",
                    iconName: "vibration",
                    isOn: Binding(
                        get: { dataManager.settings.vibrationEnabled },
                        set: {
                            dataManager.settings.vibrationEnabled = $0
                            dataManager.saveSettings()
                        }
                    )
                )
                
                Divider().background(AppTheme.textMuted.opacity(0.3))
                
                // Vibration intensity
                if dataManager.settings.vibrationEnabled {
                    SettingsPickerRow(
                        title: "Vibration Intensity",
                        iconName: "vibration",
                        selection: Binding(
                            get: { dataManager.settings.vibrationIntensity },
                            set: {
                                dataManager.settings.vibrationIntensity = $0
                                dataManager.saveSettings()
                            }
                        ),
                        options: AppSettings.VibrationIntensity.allCases
                    )
                    
                    Divider().background(AppTheme.textMuted.opacity(0.3))
                }
                
                // Sound toggle
                SettingsToggleRow(
                    title: "Sound Effects",
                    subtitle: "Hear bite alerts",
                    iconName: "sound",
                    isOn: Binding(
                        get: { dataManager.settings.soundEnabled },
                        set: {
                            dataManager.settings.soundEnabled = $0
                            dataManager.saveSettings()
                        }
                    )
                )
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    // MARK: - Game Settings
    
    private var gameSettingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Game")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            VStack(spacing: 0) {
                // Countdown
                SettingsToggleRow(
                    title: "Show Countdown",
                    subtitle: "3-2-1 before each session",
                    iconName: "timer",
                    isOn: Binding(
                        get: { dataManager.settings.showCountdown },
                        set: {
                            dataManager.settings.showCountdown = $0
                            dataManager.saveSettings()
                        }
                    )
                )
                
                Divider().background(AppTheme.textMuted.opacity(0.3))
                
                // Auto next round
                SettingsToggleRow(
                    title: "Auto Next Round",
                    subtitle: "Automatically proceed after each round",
                    iconName: "refresh",
                    isOn: Binding(
                        get: { dataManager.settings.autoNextRound },
                        set: {
                            dataManager.settings.autoNextRound = $0
                            dataManager.saveSettings()
                        }
                    )
                )
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    // MARK: - About
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            VStack(spacing: 0) {
                SettingsInfoRow(
                    title: "Version",
                    value: "1.0.0",
                    iconName: "target"
                )
                
                Divider().background(AppTheme.textMuted.opacity(0.3))
                
                SettingsInfoRow(
                    title: "Total Sessions",
                    value: "\(dataManager.totalSessions)",
                    iconName: "chart"
                )
                
                Divider().background(AppTheme.textMuted.opacity(0.3))
                
                SettingsInfoRow(
                    title: "Total Rounds",
                    value: "\(dataManager.totalRounds)",
                    iconName: "hook"
                )
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
}

// MARK: - Settings Rows

struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    let iconName: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            IconView(name: iconName, size: 24, color: AppTheme.primary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textMuted)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppTheme.primary)
        }
        .padding(16)
    }
}

struct SettingsPickerRow<T: Hashable & RawRepresentable>: View where T.RawValue == String {
    let title: String
    let iconName: String
    @Binding var selection: T
    let options: [T]
    
    var body: some View {
        HStack(spacing: 12) {
            IconView(name: iconName, size: 24, color: AppTheme.primary)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
            
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)
            .tint(AppTheme.textSecondary)
        }
        .padding(16)
    }
}

struct SettingsInfoRow: View {
    let title: String
    let value: String
    let iconName: String
    
    var body: some View {
        HStack(spacing: 12) {
            IconView(name: iconName, size: 24, color: AppTheme.primary)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(16)
    }
}
