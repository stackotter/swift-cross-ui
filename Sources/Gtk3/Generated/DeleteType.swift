import CGtk3

/// See also: #GtkEntry::delete-from-cursor.
public enum DeleteType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkDeleteType

    /// Delete characters.
    case chars
    /// Delete only the portion of the word to the
    /// left/right of cursor if we’re in the middle of a word.
    case wordEnds
    /// Delete words.
    case words
    /// Delete display-lines. Display-lines
    /// refers to the visible lines, with respect to to the current line
    /// breaks. As opposed to paragraphs, which are defined by line
    /// breaks in the input.
    case displayLines
    /// Delete only the portion of the
    /// display-line to the left/right of cursor.
    case displayLineEnds
    /// Delete to the end of the
    /// paragraph. Like C-k in Emacs (or its reverse).
    case paragraphEnds
    /// Delete entire line. Like C-k in pico.
    case paragraphs
    /// Delete only whitespace. Like M-\ in Emacs.
    case whitespace

    public static var type: GType {
        gtk_delete_type_get_type()
    }

    public init(from gtkEnum: GtkDeleteType) {
        switch gtkEnum {
            case GTK_DELETE_CHARS:
                self = .chars
            case GTK_DELETE_WORD_ENDS:
                self = .wordEnds
            case GTK_DELETE_WORDS:
                self = .words
            case GTK_DELETE_DISPLAY_LINES:
                self = .displayLines
            case GTK_DELETE_DISPLAY_LINE_ENDS:
                self = .displayLineEnds
            case GTK_DELETE_PARAGRAPH_ENDS:
                self = .paragraphEnds
            case GTK_DELETE_PARAGRAPHS:
                self = .paragraphs
            case GTK_DELETE_WHITESPACE:
                self = .whitespace
            default:
                fatalError("Unsupported GtkDeleteType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkDeleteType {
        switch self {
            case .chars:
                return GTK_DELETE_CHARS
            case .wordEnds:
                return GTK_DELETE_WORD_ENDS
            case .words:
                return GTK_DELETE_WORDS
            case .displayLines:
                return GTK_DELETE_DISPLAY_LINES
            case .displayLineEnds:
                return GTK_DELETE_DISPLAY_LINE_ENDS
            case .paragraphEnds:
                return GTK_DELETE_PARAGRAPH_ENDS
            case .paragraphs:
                return GTK_DELETE_PARAGRAPHS
            case .whitespace:
                return GTK_DELETE_WHITESPACE
        }
    }
}
