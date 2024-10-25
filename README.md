# CIFilterBarcodeExtension

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg?style=flat-square)](https://github.com/apple/swift-package-manager)

A package that provides Core Image filters to generate barcodes.

```swift
import CIFilterBarcodeExtension

let barcodeGenerator = CIFilterBarcodeExtension.ean13BarcodeGenerator()
barcodeGenerator.message = "0123456789012"
let barcodeImage = barcodeGenerator.outputImage!
```

### Supported formats

- Codabar
- Code 39
- Code 93
- EAN-8
- EAN-13
- Interleaved 2 of 5
- ITF14
- UPC-E

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/woxtu/CIFilterBarcodeExtension.git", from: "1.0.0")
```

## Acknowledgments

- [ZXing](https://github.com/zxing/zxing/)

## License

Licensed under the MIT license.
