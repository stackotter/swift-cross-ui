import Foundation

@propertyWrapper
public struct AppStorage<Value: Codable>: ObservableProperty {
    class Storage {
        var value: Value
        var didChange = Publisher()
        var downstreamObservation: Cancellable?
        var backend: (any AppBackend)?

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

    var storage: Storage
    let defaultValue: Value
    let key: String

    public var didChange: Publisher {
        storage.didChange
    }

    public var wrappedValue: Value {
        get {
            storage.value
        }
        nonmutating set {
            storage.value = newValue
            if let data = try? JSONEncoder().encode(newValue) {
                storage.backend?.persistData(data, forKey: key)
            }

            storage.postSet()
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
            storage.downstreamObservation = didChange.link(toUpstream: defaultValue.didChange)
        } else if let defaultValue = defaultValue as? OptionalObservableObject,
            let innerDidChange = defaultValue.didChange
        {
            // If we have an Optional<some ObservableObject>.some, then observe its
            // inner value's publisher.
            storage.downstreamObservation = didChange.link(toUpstream: innerDidChange)
        }
    }

    public init<T: Codable>(_ key: String) where Value == T? {
        self.init(wrappedValue: nil, key)
    }

    public func update(with environment: EnvironmentValues, previousValue: AppStorage<Value>?) {
        storage.backend = environment.backend

        storage.value =
            if let data = storage.backend!.retrieveData(forKey: key),
               let decoded = try? JSONDecoder().decode(Value.self, from: data)
            {
                decoded
            } else {
                defaultValue
            }
        storage.postSet()
    }

    public func tryRestoreFromSnapshot(_ snapshot: Data) {
        guard let state = try? JSONDecoder().decode(Value.self, from: snapshot) else {
            return
        }
        storage.value = state
    }

    public func snapshot() throws -> Data? {
        try JSONEncoder().encode(storage.value)
    }
}
