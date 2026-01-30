import SwiftUI

struct CustomButton: View {
    let title: String
    let iconName: String?
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case primary
        case secondary
        case success
        case danger
        case ghost
    }
    
    init(
        title: String,
        iconName: String? = nil,
        style: ButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let iconName = iconName {
                    IconView(name: iconName, size: 20)
                }
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(backgroundView)
            .foregroundColor(foregroundColor)
            .cornerRadius(AppTheme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                    .strokeBorder(borderColor, lineWidth: style == .ghost ? 2 : 0)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            AppTheme.primaryGradient
        case .secondary:
            AppTheme.cardBackgroundLight
        case .success:
            AppTheme.successGradient
        case .danger:
            AppTheme.dangerGradient
        case .ghost:
            Color.clear
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .ghost:
            return AppTheme.primary
        default:
            return .white
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .ghost:
            return AppTheme.primary
        default:
            return .clear
        }
    }
}

struct ScaleButtonStyle: SwiftUI.ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct LargeCatchButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                IconView(name: "hook", size: 48)
                Text("CATCH!")
                    .font(.system(size: 32, weight: .black))
            }
            .frame(width: 200, height: 200)
            .background(
                Circle()
                    .fill(AppTheme.successGradient)
                    .shadow(color: AppTheme.success.opacity(0.5), radius: 20, x: 0, y: 10)
            )
            .foregroundColor(.white)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
