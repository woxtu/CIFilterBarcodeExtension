import CoreImage

public enum CIFilterBarcodeExtension {
  /// Generates an Interleaved 2 of 5 barcode.
  public static func interleaved2of5BarcodeGenerator() -> CIInterleaved2of5BarcodeGenerator { .init() }

  /// Publishes all generator filters provided by the package.
  public static func registerAll() {
    CIFilter.registerName(
      .init(describing: CIInterleaved2of5BarcodeGenerator.self),
      constructor: CIInterleaved2of5BarcodeGeneratorConstructor()
    )
  }
}
