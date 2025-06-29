import SwiftCrossUI
import Foundation

// MARK: - Message Bubble View

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            if message.isUser {
                Spacer()
                
                VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                    Text(message.content)
                        .font(AppFonts.body)
                        .foregroundColor(.white)
                        .padding(AppSpacing.md)
                        .background(AppColors.primary)
                        .cornerRadius(AppCornerRadius.large)
                        .frame(maxWidth: 600, alignment: .trailing)
                    
                    Text(formatTime(message.timestamp))
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Text("👤")
                    .font(AppFonts.title2)
            } else {
                Text("🤖")
                    .font(AppFonts.title2)
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(message.content)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.text)
                        .padding(AppSpacing.md)
                        .background(AppColors.surface)
                        .cornerRadius(AppCornerRadius.large)
                        .frame(maxWidth: 600, alignment: .leading)
                    
                    Text(formatTime(message.timestamp))
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
