import CoreImage

/// Generates an ITF-14 barcode.
public class CIITF14BarcodeGenerator: CIFilter {
  @objc var inputMessage: String?
  @objc var inputQuietSpace: Int = .defaultQuietSpace
  @objc var inputBearerBarWidth: Int = .defaultBearerBarWidth
  @objc var inputBarcodeHeight: Int = .defaultBarcodeHeight

  /// The message to encode in the ITF-14 barcode.
  public var message: String {
    get { inputMessage ?? "" }
    set { inputMessage = newValue }
  }

  /// The number of empty white pixels that should surround the barcode.
  public var quietSpace: Int {
    get { inputQuietSpace }
    set { inputQuietSpace = newValue }
  }

  /// The width, in pixels, of the bearer bar.
  public var bearerBarWidth: Int {
    get { inputBearerBarWidth }
    set { inputBearerBarWidth = newValue }
  }

  /// The height, in pixels, of the generated barcode.
  public var barcodeHeight: Int {
    get { inputBarcodeHeight }
    set { inputBarcodeHeight = newValue }
  }

  /// Sets all input values for a filter to default values.
  public override func setDefaults() {
    inputMessage = nil
    inputQuietSpace = .defaultQuietSpace
    inputBearerBarWidth = .defaultBearerBarWidth
    inputBarcodeHeight = .defaultBarcodeHeight
  }

  /// Returns a CIImage object that encapsulates the operations configured in the filter.
  public override var outputImage: CIImage? {
    guard
      let message = inputMessage,
      let barcodePattern = ITF14.encode(message)
    else {
      return nil
    }

    let quietSpace = max(0, inputQuietSpace)
    let bearerBarWidth = max(0, inputBearerBarWidth)
    let barcodeHeight = max(0, inputBarcodeHeight)
    let imageWidth = barcodePattern.count + quietSpace * 2 + bearerBarWidth * 2
    let imageHeight = barcodeHeight + bearerBarWidth * 2
    var imageData = Data(capacity: .init(imageWidth * imageHeight))

    // Add the top bearer bar
    for _ in 0 ..< bearerBarWidth * imageWidth {
      imageData.appendBlack()
    }

    for _ in 0 ..< barcodeHeight {
      // Add the leading bearer bar
      for _ in 0 ..< bearerBarWidth {
        imageData.appendBlack()
      }

      // Add the leading quiet zone
      for _ in 0 ..< quietSpace {
        imageData.appendWhite()
      }

      // Add the barcode pattern
      for color in barcodePattern {
        if color {
          imageData.appendBlack()
        } else {
          imageData.appendWhite()
        }
      }

      // Add the trailing quiet zone
      for _ in 0 ..< quietSpace {
        imageData.appendWhite()
      }

      // Add the trailing bearer bar
      for _ in 0 ..< bearerBarWidth {
        imageData.appendBlack()
      }
    }

    // Add the bottom bearer bar
    for _ in 0 ..< bearerBarWidth * imageWidth {
      imageData.appendBlack()
    }

    return .rgba8(bitmapData: imageData, size: .init(width: imageWidth, height: imageHeight))
  }
}

class CIITF14BarcodeGeneratorConstructor: CIFilterConstructor {
  func filter(withName name: String) -> CIFilter? {
    return CIITF14BarcodeGenerator()
  }
}

extension Int {
  fileprivate static let defaultQuietSpace: Int = 10
  fileprivate static let defaultBearerBarWidth: Int = 5
  fileprivate static let defaultBarcodeHeight: Int = 32
}
