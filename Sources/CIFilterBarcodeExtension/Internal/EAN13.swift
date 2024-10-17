import Foundation

enum EAN13 {
  static let firstGroupCodePatterns: [[Character]] = [
    ["L", "L", "L", "L", "L", "L"],
    ["L", "L", "G", "L", "G", "G"],
    ["L", "L", "G", "G", "L", "G"],
    ["L", "L", "G", "G", "G", "L"],
    ["L", "G", "L", "L", "G", "G"],
    ["L", "G", "G", "L", "L", "G"],
    ["L", "G", "G", "G", "L", "L"],
    ["L", "G", "L", "G", "L", "G"],
    ["L", "G", "L", "G", "G", "L"],
    ["L", "G", "G", "L", "G", "L"],
  ]

  private static let B: Bool = true
  private static let S: Bool = false

  static let startStopPattern: [Bool] = [B, S, B]
  static let middlePattern: [Bool] = [S, B, S, B, S]

  static let lCodeCharacterEncodings: [[Bool]] = [
    [S, S, S, B, B, S, B],
    [S, S, B, B, S, S, B],
    [S, S, B, S, S, B, B],
    [S, B, B, B, B, S, B],
    [S, B, S, S, S, B, B],
    [S, B, B, S, S, S, B],
    [S, B, S, B, B, B, B],
    [S, B, B, B, S, B, B],
    [S, B, B, S, B, B, B],
    [S, S, S, B, S, B, B],
  ]

  static let rCodeCharacterEncodings: [[Bool]] = lCodeCharacterEncodings.map { $0.map { !$0 } }

  static let gCodeCharacterEncodings: [[Bool]] = rCodeCharacterEncodings.map { $0.reversed() }

  static func encode(_ message: String) -> [Bool]? {
    guard
      case var digits = message.compactMap({ Int(String($0)) }),
      digits.count == message.count,
      !digits.isEmpty
    else {
      return nil
    }

    switch digits.count {
    case 12:
      // A message with no check digit is encoded by adding a check digit
      digits.append(CheckDigit.modulus10Weight3(for: digits))

    case 13:
      guard digits.last == CheckDigit.modulus10Weight3(for: digits.dropLast()) else {
        return nil
      }

    default:
      return nil
    }

    let firstGroupCodePattern = firstGroupCodePatterns[digits[0]]
    let firstGroupPattern = zip(firstGroupCodePattern, digits[1 ... 6]).flatMap { code, digit in
      let characterEncodings = code == "L" ? lCodeCharacterEncodings : gCodeCharacterEncodings
      return characterEncodings[digit]
    }

    let lastGroupPattern = digits[7 ... 12].flatMap { rCodeCharacterEncodings[$0] }

    return startStopPattern
      + firstGroupPattern
      + middlePattern
      + lastGroupPattern
      + startStopPattern
  }
}
