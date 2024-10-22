import Foundation

enum Code39 {
  private static let B: Bool = true
  private static let S: Bool = false

  static let startStopEncoding: [Bool] = [B, S, S, B, S, B, B, S, B, B, S, B]

  static let characterEncodings: [Character: [Bool]] = [
    "0": [B, S, B, S, S, B, B, S, B, B, S, B],
    "1": [B, B, S, B, S, S, B, S, B, S, B, B],
    "2": [B, S, B, B, S, S, B, S, B, S, B, B],
    "3": [B, B, S, B, B, S, S, B, S, B, S, B],
    "4": [B, S, B, S, S, B, B, S, B, S, B, B],
    "5": [B, B, S, B, S, S, B, B, S, B, S, B],
    "6": [B, S, B, B, S, S, B, B, S, B, S, B],
    "7": [B, S, B, S, S, B, S, B, B, S, B, B],
    "8": [B, B, S, B, S, S, B, S, B, B, S, B],
    "9": [B, S, B, B, S, S, B, S, B, B, S, B],
    "A": [B, B, S, B, S, B, S, S, B, S, B, B],
    "B": [B, S, B, B, S, B, S, S, B, S, B, B],
    "C": [B, B, S, B, B, S, B, S, S, B, S, B],
    "D": [B, S, B, S, B, B, S, S, B, S, B, B],
    "E": [B, B, S, B, S, B, B, S, S, B, S, B],
    "F": [B, S, B, B, S, B, B, S, S, B, S, B],
    "G": [B, S, B, S, B, S, S, B, B, S, B, B],
    "H": [B, B, S, B, S, B, S, S, B, B, S, B],
    "I": [B, S, B, B, S, B, S, S, B, B, S, B],
    "J": [B, S, B, S, B, B, S, S, B, B, S, B],
    "K": [B, B, S, B, S, B, S, B, S, S, B, B],
    "L": [B, S, B, B, S, B, S, B, S, S, B, B],
    "M": [B, B, S, B, B, S, B, S, B, S, S, B],
    "N": [B, S, B, S, B, B, S, B, S, S, B, B],
    "O": [B, B, S, B, S, B, B, S, B, S, S, B],
    "P": [B, S, B, B, S, B, B, S, B, S, S, B],
    "Q": [B, S, B, S, B, S, B, B, S, S, B, B],
    "R": [B, B, S, B, S, B, S, B, B, S, S, B],
    "S": [B, S, B, B, S, B, S, B, B, S, S, B],
    "T": [B, S, B, S, B, B, S, B, B, S, S, B],
    "U": [B, B, S, S, B, S, B, S, B, S, B, B],
    "V": [B, S, S, B, B, S, B, S, B, S, B, B],
    "W": [B, B, S, S, B, B, S, B, S, B, S, B],
    "X": [B, S, S, B, S, B, B, S, B, S, B, B],
    "Y": [B, B, S, S, B, S, B, B, S, B, S, B],
    "Z": [B, S, S, B, B, S, B, B, S, B, S, B],
    "-": [B, S, S, B, S, B, S, B, B, S, B, B],
    ".": [B, B, S, S, B, S, B, S, B, B, S, B],
    " ": [B, S, S, B, B, S, B, S, B, B, S, B],
    "$": [B, S, S, B, S, S, B, S, S, B, S, B],
    "/": [B, S, S, B, S, S, B, S, B, S, S, B],
    "+": [B, S, S, B, S, B, S, S, B, S, S, B],
    "%": [B, S, B, S, S, B, S, S, B, S, S, B],
  ]

  static func encode(_ message: String) -> [Bool]? {
    guard
      !message.isEmpty,
      message.allSatisfy({ $0.isASCII })
    else {
      return nil
    }

    let isExtended = !Set(message).isSubset(of: characterEncodings.keys)

    let messagePattern =
      (isExtended ? extendedCharacters(message) : message)
      .compactMap { characterEncodings[$0] }
      .joined(separator: CollectionOfOne(false))

    return startStopEncoding
      + CollectionOfOne(false)
      + messagePattern
      + CollectionOfOne(false)
      + startStopEncoding
  }

  private static func extendedCharacters(_ string: String) -> String {
    string
      .map { char in
        switch char {
        case "\u{00}": "%U"
        case "\u{01}": "$A"
        case "\u{02}": "$B"
        case "\u{03}": "$C"
        case "\u{04}": "$D"
        case "\u{05}": "$E"
        case "\u{06}": "$F"
        case "\u{07}": "$G"
        case "\u{08}": "$H"
        case "\u{09}": "$I"
        case "\u{0A}": "$J"
        case "\u{0B}": "$K"
        case "\u{0C}": "$L"
        case "\u{0D}": "$M"
        case "\u{0E}": "$N"
        case "\u{0F}": "$O"
        case "\u{10}": "$P"
        case "\u{11}": "$Q"
        case "\u{12}": "$R"
        case "\u{13}": "$S"
        case "\u{14}": "$T"
        case "\u{15}": "$U"
        case "\u{16}": "$V"
        case "\u{17}": "$W"
        case "\u{18}": "$X"
        case "\u{19}": "$Y"
        case "\u{1A}": "$Z"
        case "\u{1B}": "%A"
        case "\u{1C}": "%B"
        case "\u{1D}": "%C"
        case "\u{1E}": "%D"
        case "\u{1F}": "%E"
        case " ": " "
        case "!": "/A"
        case "\"": "/B"
        case "#": "/C"
        case "$": "/D"
        case "%": "/E"
        case "&": "/F"
        case "'": "/G"
        case "(": "/H"
        case ")": "/I"
        case "*": "/J"
        case "+": "/K"
        case ",": "/L"
        case "-", ".": .init(char)
        case "/": "/O"
        case "0" ... "9": .init(char)
        case ":": "/Z"
        case ";": "%F"
        case "<": "%G"
        case "=": "%H"
        case ">": "%I"
        case "?": "%J"
        case "@": "%V"
        case "A" ... "Z": .init(char)
        case "[": "%K"
        case "\\": "%L"
        case "]": "%M"
        case "^": "%N"
        case "_": "%O"
        case "`": "%W"
        case "a" ... "z": "+" + char.uppercased()
        case "{": "%P"
        case "|": "%Q"
        case "}": "%R"
        case "~": "%S"
        case "\u{7F}": "%T"
        default: ""
        }
      }
      .joined()
  }
}
