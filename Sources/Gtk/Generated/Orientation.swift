import CGtk

/// Represents the orientation of widgets and other objects.
///
/// Typical examples are [class@Box] or [class@GesturePan].
public enum Orientation: GValueRepresentableEnum {
    public typealias GtkEnum = GtkOrientation

    /// The element is in horizontal orientation.
    case horizontal
    /// The element is in vertical orientation.
    case vertical

    /// Converts a Gtk value to its corresponding swift representation.
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

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkOrientation {
        switch self {
            case .horizontal:
                return GTK_ORIENTATION_HORIZONTAL
            case .vertical:
                return GTK_ORIENTATION_VERTICAL
        }
    }
}
