import CGtk

/// Represents the orientation of widgets and other objects.
///
/// Typical examples are [class@Box] or [class@GesturePan].
public enum Orientation {
    /// The element is in horizontal orientation.
    case horizontal
    /// The element is in vertical orientation.
    case vertical

    /// Converts the value to its corresponding Gtk representation.
    func toGtkOrientation() -> GtkOrientation {
        switch self {
            case .horizontal:
                return GTK_ORIENTATION_HORIZONTAL
            case .vertical:
                return GTK_ORIENTATION_VERTICAL
        }
    }
}

extension GtkOrientation {
    /// Converts a Gtk value to its corresponding swift representation.
    func toOrientation() -> Orientation {
        switch self {
            case GTK_ORIENTATION_HORIZONTAL:
                return .horizontal
            case GTK_ORIENTATION_VERTICAL:
                return .vertical
            default:
                fatalError("Unsupported GtkOrientation enum value: \(self.rawValue)")
        }
    }
}
