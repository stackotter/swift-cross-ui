import CGtk

/// Controls how a content should be made to fit inside an allocation.
public enum ContentFit {
    /// Make the content fill the entire allocation,
    /// without taking its aspect ratio in consideration. The resulting
    /// content will appear as stretched if its aspect ratio is different
    /// from the allocation aspect ratio.
    case fill
    /// Scale the content to fit the allocation,
    /// while taking its aspect ratio in consideration. The resulting
    /// content will appear as letterboxed if its aspect ratio is different
    /// from the allocation aspect ratio.
    case contain
    /// Cover the entire allocation, while taking
    /// the content aspect ratio in consideration. The resulting content
    /// will appear as clipped if its aspect ratio is different from the
    /// allocation aspect ratio.
    case cover
    /// The content is scaled down to fit the
    /// allocation, if needed, otherwise its original size is used.
    case scaleDown

    /// Converts the value to its corresponding Gtk representation.
    func toGtkContentFit() -> GtkContentFit {
        switch self {
            case .fill:
                return GTK_CONTENT_FIT_FILL
            case .contain:
                return GTK_CONTENT_FIT_CONTAIN
            case .cover:
                return GTK_CONTENT_FIT_COVER
            case .scaleDown:
                return GTK_CONTENT_FIT_SCALE_DOWN
        }
    }
}

extension GtkContentFit {
    /// Converts a Gtk value to its corresponding swift representation.
    func toContentFit() -> ContentFit {
        switch self {
            case GTK_CONTENT_FIT_FILL:
                return .fill
            case GTK_CONTENT_FIT_CONTAIN:
                return .contain
            case GTK_CONTENT_FIT_COVER:
                return .cover
            case GTK_CONTENT_FIT_SCALE_DOWN:
                return .scaleDown
            default:
                fatalError("Unsupported GtkContentFit enum value: \(self.rawValue)")
        }
    }
}
