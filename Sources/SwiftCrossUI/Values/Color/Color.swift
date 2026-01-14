/// A color, which can be a simple RGBA color or a color that adapts
/// to light/dark and high contrast modes.
public struct Color: Sendable, Equatable, Hashable {
    /// The ideal size of a color view.
    private static let idealSize = ViewSize(10, 10)

    package var representation: Representation
    package var opacity: Float

    package init(representation: Representation, opacity: Float = 1) {
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

    /// An adaptive black color.
    public static let black = Color(representation: .adaptive(.black))
    /// An adaptive blue color.
    public static let blue = Color(representation: .adaptive(.blue))
    /// An adaptive brown color.
    public static let brown = Color(representation: .adaptive(.brown))
    /// A completely clear color.
    public static let clear = Color(0.50, 0.50, 0.50, 0.00)
    /// An adaptive gray color.
    public static let gray = Color(representation: .adaptive(.gray))
    /// An adaptive green color.
    public static let green = Color(representation: .adaptive(.green))
    /// An adaptive orange color.
    public static let orange = Color(representation: .adaptive(.orange))
    /// An adaptive purple color.
    public static let purple = Color(representation: .adaptive(.purple))
    /// An adaptive red color.
    public static let red = Color(representation: .adaptive(.red))
    /// An adaptive yellow color.
    public static let yellow = Color(representation: .adaptive(.yellow))
    /// An adaptive white color.
    public static let white = Color(representation: .adaptive(.white))

    public init(_ resolved: Color.Resolved) {
        self.representation = .rgb(red: resolved.red, green: resolved.green, blue: resolved.blue)
        self.opacity = resolved.opacity
    }

    @MainActor
    public func resolve(in environment: EnvironmentValues) -> Color.Resolved {
        switch representation {
            case .rgb(let red, let green, let blue):
                Color.Resolved(red: red, green: green, blue: blue, opacity: opacity)
            case .adaptive(let adaptive):
                environment.backend.resolveAdaptiveColor(adaptive, in: environment)
        }
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
