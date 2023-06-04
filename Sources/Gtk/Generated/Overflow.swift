import CGtk

/// Defines how content overflowing a given area should be handled.
///
/// This is used in [method@Gtk.Widget.set_overflow]. The
/// [property@Gtk.Widget:overflow] property is modeled after the
/// CSS overflow property, but implements it only partially.
public enum Overflow {
    /// No change is applied. Content is drawn at the specified
    /// position.
    case visible
    /// Content is clipped to the bounds of the area. Content
    /// outside the area is not drawn and cannot be interacted with.
    case hidden

    /// Converts the value to its corresponding Gtk representation.
    func toGtkOverflow() -> GtkOverflow {
        switch self {
            case .visible:
                return GTK_OVERFLOW_VISIBLE
            case .hidden:
                return GTK_OVERFLOW_HIDDEN
        }
    }
}

extension GtkOverflow {
    /// Converts a Gtk value to its corresponding swift representation.
    func toOverflow() -> Overflow {
        switch self {
            case GTK_OVERFLOW_VISIBLE:
                return .visible
            case GTK_OVERFLOW_HIDDEN:
                return .hidden
            default:
                fatalError("Unsupported GtkOverflow enum value: \(self.rawValue)")
        }
    }
}
