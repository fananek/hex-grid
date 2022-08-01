/// HexGrid is an entry point of the package. It represents a grid of hexagonal cells
public class HexGrid: Codable {

    // MARK: Properties

    /// The `Orientation` of all the hexagons in the grid.
    public var orientation: Orientation

    /// The `OffsetLayout` option for the grid.
    public var offsetLayout: OffsetLayout

    /// A bounding size for each individual hexagon cell in the grid.
    /// Note that for regular hexagons, `hexSize` should be square,
    /// (`width` and `height` values the same), and the
    /// hexagon itself will be drawn slightly inset inside this box.
    /// (Which direction depends on the grid's `orientation`.)
    public var hexSize: HexSize {
        didSet {
            if hexSize != oldValue {
                updatePixelDimensions()
            }
        }
    }

    /// The point of origin for generating pixel coordinates and various drawing-related values.
    public var origin: Point

    /// All the cells in the grid.
    public var cells: Set<Cell> {
        didSet {
            updatePixelDimensions()
        }
    }

    /// User attributes stored on the grid itself.
    public var attributes: [String: Attribute]

    /// Width and height of the entire grid in pixel dimensions.
    /// - Note: This value is calculated at based on the `hexSize` property.
    private(set) public var pixelSize = HexSize(width: 0.0, height: 0.0)

    // MARK: Initializers

    /// Default initializer using a `Set` filled with `Cell` objects.
    /// - Parameters:
    ///   - cells: grid cells `Set<Cell>`
    ///   - orientation: Grid `Orientation` enumeration
    ///   - offsetLayout: `OffsetLayout` enumeration (used to specify row or column offset for rectangular grids)
    ///   - hexSize: `HexSize`
    ///   - origin: Grid origin coordinates (used for drawing related math)
    ///   - attributes: A dictionary of attributes for the entire grid.
    public init(
        cells: Set<Cell>,
        orientation: Orientation = Orientation.pointyOnTop,
        offsetLayout: OffsetLayout = OffsetLayout.even,
        hexSize: HexSize = HexSize(width: 10.0, height: 10.0),
        origin: Point = Point(x: 0, y: 0),
        attributes: [String: Attribute] = [String: Attribute]()
    ) {
        self.cells = cells
        self.orientation = orientation
        self.offsetLayout = offsetLayout
        self.hexSize = hexSize
        self.origin = origin
        self.attributes = attributes
        updatePixelDimensions()
    }

    /// Initializer with generated grid shape, including a `HexSize` (width/height) for the
    /// pixel dimensions of a single hexagon, and an origin `Point` for drawing.
    ///
    /// - Parameters:
    ///   - shape: The `GridShape` to use for generated cells.
    ///   - orientation: Grid `Orientation` enumeration
    ///   - offsetLayout: `OffsetLayout` enumeration (used to specify row or column offset for rectangular grids)
    ///   - hexSize: `HexSize`
    ///   - origin: Grid origin coordinates (used for drawing related math)
    ///   - attributes: A dictionary of attributes for the entire grid.
    public init(
        shape: GridShape,
        orientation: Orientation = Orientation.pointyOnTop,
        offsetLayout: OffsetLayout = OffsetLayout.even,
        hexSize: HexSize = HexSize(width: 10.0, height: 10.0),
        origin: Point = Point(x: 0, y: 0),
        attributes: [String: Attribute] = [String: Attribute]()
    ) {
        self.orientation = orientation
        self.offsetLayout = offsetLayout
        self.hexSize = hexSize
        self.origin = origin
        self.attributes = attributes
        
        do {
            try self.cells = Generator.cellsForGridShape(
                shape: shape,
                orientation: orientation,
                offsetLayout: offsetLayout)
        } catch {
            self.cells = Set<Cell>()
        }
        updatePixelDimensions()
    }

