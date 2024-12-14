extension View {
    public func alert(
        _ title: String,
        isPresented: Binding<Bool>,
        @AlertActionsBuilder actions: () -> [AlertAction]
    ) -> some View {
        AlertModifierView(
            child: self,
            title: title,
            isPresented: isPresented,
            actions: actions()
        )
    }
}

struct AlertModifierView<Child: View>: TypeSafeView {
    typealias Children = AlertModifierViewChildren<Child>

    var state = EmptyState()
    var body = EmptyView()

    var child: Child
    var title: String
    var isPresented: Binding<Bool>
    var actions: [AlertAction]

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> Children {
        AlertModifierViewChildren(
            childNode: AnyViewGraphNode(
                ViewGraphNode(
                    for: child,
                    backend: backend,
                    environment: environment
                )
            ),
            alert: nil
        )
    }

    func asWidget<Backend: AppBackend>(_ children: Children, backend: Backend) -> Backend.Widget {
        children.childNode.widget.into()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Children,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        let size = children.childNode.update(
            with: child,
            proposedSize: proposedSize,
            environment: environment,
            dryRun: dryRun
        )

        if isPresented.wrappedValue && children.alert == nil {
            let alert = backend.createAlert()
            backend.updateAlert(
                alert,
                title: title,
                actionLabels: actions.map(\.label),
                environment: environment
            )
            backend.showAlert(
                alert,
                window: environment.window! as! Backend.Window
            ) { responseId in
                children.alert = nil
                isPresented.wrappedValue = false
                actions[responseId].action()
            }
            children.alert = alert
        } else if isPresented.wrappedValue == false && children.alert != nil {
            backend.dismissAlert(
                children.alert as! Backend.Alert,
                window: environment.window! as! Backend.Window
            )
            children.alert = nil
        }

        return size
    }
}

class AlertModifierViewChildren<Child: View>: ViewGraphNodeChildren {
    var childNode: AnyViewGraphNode<Child>
    var alert: Any?

    var widgets: [AnyWidget] {
        [childNode.widget]
    }

    var erasedNodes: [ErasedViewGraphNode] {
        [ErasedViewGraphNode(wrapping: childNode)]
    }

    init(
        childNode: AnyViewGraphNode<Child>,
        alert: Any?
    ) {
        self.childNode = childNode
        self.alert = alert
    }
}
