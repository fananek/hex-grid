# HexGrid
<p align="center">
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-5.6-orange.svg" alt="Swift 5.6+">
    </a>
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-&#x2713-brightgreen.svg" alt="Swift Package Manager Compatible">
    </a>
    <a href="https://github.com/fananek/hex-grid/blob/main/LICENSE.md">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://fananek.github.io/hex-grid/documentation/hexgrid">
        <img src="http://img.shields.io/badge/read_the-docs-2196f3.svg" alt="Documentation">
    </a>
</p>

    Development in progress!
    
    API might change without further notice until first major release 1.x.x.

HexGrid library provides easy and intuitive way of working with hexagonal grids. Under the hood it handles all the math so you can focus on more important stuff.

- Support any gird shape, including irregular one or grid with holes.

The library is meant for generic backend use. Therefore it doesn't not offer any UI or rendering stuff. However, it provides calculations needed for grid rendering.

## Features

- [x] Create or generate a grid with hexagonal cells.  
- [x] Various coordinate systems (cube, axial, offset).  
- [x] Rotation, Manhattan distance, linear interpolation.  
- [x] Get Neighbors or diagonal neighbors.  
- [x] Get Line (get all hexes making a line from A to B).  
- [x] Get Ring (get all hexes making a ring from an origin coordinates in specified radius).  
- [x] Get Filled Ring (get all hexes making a filled ring from an origin coordinates in specified radius).  
- [x] Find reachable hexes within `n` steps (Breath First Search).  
- [x] Find the shortest path from A to B (optimized A* search algorithm).
- [x] FieldOfView algorithm (`ShadowCasting` designed for hexagonal grids).
- [x] Hexagon rendering related stuff (e.g. polygon corners).  
- [x] Code inline documentation (quick help).
- [x] Solid unit tests coverage.
- [x] Automated documentation generator (SwiftDoc + GitHub Actions -> hosted on repo GitHub Pages).
- [x] Demo with visualization.

## What's coming next?

- [ ] We are done for the moment. Any feature requests or ideas are welcome. 

## HexGrid in action

