/// A persistent representation of a scene that maintains its state even when the scene
/// itself gets recomputed. Required to store view graphs and widget handles etc.
///
/// Treat scenes as basic data structures that simply encode the structure of the app;
/// the actual rendering and logic is handled by the node.
public protocol SceneGraphNode: AnyObject {
    /// The type of scene managed by this node.
    associatedtype NodeScene: Scene where NodeScene.Node == Self

    /// Creates a node from a corresponding scene. Should perform initial setup of
    /// any widgets required to display the scene (although ``SceneGraphNode/update(_:)``
    /// is guaranteed to be called immediately after initialization).
    init<Backend: AppBackend>(from scene: NodeScene, backend: Backend)

    /// Unlike views (which have state), scenes are only ever updated when they're
    /// recomputed or immediately after they're created.
    /// - Parameters:
    ///   - newScene: The new recomputed scene if the update is due to being recomputed.
    ///   - backend: The backend to use.
    func update<Backend: AppBackend>(_ newScene: NodeScene?, backend: Backend)
}
