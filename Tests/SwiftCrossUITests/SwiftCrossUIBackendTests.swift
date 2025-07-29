import Foundation
import Testing

@testable import SwiftCrossUI

#if canImport(AppKitBackend)
    @testable import AppKitBackend
#else
    // Consider this the mock backend for code that is not currently specialized to one backend explicitly
    @testable import DefaultBackend
#endif

// TODO: Create mock backend so that this can be tested on all platforms. There's
//       nothing AppKit-specific about it.
@Suite(
    "Testing for Graphical Backends",
    .tags(.interface, .backend)
)
struct BackendTests {
    public struct BackendTestError: Error {
        var message: String? = nil

        // These are preconfigured instances for functions with `throws(BackendTests.BackendTestError)` in the signature
        static let failedBitmapBack: Self = new("Failed to create bitmap backing")
        static let failedTiffRep: Self = new("Failed to create tiff representation")
        static let unknownIssue: Self = new()

        var errorDescription: String? {
            message ?? "Something when wrong during Backend Testing"
        }

        // Condensed Error Generator for abridging the initalizer
        static func new(_ info: String? = nil) -> Self {
            Self(message: info)
        }
    }

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

    @Test(
        "Ensures that `Publisher.observeAsUIUpdater(backend:)` throttles state update observations",
        .tags(.observation, .state)
    )
    func throttledStateObservation() async {
        class MyState: SwiftCrossUI.ObservableObject {
            @SwiftCrossUI.Published
            var count = 0
        }

        /// A thread-safe count.
        actor Count {
            var count: Int = 0

            /// Allow for the contents of Count to be manipulated with an async function
            func update(_ action: (Int) -> Int) async {
                count = action(count)
            }

            /// Allow for the contents of Count to be aquired with an async function
            func get() async -> Int {
                count
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

        let backend = await DefaultBackend()
        let cancellable = state.didChange.observeAsUIUpdater(backend: backend) {
            Task {
                await updateCount.update { $0 + 1 }
            }
            // Simulate an update of duration `updateDuration` seconds
            Thread.sleep(forTimeInterval: updateDuration)
        }
        _ = cancellable  // Silence warning about cancellable being unused

        let start = ProcessInfo.processInfo.systemUptime
        for _ in 0..<mutationCount {
            state.count += 1
            try? await Task.sleep(for: .seconds(mutationGap))
        }
        let end = ProcessInfo.processInfo.systemUptime
        let elapsed = end - start

        let count = await updateCount.get()

        // Compute percentage of main thread's time taken up by updates.
        let ratio = Double(count) * updateDuration / elapsed
        #expect(
            ratio <= 0.85,
            """
            Expected throttled updates to take under 85% of the main \
            thread's time. Took \(Int(ratio * 100))%

            Duration: \(elapsed) seconds
            Updates: \(count)/\(mutationCount)
            """
        )
    }

    #if canImport(AppKitBackend)

        @Test(
            "A Basic Layout Works properly",
            tags(.layout)
        )
        @MainActor
        func basicLayout() async throws {
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

            #expect(
                result.size == ViewSize(fixedSize: SIMD2(92, 96)),
                "View update result mismatch"
            )

            #expect(
                result.preferences.onOpenURL == nil,
                "`onOpenURL` should be `nil` as it was not set"
            )
        }

        /// Helper function to be used in future tests
        @MainActor
        static func snapshotView(_ view: NSView) throws(BackendTestError) -> Data {
            view.wantsLayer = true
            view.layer?.backgroundColor = CGColor.white

            guard let bitmap = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
                throw .failedBitmapBack
            }

            view.cacheDisplay(in: view.bounds, to: bitmap)

            guard let data = bitmap.tiffRepresentation else {
                throw .failedTiffRep
            }

            return data
        }
    #endif
}
