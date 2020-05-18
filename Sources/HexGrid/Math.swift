import Foundation

/// Math operations for hexagon related calculations.
internal struct Math {
    
    // Basic arithmetic operations
    /// Add operation
    ///
    /// - Parameters:
    ///     - a: Coordinates of a first hexagon.
    ///     - b: Coordinates of a second hexagon.
    /// - Returns: Result coordinates
    static func add (a: CubeCoordinates, b: CubeCoordinates) throws -> CubeCoordinates {
        return try CubeCoordinates(x: a.x + b.x, y: a.y + b.y, z: a.z + b.z)
    }
    
    /// Subtract operation
    ///
    /// - Parameters:
    ///     - a: Coordinates of minuend.
    ///     - b: Coordinates of subtrahend.
    /// - Returns: Result coordinates
    static func subtract (a: CubeCoordinates, b: CubeCoordinates) throws -> CubeCoordinates {
        return try CubeCoordinates(x: a.x - b.x, y: a.y - b.y, z: a.z - b.z)
    }
    
    /// Scale operation for direction vectors
    ///
    /// - Parameters:
    ///     - a: Coordinates of factor.
    ///     - c: Coefficient.
    /// - Returns: Result coordinates
    /// - Note:
    ///     This function works only with vectors coordinates! See `CoordinateMath.directions` for more details.
    ///     Using other than vector coordinates as an argument `a` might produce invalid coordinates.
    ///
    ///     Result coordinates must fulfill the same condition `sum(x+y+z)`as any cube coordinates used in this library.
    static func scale (a: CubeCoordinates, c: Int) throws -> CubeCoordinates {
        return try CubeCoordinates(x: a.x * c, y: a.y * c, z: a.z * c)
    }
    
    // distance functions
    /// Hexagon length in grid units
    ///
    /// - Parameters:
    ///     - coordinates: Coordinates of a hexagon.
    /// - Returns: Length
    static func length (coordinates: CubeCoordinates) -> Int {
        return ((abs(coordinates.x) + abs(coordinates.y) + abs(coordinates.z)) / 2)
    }
    
    /// Distance between `from`and `to` hexagons in grid units
    ///
    /// - Parameters:
    ///     - from: Coordinates of the initial hexagon.
    ///     - to: Coordinates of the destination hexagon.
    /// - Returns: Distance between two coordinates
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    static func distance (from: CubeCoordinates, to: CubeCoordinates) throws -> Int {
        return try length(coordinates: subtract(a: from, b: to))
    }
    
    // neighbors
    /// Predefined neighbor coordinates
    fileprivate static let directions = try! [
        CubeCoordinates(x:  1, y:  0, z: -1),
        CubeCoordinates(x:  1, y: -1, z:  0),
        CubeCoordinates(x:  0, y: -1, z:  1),
        CubeCoordinates(x: -1, y:  0, z:  1),
        CubeCoordinates(x: -1, y:  1, z:  0),
        CubeCoordinates(x:  0, y:  1, z: -1)
    ]
    
    /// Get one of the predefined neighbor coordinates based on index
    ///
    /// - Parameters:
    ///     - at: index of desired direction (0...5).
    /// - Returns: Coordinates of a specified direction
    /// - Note:
    /// This formula `(6 + (index % 6)) % 6` make it work with index outside of 0...5.
    /// Works also with negative numbers.
    ///
    /// This makes `directions`  a closed loop. When an index overflow the array boundary it continues on the other side.
    ///
    /// examples:
    ///
    ///   index  `6` will return the same direction as index `0`
    ///
    ///   index `-1` will return the same direction as index `5`
    ///
    ///   index `13` will return the same direction as index `1`
    static func direction(at index: Int) -> CubeCoordinates {
        return directions[(6 + (index % 6)) % 6]
    }
    
    /// Get coordinates of a neighbor based on specified direction
    ///
    /// - Parameters:
    ///     - at: index of desired direction (0...5).
    ///     - origin: Coordinates of the origin hexagon.
    /// - Returns: Coordinates of a neighbor at specified direction
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    static func neighbor(at index: Int, origin: CubeCoordinates) throws -> CubeCoordinates {
        return try add(a: origin, b: direction(at: index))
    }
    
