import CGtk

/// Represents the orientation of widgets and other objects which can be switched between horizontal
/// and vertical orientation on the fly, like `GtkToolbar` or `GtkGesturePan`.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.Orientation.html)
public enum Orientation {
    /// The element is in horizontal orientation.
    case horizontal
    /// The element is in vertical orientation.
    case vertical

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
