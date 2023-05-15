import CGtk

/// The type of message being displayed in the dialog.
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.MessageType.html)
public enum MessageType {
    /// Informational message.
    case info
    /// Non-fatal warning message.
    case warning
    /// Question requiring a choice.
    case question
    /// Fatal error message.
    case error
    /// None of the above.
    case other

    func toGtkMessageType() -> GtkMessageType {
        switch self {
        case .info:
            return GTK_MESSAGE_INFO
        case .warning:
            return GTK_MESSAGE_WARNING
        case .question:
            return GTK_MESSAGE_QUESTION
        case .error:
            return GTK_MESSAGE_ERROR
        case .other:
            return GTK_MESSAGE_OTHER
        }
    }
}

extension GtkMessageType {
    func toMessageType() -> MessageType {
        switch self {
        case GTK_MESSAGE_INFO:
            return .info
        case GTK_MESSAGE_WARNING:
            return .warning
        case GTK_MESSAGE_QUESTION:
            return .question
        case GTK_MESSAGE_ERROR:
            return .error
        case GTK_MESSAGE_OTHER:
            return .other
        default:
            fatalError("Unsupported GtkMessageType enum value: \(self.rawValue)")
        }
    }
}
