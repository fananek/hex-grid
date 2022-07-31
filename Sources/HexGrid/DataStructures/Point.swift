/// Basic structure containing an `x` and `y` value.
public struct Point: Codable, Equatable {
    public var x, y: Double

    /// Initializing the `Point`.
    /// - Parameters:
    ///   - x: horizontal coordinate value
    ///   - y: vertical coordinate value
    public init (x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}
