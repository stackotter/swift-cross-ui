import Foundation
import SwiftCrossUI
import OpenAI

// MARK: - ChatBot ViewModel

@MainActor
class ChatbotViewModel: SwiftCrossUI.ObservableObject {
    // MARK: - Published Properties
    @SwiftCrossUI.Published var selectedThread: ChatThread?
    @SwiftCrossUI.Published var threads: [ChatThread] = []
    @SwiftCrossUI.Published var currentMessage = ""
    @SwiftCrossUI.Published var selectedLLM: LLM = .gpt3_5Turbo
    @SwiftCrossUI.Published var isLoading = false
    @SwiftCrossUI.Published var errorMessage: String?
    @SwiftCrossUI.Published var showSettings = false
    
    // MARK: - Dependencies
    let threadStorage = ThreadStorage()
    let apiKeyStorage = APIKeyStorage()
    let openAIService = OpenAIService()
    
    // MARK: - Computed Properties
    
    /// Current thread messages converted to ChatMessage format for compatibility
    var currentThreadMessages: [ChatMessage] {
        guard let thread = selectedThread else { return [] }
        let threadMessages = threadStorage.loadMessages(for: thread.id)
        return threadMessages.map { threadMessage in
            ChatMessage(
                content: threadMessage.content,
                isUser: threadMessage.isUser,
                timestamp: threadMessage.timestamp
            )
        }
    }
    
    var isThreadSelected: Bool {
        selectedThread != nil
    }
    
    // MARK: - Initialization
    
    init() {
        loadSavedAPIKey()
        loadThreads()
    }
    
    // MARK: - API Key Management
    
    private func loadSavedAPIKey() {
        if let savedKey = apiKeyStorage.loadAPIKey() {
            openAIService.configure(apiKey: savedKey)
        }
    }
    
    func reloadAPIKey() {
        if let savedKey = apiKeyStorage.loadAPIKey() {
            openAIService.configure(apiKey: savedKey)
        }
    }
    
    // MARK: - Thread Management
    
    private func loadThreads() {
        threads = threadStorage.loadThreads()
        print("📂 Loaded \(threads.count) threads from storage")
    }
    
    func createNewThread() {
        let newThread = ChatThread(title: "New Chat")
        print("🆕 Creating new thread: \(newThread.id)")
        threadStorage.saveThread(newThread)
        loadThreads()
        selectedThread = newThread
        clearError()
        print("✅ New thread created and selected")
    }
    
    func selectThread(_ thread: ChatThread) {
        selectedThread = thread
        clearError()
        print("📌 Selected thread: \(thread.title)")
    }
    
    func deleteThread(_ thread: ChatThread) {
        threadStorage.deleteThread(thread.id)
        loadThreads()
        
        // If the deleted thread was selected, clear selection
        if selectedThread?.id == thread.id {
            selectedThread = nil
        }
        print("🗑️ Deleted thread: \(thread.title)")
    }
    
    // MARK: - Message Sending
    
    func sendMessage() {
        guard let thread = selectedThread else {
            setError("No thread selected")
            return
        }
        
        let messageText = currentMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !messageText.isEmpty else { return }
        
        // Save user message
        let userMessage = ThreadMessage(
            threadId: thread.id,
            content: messageText,
            isUser: true
        )
        threadStorage.saveMessage(userMessage)
        
        // Update thread title if this is the first message
        updateThreadTitleIfNeeded(thread, firstMessage: messageText)
        
        // Clear input and prepare for response
        currentMessage = ""
        clearError()
        isLoading = true
        
        Task {
            await sendMessageToOpenAI(messageText, thread: thread)
        }
    }
    
    private func sendMessageToOpenAI(_ messageText: String, thread: ChatThread) async {
        do {
            let threadMessages = threadStorage.loadMessages(for: thread.id)
            let response = try await openAIService.sendMessageToThread(
                messageText,
                threadMessages: threadMessages,
                model: selectedLLM
            )
            
            // Save bot response
            let botMessage = ThreadMessage(
                threadId: thread.id,
                content: response,
                isUser: false
            )
            threadStorage.saveMessage(botMessage)
            
            // Update UI
            loadThreads() // Refresh threads to update last message time
            isLoading = false
            
        } catch {
            setError(error.localizedDescription)
            isLoading = false
        }
    }
    
    // MARK: - UI State Management
    
    func toggleSettings() {
        showSettings.toggle()
    }
    
    private func clearError() {
        errorMessage = nil
    }
    
    private func setError(_ message: String) {
        errorMessage = message
        isLoading = false
    }
    
    // MARK: - Thread Title Generation
    
    private func generateThreadTitle(from message: String) -> String {
        return threadStorage.generateThreadTitle(from: message)
    }
    
    private func updateThreadTitleIfNeeded(_ thread: ChatThread, firstMessage: String) {
        if thread.title == "New Chat" || thread.title == "New Conversation" {
            let newTitle = generateThreadTitle(from: firstMessage)
            let updatedThread = ChatThread(
                id: thread.id,
                title: newTitle,
                openAIThreadId: thread.openAIThreadId
            )
            threadStorage.saveThread(updatedThread)
            
            selectedThread = updatedThread
            loadThreads()
        }
    }
}

// MARK: - Binding Extensions

extension ChatbotViewModel {
    var threadsBinding: Binding<[ChatThread]> {
        Binding(
            get: { self.threads },
            set: { self.threads = $0 }
        )
    }
    
    var selectedThreadBinding: Binding<ChatThread?> {
        Binding(
            get: { self.selectedThread },
            set: { self.selectedThread = $0 }
        )
    }
    
    var currentMessageBinding: Binding<String> {
        Binding(
            get: { self.currentMessage },
            set: { self.currentMessage = $0 }
        )
    }
    
    var errorMessageBinding: Binding<String?> {
        Binding(
            get: { self.errorMessage },
            set: { self.errorMessage = $0 }
        )
    }
    
    var showSettingsBinding: Binding<Bool> {
        Binding(
            get: { self.showSettings },
            set: { self.showSettings = $0 }
        )
    }
    
    var selectedLLMBinding: Binding<LLM> {
        Binding(
            get: { self.selectedLLM },
            set: { self.selectedLLM = $0 }
        )
    }
}
