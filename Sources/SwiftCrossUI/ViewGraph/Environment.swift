public struct Environment {
    public var onResize: (_ newSize: ViewSize) -> Void
    public var layoutOrientation: Orientation
    public var layoutAlignment: StackAlignment
    public var layoutSpacing: Int
    public var font: Font
    public var multilineTextAlignment: HorizontalAlignment

    /// The current color scheme of the current view scope.
    public var colorScheme: ColorScheme
    /// The foreground color. `nil` means that the default foreground color of
    /// the current color scheme should be used.
    public var foregroundColor: Color?

    /// The suggested foreground color for backends to use. Backends don't
    /// neccessarily have to obey this when ``Environment/foregroundColor``
    /// is `nil`.
    public var suggestedForegroundColor: Color {
        foregroundColor ?? colorScheme.defaultForegroundColor
    }

    /// The backend's representation of the window that the current view is
    /// in, if any. This is a very internal detail that should never get
    /// exposed to users.
    var window: Any?

    init() {
        onResize = { _ in }
        layoutOrientation = .vertical
        layoutAlignment = .center
        layoutSpacing = 10
        foregroundColor = nil
        font = .system(size: 12)
        multilineTextAlignment = .leading
        colorScheme = .light
        window = nil
    }

    public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ newValue: T) -> Self {
        var environment = self
        environment[keyPath: keyPath] = newValue
        return environment
    }
}
