/// Represents coordinates in Offset format using column and row.
///
/// Offset coordinates, usually used for rendering and UI purposes.
public struct OffsetCoordinates {
    public let column, row: Int
    public let orientation: Orientation
    public let offsetLayout: OffsetLayout

    /// Basic Initializer
    ///
    /// - parameters:
    ///     - column: Value of horizontal axis.
    ///     - row: Value of vertical axis.
    ///     - orientation: See `OrientationEnumeration` options
    ///     - offsetLayout: See `OffsetLayoutEnumeration` options
    public init(column: Int, row: Int, orientation: Orientation, offsetLayout: OffsetLayout) {
        self.column = column
        self.row = row
        self.orientation = orientation
        self.offsetLayout = offsetLayout
    }
}

// conversion functions
extension OffsetCoordinates {

    /// Converts coordinates to cube system
    /// - throws: `InvalidArgumentsError` in case sum of result coordinates is not equal to zero.
    public func toCube () throws -> CubeCoordinates {
        return try Convertor.offsetToCube(from: self)
    }
}

// Helpers
extension OffsetCoordinates: Equatable {
    public static func ==(lhs: OffsetCoordinates, rhs: OffsetCoordinates) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
            && lhs.orientation == rhs.orientation && lhs.offsetLayout == rhs.offsetLayout
    }
}
