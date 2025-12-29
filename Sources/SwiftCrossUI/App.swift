import Foundation
import Logging

/// The storage behind ``logger``.
///
/// `nil` if the logger hasn't been set yet (which is only the case during
/// ``App/init()``).
///
/// > Safety: This is only accessible from within this file, which does not use
/// > any concurrency features.
nonisolated(unsafe) private var _logger: Logger?

/// The global logger.
///
/// This is safe to use from anywhere in the library, except in
/// `extractSwiftBundlerMetadata()`, since that's called before the logger is
/// initialized. If used from there, this property will crash the app.
var logger: Logger {
    guard let _logger else { fatalError("logger not yet initialized") }
    return _logger
}

/// The logs that were output by `extractSwiftBundlerMetadata()`.
///
/// This is necessary because `extractSwiftBundlerMetadata()` is called before
/// ``logger`` is initialized. The function stores log messages here, and they
/// are all output as soon as the logger is set up.
///
/// > Safety: This is only accessible from within this file, which does not use
/// > any concurrency features.
nonisolated(unsafe) private var extractSwiftBundlerMetadataLogs:
    [(Logger.Message, Logger.Metadata?)] = []

/// An application.
@MainActor
public protocol App {
    /// The backend used to render the app.
    associatedtype Backend: AppBackend
    /// The type of scene representing the content of the app.
    associatedtype Body: Scene

    /// Metadata loaded at app start up.
    ///
    /// By default SwiftCrossUI attempts to load metadata inserted by Swift
    /// Bundler if present. Used by backends' default ``App/backend``
    /// implementations if not `nil`.
    static var metadata: AppMetadata? { get }

    /// The application's backend.
    var backend: Backend { get }

    /// The content of the app.
    @SceneBuilder var body: Body { get }

    /// Creates an instance of the app.
    ///
    /// This initializer is run before anything else, so you can perform early
    /// setup tasks in here, such as [setting the logging backend](doc:Logging).
    init()
}

/// Force refresh the entire scene graph. Used by hot reloading. If you need to do
/// this in your own code then something has gone very wrong...
@MainActor
public var _forceRefresh: () -> Void = {}

/// Metadata embedded by Swift Bundler, if present. Loaded at app start up.
///
/// This will contain the app's metadata, if present, by the time ``App/init()``
/// gets called.
@MainActor
private var swiftBundlerAppMetadata: AppMetadata?

/// An error encountered when parsing Swift Bundler metadata.
private enum SwiftBundlerMetadataError: LocalizedError {
    case jsonNotDictionary(String)
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
    ///
    /// This is accessible from within ``init()``.
    public static var metadata: AppMetadata? {
        swiftBundlerAppMetadata
    }

    /// Runs the application.
    public static func main() {
        swiftBundlerAppMetadata = extractSwiftBundlerMetadata()

        let app = Self()

        // set up the logger _after_ calling App's initializer; that way users
        // can call LoggingSystem.bootstrap in the init
        _logger = Logger(label: "SwiftCrossUI")

        // dump the logs from `extractSwiftBundlerMetadata()`
        for (message, metadata) in extractSwiftBundlerMetadataLogs {
            logger.warning(message, metadata: metadata)
        }

        let _app = _App(app)
        _forceRefresh = {
            app.backend.runInMainThread {
                _app.forceRefresh()
            }
        }
        _app.run()
    }

    private static func extractSwiftBundlerMetadata() -> AppMetadata? {
        // NB: The logger isn't yet set up when this is called (it's initialized
        // after `App.init()` to allow the user to customize the backend). Since
        // errors in this function are important to be able to debug, we store
        // logged messages in `extractSwiftBundlerMetadataLogs` and dump them
        // all as soon as the logger is ready.

        guard let executable = Bundle.main.executableURL else {
            extractSwiftBundlerMetadataLogs.append((
                "no executable url", nil
            ))
            return nil
        }

        guard let data = try? Data(contentsOf: executable) else {
            extractSwiftBundlerMetadataLogs.append((
                "executable failed to read itself (to extract metadata)", nil
            ))
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
                throw SwiftBundlerMetadataError.jsonNotDictionary(String(describing: jsonValue))
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
            extractSwiftBundlerMetadataLogs.append((
                "swift-bundler metadata present but couldn't be parsed",
                ["error": "\(error)"]
            ))
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
