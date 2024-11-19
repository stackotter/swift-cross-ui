import CGtk3

public struct Color: Equatable {
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

    public var gdkColor: GdkRGBA {
        return GdkRGBA(red: red, green: green, blue: blue, alpha: alpha)
    }
}
