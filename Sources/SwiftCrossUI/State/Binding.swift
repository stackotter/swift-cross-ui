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
    
    private let getValue: () -> Value
    private let setValue: (Value) -> Void
    
    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.getValue = get
        self.setValue = set
    }
}
