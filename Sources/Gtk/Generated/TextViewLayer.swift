import CGtk

/// Used to reference the layers of `GtkTextView` for the purpose of customized
/// drawing with the ::snapshot_layer vfunc.
public enum TextViewLayer: GValueRepresentableEnum {
    public typealias GtkEnum = GtkTextViewLayer

    /// The layer rendered below the text (but above the background).
    case belowText
    /// The layer rendered above the text.
    case aboveText

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkTextViewLayer) {
        switch gtkEnum {
            case GTK_TEXT_VIEW_LAYER_BELOW_TEXT:
                self = .belowText
            case GTK_TEXT_VIEW_LAYER_ABOVE_TEXT:
                self = .aboveText
            default:
                fatalError("Unsupported GtkTextViewLayer enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkTextViewLayer {
        switch self {
            case .belowText:
                return GTK_TEXT_VIEW_LAYER_BELOW_TEXT
            case .aboveText:
                return GTK_TEXT_VIEW_LAYER_ABOVE_TEXT
        }
    }
}
