import XCTest

@testable import SwiftCrossUI

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
}
