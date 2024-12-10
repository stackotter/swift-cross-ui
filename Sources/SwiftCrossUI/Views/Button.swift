/// A control that initiates an action.
public struct Button: ElementaryView, View {
    /// The label to show on the button.
    var label: String
    /// The action to be performed when the button is clicked.
    var action: () -> Void

    /// Creates a button that displays a custom label.
    public init(_ label: String, action: @escaping () -> Void = {}) {
        self.label = label
        self.action = action
    }

    public func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        return backend.createButton()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        // TODO: Implement button sizing within SwiftCrossUI so that we can properly implement
        //   `dryRun`. Relying on the backend for button sizing also makes the Gtk 3 backend
        //   basically impossible to implement correctly, hence the
        //   `finalContentSize != contentSize` check in WindowGroupNode to catch any weird
        //   behaviour. Without that extra safety net logic, buttons all end up label-less
        //   whenever the window grows due to a view containing buttons appearing. Not sure
        //   why all buttons lose their labels (until you click off the window, forcing it to
        //   refresh), but the reason Gtk 3 doesn't like it is that the window gets set smaller
        //   than its content I think.
        //   See: https://github.com/stackotter/swift-cross-ui/blob/27f50579c52e79323c3c368512d37e95af576c25/Sources/SwiftCrossUI/Scenes/WindowGroupNode.swift#L140
        backend.updateButton(widget, label: label, action: action, environment: environment)
        return ViewSize(fixedSize: backend.naturalSize(of: widget))
    }
}
