import CGtk

/// Used to reference the layers of `GtkTextView` for the purpose of customized
/// drawing with the ::snapshot_layer vfunc.
public enum TextViewLayer {
    /// The layer rendered below the text (but above the background).
    case belowText
    /// The layer rendered above the text.
    case aboveText

    /// Converts the value to its corresponding Gtk representation.
    func toGtkTextViewLayer() -> GtkTextViewLayer {
        switch self {
            case .belowText:
                return GTK_TEXT_VIEW_LAYER_BELOW_TEXT
            case .aboveText:
                return GTK_TEXT_VIEW_LAYER_ABOVE_TEXT
        }
    }
}

extension GtkTextViewLayer {
    /// Converts a Gtk value to its corresponding swift representation.
    func toTextViewLayer() -> TextViewLayer {
        switch self {
            case GTK_TEXT_VIEW_LAYER_BELOW_TEXT:
                return .belowText
            case GTK_TEXT_VIEW_LAYER_ABOVE_TEXT:
                return .aboveText
            default:
                fatalError("Unsupported GtkTextViewLayer enum value: \(self.rawValue)")
        }
    }
}
