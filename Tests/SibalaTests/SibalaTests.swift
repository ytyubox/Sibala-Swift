import XCTest
@testable import Sibala

final class SibalaTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Sibala().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
