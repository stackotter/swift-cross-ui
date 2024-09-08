extension View {
    /// Positions this view within an invisible frame having the specified minimum size constraints.
    public func frame(width: Int? = nil, height: Int? = nil) -> some View {
        return StrictFrameView(
            self,
            width: width,
            height: height
        )
    }

    /// Positions this view within an invisible frame having the specified minimum size constraints.
    public func frame(
        minWidth: Int? = nil,
        idealWidth: Int? = nil,
        maxWidth: Int? = nil,
        minHeight: Int? = nil,
        idealHeight: Int? = nil,
        maxHeight: Int? = nil
    ) -> some View {
        return FlexibleFrameView(
            self,
            minWidth: minWidth,
            idealWidth: idealWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            idealHeight: idealHeight,
            maxHeight: maxHeight
        )
    }
}

/// The implementation for the ``View/frame(width:height:)`` view modifier.
struct StrictFrameView<Child: View>: TypeSafeView {
    var body: TupleView1<Child>

    /// The exact width to make the view.
    var width: Int?
    /// The exact height to make the view.
    var height: Int?

    /// Wraps a child view with size constraints.
    init(_ child: Child, width: Int?, height: Int?) {
        self.body = TupleView1(child)
        self.width = width
        self.height = height
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
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
        environment: Environment,
        backend: Backend
    ) -> ViewUpdateResult {
        let frameSize = SIMD2(
            width ?? proposedSize.x,
            height ?? proposedSize.y
        )

        let childSize = children.child0.update(
            with: body.view0,
            proposedSize: frameSize,
            environment: environment
        )

        let childPosition =
            SIMD2(
                frameSize.x - childSize.size.x,
                frameSize.y - childSize.size.y
            ) / 2
        backend.setSize(of: widget, to: frameSize)
        backend.setPosition(ofChildAt: 0, in: widget, to: childPosition)

        return ViewUpdateResult(
            size: frameSize,
            minimumWidth: width ?? childSize.minimumWidth,
            minimumHeight: height ?? childSize.minimumHeight
        )
    }
}

/// The implementation for the ``View/frame(width:height:)`` view modifier.
struct FlexibleFrameView<Child: View>: TypeSafeView {
    var body: TupleView1<Child>

    var minWidth: Int?
    var idealWidth: Int?
    var maxWidth: Int?
    var minHeight: Int?
    var idealHeight: Int?
    var maxHeight: Int?

    /// Wraps a child view with size constraints.
    init(
        _ child: Child,
        minWidth: Int?,
        idealWidth: Int?,
        maxWidth: Int?,
        minHeight: Int?,
        idealHeight: Int?,
        maxHeight: Int?
    ) {
        self.body = TupleView1(child)
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.idealWidth = idealWidth
        self.idealHeight = idealHeight
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
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
        environment: Environment,
        backend: Backend
    ) -> ViewUpdateResult {
        var proposedFrameSize = proposedSize
        if let idealWidth {
            proposedFrameSize.x = min(proposedFrameSize.x, idealWidth)
        }
        if let minWidth {
            proposedFrameSize.x = max(proposedFrameSize.x, minWidth)
        }
        if let maxWidth {
            proposedFrameSize.x = min(proposedFrameSize.x, maxWidth)
        }
        if let minHeight {
            proposedFrameSize.y = max(proposedFrameSize.y, minHeight)
        }
        if let maxHeight {
            proposedFrameSize.y = min(proposedFrameSize.y, maxHeight)
        }
        if let idealHeight {
            proposedFrameSize.y = min(proposedFrameSize.y, idealHeight)
        }

        let childSize = children.child0.update(
            with: body.view0,
            proposedSize: proposedFrameSize,
            environment: environment
        )

        var frameSize = childSize
        if let minWidth {
            frameSize.size.x = max(frameSize.size.x, minWidth)
            frameSize.minimumWidth = minWidth
        }
        if let maxWidth {
            frameSize.size.x = min(frameSize.size.x, maxWidth)
        }
        if let minHeight {
            frameSize.size.y = max(frameSize.size.y, minHeight)
            frameSize.minimumHeight = minHeight
        }
        if let maxHeight {
            frameSize.size.y = min(frameSize.size.y, maxHeight)
        }

        let childPosition =
            SIMD2(
                frameSize.size.x - childSize.size.x,
                frameSize.size.y - childSize.size.y
            ) / 2
        backend.setSize(of: widget, to: frameSize.size)
        backend.setPosition(ofChildAt: 0, in: widget, to: childPosition)

        return frameSize
    }
}
