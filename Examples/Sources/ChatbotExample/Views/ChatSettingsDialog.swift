import SwiftCrossUI
import OpenAI

// MARK: - Model Info

struct ModelInfo: Identifiable, Equatable {
    let id: String
    let displayName: String
    let description: String
    let model: LLM
    
    static func == (lhs: ModelInfo, rhs: ModelInfo) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Chat Settings Dialog

struct ChatSettingsDialog: View {
    @Binding var isPresented: Bool
    @Binding var selectedModel: LLM
    @State private var model: ChatSettingsViewModel
    
    let onSave: () -> Void
    
    init(
        isPresented: Binding<Bool>,
        selectedModel: Binding<LLM>,
        openAIService: OpenAIService,
        apiKeyStorage: APIKeyStorage,
        onSave: @escaping () -> Void
    ) {
        self._isPresented = isPresented
        self._selectedModel = selectedModel
        self._model = State(wrappedValue: ChatSettingsViewModel(
            openAIService: openAIService,
            apiKeyStorage: apiKeyStorage
        ))
        self.onSave = onSave
    }
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .onTapGesture {
                    isPresented = false
                }
            
            // Main dialog
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        apiKeySection
                        apiEndpointSection
                        llmSelectionSection
                        temperatureSection
                        maxTokensSection
                    }
                    .padding(24)
                }
                .frame(maxHeight: .infinity)
                
                // Footer buttons - ensure it's always visible
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
                
                footerSection
            }
            .frame(maxWidth: 500, maxHeight: 600)
            .background(Color.white)
            .cornerRadius(16)
            .padding(20)
        }
        .onAppear {
            model.loadCurrentSettings()
            model.loadAvailableModels()
            // Sync with parent's selectedModel
            model.selectedModel = selectedModel
        }
        .onChange(of: model.selectedModel) {
            selectedModel = model.selectedModel
        }
        .onChange(of: selectedModel) {
            model.selectedModel = selectedModel
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Chat Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Configure your AI assistant.")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button("✕") {
                    isPresented = false
                }
                .iconButtonLargeStyle()
            }
            .padding(20)
        }
        .background(Color.blue)
    }
    
    // MARK: - API Key Section
    
    private var apiKeySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("API Key")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                TextField("Enter your API key", text: $model.apiKey)
                    .foregroundColor(.black)
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .onChange(of: model.apiKey) {
                        // Reload models when API key changes
                        if !model.apiKey.isEmpty && model.apiKey.count > 20 { // Basic validation
                            model.loadAvailableModels()
                        }
                    }
                
                Button(model.showCopiedFeedback ? "✓" : "📋") {
                    model.copyToClipboard(model.apiKey)
                }
                .iconButtonStyle()
            }
            
            Text("Your API key is stored locally and never shared.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    // MARK: - API Endpoint Section
    
    private var apiEndpointSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("API Endpoint")
                .font(.headline)
                .fontWeight(.semibold)
            
            TextField("API Endpoint", text: $model.apiEndpoint)
                .foregroundColor(.black)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    // MARK: - LLM Selection Section
    
    private var llmSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Language Model")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if !model.apiKey.isEmpty && !model.isLoadingModels {
                    Button("🔄") {
                        model.loadAvailableModels()
                    }
                    .iconButtonStyle()
                }
            }
            
            // Quick Recommendations Section
            if !model.availableModels.isEmpty || !model.apiKey.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quick Recommendations:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack(spacing: 8) {
                        RecommendationChip(
                            title: "Chat",
                            model: LLMUtilities.recommendedModel(for: .conversation),
                            selectedModel: $model.selectedModel
                        )
                        RecommendationChip(
                            title: "Analysis",
                            model: LLMUtilities.recommendedModel(for: .analytical),
                            selectedModel: $model.selectedModel
                        )
                        RecommendationChip(
                            title: "Creative",
                            model: LLMUtilities.recommendedModel(for: .creative),
                            selectedModel: $model.selectedModel
                        )
                    }
                }
                .padding(.bottom, 8)
            }
            
            if model.isLoadingModels {
                HStack {
                    Text("Loading models...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            } else if let error = model.modelLoadError {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Failed to load models: \(error)")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    Button("Retry") {
                        model.loadAvailableModels()
                    }
                    .font(.caption)
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                }
            } else if model.availableModels.isEmpty {
                VStack(spacing: 8) {
                    // Fallback to default models if API call fails
                    LLMOptionButton(
                        title: "GPT-3.5 Turbo",
                        subtitle: "Fast and efficient",
                        model: .gpt3_5Turbo,
                        selectedModel: $model.selectedModel
                    )
                    
                    LLMOptionButton(
                        title: "GPT-4",
                        subtitle: "Most capable",
                        model: .gpt4,
                        selectedModel: $model.selectedModel
                    )
                    
                    LLMOptionButton(
                        title: "GPT-4 Turbo",
                        subtitle: "Latest and fastest GPT-4",
                        model: .gpt4_turbo,
                        selectedModel: $model.selectedModel
                    )
                }
            } else {
                VStack(spacing: 8) {
                    ForEach(model.availableModels) { modelInfo in
                        DynamicLLMOptionButton(
                            modelInfo: modelInfo,
                            selectedModel: $model.selectedModel
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Temperature Section
    
    private var temperatureSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Temperature")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                HStack {
                    Text("More focused")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f", model.temperature))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.primary)
                        .padding(4)
                    
                    Spacer()
                    
                    Text("More creative")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Temperature slider
                Slider($model.temperature, minimum: 0.0, maximum: 1.0)
            }
        }
    }
    
    // MARK: - Max Tokens Section
    
    private var maxTokensSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Max Tokens")
                .font(.headline)
                .fontWeight(.semibold)
            
            TextField("1000", text: $model.maxTokens)
                .foregroundColor(.black)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    // MARK: - Footer Section
    
    private var footerSection: some View {
        HStack(spacing: 16) {
            Button("❌ ") {
                isPresented = false
            }
            .foregroundColor(.black)
            .secondaryButtonStyle()
            .frame(maxWidth: .infinity)
            
            Button("💾 ") {
                model.saveSettings()
                onSave()
                isPresented = false
            }
            .foregroundColor(.white)
            .secondaryButtonStyle()
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(Color.gray.opacity(0.2))
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Model Option Button

struct LLMOptionButton: View {
    let title: String
    let subtitle: String
    let model: LLM
    @Binding var selectedModel: LLM
    
    var isSelected: Bool {
        selectedModel == model
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(isSelected ? .semibold : .medium)
                        .foregroundColor(isSelected ? AppColors.primary : AppColors.text)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Text("✓")
                        .font(.subheadline)
                        .foregroundColor(AppColors.primary)
                }
            }
            .padding(12)
            .cornerRadius(8)
        }
        .onTapGesture {
            selectedModel = model
        }
    }
}

