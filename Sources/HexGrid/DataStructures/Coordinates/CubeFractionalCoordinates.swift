import Foundation

/// Represents coordinates in Cube format using x, y and z axis
public struct CubeFractionalCoordinates: Hashable {
    public let x: Double
    public let y: Double
    public let z: Double
    
    /// Basic Initializer
    ///
    /// - parameters:
    ///     - x: Value of x axis.
    ///     - y: Value of y axis.
    ///     - z: Value of z axis.
    /// - throws: `InvalidArgumentsError` in case sum of coordinates is not equal to zero.
    public init(x: Double, y: Double, z: Double) throws {
        self.x = x
        self.y = y
        self.z = z

        if (round(self.x + self.y + self.z)) != 0 {
            throw InvalidArgumentsError(message: "Sum of coordinate values is not equal to zero.")
        }
    }
}
