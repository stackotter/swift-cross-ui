import Dispatch
import Foundation

// FIXME: Make this concurrency-safe
private nonisolated(unsafe) var appStorageCache: [String: any Codable] = [:]

/// The debounce timeout for persisting to disk, in seconds.
private let persistDebounceTimeout: Double = 0.5

@propertyWrapper
public struct AppStorage<Value: Codable>: ObservableProperty {
    private final class Storage {
        let key: String
        let defaultValue: Value
        let didChange = Publisher()
        var downstreamObservation: Cancellable?
        var provider: (any AppStorageProvider)?
        var persistWorkItem: DispatchWorkItem?

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

                // In order to avoid writing to disk on every update, we perform some basic
                // debouncing. We schedule a `DispatchWorkItem` to be executed
                // `persistDebounceTimeout` seconds from now; if this setter is called again
                // before that happens, the work item is cancelled and a new one is scheduled.
                // This means changes will only be persisted if no updates occur for at least
                // `persistDebounceTimeout` seconds.
                persistWorkItem?.cancel()
                let workItem = DispatchWorkItem { [weak self] in
                    guard let self else { return }
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

                persistWorkItem = workItem
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + persistDebounceTimeout,
                    execute: workItem
                )
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
    
    /// The inner `Storage` is what stays constant between view updates.
    /// The wrapping box is used so that we can assign the storage to future
    /// state instances from the non-mutating ``update(with:previousValue:)``
    /// method. It's vital that the inner storage remains the same so that
    /// bindings can be stored across view updates.
    private let box: Box<Storage>
    let defaultValue: Value
    let key: String

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
        // Specifically link the binding to the inner storage instead of the
        // outer box which changes with each view update.
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

    public init(wrappedValue defaultValue: Value, _ key: String) {
        self.key = key
        self.defaultValue = defaultValue
        box = Box(Storage(key: key, defaultValue: defaultValue))

        // Before casting the value we check the type, because casting an optional
        // to protocol Optional doesn't conform to can still succeed when the value
        // is `.some` and the wrapped type conforms to the protocol.
        if Value.self is ObservableObject.Type,
            let defaultValue = defaultValue as? ObservableObject
        {
            box.value.downstreamObservation = didChange.link(toUpstream: defaultValue.didChange)
        } else if let defaultValue = defaultValue as? OptionalObservableObject,
            let innerDidChange = defaultValue.didChange
        {
            // If we have an Optional<some ObservableObject>.some, then observe its
            // inner value's publisher.
            box.value.downstreamObservation = didChange.link(toUpstream: innerDidChange)
        }
    }

    public init<T>(_ key: String) where Value == T? {
        self.init(wrappedValue: nil, key)
    }

    public func update(with environment: EnvironmentValues, previousValue: AppStorage<Value>?) {
        if let previousValue {
            box.value = previousValue.box.value
        }
        box.value.provider = environment.appStorageProvider
    }
}

// MARK: - AppStorageKey

extension AppStorage {
    public init<Key: AppStorageKey<Value>>(_: Key.Type) {
        self.init(wrappedValue: Key.defaultValue, Key.name)
    }
}

public protocol AppStorageKey<Value> {
    associatedtype Value: Codable

    /// The name to use when persisting the key.
    static var name: String { get }
    /// The default value for the key.
    static var defaultValue: Value { get }
}
