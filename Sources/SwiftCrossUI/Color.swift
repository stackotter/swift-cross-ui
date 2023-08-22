public struct Color {
    public var red: Float
    public var green: Float
    public var blue: Float
    public var alpha: Float

    public init(
        _ red: Float,
        _ green: Float,
        _ blue: Float,
        _ alpha: Float = 1
    ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public static let red = Color(1, 0, 0)
    public static let green = Color(0, 1, 0)
    public static let blue = Color(0, 0, 1)
    public static let magenta = Color(1, 0, 1)
    public static let cyan = Color(0, 1, 1)
    public static let yellow = Color(1, 1, 0)
    public static let white = Color(1, 1, 1)
    public static let black = Color(0, 0, 0)
}
