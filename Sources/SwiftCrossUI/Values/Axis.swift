/// An axis in a 2D coordinate system.
public enum Axis: Sendable, CaseIterable {
    /// The horizontal axis.
    case horizontal
    /// The vertical axis.
    case vertical

    /// Gets the orientation with this axis as its main axis.
    var orientation: Orientation {
        switch self {
            case .horizontal:
                .horizontal
            case .vertical:
                .vertical
        }
    }

    /// A set of axes represented as an efficient bit field.
    public struct Set: OptionSet, Sendable {
        /// The horizontal axis.
        public static let horizontal = Set(rawValue: 1)
        /// The vertical axis.
        public static let vertical = Set(rawValue: 2)

        public var rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        /// Gets whether a given member is a member of the option set.
        public func contains(_ member: Axis) -> Bool {
            switch member {
                case .horizontal:
                    contains(Axis.Set.horizontal)
                case .vertical:
                    contains(Axis.Set.vertical)
            }
        }
    }
}
