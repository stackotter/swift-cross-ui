import Foundation
import SwiftCrossUI
import OpenAI

// MARK: - OpenAI Service

class OpenAIService {
    private var openAI: OpenAI?
    
    func configure(apiKey: String) {
        openAI = OpenAI(apiToken: apiKey)
        print("🔑 OpenAI client configured successfully")
    }
    
    // MARK: - Thread-based Chat
    
    func sendMessageToThread(_ message: String, threadMessages: [ThreadMessage], model: LLM) async throws -> String {
        guard let openAI = openAI else {
            print("❌ OpenAI client not configured")
            throw ChatError.missingAPIKey
        }
        
        print("📤 Sending message to thread conversation")
        print("📝 Message length: \(message.count) characters")
        print("🤖 Model: \(model)")
        print("📚 Context messages: \(threadMessages.count)")
        
        // Build conversation messages array from thread history
        var allMessages = threadMessages.compactMap { threadMessage in
            if threadMessage.isUser {
                return ChatQuery.ChatCompletionMessageParam(role: .user, content: threadMessage.content)
            } else {
                return ChatQuery.ChatCompletionMessageParam(role: .assistant, content: threadMessage.content)
            }
        }
        
        // Add the new user message
        if let newMessage = ChatQuery.ChatCompletionMessageParam(role: .user, content: message) {
            allMessages.append(newMessage)
        }
        
        let query = ChatQuery(
            messages: allMessages,
            model: model
        )
        
        do {
            let result = try await openAI.chats(query: query)
            let response = result.choices.first?.message.content ?? "No response"
            print("✅ Successfully received response from thread conversation")
            return response
        } catch let error as APIError {
            print("❌ OpenAI API Error: \(error)")
            throw ChatError.invalidResponse
        } catch {
            print("❌ Network error: \(error)")
            throw ChatError.invalidResponse
        }
    }
    
    func fetchAvailableModels() async throws -> [Model] {
        guard let openAI = openAI else {
            print("❌ OpenAI client not configured")
            throw ChatError.missingAPIKey
        }
        
        print("📋 Fetching available models from OpenAI API")
        
        do {
            let modelsResponse = try await openAI.models()
            let availableModels = modelsResponse.data.compactMap { modelData -> Model? in
                // Filter for the 5 core chat models we support
                let id = modelData.id
                switch id {
                case "gpt-4o":
                    return .gpt4_o
                case "gpt-4o-mini":
                    return .gpt4_o_mini
                case "gpt-4-turbo":
                    return .gpt4_turbo
                case "gpt-4":
                    return .gpt4
                case "gpt-3.5-turbo":
                    return .gpt3_5Turbo
                default:
                    return nil
                }
            }
            
            print("✅ Found \(availableModels.count) available chat models")
            return Array(Set(availableModels)) // Remove duplicates
        } catch {
            print("❌ Failed to fetch models: \(error)")
            // Return default models as fallback
            return [.gpt4_o, .gpt4_o_mini, .gpt4_turbo, .gpt4, .gpt3_5Turbo]
        }
    }
    
    func sendMessage(_ message: String, model: LLM) async throws -> String {
        guard let openAI = openAI else {
            print("❌ OpenAI client not configured")
            throw ChatError.missingAPIKey
        }
        
        print("📤 Sending message to OpenAI API")
        print("📝 Message length: \(message.count) characters")
        print("🤖 Model: \(model)")
        
        let query = ChatQuery(
            messages: [
                .user(.init(content: .string(message)))
            ],
            model: model
        )
        
        do {
            let result = try await openAI.chats(query: query)
            let response = result.choices.first?.message.content ?? "No response"
            print("✅ Successfully received response (\(response.count) characters)")
            return response
        } catch let error as APIError {
            print("❌ OpenAI API Error: \(error)")
            // Handle different API errors
            throw ChatError.invalidResponse
        } catch {
            print("❌ Network error: \(error)")
            throw ChatError.invalidResponse
        }
    }
}
