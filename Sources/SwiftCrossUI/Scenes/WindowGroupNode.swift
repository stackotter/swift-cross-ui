/// The ``SceneGraphNode`` corresponding to a ``WindowGroup`` scene. Holds
/// the scene's view graph and window handle.
public final class WindowGroupNode<Content: View>: SceneGraphNode {
    public typealias NodeScene = WindowGroup<Content>

    /// The node's scene.
    private var scene: WindowGroup<Content>
    /// The view graph of the window group's root view. Will need to be multiple
    /// view graphs once having multiple copies of a window is supported.
    private var viewGraph: ViewGraph<Content>
    /// The window that the group is getting rendered in. Will need to be multiple
    /// windows once having multiple copies of a window is supported.
    private var window: Any
    /// `false` after the first scene update.
    private var isFirstUpdate = true
    /// The environment most recently provided by this node's parent scene.
    private var parentEnvironment: Environment

    public init<Backend: AppBackend>(
        from scene: WindowGroup<Content>,
        backend: Backend,
        environment: Environment
    ) {
        self.scene = scene
        viewGraph = ViewGraph(for: scene.body, backend: backend, environment: environment)
        let window = backend.createWindow(withDefaultSize: scene.defaultSize)
        let rootWidget = viewGraph.rootNode.concreteNode(for: Backend.self).widget
        backend.setChild(ofWindow: window, to: rootWidget)
        backend.setTitle(ofWindow: window, to: scene.title)
        backend.setResizability(ofWindow: window, to: scene.resizability.isResizable)

        self.window = window
        parentEnvironment = environment

        backend.setResizeHandler(ofWindow: window) { [weak self] newSize in
            guard let self else { return .zero }
            _ = self.update(
                nil,
                proposedWindowSize: newSize,
                backend: backend,
                environment: parentEnvironment
            )
            return newSize
        }
    }

    public func update<Backend: AppBackend>(
        _ newScene: WindowGroup<Content>?,
        backend: Backend,
        environment: Environment
    ) {
        guard let window = window as? Backend.Window else {
            fatalError("Scene updated with a backend incompatible with the window it was given")
        }

        _ = update(
            newScene,
            proposedWindowSize: backend.size(ofWindow: window),
            backend: backend,
            environment: environment
        )
    }

    public func update<Backend: AppBackend>(
        _ newScene: WindowGroup<Content>?,
        proposedWindowSize: SIMD2<Int>,
        backend: Backend,
        environment: Environment
    ) -> ViewUpdateResult {
        guard let window = window as? Backend.Window else {
            fatalError("Scene updated with a backend incompatible with the window it was given")
        }

        parentEnvironment = environment

        if let newScene = newScene {
            // Don't set default size even if it has changed. We only set that once
            // at window creation since some backends don't have a concept of
            // 'default' size which would mean that setting the default size every time
            // the default size changed would resize the window (which is incorrect
            // behaviour).
            backend.setTitle(ofWindow: window, to: newScene.title)
            backend.setResizability(ofWindow: window, to: newScene.resizability.isResizable)
            scene = newScene
        }

        let contentSize = viewGraph.update(
            with: newScene?.body,
            proposedSize: proposedWindowSize,
            environment: environment.with(\.onResize) { [weak self] newContentSize in
                guard let self = self else { return }
                self.updateSize(of: window, backend: backend, contentSize: newContentSize)
            }
        )

        updateSize(of: window, backend: backend, contentSize: contentSize)

        if isFirstUpdate {
            backend.show(window: window)
            isFirstUpdate = false
        }

        return contentSize
    }

    public func updateSize<Backend: AppBackend>(
        of window: Backend.Window,
        backend: Backend,
        contentSize: ViewUpdateResult
    ) {
        if scene.resizability.isResizable {
            backend.setMinimumSize(
                ofWindow: window,
                to: SIMD2(
                    contentSize.minimumWidth,
                    contentSize.minimumHeight
                )
            )
        } else {
            backend.setSize(ofWindow: window, to: contentSize.size)
        }
    }
}
