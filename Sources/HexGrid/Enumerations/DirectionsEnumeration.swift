/// Enumeration for direction
public enum Direction {
    /// ⬣ - flat side on top of a hexagon
    case flat(Flat)
    
    /// ⬢ - pointy side on top of a hexagon
    case pointy(Pointy)

    
    /// ⬣ - flat side on top of a hexagon
    /// individual cases correspond to common cardinal directions
    /// (`east` and `west` directions are not available for **flat on top** orientation)
    public enum Flat: Int {
        case north = 5
        case northEast = 0
        case southEast = 1
        case south = 2
        case southWest = 3
        case northWest = 4
    }

    /// ⬢ - pointy side on top of a hexagon
    /// individual cases correspond to common cardinal directions
    /// (`north` and `south` directions are not available for **pointy on top** orientation)
    public enum Pointy: Int {
        case northEast = 0
        case east = 1
        case southEast = 2
        case southWest = 3
        case west = 4
        case northWest = 5
    }
}
