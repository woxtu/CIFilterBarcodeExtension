import Foundation

enum Code93 {
  private static let B: Bool = true
  private static let S: Bool = false

  static let startStopEncoding: [Bool] = [B, S, B, S, B, B, B, B, S]
  static let terminationBar: [Bool] = [B]

  static let characterEncodings: [Character: [Bool]] = [
    "0": [B, S, S, S, B, S, B, S, S],
    "1": [B, S, B, S, S, B, S, S, S],
    "2": [B, S, B, S, S, S, B, S, S],
    "3": [B, S, B, S, S, S, S, B, S],
    "4": [B, S, S, B, S, B, S, S, S],
    "5": [B, S, S, B, S, S, B, S, S],
    "6": [B, S, S, B, S, S, S, B, S],
    "7": [B, S, B, S, B, S, S, S, S],
    "8": [B, S, S, S, B, S, S, B, S],
    "9": [B, S, S, S, S, B, S, B, S],
    "A": [B, B, S, B, S, B, S, S, S],
    "B": [B, B, S, B, S, S, B, S, S],
    "C": [B, B, S, B, S, S, S, B, S],
    "D": [B, B, S, S, B, S, B, S, S],
    "E": [B, B, S, S, B, S, S, B, S],
    "F": [B, B, S, S, S, B, S, B, S],
    "G": [B, S, B, B, S, B, S, S, S],
    "H": [B, S, B, B, S, S, B, S, S],
    "I": [B, S, B, B, S, S, S, B, S],
    "J": [B, S, S, B, B, S, B, S, S],
    "K": [B, S, S, S, B, B, S, B, S],
    "L": [B, S, B, S, B, B, S, S, S],
    "M": [B, S, B, S, S, B, B, S, S],
    "N": [B, S, B, S, S, S, B, B, S],
    "O": [B, S, S, B, S, B, B, S, S],
    "P": [B, S, S, S, B, S, B, B, S],
    "Q": [B, B, S, B, B, S, B, S, S],
    "R": [B, B, S, B, B, S, S, B, S],
    "S": [B, B, S, B, S, B, B, S, S],
    "T": [B, B, S, B, S, S, B, B, S],
    "U": [B, B, S, S, B, S, B, B, S],
    "V": [B, B, S, S, B, B, S, B, S],
    "W": [B, S, B, B, S, B, B, S, S],
    "X": [B, S, B, B, S, S, B, B, S],
    "Y": [B, S, S, B, B, S, B, B, S],
    "Z": [B, S, S, B, B, B, S, B, S],
    "-": [B, S, S, B, S, B, B, B, S],
    ".": [B, B, B, S, B, S, B, S, S],
    " ": [B, B, B, S, B, S, S, B, S],
    "$": [B, B, B, S, S, B, S, B, S],
    "/": [B, S, B, B, S, B, B, B, S],
    "+": [B, S, B, B, B, S, B, B, S],
    "%": [B, B, S, B, S, B, B, B, S],
    "a": [B, S, S, B, S, S, B, B, S],  // ($)
    "b": [B, B, B, S, B, B, S, B, S],  // (%)
    "c": [B, B, B, S, B, S, B, B, S],  // (/)
    "d": [B, S, S, B, B, S, S, B, S],  // (+)
  ]

  private static let encodableCharacters: [Character] =
    .init("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%abcd")

  static func encode(_ message: String) -> [Bool]? {
    guard
      !message.isEmpty,
      message.allSatisfy({ $0.isASCII })
    else {
      return nil
    }

    var characters = extendedCharacters(message)
    characters.append(checkDigit(for: characters, maxWeight: 20))  // C
    characters.append(checkDigit(for: characters, maxWeight: 15))  // K

    let messagePattern =
      characters
      .compactMap { characterEncodings[$0] }
      .joined(separator: CollectionOfOne(false))

    return startStopEncoding
      + CollectionOfOne(false)
      + messagePattern
      + CollectionOfOne(false)
      + startStopEncoding
      + terminationBar
  }

  private static func extendedCharacters(_ string: String) -> String {
    string
      .map { char in
        switch char {
        case "\u{00}": "bU"  // (%)U
        case "\u{01}": "aA"  // ($)A
        case "\u{02}": "aB"  // ($)B
        case "\u{03}": "aC"  // ($)C
        case "\u{04}": "aD"  // ($)D
        case "\u{05}": "aE"  // ($)E
        case "\u{06}": "aF"  // ($)F
        case "\u{07}": "aG"  // ($)G
        case "\u{08}": "aH"  // ($)H
        case "\u{09}": "aI"  // ($)I
        case "\u{0A}": "aJ"  // ($)J
        case "\u{0B}": "aK"  // ($)K
        case "\u{0C}": "aL"  // ($)L
        case "\u{0D}": "aM"  // ($)M
        case "\u{0E}": "aN"  // ($)N
        case "\u{0F}": "aO"  // ($)O
        case "\u{10}": "aP"  // ($)P
        case "\u{11}": "aQ"  // ($)Q
        case "\u{12}": "aR"  // ($)R
        case "\u{13}": "aS"  // ($)S
        case "\u{14}": "aT"  // ($)T
        case "\u{15}": "aU"  // ($)U
        case "\u{16}": "aV"  // ($)V
        case "\u{17}": "aW"  // ($)W
        case "\u{18}": "aX"  // ($)X
        case "\u{19}": "aY"  // ($)Y
        case "\u{1A}": "aZ"  // ($)Z
        case "\u{1B}": "bA"  // (%)A
        case "\u{1C}": "bB"  // (%)B
        case "\u{1D}": "bC"  // (%)C
        case "\u{1E}": "bD"  // (%)D
        case "\u{1F}": "bE"  // (%)E
        case " ": " "
        case "!": "cA"  // (/)A
        case "\"": "cB"  // (/)B
        case "#": "cC"  // (/)C
        case "$", "%": .init(char)
        case "&": "cF"  // (/)F
        case "'": "cG"  // (/)F
        case "(": "cH"  // (/)H
        case ")": "cI"  // (/)I
        case "*": "cJ"  // (/)J
        case "+": "+"
        case ",": "/L"  // (/)L
        case "-", ".", "/", "0" ... "9": .init(char)
        case ":": "cZ"  // (/)Z
        case ";": "bF"  // (%)F
        case "<": "bG"  // (%)G
        case "=": "bH"  // (%)H
        case ">": "bI"  // (%)I
        case "?": "bJ"  // (%)J
        case "@": "bV"  // (%)V
        case "A" ... "Z": .init(char)
        case "[": "bK"  // (%)K
        case "\\": "bL"  // (%)L
        case "]": "bM"  // (%)M
        case "^": "bN"  // (%)N
        case "_": "bO"  // (%)O
        case "`": "bW"  // (%)W
        case "a" ... "z": "d" + char.uppercased()  // (+)A - (+)Z
        case "{": "bP"  // (%)P
        case "|": "bQ"  // (%)Q
        case "}": "bR"  // (%)R
        case "~": "bS"  // (%)S
        case "\u{7F}": "bT"  // (%)T
        default: ""
        }
      }
      .joined()
  }

  private static func checkDigit(for characters: String, maxWeight: Int) -> Character {
    let total =
      characters
      .reversed()
      .compactMap { encodableCharacters.firstIndex(of: $0) }
      .enumerated()
      .reduce(0) { $0 + $1.element * ($1.offset % maxWeight + 1) }
    return encodableCharacters[total % encodableCharacters.count]
  }
}
