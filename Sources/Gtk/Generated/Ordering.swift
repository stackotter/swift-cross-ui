import CGtk

/// Describes the way two values can be compared.
///
/// These values can be used with a [callback@GLib.CompareFunc]. However,
/// a `GCompareFunc` is allowed to return any integer values.
/// For converting such a value to a `GtkOrdering` value, use
/// [func@Gtk.Ordering.from_cmpfunc].
public enum Ordering {
    /// The first value is smaller than the second
    case smaller
    /// The two values are equal
    case equal
    /// The first value is larger than the second
    case larger

    /// Converts the value to its corresponding Gtk representation.
    func toGtkOrdering() -> GtkOrdering {
        switch self {
            case .smaller:
                return GTK_ORDERING_SMALLER
            case .equal:
                return GTK_ORDERING_EQUAL
            case .larger:
                return GTK_ORDERING_LARGER
        }
    }
}

extension GtkOrdering {
    /// Converts a Gtk value to its corresponding swift representation.
    func toOrdering() -> Ordering {
        switch self {
            case GTK_ORDERING_SMALLER:
                return .smaller
            case GTK_ORDERING_EQUAL:
                return .equal
            case GTK_ORDERING_LARGER:
                return .larger
            default:
                fatalError("Unsupported GtkOrdering enum value: \(self.rawValue)")
        }
    }
}
