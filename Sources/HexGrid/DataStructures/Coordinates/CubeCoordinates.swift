import Foundation

/// Represents coordinates in Cube format using x, y and z axis
public struct CubeCoordinates: Hashable, Codable {
    public let x, y, z: Int
    
    /// Basic Initializer
    ///
    /// - parameters:
    ///     - x: Value of x axis.
    ///     - y: Value of y axis.
    ///     - z: Value of z axis.
    /// - throws: `InvalidArgumentsError` in case sum of coordinates is not equal to zero.
    public init(x: Int, y: Int, z: Int) throws {
        self.x = x
        self.y = y
        self.z = z
        
        if (self.x + self.y + self.z) != 0 {
            throw InvalidArgumentsError(message: "Sum of coordinate values is not equal to zero.")
        }
    }
    
    /// Initializer for Double type
    ///
    /// - parameters:
    ///     - x: Value of x axis.
    ///     - y: Value of y axis.
    ///     - z: Value of z axis.
    /// - note:
    ///  There is an algorithm in place which make sure that rule `x + y + z = 0`is not violated
    public init(x: Double, y: Double, z: Double) {
        var xInt = round(x)
        var yInt = round(y)
        var zInt = round(z)
        let xDiff = abs(xInt - x)
        let yDiff = abs(yInt - y)
        let zDiff = abs(zInt - z)
        if xDiff > yDiff && xDiff > zDiff {
            xInt = -yInt - zInt
        } else if yDiff > zDiff {
            yInt = -xInt - zInt
        } else {
            zInt = -xInt - yInt
        }
        self.x = Int(xInt.rounded())
        self.y = Int(yInt.rounded())
        self.z = Int(zInt.rounded())
    }
}

// conversion functions
extension CubeCoordinates {
    
    /// Converts coordinates to axial system
    public func toAxial () -> AxialCoordinates {
        return Convertor.cubeToAxial(from: self)
    }

    /// Converts coordinates to offset system
    /// - parameters:
    ///     - orientation: See `OrientationEnumeration` options
    ///     - offsetLayout: See `OffsetLayoutEnumeration` options
    public func toOffset (orientation: Orientation, offsetLayout: OffsetLayout) -> OffsetCoordinates {
        return Convertor.cubeToOffset(from: self, orientation: orientation, offsetLayout: offsetLayout)
    }

    /// Converts coordinates to pixel coordinates
    /// - parameters:
    ///     - orientation: See `OrientationEnumeration` options
    ///     - hexSize: pixel size of a single hex in x and y axis
    ///     - origin: pixel coordinates of a grid origin
    public func toPixel (orientation: Orientation, hexSize: HexSize, origin: Point) -> Point {
        return Convertor.cubeToPixel(from: self, hexSize: hexSize, gridOrigin: origin, orientation: orientation)
    }
}

extension CubeCoordinates: Equatable {
    public static func ==(lhs: CubeCoordinates, rhs: CubeCoordinates) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}
