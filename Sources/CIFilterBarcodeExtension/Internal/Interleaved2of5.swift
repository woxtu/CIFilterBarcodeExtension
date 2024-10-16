import Foundation

enum Interleaved2of5 {
  private static let n: Int = 1
  private static let W: Int = 3

  static let startPattern: [Int] = [n, n, n, n]
  static let stopPattern: [Int] = [W, n, n]

  static let characterEncodings: [[Int]] = [
    [n, n, W, W, n],
    [W, n, n, n, W],
    [n, W, n, n, W],
    [W, W, n, n, n],
    [n, n, W, n, W],
    [W, n, W, n, n],
    [n, W, W, n, n],
    [n, n, n, W, W],
    [W, n, n, W, n],
    [n, W, n, W, n],
  ]

  static func encode(_ message: String) -> [Bool]? {
    guard
      case var digits = message.compactMap({ Int(String($0)) }),
      digits.count == message.count,
      !digits.isEmpty
    else {
      return nil
    }

    // An odd number of digits is encoded by adding a leading zero
    if digits.count % 2 != 0 {
      digits.insert(0, at: 0)
    }

    let startPattern = startPattern.enumerated().flatMap { repeatElement($0 % 2 == 0, count: $1) }

    var messagePattern = [Bool]()
    for index in stride(from: 0, to: digits.count, by: 2) {
      for (black, white) in zip(characterEncodings[digits[index]], characterEncodings[digits[index + 1]]) {
        messagePattern += repeatElement(true, count: black)
        messagePattern += repeatElement(false, count: white)
      }
    }

    let stopPattern = stopPattern.enumerated().flatMap { repeatElement($0 % 2 == 0, count: $1) }

    return startPattern + messagePattern + stopPattern
  }
}
