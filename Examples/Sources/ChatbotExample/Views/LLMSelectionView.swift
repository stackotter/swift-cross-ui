import SwiftCrossUI
import OpenAI

// MARK: - Array Extension for Chunking

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// MARK: - Model Selection View

struct LLMSelectionView: View {
    @Binding var selectedModel: LLM
    @SwiftCrossUI.State private var availableModels: [LLM] = [.gpt4_o, .gpt4_o_mini, .gpt4_turbo, .gpt4, .gpt3_5Turbo]
    @SwiftCrossUI.State private var isLoading = false
    @SwiftCrossUI.State private var errorMessage: String?
    
    let openAIService: OpenAIService
    
    init(selectedModel: Binding<LLM>, openAIService: OpenAIService) {
        self._selectedModel = selectedModel
        self.openAIService = openAIService
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack {
                Text("Model:")
                    .font(AppFonts.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                if isLoading {
                    Text("Loading...")
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            if let errorMessage = errorMessage {
                HStack(spacing: AppSpacing.xs) {
                    Text("⚠️")
                    Text(errorMessage)
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.error)
                }
                .padding(AppSpacing.sm)
                .background(AppColors.error.opacity(0.1))
                .cornerRadius(AppCornerRadius.small)
            }
            
            VStack(spacing: AppSpacing.xs) {
                // Simple dynamic model layout
                ForEach(availableModels) { model in
                    LLMButton(
                        title: LLMUtilities.displayName(for: model),
                        model: model,
                        selectedModel: $selectedModel
                    )
                }
            }
            
            Text("Selected: \(LLMUtilities.displayName(for: selectedModel))")
                .font(AppFonts.caption2)
                .foregroundColor(AppColors.textSecondary)
        }
        .surfaceStyle()
        .onAppear {
            loadAvailableModels()
        }
    }
    
    private func loadAvailableModels() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let models = try await openAIService.fetchAvailableModels()
                await MainActor.run {
                    self.availableModels = models.isEmpty ? LLMUtilities.defaultModels : models
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load models"
                    self.isLoading = false
                    // Keep default models on error
                }
            }
        }
    }
}

// MARK: - Model Button

struct LLMButton: View {
    let title: String
    let model: LLM
    @Binding var selectedModel: LLM
    
    var isSelected: Bool {
        selectedModel == model
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack {
                Text(title)
                    .font(AppFonts.subheadline)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.text)
                
                Spacer()
                
                // Cost indicator
                Text(LLMUtilities.costTier(for: model).description)
                    .font(AppFonts.caption2)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(AppColors.surface)
                    .cornerRadius(4)
            }
            
            Text(LLMUtilities.description(for: model))
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textSecondary)
            
            // Capabilities row
            HStack(spacing: AppSpacing.xs) {
                Text("\(LLMUtilities.contextWindow(for: model)/1000)k")
                    .font(AppFonts.caption2)
                    .foregroundColor(AppColors.textSecondary)
                
                if LLMUtilities.hasVisionCapabilities(model) {
                    Text("👁️ Vision")
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Text("✓")
                        .font(AppFonts.subheadline)
                        .foregroundColor(AppColors.primary)
                }
            }
        }
        .padding(AppSpacing.sm)
        .background(isSelected ? AppColors.primary.opacity(0.1) : AppColors.surface)
        .cornerRadius(AppCornerRadius.medium)
        .onTapGesture {
            selectedModel = model
        }
    }
}
