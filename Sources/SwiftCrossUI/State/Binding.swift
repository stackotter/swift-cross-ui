/// A value that can read and write a value owned by a source of truth.
///
/// Can be thought of as a writable reference to the value.
@dynamicMemberLookup
@propertyWrapper
public struct Binding<Value> {
    /// The binding's wrapped value.
    public var wrappedValue: Value {
        get {
            getValue()
        }
        nonmutating set {
            setValue(newValue)
        }
    }

    /// The binding itself.
    public var projectedValue: Binding<Value> {
        // Just a handy helper so that you can use `@Binding` properties like
        // you would `@State` properties.
        self
    }

    /// The stored getter.
    private let getValue: () -> Value
    /// The stored setter.
    private let setValue: (Value) -> Void

    /// Creates a binding with a custom getter and setter.
    ///
    /// To create a binding from a ``State`` property use its projected value
    /// instead: e.g. `$myStateProperty` will give you a binding for reading and
    /// writing `myStateProperty` (assuming that `myStateProperty` is marked
    /// with `@State` at its declaration site).
    ///
    /// - Parameters:
    ///   - get: The binding's getter.
    ///   - set: The binding's setter.
    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.getValue = get
        self.setValue = set
    }

    /// Converts a `Binding<Value?>` into a `Binding<Value>?`, returning `nil`
    /// if the `wrappedValue` of `other` is `nil`.
    ///
    /// - Parameter other: A binding with an optional value.
    /// - Returns: An optional binding with a non-optional value.
    public init?(_ other: Binding<Value?>) {
        if let initialValue = other.wrappedValue {
            self.init(
                get: {
                    other.wrappedValue ?? initialValue
                },
                set: { newValue in
                    other.wrappedValue = newValue
                }
            )
        } else {
            return nil
        }
    }

    /// Projects a property of a binding.
    ///
    /// - Parameter keyPath: A key path from this binding's value type.
    /// - Returns: A binding to the property referenced by `keyPath`.
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> Binding<T> {
        get {
            Binding<T>(
                get: {
                    self.wrappedValue[keyPath: keyPath]
                },
                set: { newValue in
                    self.wrappedValue[keyPath: keyPath] = newValue
                }
            )
        }
    }

    /// Returns a new binding that will perform an action whenever it is used to set
    /// the source of truth's value.
    ///
    /// - Parameter action: The action to perform.
    /// - Returns: A binding that calls `action` with the new value after
    ///   setting it.
    public func onChange(_ action: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding<Value>(
            get: getValue,
            set: { newValue in
                self.setValue(newValue)
                action(newValue)
            }
        )
    }
}
