/// A color, which can be a simple RGBA color or a color that adapts
/// to light/dark and high contrast modes.
public struct Color: Sendable, Equatable, Hashable {
    /// The ideal size of a color view.
    private static let idealSize = ViewSize(10, 10)

    var representation: Representation
    var opacity: Float

    init(representation: Representation, opacity: Float = 1) {
        self.representation = representation
        self.opacity = opacity
    }

    /// Creates a color from its components with values between 0 and 1.
    public init(
        _ red: Float,
        _ green: Float,
        _ blue: Float,
        _ opacity: Float = 1
    ) {
        self.representation = .rgb(red: red, green: green, blue: blue)
        self.opacity = opacity
    }

    /// Multiplies the opacity of the color by the given amount.
    public consuming func opacity(_ opacity: Float) -> Color {
        self.opacity *= opacity
        return self
    }

    /// A pure black color.
    public static let black = Color(0.00, 0.00, 0.00, 1.00)
    /// A pure white color.
    public static let white = Color(1.00, 1.00, 1.00, 1.00)
    /// A completely clear color.
    public static let clear = Color(0.50, 0.50, 0.50, 0.00)

    /// An adaptive blue color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let blue = Color(representation: .scuiAdaptive(.blue))
    /// An adaptive brown color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let brown = Color(representation: .scuiAdaptive(.brown))
    /// An adaptive gray color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let gray = Color(representation: .scuiAdaptive(.gray))
    /// An adaptive green color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let green = Color(representation: .scuiAdaptive(.green))
    /// An adaptive orange color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let orange = Color(representation: .scuiAdaptive(.orange))
    /// An adaptive purple color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let purple = Color(representation: .scuiAdaptive(.purple))
    /// An adaptive red color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let red = Color(representation: .scuiAdaptive(.red))
    /// An adaptive yellow color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let yellow = Color(representation: .scuiAdaptive(.yellow))

    /// Creates an adaptive color tailored for each platform.
    ///
    /// - Parameter color: The color.
    /// - Returns: An adaptive color tailored for each platform.
    public static func system(_ color: Adaptive) -> Color {
        Color(representation: .systemAdaptive(color))
    }

    public init(_ resolved: Color.Resolved) {
        self.representation = .rgb(red: resolved.red, green: resolved.green, blue: resolved.blue)
        self.opacity = resolved.opacity
    }
}

extension Color: ElementaryView {
    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        backend.createColorableRectangle()
    }

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: ProposedViewSize,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        ViewLayoutResult.leafView(
            size: proposedSize.replacingUnspecifiedDimensions(by: Self.idealSize)
        )
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        backend.setSize(of: widget, to: layout.size.vector)
        backend.setColor(ofColorableRectangle: widget, to: self.resolve(in: environment))
    }
}
