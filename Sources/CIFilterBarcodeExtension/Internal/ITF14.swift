import Foundation

enum ITF14 {
  static func encode(_ message: String) -> [Bool]? {
    guard
      case var digits = message.compactMap({ Int(String($0)) }),
      digits.count == message.count,
      !digits.isEmpty
    else {
      return nil
    }

    switch digits.count {
    case 13:
      // A message with no check digit is encoded by adding a check digit
      digits.append(CheckDigit.modulus10Weight3(for: digits))

    case 14:
      guard digits.last == CheckDigit.modulus10Weight3(for: digits.dropLast()) else {
        return nil
      }

    default:
      return nil
    }

    return Interleaved2of5.encode(digits.map(String.init).joined())
  }
}
