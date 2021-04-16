import XCTest
@testable import CSVParser

final class CSVParserTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CSVParser().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
