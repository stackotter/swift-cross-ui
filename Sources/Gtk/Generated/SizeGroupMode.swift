import CGtk

/// The mode of the size group determines the directions in which the size
/// group affects the requested sizes of its component widgets.
public enum SizeGroupMode: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSizeGroupMode

    /// Group has no effect
    case none
    /// Group affects horizontal requisition
    case horizontal
    /// Group affects vertical requisition
    case vertical
    /// Group affects both horizontal and vertical requisition
    case both

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkSizeGroupMode) {
        switch gtkEnum {
            case GTK_SIZE_GROUP_NONE:
                self = .none
            case GTK_SIZE_GROUP_HORIZONTAL:
                self = .horizontal
            case GTK_SIZE_GROUP_VERTICAL:
                self = .vertical
            case GTK_SIZE_GROUP_BOTH:
                self = .both
            default:
                fatalError("Unsupported GtkSizeGroupMode enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkSizeGroupMode {
        switch self {
            case .none:
                return GTK_SIZE_GROUP_NONE
            case .horizontal:
                return GTK_SIZE_GROUP_HORIZONTAL
            case .vertical:
                return GTK_SIZE_GROUP_VERTICAL
            case .both:
                return GTK_SIZE_GROUP_BOTH
        }
    }
}
