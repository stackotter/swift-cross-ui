// FIXME: we should make this a preference instead
var windowOpenFunctionsByID: [String: @Sendable @MainActor () -> Void] = [:]

/// The ``SceneGraphNode`` corresponding to a ``GenericWindow`` scene. Holds the
/// scene's view graph and window handle.
final class GenericWindowNode<Content: View>: SceneGraphNode {
    typealias NodeScene = GenericWindow<Content>

    /// The node's scene.
    private var scene: GenericWindow<Content>
    /// The view graph of the window's root view.
    private var viewGraph: ViewGraph<Content>
    /// The window being rendered in.
    private var window: Any
    /// `false` after the first scene update.
    private var isFirstUpdate = true
    /// The environment most recently provided by this node's parent scene.
    private var parentEnvironment: EnvironmentValues
    /// The container used to center the root view in the window.
    private var containerWidget: AnyWidget
    
    init<Backend: AppBackend>(
        from scene: GenericWindow<Content>,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        self.scene = scene
        let window = backend.createWindow(withDefaultSize: scene.defaultSize)

        // add this window to `windowOpenFunctionsByID`
        if let id = scene.id {
            windowOpenFunctionsByID[id] = { backend.show(window: window) }
        }

        viewGraph = ViewGraph(
            for: scene.body,
            backend: backend,
            environment: environment
                .with(\.window, window)
                .with(\.dismiss, DismissAction {
                    backend.close(window: window)
                })
        )
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
            guard let self else {
                return
            }

            _ = self.update(
                self.scene,
                proposedWindowSize: newSize,
                needsWindowSizeCommit: false,
                backend: backend,
                environment: self.parentEnvironment,
                windowSizeIsFinal:
                    !backend.isWindowProgrammaticallyResizable(window)
            )
        }
        
        backend.setWindowEnvironmentChangeHandler(of: window) { [weak self] in
            guard let self else {
                return
            }

            _ = self.update(
                self.scene,
                proposedWindowSize: backend.size(ofWindow: window),
                needsWindowSizeCommit: false,
                backend: backend,
                environment: self.parentEnvironment,
                windowSizeIsFinal:
                    !backend.isWindowProgrammaticallyResizable(window)
            )
        }
    }
    
    func update<Backend: AppBackend>(
        _ newScene: GenericWindow<Content>?,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        guard let window = window as? Backend.Window else {
            fatalError("Scene updated with a backend incompatible with the window it was given")
        }

        let isProgramaticallyResizable =
            backend.isWindowProgrammaticallyResizable(window)

        let proposedWindowSize: SIMD2<Int>
        let usedDefaultSize: Bool
        if isFirstUpdate && isProgramaticallyResizable {
            proposedWindowSize = (newScene ?? scene).defaultSize
            usedDefaultSize = true
        } else {
            proposedWindowSize = backend.size(ofWindow: window)
            usedDefaultSize = false
        }

        _ = update(
            newScene,
            proposedWindowSize: proposedWindowSize,
            needsWindowSizeCommit: usedDefaultSize,
            backend: backend,
            environment: environment,
            windowSizeIsFinal: !isProgramaticallyResizable
        )
    }

    /// Updates the WindowGroupNode.
    /// - Parameters:
    ///   - newScene: The scene's body if recomputed.
    ///   - proposedWindowSize: The proposed window size.
    ///   - needsWindowSizeCommit: Whether the proposed window size matches the
    ///     windows current size (or imminent size in the case of a window
    ///     resize). We use this parameter instead of comparing to the window's
    ///     current size to the proposed size, because some backends (such as
    ///     AppKitBackend) trigger window resize handlers *before* the underlying
    ///     window gets assigned its new size (allowing us to pre-emptively update the
    ///     window's content to match the new size).
    ///   - backend: The backend to use.
    ///   - environment: The current environment.
    ///   - windowSizeIsFinal: If true, no further resizes can/will be made. This
    ///     is true on platforms that don't support programmatic window resizing,
    ///     and when a window is full screen.
    func update<Backend: AppBackend>(
        _ newScene: GenericWindow<Content>?,
        proposedWindowSize: SIMD2<Int>,
        needsWindowSizeCommit: Bool,
        backend: Backend,
        environment: EnvironmentValues,
        windowSizeIsFinal: Bool = false
    ) -> ViewLayoutResult {
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
        
        let environment =
        backend.computeWindowEnvironment(window: window, rootEnvironment: environment)
            .with(\.onResize) { [weak self] _ in
                guard let self = self else { return }
                // TODO: Figure out whether this would still work if we didn't recompute the
                //   scene's body. I have a vague feeling that it wouldn't work in all cases?
                //   But I don't have the time to come up with a counterexample right now.
                _ = self.update(
                    self.scene,
                    proposedWindowSize: backend.size(ofWindow: window),
                    needsWindowSizeCommit: false,
                    backend: backend,
                    environment: environment
                )
            }
            .with(\.window, window)
            .with(\.dismiss, DismissAction { backend.close(window: window) })

        let finalContentResult: ViewLayoutResult
        if scene.resizability.isResizable {
            let minimumWindowSize = viewGraph.computeLayout(
                with: newScene?.body,
                proposedSize: .zero,
                environment: environment.with(\.allowLayoutCaching, true)
            ).size

            let clampedWindowSize = ViewSize(
                max(minimumWindowSize.width, Double(proposedWindowSize.x)),
                max(minimumWindowSize.height, Double(proposedWindowSize.y))
            )

            if clampedWindowSize.vector != proposedWindowSize && !windowSizeIsFinal {
                // Restart the window update if the content has caused the window to
                // change size.
                return update(
                    scene,
                    proposedWindowSize: clampedWindowSize.vector,
                    needsWindowSizeCommit: true,
                    backend: backend,
                    environment: environment,
                    windowSizeIsFinal: true
                )
            }

            // Set this even if the window isn't programmatically resizable
            // because the window may still be user resizable.
            backend.setMinimumSize(ofWindow: window, to: minimumWindowSize.vector)

            finalContentResult = viewGraph.computeLayout(
                proposedSize: ProposedViewSize(proposedWindowSize),
                environment: environment
            )
        } else {
            let initialContentResult = viewGraph.computeLayout(
                with: newScene?.body,
                proposedSize: ProposedViewSize(proposedWindowSize),
                environment: environment
            )
            if initialContentResult.size.vector != proposedWindowSize && !windowSizeIsFinal {
                return update(
                    scene,
                    proposedWindowSize: initialContentResult.size.vector,
                    needsWindowSizeCommit: true,
                    backend: backend,
                    environment: environment,
                    windowSizeIsFinal: true
                )
            }
            finalContentResult = initialContentResult
        }

        viewGraph.commit()

        backend.setPosition(
            ofChildAt: 0,
            in: containerWidget.into(),
            to: (proposedWindowSize &- finalContentResult.size.vector) / 2
        )

        if needsWindowSizeCommit {
            backend.setSize(ofWindow: window, to: proposedWindowSize)
        }
        
        if isFirstUpdate {
            if scene.openOnAppLaunch {
                backend.show(window: window)
            }
            isFirstUpdate = false
        }
        
        return finalContentResult
    }
}
