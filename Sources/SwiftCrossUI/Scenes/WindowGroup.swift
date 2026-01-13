#if !os(WASI)
    import Foundation
#endif

/// A scene that presents a group of identically structured windows. Currently
/// only supports having a single instance of the window but will eventually
/// support duplicating the window.
public struct WindowGroup<Content: View>: Scene {
    public typealias Node = WindowGroupNode<Content>

    var windowInfo: WindowInfo<Content>
    var id: String?

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
}

/// The ``SceneGraphNode`` corresponding to a ``WindowGroup`` scene.
public final class WindowGroupNode<Content: View>: SceneGraphNode {
    public typealias NodeScene = WindowGroup<Content>

    /// The references to the underlying window objects, which also manage
    /// each window's view graph.
    ///
    /// Empty if there are currently no instances of the window.
    private var windowReferences: [UUID: WindowReference<Content>] = [:]

    /// The underlying scene.
    private var scene: WindowGroup<Content>

    public init<Backend: AppBackend>(
        from scene: WindowGroup<Content>,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        self.scene = scene

        let openOnAppLaunch = switch environment.defaultLaunchBehavior {
            case .automatic, .presented: true
            case .suppressed: false
        }

        if openOnAppLaunch {
            let windowID = UUID()
            self.windowReferences = [
                windowID: WindowReference(
                    info: scene.windowInfo,
                    backend: backend,
                    environment: environment,
                    onClose: { self.windowReferences[windowID] = nil }
                )
            ]
        }

        setOpenFunction(for: scene, backend: backend, environment: environment)
    }

    public func update<Backend: AppBackend>(
        _ newScene: WindowGroup<Content>?,
        backend: Backend,
        environment: EnvironmentValues
    ) -> SceneUpdateResult {
        if let newScene {
            self.scene = newScene
        }

        setOpenFunction(for: scene, backend: backend, environment: environment)

        let results = windowReferences.values.map { windowReference in
            windowReference.update(
                newScene?.windowInfo,
                backend: backend,
                environment: environment
            )
        }
        return SceneUpdateResult(childResults: results)
    }

    private func setOpenFunction<Backend: AppBackend>(
        for scene: WindowGroup<Content>,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        if let id = scene.id {
            OpenWindowAction.openFunctionsByID[id] = { [weak self] in
                guard let self else { return }

                let windowID = UUID()
                windowReferences[windowID] = WindowReference(
                    info: scene.windowInfo,
                    backend: backend,
                    environment: environment,
                    onClose: { self.windowReferences[windowID] = nil },
                    updateImmediately: true
                )
            }
        }
    }
}
