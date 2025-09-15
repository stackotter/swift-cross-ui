import CGtk

/// The type of a pad action.
public enum PadActionType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPadActionType

    /// Action is triggered by a pad button
    case button
    /// Action is triggered by a pad ring
    case ring
    /// Action is triggered by a pad strip
    case strip

    public static var type: GType {
        gtk_pad_action_type_get_type()
    }

    public init(from gtkEnum: GtkPadActionType) {
        switch gtkEnum {
            case GTK_PAD_ACTION_BUTTON:
                self = .button
            case GTK_PAD_ACTION_RING:
                self = .ring
            case GTK_PAD_ACTION_STRIP:
                self = .strip
            default:
                fatalError("Unsupported GtkPadActionType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPadActionType {
        switch self {
            case .button:
                return GTK_PAD_ACTION_BUTTON
            case .ring:
                return GTK_PAD_ACTION_RING
            case .strip:
                return GTK_PAD_ACTION_STRIP
        }
    }
}
