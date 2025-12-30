import Foundation

// TODO: Document State properly, this is an important type.
// - It supports value types
// - It supports ObservableObject
// - It supports Optional<ObservableObject>

/// A property wrapper that acts as a source of truth for view state.
@propertyWrapper
public struct State<Value>: DynamicProperty, StateProperty {
    class Storage {
        // This inner box is what stays constant between view updates. The
        // outer box (Storage) is used so that we can assign this box to
        // future state instances from the non-mutating
        // `update(with:previousValue:)` method. It's vital that the inner
        // box remains the same so that bindings can be stored across view
        // updates.
        var box: InnerBox

        class InnerBox {
            var value: Value
            var didChange = Publisher()
            var downstreamObservation: Cancellable?

            init(value: Value) {
                self.value = value
            }

            /// Call this to publish an observation to all observers after
            /// setting a new value. This isn't in a didSet property accessor
            /// because we want more granular control over when it does and
            /// doesn't trigger.
            ///
            /// Additionally updates the downstream observation if the
            /// wrapped value is an Optional<some ObservableObject> and the
            /// current case has toggled.
            func postSet() {
                // If the wrapped value is an Optional<some ObservableObject>
                // then we need to observe/unobserve whenever the optional
                // toggles between `.some` and `.none`.
                if let value = value as? OptionalObservableObject {
                    if let innerDidChange = value.didChange, downstreamObservation == nil {
                        downstreamObservation = didChange.link(toUpstream: innerDidChange)
                    } else if value.didChange == nil, let observation = downstreamObservation {
                        observation.cancel()
                        downstreamObservation = nil
                    }
                }
                didChange.send()
            }
        }

        init(_ value: Value) {
            self.box = InnerBox(value: value)
        }
    }

    var storage: Storage

    var didChange: Publisher {
        storage.box.didChange
    }

    public var wrappedValue: Value {
        get {
            storage.box.value
        }
        nonmutating set {
            storage.box.value = newValue
            storage.box.postSet()
        }
    }

    /// Returns a ``Binding`` to this state.
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
                box.postSet()
            }
        )
    }

    /// Creates a `State` given an initial value.
    ///
    /// - Parameter initialValue: The state's initial value.
    public init(wrappedValue initialValue: Value) {
        storage = Storage(initialValue)

        // Before casting the value we check the type, because casting an optional
        // to protocol Optional doesn't conform to can still succeed when the value
        // is `.some` and the wrapped type conforms to the protocol.
        if Value.self as? ObservableObject.Type != nil,
            let initialValue = initialValue as? ObservableObject
        {
            storage.box.downstreamObservation = didChange.link(toUpstream: initialValue.didChange)
        } else if let initialValue = initialValue as? OptionalObservableObject,
            let innerDidChange = initialValue.didChange
        {
            // If we have an Optional<some ObservableObject>.some, then observe its
            // inner value's publisher.
            storage.box.downstreamObservation = didChange.link(toUpstream: innerDidChange)
        }
    }

    public func update(with environment: EnvironmentValues, previousValue: State<Value>?) {
        if let previousValue {
            storage.box = previousValue.storage.box
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
