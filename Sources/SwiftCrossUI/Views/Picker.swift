/// A control for selecting from a set of values.
public struct Picker<Value: Equatable>: ElementaryView, View {
    /// The options to be offered by the picker.
    private var options: [Value]
    /// A binding to the picker's selected option.
    private var value: Binding<Value?>

    /// The index of the selected option (if any).
    private var selectedOptionIndex: Int? {
        return options.firstIndex { option in
            return option == value.wrappedValue
        }
    }

    /// Creates a new picker with the given options and a binding for the
    /// selected value.
    ///
    /// - Parameters:
    ///   - options: The options to be offered by the picker.
    ///   - value: A binding to the picker's selected option.
    public init(of options: [Value], selection value: Binding<Value?>) {
        self.options = options
        self.value = value
    }

    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        return backend.createPicker()
    }

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: ProposedViewSize,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        // TODO: Implement picker sizing within SwiftCrossUI so that we can
        //   properly separate committing logic out into `commit`.
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

        // Special handling for UIKitBackend:
        // When backed by a UITableView, its natural size is -1 x -1,
        // but it can and should be as large as reasonable
        let naturalSize = backend.naturalSize(of: widget)
        let size: ViewSize
        if naturalSize == SIMD2(-1, -1) {
            size = proposedSize.replacingUnspecifiedDimensions(by: ViewSize(10, 10))
        } else {
            size = ViewSize(naturalSize)
        }
        return ViewLayoutResult.leafView(size: size)
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        backend.setSize(of: widget, to: layout.size.vector)
    }
}
