extension View {
    /// Locks this view's size on both the horizontal and vertical axes.
    public func fixedSize() -> some View {
        FixedSizeModifier(self, horizontal: true, vertical: true)
    }

    /// Locks this view's size.
    ///
    /// - Parameters:
    ///   - horizontal: Whether to lock this view's size on the horizontal axis.
    ///   - vertical: Whether to lock this view's size on the vertical axis.
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

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: TupleViewChildren1<Child>,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        let probingChildResult = children.child0.update(
            with: body.view0,
            proposedSize: proposedSize,
            environment: environment,
            dryRun: true
        )

        var frameSize = probingChildResult.size.size
        if horizontal && vertical {
            frameSize = probingChildResult.size.idealSize
        } else if horizontal {
            frameSize.x = probingChildResult.size.idealWidthForProposedHeight
        } else if vertical {
            frameSize.y = probingChildResult.size.idealHeightForProposedWidth
        }

        let childResult = children.child0.update(
            with: body.view0,
            proposedSize: frameSize,
            environment: environment,
            dryRun: dryRun
        )

        if !dryRun {
            let childPosition = Alignment.center.position(
                ofChild: childResult.size.size,
                in: frameSize
            )
            backend.setPosition(ofChildAt: 0, in: widget, to: childPosition)
            backend.setSize(of: widget, to: frameSize)
        }

        return ViewUpdateResult(
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
}
