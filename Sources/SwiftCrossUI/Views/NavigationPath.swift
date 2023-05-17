import Foundation

/// A type-erased list of data representing the content of a navigation stack.
public struct NavigationPath {
    internal private(set) var path: [any Codable] = []

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
        path.append(component)
    }

    /// Removes values from the end of this path.
    public mutating func removeLast(_ k: Int = 1) {
        path.removeLast(k)
    }

    /// Removes all values from this path.
    public mutating func removeAll() {
        path.removeAll()
    }
}

/// https://gist.github.com/mbrandonw/ed5d14b86e263fa6df008329cba74142
extension NavigationPath: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in path.reversed() {
            try container.encode(_mangledTypeName(type(of: element)))
            let string = try String(decoding: JSONEncoder().encode(element), as: UTF8.self)
            try container.encode(string)
        }
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.path = []
        while !container.isAtEnd {
            let typeName = try container.decode(String.self)
            guard let type = _typeByName(typeName) as? any Codable.Type else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "\(typeName) is not Codable."
                )
            }
            let encodedValue = try container.decode(String.self)
            let value = try JSONDecoder().decode(type, from: Data(encodedValue.utf8))
            self.path.insert(value, at: 0)
        }
    }
}