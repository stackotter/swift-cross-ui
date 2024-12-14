extension View {
    /// Adds an action to be performed before this view appears.
    ///
    /// The exact moment that the action gets called is an internal detail and
    /// may change at any time, but it is guaranteed to be after accessing the
    /// view's ``View/body`` and before the view appears on screen. Currently,
    /// if these docs have been kept up to date, the action gets called just
    /// before creating the view's widget.
    public func onAppear(perform action: @escaping () -> Void) -> some View {
        OnAppearModifier(body: self, action: action)
    }
}

struct OnAppearModifier<Content: View>: LightweightView {
    var body: Content
    var action: () -> Void

    func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        action()
        return body.asWidget(children, backend: backend)
    }
}
