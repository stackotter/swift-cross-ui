import Foundation
import SwiftCrossUI

// MARK: - Thread Storage Service

class ThreadStorage: SwiftCrossUI.ObservableObject {
    private let threadsKey = "chatThreads"
    private let messagesKey = "threadMessages"
    
    // MARK: - Thread Management
    
    func saveThread(_ thread: ChatThread) {
        var threads = loadThreads()
        if let index = threads.firstIndex(where: { $0.id == thread.id }) {
            threads[index] = thread
        } else {
            threads.append(thread)
        }
        
        // Sort threads by last message time (most recent first)
        threads.sort { $0.lastMessageAt > $1.lastMessageAt }
        
        if let data = try? JSONEncoder().encode(threads) {
            UserDefaults.standard.set(data, forKey: threadsKey)
            print("💾 Saved thread: \(thread.title)")
        }
    }
    
    func loadThreads() -> [ChatThread] {
        guard let data = UserDefaults.standard.data(forKey: threadsKey),
              let threads = try? JSONDecoder().decode([ChatThread].self, from: data) else {
            return []
        }
        return threads.sorted { $0.lastMessageAt > $1.lastMessageAt }
    }
    
    func deleteThread(_ threadId: String) {
        var threads = loadThreads()
        threads.removeAll { $0.id == threadId }
        
        if let data = try? JSONEncoder().encode(threads) {
            UserDefaults.standard.set(data, forKey: threadsKey)
        }
        
        // Also delete all messages for this thread
        deleteMessagesForThread(threadId)
        print("🗑️ Deleted thread: \(threadId)")
    }
    
    // MARK: - Message Management
    
    func saveMessage(_ message: ThreadMessage) {
        var messages = loadMessages()
        messages.append(message)
        
        if let data = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(data, forKey: messagesKey)
            print("💬 Saved message to thread: \(message.threadId)")
        }
        
        // Update thread's last message time
        updateThreadLastMessageTime(message.threadId)
    }
    
    func loadMessages(for threadId: String) -> [ThreadMessage] {
        let allMessages = loadMessages()
        return allMessages.filter { $0.threadId == threadId }.sorted { $0.timestamp < $1.timestamp }
    }
    
    private func loadMessages() -> [ThreadMessage] {
        guard let data = UserDefaults.standard.data(forKey: messagesKey),
              let messages = try? JSONDecoder().decode([ThreadMessage].self, from: data) else {
            return []
        }
        return messages
    }
    
    private func deleteMessagesForThread(_ threadId: String) {
        var messages = loadMessages()
        messages.removeAll { $0.threadId == threadId }
        
        if let data = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(data, forKey: messagesKey)
        }
    }
    
    private func updateThreadLastMessageTime(_ threadId: String) {
        var threads = loadThreads()
        if let index = threads.firstIndex(where: { $0.id == threadId }) {
            let updatedThread = threads[index].updated()
            threads[index] = updatedThread
            
            if let data = try? JSONEncoder().encode(threads) {
                UserDefaults.standard.set(data, forKey: threadsKey)
            }
        }
    }
    
    // MARK: - Utility
    
    func generateThreadTitle(from firstMessage: String) -> String {
        let words = firstMessage.components(separatedBy: .whitespacesAndNewlines)
        let limitedWords = Array(words.prefix(4))
        let title = limitedWords.joined(separator: " ")
        return title.isEmpty ? "New Conversation" : title
    }
}
