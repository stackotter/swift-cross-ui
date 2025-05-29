/// A container view that allows its content to read the size proposed to it.
///
/// Geometry readers always take up the size proposed to them; no more, no less.
/// This is to decouple the geometry reader's size from the size of its content
/// in order to avoid feedback loops.
///
/// ```swift
/// struct MeasurementView: View {
///     var body: some View {
///         GeometryReader { proxy in
///             Text("Width: \(proxy.size.x)")
///             Text("Height: \(proxy.size.y)")
///         }
///     }
/// }
/// ```
///
/// > Note: Geometry reader content may get evaluated multiple times with various
/// > sizes before the layout system settles on a size. Do not depend on the size
/// > proposal always being final.
public struct GeometryReader<Content: View>: TypeSafeView, View {
    var content: (GeometryProxy) -> Content

    public var body = EmptyView()

    public init(@ViewBuilder content: @escaping (GeometryProxy) -> Content) {
        self.content = content
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> GeometryReaderChildren<Content> {
        GeometryReaderChildren()
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: GeometryReaderChildren<Content>
    ) -> [LayoutSystem.LayoutableChild] {
        []
    }

    func asWidget<Backend: AppBackend>(
        _ children: GeometryReaderChildren<Content>,
        backend: Backend
    ) -> Backend.Widget {
        // This is a little different to our usual wrapper implementations
        // because we want to avoid calling the user's content closure before
        // we actually have to.
        return backend.createContainer()
    }

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: GeometryReaderChildren<Content>,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let view = content(GeometryProxy(size: proposedSize))

        let environment = environment.with(\.layoutAlignment, .leading)

        let contentNode: AnyViewGraphNode<Content>
        if let node = children.node {
            contentNode = node
        } else {
            contentNode = AnyViewGraphNode(
                for: view,
                backend: backend,
                environment: environment
            )
            children.node = contentNode

            // It's ok to add the child here even though it's not a dry run
            // because this is guaranteed to only happen once. Dry runs are
            // more about 'commit' actions that happen every single update.
            backend.addChild(contentNode.widget.into(), to: widget)
        }

        // TODO: Look into moving this to the final non-dry run update. In order
        //   to do so we'd have to give up on preferences being allowed to affect
        //   layout (which is probably something we don't want to support anyway
        //   because it sounds like feedback loop central).
        let contentResult = contentNode.computeLayout(
            with: view,
            proposedSize: proposedSize,
            environment: environment
        )

        return ViewLayoutResult(
            size: ViewSize(
                size: proposedSize,
                idealSize: SIMD2(10, 10),
                minimumWidth: 0,
                minimumHeight: 0,
                maximumWidth: nil,
                maximumHeight: nil
            ),
            childResults: [contentResult]
        )
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: GeometryReaderChildren<Content>,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        _ = children.node?.commit()
        backend.setPosition(ofChildAt: 0, in: widget, to: .zero)
        backend.setSize(of: widget, to: layout.size.size)
    }
}

class GeometryReaderChildren<Content: View>: ViewGraphNodeChildren {
    var node: AnyViewGraphNode<Content>?

    var widgets: [AnyWidget] {
        [node?.widget].compactMap { $0 }
    }

    var erasedNodes: [ErasedViewGraphNode] {
        [node.map(ErasedViewGraphNode.init(wrapping:))].compactMap { $0 }
    }
}
