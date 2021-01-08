/// Represents coordinates in Axial format using q, r axis.
/// q - you can imagine as a column
/// r - you can imagine as a row
///
/// Axial coordinates are used mainly for storage purposes.
/// Use it carefully because it can't be validated like Cube coordinates.
public struct AxialCoordinates: Codable {
    public let q, r: Int

    /// Basic Initializer
    ///
    /// - parameters:
    ///     - q: Value of q axis (column).
    ///     - r: Value of r axis (row).
    public init(q: Int, r: Int) {
        self.q = q
        self.r = r
    }
}

// conversion functions
extension AxialCoordinates {

    /// Converts coordinates to cube system
    /// - throws: `InvalidArgumentsError` in case sum of result coordinates is not equal to zero.
    public func toCube() throws -> CubeCoordinates {
        return try Convertor.axialToCube(from: self)
    }
}

// Helpers
extension AxialCoordinates: Equatable {
    public static func ==(lhs: AxialCoordinates, rhs: AxialCoordinates) -> Bool {
        return lhs.q == rhs.q && lhs.r == rhs.r
    }
}
