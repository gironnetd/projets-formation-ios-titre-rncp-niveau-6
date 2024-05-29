import XCTest
@testable import navigation

final class navigationTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(navigation().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
