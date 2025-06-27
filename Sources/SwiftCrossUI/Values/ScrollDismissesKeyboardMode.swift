/// The ways that scrollable content can interact with the software keyboard.
///
/// Use this type in a call to the ``View/scrollDismissesKeyboard(_:)``
/// modifier to specify the dismissal behavior of scrollable views.
public enum ScrollDismissesKeyboardMode: Sendable {
    /// Determine the mode automatically based on the surrounding context.
    ///
    /// Currently, this behaves the same as ``ScrollDismissesKeyboardMode/interactively``.
    /// In the future, it may adapt dynamically based on the context, similar to how
    /// SwiftUI's `.automatic` works (e.g., using `.interactively` in some views and
    /// `.immediately` in others). Using this value avoids source-breaking changes later on.
    case automatic

    /// Dismiss the keyboard as soon as scrolling starts.
    case immediately

    /// Enable people to interactively dismiss the keyboard as part of the
    /// scroll operation.
    ///
    /// The software keyboard's position tracks the gesture that drives the
    /// scroll operation if the gesture crosses into the keyboard's area of the
    /// display. People can dismiss the keyboard by scrolling it off the
    /// display, or reverse the direction of the scroll to cancel the dismissal.
    case interactively

    /// Never dismiss the keyboard automatically as a result of scrolling.
    case never
}
