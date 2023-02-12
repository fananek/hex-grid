/// Enumeration for built-in types of hexagonal grid shapes.
///
/// Options are: `hexagon`, `rectangle`, and `triangle`.
/// Each option has stored properties relevant to that shape.
public enum GridShape {

    /// Hexagonal `GridShape`. Stored property corresponds to side-length.
    case hexagon(Int)

    /// Rectangular `GridShape` that does not attempt to be square. Stored properties are for width and height.
    case parallelogram(Int, Int)

    /// Rectangular `GridShape` that attempts to create a more or less square shape. Stored properties are for width and height.
    case rectangle(Int, Int)

    /// Triangular `GridShape`. Stored property is side-length.
    case triangle(Int)
}
