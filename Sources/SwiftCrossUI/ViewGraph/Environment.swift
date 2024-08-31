public struct Environment {
    var onResize: (_ newSize: ViewUpdateResult) -> Void
    var layoutOrientation: Orientation
    var layoutAlignment: StackAlignment
    var layoutSpacing: Int

    init() {
        onResize = { _ in }
        layoutOrientation = .vertical
        layoutAlignment = .center
        layoutSpacing = 10
    }

    func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ newValue: T) -> Self {
        var environment = self
        environment[keyPath: keyPath] = newValue
        return environment
    }
}
