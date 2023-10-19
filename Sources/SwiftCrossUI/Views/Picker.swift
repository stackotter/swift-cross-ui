/// A picker view.
public struct Picker<Value: Equatable>: View {
    public var body = EmptyViewContent()

    /// The array of options to be offered by the picker.
    private var options: [Value]
    /// Storage for the picker's selected option.
    private var value: Binding<Value?>

    /// The index of the selected option (if any).
    private var selectedOptionIndex: Int? {
        return options.firstIndex { option in
            return option == value.wrappedValue
        }
    }

    /// Creates a new picker with the given array and binds a value.
    public init(of options: [Value], selection value: Binding<Value?>) {
        self.options = options
        self.value = value
    }

    public func asWidget<Backend: AppBackend>(
        _ children: EmptyViewContent.Children,
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
        _ widget: Backend.Widget, children: EmptyViewContent.Children, backend: Backend
    ) {
        backend.setOptions(ofPicker: widget, to: options.map { "\($0)" })
        backend.setSelectedOption(ofPicker: widget, to: selectedOptionIndex)
    }
}
