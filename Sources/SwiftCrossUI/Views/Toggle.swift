public struct Toggle: View {
    /// The style of toggle shown.
    var selectedToggleStyle: ToggleStyle
    /// The label to be shown on or beside the toggle.
    var label: String
    /// Whether the toggle is active or not.
    var active: Binding<Bool>

    /// Creates a toggle that displays a custom label.
    public init(_ label: String, active: Binding<Bool>) {
        self.selectedToggleStyle = .button
        self.label = label
        self.active = active
    }

    public var body: some View {
        switch selectedToggleStyle {
            case .switch:
                HStack {
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
        var toggle = self
        toggle.selectedToggleStyle = selectedToggleStyle
        return toggle
    }
}

public enum ToggleStyle {
    case `switch`
    case button
}
