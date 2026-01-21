import Foundation

public protocol AppStorageProvider {
    func persist<Value: Codable>(value: Value, forKey key: String) throws
    func retrieve<Value: Codable>(type: Value.Type, forKey key: String) -> Value?
}

public struct UserDefaultsAppStorageProvider: AppStorageProvider {
    public func persist<Value: Codable>(value: Value, forKey key: String) throws {
        let jsonData = try JSONEncoder().encode(value)
        UserDefaults.standard.setValue(jsonData, forKey: key)

        // NB: The UserDefaults store isn't automatically synced to disk on
        // Linux and Windows.
        // https://github.com/swiftlang/swift-corelibs-foundation/issues/4837
        #if os(Linux) || os(Windows)
            UserDefaults.standard.synchronize()
        #endif
    }

    public func retrieve<Value: Codable>(type _: Value.Type, forKey key: String) -> Value? {
        guard let data = UserDefaults.standard.data(forKey: key),
            let value = try? JSONDecoder().decode(Value.self, from: data)
        else {
            return nil
        }
        return value
    }
}
