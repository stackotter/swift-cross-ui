/// An enumeration to indicate one edge of a rectangle.
public enum Edge: Int8, CaseIterable, Hashable {
    case top
    case bottom
    case leading
    case trailing

    /// An efficient set of Edges.
    public struct Set: OptionSet, Hashable {
        public let rawValue: Int8
        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }
        public init(_ e: Edge) {
            self.rawValue = 1 << e.rawValue
        }

        public static let top = Set(.top)
        public static let bottom = Set(.bottom)
        public static let leading = Set(.leading)
        public static let trailing = Set(.trailing)

        public static let horizontal: Set = [.leading, .trailing]
        public static let vertical: Set = [.bottom, .top]
        public static let all: Set = [.horizontal, .vertical]
    }
}
