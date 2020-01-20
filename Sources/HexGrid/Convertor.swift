/// Allows conversion between several coordinate systems.
///
/// While cube coordinate system is suitable for most of alghoritms, axial
///  or offset coordinate systems are often better for storage or rendering.
internal struct Convertor {
    
    /// Converts coordinates from `cube` to `offset`
    ///
    /// - parameters:
    ///     - fromCoordinates: Original coordinates to be coverted.
    ///     - orientation: See `OrientationEnumeration`
    ///     - offsetLayout: See `OffsetLayoutEnumeration`
    static func cubeToOffset (
        from: CubeCoordinates,
        orientation: Orientation,
        offsetLayout: OffsetLayout) -> OffsetCoordinates {
        let column, row: Int
        
        switch orientation {
        case Orientation.pointyOnTop:
            column = from.x + ((from.z + offsetLayout.rawValue * (abs(from.z) & 1)) / 2)
            row = from.z
            return OffsetCoordinates(column: column, row: row, orientation: orientation, offsetLayout: offsetLayout)
            
        case Orientation.flatOnTop:
            column = from.x
            row = from.z + ((from.x + offsetLayout.rawValue * (abs(from.x) & 1)) / 2)
            return OffsetCoordinates(column: column, row: row, orientation: orientation, offsetLayout: offsetLayout)
        }
    }
    
    /// Converts coordinates from `offset` to `cube`
    ///
    /// - parameters:
    ///     - fromCoordinates: Original coordinates to be coverted.
    /// - throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    static func offsetToCube (from: OffsetCoordinates) throws -> CubeCoordinates {
        let x, y, z: Int
        
        switch from.orientation {
        case Orientation.pointyOnTop:
            
            x = from.column - ((from.row + from.offsetLayout.rawValue * (abs(from.row) & 1)) / 2)
            z = from.row
            y = -x - z
            return try CubeCoordinates(x: x, y: y, z: z)
            
        case Orientation.flatOnTop:
            x = from.column
            z = from.row - ((from.column + from.offsetLayout.rawValue * (abs(from.column) & 1)) / 2)
            y = -x - z
            return try CubeCoordinates(x: x, y: y, z: z)
        }
    }
    
    /// Converts coordinates from `cube` to `axial`
    ///
    /// - parameters:
    ///     - fromCoordinates: Original coordinates to be coverted.
    static func cubeToAxial (from: CubeCoordinates) -> AxialCoordinates {
        return AxialCoordinates(q: from.x, r: from.z)
    }
    
    /// Converts coordinates from `axial` to `cube`
    ///
    /// - parameters:
    ///     - fromCoordinates: Original coordinates to be coverted.
    /// - throws: `InvalidArgumentsError` in case sum of underlying cube coordinates initializer propagate the error.
    static func axialToCube (from: AxialCoordinates) throws -> CubeCoordinates {
        return try CubeCoordinates(x: from.q, y: (-from.q - from.r), z: from.r)
    }
    
    static func cubeToPixel(
        from coordinates: CubeCoordinates,
        hexSize: HexSize,
        gridOrigin: Point,
        orientation: Orientation) -> Point {
        let axialCoords = coordinates.toAxial()
        let orientation = OrientationMatrix(orientation: orientation)
        let x = ((orientation.f00 * Double(axialCoords.q)) + (orientation.f10 * Double(axialCoords.r))) * hexSize.width
        let y = ((orientation.f01 * Double(axialCoords.q)) + (orientation.f11 * Double(axialCoords.r))) * hexSize.height

        return Point(x: x + gridOrigin.x, y: y + gridOrigin.y)
    }

    static func pixelToCube(
        from point: Point,
        hexSize: HexSize,
        origin: Point,
        orientation: Orientation) -> CubeCoordinates {
        let orientation = OrientationMatrix(orientation: orientation)
        let point = (x: (point.x - origin.x) / hexSize.width, y: (point.y - origin.y) / hexSize.height)
        let x = orientation.b00 * point.x + orientation.b10 * point.y
        let y = orientation.b01 * point.x + orientation.b11 * point.y
        return CubeCoordinates(x: x, y: -x-y, z: y)
    }
}
