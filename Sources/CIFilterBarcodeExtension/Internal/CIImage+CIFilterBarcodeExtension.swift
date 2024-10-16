import CoreImage

extension CIImage {
  static func rgba8(bitmapData data: Data, size: CGSize) -> CIImage {
    return .init(
      bitmapData: data,
      bytesPerRow: Int(size.width) * 4,
      size: size,
      format: .RGBA8,
      colorSpace: CGColorSpaceCreateDeviceRGB()
    )
  }
}
