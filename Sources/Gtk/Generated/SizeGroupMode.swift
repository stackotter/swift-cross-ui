import CGtk

/// The mode of the size group determines the directions in which the size
/// group affects the requested sizes of its component widgets.
public enum SizeGroupMode {
    /// Group has no effect
    case none
    /// Group affects horizontal requisition
    case horizontal
    /// Group affects vertical requisition
    case vertical
    /// Group affects both horizontal and vertical requisition
    case both

    /// Converts the value to its corresponding Gtk representation.
    func toGtkSizeGroupMode() -> GtkSizeGroupMode {
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

extension GtkSizeGroupMode {
    /// Converts a Gtk value to its corresponding swift representation.
    func toSizeGroupMode() -> SizeGroupMode {
        switch self {
            case GTK_SIZE_GROUP_NONE:
                return .none
            case GTK_SIZE_GROUP_HORIZONTAL:
                return .horizontal
            case GTK_SIZE_GROUP_VERTICAL:
                return .vertical
            case GTK_SIZE_GROUP_BOTH:
                return .both
            default:
                fatalError("Unsupported GtkSizeGroupMode enum value: \(self.rawValue)")
        }
    }
}
