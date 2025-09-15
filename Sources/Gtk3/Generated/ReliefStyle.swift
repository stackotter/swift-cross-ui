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

    public static var type: GType {
        gtk_relief_style_get_type()
    }

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
