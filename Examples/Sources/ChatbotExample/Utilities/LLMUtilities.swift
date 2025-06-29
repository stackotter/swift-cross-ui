import OpenAI

// MARK: - LLM Utilities

struct LLMUtilities {
    
    // MARK: - Display Names
    
    static func displayName(for model: LLM) -> String {
        switch model {
        case .gpt4_o:
            return "GPT-4o"
        case .gpt4_o_mini:
            return "GPT-4o Mini"
        case .gpt4_turbo:
            return "GPT-4 Turbo"
        case .gpt4:
            return "GPT-4"
        case .gpt3_5Turbo:
            return "GPT-3.5 Turbo"
        default:
            return "Unknown Model"
        }
    }
    
    static func id(for model: LLM) -> String {
        switch model {
        case .gpt4_o:
            return "gpt-4o"
        case .gpt4_o_mini:
            return "gpt-4o-mini"
        case .gpt4_turbo:
            return "gpt-4-turbo"
        case .gpt4:
            return "gpt-4"
        case .gpt3_5Turbo:
            return "gpt-3.5-turbo"
        default:
            return "gpt-3.5-turbo"
        }
    }
    
    static func description(for model: LLM) -> String {
        switch model {
        case .gpt4_o:
            return "Flagship multimodal model with vision capabilities"
        case .gpt4_o_mini:
            return "Fast multimodal model for lightweight tasks"
        case .gpt4_turbo:
            return "Advanced GPT-4 with enhanced capabilities"
        case .gpt4:
            return "Most capable model for complex tasks"
        case .gpt3_5Turbo:
            return "Fast and efficient for most tasks"
        default:
            return "OpenAI chat model"
        }
    }
    
    // MARK: - Model Conversion
    
    static func model(from id: String) -> LLM {
        switch id.lowercased() {
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
            return .gpt3_5Turbo  // Default fallback
        }
    }
    
    // MARK: - Default Models
    
    static let defaultModels: [LLM] = [
        .gpt4_o, .gpt4_o_mini, .gpt4_turbo, .gpt4, .gpt3_5Turbo
    ]
    
    // MARK: - Model Recommendations
    
    static func recommendedModel(for taskType: TaskType) -> LLM {
        switch taskType {
        case .creative:
            return .gpt4_o
        case .analytical:
            return .gpt4
        case .coding:
            return .gpt4_turbo
        case .conversation:
            return .gpt4_o_mini
        case .quickQuestions:
            return .gpt3_5Turbo
        case .multimodal:
            return .gpt4_o
        }
    }
    
    enum TaskType {
        case creative
        case analytical
        case coding
        case conversation
        case quickQuestions
        case multimodal
    }
    
    // MARK: - Model Capabilities
    
    static func hasVisionCapabilities(_ model: LLM) -> Bool {
        switch model {
        case .gpt4_o, .gpt4_o_mini:
            return true
        default:
            return false
        }
    }
    
    static func contextWindow(for model: LLM) -> Int {
        switch model {
        case .gpt4_o, .gpt4_o_mini, .gpt4_turbo:
            return 128_000
        case .gpt4:
            return 8_192
        case .gpt3_5Turbo:
            return 16_385
        default:
            return 8_192
        }
    }
    
    static func costTier(for model: LLM) -> CostTier {
        switch model {
        case .gpt4_o:
            return .premium
        case .gpt4, .gpt4_turbo:
            return .high
        case .gpt4_o_mini:
            return .medium
        case .gpt3_5Turbo:
            return .low
        default:
            return .medium
        }
    }
    
    enum CostTier {
        case low, medium, high, premium
        
        var description: String {
            switch self {
            case .low: return "Most affordable"
            case .medium: return "Balanced cost"
            case .high: return "Higher cost"
            case .premium: return "Premium pricing"
            }
        }
    }
    
    // MARK: - Enhanced Model Information
    
    static func detailedDescription(for model: LLM) -> String {
        let baseDescription = description(for: model)
        let contextSize = contextWindow(for: model)
        let cost = costTier(for: model)
        let hasVision = hasVisionCapabilities(model)
        
        var details = [baseDescription]
        details.append("Context: \(contextSize/1000)k tokens")
        details.append(cost.description)
        if hasVision {
            details.append("Vision capable")
        }
        
        return details.joined(separator: " • ")
    }
    
    // MARK: - Summary
    
    static func getSupportedModelSummary() -> String {
        return """
        Supported Models: 5 core OpenAI models
        • GPT-4o (flagship multimodal)
        • GPT-4o Mini (fast multimodal)
        • GPT-4 Turbo (enhanced capabilities)
        • GPT-4 (most capable)
        • GPT-3.5 Turbo (fast and efficient)
        """
    }
}
