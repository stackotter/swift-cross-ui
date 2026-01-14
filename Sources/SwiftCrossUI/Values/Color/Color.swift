/// An RGBA representation of a color.
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

    /// Pure black.
    public static let black = Color(representation: .adaptive(.black))
    /// Pure blue.
    public static let blue = Color(representation: .adaptive(.blue))
    /// Pure brown.
    public static let brown = Color(representation: .adaptive(.brown))
    /// Completely clear.
    public static let clear = Color(0.50, 0.50, 0.50, 0.00)
    /// Pure cyan.
    public static let cyan = Color(representation: .adaptive(.cyan))
    /// Pure gray.
    public static let gray = Color(representation: .adaptive(.gray))
    /// Pure green.
    public static let green = Color(representation: .adaptive(.green))
    /// Pure indigo.
    public static let indigo = Color(representation: .adaptive(.indigo))
    /// Pure mint.
    public static let mint = Color(representation: .adaptive(.mint))
    /// Pure orange.
    public static let orange = Color(representation: .adaptive(.orange))
    /// Pure pink.
    public static let pink = Color(representation: .adaptive(.pink))
    /// Pure purple.
    public static let purple = Color(representation: .adaptive(.purple))
    /// Pure red.
    public static let red = Color(representation: .adaptive(.red))
    /// Pure teal.
    public static let teal = Color(representation: .adaptive(.teal))
    /// Pure yellow.
    public static let yellow = Color(representation: .adaptive(.yellow))
    /// Pure white.
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
