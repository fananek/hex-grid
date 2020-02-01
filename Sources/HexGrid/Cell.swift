/// Represents single position in a grid
public class Cell: Codable {
    public var coordinates: CubeCoordinates
    public var isBlocked: Bool
    public var cost: Double
    
    /// Basic Initializer
    ///
    /// - parameters:
    ///     - coordinates: Cube coordinates of a cell
    ///     - isBlocked: Bool value specipyfing whether cell is blocked or not
    ///     - cost: Cost of passing the cell (used in pathfinding).
    public init(_ coordinates: CubeCoordinates, isBlocked: Bool = false, cost: Double = 0) {
        self.coordinates = coordinates
        self.isBlocked = isBlocked
        self.cost = cost
    }
    
    /// Rotate cell coordinates
    ///
    /// - parameters:
    ///     - side: Rotation enumeration (left or right)
    /// - throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    public func rotate(_ side: Rotation) throws {
        switch side {
        case Rotation.left:
            self.coordinates = try Math.rotateLeft(coordinates: self.coordinates)
        case Rotation.right:
            self.coordinates = try Math.rotateRight(coordinates: self.coordinates)
        }
    }

    /// Manhatan distance to coordinates
    ///
    /// - parameters:
    ///   - coordinates: Target coordinates
    /// - returns: Distance from current cell to target coordinates
    /// - throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    public func distance(to coordinates: CubeCoordinates) throws -> Int {
        return try Math.distance(from: self.coordinates, to: coordinates)
    }

    /// Manhatan distance to cell
    ///
    /// - parameters:
    ///   - cell: Target cell
    /// - returns: Distance from current cell to target cell
    /// - throws: `InvalidArgumentsError` in case underlying cube coordinates initializer propagate the error.
    public func distance(to cell: Cell) throws -> Int {
        return try Math.distance(from: self.coordinates, to: cell.coordinates)
    }    
}

extension Cell: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(coordinates)
        hasher.combine(cost)
    }
}

extension Cell: Equatable {
    public static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.coordinates == rhs.coordinates
    }
}
