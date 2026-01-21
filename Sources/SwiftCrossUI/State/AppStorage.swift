import Foundation

@propertyWrapper
public struct AppStorage<Value: Codable & Equatable>: ObservableProperty {
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
            let didChange = Publisher()
            var downstreamObservation: Cancellable?
            var backend: (any AppBackend)?

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

    let storage: Storage
    let defaultValue: Value
    let key: String

    public var didChange: Publisher {
        storage.box.didChange
    }

    public var wrappedValue: Value {
        get {
            storage.box.value
        }
        nonmutating set {
            if storage.box.value != newValue, let data = try? JSONEncoder().encode(newValue) {
                storage.box.backend?.persistData(data, forKey: key)
            }

            storage.box.value = newValue
            storage.box.postSet()
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { newValue in wrappedValue = newValue }
        )
    }

    public init(wrappedValue defaultValue: Value, _ key: String) {
        self.key = key
        self.defaultValue = defaultValue
        storage = Storage(defaultValue)

        // Before casting the value we check the type, because casting an optional
        // to protocol Optional doesn't conform to can still succeed when the value
        // is `.some` and the wrapped type conforms to the protocol.
        if Value.self is ObservableObject.Type,
            let defaultValue = defaultValue as? ObservableObject
        {
            storage.box.downstreamObservation = didChange.link(toUpstream: defaultValue.didChange)
        } else if let defaultValue = defaultValue as? OptionalObservableObject,
            let innerDidChange = defaultValue.didChange
        {
            // If we have an Optional<some ObservableObject>.some, then observe its
            // inner value's publisher.
            storage.box.downstreamObservation = didChange.link(toUpstream: innerDidChange)
        }
    }

    public init<T>(_ key: String) where Value == T? {
        self.init(wrappedValue: nil, key)
    }

    public func update(with environment: EnvironmentValues, previousValue: AppStorage<Value>?) {
        if let previousValue {
            storage.box = previousValue.storage.box
        }

        // if we haven't set the backend yet, this is the first update
        if storage.box.backend == nil {
            storage.box.backend = environment.backend

            storage.box.value =
                if let data = storage.box.backend!.retrieveData(forKey: key),
                    let decoded = try? JSONDecoder().decode(Value.self, from: data)
                {
                    decoded
                } else {
                    defaultValue
                }
            storage.box.postSet()
        }
    }

    public func tryRestoreFromSnapshot(_ snapshot: Data) {
        guard let state = try? JSONDecoder().decode(Value.self, from: snapshot) else {
            return
        }
        storage.box.value = state
    }

    public func snapshot() throws -> Data? {
        try JSONEncoder().encode(storage.box.value)
    }
}
