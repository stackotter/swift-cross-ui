import CGtk3

/// Used to change the appearance of an outline typically provided by a #GtkFrame.
///
/// Note that many themes do not differentiate the appearance of the
/// various shadow types: Either their is no visible shadow (@GTK_SHADOW_NONE),
/// or there is (any other value).
public enum ShadowType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkShadowType

    /// No outline.
    case none
    /// The outline is bevelled inwards.
    case in_
    /// The outline is bevelled outwards like a button.
    case out
    /// The outline has a sunken 3d appearance.
    case etchedIn
    /// The outline has a raised 3d appearance.
    case etchedOut

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkShadowType) {
        switch gtkEnum {
            case GTK_SHADOW_NONE:
                self = .none
            case GTK_SHADOW_IN:
                self = .in_
            case GTK_SHADOW_OUT:
                self = .out
            case GTK_SHADOW_ETCHED_IN:
                self = .etchedIn
            case GTK_SHADOW_ETCHED_OUT:
                self = .etchedOut
            default:
                fatalError("Unsupported GtkShadowType enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkShadowType {
        switch self {
            case .none:
                return GTK_SHADOW_NONE
            case .in_:
                return GTK_SHADOW_IN
            case .out:
                return GTK_SHADOW_OUT
            case .etchedIn:
                return GTK_SHADOW_ETCHED_IN
            case .etchedOut:
                return GTK_SHADOW_ETCHED_OUT
        }
    }
}
