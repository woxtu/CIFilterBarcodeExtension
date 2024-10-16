import CoreImage

enum LinearBarcodeRenderer {
  static func image(_ pattern: [Bool], quietSpace: Int, barcodeHeight: Int) -> CIImage {
    let imageWidth = pattern.count + quietSpace * 2
    let imageHeight = barcodeHeight + quietSpace * 2
    var imageData = Data(capacity: .init(imageWidth * imageHeight))

    // Add the top quiet zone
    for _ in 0 ..< quietSpace * imageWidth {
      imageData.appendWhite()
    }

    for _ in 0 ..< barcodeHeight {
      // Add the leading quiet zone
      for _ in 0 ..< quietSpace {
        imageData.appendWhite()
      }

      // Add the barcode pattern
      for color in pattern {
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
    }

    // Add the bottom quiet zone
    for _ in 0 ..< quietSpace * imageWidth {
      imageData.appendWhite()
    }

    return .rgba8(bitmapData: imageData, size: .init(width: imageWidth, height: imageHeight))
  }
}
