import CGtk

/// Describes which edge of a widget a certain feature is positioned at.
///
/// For examples, see the tabs of a [class@Notebook], or the label
/// of a [class@Scale].
public enum PositionType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPositionType

    /// The feature is at the left edge.
    case left
    /// The feature is at the right edge.
    case right
    /// The feature is at the top edge.
    case top
    /// The feature is at the bottom edge.
    case bottom

    public static var type: GType {
        gtk_position_type_get_type()
    }

    public init(from gtkEnum: GtkPositionType) {
        switch gtkEnum {
            case GTK_POS_LEFT:
                self = .left
            case GTK_POS_RIGHT:
                self = .right
            case GTK_POS_TOP:
                self = .top
            case GTK_POS_BOTTOM:
                self = .bottom
            default:
                fatalError("Unsupported GtkPositionType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPositionType {
        switch self {
            case .left:
                return GTK_POS_LEFT
            case .right:
                return GTK_POS_RIGHT
            case .top:
                return GTK_POS_TOP
            case .bottom:
                return GTK_POS_BOTTOM
        }
    }
}
