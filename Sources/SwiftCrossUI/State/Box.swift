/// A simple wrapper used to implement internal mutability. Mostly used by
/// dynamic property wrappers (see ``DynamicProperty``).
class Box<V> {
    var value: V

    init(_ value: V) {
        self.value = value
    }
}
