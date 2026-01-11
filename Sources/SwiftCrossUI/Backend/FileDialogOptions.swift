import Foundation

/// Options for file dialogs.
public struct FileDialogOptions {
    /// The dialog title.
    public var title: String
    /// The label of the primary button.
    public var defaultButtonLabel: String
    /// The content types allowed by the dialog.
    public var allowedContentTypes: [ContentType]
    /// Whether to show hidden files.
    ///
    /// The definition of "hidden" is platform-specific, but typically involves
    /// a special metadata flag and/or a leading period in the file name.
    public var showHiddenFiles: Bool
    /// Whether to allow selecting items that are not one of the types specified
    /// in ``allowedContentTypes``.
    public var allowOtherContentTypes: Bool
    /// The directory the file dialog starts in. If `nil`, the starting
    /// directory is backend-specific.
    public var initialDirectory: URL?
}
