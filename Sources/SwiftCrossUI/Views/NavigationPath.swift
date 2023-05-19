import Foundation

/// A type-erased list of data representing the content of a navigation stack.
public struct NavigationPath {
    /// A storage class used so that we have control over exactly which changes are published (to
    /// avoid infinite loops).
    private class Storage {
        /// An entry that will be decoded next time it is used by a ``NavigationStack`` (we need to
        /// wait until we know what concrete entry types are available).
        struct EncodedEntry: Codable {
            var type: String
            var value: Data
        }

        /// The current path. If both this and `encodedEntries` are non-empty, the elements in path
        /// were added before the navigation path was even used to render a view. By design they
        /// come after the encodedEntries (because they can only be the result of appending and
        /// maybe popping).
        var path: [any Codable] = []
        /// Entries that will be encoded when this navigation path is first used by a
        /// ``NavigationStack``. It is not possible to decode the entries without first knowing
        /// what types the path can possibly contain (which only the ``NavigationStack`` will know).
        var encodedEntries: [EncodedEntry]?
    }

    /// The path and any elements waiting to be decoded are stored in a class so that changes are
    /// triggered from within NavigationStack when decoding the elements (which causes an infinite
    /// loop of updates).
    private var storage = Storage()

    /// A dummy used to trigger changes detectable by `Observed`.
    private var dummy = false

    /// Indicates whether this path is empty.
    var isEmpty: Bool {
        count == 0
    }

    /// The number of elements in the path.
    var count: Int {
        (storage.encodedEntries?.count ?? 0) + storage.path.count
    }

    /// Creates an empty navigation path
    public init() {
        storage.path = []
    }

    /// Appends a new value to the end of the path.
    public mutating func append<C: Codable>(_ component: C) {
        storage.path.append(component)
        triggerUpdate()
    }

    /// Removes values from the end of this path.
    public mutating func pop(_ k: Int = 1) {
        if storage.path.count == 0 && !isEmpty {
            storage.encodedEntries?.removeLast(k)
            if storage.encodedEntries?.count == 0 {
                storage.encodedEntries = nil
            }
        } else if !isEmpty {
            storage.path.removeLast()
        } else {
            fatalError("Attempted to pop from empty navigation path")
        }
        triggerUpdate()
    }

    /// Removes all values from this path.
    public mutating func removeAll() {
        storage.path.removeAll()
        storage.encodedEntries = nil
        triggerUpdate()
    }

    /// Causes the path to count as mutated so that any observers can know that it changed. Should
    /// be called whenever `storage` is updated except for when decoding entries (which doesn't
    /// change what is displayed and would cause an infinite loop of updates).
    private mutating func triggerUpdate() {
        dummy = !dummy
    }

    /// Gets the path's current entries. If the path was decoded from a stored representation and
    /// has not been used by a ``NavigationStack`` yet, the ``destinationTypes`` will be used to
    /// decode all elements in the path. Without knowing the ``destinationTypes``, the entries
    /// cannot be decoded (after macOS 11 they can be decoded by using `_typeByName`, but we can't
    /// use that because of backwards compatibility).
    func path(destinationTypes: [any Codable.Type]) -> [any Codable] {
        guard let encodedEntries = storage.encodedEntries else {
            return storage.path
        }

        var decodedEntries: [Int: any Codable] = [:]
        for destinationType in destinationTypes {
            let type = String(reflecting: destinationType)
            for (i, entry) in encodedEntries.enumerated() where entry.type == type {
                do {
                    let value = try JSONDecoder().decode(
                        destinationType,
                        from: entry.value
                    )
                    decodedEntries[i] = value
                } catch {
                    let data = String(data: entry.value, encoding: .utf8) ?? "Invalid encoding"
                    fatalError("Failed to decode item in encoded navigation path: '\(data)'")
                }
            }
        }

        var entries: [any Codable] = []
        for i in 0..<encodedEntries.count {
            guard let entry = decodedEntries[i] else {
                // This should not be possible to reach
                fatalError("Failed to decode navigation path")
            }
            entries.append(entry)
        }

        self.storage.encodedEntries = nil
        storage.path = entries + storage.path

        return storage.path
    }
}

extension NavigationPath: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Storage.EncodedEntry].self)
        guard !entries.isEmpty else {
            return
        }

        storage.encodedEntries = entries
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        // Combine any remaining encoded entries with the current decoded entries in the path.
        var entries = storage.encodedEntries ?? []
        entries += storage.path.map { entry in
            let type = String(reflecting: type(of: entry))
            let value: Data
            do {
                value = try JSONEncoder().encode(entry)
            } catch {
                fatalError("Failed to encode navigation path entry of type \(type)")
            }

            return Storage.EncodedEntry(
                type: type,
                value: value
            )
        }

        try container.encode(entries)
    }
}
