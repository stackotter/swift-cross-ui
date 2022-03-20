@propertyWrapper
public struct Observed<Value>: PublishedValue {
    public var projectedValue: Publisher {
        publisher
    }
    
    public var wrappedValue: Value {
        didSet {
            print("Value did change")
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