HexGrid [demo app](https://github.com/mgrider/SKHexGrid) using SpriteKit.  
HexGrid [demo app](https://github.com/fananek/HexGrid-SwiftUI-Demo) using SwiftUI.

## Getting Started

### Integrating HexGrid to your project

Add HexGrid as a dependency to your `Package.swift` file. 

```swift
import PackageDescription

let package = Package(
name: "MyApp",
dependencies: [
...
// Add HexGrid package here
.package(url: "https://github.com/fananek/hex-grid.git", from: "0.4.11")
],
...
targets: [
        .target(name: "App", dependencies: [
            .product(name: "HexGrid", package: "hex-grid"),
            ...
```

Import HexGrid package to your code.

```swift
import HexGrid
...
// your code goes here
```

## Using

### Creating a grid

Grids can be initialized either with a set of cell coordinates, or HexGrid can generate some standard shaped grids for you.

#### Standard shape grids

Example:

```swift
...
// create grid of hexagonal shape
var grid = HexGrid(shape: GridShape.hexagon(10))
// or rectangular shape
var grid = HexGrid(shape: GridShape.rectangle(8, 12))
// or triangular shape
var grid = HexGrid(shape: GridShape.triangle(6))
```

#### Custom grids

Example:

```swift
...
// create new HexGrid

let gridCells: Set<Cell> = try [
Cell(CubeCoordinates(x:  2,  y: -2,  z:  0)),
Cell(CubeCoordinates(x:  0,  y: -1,  z:  1)),
Cell(CubeCoordinates(x: -1,  y:  1,  z:  0)),
Cell(CubeCoordinates(x:  0,  y:  2,  z: -2))
]
var grid = HexGrid(cells: gridCells)
...
```

#### Initializers and drawing

Note that, assuming you want to draw your grid, you'll want to think about whether to pass a size for each cell (`hexSize`) or a size for the entire Grid (`pixelSize`) to the initializer. (See "Drawing the Grid" below.)

#### HexGrid <-> JSON

HexGrid conforms to swift `Codable` protocol so it can be easily encoded to or decoded from JSON.

Example:

```swift
// encode (grid to JSON)
let grid = HexGrid(shape: GridShape.hexagon(5) )
let encoder = JSONEncoder()
let data = try encoder.encode(grid)
```

```swift
// decode (JSON to grid)
let decoder = JSONDecoder()
let grid = try decoder.decode(HexGrid.self, from: data)
```

### Grid operations examples

Almost all functions have two variants. One that works with `Cell` and the other one works with `CubeCoordinates`. Use those which better fulfill your needs.

#### Get Cell at coordinates

```swift
let cell = grid.cellAt(try CubeCoordinates(x: 1, y: 0, z: -1))
```

#### Validate coordinates

Check whether a coordinate is valid (meaning it has a corresponding `Cell` in the grid's `cells` array).

```swift
// returns Bool
isValidCoordinates(try CubeCoordinates(x: 2, y: 4, z: -6))
```

#### Get blocked or non blocked Cells

```swift
let blockedCells = grid.blockedCells()
// or
let nonBlockedCells = grid.nonBlockedCells()
```

#### Get single neighbor

```swift
// get neighbor for a specific Cell
let neighbor = try grid.neighbor(
            for: someCell,
            at: Direction.Pointy.northEast.rawValue)

// get just neighbor coordinates
let neighborCoordinates = try grid.neighborCoordinates(
            for: someCoordinates,
            at: Direction.Pointy.northEast.rawValue)
```

#### Get all neighbors

```swift
// get all neighbors for a specific Cell
let neighbors = try grid.neighbors(for: someCell)

// get only coordinates of all neighbors
let neighborsCoords = try grid.neighbors(for: someCoordinates)
```

#### Get line from A to B

```swift
// returns nil in case line doesn't exist
let line = try grid.line(from: originCell, to: targetCell)
```

#### Get ring

```swift
// returns all cells making a ring from origin cell in radius
let ring = try grid.ring(from: originCell, in: 2)
```

#### Get filled ring

```swift
// returns all cells making a filled ring from origin cell in radius
let ring = try grid.filledRing(from: originCell, in: 2)
```

#### Find reachable cells

```swift
// find all reachable cells (max. 4 steps away from origin)
let reachableCells = try grid.findReachable(from: origin, in: 4)
```

#### Find shortest path

```swift
// returns nil in case path doesn't exist at all
let path = try grid.findPath(from: originCell, to: targetCell)
```

#### Calculate field of view (FOV)

`Cell` has an attribute called `isOpaque`. Its value can be `true` or `false`. Based on this information it's possible to calculate so called **field of view**. It means all cells visible from specific position on grid, considering all opaque obstacles.

```swift
// set cell as opaque
obstacleCell.isOpaque = true 
```

In order to get field of view, simply call following function.

```swift
// find all hexes visible in radius 4 from origin cell
let visibleHexes = try grid.fieldOfView(from: originCell, in: 4)
```

By default cell is considered visible as soon as its center is visible from the origin cell. If you want to include partially visible cells as well, use optional paramter `includePartiallyVisible`.

```swift
// find all hexes even partially visible in radius 4 from origin cell
let visibleHexesIncludingPartials = try grid.fieldOfView(from: originCell, in: 4, includePartiallyVisible: true)
```

### Drawing the Grid

Internally, `HexGrid` calculates all "pixel coordinates" using one of two methods:

1. Using a size for each `Cell` (stored in the `hexSize` property).

*...or...*

2. Using a size for the entire Grid (stored in the `pixelSize` property).

> *Note that both the `hexSize` and `pixelSize` properties are stored internally as `HexSize` structures. Try not to get confused by this! `HexSize` is just a convenient way to store `width` and `height` values.*

Which flavor of `HexGrid` initializer you want to use will depend on which of these methods best applies to your use case. When specifying the `hexSize`, the `pixelSize` is calculated for you, and when specifying the `pixelSize`, the `hexSize` is likewise set automatically.

While it is not possible to modify the `hexSize` or `pixelSize` properties directly (after initialization), you can set the grid's `pixelSize` (and re-calculate `hexSize` from it) at any time using the `fitGrid(in size: HexSize)` function. Note that this also resets the `origin` property.

#### The origin property

You can think of the `HexGrid`'s' `origin` property as the center point of the `Cell` at `CubeCoordinate` `0,0,0`.

> *Note that you can specify the `origin` at initialization, but only when using the `cellSize` method. When specifying `pixelSize`, the origin is set for you, so the grid "fits" inside the specified width & height.*

It will be important to change the `origin` property any time you want to change the pixel coordinates for your Grid. *Changing the `origin` will modify the return values of all pixel-calculating functions.* You can use this to apply an offset for your grid, or "re-center" it later.

#### Corner Pixel Coordinates

Usually, when drawing hexagons, you will want the screen coordinates of the polygon corners for each `Cell`.

```swift
let corners = grid.polygonCorners(for: someCell)
```

#### Center Pixel Coordinates

This function returns a `Point` struct (x: and y: values) for the center of a `Cell`.

```swift
let screenCoords = grid.pixelCoordinates(for: someCell)
```

#### Finding a Cell at screen coordinates

```swift
// return cell for specified screen coordinates (or nil if such cell doesn't exists)
let cell = try grid.cellAt(point)
```

## Implementation fundamentals

For detailed information see complete [documentation](https://fananek.github.io/hex-grid/)

### Data structures you should know

#### HexGrid

Represents the grid itself as well as it's an entry point of the HexGrid library.

`HexGrid` is defined by set of `Cells` and few other properties. All together makes a grid setup. In other words it put grid cells into a meaningful context. Therefore most of available operations are being called directly on a grid instance because it make sense only with such context (grid setup).

Properties:

- cells: `Set<Cell>` - grid cells
- orientation: `Orientation` - see [Orientation enumeration](#Orientation)
- offsetLayout: `OffsetLayout` - see [OffsetLayout enumeration](#OffsetLayout)
- hexSize: `HexSize` - width and height of a hexagon
- origin: `Point` - 'display coordinates' (x, y) of a grid origin
- pixelWidth: `Double` - pixel width of a grid
- pixelHeight: `Double` - pixel width of a grid
- attributes: `[String: Attribute]` - dictionary of custom attributes (most primitive types are supported as well as nesting)

#### Cell

Cell is a building block of a grid.

Properties:

- coordinates: `CubeCoordinates` - cell placement on a grid coordinate system
- attributes: `[String: Attribute]` - dictionary of custom attributes (most primitive types are supported as well as nesting)
- isBlocked: `Bool` - used by algorithms (reachableCells, pathfinding etc.)
- isOpaque: `Bool` - used by fieldOfView algorithm
- cost: `Float` - used by pathfinding algorithm. For the sake of simplicity let's put graph theory aside. You can imagine cost as an amount of energy needed to pass a cell. Pathfinding algorithm then search for path requiring the less effort.

#### CubeCoordinates

The most common coordinates used within HexGrid library is cube coordinate system. This type of coordinates has three axis x, y and z. The only condition is that sum of its all values has to be equal zero.

```swift
// valid cube coordinates
CubeCoordinates(x: 1, y: 0, z: -1) -> sum = 0

// invalid cube coordinates
CubeCoordinates(x: 1, y: 1, z: -1) -> sum = 1 -> throws error
```

For more details check [Amit Patel's explanation](https://www.redblobgames.com/grids/hexagons/#coordinates-cube).

#### Enumerations

##### Orientation

Options:

- `pointyOnTop` - ⬢
- `flatOnTop` - ⬣

##### OffsetLayout

OffsetLayout is used primarily for rectangular shaped grids. It has two options but their meaning can differ based on grid orientation.

Options:

- `odd`
- `even`

There are four offset types depending on orientation of hexagons. The “row” types are used with with pointy top hexagons and the “column” types are used with flat top.

- Pointy on top orientation
  - odd-row (slide alternate rows right)
  - even-row (slide alternate rows left)
- Flat on top orientation
  - odd-column (slide alternate columns up)
  - even-column (slide alternate columns down)

##### GridShape

Cases from this enumeration can be passed into the `HexGrid` constructor to generate grids of various shapes and sizes.

Options:

- `rectangle(Int, Int)` - Associated values are column width and row height of the generated grid. Sides of the grid will be essentially parallel to the edges of the screen.
- `parallelogram(Int, Int)` - Associated values are both side-lengths.
- `hexagon(Int)` - This generates a regular hexagon shaped grid, with all sides the length of the associated value.
- `irregularHexagon(Int, Int)` - This is used to generate a grid shaped like a hexagon where every other side is the length of the associated values.
- `triangle(Int)` - Generates an equilateral triangle with all sides the length of the associated value.

##### Rotation

Options:

- `left`
- `right`

##### Direction

Direction enumeration is consistent and human recognizable direction naming. Using direction enumeration is not only much more convenient but it also help to avoid errors. It's better to say just *"Hey, I'm on cell X and want to go north."* than think *"What the hack was that index of north direction?"*, isn't it?

Options:

- `Direction.Flat`
  - `north`
  - `northEast`
  - `southEast`
  - `south`
  - `southWest`
  - `northWest`
- `Direction.Pointy`
  - `northEast`
  - `east`
  - `southEast`
  - `southWest`
  - `west`
  - `northWest`

There is actually separate set of directions for each grid orientation. It's because of two reasons. First, some directions are valid only for one or another orientation. Second, direction raw values are shifted based on orientation.

## Authors

- [@fananek](https://github.com/fananek)
- [@mlhovka](https://github.com/mlhovka)

See also the list of [contributors](https://github.com/fananek/HexGrid/contributors) who participated in this project.

## License

All code contained in the HexGrid package is under the [MIT](https://github.com/fananek/HexGrid/blob/master/LICENSE.md) license agreement.
