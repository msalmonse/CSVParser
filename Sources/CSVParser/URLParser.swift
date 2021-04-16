#if os(macOS)
import Foundation
#endif

/// Parse csv URL
/// - Parameters:
///   - url: CSV source
///   - separatedBy: field separator
///   - to: Array of arrays to hold results
//    - leavingWhiteSpace: Should white space be trimmed or left?

public func csvParse(
    _ url: URL,
    separatedBy: String = ",",
    to outData: inout [[String]],
    leavingWhiteSpace: Bool = false
) throws {
    do {
        try csvParse(
            String(contentsOf: url),
            separatedBy: separatedBy,
            to: &outData,
            leavingWhiteSpace: leavingWhiteSpace
        )
    } catch {
        throw(error)
    }
}
