import XCTest
@testable import util

final class utilTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(util().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
