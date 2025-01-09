import Foundation

/// An application.
public protocol App {
    /// The backend used to render the app.
    associatedtype Backend: AppBackend
    /// The type of scene representing the content of the app.
    associatedtype Body: Scene

    /// Metadata loaded at app start up. By default SwiftCrossUI attempts
    /// to load metadata inserted by Swift Bundler if present. Used by backends'
    /// default ``App/backend`` implementations if not `nil`.
    static var metadata: AppMetadata? { get }

    /// The application's backend.
    var backend: Backend { get }

    /// The content of the app.
    @SceneBuilder var body: Body { get }

    /// Creates an instance of the app.
    init()
}

/// Force refresh the entire scene graph. Used by hot reloading. If you need to do
/// this in your own code then something has gone very wrong...
public var _forceRefresh: () -> Void = {}

/// Metadata embedded by Swift Bundler if present. Loaded at app start up.
private var swiftBundlerAppMetadata: AppMetadata?

/// An error encountered when parsing Swift Bundler metadata.
private enum SwiftBundlerMetadataError: LocalizedError {
    case jsonNotDictionary(Any)
    case missingAppIdentifier
    case missingAppVersion

    var errorDescription: String? {
        switch self {
            case .jsonNotDictionary:
                "Root metadata JSON value wasn't an object"
            case .missingAppIdentifier:
                "Missing 'appIdentifier' (of type String)"
            case .missingAppVersion:
                "Missing 'appVersion' (of type String)"
        }
    }
}

extension App {
    /// Metadata loaded at app start up.
    public static var metadata: AppMetadata? {
        swiftBundlerAppMetadata
    }

    /// Runs the application.
    public static func main() {
        swiftBundlerAppMetadata = extractSwiftBundlerMetadata()

        let app = Self()
        let _app = _App(app)
        _forceRefresh = {
            app.backend.runInMainThread {
                _app.forceRefresh()
            }
        }
        _app.run()
    }

    private static func extractSwiftBundlerMetadata() -> AppMetadata? {
        guard let executable = Bundle.main.executableURL else {
            print("warning: No executable url")
            return nil
        }

        guard let data = try? Data(contentsOf: executable) else {
            print("warning: Executable failed to read self (to extract metadata)")
            return nil
        }

        // Check if executable has Swift Bundler metadata magic bytes.
        let bytes = Array(data)
        guard bytes.suffix(8) == Array("SBUNMETA".utf8) else {
            return nil
        }

        let lengthStart = bytes.count - 16
        let jsonLength = parseBigEndianUInt64(startingAt: lengthStart, in: bytes)
        let jsonStart = lengthStart - Int(jsonLength)
        let jsonData = Data(bytes[jsonStart..<lengthStart])

        do {
            // Manually parsed due to the `additionalMetadata` field (which would
            // require a lot of boilerplate code to parse with Codable).
            let jsonValue = try JSONSerialization.jsonObject(with: jsonData)
            guard let json = jsonValue as? [String: Any] else {
                throw SwiftBundlerMetadataError.jsonNotDictionary(jsonValue)
            }
            guard let identifier = json["appIdentifier"] as? String else {
                throw SwiftBundlerMetadataError.missingAppIdentifier
            }
            guard let version = json["appVersion"] as? String else {
                throw SwiftBundlerMetadataError.missingAppVersion
            }
            let additionalMetadata =
                json["additionalMetadata"].map { value in
                    value as? [String: Any] ?? [:]
                } ?? [:]
            return AppMetadata(
                identifier: identifier,
                version: version,
                additionalMetadata: additionalMetadata
            )
        } catch {
            print("warning: Swift Bundler metadata present but couldn't be parsed")
            print("  -> \(error)")
            return nil
        }
    }

    private static func parseBigEndianUInt64(
        startingAt startIndex: Int,
        in bytes: [UInt8]
    ) -> UInt64 {
        bytes[startIndex..<(startIndex + 8)].withUnsafeBytes { pointer in
            let bigEndianValue = pointer.assumingMemoryBound(to: UInt64.self)
                .baseAddress!.pointee
            return UInt64(bigEndian: bigEndianValue)
        }
    }
}