    /// Initializer with generated grid shape and `pixelSize` for the entire grid.
    /// Each hexagon in the grid will "fit" within that size by default.
    /// - Parameters:
    ///   - shape: Shape to be generated
    ///   - orientation: Grid `Orientation` enumeration
    ///   - offsetLayout: `OffsetLayout` enumeration (used to specify row or column offset for rectangular grids)
    ///   - pixelSize: A `HexSize` corresponding to the size for the entire grid.
    ///   - attributes: A dictionary of attributes for the entire grid.
    public init(
        shape: GridShape,
        orientation: Orientation = Orientation.pointyOnTop,
        offsetLayout: OffsetLayout = OffsetLayout.even,
        pixelSize: HexSize = HexSize(width: 100.0, height: 100.0),
        attributes: [String: Attribute] = [String: Attribute]()
    ) {
        self.orientation = orientation
        self.offsetLayout = offsetLayout
        self.pixelSize = pixelSize
        self.attributes = attributes
        do {
            try self.cells = Generator.cellsForGridShape(
                shape: shape,
                orientation: orientation,
                offsetLayout: offsetLayout)
        } catch {
            self.cells = Set<Cell>()
        }
        // these values will be overwritten shortly
        self.hexSize = HexSize(width: 100.0, height: 100.0)
        self.origin = Point(x: 0, y: 0)
        updatePixelDimensions()
        fitGrid(in: pixelSize)
    }

    // MARK: Coordinates
    
    /// Coordinates of all available grid cells
    /// - Returns: `Set<CubeCoordinates>`
    public func allCellsCoordinates() -> Set<CubeCoordinates> {
        return Set(self.cells.map { $0.coordinates })
    }
    
    /// All non-blocked grid cells
    /// - Returns: `Set<Cell>`
    public func nonBlockedCells() -> Set<Cell> {
        return self.cells.filter { !$0.isBlocked }
    }
    
    /// All non-blocked grid cells coordinates
    /// - Returns: `Set<CubeCoordinates>`
    public func nonBlockedCellsCoordinates() -> Set<CubeCoordinates> {
        return Set(nonBlockedCells().map { $0.coordinates })
    }
    
    /// All blocked grid cells
    /// - Returns: `Set<Cell>`
    public func blockedCells() -> Set<Cell> {
        return self.cells.filter { $0.isBlocked }
    }
    
    /// All blocked grid cells coordinates
    /// - Returns: `Set<CubeCoordinates>`
    public func blockedCellsCoordinates() -> Set<CubeCoordinates> {
        return Set(blockedCells().map { $0.coordinates })
    }
    
    /// All opaque grid cells
    /// - Returns: `Set<Cell>`
    public func opaqueCells() -> Set<Cell> {
        return self.cells.filter { $0.isOpaque }
    }
    
    /// All opaque grid cells coordinates
    /// - Returns: `Set<CubeCoordinates>`
    public func opaqueCellsCoordinates() -> Set<CubeCoordinates> {
        return Set(opaqueCells().map { $0.coordinates })
    }
    
    /// Tries to get a grid cells for specified coordinates
    /// - Parameter coordinates: `CubeCoordinates`
    /// - Returns: `Cell` or `nil` in case cell with provided coordinates doesn't exist
    public func cellAt(_ coordinates: CubeCoordinates) -> Cell? {
        return self.cells.first(where: { $0.coordinates == coordinates })
    }
    
    /// Check whether grid cells with specified coordinates exists
    /// - Parameter coordinates: `CubeCoordinates`
    /// - Returns: `Bool`
    public func isValidCoordinates(_ coordinates: CubeCoordinates) -> Bool {
        return self.allCellsCoordinates().contains(coordinates)
    }
    
    // MARK: Cell relations (neighbors and ranges)
    
    /// Search for a cell neighbor at specified direction
    /// - Parameters:
    ///   - cell: `cell`
    ///   - direction: `Int` index of direction
    /// - Returns: `Cell` or `nil` in case neighbor cell doesn't exist on the grid
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note:
    ///     Consider using `Direction` enumeration instead of an Integer value.
    ///
    ///     Example: `Direction.Pointy.northEast.rawValue`
    public func neighbor(for cell: Cell, at direction: Int) throws -> Cell? {
        return try cellAt(Math.neighbor(at: direction, origin: cell.coordinates))
    }
    
