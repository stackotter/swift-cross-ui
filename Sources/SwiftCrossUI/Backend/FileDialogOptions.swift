import Foundation

public struct FileDialogOptions {
    public var title: String
    public var defaultButtonLabel: String
    public var allowedContentTypes: [ContentType]
    public var showHiddenFiles: Bool
    public var allowOtherContentTypes: Bool
    public var initialDirectory: URL?
}
