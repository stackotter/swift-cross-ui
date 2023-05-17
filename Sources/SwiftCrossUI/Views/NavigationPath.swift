import Foundation

/// A type-erased list of data representing the content of a navigation stack.
public struct NavigationPath {
    internal var hasPendingDecodableEntries = false
    private var entries: [any NavigationPathEntry] = []
    internal var path: [any Codable] {
        return entries.compactMap {
            if $0 is LazyDecodableEntry {
                return nil
            }
            return $0.data
        }
    }

    /// A Boolean that indicates whether this path is empty.
    public var isEmpty: Bool {
        path.isEmpty
    }

    /// The number of elements in this path.
    public var count: Int {
        path.count
    }

    /// Creates an empty navigation path
    public init() {}

    /// Appends a new value to the end of this path.

    public mutating func append<C: Codable>(_ component: C) {
        entries.append(Entry(
            type: typeName(for: C.self),
            data: component
        ))
    }

    /// Removes values from the end of this path.
    public mutating func removeLast(_ k: Int = 1) {
        entries.removeLast(k)
    }

    /// Removes all values from this path.
    public mutating func removeAll() {
        entries.removeAll()
    }

    internal func afterDecodingEntries<T: Codable>(ofType type: T.Type) -> NavigationPath? {
        guard hasPendingDecodableEntries else {
            return nil
        }

        let name = typeName(for: type)
        var didDecodeAnEntry = false
        var didFindDecodableEntry = false
        var updated = self
        updated.entries = entries.map {
            if let decodable = $0 as? LazyDecodableEntry {
                didFindDecodableEntry = true
                if decodable.type == name, let data = try? JSONDecoder().decode(type, from: decodable.data) {
                    didDecodeAnEntry = true
                    return Entry(type: name, data: data)
                }
            }

            return $0
        }

        if didDecodeAnEntry || !didFindDecodableEntry {
            updated.hasPendingDecodableEntries = didFindDecodableEntry
            return updated
        }

        return nil
    }

    private func typeName<T>(for: T.Type) -> String {
        // If this also does not work we can do String(describing:) but that wont
        // include parent of nested class and module
        return _typeName(T.self)
    }
}

private protocol NavigationPathEntry {
    var type: String { get }
    var data: C { get }
    associatedtype C: Codable
}
private struct LazyDecodableEntry: NavigationPathEntry, Codable {
    var type: String
    var data: Data
}
private struct Entry<C: Codable>: NavigationPathEntry {
    var type: String
    var data: C
}

extension NavigationPath: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for entry in entries.reversed() {
            try container.encode(entry.type)
            let string = try String(decoding: JSONEncoder().encode(entry.data), as: UTF8.self)
            try container.encode(string)
        }
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.entries = []
        while !container.isAtEnd {
            self.entries.insert(LazyDecodableEntry(
               type: try container.decode(String.self),
               data: Data(try container.decode(String.self).utf8)
            ), at: 0)
        }
        self.hasPendingDecodableEntries = !entries.isEmpty
    }
}