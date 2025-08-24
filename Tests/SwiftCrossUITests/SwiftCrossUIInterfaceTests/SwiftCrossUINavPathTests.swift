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
        /// Specifies the values and types input into the `NavigationPath`
        let typeValuePairs: [(type: any Codable.Type, value: any Codable)] =
            [
                (String.self, "a"),
                (Int.self, 1),
                ([Int].self, [1, 2, 3]),
                (Double.self, 5.0),
            ] as! [(any Codable.Type, any Codable)]

        let Values: [any Codable] = typeValuePairs.map { $0.value }

        let Types: [any Codable.Type] = typeValuePairs.map { $0.type }

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
