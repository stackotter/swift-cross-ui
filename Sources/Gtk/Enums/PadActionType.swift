import CGtk

/// The type of a pad action.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.PadActionType.html)
public enum PadActionType {
    /// Action is triggered by a pad button.
    case button
    /// Action is triggered by a pad ring.
    case ring
    /// Action is triggered by a pad strip.
    case strip

    func toGtkPadActionType() -> GtkPadActionType {
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

extension GtkPadActionType {
    func toPadActionType() -> PadActionType {
        switch self {
            case GTK_PAD_ACTION_BUTTON:
                return .button
            case GTK_PAD_ACTION_RING:
                return .ring
            case GTK_PAD_ACTION_STRIP:
                return .strip
            default:
                fatalError("Unsupported GtkPadActionType enum value: \(self.rawValue)")
        }
    }
}
