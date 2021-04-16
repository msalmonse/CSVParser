import XCTest
@testable import CSVParser

final class CSVParserTests: XCTestCase {

    func csvGen(_ rows: Int, by cols: Int, precision: Int = 4) -> String {
        var data: [String] = []

        for _ in 0..<rows {
            var row: [String] = []
            for _ in 0..<cols {
                row.append(String(format: "%*d", precision, Int.random(in: -500...500)))
            }
            data.append(row.joined(separator: ","))
        }
        return data.joined(separator: "\r\n")
    }

    func testTrimmingCSVParse() {
        var parsed: [[String]] = []
        csvParse(Self.testRow, to: &parsed)
        XCTAssertEqual(parsed.count, 1)
        XCTAssertEqual(parsed[0].count, 6)
        XCTAssertEqual(parsed[0][2], "Test with \"  and emoji 🌊")

        csvParse(Self.csvData, to: &parsed)
        XCTAssertEqual(parsed.count, 5)
        for row in parsed {
            XCTAssertEqual(row.count, 5)
        }

        csvParse("        ", to: &parsed)
        XCTAssertEqual(parsed.count, 0)

        csvParse("        ,", to: &parsed)
        XCTAssertEqual(parsed.count, 1)
        XCTAssertEqual(parsed[0].count, 2)

        csvParse("        \",\" ", to: &parsed)
        XCTAssertEqual(parsed.count, 1)
        XCTAssertEqual(parsed[0].count, 1)

        csvParse("        \"\r\n\" ", to: &parsed)
        XCTAssertEqual(parsed.count, 1)
        XCTAssertEqual(parsed[0].count, 1)

        csvParse("1,2,3\r\n \n4,5,6", to: &parsed)
        XCTAssertEqual(parsed.count, 2)
        XCTAssertEqual(parsed[0].count, 3)
        XCTAssertEqual(parsed[1].count, 3)
    }

    func testNoTrimmingCSVParse() {
        var parsed: [[String]] = []
        csvParse(Self.testRow, to: &parsed, leavingWhiteSpace: true)
        XCTAssertEqual(parsed.count, 1)
        XCTAssertEqual(parsed[0].count, 6)
        XCTAssertEqual(parsed[0][2], " Test with \"  and emoji 🌊 ")

        csvParse(Self.csvData, to: &parsed, leavingWhiteSpace: true)
        XCTAssertEqual(parsed.count, 5)
        for row in parsed {
            XCTAssertEqual(row.count, 5)
        }

        csvParse("        ", to: &parsed, leavingWhiteSpace: true)
        XCTAssertEqual(parsed.count, 1)

        csvParse("        ,", to: &parsed, leavingWhiteSpace: true)
        XCTAssertEqual(parsed.count, 1)
        XCTAssertEqual(parsed[0].count, 2)

        csvParse("        \",\" ", to: &parsed, leavingWhiteSpace: true)
        XCTAssertEqual(parsed.count, 1)
        XCTAssertEqual(parsed[0].count, 1)

        csvParse("        \"\r\n\" ", to: &parsed, leavingWhiteSpace: true)
        XCTAssertEqual(parsed.count, 1)
        XCTAssertEqual(parsed[0].count, 1)

        csvParse("1,2,3\r\n \n4,5,6", to: &parsed, leavingWhiteSpace: true)
        XCTAssertEqual(parsed.count, 3)
        XCTAssertEqual(parsed[0].count, 3)
        XCTAssertEqual(parsed[1].count, 1)
        XCTAssertEqual(parsed[2].count, 3)
    }

    func testCsvParsePerformance() {
        var parsed: [[String]] = []
        let testData = csvGen(100000, by: 7, precision: 8)
        measure {
            csvParse(testData, to: &parsed)
        }
    }

    static let testName = "Ozzymandis"

    // CSV string for parser test
    static let testRow = """
      1  , 234, "Test with "" " and emoji 🌊 ,,"\r\n",1\r
    """

    // CSV string for tests
    static let csvData = """
    1,-1,9,3 " "" " 5,"\(testName)"\r
    1,100.1,120.4, -110.1,0.0\r
    9,100.1 ,129.9,5220.6 ,0.0\r
    32,100.1,152.7,,\r
    "\(testName)",,,,0.0\r
    """

    static var allTests = [
        ("test csvParse with ws trimming", testTrimmingCSVParse),
        ("test csvParse without ws trimming", testNoTrimmingCSVParse),
        ("test csvParse performance", testCsvParsePerformance)
    ]
}
