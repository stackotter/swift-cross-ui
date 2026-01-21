import Foundation

private nonisolated(unsafe) var appStorageCache: [String: any Codable] = [:]

@propertyWrapper
public struct AppStorage<Value: Codable>: ObservableProperty {
    class Storage {
        // This inner box is what stays constant between view updates. The
        // outer box (Storage) is used so that we can assign this box to
        // future state instances from the non-mutating
        // `update(with:previousValue:)` method. It's vital that the inner
        // box remains the same so that bindings can be stored across view
        // updates.
        var box: InnerBox

        class InnerBox {
            let key: String
            let defaultValue: Value
            let didChange = Publisher()
            var downstreamObservation: Cancellable?
            var provider: (any AppStorageProvider)?

            init(key: String, defaultValue: Value) {
                self.key = key
                self.defaultValue = defaultValue
            }

            var value: Value {
                get {
                    // If this is the very first time we're reading from this key, it won't
                    // be in the cache yet. In that case, we return the already-persisted value
                    // if it exists, or the default value otherwise; either way, we add it to the
                    // cache so subsequent accesses of `value` won't have to read from disk again.
                    guard let cachedValue = appStorageCache[key] else {
                        let value =
                            provider?.retrieve(type: Value.self, forKey: key) ?? defaultValue
                        appStorageCache[key] = value
                        return value
                    }

                    // Make sure that we have the right type.
                    guard let cachedValue = cachedValue as? Value else {
                        logger.warning(
                            "'@AppStorage' property is of the wrong type; using default value",
                            metadata: [
                                "key": "\(key)",
                                "providedType": "\(Value.self)",
                                "actualType": "\(type(of: cachedValue))",
                            ]
                        )
                        return defaultValue
                    }

                    return cachedValue
                }

                set {
                    appStorageCache[key] = newValue
                    do {
                        try provider?.persist(value: newValue, forKey: key)
                    } catch {
                        logger.warning(
                            "failed to encode '@AppStorage' data",
                            metadata: [
                                "value": "\(newValue)",
                                "error": "\(error)",
                            ]
                        )
                    }
                }
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

        init(key: String, defaultValue: Value) {
            self.box = InnerBox(key: key, defaultValue: defaultValue)
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
        storage = Storage(key: key, defaultValue: defaultValue)

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
        storage.box.provider = environment.appStorageProvider
    }
}
