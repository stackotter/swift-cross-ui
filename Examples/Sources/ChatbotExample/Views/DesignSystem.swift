import SwiftCrossUI

// MARK: - Design System

struct AppColors {
    static let primary = Color.blue
    static let secondary = Color.purple
    static let accent = Color.green
    static let background = Color.white
    static let surface = Color.gray.opacity(0.08)
    static let border = Color.gray.opacity(0.15)
    static let text = Color.black
    static let textSecondary = Color.gray
    static let error = Color.red
    static let success = Color.green
}

struct AppFonts {
    static let title = Font.title
    static let title2 = Font.title2
    static let headline = Font.headline
    static let subheadline = Font.subheadline
    static let body = Font.body
    static let caption = Font.caption
    static let caption2 = Font.caption2
}

struct AppSpacing {
    static let xs = 4
    static let sm = 8
    static let md = 12
    static let lg = 16
    static let xl = 24
    static let xxl = 32
}

struct AppCornerRadius {
    static let small = 6
    static let medium = 10
    static let large = 16
    static let extraLarge = 24
}

// MARK: - Button Styles

extension View {
    // Primary action buttons - main calls to action
    func primaryButtonStyle() -> some View {
        self
            .font(AppFonts.body)
            .fontWeight(.semibold)
            .foregroundColor(AppColors.primary)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .frame(minHeight: 44)
            .cornerRadius(AppCornerRadius.medium)
    }
    
    // Secondary action buttons - supporting actions
    func secondaryButtonStyle() -> some View {
        self
            .font(AppFonts.body)
            .fontWeight(.medium)
            .foregroundColor(AppColors.textSecondary)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .frame(minHeight: 44)
            .cornerRadius(AppCornerRadius.medium)
    }
    
    // Large icon buttons - for header actions, close buttons
    func iconButtonLargeStyle() -> some View {
        self
            .font(AppFonts.headline)
            .fontWeight(.medium)
            .foregroundColor(AppColors.textSecondary)
            .frame(width: 44, height: 44)
            .cornerRadius(AppCornerRadius.medium)
    }
    
    // Regular icon buttons - standard icon interactions
    func iconButtonStyle() -> some View {
        self
            .font(AppFonts.body)
            .foregroundColor(AppColors.textSecondary)
            .frame(width: 36, height: 36)
            .cornerRadius(AppCornerRadius.small)
    }
    
    // Small destructive buttons - for delete actions
    func destructiveButtonStyle() -> some View {
        self
            .font(AppFonts.caption)
            .fontWeight(.medium)
            .foregroundColor(AppColors.error)
            .frame(width: 32, height: 32)
            .cornerRadius(AppCornerRadius.small)
    }
    
    // Large destructive buttons - for major destructive actions
    func destructiveButtonLargeStyle() -> some View {
        self
            .font(AppFonts.body)
            .fontWeight(.semibold)
            .foregroundColor(AppColors.error)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .frame(minHeight: 44)
            .cornerRadius(AppCornerRadius.medium)
    }
    
    func textFieldStyle() -> some View {
        self
            .padding(AppSpacing.md)
            .background(AppColors.surface)
            .cornerRadius(AppCornerRadius.medium)
    }
    
    func cardStyle() -> some View {
        self
            .padding(AppSpacing.lg)
            .background(AppColors.background)
            .cornerRadius(AppCornerRadius.large)
    }
    
    func surfaceStyle() -> some View {
        self
            .padding(AppSpacing.lg)
            .background(AppColors.surface)
            .cornerRadius(AppCornerRadius.medium)
    }
}
