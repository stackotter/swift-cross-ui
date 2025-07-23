import Testing

@testable import SwiftCrossUI

#if canImport(AppKitBackend)
    @testable import AppKitBackend
#elseif canImport(DefaultBackend)
    /// Is this close enough to a "Mock Backend"?
    @testable import AppKitBackend
#endif

enum BackendTestError: Error, LocalizedError {
    case FailedBitmapBack
    case FailedTiffRep

    var errorDescription: String? {
        switch self {
        case .FailedBitmapBack: "Failed to create bitmap backing"
        case .FailedTiffRep: "Failed to create tiff representation"
        }
    }
}

@Suite("Validate that the Backend can be interacted with")
struct BackendTests {
    #if canImport(AppKitBackend)
        // TODO: Create mock backend so that this can be tested on all platforms. There's
        //       nothing AppKit-specific about it.

        @Test("Validates Observation will not give up the thread entirely when sleeping the thread")
        func ThrottledStateObservation() async {
            /// This already exists in another test
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
            #expect(
                ratio <= 0.85,
                """
                Expected throttled updates to take under 85% of the main \
                thread's time. Took \(Int(ratio * 100))%

                Duration: \(elapsed), \(start) <=> \(end)
                Updates: \(updateCount.count)/\(mutationCount)
                """
            )
        }

        @Test("A Basic Layout Works properly")
        @MainActor
        func BasicLayout() async throws {
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

            // MARK: This Might be a logic error as `result` was proposed a Size of `SIMD2(200, 200)`, the maximum alloted to it's parent window
            #expect(
                result.size == ViewSize(fixedSize: SIMD2(92, 96)),
                """
                View update result mismatch
                \(result.size) != \(SIMD2(92, 96))
                """
            )

            #expect(
                result.preferences.onOpenURL == nil,
                "`onOpenURL` not `nil` it was not set yet"
            )
        }

        /// Unused Test Function
        @MainActor
        static func snapshotView(_ view: NSView) throws(TestError) -> Data {
            view.wantsLayer = true
            view.layer?.backgroundColor = CGColor.white

            guard let bitmap = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
                throw .FailedBitmapBack
            }

            view.cacheDisplay(in: view.bounds, to: bitmap)

            guard let data = bitmap.tiffRepresentation else {
                throw .FailedTiffRep
            }

            return data
        }
    #endif
}