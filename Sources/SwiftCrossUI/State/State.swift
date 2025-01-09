import Foundation

@propertyWrapper
public struct State<Value>: DynamicProperty, StateProperty {
    class Storage {
        var value: Value
        var didChange = Publisher()

        init(_ value: Value) {
            self.value = value
        }
    }

    var storage: Storage

    var didChange: Publisher {
        storage.didChange
    }

    public var wrappedValue: Value {
        get {
            storage.value
        }
        nonmutating set {
            storage.value = newValue
            didChange.send()
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: {
                storage.value
            },
            set: { newValue in
                storage.value = newValue
                didChange.send()
            }
        )
    }

    public init(wrappedValue initialValue: Value) {
        storage = Storage(initialValue)

        if let initialValue = initialValue as? ObservableObject {
            _ = didChange.link(toUpstream: initialValue.didChange)
        }
    }

    public func update(with environment: EnvironmentValues, previousValue: State<Value>?) {
        if let previousValue {
            storage.value = previousValue.storage.value
            storage.didChange = previousValue.didChange
        }
    }

    func tryRestoreFromSnapshot(_ snapshot: Data) {
        guard
            let decodable = Value.self as? Codable.Type,
            let state = try? JSONDecoder().decode(decodable, from: snapshot)
        else {
            return
        }

        storage.value = state as! Value
    }

    func snapshot() throws -> Data? {
        if let value = storage.value as? Codable {
            return try JSONEncoder().encode(value)
        } else {
            return nil
        }
    }
}

protocol StateProperty {
    var didChange: Publisher { get }
    func tryRestoreFromSnapshot(_ snapshot: Data)
    func snapshot() throws -> Data?
}
