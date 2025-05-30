extension View {
    public func fixedSize() -> some View {
        FixedSizeModifier(self, horizontal: true, vertical: true)
    }

    public func fixedSize(horizontal: Bool, vertical: Bool) -> some View {
        FixedSizeModifier(self, horizontal: horizontal, vertical: vertical)
    }
}

struct FixedSizeModifier<Child: View>: TypeSafeView {
    var body: TupleView1<Child>

    var horizontal: Bool
    var vertical: Bool

    init(_ child: Child, horizontal: Bool, vertical: Bool) {
        body = TupleView1(child)
        self.horizontal = horizontal
        self.vertical = vertical
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> TupleViewChildren1<Child> {
        body.children(backend: backend, snapshots: snapshots, environment: environment)
    }

    func asWidget<Backend: AppBackend>(
        _ children: TupleViewChildren1<Child>,
        backend: Backend
    ) -> Backend.Widget {
        let container = backend.createContainer()
        backend.addChild(children.child0.widget.into(), to: container)
        return container
    }

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: TupleViewChildren1<Child>,
        proposedSize: SizeProposal,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let childResult = children.child0.computeLayout(
            with: body.view0,
            proposedSize: SizeProposal(
                horizontal ? nil : proposedSize.width,
                vertical ? nil : proposedSize.height
            ),
            environment: environment
        )
        let childSize = childResult.size

        return ViewLayoutResult(
            size: ViewSize(
                size: childSize.size,
                idealSize: childSize.idealSize,
                idealWidthForProposedHeight: childSize.idealWidthForProposedHeight,
                idealHeightForProposedWidth: childSize.idealHeightForProposedWidth,
                minimumWidth: horizontal ? childSize.size.x : childSize.minimumWidth,
                minimumHeight: vertical ? childSize.size.y : childSize.minimumHeight,
                maximumWidth: horizontal ? Double(childSize.size.x) : childSize.maximumWidth,
                maximumHeight: vertical ? Double(childSize.size.y) : childSize.maximumHeight
            ),
            childResults: [childResult]
        )
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: TupleViewChildren1<Child>,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        let childResult = children.child0.commit()
        let childPosition = Alignment.center.position(
            ofChild: childResult.size.size,
            in: layout.size.size
        )
        backend.setPosition(ofChildAt: 0, in: widget, to: childPosition)
        backend.setSize(of: widget, to: layout.size.size)
    }
}
