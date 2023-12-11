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
        backend: Backend
    ) {
        viewGraph = ViewGraph(for: scene.body, backend: backend)
        let window = backend.createWindow(withDefaultSize: scene.defaultSize)
        let rootWidget = viewGraph.rootNode.concreteNode(for: Backend.self).widget
        backend.setChild(ofWindow: window, to: rootWidget)
        backend.setTitle(ofWindow: window, to: scene.title)
        backend.setResizability(ofWindow: window, to: scene.resizable)
        self.window = window
    }

    public func update<Backend: AppBackend>(_ newScene: WindowGroup<Content>?, backend: Backend) {
        guard let window = window as? Backend.Window else {
            fatalError("Scene updated with a backend incompatible with the window it was given")
        }

        if let newScene = newScene {
            viewGraph.update(newScene.body)

            // Don't set default size even if it has changed. We only set that once
            // at window creation since some backends don't have a concept of
            // 'default' size which would mean that setting the default size every time
            // the default size changed would resize the window (which is incorrect
            // behaviour).
            backend.setTitle(ofWindow: window, to: newScene.title)
            backend.setResizability(ofWindow: window, to: newScene.resizable)
        }

        backend.show(window: window)
    }
}
