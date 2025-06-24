import XCTest

@testable import SwiftCrossUI

#if canImport(AppKitBackend)
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

struct XCTError: LocalizedError {
    var message: String

    var errorDescription: String? {
        message
    }
}

final class SwiftCrossUITests: XCTestCase {
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

        XCTAssert(Self.compareComponents(ofType: String.self, components[0], decodedComponents[0]))
        XCTAssert(Self.compareComponents(ofType: Int.self, components[1], decodedComponents[1]))
        XCTAssert(Self.compareComponents(ofType: [Int].self, components[2], decodedComponents[2]))
        XCTAssert(Self.compareComponents(ofType: Double.self, components[3], decodedComponents[3]))
    }

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

    func testStateObservation() {
        class NestedState: SwiftCrossUI.ObservableObject {
            @SwiftCrossUI.Published
            var count = 0
        }

        class MyState: SwiftCrossUI.ObservableObject {
            @SwiftCrossUI.Published
            var count = 0
            @SwiftCrossUI.Published
            var publishedNestedState = NestedState()
            var unpublishedNestedState = NestedState()
        }

        let state = MyState()
        var observedChange = false
        let cancellable = state.didChange.observe {
            observedChange = true
        }

        // Ensures that published value type mutation triggers observation
        observedChange = false
        state.count += 1
        XCTAssert(observedChange, "Expected value type mutation to trigger observation")

        // Ensure that published nested ObservableObject triggers observation
        observedChange = false
        state.publishedNestedState.count += 1
        XCTAssert(observedChange, "Expected nested published observable object mutation to trigger observation")

        // Ensure that replacing published nested ObservableObject triggers observation
        observedChange = false
        state.publishedNestedState = NestedState()
        XCTAssert(observedChange, "Expected replacing nested published observable object to trigger observation")

        // Ensure that replaced published nested ObservableObject triggers observation
        observedChange = false
        state.publishedNestedState.count += 1
        XCTAssert(observedChange, "Expected replaced nested published observable object mutation to trigger observation")

        // Ensure that non-published nested ObservableObject doesn't trigger observation
        observedChange = false
        state.unpublishedNestedState.count += 1
        XCTAssert(!observedChange, "Expected nested unpublished observable object mutation to not trigger observation")

        // Ensure that cancelling the observation prevents future observations
        cancellable.cancel()
        observedChange = false
        state.count += 1
        XCTAssert(!observedChange, "Expected mutation not to trigger cancelled observation")
    }

    #if canImport(AppKitBackend)
        // TODO: Create mock backend so that this can be tested on all platforms. There's
        //   nothing AppKit-specific about it.
        func testThrottledStateObservation() async {
            class MyState: SwiftCrossUI.ObservableObject {
                @SwiftCrossUI.Published
                var count = 0
            }

            /// A thread-safe count.
            actor Count {
                var count = 0

                func update(_ action: (Int) -> Int) {
                    count = action(count)
                }
            }

            // Number of mutations to perform
            let mutationCount = 20
            // Length of each fake state update
            let updateDuration = 0.02
            // Delay between observation-causing state mutations
            let mutationGap = 0.01

            let state = MyState()
            let updateCount = Count()

            let backend = await AppKitBackend()
            let cancellable = state.didChange.observeAsUIUpdater(backend: backend) {
                Task {
                    await updateCount.update { $0 + 1 }
                }
                // Simulate an update of duration `updateDuration` seconds
                Thread.sleep(forTimeInterval: updateDuration)
            }
            _ = cancellable // Silence warning about cancellable being unused

            let start = ProcessInfo.processInfo.systemUptime
            for _ in 0..<mutationCount {
                state.count += 1
                try? await Task.sleep(for: .seconds(mutationGap))
            }
            let elapsed = ProcessInfo.processInfo.systemUptime - start

            // Compute percentage of main thread's time taken up by updates.
            let ratio = Double(await updateCount.count) * updateDuration / elapsed
            XCTAssert(
                ratio <= 0.85,
                """
                Expected throttled updates to take under 85% of the main \
                thread's time. Took \(Int(ratio * 100))%
                """
            )
        }

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

            let result = viewGraph.update(
                proposedSize: SIMD2(200, 200),
                environment: environment,
                dryRun: false
            )
            let view: AppKitBackend.Widget = viewGraph.rootNode.widget.into()
            backend.setSize(of: view, to: result.size.size)
            backend.setSize(ofWindow: window, to: result.size.size)

            XCTAssertEqual(
                result.size,
                ViewSize(fixedSize: SIMD2(92, 96)),
                "View update result mismatch"
            )

            XCTAssert(
                result.preferences.onOpenURL == nil,
                "onOpenURL not nil"
            )
        }

        @MainActor
        static func snapshotView(_ view: NSView) throws -> Data {
            view.wantsLayer = true
            view.layer?.backgroundColor = CGColor.white

            guard let bitmap = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
                throw XCTError(message: "Failed to create bitmap backing")
            }

            view.cacheDisplay(in: view.bounds, to: bitmap)

            guard let data = bitmap.tiffRepresentation else {
                throw XCTError(message: "Failed to create tiff representation")
            }

            return data
        }
    #endif
}
