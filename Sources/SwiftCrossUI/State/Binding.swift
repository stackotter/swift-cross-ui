/// A value that can read and write a value owned by a source of truth. Can be thought of
/// as a writable reference to the value.
@dynamicMemberLookup
@propertyWrapper
public class Binding<Value> {
    public var wrappedValue: Value {
        get {
            getValue()
        }
        set {
            setValue(newValue)
        }
    }

    /// The stored getter.
    private let getValue: () -> Value
    /// The stored setter.
    private let setValue: (Value) -> Void

    /// Creates a binding with a custom getter and setter. To create a binding from
    /// an `@State` property use its projected value instead: e.g. `$myStateProperty`
    /// will give you a binding for reading and writing `myStateProperty` (assuming that
    /// `myStateProperty` is marked with `@State` at its declaration site).
    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.getValue = get
        self.setValue = set
    }

    /// Projects a property of a binding.
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
