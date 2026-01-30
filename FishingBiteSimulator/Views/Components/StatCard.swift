import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let iconName: String
    let color: Color
    
    init(
        title: String,
        value: String,
        subtitle: String? = nil,
        iconName: String,
        color: Color = AppTheme.primary
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.iconName = iconName
        self.color = color
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                IconView(name: iconName, size: 24, color: color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textMuted)
                }
            }
        }
        .padding(AppTheme.paddingMedium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
}

struct CompactStatCard: View {
    let title: String
    let value: String
    let iconName: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            IconView(name: iconName, size: 20, color: color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textMuted)
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusSmall)
    }
}
