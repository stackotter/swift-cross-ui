import CGtk

/// Represents the packing location of a children in its parent.
///
/// See [class@WindowControls] for example.
public enum PackType {
    /// The child is packed into the start of the widget
    case start
    /// The child is packed into the end of the widget
    case end

    /// Converts the value to its corresponding Gtk representation.
    func toGtkPackType() -> GtkPackType {
        switch self {
            case .start:
                return GTK_PACK_START
            case .end:
                return GTK_PACK_END
        }
    }
}

extension GtkPackType {
    /// Converts a Gtk value to its corresponding swift representation.
    func toPackType() -> PackType {
        switch self {
            case GTK_PACK_START:
                return .start
            case GTK_PACK_END:
                return .end
            default:
                fatalError("Unsupported GtkPackType enum value: \(self.rawValue)")
        }
    }
}
