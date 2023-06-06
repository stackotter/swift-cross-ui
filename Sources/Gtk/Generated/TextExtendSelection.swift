import CGtk

/// Granularity types that extend the text selection. Use the
/// `GtkTextView::extend-selection` signal to customize the selection.
public enum TextExtendSelection: GValueRepresentableEnum {
    public typealias GtkEnum = GtkTextExtendSelection

    /// Selects the current word. It is triggered by
    /// a double-click for example.
    case word
    /// Selects the current line. It is triggered by
    /// a triple-click for example.
    case line

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkTextExtendSelection) {
        switch gtkEnum {
            case GTK_TEXT_EXTEND_SELECTION_WORD:
                self = .word
            case GTK_TEXT_EXTEND_SELECTION_LINE:
                self = .line
            default:
                fatalError("Unsupported GtkTextExtendSelection enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkTextExtendSelection {
        switch self {
            case .word:
                return GTK_TEXT_EXTEND_SELECTION_WORD
            case .line:
                return GTK_TEXT_EXTEND_SELECTION_LINE
        }
    }
}
