/// Metadata loaded at app start up.
public struct AppMetadata: Codable {
    /// The app's reverse domain name identifier.
    public var identifier: String
    /// The app's version (generally a semantic version string).
    public var version: String

    public init(identifier: String, version: String) {
        self.identifier = identifier
        self.version = version
    }

    private enum CodingKeys: String, CodingKey {
        case identifier = "appIdentifier"
        case version = "appVersion"
    }
}
