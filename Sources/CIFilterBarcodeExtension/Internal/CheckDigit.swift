import Foundation

enum CheckDigit {
  static func modulus10Weight3(for digits: [Int]) -> Int {
    var m = 0
    for index in stride(from: digits.count - 1, through: 0, by: -2) {
      m += digits[index]
    }
    m *= 3
    for index in stride(from: digits.count - 2, through: 0, by: -2) {
      m += digits[index]
    }
    m %= 10
    return m == 0 ? 0 : 10 - m
  }
}
