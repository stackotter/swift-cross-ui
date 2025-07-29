/// Required Imports
import Foundation
import Testing

@testable import SwiftCrossUI

@Suite(
    "Navigation Path Tests",
    .tags(.interface, .navPath)
)
struct NavPathTests {
    // NOTE: The Test ``CodableNavigationPath`` cannot be condensed into a parameterized test
    // or a for loop without specifiying allowed Types individually. A Macro might be useful here
    /// Makes sure that ``NavigationPath`` can retain data validating them with `compareComponents`.
    @Test(
        "Ensures that `NavigationPath` instances can be round tripped to JSON and back"
    )
    func codableNavigationPath() throws {
        /// Specifies the values that are saved into the `NavigationPath`
        let Values: [any Codable] = [
            "a",
            1,
            [1, 2, 3],
            5.0,
        ]

        // All types are required to be a type of `Codable` to permit encoding it and `Equatable` to satisfy ``compareComponents(ofType:,_:,_:)``
        /// Specifies the types used for indicating the `destinationTypes` paramater of `NavigationPath.path(destinationTypes:)`
        /// Be aware that you still need to add a new expect block for each unique value
        let Types: [any Codable.Type] =
            [
                String.self, Int.self, [Int].self, Double.self,
            ] as! [any Codable.Type]

        try #require(
            Values.count == Types.count,
            """
            Test `CodableNavigationPath` is Malformed.
            `Values` and `Types` must have a 1 to 1 match-up
            """
        )

        var path = NavigationPath()
        for value in Values {
            path.append(value)
        }

        let components = path.path(destinationTypes: Types)

        let encoded = try JSONEncoder().encode(path)
        let decodedPath = try JSONDecoder().decode(NavigationPath.self, from: encoded)

        let decodedComponents = decodedPath.path(destinationTypes: Types)

        try #require(
            decodedComponents.count == components.count,
            "`decodedComponents` and `components` are inconsitently sized"
        )

        #expect(
            Self.compareComponents(ofType: String.self, components[0], decodedComponents[0]),
            "An Issue with Navigation path data retainment occured"
        )
        #expect(
            Self.compareComponents(ofType: Int.self, components[1], decodedComponents[1]),
            "An Issue with Navigation path data retainment occured"
        )
        #expect(
            Self.compareComponents(ofType: [Int].self, components[2], decodedComponents[2]),
            "An Issue with Navigation path data retainment occured"
        )
        #expect(
            Self.compareComponents(ofType: Double.self, components[3], decodedComponents[3]),
            "An Issue with Navigation path data retainment occured"
        )
    }

    // Note: consider making compareComponents not require a type input
    static func compareComponents<T>(
        ofType type: T.Type, _ original: Any, _ decoded: Any
    ) -> Bool where T: Equatable {
        guard
            let original = original as? T,
            let decoded = decoded as? T
        else {
            return false
        }

        return original == decoded
    }
}

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
