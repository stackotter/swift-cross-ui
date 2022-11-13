public protocol DoubleConvertible {
    init(_ value: Double)
    var doubleRepresentation: Double { get }
}

struct FloatingPointValue<Value: BinaryFloatingPoint>: DoubleConvertible {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }

    init(_ value: Double) {
        self.value = Value(value)
    }

    var doubleRepresentation: Double {
        return Double(value)
    }
}

struct IntegerValue<Value: BinaryInteger>: DoubleConvertible {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }

    init(_ value: Double) {
        self.value = Value(value)
    }

    var doubleRepresentation: Double {
        return Double(value)
    }
}

/// A slider that allows a user to choose a numeric value.
public struct Slider: View {
    public var value: Binding<Double>?
    public var minimum: Double
    public var maximum: Double
    public var decimalPlaces: Int

    public var body = EmptyViewContent()

    public init<T: BinaryInteger>(_ value: Binding<T>? = nil, minimum: T, maximum: T) {
        if let value = value {
            self.value = Binding<Double>(
                get: {
                    return Double(value.wrappedValue)
                },
                set: {
                    newValue in value.wrappedValue = T(newValue.rounded())
                }
            )
        }
        self.minimum = Double(minimum)
        self.maximum = Double(maximum)
        decimalPlaces = 0
    }

    public init<T: BinaryFloatingPoint>(_ value: Binding<T>? = nil, minimum: T, maximum: T) {
        if let value = value {
            self.value = Binding<Double>(
                get: {
                    return Double(value.wrappedValue)
                },
                set: {
                    newValue in value.wrappedValue = T(newValue)
                }
            )
        }
        self.minimum = Double(minimum)
        self.maximum = Double(maximum)
        decimalPlaces = 2
    }

    public func asWidget(_ children: EmptyViewGraphNodeChildren) -> GtkWidget {
        let slider = GtkScale()
        slider.minimum = minimum
        slider.maximum = maximum
        slider.value = value?.wrappedValue ?? slider.value
        slider.decimalPlaces = decimalPlaces
        slider.changed = { widget in
            self.value?.wrappedValue = widget.value
        }
        return slider
    }

    public func update(_ widget: GtkWidget, children: EmptyViewGraphNodeChildren) {
        let slider = widget as! GtkScale
        slider.minimum = minimum
        slider.maximum = maximum
        slider.value = value?.wrappedValue ?? slider.value
        slider.decimalPlaces = decimalPlaces
        slider.changed = { widget in
            self.value?.wrappedValue = widget.value
        }
    }
}
