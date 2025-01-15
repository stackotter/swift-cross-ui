import Foundation

@propertyWrapper
public struct State<Value>: DynamicProperty, StateProperty {
    class Storage {
        // This inner box is what stays constant between view updates. The
        // outer box (Storage) is used so that we can assign this box to
        // future state instances from the non-mutating
        // `update(with:previousValue:)` method. It's vital that the inner
        // box remains the same so that bindings can be stored across view
        // updates.
        var box: Box<Value>
        var didChange = Publisher()

        init(_ value: Value) {
            self.box = Box(value: value)
        }
    }

    var storage: Storage

    var didChange: Publisher {
        storage.didChange
    }

    public var wrappedValue: Value {
        get {
            storage.box.value
        }
        nonmutating set {
            storage.box.value = newValue
            didChange.send()
        }
    }

    public var projectedValue: Binding<Value> {
        // Specifically link the binding to the inner box instead of the outer
        // storage which changes with each view update.
        let box = storage.box
        return Binding(
            get: {
                box.value
            },
            set: { newValue in
                box.value = newValue
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
            storage.box = previousValue.storage.box
            storage.didChange = previousValue.storage.didChange
        }
    }

    func tryRestoreFromSnapshot(_ snapshot: Data) {
        guard
            let decodable = Value.self as? Codable.Type,
            let state = try? JSONDecoder().decode(decodable, from: snapshot)
        else {
            return
        }

        storage.box.value = state as! Value
    }

    func snapshot() throws -> Data? {
        if let value = storage.box as? Codable {
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
