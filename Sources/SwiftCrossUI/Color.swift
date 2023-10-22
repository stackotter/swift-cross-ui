/// An RGBA representation of a color.
public struct Color {
    /// The red component (from 0 to 1).
    public var red: Float
    /// The green component (from 0 to 1).
    public var green: Float
    /// The blue component (from 0 to 1).
    public var blue: Float
    /// The alpha component (from 0 to 1).
    public var alpha: Float

    /// Creates a color from its components with values between 0 and 1.
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

    /// Pure red.
    public static let red = Color(1, 0, 0)
    /// Pure green.
    public static let green = Color(0, 1, 0)
    /// Pure blue.
    public static let blue = Color(0, 0, 1)
    /// Pure magenta.
    public static let magenta = Color(1, 0, 1)
    /// Pure cyan.
    public static let cyan = Color(0, 1, 1)
    /// Pure yellow.
    public static let yellow = Color(1, 1, 0)
    /// Pure white.
    public static let white = Color(1, 1, 1)
    /// Pure black.
    public static let black = Color(0, 0, 0)
}
