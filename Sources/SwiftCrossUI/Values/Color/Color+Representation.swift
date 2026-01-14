extension Color {
    public enum Representation: Sendable, Equatable, Hashable {
        case rgb(red: Float, green: Float, blue: Float)
        case adaptive(Adaptive)

        public enum Adaptive: Sendable, Equatable, Hashable {
            case black
            case blue
            case brown
            case cyan
            case gray
            case green
            case indigo
            case mint
            case orange
            case pink
            case purple
            case red
            case teal
            case yellow
            case white
        }
    }
}
