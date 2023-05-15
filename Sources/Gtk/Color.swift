import CGtk

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

    public var gdkColor: GdkRGBA {
        return GdkRGBA(red: red, green: green, blue: blue, alpha: alpha)
    }
}
