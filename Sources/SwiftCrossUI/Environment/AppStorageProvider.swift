import Foundation

/// A type that can be used to persist ``AppStorage`` values to disk.
public protocol AppStorageProvider: Sendable {
    /// Persists the given value.
    ///
    /// - Parameters:
    ///   - value: The value to persist.
    ///   - key: The key to assign the value to.
    func persist<Value: Codable>(value: Value, forKey key: String) throws
    /// Retrieves the value for the given key.
    ///
    /// - Parameters:
    ///   - type: The type that you expect the value to be.
    ///   - key: The key to retrieve the value from.
    /// - Returns: The persisted value for `key`, if it exists and is of the
    ///   expected type; otherwise, `nil`.
    func retrieve<Value: Codable>(type: Value.Type, forKey key: String) -> Value?
}

/// A simple app storage provider that uses `UserDefaults` to persist
/// data.
///
/// This works on all supported platforms.
public struct UserDefaultsAppStorageProvider: AppStorageProvider {
    public func persist<Value: Codable>(value: Value, forKey key: String) throws {
        let jsonData = try JSONEncoder().encode(value)
        let jsonString = String.init(data: jsonData, encoding: .utf8)
        UserDefaults.standard.setValue(jsonString, forKey: key)

        // NB: The UserDefaults store isn't automatically synced to disk on
        // Linux and Windows.
        // https://github.com/swiftlang/swift-corelibs-foundation/issues/4837
        #if os(Linux) || os(Windows)
            UserDefaults.standard.synchronize()
        #endif
    }

    public func retrieve<Value: Codable>(type _: Value.Type, forKey key: String) -> Value? {
        guard let string = UserDefaults.standard.string(forKey: key),
            let data = string.data(using: .utf8),
            let value = try? JSONDecoder().decode(Value.self, from: data)
        else {
            return nil
        }
        return value
    }
}
