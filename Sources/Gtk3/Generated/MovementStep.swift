import CGtk3

public enum MovementStep: GValueRepresentableEnum {
    public typealias GtkEnum = GtkMovementStep

    /// Move forward or back by graphemes
    case logicalPositions
    /// Move left or right by graphemes
    case visualPositions
    /// Move forward or back by words
    case words
    /// Move up or down lines (wrapped lines)
    case displayLines
    /// Move to either end of a line
    case displayLineEnds
    /// Move up or down paragraphs (newline-ended lines)
    case paragraphs
    /// Move to either end of a paragraph
    case paragraphEnds
    /// Move by pages
    case pages
    /// Move to ends of the buffer
    case bufferEnds
    /// Move horizontally by pages
    case horizontalPages

    public static var type: GType {
        gtk_movement_step_get_type()
    }

    public init(from gtkEnum: GtkMovementStep) {
        switch gtkEnum {
            case GTK_MOVEMENT_LOGICAL_POSITIONS:
                self = .logicalPositions
            case GTK_MOVEMENT_VISUAL_POSITIONS:
                self = .visualPositions
            case GTK_MOVEMENT_WORDS:
                self = .words
            case GTK_MOVEMENT_DISPLAY_LINES:
                self = .displayLines
            case GTK_MOVEMENT_DISPLAY_LINE_ENDS:
                self = .displayLineEnds
            case GTK_MOVEMENT_PARAGRAPHS:
                self = .paragraphs
            case GTK_MOVEMENT_PARAGRAPH_ENDS:
                self = .paragraphEnds
            case GTK_MOVEMENT_PAGES:
                self = .pages
            case GTK_MOVEMENT_BUFFER_ENDS:
                self = .bufferEnds
            case GTK_MOVEMENT_HORIZONTAL_PAGES:
                self = .horizontalPages
            default:
                fatalError("Unsupported GtkMovementStep enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkMovementStep {
        switch self {
            case .logicalPositions:
                return GTK_MOVEMENT_LOGICAL_POSITIONS
            case .visualPositions:
                return GTK_MOVEMENT_VISUAL_POSITIONS
            case .words:
                return GTK_MOVEMENT_WORDS
            case .displayLines:
                return GTK_MOVEMENT_DISPLAY_LINES
            case .displayLineEnds:
                return GTK_MOVEMENT_DISPLAY_LINE_ENDS
            case .paragraphs:
                return GTK_MOVEMENT_PARAGRAPHS
            case .paragraphEnds:
                return GTK_MOVEMENT_PARAGRAPH_ENDS
            case .pages:
                return GTK_MOVEMENT_PAGES
            case .bufferEnds:
                return GTK_MOVEMENT_BUFFER_ENDS
            case .horizontalPages:
                return GTK_MOVEMENT_HORIZONTAL_PAGES
        }
    }
}
