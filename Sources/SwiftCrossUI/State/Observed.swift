@propertyWrapper
public class Observed<Value>: PublishedValue {
    public var projectedValue: Binding<Value> {
        Binding(get: {
            self.wrappedValue
        }, set: { newValue in
            self.wrappedValue = newValue
        })
    }

    public var wrappedValue: Value {
        didSet {
            valueDidChange()
        }
    }

    public var publisher = Publisher()

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public func valueDidChange() {
        publisher.send()
    }
}
