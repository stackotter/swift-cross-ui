/// A container that lays its views on top of each other.
public struct ZStack<Content: View>: View {
    /// The stack's alignment.
    public var alignment: Alignment
    /// The stack's content.
    public var body: Content

    /// Creates a ``ZStack``.
    ///
    /// - Parameters:
    ///   - alignment: The stack's alignment.
    ///   - content: The stack's content.
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

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        var childResults: [ViewUpdateResult] = []
        for child in layoutableChildren(backend: backend, children: children) {
            let childResult = child.update(
                proposedSize: proposedSize,
                environment: environment,
                dryRun: dryRun
            )
            childResults.append(childResult)
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

        if !dryRun {
            for (i, childSize) in childSizes.enumerated() {
                let position = alignment.position(
                    ofChild: childSize.size,
                    in: size.size
                )
                backend.setPosition(ofChildAt: i, in: widget, to: position)
            }
            backend.setSize(of: widget, to: size.size)
        }

        return ViewUpdateResult(size: size, childResults: childResults)
    }
}
