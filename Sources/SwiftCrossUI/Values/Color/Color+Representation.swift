extension Color {
    /// The internal representation of a ``Color``.
    ///
    /// This is only `public` so backends can use it; it's not actually
    /// stable API.
    enum Representation: Sendable, Equatable, Hashable {
        /// An RGB color.
        case rgb(red: Float, green: Float, blue: Float)
        /// An adaptive color that uses the same colors on all platforms.
        case scuiAdaptive(Adaptive)
        /// An adaptive color that uses platform-specific colors.
        case systemAdaptive(Adaptive)
    }

    /// An adaptive color.
    public enum Adaptive: Sendable, Equatable, Hashable {
        case blue
        case brown
        case gray
        case green
        case orange
        case purple
        case red
        case yellow
    }
}
