#if !os(WASI)
    import Foundation
#endif

/// A scene that presents a single window.
public struct Window<Content: View>: Scene {
    public typealias Node = WindowNode<Content>

    var windowInfo: WindowInfo<Content>
    var id: String
    var launchBehavior: SceneLaunchBehavior = .automatic

    public var commands: Commands = .empty

    /// Creates a window scene specifying a title and an ID.
    public init(
        _ title: String,
        id: String,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.id = id
        self.windowInfo = WindowInfo(title: title, content: content)
    }

    /// Sets the default size of a window (used when creating new instances of
    /// the window).
    public func defaultSize(width: Int, height: Int) -> Self {
        var window = self
        window.windowInfo.defaultSize = SIMD2(width, height)
        return window
    }

    /// Sets the resizability of a window.
    public func windowResizability(_ resizability: WindowResizability) -> Self {
        var window = self
        window.windowInfo.resizability = resizability
        return window
    }

    /// Sets the default launch behavior of a window.
    public func defaultLaunchBehavior(
        _ launchBehavior: SceneLaunchBehavior
    ) -> Self {
        var window = self
        window.launchBehavior = launchBehavior
        return window
    }
}

/// The ``SceneGraphNode`` corresponding to a ``Window`` scene.
public final class WindowNode<Content: View>: SceneGraphNode {
    public typealias NodeScene = Window<Content>

    /// The reference to the underlying window object, which also manages
    /// the window's view graph.
    ///
    /// `nil` if the window is closed.
    private var windowReference: WindowReference<Content>? = nil

    public init<Backend: AppBackend>(
        from scene: Window<Content>,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        let openOnAppLaunch = switch scene.launchBehavior {
            case .presented: true
            case .automatic, .suppressed: false
        }

        if openOnAppLaunch {
            self.windowReference = WindowReference(
                info: scene.windowInfo,
                backend: backend,
                environment: environment,
                dismissWindowAction: { self.windowReference = nil }
            )
        }

        windowOpenFunctionsByID[scene.id] = {
            self.open(
                scene,
                backend: backend,
                environment: environment
            )
        }
    }

    public func update<Backend: AppBackend>(
        _ newScene: Window<Content>?,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        windowReference?.update(
            newScene?.windowInfo,
            backend: backend,
            environment: environment
        )
    }

    private func open<Backend: AppBackend>(
        _ scene: Window<Content>,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        if let windowReference {
            // the window is already open: activate it
            windowReference.activate(backend: backend)
        } else {
            // the window is not open: create a new instance
            windowReference = WindowReference(
                info: scene.windowInfo,
                backend: backend,
                environment: environment,
                dismissWindowAction: { self.windowReference = nil },
                updateImmediately: true
            )
        }
    }
}
