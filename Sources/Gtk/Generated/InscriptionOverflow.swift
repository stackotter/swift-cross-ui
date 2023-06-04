import CGtk

/// The different methods to handle text in #GtkInscription when it doesn't
/// fit the available space.
public enum InscriptionOverflow {
    /// Clip the remaining text
    case clip
    /// Omit characters at the start of the text
    case ellipsizeStart
    /// Omit characters at the middle of the text
    case ellipsizeMiddle
    /// Omit characters at the end of the text
    case ellipsizeEnd

    /// Converts the value to its corresponding Gtk representation.
    func toGtkInscriptionOverflow() -> GtkInscriptionOverflow {
        switch self {
            case .clip:
                return GTK_INSCRIPTION_OVERFLOW_CLIP
            case .ellipsizeStart:
                return GTK_INSCRIPTION_OVERFLOW_ELLIPSIZE_START
            case .ellipsizeMiddle:
                return GTK_INSCRIPTION_OVERFLOW_ELLIPSIZE_MIDDLE
            case .ellipsizeEnd:
                return GTK_INSCRIPTION_OVERFLOW_ELLIPSIZE_END
        }
    }
}

extension GtkInscriptionOverflow {
    /// Converts a Gtk value to its corresponding swift representation.
    func toInscriptionOverflow() -> InscriptionOverflow {
        switch self {
            case GTK_INSCRIPTION_OVERFLOW_CLIP:
                return .clip
            case GTK_INSCRIPTION_OVERFLOW_ELLIPSIZE_START:
                return .ellipsizeStart
            case GTK_INSCRIPTION_OVERFLOW_ELLIPSIZE_MIDDLE:
                return .ellipsizeMiddle
            case GTK_INSCRIPTION_OVERFLOW_ELLIPSIZE_END:
                return .ellipsizeEnd
            default:
                fatalError("Unsupported GtkInscriptionOverflow enum value: \(self.rawValue)")
        }
    }
}
