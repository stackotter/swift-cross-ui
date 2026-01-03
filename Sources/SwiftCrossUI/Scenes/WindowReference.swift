/// Holds the view graph and window handle for a single window.
@MainActor
final class WindowReference<Content: View> {
    /// The window info.
    var info: WindowInfo<Content>
    /// The view graph of the window's root view.
    private var viewGraph: ViewGraph<Content>
    /// The window being rendered in.
    private var window: AnyObject
    /// `false` after the first scene update.
    private var isFirstUpdate = true
    /// The environment most recently provided by this node's parent scene.
    private var parentEnvironment: EnvironmentValues
    /// The container used to center the root view in the window.
    private var containerWidget: AnyWidget

    /// The action to assign to ``EnvironmentValues/dismissWindow``.
    ///
    /// This also gets called when the backend closes the window of its own
    /// accord, e.g. when the close button in the title bar is clicked.
    ///
    /// This action should dispose of the wrapping scene's reference to this
    /// `WindowReference` such that `deinit` is called by the runtime.
    private var dismissWindowAction: @Sendable @MainActor () -> Void
    /// The function to call when this object's `deinit` is called by the
    /// runtime.
    ///
    /// This asks the backend to close the window.
    private var onDeinit: @Sendable @MainActor () -> Void

    /// - Parameters:
    ///   - dismissWindowAction: The action to assign to
    ///     ``EnvironmentValues/dismissWindow``. Should dispose of the caller's
    ///     reference to this `WindowReference` such that `deinit` is called.
    ///   - updateImmediately: Whether to call `update(_:backend:environment:)`
    ///     after performing setup. Set this to `true` if opening as a result of
    ///     ``EnvironmentValues/openWindow``.
    init<Backend: AppBackend>(
        info: WindowInfo<Content>,
        backend: Backend,
        environment: EnvironmentValues,
        dismissWindowAction: @escaping @Sendable @MainActor () -> Void,
        updateImmediately: Bool = false
    ) {
        self.info = info
        self.dismissWindowAction = dismissWindowAction
        let window = backend.createWindow(withDefaultSize: info.defaultSize)

        viewGraph = ViewGraph(
            for: info.body,
            backend: backend,
            environment: environment
                .with(\.window, window)
                .with(
                    \.dismissWindow,
                     DismissWindowAction(action: dismissWindowAction)
                )
        )
        let rootWidget = viewGraph.rootNode.concreteNode(for: Backend.self).widget
        
        let container = backend.createContainer()
        backend.addChild(rootWidget, to: container)
        self.containerWidget = AnyWidget(container)
        
        backend.setChild(ofWindow: window, to: container)
        backend.setTitle(ofWindow: window, to: info.title)
        backend.setResizability(ofWindow: window, to: info.resizability.isResizable)

        self.window = window
        parentEnvironment = environment

        self.onDeinit = { backend.close(window: window) }
        backend.setCloseHandler(ofWindow: window) { [weak self] in
            self?.dismissWindowAction()
        }

        backend.setResizeHandler(ofWindow: window) { [weak self] newSize in
            guard let self else {
                return
            }

            _ = self.update(
                self.info,
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
                self.info,
                proposedWindowSize: backend.size(ofWindow: window),
                needsWindowSizeCommit: false,
                backend: backend,
                environment: self.parentEnvironment,
                windowSizeIsFinal:
                    !backend.isWindowProgrammaticallyResizable(window)
            )
        }

        if updateImmediately {
            self.update(nil, backend: backend, environment: environment)
        }
    }

    #if compiler(>=6.2)
    isolated deinit {
        onDeinit()
    }
    #else
    deinit {
        // `isolated deinit` is a Swift 6.2 feature, so we can't use that here.
        // But we can't return from `deinit` until `onDeinit` returns (otherwise
        // things get wonky), meaning we can't just plop it in a task and call
        // it a day.
        //
        // `MainActor.assumeIsolated` at least seems to work reliably here, but
        // I'm not a fan of blindly trusting that we happen to be on the correct
        // executor when the runtime decides to call `deinit`.

        // FIXME: Find a way to mimic `isolated deinit` without `isolated deinit`
        MainActor.assumeIsolated {
            onDeinit()
        }
    }
    #endif

    func update<Backend: AppBackend>(
        _ newInfo: WindowInfo<Content>?,
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
            proposedWindowSize = (newInfo ?? info).defaultSize
            usedDefaultSize = true
        } else {
            proposedWindowSize = backend.size(ofWindow: window)
            usedDefaultSize = false
        }

        _ = update(
            newInfo,
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
        _ newInfo: WindowInfo<Content>?,
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
        
        if let newInfo {
            // Don't set default size even if it has changed. We only set that once
            // at window creation since some backends don't have a concept of
            // 'default' size which would mean that setting the default size every time
            // the default size changed would resize the window (which is incorrect
            // behaviour).
            backend.setTitle(ofWindow: window, to: newInfo.title)
            backend.setResizability(ofWindow: window, to: newInfo.resizability.isResizable)
            info = newInfo
        }
        
        let environment =
        backend.computeWindowEnvironment(window: window, rootEnvironment: environment)
            .with(\.onResize) { [weak self] _ in
                guard let self = self else { return }
                // TODO: Figure out whether this would still work if we didn't recompute the
                //   scene's body. I have a vague feeling that it wouldn't work in all cases?
                //   But I don't have the time to come up with a counterexample right now.
                _ = self.update(
                    self.info,
                    proposedWindowSize: backend.size(ofWindow: window),
                    needsWindowSizeCommit: false,
                    backend: backend,
                    environment: environment
                )
            }
            .with(\.window, window)
            .with(
                \.dismissWindow,
                 DismissWindowAction(action: dismissWindowAction)
            )

        let finalContentResult: ViewLayoutResult
        if info.resizability.isResizable {
            let minimumWindowSize = viewGraph.computeLayout(
                with: newInfo?.body,
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
                    info,
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
                with: newInfo?.body,
                proposedSize: ProposedViewSize(proposedWindowSize),
                environment: environment
            )
            if initialContentResult.size.vector != proposedWindowSize && !windowSizeIsFinal {
                return update(
                    info,
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
            backend.show(window: window)
            isFirstUpdate = false
        }
        
        return finalContentResult
    }

    func activate<Backend: AppBackend>(
        backend: Backend
    ) {
        guard let window = window as? Backend.Window else {
            fatalError("Scene updated with a backend incompatible with the window it was given")
        }
        
        backend.activate(window: window)
    }
}
