public struct ZStack<Content: View>: View {
    public var body: Content

    public init(@ViewBuilder content: () -> Content) {
        self.init(content: content())
    }

    public init(content: Content) {
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
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        var childSizes: [ViewSize] = []
        for child in layoutableChildren(backend: backend, children: children) {
            let childSize = child.update(
                proposedSize: proposedSize,
                environment: environment,
                dryRun: dryRun
            )
            childSizes.append(childSize)
        }

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
                let position = (size.size &- childSize.size) / 2
                backend.setPosition(ofChildAt: i, in: widget, to: position)
            }
        }

        return size
    }
}
