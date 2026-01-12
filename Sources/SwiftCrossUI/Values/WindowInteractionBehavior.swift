/// The behavior for a window interaction.
public enum WindowInteractionBehavior: Sendable {
    /// The automatic behavior.
    case automatic
    /// The disabled behavior.
    case disabled
    /// The enabled behavior.
    case enabled

    var isEnabled: Bool {
        switch self {
            case .automatic, .enabled: true
            case .disabled: false
        }
    }
}
