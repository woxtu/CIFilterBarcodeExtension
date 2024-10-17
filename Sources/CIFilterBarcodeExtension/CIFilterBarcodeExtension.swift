import CoreImage

public enum CIFilterBarcodeExtension {
  /// Generates an EAN-8 barcode.
  public static func ean8BarcodeGenerator() -> CIEAN8BarcodeGenerator { .init() }

  /// Generates an EAN-13 barcode.
  public static func ean13BarcodeGenerator() -> CIEAN13BarcodeGenerator { .init() }

  /// Generates an Interleaved 2 of 5 barcode.
  public static func interleaved2of5BarcodeGenerator() -> CIInterleaved2of5BarcodeGenerator { .init() }

  /// Generates an ITF-14 barcode.
  public static func itf14BarcodeGenerator() -> CIITF14BarcodeGenerator { .init() }

  /// Publishes all generator filters provided by the package.
  public static func registerAll() {
    CIFilter.registerName(
      .init(describing: CIEAN8BarcodeGenerator.self),
      constructor: CIEAN8BarcodeGeneratorConstructor()
    )
    CIFilter.registerName(
      .init(describing: CIEAN13BarcodeGenerator.self),
      constructor: CIEAN13BarcodeGeneratorConstructor()
    )
    CIFilter.registerName(
      .init(describing: CIInterleaved2of5BarcodeGenerator.self),
      constructor: CIInterleaved2of5BarcodeGeneratorConstructor()
    )
    CIFilter.registerName(
      .init(describing: CIITF14BarcodeGenerator.self),
      constructor: CIITF14BarcodeGeneratorConstructor()
    )
  }
}
