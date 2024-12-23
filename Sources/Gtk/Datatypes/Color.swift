import CGtk

public struct Color: Equatable {
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

    public static func eightBit(
        _ red: UInt8,
        _ green: UInt8,
        _ blue: UInt8,
        _ alpha: UInt8 = 255
    ) -> Color {
        Color(
            Float(red) / 255,
            Float(green) / 255,
            Float(blue) / 255,
            Float(alpha) / 255
        )
    }

    public var gdkColor: GdkRGBA {
        return GdkRGBA(red: red, green: green, blue: blue, alpha: alpha)
    }
}
