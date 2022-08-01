/// Enumeration for hexagon orientation
/// Options are either `pointyOnTop` or `flatOnTop`.
public enum Orientation: String, Codable {
    /// ⬢ - pointy side on top of a hexagon
    case pointyOnTop
    /// ⬣ - flat side on top of a hexagon
    case flatOnTop
}