    /// Get coordinates of all neighbors
    ///
    /// - Parameters:
    ///     - coordinates: Coordinates of the origin hexagon.
    /// - Returns: Set of CubeCoordinates
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    static func neighbors(for coordinates: CubeCoordinates) throws -> Set<CubeCoordinates> {
        var allNeighbors: Set<CubeCoordinates> = Set<CubeCoordinates>()
        for index in 0...5 {
            allNeighbors.insert(try neighbor(at: index, origin: coordinates))
        }
        return allNeighbors
    }
    
    /// Predefined diagonal coordinates
    fileprivate static let diagonalDirections: [CubeCoordinates] = try! [
        CubeCoordinates(x:  2, y: -1, z: -1),
        CubeCoordinates(x:  1, y:  1, z: -2),
        CubeCoordinates(x: -1, y:  2, z: -1),
        CubeCoordinates(x: -2, y:  1, z:  1),
        CubeCoordinates(x: -1, y: -1, z:  2),
        CubeCoordinates(x:  1, y: -2, z:  1)
    ]
    
    /// Get one of the predefined diagonal neighbor coordinates based on index
    ///
    /// - Parameters:
    ///     - at: index of desired direction (0...5).
    /// - Returns: Coordinates of a specified diagonal direction
    /// - Note:
    /// This formula `(6 + (index % 6)) % 6` make it work with index outside of 0...5. Works also with negative numbers.
    ///
    /// This makes `diagonalDirections` a closed loop. When index overflow an array boundary it continues on the other side.
    ///
    /// examples:
    ///
    ///   index  `6` will return the same direction as index `0`
    ///
    ///   index `-1` will return the same direction as index `5`
    ///
    ///   index `13` will return the same direction as index `1`
    static func diagonalDirection(at index: Int) -> CubeCoordinates {
        // This ugly formula make it work with index outside of 0...5
        // It's useful for negative numbers (e.g. backward rotation)
        return diagonalDirections[(6 + (index % 6)) % 6]
    }
    
    /// Get coordinates of a diagonal neighbor based on specified direction
    ///
    /// - Parameters:
    ///     - at: index of desired direction (0...5).
    ///     - origin: Coordinates of the origin hexagon.
    /// - Returns: Coordinates of a diagonal neighbor at specified direction
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    static func diagonalNeighbor(at index: Int, origin: CubeCoordinates) throws -> CubeCoordinates {
        return try add(a: origin, b: diagonalDirection(at: index))
    }
    
    /// Get coordinates of all diagonal neighbors
    ///
    /// - Parameters:
    ///     - coordinates: Coordinates of the origin hexagon.
    /// - Returns: Set of CubeCoordinates
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    static func diagonalNeighbors(for coordinates: CubeCoordinates) throws -> Set<CubeCoordinates> {
        var allNeighbors: Set<CubeCoordinates> = Set<CubeCoordinates>()
        for index in 0...5 {
            allNeighbors.insert(try diagonalNeighbor(at: index, origin: coordinates))
        }
        return allNeighbors
    }
    
    // Rotation
    /// Rotate Left
    /// - Parameters:
    ///     - coordinates: coordinates to be rotated
    /// - Returns: rotated coordinates
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    static func rotateLeft(coordinates: CubeCoordinates) throws -> CubeCoordinates
    {
        return try CubeCoordinates(x: -coordinates.y, y: -coordinates.z, z: -coordinates.x)
    }
    
    /// Rotate Right
    /// - Parameters:
    ///     - coordinates: coordinates to be rotated
    /// - Returns: rotated coordinates
    /// - Throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    static func rotateRight(coordinates: CubeCoordinates) throws -> CubeCoordinates
    {
        return try CubeCoordinates(x: -coordinates.z, y: -coordinates.x, z: -coordinates.y)
    }
    
    // Screen coordinates related math
    
