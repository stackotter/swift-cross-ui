import CGtk

/// Describes the way two values can be compared.
///
/// These values can be used with a [callback@GLib.CompareFunc]. However,
/// a `GCompareFunc` is allowed to return any integer values.
/// For converting such a value to a `GtkOrdering` value, use
/// [func@Gtk.Ordering.from_cmpfunc].
public enum Ordering: GValueRepresentableEnum {
    public typealias GtkEnum = GtkOrdering

    /// The first value is smaller than the second
    case smaller
    /// The two values are equal
    case equal
    /// The first value is larger than the second
    case larger

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkOrdering) {
        switch gtkEnum {
            case GTK_ORDERING_SMALLER:
                self = .smaller
            case GTK_ORDERING_EQUAL:
                self = .equal
            case GTK_ORDERING_LARGER:
                self = .larger
            default:
                fatalError("Unsupported GtkOrdering enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkOrdering {
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
