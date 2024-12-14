/// A content type corresponding to a specific file/data format.
public struct ContentType {
    public static let html = ContentType(
        name: "HTML",
        mimeTypes: ["text/html"],
        fileExtensions: ["html", "htm"]
    )

    public var name: String
    public var mimeTypes: [String]
    public var fileExtensions: [String]

    public init(name: String, mimeTypes: [String], fileExtensions: [String]) {
        self.name = name
        self.mimeTypes = mimeTypes
        self.fileExtensions = fileExtensions
    }
}