    // Helper function for hex corner offset calculation
    fileprivate static func hexCornerOffset(at index: Int, hexSize: HexSize, orientation: Orientation) -> Point {
        let angle = 2.0 * Double.pi * (
            OrientationMatrix(orientation: orientation).startAngle + Double(index)) / 6
        return Point(x: hexSize.width * cos(angle), y: hexSize.height * sin(angle))
    }
    
    /// Hex Corners
    /// - Parameters:
    ///     - coordinates: coordinates of a hex
    ///     - hexSize: represents display height and width of a hex
    ///     - gridOrigin: display coordinates of a grid origin
    ///     - orientation: orientation of a grid
    /// - Returns: Array of six display coordinates (polygon vertices).
    static func hexCorners(
        coordinates: CubeCoordinates,
        hexSize: HexSize,
        origin: Point,
        orientation: Orientation) -> [Point] {
        var corners = [Point]()
        let center = Convertor.cubeToPixel(from: coordinates, hexSize: hexSize, gridOrigin: origin, orientation: orientation)
        for i in 0...5 {
            let offset = hexCornerOffset(at: i, hexSize: hexSize, orientation: orientation)
            corners.append(Point(x: center.x + offset.x, y: center.y + offset.y))
        }
        return corners
    }
    
    // Algorithms
    /// Linear interpolation between two hexes (fractional cube coordinates)
    /// - Parameters:
    ///     - a: first coordinates
    ///     - b: second coordinates
    /// - Returns: Interpolated coordinates
    static func lerpCube(a: CubeFractionalCoordinates, b: CubeFractionalCoordinates, f: Double) -> CubeCoordinates
    {
        return CubeCoordinates(
            x: a.x * (1.0 - f) + b.x * f,
            y: a.y * (1.0 - f) + b.y * f,
            z: a.z * (1.0 - f) + b.z * f)
    }
    
    /// Line between two hexes
    /// - Parameters:
    ///     - from: origin coordinates
    ///     - to: target coordinates
    /// - Returns: Set of all coordinates making a line from coordinate `a` to coordinate `b`
    static func line(from a: CubeCoordinates, to b: CubeCoordinates) throws -> Set<CubeCoordinates> {
        let n = try distance(from: a, to: b)
        let aNudge = try CubeFractionalCoordinates(
            x: Double(a.x) + 1e-06,
            y: Double(a.y) + 1e-06,
            z: Double(a.z) - 2e-06)
        let bNudge = try CubeFractionalCoordinates(
            x: Double(b.x) + 1e-06,
            y: Double(b.y) + 1e-06,
            z: Double(b.z) - 2e-06)
        var results = Set<CubeCoordinates>()
        let step = 1.0 / Double(max(n, 1))
        for i in 0...n {
            results.insert(lerpCube(a: aNudge, b: bNudge, f: step * Double(i)))
        }
        return results
    }
    
    /// Ring algorithm
    /// - Parameters:
    ///     - from: coordinates of a ring center
    ///     - in: ring radius
    /// - Returns: Set of all coordinates making a ring from hex `origin` on `radius`
    static func ring(from origin: CubeCoordinates, in radius: Int) throws -> Set<CubeCoordinates> {
        var results = Set<CubeCoordinates>()
        switch radius {
        case Int.min..<0:
            throw InvalidArgumentsError(message: "Radius can't be less than zero.")
        case 0:
            results.insert(origin)
        default:
            var h = try add(a: origin, b: scale(a: direction(at: 4), c: radius))
            for side in 0..<6 {
                for _ in 0..<radius {
                    results.insert(h)
                    h = try neighbor(at: side, origin: h)
                }
            }
        }
        return results
    }
    
    /// Filled Ring algorithm
    ///     - from: coordinates of a ring center
    ///     - in: ring radius
    /// - Returns: Set of all coordinates making a filled ring from hex `origin` on `radius`
    static func filledRing(from origin: CubeCoordinates, in radius: Int) throws -> Set<CubeCoordinates> {
        var results = Set<CubeCoordinates>()
        if radius < 0 {
            throw InvalidArgumentsError(message: "Radius can't be less than zero.")
        }
        results.insert(origin)
        for step in 1...radius {
            try results = results.union(ring(from: origin, in: step))
        }
        return results
    }
    
