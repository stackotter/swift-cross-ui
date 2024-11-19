import CGtk3

/// Indicated the relief to be drawn around a #GtkButton.
public enum ReliefStyle: GValueRepresentableEnum {
    public typealias GtkEnum = GtkReliefStyle

    /// Draw a normal relief.
    case normal
    /// A half relief. Deprecated in 3.14, does the same as @GTK_RELIEF_NORMAL
    case half
    /// No relief.
    case none

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkReliefStyle) {
        switch gtkEnum {
            case GTK_RELIEF_NORMAL:
                self = .normal
            case GTK_RELIEF_HALF:
                self = .half
            case GTK_RELIEF_NONE:
                self = .none
            default:
                fatalError("Unsupported GtkReliefStyle enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkReliefStyle {
        switch self {
            case .normal:
                return GTK_RELIEF_NORMAL
            case .half:
                return GTK_RELIEF_HALF
            case .none:
                return GTK_RELIEF_NONE
        }
    }
}
