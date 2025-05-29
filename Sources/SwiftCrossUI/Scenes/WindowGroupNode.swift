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
    private var parentEnvironment: EnvironmentValues
    /// The container used to center the root view in the window.
    private var containerWidget: AnyWidget

    public init<Backend: AppBackend>(
        from scene: WindowGroup<Content>,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        self.scene = scene
        let window = backend.createWindow(withDefaultSize: scene.defaultSize)

        viewGraph = ViewGraph(
            for: scene.body,
            backend: backend,
            environment: environment.with(\.window, window)
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
                backend: backend,
                environment: self.parentEnvironment,
                windowSizeIsFinal:
                    !backend.isWindowProgrammaticallyResizable(window)
            )
        }
    }

    public func update<Backend: AppBackend>(
        _ newScene: WindowGroup<Content>?,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        guard let window = window as? Backend.Window else {
            fatalError("Scene updated with a backend incompatible with the window it was given")
        }

        let isProgramaticallyResizable =
            backend.isWindowProgrammaticallyResizable(window)

        _ = update(
            newScene,
            proposedWindowSize: isFirstUpdate && isProgramaticallyResizable
                ? (newScene ?? scene).defaultSize
                : backend.size(ofWindow: window),
            backend: backend,
            environment: environment,
            windowSizeIsFinal: !isProgramaticallyResizable
        )
    }

    public func update<Backend: AppBackend>(
        _ newScene: WindowGroup<Content>?,
        proposedWindowSize: SIMD2<Int>,
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
                    backend: backend,
                    environment: environment
                )
            }
            .with(\.window, window)

        let dryRunResult: ViewLayoutResult?
        if !windowSizeIsFinal {
            // Perform a dry-run update of the root view to check if the window
            // needs to change size.
            let contentResult = viewGraph.update(
                with: newScene?.body,
                proposedSize: proposedWindowSize,
                environment: environment,
                dryRun: true
            )
            dryRunResult = contentResult

            let newWindowSize = computeNewWindowSize(
                currentProposedSize: proposedWindowSize,
                backend: backend,
                contentSize: contentResult.size,
                environment: environment
            )

            // Restart the window update if the content has caused the window to
            // change size. To avoid infinite recursion, we take the view's word
            // and assume that it will take on the minimum/maximum size it claimed.
            if let newWindowSize {
                return update(
                    scene,
                    proposedWindowSize: newWindowSize,
                    backend: backend,
                    environment: environment,
                    windowSizeIsFinal: false
                )
            }
        } else {
            // We don't use this result, but we do need to do a dry run to
            // respect the assumptions of ViewGraph (each non dry run must
            // follow a dry run).
            _ = viewGraph.update(
                with: newScene?.body,
                proposedSize: proposedWindowSize,
                environment: environment,
                dryRun: true
            )

            dryRunResult = nil
        }

        let finalContentResult = viewGraph.update(
            with: newScene?.body,
            proposedSize: proposedWindowSize,
            environment: environment,
            dryRun: false
        )

        // The Gtk 3 backend has some broken sizing code that can't really be
        // fixed due to the design of Gtk 3. Our layout system underestimates
        // the size of the new view due to the button not being in the Gtk 3
        // widget hierarchy yet (which prevents Gtk 3 from computing the
        // natural sizes of the new buttons). One fix seems to be removing
        // view size reuse (currently the second check in ViewGraphNode.update)
        // and I'm not exactly sure why, but that makes things awfully slow.
        // The other fix is to add an alternative path to
        // Gtk3Backend.naturalSize(of:) for buttons that moves non-realized
        // buttons to a secondary window before measuring their natural size,
        // but that's super janky, easy to break if the button in the real
        // window is inheriting styles from its ancestors, and I'm not sure
        // how to hide the window (it's probably terrible for performance too).
        //
        // I still have no clue why this size underestimation (and subsequent
        // mis-sizing of the window) had the symptom of all buttons losing
        // their labels temporarily; Gtk 3 is a temperamental beast.
        //
        // Anyway, Gtk3Backend isn't really intended to be a recommended
        // backend so I think this is a fine solution for now (people should
        // only use Gtk3Backend if they can't use GtkBackend).
        if let dryRunResult, finalContentResult.size != dryRunResult.size {
            print(
                """
                warning: Final window content size didn't match dry-run size. This is a sign that
                         either view size caching is broken or that backend.naturalSize(of:) is 
                         broken (or both).
                      -> dryRunResult.size:       \(dryRunResult.size)
                      -> finalContentResult.size: \(finalContentResult.size)
                """
            )

            // Give the view graph one more chance to sort itself out to fail
            // as gracefully as possible.
            let newWindowSize = computeNewWindowSize(
                currentProposedSize: proposedWindowSize,
                backend: backend,
                contentSize: finalContentResult.size,
                environment: environment
            )

            if let newWindowSize {
                return update(
                    scene,
                    proposedWindowSize: newWindowSize,
                    backend: backend,
                    environment: environment,
                    windowSizeIsFinal: true
                )
            }
        }

        // Set this even if the window isn't programmatically resizable
        // because the window may still be user resizable.
        if scene.resizability.isResizable {
            backend.setMinimumSize(
                ofWindow: window,
                to: SIMD2(
                    finalContentResult.size.minimumWidth,
                    finalContentResult.size.minimumHeight
                )
            )
        }

        backend.setPosition(
            ofChildAt: 0,
            in: containerWidget.into(),
            to: SIMD2(
                (proposedWindowSize.x - finalContentResult.size.size.x) / 2,
                (proposedWindowSize.y - finalContentResult.size.size.y) / 2
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

        return finalContentResult
    }

    public func computeNewWindowSize<Backend: AppBackend>(
        currentProposedSize: SIMD2<Int>,
        backend: Backend,
        contentSize: ViewSize,
        environment: EnvironmentValues
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
        } else if contentSize.idealSize != currentProposedSize {
            return contentSize.idealSize
        } else {
            return nil
        }
    }
}
