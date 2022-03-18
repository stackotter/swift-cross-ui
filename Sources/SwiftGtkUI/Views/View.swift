import Foundation

/// A view that can be displayed by SwiftGtkUI.
public protocol View {
    /// The view's contents.
    @ViewBuilder var body: [View] { get }
}

protocol _View {
    func build() -> _ViewGraphNode
    func update(_ node: inout _ViewGraphNode)
}
