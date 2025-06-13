/// Indicates a specific edge of a rectangle.
public enum Edge: Int8, CaseIterable, Hashable, Sendable {
    /// The top edge.
    case top
    /// The bottom edge.
    case bottom
    /// The leading edge (the left edge in left to right layouts).
    case leading
    /// The trailing edge (the right edge in left to right layouts).
    case trailing

    /// An efficient set of Edges.
    public struct Set: OptionSet, Hashable, Sendable {
        public let rawValue: Int8

        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }

        public init(_ edge: Edge) {
            self.rawValue = 1 << edge.rawValue
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
