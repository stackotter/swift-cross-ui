import CGtk

/// [Gtk docs](https://docs.gtk.org/gtk3/enum.MovementStep.html)
public enum MovementStep {
    /// Move forward or back by graphemes.
    case logicalPositions
    /// Move left or right by graphemes.
    case visualPositions
    /// Move forward or back by words.
    case words
    /// Move up or down lines (wrapped lines)
    case displayLines
    /// Move to either end of a line.
    case displayLineEnds
    /// Move up or down paragraphs (newline-ended lines)
    case paragraphs
    /// Move to either end of a paragraph.
    case paragraphEnds
    /// Move by pages.
    case pages
    /// Move to ends of the buffer.
    case bufferEnds
    /// Move horizontally by pages.
    case horizontalPages

    func toGtkMovementStep() -> GtkMovementStep {
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

extension GtkMovementStep {
    func toMovementStep() -> MovementStep {
        switch self {
        case GTK_MOVEMENT_LOGICAL_POSITIONS:
            return .logicalPositions
        case GTK_MOVEMENT_VISUAL_POSITIONS:
            return .visualPositions
        case GTK_MOVEMENT_WORDS:
            return .words
        case GTK_MOVEMENT_DISPLAY_LINES:
            return .displayLines
        case GTK_MOVEMENT_DISPLAY_LINE_ENDS:
            return .displayLineEnds
        case GTK_MOVEMENT_PARAGRAPHS:
            return .paragraphs
        case GTK_MOVEMENT_PARAGRAPH_ENDS:
            return .paragraphEnds
        case GTK_MOVEMENT_PAGES:
            return .pages
        case GTK_MOVEMENT_BUFFER_ENDS:
            return .bufferEnds
        case GTK_MOVEMENT_HORIZONTAL_PAGES:
            return .horizontalPages
        default:
            fatalError("Unsupported GtkMovementStep enum value: \(self.rawValue)")
        }
    }
}
