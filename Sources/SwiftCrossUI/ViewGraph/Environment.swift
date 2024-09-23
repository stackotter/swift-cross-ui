public struct Environment {
    public var onResize: (_ newSize: ViewSize) -> Void
    public var layoutOrientation: Orientation
    public var layoutAlignment: StackAlignment
    public var layoutSpacing: Int
    public var foregroundColor: Color

    init() {
        onResize = { _ in }
        layoutOrientation = .vertical
        layoutAlignment = .center
        layoutSpacing = 10
        foregroundColor = .black
    }

    public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ newValue: T) -> Self {
        var environment = self
        environment[keyPath: keyPath] = newValue
        return environment
    }
}
