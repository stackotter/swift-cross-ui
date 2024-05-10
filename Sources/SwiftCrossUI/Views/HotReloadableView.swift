import Foundation

/// A view which attempts to persist the state of its view subtree even
/// when the subtree's structure changes. Uses state serialization (via
/// view graph snapshotting) to persist view state even when a child
/// view's implementation gets swapped out with an implementation from
/// a newly-loaded dylib (this is what makes this useful for hot reloading).
///
/// Only expected to be used directly by SwiftCrossUI itself or third
/// party libraries extending SwiftCrossUI's hot reloading capabilities.
public struct HotReloadableView: TypeSafeView {
    typealias Children = HotReloadableViewChildren

    public var body = EmptyView()

    var child: any View

    public init(_ child: any View) {
        self.child = child
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?
    ) -> HotReloadableViewChildren {
        let snapshot = snapshots?.count == 1 ? snapshots?.first : nil
        return HotReloadableViewChildren(from: self, backend: backend, snapshot: snapshot)
    }

    func updateChildren<Backend: AppBackend>(
        _ children: HotReloadableViewChildren, backend: Backend
    ) {
        children.update(with: self, backend: backend)
    }

    func asWidget<Backend: AppBackend>(
        _ children: HotReloadableViewChildren,
        backend: Backend
    ) -> Backend.Widget {
        return children.container.into()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: HotReloadableViewChildren,
        backend: Backend
    ) {}
}

class HotReloadableViewChildren: ViewGraphNodeChildren {
    /// The erased underlying node.
    var node: ErasedViewGraphNode
    /// The single-child container used to allow the child to be swapped
    /// out willy-nilly.
    var container: AnyWidget

    var widgets: [AnyWidget] {
        return [container]
    }

    var erasedNodes: [ErasedViewGraphNode] {
        [node]
    }

    /// Creates the erased child node and wraps the child's widget in a single-child container.
    init<Backend: AppBackend>(
        from view: HotReloadableView,
        backend: Backend,
        snapshot: ViewGraphSnapshotter.NodeSnapshot?
    ) {
        node = ErasedViewGraphNode(for: view.child, backend: backend, snapshot: snapshot)
        let container = backend.createSingleChildContainer()
        backend.setChild(ofSingleChildContainer: container, to: node.getWidget().into())
        self.container = AnyWidget(container)
    }

    /// Attempts to update the child. If the initial update succeeds then the child's concrete type
    /// hasn't changed and the ViewGraph will has handled state persistence on our behalf. Otherwise,
    /// we must recreate the child node and swap out our current child widget with the new view's
    /// widget. Before displaying the child, we also attempt to transfer a snapshot of the old
    /// view graph sub tree's state onto the new view graph sub tree. This is not possible to do
    /// perfectly by definition, so if we can't successfully transfer the state of the sub tree
    /// we just fall back on the failing view's default state.
    func update<Backend: AppBackend>(with view: HotReloadableView, backend: Backend) {
        if !node.updateWithNewView(view.child) {
            let snapshotter = ViewGraphSnapshotter()
            let snapshot = node.transform(with: snapshotter)
            node = ErasedViewGraphNode(for: view.child, backend: backend, snapshot: snapshot)
            backend.setChild(ofSingleChildContainer: container.into(), to: node.getWidget().into())
        }
    }

    static func setState<V: View>(of view: V, to data: Data) -> V {
        guard
            let decodable = V.State.self as? Codable.Type,
            let state = try? JSONDecoder().decode(decodable, from: data)
        else {
            return view
        }
        var view = view
        view.state = state as! V.State
        return view
    }
}
