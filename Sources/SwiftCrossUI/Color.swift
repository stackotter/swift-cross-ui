public struct Color {
    public var red: Double
    public var green: Double
    public var blue: Double
    public var alpha: Double

    public init(
        _ red: Double,
        _ green: Double,
        _ blue: Double,
        _ alpha: Double = 1
    ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public var gtkColor: GtkColor {
        return GtkColor(red, green, blue, alpha)
    }
}
