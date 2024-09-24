public struct ProgressView<Label: View>: View {
    var label: Label

    public var body: some View {
        if label as? EmptyView == nil {
            ProgressSpinnerView()
            label
        } else {
            ProgressSpinnerView()
        }
    }

    public init(_ label: Label) {
        self.label = label
    }
}

extension ProgressView where Label == EmptyView {
    public init() {
        self.label = EmptyView()
    }
}

extension ProgressView where Label == Text {
    public init(_ label: String) {
        self.label = Text(label)
    }
}

struct ProgressSpinnerView: View {
    public var body = EmptyView()

    public init() {}

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        backend.createProgressSpinner()
    }

    public func update<Backend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize where Backend: AppBackend {
        ViewSize(fixedSize: backend.naturalSize(of: widget))
    }
}
