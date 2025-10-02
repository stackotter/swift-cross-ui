/// Represents the available detents (heights) for a sheet presentation.
public enum PresentationDetent: Sendable, Hashable {
    /// A detent that represents a medium height sheet.
    case medium

    /// A detent that represents a large (full-height) sheet.
    case large

    /// A detent at a custom fractional height of the available space.
    /// - Parameter fraction: A value between 0 and 1 representing the fraction of available height.
    case fraction(Double)

    /// A detent at a specific fixed height in pixels.
    /// - Parameter height: The height in pixels.
    case height(Int)
}
