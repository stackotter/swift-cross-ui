import Foundation

// MARK: - Error Types

enum ChatError: Error, LocalizedError {
    case missingAPIKey
    case invalidURL
    case encodingError
    case decodingError
    case invalidResponse
    case apiError(Int)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Please enter your OpenAI API key"
        case .invalidURL:
            return "Invalid URL"
        case .encodingError:
            return "Failed to encode request"
        case .decodingError:
            return "Failed to decode response"
        case .invalidResponse:
            return "Invalid response from server"
        case .apiError(let code):
            switch code {
            case 401:
                return "API Error 401: Invalid API key. Please check your OpenAI API key and make sure it's valid and has sufficient credits."
            case 429:
                return "API Error 429: Rate limit exceeded. Please wait a moment and try again."
            case 500, 502, 503:
                return "API Error \(code): OpenAI server error. Please try again later."
            default:
                return "API error: \(code)"
            }
        }
    }
}
