import Foundation

// MARK: - API Key Storage

class APIKeyStorage {
    private let userDefaults = UserDefaults.standard
    private let apiKeyKey = "OpenAI_API_Key"
    
    func saveAPIKey(_ key: String) {
        userDefaults.set(key, forKey: apiKeyKey)
        userDefaults.synchronize() // Force immediate synchronization
        print("🔑 API key saved to disk")
    }
    
    func loadAPIKey() -> String? {
        let key = userDefaults.string(forKey: apiKeyKey)
        if let key = key, !key.isEmpty {
            print("🔑 API key loaded from disk successfully")
            return key
        }
        return nil
    }
    
    func deleteAPIKey() {
        userDefaults.removeObject(forKey: apiKeyKey)
        userDefaults.synchronize() // Force immediate synchronization
        print("🗑️ API key deleted from disk")
    }
}
