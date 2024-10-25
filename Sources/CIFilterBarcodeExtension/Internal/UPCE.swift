import Foundation

enum UPCE {
  static let parityPatterns: [[[Character]]] = [
    // Number system 0
    [
      ["E", "E", "E", "O", "O", "O"],
      ["E", "E", "O", "E", "O", "O"],
      ["E", "E", "O", "O", "E", "O"],
      ["E", "E", "O", "O", "O", "E"],
      ["E", "O", "E", "E", "O", "O"],
      ["E", "O", "O", "E", "E", "O"],
      ["E", "O", "O", "O", "E", "E"],
      ["E", "O", "E", "O", "E", "O"],
      ["E", "O", "E", "O", "O", "E"],
      ["E", "O", "O", "E", "O", "E"],
    ],
    // Number system 1
    [
      ["O", "O", "O", "E", "E", "E"],
      ["O", "O", "E", "O", "E", "E"],
      ["O", "O", "E", "E", "O", "E"],
      ["O", "O", "E", "E", "E", "O"],
      ["O", "E", "O", "O", "E", "E"],
      ["O", "E", "E", "O", "O", "E"],
      ["O", "E", "E", "E", "O", "O"],
      ["O", "E", "O", "E", "O", "E"],
      ["O", "E", "O", "E", "E", "O"],
      ["O", "E", "E", "O", "E", "O"],
    ],
  ]

  private static let B: Bool = true
  private static let S: Bool = false

  static let startPattern: [Bool] = EAN13.startStopPattern
  static let stopPattern: [Bool] = [S, B, S, B, S, B]

  static let oddParityCharacterEncodings: [[Bool]] = EAN13.lCodeCharacterEncodings
  static let evenParityCharacterEncodings: [[Bool]] = EAN13.gCodeCharacterEncodings

  static func encode(_ message: String) -> [Bool]? {
    guard
      case var digits = message.compactMap({ Int(String($0)) }),
      digits.count == message.count,
      !digits.isEmpty,
      digits.first == 0 || digits.first == 1
    else {
      return nil
    }

    switch digits.count {
    case 7:
      // A message with no check digit is encoded by adding a check digit
      digits.append(CheckDigit.modulus10Weight3(for: upcA(digits)))

    case 8:
      guard digits.last == CheckDigit.modulus10Weight3(for: upcA(digits.dropLast())) else {
        return nil
      }

    default:
      return nil
    }

    let parityPattern = parityPatterns[digits.first!][digits.last!]
    let messagePattern = zip(parityPattern, digits.dropFirst().dropLast()).flatMap { parity, digit in
      let characterEncodings = parity == "O" ? oddParityCharacterEncodings : evenParityCharacterEncodings
      return characterEncodings[digit]
    }

    return startPattern + messagePattern + stopPattern
  }

  private static func upcA(_ digits: [Int]) -> [Int] {
    switch digits.last {
    case 0, 1, 2:
      // NMMPPPX -> NMMX00-00PPP
      digits[0 ..< 3] + CollectionOfOne(digits.last!) + [0, 0, 0, 0] + digits[3 ..< 6]
    case 3:
      // NMMMPP3 -> NMMM00-000PP
      digits[0 ..< 4] + [0, 0, 0, 0, 0] + digits[4 ..< 6]
    case 4:
      // NMMMMP4 -> NMMMM0-0000P
      digits[0 ..< 5] + [0, 0, 0, 0, 0] + digits[5 ..< 6]
    default:
      // NMMMMMX -> NMMMMM-0000X
      digits[0 ..< 6] + [0, 0, 0, 0] + CollectionOfOne(digits.last!)
    }
  }
}
