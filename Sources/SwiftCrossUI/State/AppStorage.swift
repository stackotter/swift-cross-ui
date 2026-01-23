import Foundation
import Mutex

private let appStorageCache: Mutex<[String: any Codable & Sendable]> = Mutex([:])
private let appStoragePublisherCache: Mutex<[String: Publisher]> = Mutex([:])

/// Like ``State``, but persists its value to disk so that it survives betweeen
/// app launches.
@propertyWrapper
public struct AppStorage<Value: Codable & Sendable>: ObservableProperty {
    // TODO: Observe changes to persisted values made by external processes

    private final class Storage {
        let key: String
        let defaultValue: Value
        var downstreamObservation: Cancellable?
        var provider: (any AppStorageProvider)?
        var persistTask: Task<Void, Never>?

        init(key: String, defaultValue: Value) {
            self.key = key
            self.defaultValue = defaultValue
        }

        var didChange: Publisher {
            appStoragePublisherCache.withLock { cache in
                guard let publisher = cache[key] else {
                    let newPublisher = Publisher()
                    cache[key] = newPublisher
                    return newPublisher
                }
                return publisher
            }
        }

        var value: Value {
            get {
                guard let provider else {
                    fatalError(
                        """
                        @AppStorage value with key '\(key)' used before initialization. \
                        Don't use @AppStorage properties before SwiftCrossUI requests the \
                        view's body.
                        """
                    )
                }

                return appStorageCache.withLock { cache in
                    // If this is the very first time we're reading from this key, it won't
                    // be in the cache yet. In that case, we return the already-persisted value
                    // if it exists, or the default value otherwise; either way, we add it to the
                    // cache so subsequent accesses of `value` won't have to read from disk again.
                    guard let cachedValue = cache[key] else {
                        let value = provider.retrieve(type: Value.self, forKey: key) ?? defaultValue
                        cache[key] = value
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
            }

            set {
                guard let provider else {
                    fatalError(
                        """
                        @AppStorage value with key '\(key)' used before initialization. \
                        Don't use @AppStorage properties before SwiftCrossUI requests the \
                        view's body.
                        """
                    )
                }

                appStorageCache.withLock { $0[key] = newValue }

                // In order to avoid writing to disk on every update, we perform some simple
                // debouncing. We spin up a `Task` which immediately sleeps for
                // `persistDebounceTimeout` seconds from; if this setter is called again
                // before that happens, the task is cancelled (causing `sleep` to throw) and
                // a new one is started. This means changes will only be persisted if no updates
                // occur for at least `persistDebounceTimeout` seconds.
                persistTask?.cancel()
                persistTask = Task { [key, newValue, provider] in
                    do {
                        try await Task.sleep(
                            nanoseconds: UInt64(provider.debounceTimeout * 1_000_000_000)
                        )
                        logger.debug("persisting '\(newValue)' for '\(key)'")
                        try provider.persist(value: newValue, forKey: key)
                    } catch is CancellationError {
                        // If the task is cancelled before the call to `sleep` returns, it'll throw
                        // a CancellationError and skip the rest of the code, which is precisely
                        // what we want here. So we just swallow the error.
                    } catch {
                        logger.warning(
                            "failed to encode '@AppStorage' data",
                            metadata: ["value": "\(newValue)", "error": "\(error)"]
                        )
                    }
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

    /// The inner `Storage` is what stays constant between view updates.
    /// The wrapping box is used so that we can assign the storage to future
    /// state instances from the non-mutating ``update(with:previousValue:)``
    /// method. It's vital that the inner storage remains the same so that
    /// bindings can be stored across view updates.
    private let box: Box<Storage>

    /// The default value, used when no value has been persisted yet.
    let defaultValue: Value

    /// The key used to access the persisted value.
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
