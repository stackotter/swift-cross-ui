import CGtk3

/// Used to specify the placement of scroll arrows in scrolling menus.
public enum ArrowPlacement: GValueRepresentableEnum {
    public typealias GtkEnum = GtkArrowPlacement

    /// Place one arrow on each end of the menu.
    case both
    /// Place both arrows at the top of the menu.
    case start
    /// Place both arrows at the bottom of the menu.
    case end

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkArrowPlacement) {
        switch gtkEnum {
            case GTK_ARROWS_BOTH:
                self = .both
            case GTK_ARROWS_START:
                self = .start
            case GTK_ARROWS_END:
                self = .end
            default:
                fatalError("Unsupported GtkArrowPlacement enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkArrowPlacement {
        switch self {
            case .both:
                return GTK_ARROWS_BOTH
            case .start:
                return GTK_ARROWS_START
            case .end:
                return GTK_ARROWS_END
        }
    }
}
