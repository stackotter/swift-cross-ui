import CGtk3

/// Represents the orientation of widgets and other objects which can be switched
/// between horizontal and vertical orientation on the fly, like #GtkToolbar or
/// #GtkGesturePan.
public enum Orientation: GValueRepresentableEnum {
    public typealias GtkEnum = GtkOrientation

    /// The element is in horizontal orientation.
    case horizontal
    /// The element is in vertical orientation.
    case vertical

    public static var type: GType {
        gtk_orientation_get_type()
    }

    public init(from gtkEnum: GtkOrientation) {
        switch gtkEnum {
            case GTK_ORIENTATION_HORIZONTAL:
                self = .horizontal
            case GTK_ORIENTATION_VERTICAL:
                self = .vertical
            default:
                fatalError("Unsupported GtkOrientation enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkOrientation {
        switch self {
            case .horizontal:
                return GTK_ORIENTATION_HORIZONTAL
            case .vertical:
                return GTK_ORIENTATION_VERTICAL
        }
    }
}
