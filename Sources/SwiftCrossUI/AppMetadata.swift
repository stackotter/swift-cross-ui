/// Metadata loaded at app start up.
public struct AppMetadata {
    /// The app's reverse domain name identifier.
    public var identifier: String
    /// The app's version (generally a semantic version string).
    public var version: String
    /// Additional developer-defined metadata.
    public var additionalMetadata: [String: Any]

    public init(
        identifier: String,
        version: String,
        additionalMetadata: [String: Any]
    ) {
        self.identifier = identifier
        self.version = version
        self.additionalMetadata = additionalMetadata
    }
}
