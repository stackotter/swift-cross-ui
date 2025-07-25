import Testing

@testable import SwiftCrossUI

/// Required Imports
import Foundation

@Suite(
    "SwiftCrossUI's Internal Types",
    .tags(.Internal)
)
struct InternalTests {

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

    // NOTE: The Test ``CodableNavigationPath`` cannot be condensed into a parameterized test
    // or a for loop without specifiying allowed Types individually. A Macro might be useful here
    /// Makes sure that ``NavigationPath`` can retain data validating them with `compareComponents`.
    @Test(
        "The Codable NavigationPath can accurately store Codable data",
        .tags(.NavPath)
    )
    func CodableNavigationPath() throws {
        let Values: [any Codable] = [
            "a",
            1,
            [1,2,3],
            5.0
        ]

        /// All types are required to be a type of `Codable` to permit encoding it and `Equatable` to satisfy ``compareComponents(ofType:,_:,_:)``
        let Types: [any Codable.Type] = [
            String.self, Int.self, [Int].self, Double.self,
        ] as! [any Codable.Type]
        
        try #require(
            Values.count == Types.count,
            "Test `CodableNavigationPath` is Malformed"
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
            "`decodedComponents` and `components` are inconsitently sized. \(decodedComponents.count) != \(components.count)"
        )

        /// This Flag being on indicates that functions can have their specializations dynamically inferred.
        /// This needs a change to Swift's Type System to work. This Loop does not compile and is present for clarity.
        /// Unrolling this loop gives the contents of the `#else` block,
        /// Make sure to add a new expect clause for each new item you add
        #if ProcedurallyInferredTypes
            for (i,Type) in Types.enumerated() {
                guard Type is any Equatable else { #expect(false, "The type in slot \(i) was not Equatable") }
                #expect(
                    Self.compareComponents(ofType: Type.self, components[i], decodedComponents[i]),
                    "An Issue with Navigation path data retainment occured \(components[i]) != \(decodedComponents[i])"
                )
            }
        #else
            #expect(
                Self.compareComponents(ofType: String.self, components[0], decodedComponents[0]),
                "An Issue with Navigation path data retainment occured \(components[0]) != \(decodedComponents[0])"
            )
            #expect(
                Self.compareComponents(ofType: Int.self, components[1], decodedComponents[1]),
                "An Issue with Navigation path data retainment occured \(components[1]) != \(decodedComponents[1])"
            )
            #expect(
                Self.compareComponents(ofType: [Int].self, components[2], decodedComponents[2]),
                "An Issue with Navigation path data retainment occured \(components[2]) != \(decodedComponents[2])"
            )
            #expect(
                Self.compareComponents(ofType: Double.self, components[3], decodedComponents[3]),
                "An Issue with Navigation path data retainment occured \(components[3]) != \(decodedComponents[3])"
            )
            // */
        #endif
    }

    // Note: consider
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

    @Test(
        "Observation Sanity Checks",
        .tags(.Observation)
    )
    func StateObservationSanity() {
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
        #expect(observedChange, "Expected nested published observable object mutation to trigger observation")

        // Ensure that replacing published nested ObservableObject triggers observation
        observedChange = false
        state.publishedNestedState = NestedState()
        #expect(observedChange, "Expected replacing nested published observable object to trigger observation")

        // Ensure that replaced published nested ObservableObject triggers observation
        observedChange = false
        state.publishedNestedState.count += 1
        #expect(observedChange, "Expected replaced nested published observable object mutation to trigger observation")

        // Ensure that non-published nested ObservableObject doesn't trigger observation
        observedChange = false
        state.unpublishedNestedState.count += 1
        #expect(!observedChange, "Expected nested unpublished observable object mutation to not trigger observation")

        // Ensure that cancelling the observation prevents future observations
        cancellable.cancel()
        observedChange = false
        state.count += 1
        #expect(!observedChange, "Expected mutation not to trigger cancelled observation")
    }
}
