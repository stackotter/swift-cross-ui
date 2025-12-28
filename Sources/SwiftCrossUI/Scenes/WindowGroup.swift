#if !os(WASI)
    import Foundation
#endif

/// A scene that presents a group of identically structured windows. Currently
/// only supports having a single instance of the window but will eventually
/// support duplicating the window.
public struct WindowGroup<Content: View>: Scene {
    public typealias Node = WindowGroupNode<Content>

    public var commands: Commands = .empty

    var genericWindow: GenericWindow<Content>

    /// Creates a window group optionally specifying a title. Window title
    /// defaults to `ProcessInfo.processInfo.processName`.
    public init(
        _ title: String? = nil,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        #if os(WASI)
            let title = title ?? "Title"
        #else
            let title = title ?? ProcessInfo.processInfo.processName
        #endif
        self.genericWindow = GenericWindow(
            title,
            id: nil,
            openOnAppLaunch: true,
            content
        )
    }

    /// Sets the default size of a window (used when creating new instances of
    /// the window).
    public func defaultSize(width: Int, height: Int) -> Self {
        var windowGroup = self
        windowGroup.genericWindow.defaultSize = SIMD2(width, height)
        return windowGroup
    }

    /// Sets the resizability of a window.
    public func windowResizability(_ resizability: WindowResizability) -> Self {
        var windowGroup = self
        windowGroup.genericWindow.resizability = resizability
        return windowGroup
    }

    /// Sets the default launch behavior of a window.
    public func defaultLaunchBehavior(
        _ launchBehavior: SceneLaunchBehavior
    ) -> Self {
        var window = self
        window.genericWindow.openOnAppLaunch = switch launchBehavior {
        case .automatic, .presented: true
        case .suppressed: false
        }
        return window
    }
}

/// The ``SceneGraphNode`` corresponding to a ``WindowGroup`` scene. Holds
/// the scene's view graph and window handle.
public final class WindowGroupNode<Content: View>: SceneGraphNode {
    public typealias NodeScene = WindowGroup<Content>

    private var genericWindowNode: GenericWindowNode<Content>

    public init<Backend: AppBackend>(
        from scene: WindowGroup<Content>,
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
        _ newScene: WindowGroup<Content>?,
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