    /// Breadth First Search algorithm (flood algorithm)
    ///     - from: coordinates of a search origin
    ///     - in: search radius
    ///     - blocked: set of blocked coordinates
    /// - Returns: Set of all reachable coordinates within specified `radius`, considering obstacles
    static func breadthFirstSearch(
        from origin: CubeCoordinates,
        in steps: Int,
        on grid: HexGrid) throws -> Set<CubeCoordinates> {
        if steps < 0 {
            throw InvalidArgumentsError(message: "Radius can't be less than zero.")
        }
        let blocked = grid.blockedCellsCoordinates()
        var results = Set<CubeCoordinates>()
        results.insert(origin)
        var fringes = [Set<CubeCoordinates>]()
        fringes.append([origin])
        var neighborCoordinates: CubeCoordinates
        
        for k in 1...steps {
            fringes.append([])
            for coord in fringes[k-1] {
                for direction in 0..<6 {
                    neighborCoordinates = try neighbor(at: direction, origin: coord)
                    if !(blocked.contains(neighborCoordinates) || results.contains(neighborCoordinates) || !grid.isValidCoordinates(neighborCoordinates)) {
                        results.insert(neighborCoordinates)
                        fringes[k].insert(neighborCoordinates)
                    }
                }
            }
        }
        return results
    }
    
    
    /// Reconstruct path based on the target node found by an aStar search algorithm
    ///
    /// - parameter targetNode: The target node found by aStarPath function.
    /// - Returns: An array representing path from target to origin.
    fileprivate static func backtrack<T>(_ targetNode: Node<T>) -> [T] {
        var result: [T] = []
        var node = targetNode
        
        while let parent = node.parent {
            result.append(node.coordinates)
            node = parent
        }
        result.append(node.coordinates) // add origin node as well
        
        return result.reversed()
    }
    
    /// A* pathfinding algorithm. Search for the shortest available path.
    ///     - from: start coordinates
    ///     - to: target coordinates
    ///     - on: HexGrid on which is pathfinding performed
    /// - Returns: Path (Sorted Array) of consequent coordinates from start to target coordinates or `nil` in case a path doesn't exist.
    static func aStarPath(
        from: CubeCoordinates,
        to: CubeCoordinates,
        on grid: HexGrid) throws -> [CubeCoordinates]? {
        let origin = Node(coordinates: from, parent: nil, costScore: 0, heuristicScore: 0)
        
        // Store potential candidates for next step in prority queue.
        // Priority is based on movement cost + heuristic function.
        var frontier = PriorityQueue<Node<CubeCoordinates>>(sort: < )
        frontier.enqueue(origin)
        
        // Store already explored coordinates together with "cost so far".
        var exploredNodes = Dictionary<CubeCoordinates, Double>()
        exploredNodes[origin.coordinates] = 0
        
        while let currentNode = frontier.dequeue() {
            
            // We are done, return the path
            if currentNode.coordinates == to {
                return backtrack(currentNode)
            }
            
            // Get all non blocked neighbors for current Node
            for nextCoords in try grid.neighborsCoordinates(for: currentNode.coordinates)
                .subtracting(grid.blockedCellsCoordinates()) {
                    let newCost = (exploredNodes[currentNode.coordinates] ?? 0)
                        + (grid.cellAt(nextCoords)?.cost ?? 0) + 10
                    let nextNode = Node(
                        coordinates: nextCoords,
                        parent: currentNode,
                        costScore: newCost,
                        // Manhattan distance seems to have a good performance/accuracy balance
                        heuristicScore: Double(try distance(from: nextCoords, to: to))
                    )
                    // If a neighbor has not been visited or we found a better path,
                    // enqueue it in priority queue and store or update record in exploredNodes.
                    if let exploredNextNodeCost = exploredNodes[nextCoords], newCost > exploredNextNodeCost {
                        continue
                    } else {
                        exploredNodes[nextCoords] = nextNode.costScore
                        frontier.enqueue(nextNode)
                    }
            }
        }
        // There is no valid path
        return nil
    }
}
