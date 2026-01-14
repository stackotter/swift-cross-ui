extension Color {
    /// The internal representation of a ``Color``.
    ///
    /// This is only `public` so backends can use it; it's not actually
    /// stable API.
    public enum Representation: Sendable, Equatable, Hashable {
        case rgb(red: Float, green: Float, blue: Float)
        case adaptive(Adaptive)

        public enum Adaptive: Sendable, Equatable, Hashable {
            case black
            case blue
            case brown
            case gray
            case green
            case orange
            case purple
            case red
            case yellow
            case white
        }
    }
}
