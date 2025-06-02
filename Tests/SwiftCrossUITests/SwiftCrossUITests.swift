import Testing
import Foundation

@testable import SwiftCrossUI

#if canImport(AppKitBackend)
    import AppKit
    import CoreGraphics
    @testable import AppKitBackend
#endif

struct CounterView: View {
    @State var count = 0

    var body: some View {
        VStack {
            Button("Decrease") { count -= 1 }
            Text("Count: 1")
            Button("Increase") { count += 1 }
        }.padding()
    }
}

struct TestError: LocalizedError {
    var message: String

    var errorDescription: String? {
        message
    }
}

@Suite("Testing for SwiftCrossUI")
struct SwiftCrossUITests {
    @Test("Ensures that a NavigationPath can be round tripped to and from JSON")
    func testCodableNavigationPath() throws {
        var path = NavigationPath()
        path.append("a")
        path.append(1)
        path.append([1, 2, 3])
        path.append(5.0)

        let components = path.path(destinationTypes: [
            String.self, Int.self, [Int].self, Double.self,
        ])

        let encoded = try JSONEncoder().encode(path)
        let decodedPath = try JSONDecoder().decode(NavigationPath.self, from: encoded)

        let decodedComponents = decodedPath.path(destinationTypes: [
            String.self, Int.self, [Int].self, Double.self,
        ])

        #expect(Self.compareComponents(ofType: String.self, components[0], decodedComponents[0]))
        #expect(Self.compareComponents(ofType: Int.self, components[1], decodedComponents[1]))
        #expect(Self.compareComponents(ofType: [Int].self, components[2], decodedComponents[2]))
        #expect(Self.compareComponents(ofType: Double.self, components[3], decodedComponents[3]))
    }

    /// Helper function for `testCodableNavigationPath`.
    static func compareComponents<T: Equatable>(
        ofType type: T.Type, _ original: Any, _ decoded: Any
    ) -> Bool {
        guard
            let original = original as? T,
            let decoded = decoded as? T
        else {
            return false
        }

        return original == decoded
    }

    #if canImport(AppKitBackend)
        @Test("Ensure that a basic view has the expected dimensions under AppKitBackend")
        @MainActor
        func testBasicLayout() async throws {
            let backend = AppKitBackend()
            let window = backend.createWindow(withDefaultSize: SIMD2(200, 200))

            // Idea taken from https://github.com/pointfreeco/swift-snapshot-testing/pull/533
            // and implemented in AppKitBackend.
            window.backingScaleFactorOverride = 1
            window.colorSpace = .genericRGB

            let environment = EnvironmentValues(backend: backend)
                .with(\.window, window)
            let viewGraph = ViewGraph(
                for: CounterView(),
                backend: backend,
                environment: environment
            )
            backend.setChild(ofWindow: window, to: viewGraph.rootNode.widget.into())

            // We have to run this twice due to the computeLayout/commit change
            // to the View protocol. This should get neater once ViewGraph uses
            // computeLayout/commit as well instead of updates with dryRun.
            _ = viewGraph.update(
                proposedSize: SIMD2(200, 200),
                environment: environment,
                dryRun: true
            )
            let result = viewGraph.update(
                proposedSize: SIMD2(200, 200),
                environment: environment,
                dryRun: false
            )
            let view: AppKitBackend.Widget = viewGraph.rootNode.widget.into()
            backend.setSize(of: view, to: result.size.size)
            backend.setSize(ofWindow: window, to: result.size.size)

            #expect(
                result.size == ViewSize(fixedSize: SIMD2(92, 96)),
                "View update result mismatch"
            )

            #expect(
                result.preferences.onOpenURL == nil,
                "onOpenURL not nil"
            )
        }

        @Test("Ensures that basic AppKitBackend text layout works as expected")
        @MainActor
        func testTextLayout() {
            let backend = AppKitBackend()
            let text = Text("Lorem ipsum dolor sit amet")
            let widget = text.asWidget(backend: backend)
            let environment = EnvironmentValues(backend: backend)
            let children = text.children(backend: backend, snapshots: nil, environment: environment)
            let idealLayout = text.computeLayout(
                widget,
                children: children,
                proposedSize: .ideal,
                environment: environment,
                backend: backend
            )
            let fixedHeightLayout = text.computeLayout(
                widget,
                children: children,
                proposedSize: SizeProposal(idealLayout.size.size.x / 2, nil),
                environment: environment,
                backend: backend
            )
            let layout = text.computeLayout(
                widget,
                proposedSize: SizeProposal(idealLayout.size.size.x / 2, 1000),
                environment: environment,
                backend: backend
            )
            #expect(
                idealLayout.size.size.y != fixedHeightLayout.size.size.y,
                "Halving text width didn't affect text height"
            )
            #expect(fixedHeightLayout.size == layout.size, "Excess height changed text size")
        }

        @Test("Ensures that the fixedSize layout works as expected")
        @MainActor
        func testFixedSizeLayout() {
            let backend = AppKitBackend()
            let text = Text("Lorem ipsum dolor sit amet")
                .fixedSize(horizontal: false, vertical: true)
            let window = backend.createWindow(withDefaultSize: SIMD2(200, 200))
            let environment = EnvironmentValues(backend: backend)
                .with(\.window, window)
            let children = text.children(backend: backend, snapshots: nil, environment: environment)
            let widget = text.asWidget(children, backend: backend)
            let idealLayout = text.computeLayout(
                widget,
                children: children,
                proposedSize: .ideal,
                environment: environment,
                backend: backend
            )
            let fixedHeightLayout = text.computeLayout(
                widget,
                children: children,
                proposedSize: SizeProposal(idealLayout.size.size.x / 2, nil),
                environment: environment,
                backend: backend
            )
            let layout = text.computeLayout(
                widget,
                children: children,
                proposedSize: SizeProposal(idealLayout.size.size.x / 2, 1000),
                environment: environment,
                backend: backend
            )
            #expect(
                idealLayout.size.size.y != fixedHeightLayout.size.size.y,
                "Halving text width didn't affect text height"
            )
            #expect(fixedHeightLayout.size == layout.size, "Excess height changed text size")
        }

        @MainActor
        /// Snapshots an AppKit view to a TIFF image.
        static func snapshotView(_ view: NSView) throws -> Data {
            view.wantsLayer = true
            view.layer?.backgroundColor = CGColor.white

            guard let bitmap = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
                throw TestError(message: "Failed to create bitmap backing")
            }

            view.cacheDisplay(in: view.bounds, to: bitmap)

            guard let data = bitmap.tiffRepresentation else {
                throw TestError(message: "Failed to create tiff representation")
            }

            return data
        }
    #endif
}