    /// Search for a neighbor coordinates at specified direction
    /// - Parameters:
    ///   - coordinates: `CubeCoordinates`
    ///   - direction: `Int` index of direction
    /// - Returns: `CubeCoordinates` or `nil` in case neighbor coordinates are not valid
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note:
    ///     Consider using `Direction` enumeration instead of an Integer value.
    ///
    ///     Example: `Direction.Pointy.northEast.rawValue`
    public func neighborCoordinates(
        for coordinates: CubeCoordinates,
        at direction: Int) throws -> CubeCoordinates? {
        let neighborCoords = try Math.neighbor(at: direction, origin: coordinates)
        return isValidCoordinates(neighborCoords) ? neighborCoords : nil
    }
    
    /// Get all available neighbor cells for specified cell
    /// - Parameter cell: `Cell`
    /// - Returns: `Set<Cell>`
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    public func neighbors(for cell: Cell) throws -> Set<Cell> {
        let neighborsCoordinates = try Math.neighbors(
            for: cell.coordinates).filter { isValidCoordinates($0) }
        return Set(neighborsCoordinates.compactMap { cellAt($0) })
    }
    
    /// Get all available neighbor coordinates for specified coordinates
    /// - Parameter coordinates: `CubeCoordinates`
    /// - Returns: `Set<CubeCoordinates>`
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    public func neighborsCoordinates(for coordinates: CubeCoordinates) throws -> Set<CubeCoordinates> {
        return try Math.neighbors(for: coordinates).filter { isValidCoordinates($0) }
    }
    
    /// Search for a cell neighbor at specified diagonal direction
    /// - Parameters:
    ///   - cell: `cell`
    ///   - direction: `Int` index of direction
    /// - Returns: `Cell` or `nil` in case neighbor cell doesn't exist on the grid
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note:
    ///     Consider using `Direction` enumeration instead of an Integer value.
    ///
    ///     Example: `Direction.Pointy.northEast.rawValue`
    public func diagonalNeighbor(for cell: Cell, at direction: Int) throws -> Cell? {
        return try cellAt(Math.diagonalNeighbor(at: direction, origin: cell.coordinates))
    }
    
    /// Search for a neighbor coordinates at specified diagonal direction
    /// - Parameters:
    ///   - coordinates: `CubeCoordinates`
    ///   - direction: `Int` index of direction
    /// - Returns: `CubeCoordinates` or `nil` in case neighbor coordinates are not valid
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note:
    ///     Consider using `Direction` enumeration instead of an Integer value.
    ///
    ///     Example: `Direction.Pointy.northEast.rawValue`
    public func diagonalNeighborCoordinates(
        for coordinates: CubeCoordinates,
        at direction: Int) throws -> CubeCoordinates? {
        let neighborCoords = try Math.diagonalNeighbor(at: direction, origin: coordinates)
        return isValidCoordinates(neighborCoords) ? neighborCoords : nil
    }
    
    /// Get all available diagonal neighbor cells for specified cell
    /// - Parameter cell: `Cell`
    /// - Returns: `Set<Cell>`
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    public func diagonalNeighbors(for cell: Cell) throws -> Set<Cell> {
        let neighborsCoordinates = try Math.diagonalNeighbors(
            for: cell.coordinates).filter { isValidCoordinates($0) }
        return Set(neighborsCoordinates.compactMap { cellAt($0) })
    }
    
    /// Get all available diagonal neighbor coordinates for specified coordinates
    /// - Parameter coordinates: `CubeCoordinates`
    /// - Returns: `Set<CubeCoordinates>`
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    public func diagonalNeighborsCoordinates(for coordinates: CubeCoordinates) throws -> Set<CubeCoordinates> {
        return try Math.diagonalNeighbors(for: coordinates).filter { isValidCoordinates($0) }
    }
    
    /// Search for coordinates making a line from origin to target coordinates
    /// - Parameters:
    ///   - origin: `CubeCoordinates`
    ///   - target: `CubeCoordinates`
    /// - Returns: `Set<CubeCoordinates>` or `nil` in case valid line doesn't exist
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    public func lineCoordinates(
        from origin: CubeCoordinates,
        to target: CubeCoordinates) throws -> Set<CubeCoordinates>? {
        let mathLine = try Math.line(from: origin, to: target)
        return mathLine.allSatisfy({ isValidCoordinates($0) }) ? mathLine : nil
    }
    
