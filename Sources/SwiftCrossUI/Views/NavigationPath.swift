/// A type-erased list of data representing the content of a navigation stack.
public struct NavigationPath {
    internal private(set) var previousPath: [any Hashable]?
    internal private(set) var path: [any Hashable] = [] {
        willSet {
            previousPath = path
        }
    }

    /// A Boolean that indicates whether this path is empty.
    public var isEmpty: Bool {
        path.isEmpty
    }

    /// The number of elements in this path.
    public var count: Int {
        path.count
    }

    public init() {}

    /// Appends a new value to the end of this path.
    public mutating func append<H: Hashable>(_ component: H) {
        path.append(component)
    }

    /// Removes values from the end of this path.
    public mutating func removeLast(_ k: Int = 1) {
        path.removeLast(k)
    }

    /// Removes all values from this path.
    public mutating func removeAll() {
        path.removeAll()
    }
}