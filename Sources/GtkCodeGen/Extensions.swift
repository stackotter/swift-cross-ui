import Foundation

extension String: @retroactive CodingKey {
    public init?(intValue: Int) {
        return nil
    }

    public init?(stringValue: String) {
        self = stringValue
    }

    public var stringValue: String {
        return self
    }

    public var intValue: Int? {
        return nil
    }
}