    /// Search for cells making a line from origin to target cell
    /// - Parameters:
    ///   - origin: `Cell`
    ///   - target: `Cell`
    /// - Returns: `Set<Cell>` or `nil` in case valid line doesn't exist
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    public func line(from origin: Cell, to target: Cell) throws -> Set<Cell>? {
        if let lineCoords = try lineCoordinates(from: origin.coordinates, to: target.coordinates) {
            return Set(lineCoords.compactMap { self.cellAt($0) })
        }
        return nil
    }
    
    /// Search for coordinates making a ring from origin coordinates in specified radius
    /// - Parameters:
    ///   - coordinates: `CubeCoordinates`
    ///   - radius: `Int`
    ///   - includingBlocked: optional `Bool`
    /// - Returns: `Set<CubeCoordinates>`
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note: Coordinates of blocked cells are excluded by default.
    public func ringCoordinates(
        from coordinates: CubeCoordinates,
        in radius: Int,
        includingBlocked: Bool = false) throws -> Set<CubeCoordinates> {
        let ring = try Math.ring(from: coordinates, in: radius)
        if includingBlocked {
            return ring.intersection(self.allCellsCoordinates())
        }
        return ring.intersection(self.nonBlockedCellsCoordinates())
    }
    
    /// Search for cells making a ring from origin cell in specified radius
    /// - Parameters:
    ///   - cell: `Cell`
    ///   - radius: `Int`
    ///   - includingBlocked: optional `Bool`
    /// - Returns: `Set<Cell>`
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note: Blocked cells are excluded by default.
    public func ring(from cell: Cell, in radius: Int, includingBlocked: Bool = false) throws -> Set<Cell> {
        return Set(try self.ringCoordinates(
                    from: cell.coordinates,
                    in: radius,
                    includingBlocked: includingBlocked ).compactMap { self.cellAt($0) })
    }
    
    /// Search for coordinates making a filled ring from origin coordinates in specified radius
    /// - Parameters:
    ///   - coordinates: `CubeCoordinates`
    ///   - radius: `Int`
    ///   - includingBlocked: optional `Bool`
    /// - Returns: `Set<CubeCoordinates>`
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note: Coordinates of blocked cells are excluded by default.
    public func filledRingCoordinates(from coordinates: CubeCoordinates, in radius: Int, includingBlocked: Bool = false) throws -> Set<CubeCoordinates> {
        let filledRing = try Math.filledRing(from: coordinates, in: radius)
        if includingBlocked {
            return filledRing.intersection(allCellsCoordinates())
        }
        return filledRing.intersection(nonBlockedCellsCoordinates())
    }
    
    /// Search for cells making a filled ring from origin cell in specified radius
    /// - Parameters:
    ///   - cell: `Cell`
    ///   - radius: `Int`
    ///   - includingBlocked: optional `Bool`
    /// - Returns: `Set<Cell>`
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note: Blocked cells are excluded by default.
    public func filledRing(from cell: Cell, in radius: Int, includingBlocked: Bool = false) throws -> Set<Cell> {
        return Set(try filledRingCoordinates(
                    from: cell.coordinates,
                    in: radius,
                    includingBlocked: includingBlocked).compactMap{ self.cellAt($0) })
        
    }
    
    // MARK: Grid searching (flood search and pathfinding)
    
    /// Search for all coordinates reachable from origin coordinates within specified number of steps
    /// - Parameters:
    ///   - coordinates: `CubeCoordinates` origin
    ///   - steps: maximum number of steps
    /// - Returns: `Set<CubeCoordinates>`
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note: This function internally use Breadth First Search algorithm.
    public func findReachableCoordinates(from coordinates: CubeCoordinates, in steps: Int) throws -> Set<CubeCoordinates> {
        return try Math.breadthFirstSearch(from: coordinates, in: steps, on: self)
    }
    
    /// Search for all cells reachable from origin cell within specified number of steps
    /// - Parameters:
    ///   - cell: `Cell` origin
    ///   - steps: maximum number of steps
    /// - Returns: `Set<Cell>`
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note: This function internally use Breadth First Search algorithm.
    public func findReachable(from cell: Cell, in steps: Int) throws -> Set<Cell> {
        return Set(try self.findReachableCoordinates(
                    from: cell.coordinates,
                    in: steps).compactMap{ self.cellAt($0) })
    }
    
