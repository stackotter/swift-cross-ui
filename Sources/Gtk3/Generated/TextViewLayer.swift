import CGtk3

/// Used to reference the layers of #GtkTextView for the purpose of customized
/// drawing with the ::draw_layer vfunc.
public enum TextViewLayer: GValueRepresentableEnum {
    public typealias GtkEnum = GtkTextViewLayer

    /// Old deprecated layer, use %GTK_TEXT_VIEW_LAYER_BELOW_TEXT instead
    case below
    /// Old deprecated layer, use %GTK_TEXT_VIEW_LAYER_ABOVE_TEXT instead
    case above

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkTextViewLayer) {
        switch gtkEnum {
            case GTK_TEXT_VIEW_LAYER_BELOW:
                self = .below
            case GTK_TEXT_VIEW_LAYER_ABOVE:
                self = .above
            default:
                fatalError("Unsupported GtkTextViewLayer enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkTextViewLayer {
        switch self {
            case .below:
                return GTK_TEXT_VIEW_LAYER_BELOW
            case .above:
                return GTK_TEXT_VIEW_LAYER_ABOVE
        }
    }
}
