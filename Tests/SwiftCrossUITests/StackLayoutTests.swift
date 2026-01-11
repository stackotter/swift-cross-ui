import Testing

import DummyBackend
@testable import SwiftCrossUI

@Suite("Testing for stack layouts")
struct StackLayoutTests {
    @MainActor
    @Test("Empty ScrollView should still be greedy in stack (#328)")
    func emptyScrollViewInStack() {
        let backend = DummyBackend()
        let window = backend.createWindow(withDefaultSize: nil)
        let environment = EnvironmentValues(backend: backend).with(\.window, window)

        let view = VStack {
            Text("Dummy")
            ScrollView {}
        }

        let height = 200.0
        let node = ViewGraphNode(for: view, backend: backend, environment: environment)
        let result = node.computeLayout(
            proposedSize: ProposedViewSize(100, height),
            environment: environment
        )

        #expect(result.size.height == height)
    }
}
