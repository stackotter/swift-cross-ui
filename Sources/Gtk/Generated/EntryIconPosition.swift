import CGtk

/// Specifies the side of the entry at which an icon is placed.
public enum EntryIconPosition {
    /// At the beginning of the entry (depending on the text direction).
    case primary
    /// At the end of the entry (depending on the text direction).
    case secondary

    /// Converts the value to its corresponding Gtk representation.
    func toGtkEntryIconPosition() -> GtkEntryIconPosition {
        switch self {
            case .primary:
                return GTK_ENTRY_ICON_PRIMARY
            case .secondary:
                return GTK_ENTRY_ICON_SECONDARY
        }
    }
}

extension GtkEntryIconPosition {
    /// Converts a Gtk value to its corresponding swift representation.
    func toEntryIconPosition() -> EntryIconPosition {
        switch self {
            case GTK_ENTRY_ICON_PRIMARY:
                return .primary
            case GTK_ENTRY_ICON_SECONDARY:
                return .secondary
            default:
                fatalError("Unsupported GtkEntryIconPosition enum value: \(self.rawValue)")
        }
    }
}
