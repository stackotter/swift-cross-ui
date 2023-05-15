import CGtk

/// Represents the packing location GtkBox children. (See: `GtkVBox`, `GtkHBox`, and `GtkButtonBox`).
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.PackType.html)
public enum PackType {
    /// The child is packed into the start of the box.
    case start
    /// The child is packed into the end of the box.
    case end

    func toGtkPackType() -> GtkPackType {
        switch self {
        case .start:
            return GTK_PACK_START
        case .end:
            return GTK_PACK_END
        }
    }
}

extension GtkPackType {
    func toPackType() -> PackType {
        switch self {
        case GTK_PACK_START:
            return .start
        case GTK_PACK_END:
            return .end
        default:
            fatalError("Unsupported GtkPackType enum value: \(self.rawValue)")
        }
    }
}
