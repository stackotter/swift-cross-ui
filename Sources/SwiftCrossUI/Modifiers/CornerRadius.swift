extension View {
    public func cornerRadius(_ radius: Int) -> some View {
        CornerRadiusModifier(body: self, cornerRadius: radius)
    }
}

struct CornerRadiusModifier<Content: View>: View {
    var body: Content
    var cornerRadius: Int

    func update<Backend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize where Backend: AppBackend {
        let contentSize = body.update(
            widget,
            children: children,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend,
            dryRun: dryRun
        )
        backend.setCornerRadius(of: widget, to: cornerRadius)
        return contentSize
    }
}
