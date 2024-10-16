import Foundation

extension Data {
  /// Add a black pixel in RGBA8
  mutating func appendBlack() {
    append(0)
    append(0)
    append(0)
    append(.max)
  }

  /// Add a white pixel in RGBA8
  mutating func appendWhite() {
    append(.max)
    append(.max)
    append(.max)
    append(.max)
  }
}
