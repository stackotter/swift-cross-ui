import SwiftCrossUI

// MARK: - Chat Input View

struct ChatInputView: View {
    @Binding var currentMessage: String
    @Binding var errorMessage: String?
    let isLoading: Bool
    let messageCount: Int
    let onSend: () -> Void
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                TextEditor(text: $currentMessage)
                    .padding(AppSpacing.sm)
                    .frame(minHeight: 30, maxHeight: 80) // Much more compact input area
                    .background(AppColors.background)
                    .cornerRadius(AppCornerRadius.large)
                
                VStack(spacing: AppSpacing.sm) {
                    Button("Send") {
                        onSend()
                    }
                    .primaryButtonStyle()
                    .disabled(currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                    
                    Button("Clear") {
                        currentMessage = ""
                        errorMessage = nil
                    }
                    .secondaryButtonStyle()
                    .disabled(isLoading)
                }
            }
            
            HStack {
                if messageCount == 0 {
                    Text("Type your message...")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                } else {
                    Text("\(messageCount) messages")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
            }
        }
        .padding(AppSpacing.xl)
        .background(AppColors.surface)
    }
}
