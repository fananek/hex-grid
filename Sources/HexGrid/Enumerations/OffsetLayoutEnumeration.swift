/// Enumeration for hexagonal grid offset layout
/**
 There are four offset types depending on orientation of hexagons.
 The “row” types are used with with pointy top hexagons and the “column” types are used with flat top.

 See `OrientationEnumeration`
 
 - Pointy on top orientation
   - odd-row (slide alternate rows right)
   - even-row (slide alternate rows left)
 - Flat on top orientation
   - odd-column (slide alternate columns up)
   - even-column (slide alternate columns down)
*/
public enum OffsetLayout: Int, Codable {
    case even = 1
    case odd = -1
}
