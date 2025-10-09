/// Represents the available detents (heights) for a sheet presentation.
public enum PresentationDetent: Sendable, Hashable {
    /// A detent that represents a medium height sheet.
    case medium

    /// A detent that represents a large (full-height) sheet.
    case large

    /// A detent at a custom fractional height of the available space.
    /// falling back to medium on iOS 15
    /// - Parameter fraction: A value between 0 and 1 representing the fraction of available height.
    case fraction(Double)

    /// A detent at a specific fixed height in pixels.
    /// falling back to medium on iOS 15
    /// - Parameter height: The height
    case height(Double)
}
