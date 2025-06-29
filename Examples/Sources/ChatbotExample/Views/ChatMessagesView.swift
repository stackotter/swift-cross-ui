import SwiftCrossUI

// MARK: - Chat Messages View

struct ChatMessagesView: View {
    let messages: [ChatMessage]
    let isLoading: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.sm) {
                if messages.isEmpty {
                    EmptyStateView()
                } else {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                
                if isLoading {
                    LoadingIndicatorView()
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
        }
    }
}

// MARK: - Empty State View

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Text("👋")
                .font(.system(size: 50))
            
            Text("Welcome!")
                .font(AppFonts.title2)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.text)
            
            Text("Start a conversation by typing a message below.")
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 50)
    }
}

// MARK: - Loading Indicator View

struct LoadingIndicatorView: View {
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Text("🤖")
                .font(AppFonts.title2)
            Text("Thinking...")
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
        .surfaceStyle()
    }
}
