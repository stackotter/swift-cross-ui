#if !os(WASI)
    import Foundation
#endif

/// A scene that presents a group of identically structured windows. Currently
/// only supports having a single instance of the window but will eventually
/// support duplicating the window.
public struct WindowGroup<Content: View>: Scene {
    public typealias Node = WindowGroupNode<Content>

    public var commands: Commands = .empty

    var windowInfo: WindowInfo<Content>
    var id: String?
    var launchBehavior: SceneLaunchBehavior = .automatic

    /// Creates a window group optionally specifying a title and an ID. Window title
    /// defaults to `ProcessInfo.processInfo.processName`.
    public init(
        _ title: String? = nil,
        id: String? = nil,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        #if os(WASI)
            let title = title ?? "Title"
        #else
            let title = title ?? ProcessInfo.processInfo.processName
        #endif
        self.id = id
        self.windowInfo = WindowInfo(title: title, content: content)
    }

    /// Sets the default size of a window (used when creating new instances of
    /// the window).
    public func defaultSize(width: Int, height: Int) -> Self {
        var windowGroup = self
        windowGroup.windowInfo.defaultSize = SIMD2(width, height)
        return windowGroup
    }

    /// Sets the resizability of a window.
    public func windowResizability(_ resizability: WindowResizability) -> Self {
        var windowGroup = self
        windowGroup.windowInfo.resizability = resizability
        return windowGroup
    }

    /// Sets the default launch behavior of a window.
    public func defaultLaunchBehavior(
        _ launchBehavior: SceneLaunchBehavior
    ) -> Self {
        var windowGroup = self
        windowGroup.launchBehavior = launchBehavior
        return windowGroup
    }
}

/// The ``SceneGraphNode`` corresponding to a ``WindowGroup`` scene.
public final class WindowGroupNode<Content: View>: SceneGraphNode {
    public typealias NodeScene = WindowGroup<Content>

    /// The references to the underlying window objects, which also manages
    /// each window's view graph.
    ///
    /// Empty if there are currently no instances of the window.
    private var windowReferences: [UUID: WindowReference<Content>] = [:]

    public init<Backend: AppBackend>(
        from scene: WindowGroup<Content>,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        let openOnAppLaunch = switch scene.launchBehavior {
            case .automatic, .presented: true
            case .suppressed: false
        }

        if openOnAppLaunch {
            let id = UUID()
            self.windowReferences = [
                id: WindowReference(
                    info: scene.windowInfo,
                    backend: backend,
                    environment: environment,
                    dismissWindowAction: { self.windowReferences[id] = nil }
                )
            ]
        }

        if let id = scene.id {
            windowOpenFunctionsByID[id] = {
                self.open(
                    scene,
                    backend: backend,
                    environment: environment
                )
            }
        }
    }

    public func update<Backend: AppBackend>(
        _ newScene: WindowGroup<Content>?,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        for (id, windowReference) in windowReferences {
            windowReference.update(
                newScene?.windowInfo,
                backend: backend,
                environment: environment
            )
        }
    }

    private func open<Backend: AppBackend>(
        _ scene: WindowGroup<Content>,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        let id = UUID()
        windowReferences[id] = WindowReference(
            info: scene.windowInfo,
            backend: backend,
            environment: environment,
            dismissWindowAction: { self.windowReferences[id] = nil },
            updateImmediately: true
        )
    }
}
