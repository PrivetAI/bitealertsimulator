import Foundation
import SwiftUI

// MARK: - Date Extensions

extension Date {
    func daysAgo() -> String {
        let days = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
        if days == 0 {
            return "Today"
        } else if days == 1 {
            return "Yesterday"
        } else {
            return "\(days) days ago"
        }
    }
    
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: self)
    }
    
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: self)
    }
    
    func formattedDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: self)
    }
}

// MARK: - Double Extensions

extension Double {
    func formatReactionTime() -> String {
        return String(format: "%.3fs", self)
    }
    
    func formatPercentage() -> String {
        return String(format: "%.0f%%", self)
    }
}

// MARK: - View Extensions

extension View {
    func cardStyle() -> some View {
        self
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
    }
    
    func adaptivePadding() -> some View {
        self.padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 16)
    }
    
    func shimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}

// MARK: - Shimmer Effect

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.3),
                            Color.white.opacity(0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.5)
                    .offset(x: phase * geometry.size.width * 1.5 - geometry.size.width * 0.25)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

// MARK: - Conditional Modifier

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
