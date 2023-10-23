/// The ``SceneGraphNode`` corresponding to a ``WindowGroup`` scene. Holds
/// the scene's view graph and window handle.
public final class WindowGroupNode<Content: View>: SceneGraphNode {
    public typealias NodeScene = WindowGroup<Content>

    /// The view graph of the window group's root view. Will need to be multiple
    /// view graphs once having multiple copies of a window is supported.
    private var viewGraph: ViewGraph<Content>
    /// The window that the group is getting rendered in. Will need to be multiple
    /// windows once having multiple copies of a window is supported.
    private var window: Any

    public init<Backend: AppBackend>(
        from scene: WindowGroup<Content>,
        backend: Backend,
        rootWindow: Backend.Window
    ) {
        viewGraph = ViewGraph(for: scene.body, backend: backend)
        let rootWidget = viewGraph.rootNode.concreteNode(for: Backend.self).widget
        backend.setChild(ofWindow: rootWindow, to: rootWidget)
        window = rootWindow
    }

    public func update<Backend: AppBackend>(_ newScene: WindowGroup<Content>?, backend: Backend) {
        if let newScene = newScene {
            viewGraph.update(newScene.body)
        }

        guard let window = window as? Backend.Window else {
            fatalError("Scene updated with a backend incompatible with the window it was given")
        }

        backend.show(window: window)
    }
}
