import Testing

@testable import SwiftCrossUI

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

@Suite
struct InternalTests {
    /// Makes sure that ``NavigationPath`` can retain data validating them with `compareComponents`
    /// ``T`` is required to be a type of `Codable` to permit encoding it and `Equatable` to satisfy ``compareComponents(ofType:,_:,_:)``
    @Test(
        "The Codable NavigationPath can accurately store Codable data",
        arguments: zip(
            ["a", 1, [1,2,3],5.0],
            [String.self, Int.self, [Int].self, Double.self]
        )
    )
    func CodableNavigationPath<T>(component: T, ofType _:T.Type) throws where T:Codable & Equatable {
        var path = NavigationPath()
        path.append(component)

        let components = path.path(destinationTypes: [
            T.self
        ])

        let encoded = try JSONEncoder().encode(path)
        let decodedPath = try JSONDecoder().decode(NavigationPath.self, from: encoded)

        let decodedComponents = decodedPath.path(destinationTypes: [
            T.self
        ])
        #expect(
            Self.compareComponents(ofType: T.self, components[0], decodedComponents[0]),
            "Expected `\(components[0])` and `\(decodedComponents[0])` to both be \((components[0] is T && decodedComponents[0] is T) ? "equal" : "of type \(T)")."
        )
    }

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

    // TODO: Move to seperate Suite so that the setup items can be stable
    @Test("Observation Sanity Checks")
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
