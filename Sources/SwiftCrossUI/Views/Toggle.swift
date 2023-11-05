
public struct Toggle: View {
    /// The style of toggle shown.
    public let selectedToggleStyle: ToggleStyle
    /// The label to be shown on or beside the toggle.
    var label: String
    /// Whether the toggle is active or not.
    var active: Binding<Bool>

    /// Creates a toggle that displays a custom label.
    public init(selectedToggleStyle: ToggleStyle = .button, _ label: String, active: Binding<Bool>) {
        self.selectedToggleStyle = selectedToggleStyle
        self.label = label
        self.active = active
    }

    public var body: some View {
        switch selectedToggleStyle {
            case .switch:
                HStack() {
                    Text(label)
                    ToggleSwitch(active: active)
                }
            case .button:
                ToggleButton(label, active: active)
    }
  }
}

extension Toggle {
    /// Sets the style of the toggle.
    public func toggleStyle(_ selectedToggleStyle: ToggleStyle) -> Toggle {
        return Toggle(
            selectedToggleStyle: selectedToggleStyle, 
            self.label, 
            active: self.active
        )
    }
}

public enum ToggleStyle {
    case `switch`
    case button
}

/// A light switch style control that is either on or off.
private struct ToggleSwitch: ElementaryView, View {
    /// Whether the switch is active or not.
    private var active: Binding<Bool>

    /// Creates a switch.
    public init(active: Binding<Bool>) {
        self.active = active
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createSwitch(
            active: active.wrappedValue,
            onChange: { newValue in
                self.active.wrappedValue = newValue
            }
        )
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        backend.setIsActive(ofSwitch: widget, to: active.wrappedValue)
        backend.setOnChange(ofSwitch: widget) { newActiveState in
            active.wrappedValue = newActiveState
        }
    }
}

/// A button style control that is either on or off.
private struct ToggleButton: ElementaryView, View {
    /// The label to show on the toggle button.
    private var label: String
    /// Whether the button is active or not.
    private var active: Binding<Bool>

    /// Creates a toggle button that displays a custom label.
    public init(_ label: String, active: Binding<Bool>) {
        self.label = label
        self.active = active
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createToggle(
            label: label,
            active: active.wrappedValue,
            onChange: { newValue in
                self.active.wrappedValue = newValue
            }
        )
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        backend.setLabel(ofButton: widget, to: label)
        backend.setIsActive(ofToggle: widget, to: active.wrappedValue)
        backend.setOnChange(ofToggle: widget) { newActiveState in
            active.wrappedValue = newActiveState
        }
    }
}
