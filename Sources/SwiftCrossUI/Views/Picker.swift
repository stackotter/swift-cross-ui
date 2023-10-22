/// A control for selecting from a set of values.
public struct Picker<Value: Equatable>: ElementaryView {
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

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createPicker(
            options: options.map { "\($0)" },
            selectedOption: selectedOptionIndex
        ) { selectedIndex in
            guard let selectedIndex = selectedIndex else {
                value.wrappedValue = nil
                return
            }
            value.wrappedValue = options[selectedIndex]
        }
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, backend: Backend
    ) {
        backend.setOptions(ofPicker: widget, to: options.map { "\($0)" })
        backend.setSelectedOption(ofPicker: widget, to: selectedOptionIndex)
    }
}
