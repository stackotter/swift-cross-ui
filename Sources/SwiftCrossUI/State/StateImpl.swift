struct StateImpl<Storage: StateStorageProtocol> {
    /// The inner `Storage` is what stays constant between view updates.
    /// The wrapping box is used so that we can assign the storage to future
    /// state instances from the non-mutating ``update(with:previousValue:)``
    /// method. It's vital that the inner storage remains the same so that
    /// bindings can be stored across view updates.
    var box: Box<Storage>

    init(initialStorage: Storage) {
        self.box = Box(initialStorage)

        // Before casting the value we check the type, because casting an optional
        // to protocol Optional doesn't conform to can still succeed when the value
        // is `.some` and the wrapped type conforms to the protocol.
        if Storage.Value.self is ObservableObject.Type,
            let value = initialStorage.value as? ObservableObject
        {
            box.value.downstreamObservation = box.value.didChange.link(toUpstream: value.didChange)
        } else if let value = initialStorage.value as? OptionalObservableObject,
            let innerDidChange = value.didChange
        {
            // If we have an `Optional<some ObservableObject>.some`, then observe its
            // inner value's publisher.
            box.value.downstreamObservation = box.value.didChange.link(toUpstream: innerDidChange)
        }
    }

    var wrappedValue: Storage.Value {
        get { box.value.value }
        nonmutating set {
            box.value.value = newValue
            box.value.postSet()
        }
    }

    var projectedValue: Binding<Storage.Value> {
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

    func update(with environment: EnvironmentValues, previousValue: Self?) {
        if let previousValue {
            box.value = previousValue.box.value
        }
    }
}

protocol StateStorageProtocol: AnyObject {
    associatedtype Value
    var value: Value { get set }
    var didChange: Publisher { get }
    var downstreamObservation: Cancellable? { get set }
}

extension StateStorageProtocol {
    /// Call this to publish an observation to all observers after
    /// setting a new value. This isn't in a `didSet` property accessor
    /// because we want more granular control over when it does and
    /// doesn't trigger.
    ///
    /// Additionally updates the downstream observation if the
    /// wrapped value is an `Optional<some ObservableObject>` and the
    /// current case has toggled.
    func postSet() {
        // If the wrapped value is an `Optional<some ObservableObject>`
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