    /// Search for the all coordinates visible from origin coordinates
    /// - Parameters:
    ///   - origin: `CubeCoordinates` viewers position
    ///   - radius: `Int` radius from origin coordinates
    ///   - includePartiallyVisible: include coordinates which are at least partially visible.
    ///   Default value is `false` which means that center of cooridnates has to be visible in order to include it in a result set.
    /// - Returns: `Set<CubeCoordinates>` set of cooridnates visible from origin coordinates within specified radius
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note: This function internally uses shadowcasting algorithm designed for hexagonal grids.
    public func fieldOfViewCoordinates(from origin: CubeCoordinates, in radius: Int, includePartiallyVisible: Bool = false) throws -> Set<CubeCoordinates> {
        return try Math.calculateFieldOfView(
            from: origin, in: radius,
            on: self,
            includePartiallyVisible: includePartiallyVisible)
    }
    
    /// Search for the all cells visible from origin cell
    /// - Parameters:
    ///   - origin: `Cell` viewers position
    ///   - radius: `Int` radius from origin cell
    ///   - includePartiallyVisible: include cells which are at least partially visible.
    ///   Default value is `false` which means that center of a cell has to be visible in order to include it in result set.
    /// - Returns: `Set<Cell>` set of cells visible from origin cell within specified radius
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note: This function internally uses shadowcasting algorithm designed for hexagonal grids.
    public func fieldOfView(from origin: Cell, in radius: Int, includePartiallyVisible: Bool = false) throws -> Set<Cell> {
        return Set(try self.fieldOfViewCoordinates(
                    from: origin.coordinates,
                    in: radius,
                    includePartiallyVisible: includePartiallyVisible).compactMap{ self.cellAt($0) })
    }
    
    /// Search for the shortest path from origin to target coordinates
    /// - Parameters:
    ///   - origin: `CubeCoordinates` starting position
    ///   - target: `CubeCoordinates` target position
    /// - Returns: `[CubeCoordinates]` sorted array of adjacent coordinates or `nil` in case valid path doesn't exist
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note: This function internally use A* algorithm.
    public func findPathCoordinates(from origin: CubeCoordinates, to target: CubeCoordinates) throws -> [CubeCoordinates]? {
        return try Math.aStarPath(from: origin, to: target, on: self)
    }
    
    /// Search for the shortest path from origin to target cell
    /// - Parameters:
    ///   - origin: `Cell` starting position
    ///   - target: `Cell` target position
    /// - Returns: `[Cell]` sorted array of adjacent cells or `nil` in case valid path doesn't exist
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    /// - Note: This function internally use A* algorithm.
    public func findPath(from origin: Cell, to target: Cell) throws -> [Cell]? {
        if let path = try Math.aStarPath(from: origin.coordinates, to: target.coordinates, on: self) {
            return path.compactMap{ self.cellAt($0) }
        }
        return nil
    }
    
    // MARK: UI and Drawing
    
    /// Calculate screen coordinates for corners all hexagon
    /// - Parameter cell: `Cell`
    /// - Returns: `[Point]` Array of points (x, y - screen coordinates). Each point represents one of polygon (hexagon) corners.
    /// - Note: This function take into account grid orientation as well as its origin screen coordinates.
    public func polygonCorners(for cell: Cell) -> [Point] {
        return Math.hexCorners(
            coordinates: cell.coordinates,
            hexSize: self.hexSize,
            origin: self.origin,
            orientation: self.orientation)
    }
    
    /// Calculate screen coordinates for center of a hexagon
    /// - Parameter cell: `Cell`
    /// - Returns: `Point` (x, y - screen coordinates) of a cell center
    /// - Note: This function take into account grid orientation as well as its origin screen coordinates.
    public func pixelCoordinates(for cell: Cell) -> Point {
        return cell.coordinates.toPixel(orientation: self.orientation, hexSize: self.hexSize, origin: self.origin)
    }
    
