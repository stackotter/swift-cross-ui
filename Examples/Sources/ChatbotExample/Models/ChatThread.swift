import Foundation

// MARK: - Thread Models

struct ChatThread: Identifiable, Codable {
    let id: String
    let title: String
    let createdAt: Date
    let lastMessageAt: Date
    let openAIThreadId: String? // OpenAI Thread ID for API integration
    
    init(id: String = UUID().uuidString, title: String, openAIThreadId: String? = nil) {
        self.id = id
        self.title = title
        self.createdAt = Date()
        self.lastMessageAt = Date()
        self.openAIThreadId = openAIThreadId
    }
    
    func updated(with lastMessageTime: Date = Date()) -> ChatThread {
        return ChatThread(
            id: self.id,
            title: self.title,
            openAIThreadId: self.openAIThreadId
        )
    }
}

// MARK: - Thread Message

struct ThreadMessage: Identifiable, Codable {
    let id: String
    let threadId: String
    let content: String
    let isUser: Bool
    let timestamp: Date
    let openAIMessageId: String? // OpenAI Message ID for API integration
    
    init(id: String = UUID().uuidString, threadId: String, content: String, isUser: Bool, openAIMessageId: String? = nil) {
        self.id = id
        self.threadId = threadId
        self.content = content
        self.isUser = isUser
        self.timestamp = Date()
        self.openAIMessageId = openAIMessageId
    }
}
