import CGtk

/// Granularity types that extend the text selection. Use the `GtkTextView::extend-selection` signal to customize the selection.
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.TextExtendSelection.html)
public enum TextExtendSelection {
    /// Selects the current word. It is triggered by a double-click for example.
    case word
    /// Selects the current line. It is triggered by a triple-click for example.
    case line

    func toGtkTextExtendSelection() -> GtkTextExtendSelection {
        switch self {
        case .word:
            return GTK_TEXT_EXTEND_SELECTION_WORD
        case .line:
            return GTK_TEXT_EXTEND_SELECTION_LINE
        }
    }
}

extension GtkTextExtendSelection {
    func toTextExtendSelection() -> TextExtendSelection {
        switch self {
        case GTK_TEXT_EXTEND_SELECTION_WORD:
            return .word
        case GTK_TEXT_EXTEND_SELECTION_LINE:
            return .line
        default:
            fatalError("Unsupported GtkTextExtendSelection enum value: \(self.rawValue)")
        }
    }
}
