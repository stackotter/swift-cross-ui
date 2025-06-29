import DefaultBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

// MARK: - Main App

@main
@HotReloadable
struct ChatbotApp: App {
    @SwiftCrossUI.State private var viewModel = ChatbotViewModel()
    
    var body: some Scene {
        WindowGroup("ChatBot") {
            #hotReloadable {
                NavigationSplitView {
                    // Sidebar content
                    ThreadSidebarView(
                        threads: viewModel.threadsBinding,
                        selectedThread: viewModel.selectedThreadBinding,
                        onNewThread: viewModel.createNewThread,
                        onSelectThread: viewModel.selectThread,
                        onDeleteThread: viewModel.deleteThread
                    )
                } detail: {
                    // Main chat area
                    MainChatView(viewModel: viewModel)
                }
                .overlay {
                    // Settings Overlay
                    if viewModel.showSettings {
                        ChatSettingsDialog(
                            isPresented: viewModel.showSettingsBinding,
                            selectedModel: viewModel.selectedLLMBinding,
                            openAIService: viewModel.openAIService,
                            apiKeyStorage: viewModel.apiKeyStorage,
                            onSave: viewModel.reloadAPIKey
                        )
                    }
                }
            }
        }
        .defaultSize(width: 1200, height: 800)
    }
}
