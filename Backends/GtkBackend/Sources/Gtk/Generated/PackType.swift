import CGtk

/// Represents the packing location of a children in its parent.
///
/// See [class@WindowControls] for example.
public enum PackType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPackType

    /// The child is packed into the start of the widget
    case start
    /// The child is packed into the end of the widget
    case end

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkPackType) {
        switch gtkEnum {
            case GTK_PACK_START:
                self = .start
            case GTK_PACK_END:
                self = .end
            default:
                fatalError("Unsupported GtkPackType enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkPackType {
        switch self {
            case .start:
                return GTK_PACK_START
            case .end:
                return GTK_PACK_END
        }
    }
}
