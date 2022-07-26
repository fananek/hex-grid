/// Generates grid based on parameters
internal struct Generator {
    
    /// Create grid of rectangular shape
    /// - parameters:
    ///     - orientation: See `OrientationEnumeration` options
    ///     - offsetLayout: See `OffsetLayoutEnumeration` options
    ///     - width: number of columns
    ///     - height: number of rows
    static func createRectangleGrid (
        orientation: Orientation,
        offsetLayout: OffsetLayout,
        width: Int,
        height: Int) throws -> Set<CubeCoordinates> {
        guard width > 0, height > 0 else {
            throw InvalidArgumentsError(message: "Rectangle width and height must be greater than zero.")
        }
        var tiles = Set<CubeCoordinates>()
        switch orientation {
        case Orientation.pointyOnTop:
            switch offsetLayout {
            // outer loop: y, inner loop: x
            case OffsetLayout.even:
                for y in 0..<height {
                    let offset = y>>1
                    for x in -offset..<width-offset {
                        tiles.insert(try (CubeCoordinates(x: x, y: y, z: -x-y)))
                    }
                }
            // outer loop: x, inner loop: y
            case OffsetLayout.odd:
                for x in 0..<height {
                    let offset = x>>1
                    for y in -offset..<width-offset {
                        tiles.insert(try (CubeCoordinates(x: x, y: y, z: -x-y)))
                    }
                }
            }
        case Orientation.flatOnTop:
            switch offsetLayout {
            // outer loop: x, inner loop: y
            case OffsetLayout.even:
                for x in 0..<width {
                    let offset = x>>1
                    for y in -offset..<height-offset {
                        tiles.insert(try (CubeCoordinates(x: x, y: y, z: -x-y)))
                    }
                }
            // outer loop: z, inner loop: y
            case OffsetLayout.odd:
                for z in 0..<width {
                    let offset = z>>1
                    for y in -offset..<height-offset {
                        tiles.insert(try (CubeCoordinates(x: -y-z, y: y, z: z)))
                    }
                }
            }
        }
        return tiles
    }
    
    /// Create grid of hexagonal shape
    /// - parameters:
    ///     - sideLength: side length of desired hexagonal shape (1 -> single tile, 2 -> 7 tiles, 3 -> 19 tiles...)
    static func createHexagonGrid (
        sideLength: Int
        ) throws -> Set<CubeCoordinates> {
        guard sideLength > 0 else {
            throw InvalidArgumentsError(message: "Hexagon side length must be greater than zero.")
        }
        let side = sideLength - 1
        var tiles = Set<CubeCoordinates>()
        for x in -side...side {
            for y in max(-side, -x-side)...min(side, -x+side) {
                tiles.insert(try (CubeCoordinates(x: x, y: y, z: -x-y)))
            }
        }
        return tiles
    }

    /// Create grid of triangular (equilateral) shape
    /// - parameters:
    ///     - orientation: See `OrientationEnumeration` options
    ///     - sideLength: size of a triangle side (result triangle is equilateral)
    static func createTriangleGrid (
        orientation: Orientation,
        sideLength: Int
        ) throws -> Set<CubeCoordinates> {
        guard sideLength > 0 else {
            throw InvalidArgumentsError(message: "Triangle side length must be greater than zero.")
        }
        var tiles = Set<CubeCoordinates>()
        let side = sideLength - 1
        switch orientation {
        case Orientation.pointyOnTop:
            for x in 0...side {
                for y in 0...side-x {
                    tiles.insert(try (CubeCoordinates(x: x, y: y, z: -x-y)))
                }
            }
        case Orientation.flatOnTop:
            for x in 0...side {
                for y in side-x...side {
                    tiles.insert(try (CubeCoordinates(x: x, y: y, z: -x-y)))
                }
            }
        }
        return tiles
    }
}
