/// A type safe CSS property
///
/// For a list of all supported CSS properties, see [Gtk's CSS documentation](https://docs.gtk.org/gtk4/css-properties.html).
public struct CSSProperty: Equatable {
    var stringRepresentation: String {
        "\(key):\(value);"
    }

    public var key: String
    public var value: String

    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    public static func foregroundColor(_ color: Color) -> CSSProperty {
        CSSProperty(key: "color", value: rgba(color))
    }

    public static func backgroundColor(_ color: Color) -> CSSProperty {
        CSSProperty(key: "background", value: rgba(color))
    }

    public static func caretColor(_ color: Color) -> CSSProperty {
        CSSProperty(key: "caret-color", value: rgba(color))
    }

    public static func lineLimit(_ limit: Int) -> CSSProperty {
        CSSProperty(key: "max-lines", value: "\(limit)")
    }

    public static func opacity(_ opacity: Double) -> CSSProperty {
        CSSProperty(key: "opacity", value: "\(opacity)")
    }

    public static func shadow(color: Color, radius: Int, x: Int, y: Int) -> CSSProperty {
        CSSProperty(key: "box-shadow", value: "\(x)px \(y)px \(radius)px \(rgba(color))")
    }

    public static func border(color: Color, width: Int) -> CSSProperty {
        CSSProperty(key: "border", value: "\(width)px solid \(rgba(color))")
    }

    public static func cornerRadius(_ radius: Int) -> CSSProperty {
        CSSProperty(key: "border-radius", value: "\(radius)px")
    }

    public static func scale(_ scale: Double) -> CSSProperty {
        CSSProperty(key: "scale", value: "\(scale)")
    }

    public static func minWidth(_ width: Int) -> CSSProperty {
        CSSProperty(key: "min-width", value: "\(width)px")
    }

    public static func minHeight(_ height: Int) -> CSSProperty {
        CSSProperty(key: "min-height", value: "\(height)px")
    }

    public static func fontSize(_ size: Int) -> CSSProperty {
        CSSProperty(key: "font-size", value: "\(size)px")
    }

    public static func fontWeight(_ weight: Int) -> CSSProperty {
        CSSProperty(key: "font-weight", value: String(weight))
    }

    public static func fontFamily(_ family: String) -> CSSProperty {
        CSSProperty(key: "font-family", value: family)
    }

    public static func rgba(_ color: Color) -> String {
        let red = color.red * 255
        let green = color.green * 255
        let blue = color.blue * 255
        let alpha = color.alpha
        return "rgba(\(red),\(green),\(blue),\(alpha))"
    }
}
