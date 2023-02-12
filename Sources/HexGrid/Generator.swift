/// Generates grid based on parameters
internal struct Generator {

    /// A Set of `Cell`s based on `GridShape`, `Orientation`, and `OffsetLayout`.
    /// - parameters:
    ///    - shape: The `GridShape` for our `Cell` values.
    ///    - orientation: An `Orientation` value for the generated set of `Cell` values.
    ///    - offsetLayout: The `OffsetLayout` for the generated set of `Cell`s.
    /// - returns: A `Set<Cell>`, suitable for use in `HexGrid`.
    static func cellsForGridShape(
        shape: GridShape,
        orientation: Orientation,
        offsetLayout: OffsetLayout
    ) throws -> Set<Cell> {
        switch shape {
        case .hexagon(let sideLength):
            return try Set(Generator.createHexagonGrid(sideLength: sideLength).map { Cell($0) })
        case .parallelogram(let width, let height):
            return try Set(Generator.createParallelogramGrid(
                width: width,
                height: height).map { Cell($0) })
        case .rectangle(let width, let height):
            return try Set(Generator.createRectangleGrid(
                orientation: orientation,
                offsetLayout: offsetLayout,
                width: width,
                height: height).map { Cell($0) })
        case .triangle(let sideSize):
            return try Set(Generator.createTriangleGrid(
                orientation: orientation,
                sideLength: sideSize).map { Cell($0) })
        }
    }

    /// Create grid of rectangular (parallelogram) shape
    /// - parameters:
    ///     - width: number of columns
    ///     - height: number of rows
    static func createParallelogramGrid(
        width: Int,
        height: Int
    ) throws -> Set<CubeCoordinates> {
        guard width > 0, height > 0 else {
            throw InvalidArgumentsError(message: "Rectangle width and height must be greater than zero.")
        }
        var tiles = Set<CubeCoordinates>()
        for row in 0..<height {
            for column in 0..<width {
                tiles.insert(try AxialCoordinates(q: row, r: column).toCube())
            }
        }
        return tiles
    }

    /// Create grid of rectangular shape (whose edges are more or less vertical and horizontal)
    /// - parameters:
    ///     - orientation: See `OrientationEnumeration` options
    ///     - offsetLayout: See `OffsetLayoutEnumeration` options
    ///     - width: number of columns
    ///     - height: number of rows
    static func createRectangleGrid(
        orientation: Orientation,
        offsetLayout: OffsetLayout,
        width: Int,
        height: Int
    ) throws -> Set<CubeCoordinates> {
        guard width > 0, height > 0 else {
            throw InvalidArgumentsError(message: "Rectangle width and height must be greater than zero.")
        }
        var tiles = Set<CubeCoordinates>()
        switch orientation {
        case Orientation.pointyOnTop:
            for r in 0..<height {
                var offset: Int
                switch offsetLayout {
                case OffsetLayout.even:
                    offset = (r+1)>>1
                case OffsetLayout.odd:
                    offset = (r)>>1
                }
                for q in -offset..<width-offset {
                    tiles.insert(try AxialCoordinates(q: q, r: r).toCube())
                }
            }
        case Orientation.flatOnTop:
            for q in 0..<width {
                var offset: Int
                switch offsetLayout {
                case OffsetLayout.even:
                    offset = (q+1)>>1
                case OffsetLayout.odd:
                    offset = (q)>>1
                }
                for r in -offset..<height-offset {
                    tiles.insert(try AxialCoordinates(q: q, r: r).toCube())
                }
            }
        }
        return tiles
    }

    /// Create grid of hexagonal shape
    /// - parameters:
    ///     - sideLength: side length of desired hexagonal shape (1 -> single tile, 2 -> 7 tiles, 3 -> 19 tiles...)
    static func createHexagonGrid(
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
    static func createTriangleGrid(
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
