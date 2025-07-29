/// Required Imports
import Foundation
import Testing

@testable import SwiftCrossUI

@Suite(
    "State Tests",
    .tags(.state)
)
struct StateTests {
    @Test(
        "Validates ObservableObject observation behaviour",
        .tags(.observation)
    )
    func observableObjectObservation() {
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
        #expect(observedChange, "Expected value type mutation to trigger observation")

        // Ensure that published nested ObservableObject triggers observation
        observedChange = false
        state.publishedNestedState.count += 1
        #expect(
            observedChange,
            "Expected nested published observable object mutation to trigger observation")

        // Ensure that replacing published nested ObservableObject triggers observation
        observedChange = false
        state.publishedNestedState = NestedState()
        #expect(
            observedChange,
            "Expected replacing nested published observable object to trigger observation")

        // Ensure that replaced published nested ObservableObject triggers observation
        observedChange = false
        state.publishedNestedState.count += 1
        #expect(
            observedChange,
            "Expected replaced nested published observable object mutation to trigger observation"
        )

        // Ensure that non-published nested ObservableObject doesn't trigger observation
        observedChange = false
        state.unpublishedNestedState.count += 1
        #expect(
            !observedChange,
            "Expected nested unpublished observable object mutation to not trigger observation")

        // Ensure that cancelling the observation prevents future observations
        cancellable.cancel()
        observedChange = false
        state.count += 1
        #expect(!observedChange, "Expected mutation not to trigger cancelled observation")
    }
}
