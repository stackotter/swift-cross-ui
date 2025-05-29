public struct ZStack<Content: View>: View {
    public var alignment: Alignment
    public var body: Content

    public init(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            content: content()
        )
    }

    init(alignment: Alignment, content: Content) {
        self.alignment = alignment
        body = content
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        let zStack = backend.createContainer()
        for child in children.widgets(for: backend) {
            backend.addChild(child, to: zStack)
        }
        return zStack
    }

    public func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let childResults = layoutableChildren(backend: backend, children: children)
            .map { child in
                child.computeLayout(
                    proposedSize: proposedSize,
                    environment: environment
                )
            }

        let childSizes = childResults.map(\.size)
        let size = ViewSize(
            size: SIMD2(
                childSizes.map(\.size.x).max() ?? 0,
                childSizes.map(\.size.y).max() ?? 0
            ),
            idealSize: SIMD2(
                childSizes.map(\.idealSize.x).max() ?? 0,
                childSizes.map(\.idealSize.y).max() ?? 0
            ),
            minimumWidth: childSizes.map(\.minimumWidth).max() ?? 0,
            minimumHeight: childSizes.map(\.minimumHeight).max() ?? 0,
            maximumWidth: childSizes.map(\.maximumWidth).max() ?? 0,
            maximumHeight: childSizes.map(\.maximumHeight).max() ?? 0
        )

        return ViewLayoutResult(size: size, childResults: childResults)
    }

    public func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        let size = layout.size
        let children = layoutableChildren(backend: backend, children: children)
            .map { child in
                child.commit()
            }

        for (i, child) in children.enumerated() {
            let position = alignment.position(
                ofChild: child.size.size,
                in: size.size
            )
            backend.setPosition(ofChildAt: i, in: widget, to: position)
        }

        backend.setSize(of: widget, to: size.size)
    }
}
