extension Color {
    public struct Resolved: Sendable, Equatable, Hashable, Codable {
        public var red: Float
        public var green: Float
        public var blue: Float
        public var opacity: Float

        public init(
            red: Float,
            green: Float,
            blue: Float,
            opacity: Float = 1.0
        ) {
            self.red = red
            self.green = green
            self.blue = blue
            self.opacity = opacity
        }
    }
}
