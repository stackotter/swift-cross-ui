/// A simple wrapper used to implement internal mutability.
///
/// Mostly used by dynamic property wrappers (see ``DynamicProperty``).
class Box<V> {
    /// The underlying value.
    var value: V

    /// Creates a box with its underlying value.
    ///
    /// - Parameter value: The box's underlying value.
    init(value: V) {
        self.value = value
    }
}
