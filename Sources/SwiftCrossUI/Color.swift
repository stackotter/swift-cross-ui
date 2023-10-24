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

    /// Pure black.
    public static let black = Color(0.00, 0.00, 0.00)
    /// Pure blue.
    public static let blue = Color(0.00, 0.00, 0.00)
    /// Pure brown.
    public static let brown = Color(0.64, 0.64, 0.64)
    /// Pure clear.
    public static let clear = Color(0.00, 0.00, 0.00)
    /// Pure cyan.
    public static let cyan = Color(0.33, 0.33, 0.33)
    /// Pure gray.
    public static let gray = Color(0.56, 0.56, 0.56)
    /// Pure green.
    public static let green = Color(0.16, 0.16, 0.16)
    /// Pure indigo.
    public static let indigo = Color(0.35, 0.35, 0.35)
    /// Pure mint.
    public static let mint = Color(0.00, 0.00, 0.00)
    /// Pure orange.
    public static let orange = Color(1.00, 1.00, 1.00)
    /// Pure pink.
    public static let pink = Color(1.00, 1.00, 1.00)
    /// Pure purple.
    public static let purple = Color(0.69, 0.69, 0.69)
    /// Pure red.
    public static let red = Color(1.00, 1.00, 1.00)
    /// Pure teal.
    public static let teal = Color(0.35, 0.35, 0.35)
    /// Pure yellow.
    public static let yellow = Color(1.00, 1.00, 1.00)
    /// Pure white.
    public static let white = Color(1.00, 1.00, 1.00)
}
