public struct Environment {
    public var onResize: (_ newSize: ViewSize) -> Void
    public var layoutOrientation: Orientation
    public var layoutAlignment: StackAlignment
    public var layoutSpacing: Int
    public var foregroundColor: Color
    public var font: Font
    public var multilineTextAlignment: HorizontalAlignment

    init() {
        onResize = { _ in }
        layoutOrientation = .vertical
        layoutAlignment = .center
        layoutSpacing = 10
        foregroundColor = .black
        font = .system(size: 12)
        multilineTextAlignment = .leading
    }

    public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ newValue: T) -> Self {
        var environment = self
        environment[keyPath: keyPath] = newValue
        return environment
    }
}
