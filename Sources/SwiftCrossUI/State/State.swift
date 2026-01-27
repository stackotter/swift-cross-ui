import Foundation

// TODO: Document State properly, this is an important type.
// - It supports value types
// - It supports ObservableObject
// - It supports Optional<ObservableObject>
@propertyWrapper
public struct State<Value>: SnapshottableProperty {
    private final class Storage {
        var value: Value
        var didChange = Publisher()
        var downstreamObservation: Cancellable?

        init(_ value: Value) {
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

    /// The inner `Storage` is what stays constant between view updates.
    /// The wrapping box is used so that we can assign the storage to future
    /// state instances from the non-mutating ``update(with:previousValue:)``
    /// method. It's vital that the inner storage remains the same so that
    /// bindings can be stored across view updates.
    private let box: Box<Storage>

    public var didChange: Publisher {
        box.value.didChange
    }

    public var wrappedValue: Value {
        get {
            box.value.value
        }
        nonmutating set {
            box.value.value = newValue
            box.value.postSet()
        }
    }

    public var projectedValue: Binding<Value> {
        // Specifically link the binding to the inner box instead of the outer
        // storage which changes with each view update.
        let storage = box.value
        return Binding(
            get: {
                storage.value
            },
            set: { newValue in
                storage.value = newValue
                storage.postSet()
            }
        )
    }

    public init(wrappedValue initialValue: Value) {
        box = Box(Storage(initialValue))

        // Before casting the value we check the type, because casting an optional
        // to protocol Optional doesn't conform to can still succeed when the value
        // is `.some` and the wrapped type conforms to the protocol.
        if Value.self as? ObservableObject.Type != nil,
            let initialValue = initialValue as? ObservableObject
        {
            box.value.downstreamObservation = didChange.link(toUpstream: initialValue.didChange)
        } else if let initialValue = initialValue as? OptionalObservableObject,
            let innerDidChange = initialValue.didChange
        {
            // If we have an Optional<some ObservableObject>.some, then observe its
            // inner value's publisher.
            box.value.downstreamObservation = didChange.link(toUpstream: innerDidChange)
        }
    }

    public func update(with environment: EnvironmentValues, previousValue: State<Value>?) {
        if let previousValue {
            box.value = previousValue.box.value
        }
    }

    public func tryRestoreFromSnapshot(_ snapshot: Data) {
        guard
            let decodable = Value.self as? Codable.Type,
            let state = try? JSONDecoder().decode(decodable, from: snapshot)
        else {
            return
        }

        box.value.value = state as! Value
    }

    public func snapshot() throws -> Data? {
        if let value = box.value.value as? Codable {
            return try JSONEncoder().encode(value)
        } else {
            return nil
        }
    }
}
