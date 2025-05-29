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
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let probingChildResult = children.child0.computeLayout(
            with: body.view0,
            proposedSize: proposedSize,
            environment: environment
        )

        var frameSize = probingChildResult.size.size
        if horizontal && vertical {
            frameSize = probingChildResult.size.idealSize
        } else if horizontal {
            frameSize.x = probingChildResult.size.idealWidthForProposedHeight
        } else if vertical {
            frameSize.y = probingChildResult.size.idealHeightForProposedWidth
        }

        let childResult = children.child0.computeLayout(
            with: body.view0,
            proposedSize: frameSize,
            environment: environment
        )

        return ViewLayoutResult(
            size: ViewSize(
                size: frameSize,
                idealSize: childResult.size.idealSize,
                idealWidthForProposedHeight: childResult.size.idealWidthForProposedHeight,
                idealHeightForProposedWidth: childResult.size.idealHeightForProposedWidth,
                minimumWidth: horizontal ? frameSize.x : childResult.size.minimumWidth,
                minimumHeight: vertical ? frameSize.y : childResult.size.minimumHeight,
                maximumWidth: horizontal ? Double(frameSize.x) : childResult.size.maximumWidth,
                maximumHeight: vertical ? Double(frameSize.y) : childResult.size.maximumHeight
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
