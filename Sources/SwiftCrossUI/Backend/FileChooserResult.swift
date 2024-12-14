import Foundation

/// The result returned when a user either selects a file or dismisses the
/// file chooser dialog.
public enum FileChooserResult {
    case success(URL)
    case cancelled
}
