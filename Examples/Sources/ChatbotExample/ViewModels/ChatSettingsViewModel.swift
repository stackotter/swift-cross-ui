import Foundation
import SwiftCrossUI
import OpenAI

// MARK: - Chat Settings View Model

@MainActor
class ChatSettingsViewModel: SwiftCrossUI.ObservableObject {
    @SwiftCrossUI.Published var apiKey: String = ""
    @SwiftCrossUI.Published var apiEndpoint: String = "https://api.openai.com/v1/chat/completions"
    @SwiftCrossUI.Published var temperature: Double = 0.7
    @SwiftCrossUI.Published var maxTokens: String = "1000"
    @SwiftCrossUI.Published var selectedModel: LLM = .gpt4_o
    @SwiftCrossUI.Published var showCopiedFeedback: Bool = false
    @SwiftCrossUI.Published var availableModels: [ModelInfo] = []
    @SwiftCrossUI.Published var isLoadingModels: Bool = false
    @SwiftCrossUI.Published var modelLoadError: String?
    
    private let openAIService: OpenAIService
    private let apiKeyStorage: APIKeyStorage
    
    init(openAIService: OpenAIService, apiKeyStorage: APIKeyStorage) {
        self.openAIService = openAIService
        self.apiKeyStorage = apiKeyStorage
    }
    
    // MARK: - Actions
    
    func loadCurrentSettings() {
        apiKey = apiKeyStorage.loadAPIKey() ?? ""
    }
    
    func loadAvailableModels() {
        guard !apiKey.isEmpty else {
            // Use default models if no API key
            availableModels = getDefaultModels()
            return
        }
        
        isLoadingModels = true
        modelLoadError = nil
        
        Task {
            do {
                // Configure the OpenAI service with the current API key
                openAIService.configure(apiKey: apiKey)
                
                // Fetch available models from the API
                let models = try await openAIService.fetchAvailableModels()
                
                await MainActor.run {
                    self.availableModels = convertModelsToModelInfo(models)
                    self.isLoadingModels = false
                }
            } catch {
                await MainActor.run {
                    self.modelLoadError = error.localizedDescription
                    self.isLoadingModels = false
                    // Fallback to default models on error
                    self.availableModels = getDefaultModels()
                }
            }
        }
    }
    
    func saveSettings() {
        if !apiKey.isEmpty {
            apiKeyStorage.saveAPIKey(apiKey)
            openAIService.configure(apiKey: apiKey)
        }
    }
    
    func copyToClipboard(_ text: String) {
        // Note: Clipboard functionality would need to be implemented based on platform
        showCopiedFeedback = true
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            await MainActor.run {
                showCopiedFeedback = false
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func convertModelsToModelInfo(_ models: [LLM]) -> [ModelInfo] {
        return models.map { model in
            let id = LLMUtilities.id(for: model)
            return ModelInfo(
                id: id,
                displayName: LLMUtilities.displayName(for: model),
                description: LLMUtilities.description(for: model),
                model: model
            )
        }
    }
    
    private func getDefaultModels() -> [ModelInfo] {
        return LLMUtilities.defaultModels.map { model in
            ModelInfo(
                id: LLMUtilities.id(for: model),
                displayName: LLMUtilities.displayName(for: model),
                description: LLMUtilities.description(for: model),
                model: model
            )
        }
    }
}
