/// A positon.
struct Position: Hashable, Sendable {
    /// The zero position (aka the origin).
    static let zero = Self(0, 0)

    /// The position's x component.
    var x: Double
    /// The position's y component.
    var y: Double

    var vector: SIMD2<Int> {
        SIMD2(
            LayoutSystem.roundSize(x),
            LayoutSystem.roundSize(y)
        )
    }

    /// Creates a new position.
    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }

    /// The position component associated with the given orientation's main axis.
    public subscript(component orientation: Orientation) -> Double {
        get {
            switch orientation {
                case .horizontal:
                    x
                case .vertical:
                    y
            }
        }
        set {
            switch orientation {
                case .horizontal:
                    x = newValue
                case .vertical:
                    y = newValue
            }
        }
    }

    /// The position component associated with the given axis.
    public subscript(component axis: Axis) -> Double {
        get {
            self[component: axis.orientation]
        }
        set {
            self[component: axis.orientation] = newValue
        }
    }
}
