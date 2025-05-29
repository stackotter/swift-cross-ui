extension View {
    // TODO: Figure out why SwiftUI's window gets significantly shorter than
    // SwiftCrossUI's with the following content;
    //
    // VStack {
    //     Text("Hello, World!")
    //     Divider()
    //     Color.red
    //         .aspectRatio(1, contentMode: .fill)
    //         .frame(maxWidth: 300)
    //     Divider()
    //     Text("Footer")
    // }

    /// Constrains a view to maintain a specific aspect ratio.
    /// - Parameter aspectRatio: The aspect ratio to maintain. Use `nil` to
    ///   maintain the view's ideal aspect ratio.
    /// - Parameter contentMode: How the view should fill available space.
    public func aspectRatio(_ aspectRatio: Double? = nil, contentMode: ContentMode) -> some View {
        AspectRatioView(self, aspectRatio: aspectRatio, contentMode: contentMode)
    }

    /// Constrains a view to maintain an aspect ratio matching that of the
    /// provided size.
    /// - Parameter aspectRatio: The aspect ratio to maintain, specified as a
    ///   size with the desired aspect ratio.
    /// - Parameter contentMode: How the view should fill available space.
    public func aspectRatio(_ aspectRatio: SIMD2<Double>, contentMode: ContentMode) -> some View {
        AspectRatioView(
            self,
            aspectRatio: LayoutSystem.aspectRatio(of: aspectRatio),
            contentMode: contentMode
        )
    }
}

struct AspectRatioView<Child: View>: TypeSafeView {
    var body: TupleView1<Child>

    var aspectRatio: Double?
    var contentMode: ContentMode

    init(_ child: Child, aspectRatio: Double?, contentMode: ContentMode) {
        body = TupleView1(child)
        self.aspectRatio = aspectRatio
        self.contentMode = contentMode
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
        let evaluatedAspectRatio: Double
        if let aspectRatio {
            evaluatedAspectRatio = aspectRatio == 0 ? 1 : aspectRatio
        } else {
            let childResult = children.child0.computeLayout(
                with: body.view0,
                proposedSize: proposedSize,
                environment: environment
            )
            evaluatedAspectRatio = childResult.size.idealAspectRatio
        }

        let proposedFrameSize = LayoutSystem.frameSize(
            forProposedSize: proposedSize,
            aspectRatio: evaluatedAspectRatio,
            contentMode: contentMode
        )

        let childResult = children.child0.computeLayout(
            with: nil,
            proposedSize: proposedFrameSize,
            environment: environment
        )

        let frameSize = LayoutSystem.frameSize(
            forProposedSize: childResult.size.size,
            aspectRatio: evaluatedAspectRatio,
            contentMode: contentMode.opposite
        )

        return ViewLayoutResult(
            size: ViewSize(
                size: frameSize,
                idealSize: LayoutSystem.frameSize(
                    forProposedSize: childResult.size.idealSize,
                    aspectRatio: evaluatedAspectRatio,
                    contentMode: .fill
                ),
                idealWidthForProposedHeight: LayoutSystem.height(
                    forWidth: frameSize.x,
                    aspectRatio: evaluatedAspectRatio
                ),
                idealHeightForProposedWidth: LayoutSystem.width(
                    forHeight: frameSize.y,
                    aspectRatio: evaluatedAspectRatio
                ),
                // TODO: These minimum and maximum size calculations are
                // incorrect. I don't think we have enough information to
                // compute these properly at the moment because the `minimumWidth`
                // and `minimumHeight` properties are the minimum sizes assuming
                // that the other dimension stays constant, which isn't very
                // useful when trying to maintain aspect ratio.
                minimumWidth: childResult.size.minimumWidth,
                minimumHeight: childResult.size.minimumHeight,
                maximumWidth: childResult.size.maximumWidth,
                maximumHeight: childResult.size.maximumHeight
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
        // Center child in frame for cases where it's smaller or bigger than
        // aspect ratio locked frame (not all views can achieve every aspect
        // ratio).
        let childResult = children.child0.commit()
        print(childResult.size.size)
        let childPosition = Alignment.center.position(
            ofChild: childResult.size.size,
            in: layout.size.size
        )
        backend.setPosition(ofChildAt: 0, in: widget, to: childPosition)
        backend.setSize(of: widget, to: layout.size.size)
    }
}