    /// Get cell for specified screen coordinates
    /// - Parameter pixelCoordinates: `Point` (x, y - screen coordinates)
    /// - Returns: `Cell?` or `nil` if cell doesn't exist for provided screen coordinates
    /// - Note: This function take into account grid orientation as well as its origin screen coordinates.
    public func cellAt(_ pixelCoordinates: Point) throws -> Cell? {
        let coords = Convertor.pixelToCube(
            from: pixelCoordinates,
            hexSize: self.hexSize,
            origin: self.origin,
            orientation: self.orientation)
        return cellAt(coords)
    }

    /// Fit the entire grid inside a given width/height.
    /// - Note: This will potentially change the `hexSize`, `origin`, and `pixelSize` properties.
    public func fitGrid(in size: HexSize) {
        guard size != pixelSize else { return }
        let widthRatio = size.width / pixelSize.width
        let heightRatio = size.height / pixelSize.height
        // a new size that "fits" in the expected size
        var newGridSize = HexSize(width: 0.0, height: 0.0)
        var newHexSize = HexSize(width: 0.0, height: 0.0)
        var difference = HexSize(width: 0.0, height: 0.0)
        if widthRatio <= heightRatio {
            newGridSize.height = pixelSize.height * widthRatio
            newGridSize.width = pixelSize.width * widthRatio
            difference.height = (size.height - newGridSize.height) / 2.0
            newHexSize.height = hexSize.height * widthRatio
            newHexSize.width = hexSize.width * widthRatio
        } else {
            newGridSize.height = pixelSize.height * heightRatio
            newGridSize.width = pixelSize.width * heightRatio
            difference.width = (size.width - newGridSize.width) / 2.0
            newHexSize.height = hexSize.height * heightRatio
            newHexSize.width = hexSize.width * heightRatio
        }
        pixelSize = newGridSize
        hexSize = newHexSize
        setOriginToFitPixelSize(offset: difference)
    }

    /// Set the origin to the middle of the grid.
    public func setOriginToFitPixelSize(offset: HexSize) {
        var minX: Double = 0.0
        var maxX: Double = 0.0
        var minY: Double = 0.0
        var maxY: Double = 0.0

        for cell in cells {
            let pixelCoords = pixelCoordinates(for: cell)
            minX = min(minX, pixelCoords.x)
            maxX = max(maxX, pixelCoords.x)
            minY = min(minY, pixelCoords.y)
            maxY = max(maxY, pixelCoords.y)
        }

        var cellPixelWidth: Double
        var cellPixelHeight: Double
        switch orientation {
        case .pointyOnTop:
            cellPixelWidth = (3.0).squareRoot() * hexSize.width
            cellPixelHeight = 2.0 * hexSize.height
        case .flatOnTop:
            cellPixelWidth = 2.0 * hexSize.width
            cellPixelHeight = (3.0).squareRoot() * hexSize.height
        }

        origin = Point(
            x: origin.x-minX+(cellPixelWidth/2.0) + offset.width,
            y: origin.y-minY+(cellPixelHeight/2.0) + offset.height
        )
    }

    // MARK: Internal functions

    /// Function keeps grid dimensions updated using property observer
    fileprivate func updatePixelDimensions() -> Void {
        var minX: Double = 0.0
        var maxX: Double = 0.0
        var minY: Double = 0.0
        var maxY: Double = 0.0
        
        for cell in cells {
            let pixelCoords = pixelCoordinates(for: cell)
            minX = min(minX, pixelCoords.x)
            maxX = max(maxX, pixelCoords.x)
            minY = min(minY, pixelCoords.y)
            maxY = max(maxY, pixelCoords.y)
        }
        var cellPixelWidth: Double
        var cellPixelHeight: Double
        switch orientation {
        case .pointyOnTop:
            cellPixelWidth = (3.0).squareRoot() * hexSize.width
            cellPixelHeight = 2.0 * hexSize.height
        case .flatOnTop:
            cellPixelWidth = 2.0 * hexSize.width
            cellPixelHeight = (3.0).squareRoot() * hexSize.height
        }
        pixelSize.width = (maxX - minX) + cellPixelWidth
        pixelSize.height = (maxY - minY) + cellPixelHeight
    }
}
