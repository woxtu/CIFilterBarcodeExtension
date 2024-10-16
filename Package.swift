// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "CIFilterBarcodeExtension",
  products: [
    .library(
      name: "CIFilterBarcodeExtension",
      targets: ["CIFilterBarcodeExtension"]
    )
  ],
  targets: [
    .target(
      name: "CIFilterBarcodeExtension"
    ),
    .testTarget(
      name: "CIFilterBarcodeExtensionTests",
      dependencies: ["CIFilterBarcodeExtension"]
    ),
  ]
)
