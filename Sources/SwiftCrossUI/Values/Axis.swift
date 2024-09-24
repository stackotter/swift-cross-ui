/// An axis in a 2D coordinate system.
public enum Axis {
    /// The horizontal axis.
    case horizontal
    /// The vertical axis.
    case vertical

    /// A set of axes represented as an efficient bit field.
    public struct Set: OptionSet {
        /// The horizontal axis.
        public static let horizontal = Set(rawValue: 1)
        /// The vertical axis.
        public static let vertical = Set(rawValue: 2)

        public var rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
    }
}
