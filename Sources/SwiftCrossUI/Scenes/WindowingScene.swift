protocol WindowingScene: Scene {
    associatedtype Content: View
    var title: String { get }
    var content: () -> Content { get }
}
