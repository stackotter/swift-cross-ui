import CGtk

/// Specifies the side of the entry at which an icon is placed.
public enum EntryIconPosition: GValueRepresentableEnum {
    public typealias GtkEnum = GtkEntryIconPosition

    /// At the beginning of the entry (depending on the text direction).
    case primary
    /// At the end of the entry (depending on the text direction).
    case secondary

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkEntryIconPosition) {
        switch gtkEnum {
            case GTK_ENTRY_ICON_PRIMARY:
                self = .primary
            case GTK_ENTRY_ICON_SECONDARY:
                self = .secondary
            default:
                fatalError("Unsupported GtkEntryIconPosition enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkEntryIconPosition {
        switch self {
            case .primary:
                return GTK_ENTRY_ICON_PRIMARY
            case .secondary:
                return GTK_ENTRY_ICON_SECONDARY
        }
    }
}
