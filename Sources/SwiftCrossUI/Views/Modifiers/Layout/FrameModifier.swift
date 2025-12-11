extension View {
    /// Positions this view within an invisible frame having the specified minimum size constraints.
    public func frame(
        width: Int? = nil,
        height: Int? = nil,
        alignment: Alignment = .center
    ) -> some View {
        return StrictFrameView(
            self,
            width: width,
            height: height,
            alignment: alignment
        )
    }

    /// Positions this view within an invisible frame having the specified minimum size constraints.
    public func frame(
        minWidth: Int? = nil,
        idealWidth: Int? = nil,
        maxWidth: Double? = nil,
        minHeight: Int? = nil,
        idealHeight: Int? = nil,
        maxHeight: Double? = nil,
        alignment: Alignment = .center
    ) -> some View {
        return FlexibleFrameView(
            self,
            minWidth: minWidth,
            idealWidth: idealWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            idealHeight: idealHeight,
            maxHeight: maxHeight,
            alignment: alignment
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
    /// The alignment of the child within the frame.
    var alignment: Alignment

    /// Wraps a child view with size constraints.
    init(_ child: Child, width: Int?, height: Int?, alignment: Alignment) {
        body = TupleView1(child)
        self.width = width
        self.height = height
        self.alignment = alignment
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
        proposedSize: ProposedViewSize,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let width = width.map(Double.init)
        let height = height.map(Double.init)

        let childResult = children.child0.computeLayout(
            with: body.view0,
            proposedSize: ProposedViewSize(
                width ?? proposedSize.width,
                height ?? proposedSize.height
            ),
            environment: environment
        )
        let childSize = childResult.size

        let frameSize = ViewSize(
            width ?? childSize.width,
            height ?? childSize.height
        )

        return ViewLayoutResult(
            size: frameSize,
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
        let frameSize = layout.size
        let childSize = children.child0.commit().size

        let childPosition = alignment.position(
            ofChild: childSize.vector,
            in: frameSize.vector
        )
        backend.setSize(of: widget, to: frameSize.vector)
        backend.setPosition(ofChildAt: 0, in: widget, to: childPosition)
    }
}

/// The implementation for the ``View/frame(width:height:)`` view modifier.
struct FlexibleFrameView<Child: View>: TypeSafeView {
    var body: TupleView1<Child>

    var minWidth: Int?
    var idealWidth: Int?
    var maxWidth: Double?
    var minHeight: Int?
    var idealHeight: Int?
    var maxHeight: Double?
    /// The alignment of the child within the frame.
    var alignment: Alignment

    /// Wraps a child view with size constraints.
    init(
        _ child: Child,
        minWidth: Int?,
        idealWidth: Int?,
        maxWidth: Double?,
        minHeight: Int?,
        idealHeight: Int?,
        maxHeight: Double?,
        alignment: Alignment
    ) {
        self.body = TupleView1(child)
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.idealWidth = idealWidth
        self.idealHeight = idealHeight
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.alignment = alignment
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
        proposedSize: ProposedViewSize,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        var proposedFrameSize = proposedSize

        if let proposedWidth = proposedSize.width {
            proposedFrameSize.width = LayoutSystem.clamp(
                proposedWidth,
                minimum: minWidth.map(Double.init),
                maximum: maxWidth
            )
        }

        if let proposedHeight = proposedSize.height {
            proposedFrameSize.height = LayoutSystem.clamp(
                proposedHeight,
                minimum: minHeight.map(Double.init),
                maximum: maxHeight
            )
        }

        let childResult = children.child0.computeLayout(
            with: body.view0,
            proposedSize: proposedFrameSize,
            environment: environment
        )
        let childSize = childResult.size

        // TODO: Fix idealSize propagation. When idealSize isn't possible, we
        //   have to use idealWidthForProposedHeight and
        //   idealHeightForProposedWidth, and sometimes we may also have to
        //   perform an additional dryRun update to probe the child view.

        var frameSize = childSize
        frameSize.width = LayoutSystem.clamp(
            frameSize.width,
            minimum: minWidth.map(Double.init),
            maximum: maxWidth
        )
        frameSize.height = LayoutSystem.clamp(
            frameSize.height,
            minimum: minHeight.map(Double.init),
            maximum: maxHeight
        )

        if maxWidth == .infinity, let proposedWidth = proposedSize.width {
            frameSize.width = proposedWidth
        }
        if maxHeight == .infinity, let proposedHeight = proposedSize.height {
            frameSize.height = proposedHeight
        }

        return ViewLayoutResult(
            size: frameSize,
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
        let frameSize = layout.size
        let childSize = children.child0.commit().size

        let childPosition = alignment.position(
            ofChild: childSize.vector,
            in: frameSize.vector
        )
        backend.setSize(of: widget, to: frameSize.vector)
        backend.setPosition(ofChildAt: 0, in: widget, to: childPosition)
    }
}
