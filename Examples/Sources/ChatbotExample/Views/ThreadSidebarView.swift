import SwiftCrossUI
import Foundation

// MARK: - Thread Sidebar View

struct ThreadSidebarView: View {
    @Binding var threads: [ChatThread]
    @Binding var selectedThread: ChatThread?
    @Binding var showSidebar: Bool
    
    let onNewThread: () -> Void
    let onSelectThread: (ChatThread) -> Void
    let onDeleteThread: (ChatThread) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("💬 Conversations")
                    .font(AppFonts.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.text)
                    .fixedSize(horizontal: true, vertical: false)
                
                Spacer()
                
                Button("×") {
                    showSidebar = false
                }
                .iconButtonLargeStyle()
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.vertical, AppSpacing.sm)
            .background(AppColors.surface)
        
            // Thread List
            ScrollView {
                VStack(spacing: AppSpacing.sm) {
                    if threads.isEmpty {
                        EmptyThreadsView()
                    } else {
                        ForEach(threads) { thread in
                            ThreadRowView(
                                thread: thread,
                                isSelected: selectedThread?.id == thread.id,
                                onSelect: { onSelectThread(thread) },
                                onDelete: { onDeleteThread(thread) }
                            )
                        }
                    }
                }
                .padding(AppSpacing.lg)
            }
            .frame(maxHeight: .infinity)
            .background(AppColors.surface)
            
            // Footer with action buttons
            VStack(spacing: 0) {
                Rectangle()
                    .fill(AppColors.border)
                    .frame(height: 1)
                
                Button("💬 New Conversation") {
                    onNewThread()
                }
                .primaryButtonStyle()
                .frame(maxWidth: .infinity)
                .padding(AppSpacing.lg)
            }
            .background(AppColors.surface)
        }
        .frame(maxHeight: .infinity)
        .background(AppColors.surface)
        .frame(width: 300)
    }
}

// MARK: - Thread Row View

struct ThreadRowView: View {
    let thread: ChatThread
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Thread indicator
            Circle()
                .fill(isSelected ? AppColors.primary : AppColors.border)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(thread.title)
                    .font(AppFonts.body)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.text)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(relativeTime(from: thread.lastMessageAt))
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                onSelect()
            }
            
            Button("×") {
                onDelete()
            }
            .destructiveButtonStyle()
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.xl)
        .background(isSelected ? AppColors.primary.opacity(0.1) : Color.clear)
        .cornerRadius(AppCornerRadius.medium)
    }
    
    private func relativeTime(from date: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(date)
        
        if interval < 60 {
            return "now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        } else if interval < 604800 {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
    }
}

// MARK: - Empty Threads View

struct EmptyThreadsView: View {
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Text("💭")
                .font(.system(size: 48))
            
            VStack(spacing: AppSpacing.md) {
                Text("No conversations")
                    .font(AppFonts.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.text)
                
                Text("Start a new conversation to\nbegin chatting with AI!")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, AppSpacing.xxl)
        .frame(maxWidth: .infinity)
    }
}
