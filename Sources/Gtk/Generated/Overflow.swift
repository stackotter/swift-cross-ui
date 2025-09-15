import CGtk

/// Defines how content overflowing a given area should be handled.
///
/// This is used in [method@Gtk.Widget.set_overflow]. The
/// [property@Gtk.Widget:overflow] property is modeled after the
/// CSS overflow property, but implements it only partially.
public enum Overflow: GValueRepresentableEnum {
    public typealias GtkEnum = GtkOverflow

    /// No change is applied. Content is drawn at the specified
    /// position.
    case visible
    /// Content is clipped to the bounds of the area. Content
    /// outside the area is not drawn and cannot be interacted with.
    case hidden

    public static var type: GType {
        gtk_overflow_get_type()
    }

    public init(from gtkEnum: GtkOverflow) {
        switch gtkEnum {
            case GTK_OVERFLOW_VISIBLE:
                self = .visible
            case GTK_OVERFLOW_HIDDEN:
                self = .hidden
            default:
                fatalError("Unsupported GtkOverflow enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkOverflow {
        switch self {
            case .visible:
                return GTK_OVERFLOW_VISIBLE
            case .hidden:
                return GTK_OVERFLOW_HIDDEN
        }
    }
}
