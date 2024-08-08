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
    var body: VariadicView1<Child>

    /// The minimum width to make the view.
    var width: Int?
    /// The minimum height to make the view.
    var height: Int?

    /// Wraps a child view with size constraints.
    init(_ child: Child, width: Int?, height: Int?) {
        self.body = VariadicView1(child)
        self.width = width
        self.height = height
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> ViewGraphNodeChildren1<Child> {
        body.children(backend: backend, snapshots: snapshots, environment: environment)
    }

    func asWidget<Backend: AppBackend>(
        _ children: ViewGraphNodeChildren1<Child>,
        backend: Backend
    ) -> Backend.Widget {
        let container = backend.createContainer()
        backend.addChild(children.child0.widget.into(), to: container)
        return container
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ViewGraphNodeChildren1<Child>,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> SIMD2<Int> {
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
                frameSize.x - childSize.x,
                frameSize.y - childSize.y
            ) / 2
        backend.setSize(of: widget, to: frameSize)
        backend.setPosition(ofChildAt: 0, in: widget, to: childPosition)

        return frameSize
    }
}

/// The implementation for the ``View/frame(width:height:)`` view modifier.
struct FlexibleFrameView<Child: View>: TypeSafeView {
    var body: VariadicView1<Child>

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
        self.body = VariadicView1(child)
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
    ) -> ViewGraphNodeChildren1<Child> {
        body.children(backend: backend, snapshots: snapshots, environment: environment)
    }

    func asWidget<Backend: AppBackend>(
        _ children: ViewGraphNodeChildren1<Child>,
        backend: Backend
    ) -> Backend.Widget {
        let container = backend.createContainer()
        backend.addChild(children.child0.widget.into(), to: container)
        return container
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ViewGraphNodeChildren1<Child>,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> SIMD2<Int> {
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
            frameSize.x = max(frameSize.x, minWidth)
        }
        if let maxWidth {
            frameSize.x = min(frameSize.x, maxWidth)
        }
        if let minHeight {
            frameSize.y = max(frameSize.y, minHeight)
        }
        if let maxHeight {
            frameSize.y = min(frameSize.y, maxHeight)
        }

        let childPosition =
            SIMD2(
                frameSize.x - childSize.x,
                frameSize.y - childSize.y
            ) / 2
        backend.setSize(of: widget, to: frameSize)
        backend.setPosition(ofChildAt: 0, in: widget, to: childPosition)

        return frameSize
    }
}
