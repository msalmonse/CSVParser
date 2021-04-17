#if os(macOS)
import Foundation
#endif

/// State of parser

private enum ParserState: Comparable {
    case
        lineStart,          // no field data found, row is empty or whitespace
        fieldStart,         // field started but no data found, like lineStart but at least one field already
        normal,             // non-whitespace found
        qdfound,            // double quote found while quoted
        quoted              // quoted text started
}

/// Parse csv string
/// - Parameters:
///   - inData: the string to parse
///   - separatedBy: field separator
///   - to: Array of arrays to hold results
///   - leavingWhiteSpace: Should white space be trimmed or left?

public func csvParse(
    _ inData: String,
    separatedBy: String = ",",
    to outData: inout [[String]],
    leavingWhiteSpace: Bool = false
) {
    let trimWS = !leavingWhiteSpace
    let colsep = separatedBy.unicodeScalars.first
    let cr: UnicodeScalar = "\r"
    let qd: UnicodeScalar = "\""
    let nl: UnicodeScalar = "\n"
    let space: UnicodeScalar = " "
    var state = ParserState.lineStart
    var field = ""
    var spaceCount = 0              // count of potentially trailing spaces
    var lastRow = -1                // the index of the last row in outData
    var ws = CharacterSet()
    ws.insert(charactersIn: "\r\n ")

    // clean up output
    outData = []

    for ch in inData.unicodeScalars {
        // Valid data found so add a row?
        if state == .lineStart && !(trimWS && ws.contains(ch)) {
            outData.append([])
            lastRow += 1
            assert(lastRow == outData.endIndex - 1, "outData indices don't match")
        }

        // handle copying to field and next state
        switch (state, ch, trimWS) {
            // when quoted colsep, cr and nl are normal characters
        case (.quoted, colsep, _),
             (.quoted, cr, _),
             (.quoted, nl, _):
            field.unicodeScalars.append(ch)

            // skip carriage return
            // if trimWS skip spaces at the start of a line or field, nl if we haven't started a field
        case (_, cr, _),
             (.fieldStart, space, true),
             (.lineStart, space, true),
             (.lineStart, nl, true):
            break

            // in every other state colsep terminates a cell, new line always terminates a cell
        case (_, colsep, _),
             (_, nl, _):
            if spaceCount > 0 { field.unicodeScalars.removeLast(spaceCount) }
            outData[lastRow].append(field)
            field = ""
            state = ch == nl ? .lineStart : .fieldStart
            spaceCount = 0

            // double quote normally puts us into quoted
        case (.lineStart, qd, _),
             (.fieldStart, qd, _),
             (.normal, qd, _):
            state = .quoted

            // while in quoted state a double quote may terminate the state or be an actual double quote
        case (.quoted, qd, _): state = .qdfound

            // two double quotes while quoted means a literal double quote
        case (.qdfound, qd, _):
            field.unicodeScalars.append(ch)
            state = .quoted

            // one means the end of the quote, append that character
        case (.qdfound, _, _):
            field.unicodeScalars.append(ch)
            state = .normal

            // if in lineStart or fieldStart go to normal
        case (.lineStart, _, _),
             (.fieldStart, _, _):
            state = .normal
            field.unicodeScalars.append(ch)

            // otherwise just add the character to the cell
        default:
            field.unicodeScalars.append(ch)
        }

        // handle spaceCount
        if trimWS {
            switch (state, ch) {
            case (.quoted, _): spaceCount = 0
            case (.normal, space): spaceCount += 1
            default:
                spaceCount = 0
            }
        }
    }

    if state != .lineStart {
        if spaceCount > 0 { field.unicodeScalars.removeLast(spaceCount) }
        outData[lastRow].append(field)
    }
}
