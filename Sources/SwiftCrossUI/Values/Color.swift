/// An RGBA representation of a color.
public struct Color: Sendable, Equatable, Hashable {
    /// The red component (from 0 to 1).
    public var red: Float
    /// The green component (from 0 to 1).
    public var green: Float
    /// The blue component (from 0 to 1).
    public var blue: Float
    /// The alpha component (from 0 to 1).
    public var alpha: Float

    /// Creates a color from its components with values between 0 and 1.
    ///
    /// - Parameters:
    ///   - red: The red component.
    ///   - green: The green component.
    ///   - blue: The blue component.
    ///   - alpha: The alpha component.
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

    /// Multiplies the opacity of the color by the given amount.
    ///
    /// - Parameter opacity: The new opacity of the color, relative to its
    ///   current opacity.
    /// - Returns: A color with the opacity changed.
    public consuming func opacity(_ opacity: Float) -> Color {
        self.alpha *= opacity
        return self
    }

    /// Pure black.
    public static let black = Color(0.00, 0.00, 0.00)
    /// Pure blue.
    public static let blue = Color(0.00, 0.48, 1.00)
    /// Pure brown.
    public static let brown = Color(0.64, 0.52, 0.37)
    /// Completely clear.
    public static let clear = Color(0.50, 0.50, 0.50, 0.00)
    /// Pure cyan.
    public static let cyan = Color(0.33, 0.75, 0.94)
    /// Pure gray.
    public static let gray = Color(0.56, 0.56, 0.58)
    /// Pure green.
    public static let green = Color(0.16, 0.80, 0.25)
    /// Pure indigo.
    public static let indigo = Color(0.35, 0.34, 0.84)
    /// Pure mint.
    public static let mint = Color(0.00, 0.78, 0.75)
    /// Pure orange.
    public static let orange = Color(1.00, 0.58, 0.00)
    /// Pure pink.
    public static let pink = Color(1.00, 0.18, 0.33)
    /// Pure purple.
    public static let purple = Color(0.69, 0.32, 0.87)
    /// Pure red.
    public static let red = Color(1.00, 0.23, 0.19)
    /// Pure teal.
    public static let teal = Color(0.35, 0.68, 0.77)
    /// Pure yellow.
    public static let yellow = Color(1.00, 0.80, 0.00)
    /// Pure white.
    public static let white = Color(1.00, 1.00, 1.00)
}

extension Color: ElementaryView {
    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        backend.createColorableRectangle()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        if !dryRun {
            backend.setSize(of: widget, to: proposedSize)
            backend.setColor(ofColorableRectangle: widget, to: self)
        }
        return ViewUpdateResult.leafView(
            size: ViewSize(
                size: proposedSize,
                idealSize: SIMD2(10, 10),
                minimumWidth: 0,
                minimumHeight: 0,
                maximumWidth: nil,
                maximumHeight: nil
            )
        )
    }
}
