public struct Padding {
    public var top: Int = 0
    public var bottom: Int = 0
    public var left: Int = 0
    public var right: Int = 0

    public init() {}

    public init(top: Int, bottom: Int, left: Int, right: Int) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
    }

    public init(_ amount: Int) {
        top = amount
        bottom = amount
        left = amount
        right = amount
    }

    public subscript(_ side: Side) -> Int {
        get {
            switch side {
                case .top: return top
                case .bottom: return bottom
                case .left: return left
                case .right: return right
            }
        }
        set {
            switch side {
                case .top: top = newValue
                case .bottom: bottom = newValue
                case .left: left = newValue
                case .right: right = newValue
            }
        }
    }
}
