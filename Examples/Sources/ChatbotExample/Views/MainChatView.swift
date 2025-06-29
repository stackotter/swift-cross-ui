import SwiftCrossUI

// MARK: - Main Chat View

struct MainChatView: View {
    var viewModel: ChatbotViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ChatHeaderView(viewModel: viewModel)
            
            // Divider
            Rectangle()
                .fill(AppColors.border)
                .frame(height: 1)
            
            // Content area
            if viewModel.isThreadSelected {
                ChatContentView(viewModel: viewModel)
            } else {
                EmptyThreadView(viewModel: viewModel)
            }
            
            // Error message
            if let errorMessage = viewModel.errorMessage {
                ErrorMessageView(message: errorMessage)
            }
            
            // Input area
            if viewModel.isThreadSelected {
                ChatInputView(
                    currentMessage: Binding(
                        get: { viewModel.currentMessage },
                        set: { viewModel.currentMessage = $0 }
                    ),
                    errorMessage: Binding(
                        get: { viewModel.errorMessage },
                        set: { viewModel.errorMessage = $0 }
                    ),
                    isLoading: viewModel.isLoading,
                    messageCount: viewModel.currentThreadMessages.count,
                    onSend: viewModel.sendMessage
                )
            }
        }
    }
}

// MARK: - Chat Header View

struct ChatHeaderView: View {
    var viewModel: ChatbotViewModel
    
    var body: some View {
        HStack {
            // Sidebar toggle button (when hidden)
            if !viewModel.showSidebar {
                Button("☰") {
                    viewModel.toggleSidebar()
                }
                .iconButtonLargeStyle()
            }
            
            // Thread title or placeholder
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                if let thread = viewModel.selectedThread {
                    Text(thread.title)
                        .font(AppFonts.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.text)
                    Text("Created today")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                } else {
                    Text("AI Chat Assistant")
                        .font(AppFonts.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.text)
                }
            }
            
            Spacer()
            
            Button("⚙️") {
                viewModel.toggleSettings()
            }
            .iconButtonLargeStyle()
        }
        .padding(.horizontal, AppSpacing.xl)
        .padding(.vertical, AppSpacing.lg)
        .background(AppColors.background)
    }
}

// MARK: - Chat Content View

struct ChatContentView: View {
    var viewModel: ChatbotViewModel
    
    var body: some View {
        ChatMessagesView(
            messages: viewModel.currentThreadMessages,
            isLoading: viewModel.isLoading
        )
    }
}

// MARK: - Empty Thread View

struct EmptyThreadView: View {
    var viewModel: ChatbotViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: AppSpacing.xl) {
                VStack(spacing: AppSpacing.lg) {
                    Text("🤖")
                        .font(.system(size: 64))
                    
                    VStack(spacing: AppSpacing.md) {
                        Text("Ready to Chat")
                            .font(AppFonts.title)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.text)
                        
                        Text("Create a new conversation to start chatting with AI.\nYour conversations will be saved and you can continue them anytime.")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Button("+ Start New Conversation") {
                    viewModel.createNewThread()
                }
                .primaryButtonStyle()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .padding(AppSpacing.xl)
    }
}

// MARK: - Error Message View

struct ErrorMessageView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Text("⚠️")
                .font(AppFonts.body)
            Text(message)
                .font(AppFonts.body)
                .foregroundColor(AppColors.error)
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.error.opacity(0.1))
        .cornerRadius(AppCornerRadius.medium)
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.sm)
    }
}
