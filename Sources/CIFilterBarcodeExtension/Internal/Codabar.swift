import Foundation

enum Codabar {
  static let encodableCharacters: [Character] = .init("0123456789-$:/.+")
  static let startStopCharacters: [Character] = ["A", "B", "C", "D"]
  static let altStartStopCharacters: [Character] = ["T", "N", "*", "E"]
  static let defaultStartStopCharacter: String = .init(startStopCharacters[0])

  private static let B: Bool = true
  private static let S: Bool = false

  static let characterEncodings: [Character: [Bool]] = [
    "0": [B, S, B, S, B, S, S, B, B],
    "1": [B, S, B, S, B, B, S, S, B],
    "2": [B, S, B, S, S, B, S, B, B],
    "3": [B, B, S, S, B, S, B, S, B],
    "4": [B, S, B, B, S, B, S, S, B],
    "5": [B, B, S, B, S, B, S, S, B],
    "6": [B, S, S, B, S, B, S, B, B],
    "7": [B, S, S, B, S, B, B, S, B],
    "8": [B, S, S, B, B, S, B, S, B],
    "9": [B, B, S, B, S, S, B, S, B],
    "-": [B, S, B, S, S, B, B, S, B],
    "$": [B, S, B, B, S, S, B, S, B],
    ":": [B, B, S, B, S, B, B, S, B, B],
    "/": [B, B, S, B, B, S, B, S, B, B],
    ".": [B, B, S, B, B, S, B, B, S, B],
    "+": [B, S, B, B, S, B, B, S, B, B],
    "A": [B, S, B, B, S, S, B, S, S, B],
    "B": [B, S, S, B, S, S, B, S, B, B],
    "C": [B, S, B, S, S, B, S, S, B, B],
    "D": [B, S, B, S, S, B, B, S, S, B],
  ]

  static func encode(_ message: String) -> [Bool]? {
    guard !message.isEmpty else {
      return nil
    }

    var characters = message
    if characters.count < 2 {
      // A too short message cannot have any start/stop characters
      characters = defaultStartStopCharacter + characters + defaultStartStopCharacter
    } else {
      switch (
        startStopCharacters.contains(characters.first!),
        startStopCharacters.contains(characters.last!),
        altStartStopCharacters.contains(characters.first!),
        altStartStopCharacters.contains(characters.last!)
      ) {
      case (true, true, _, _), (_, _, true, true):
        break

      case (false, false, false, false):
        // A message with no start/stop characters is encoded by adding default characters
        characters = defaultStartStopCharacter + characters + defaultStartStopCharacter

      case (true, false, _, _), (false, true, _, _), (_, _, true, false), (_, _, false, true):
        return nil
      }
    }

    guard Set(characters.dropFirst().dropLast()).isSubset(of: encodableCharacters) else {
      return nil
    }

    return .init(
      characters
        .map { char in
          if let index = altStartStopCharacters.firstIndex(of: char) {
            startStopCharacters[index]
          } else {
            char
          }
        }
        .compactMap { characterEncodings[$0] }
        .joined(separator: CollectionOfOne(false))
    )
  }
}