// MARK: - Dynamic Model Option Button

struct DynamicLLMOptionButton: View {
    let modelInfo: ModelInfo
    @Binding var selectedModel: LLM
    
    var isSelected: Bool {
        selectedModel == modelInfo.model
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(modelInfo.displayName)
                        .font(.subheadline)
                        .fontWeight(isSelected ? .semibold : .medium)
                        .foregroundColor(isSelected ? AppColors.primary : AppColors.text)
                    
                    Text(modelInfo.description)
                        .font(.caption)
                        .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Text("✓")
                        .font(.subheadline)
                        .foregroundColor(AppColors.primary)
                }
            }
            .padding(12)
            .background(isSelected ? AppColors.primary.opacity(0.1) : Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
        .onTapGesture {
            selectedModel = modelInfo.model
        }
    }
}

// MARK: - Recommendation Chip

struct RecommendationChip: View {
    let title: String
    let model: LLM
    @Binding var selectedModel: LLM
    
    var isSelected: Bool {
        selectedModel == model
    }
    
    var body: some View {
        Button(title) {
            selectedModel = model
        }
        .font(AppFonts.caption)
        .fontWeight(.medium)
        .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(isSelected ? AppColors.primary.opacity(0.1) : AppColors.surface)
        .cornerRadius(AppCornerRadius.small)
    }
}
