/// Enumeration for built-in types of hexagonal grid shapes.
///
/// Options are: `hexagon`, `rectangle`, and `triangle`.
/// Each option has stored properties relevant to that shape.
public enum GridShape {

    /// Hexagonal `GridShape`. Stored property corresponds to side-length.
    case hexagon(Int)

    /// Elongated hexagon `GridShape`. Stored properties correspond to side-lengths.
    /// Note that if the side lengths are the same, this falls back to the default hexagon shape.
    case elongatedHexagon(Int, Int)

    /// Irregular hexagon `GridShape`. Stored properties correspond to side-lengths.
    /// Note that if the side lengths are the same, this falls back to the default hexagon shape.
    case irregularHexagon(Int, Int)

    /// Rectangular `GridShape` that does not attempt to be square. Stored properties are for width and height.
    case parallelogram(Int, Int)

    /// Rectangular `GridShape` that attempts to create a more or less square shape. Stored properties are for width and height.
    case rectangle(Int, Int)

    /// Triangular `GridShape`. Stored property is side-length.
    case triangle(Int)
}
