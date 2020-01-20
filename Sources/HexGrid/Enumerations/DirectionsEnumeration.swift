/// Enumeration for direction
public enum Direction {
    case flat(Flat)
    case pointy(Pointy)

    public enum Flat: Int {
        case north = 5
        case northEast = 0
        case southEast = 1
        case south = 2
        case southWest = 3
        case northWest = 4
    }

    public enum Pointy: Int {
        case northEast = 0
        case east = 1
        case southEast = 2
        case southWest = 3
        case west = 4
        case northWest = 5
    }
}
