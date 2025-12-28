#if !os(WASI)
    import Foundation
#endif

/// A scene that presents a single window.
public struct Window<Content: View>: Scene {
    public typealias Node = WindowNode<Content>

    var genericWindow: GenericWindow<Content>

    public var commands: Commands { genericWindow.commands }

    /// Creates a window scene specifying a title and an ID.
    public init(
        _ title: String,
        id: String,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.genericWindow = GenericWindow(title, id: id, content)
    }

    /// Sets the default size of a window (used when creating new instances of
    /// the window).
    public func defaultSize(width: Int, height: Int) -> Self {
        var window = self
        window.genericWindow.defaultSize = SIMD2(width, height)
        return window
    }

    /// Sets the resizability of a window.
    public func windowResizability(_ resizability: WindowResizability) -> Self {
        var window = self
        window.genericWindow.resizability = resizability
        return window
    }

    /// Sets the default launch behavior of a window.
    public func defaultLaunchBehavior(
        _ launchBehavior: SceneLaunchBehavior
    ) -> Self {
        var window = self
        window.genericWindow.openOnAppLaunch = switch launchBehavior {
        case .presented: true
        case .automatic, .suppressed: false
        }
        return window
    }
}

/// The ``SceneGraphNode`` corresponding to a ``Window`` scene. Holds the
/// scene's view graph and window handle.
public final class WindowNode<Content: View>: SceneGraphNode {
    public typealias NodeScene = Window<Content>

    private var genericWindowNode: GenericWindowNode<Content>

    public init<Backend: AppBackend>(
        from scene: Window<Content>,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        self.genericWindowNode = GenericWindowNode(
            from: scene.genericWindow,
            backend: backend,
            environment: environment
        )
    }

    public func update<Backend: AppBackend>(
        _ newScene: Window<Content>?,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        genericWindowNode.update(
            newScene?.genericWindow,
            backend: backend,
            environment: environment
        )
    }
}
