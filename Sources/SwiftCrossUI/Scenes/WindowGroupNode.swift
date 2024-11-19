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
    /// The container used to center the root view in the window.
    private var containerWidget: AnyWidget

    public init<Backend: AppBackend>(
        from scene: WindowGroup<Content>,
        backend: Backend,
        environment: Environment
    ) {
        self.scene = scene
        viewGraph = ViewGraph(for: scene.body, backend: backend, environment: environment)
        let window = backend.createWindow(withDefaultSize: scene.defaultSize)
        let rootWidget = viewGraph.rootNode.concreteNode(for: Backend.self).widget

        let container = backend.createContainer()
        backend.addChild(rootWidget, to: container)
        self.containerWidget = AnyWidget(container)

        backend.setChild(ofWindow: window, to: container)
        backend.setTitle(ofWindow: window, to: scene.title)
        backend.setResizability(ofWindow: window, to: scene.resizability.isResizable)

        self.window = window
        parentEnvironment = environment

        backend.setResizeHandler(ofWindow: window) { [weak self] newSize in
            guard let self else { return }
            _ = self.update(
                scene,
                proposedWindowSize: newSize,
                backend: backend,
                environment: parentEnvironment
            )
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
    ) -> ViewSize {
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

        let environment = environment.with(\.onResize) { [weak self] _ in
            guard let self = self else { return }
            // TODO: Figure out whether this would still work if we didn't recompute the
            //   scene's body. I have a vague feeling that it wouldn't work in all cases?
            //   But I don't have the time to come up with a counterexample right now.
            _ = self.update(
                scene,
                proposedWindowSize: backend.size(ofWindow: window),
                backend: backend,
                environment: environment
            )
        }

        // Perform a dry-run update of the root view to check if the window needs to
        // change size.
        let contentSize = viewGraph.update(
            with: newScene?.body,
            proposedSize: proposedWindowSize,
            environment: environment,
            dryRun: true
        )

        let newWindowSize = computeNewWindowSize(
            currentProposedSize: proposedWindowSize,
            backend: backend,
            contentSize: contentSize,
            environment: environment
        )

        // Restart the window update if the content has caused the window to
        // change size.
        if let newWindowSize {
            return update(
                scene,
                proposedWindowSize: newWindowSize,
                backend: backend,
                environment: environment
            )
        }

        _ = viewGraph.update(
            with: newScene?.body,
            proposedSize: proposedWindowSize,
            environment: environment,
            dryRun: false
        )

        if scene.resizability.isResizable {
            backend.setMinimumSize(
                ofWindow: window,
                to: SIMD2(
                    contentSize.minimumWidth,
                    contentSize.minimumHeight
                )
            )
        }

        backend.setPosition(
            ofChildAt: 0,
            in: containerWidget.into(),
            to: SIMD2(
                (proposedWindowSize.x - contentSize.size.x) / 2,
                (proposedWindowSize.y - contentSize.size.y) / 2
            )
        )

        let currentWindowSize = backend.size(ofWindow: window)
        if currentWindowSize != proposedWindowSize {
            backend.setSize(ofWindow: window, to: proposedWindowSize)
        }

        if isFirstUpdate {
            backend.show(window: window)
            isFirstUpdate = false
        }

        return contentSize
    }

    public func computeNewWindowSize<Backend: AppBackend>(
        currentProposedSize: SIMD2<Int>,
        backend: Backend,
        contentSize: ViewSize,
        environment: Environment
    ) -> SIMD2<Int>? {
        if scene.resizability.isResizable {
            if currentProposedSize.x < contentSize.minimumWidth
                || currentProposedSize.y < contentSize.minimumHeight
            {
                let newSize = SIMD2(
                    max(currentProposedSize.x, contentSize.minimumWidth),
                    max(currentProposedSize.y, contentSize.minimumHeight)
                )
                return newSize
            } else {
                return nil
            }
        } else if contentSize.size != currentProposedSize {
            return contentSize.size
        } else {
            return nil
        }
    }
}
