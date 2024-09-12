/// A control for selecting from a set of values.
public struct Picker<Value: Equatable>: ElementaryView, View {
    /// The options to be offered by the picker.
    private var options: [Value]
    /// The picker's selected option.
    private var value: Binding<Value?>

    /// The index of the selected option (if any).
    private var selectedOptionIndex: Int? {
        return options.firstIndex { option in
            return option == value.wrappedValue
        }
    }

    /// Creates a new picker with the given options and a binding for the selected value.
    public init(of options: [Value], selection value: Binding<Value?>) {
        self.options = options
        self.value = value
    }

    public func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        return backend.createPicker()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> ViewUpdateResult {
        backend.updatePicker(
            widget,
            options: options.map { "\($0)" },
            environment: environment
        ) {
            selectedIndex in
            guard let selectedIndex = selectedIndex else {
                value.wrappedValue = nil
                return
            }
            value.wrappedValue = options[selectedIndex]
        }
        backend.setSelectedOption(ofPicker: widget, to: selectedOptionIndex)
        return ViewUpdateResult(fixedSize: backend.naturalSize(of: widget))
    }
}
