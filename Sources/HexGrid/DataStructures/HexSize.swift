public struct HexSize: Codable {
    var width: Double
    var height: Double

    /// Width and Height of a hex
    /// - Parameters:
    ///   - width: width of a hex
    ///   - height: height of a hex
    /// - Note:
    ///     Using different width and height you can generate various aspect ratios.
    public init (width: Double, height: Double) {
        self.width = width
        self.height = height
    }
}
