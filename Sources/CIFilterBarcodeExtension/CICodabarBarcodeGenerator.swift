import CoreImage

/// Generates a Codabar barcode.
public class CICodabarBarcodeGenerator: CIFilter {
  @objc var inputMessage: String?
  @objc var inputQuietSpace: Int = .defaultQuietSpace
  @objc var inputBarcodeHeight: Int = .defaultBarcodeHeight

  /// The message to encode in the Codabar barcode.
  public var message: String {
    get { inputMessage ?? "" }
    set { inputMessage = newValue }
  }

  /// The number of empty white pixels that should surround the barcode.
  public var quietSpace: Int {
    get { inputQuietSpace }
    set { inputQuietSpace = newValue }
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
    inputBarcodeHeight = .defaultBarcodeHeight
  }

  /// Returns a CIImage object that encapsulates the operations configured in the filter.
  public override var outputImage: CIImage? {
    guard
      let message = inputMessage,
      let barcodePattern = Codabar.encode(message)
    else {
      return nil
    }

    let quietSpace = max(0, inputQuietSpace)
    let barcodeHeight = max(0, inputBarcodeHeight)
    return LinearBarcodeRenderer.image(barcodePattern, quietSpace: quietSpace, barcodeHeight: barcodeHeight)
  }
}

class CICodabarBarcodeGeneratorConstructor: CIFilterConstructor {
  func filter(withName name: String) -> CIFilter? {
    return CICodabarBarcodeGenerator()
  }
}

extension Int {
  fileprivate static let defaultQuietSpace: Int = 10
  fileprivate static let defaultBarcodeHeight: Int = 32
}
