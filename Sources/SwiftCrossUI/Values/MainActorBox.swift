@MainActor
struct MainActorBox<T>: Sendable {
    var value: T
}
