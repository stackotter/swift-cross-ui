/// The size of a view.
public struct ViewSize: Hashable, Sendable {
    /// The zero view size.
    public static let zero = Self(0, 0)

    /// The view's width.
    public var width: Double
    /// The view's height.
    public var height: Double

    /// Creates a view size.
    public init(_ width: Double, _ height: Double) {
        self.width = width
        self.height = height
    }

    /// Creates a view size from an integer vector.
    init(_ vector: SIMD2<Int>) {
        width = Double(vector.x)
        height = Double(vector.y)
    }

    /// Gets the view size as a vector.
    package var vector: SIMD2<Int> {
        SIMD2<Int>(
            LayoutSystem.roundSize(width),
            LayoutSystem.roundSize(height)
        )
    }

    /// The size component associated with the given orientation.
    public subscript(component orientation: Orientation) -> Double {
        get {
            switch orientation {
                case .horizontal:
                    width
                case .vertical:
                    height
            }
        }
        set {
            switch orientation {
                case .horizontal:
                    width = newValue
                case .vertical:
                    height = newValue
            }
        }
    }

    /// The size component associated with the given axis.
    public subscript(component axis: Axis) -> Double {
        get {
            self[component: axis.orientation]
        }
        set {
            self[component: axis.orientation] = newValue
        }
    }
}
