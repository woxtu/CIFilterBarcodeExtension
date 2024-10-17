import Foundation

enum EAN8 {
  static let startStopPattern: [Bool] = EAN13.startStopPattern
  static let middlePattern: [Bool] = EAN13.middlePattern
  static let lCodeCharacterEncodings: [[Bool]] = EAN13.lCodeCharacterEncodings
  static let rCodeCharacterEncodings: [[Bool]] = EAN13.rCodeCharacterEncodings

  static func encode(_ message: String) -> [Bool]? {
    guard
      case var digits = message.compactMap({ Int(String($0)) }),
      digits.count == message.count,
      !digits.isEmpty
    else {
      return nil
    }

    switch digits.count {
    case 7:
      // A message with no check digit is encoded by adding a check digit
      digits.append(CheckDigit.modulus10Weight3(for: digits))

    case 8:
      guard digits.last == CheckDigit.modulus10Weight3(for: digits.dropLast()) else {
        return nil
      }

    default:
      return nil
    }

    let firstGroupPattern = digits[0 ... 3].flatMap { lCodeCharacterEncodings[$0] }

    let lastGroupPattern = digits[4 ... 7].flatMap { rCodeCharacterEncodings[$0] }

    return startStopPattern
      + firstGroupPattern
      + middlePattern
      + lastGroupPattern
      + startStopPattern
  }
}
