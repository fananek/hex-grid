import XCTest
@testable import HexGrid

class GridGeneratorTests: XCTestCase {
    
    /// Create rectangular grids in all variations
    func testCreateRectangleGrid () throws {
        var orientation = Orientation.pointyOnTop
        var offsetLayout = OffsetLayout.even
        let hexSize = HexSize(width: 10.0, height: 10.0)
        let origin = Point(x: 0.0, y: 0.0)
        var shape = GridShape.rectangle(2, 1)
        
        let gridPointyEven = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(gridPointyEven.cells.count, 2)
        
        shape = GridShape.rectangle(2, 2)
        offsetLayout = OffsetLayout.odd
        let gridPointyOdd = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(gridPointyOdd.cells.count, 4)

        shape = GridShape.rectangle(3, 4)
        orientation = Orientation.flatOnTop
        offsetLayout = OffsetLayout.even
        let gridFlatEven = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(gridFlatEven.cells.count, 12)
        
        shape = GridShape.rectangle(4, 5)
        offsetLayout = OffsetLayout.odd
        let gridFlatOdd = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout)
        XCTAssertEqual(gridFlatOdd.cells.count, 20)
    }
    
    /// Create hexagonal grid
    func testCreateHexagonGrid () throws {
        var orientation = Orientation.pointyOnTop
        var offsetLayout = OffsetLayout.even
        let hexSize = HexSize(width: 10.0, height: 10.0)
        let origin = Point(x: 0.0, y: 0.0)
        var shape = GridShape.hexagon(2)
        
        let gridPointy = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(gridPointy.cells.count, 7)
        
        orientation = Orientation.flatOnTop
        offsetLayout = OffsetLayout.odd
        shape = GridShape.hexagon(3)
        let gridFlat = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(gridFlat.cells.count, 19)
    }
    
    /// Create triangular grids in all variations
    func testCreateTriangleGrid () throws {
        var orientation = Orientation.pointyOnTop
        var offsetLayout = OffsetLayout.even
        let hexSize = HexSize(width: 10.0, height: 10.0)
        let origin = Point(x: 0.0, y: 0.0)
        var shape = GridShape.triangle(4)
        
        let gridPointy = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(gridPointy.cells.count, 10)

        shape = GridShape.triangle(5)
        orientation = Orientation.flatOnTop
        offsetLayout = OffsetLayout.even
        let gridFlat = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(gridFlat.cells.count, 15)
    }
    
    /// Create invalid shape  grid
    func testCreateInvalidShapeGrid () throws {
        let orientation = Orientation.pointyOnTop
        let offsetLayout = OffsetLayout.even
        let hexSize = HexSize(width: 10.0, height: 10.0)
        let origin = Point(x: 0.0, y: 0.0)
        
        // test for invalid rectangle
        var shape = GridShape.rectangle(10, -5)
        var result = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(result.cells.count, 0)
        
        // test for invalid hexagon
        shape = GridShape.hexagon(-3)
        result = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(result.cells.count, 0)
        
        // test for invalid triangle
        shape = GridShape.triangle(-3)
        result = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(result.cells.count, 0)

        // test for invalid parallelogram
        shape = GridShape.parallelogram(-3, 5)
        result = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(result.cells.count, 0)

        // test for invalid irregular hexagon
        shape = GridShape.irregularHexagon(-3, 5)
        result = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(result.cells.count, 0)
    }

    /// Create parallelogram grids
    func testCreateParallelogramGrids () throws {
        var orientation = Orientation.pointyOnTop
        var offsetLayout = OffsetLayout.even
        let hexSize = HexSize(width: 10.0, height: 10.0)
        let origin = Point(x: 0.0, y: 0.0)

        var shape = GridShape.parallelogram(3, 4)
        let gridPointy = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(gridPointy.cells.count, 12)

        shape = GridShape.parallelogram(10, 20)
        orientation = Orientation.flatOnTop
        offsetLayout = OffsetLayout.even
        let gridFlat = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(gridFlat.cells.count, 200)
    }

    /// Create extended hexagon grids
    func testCreateElongatedHexagonGrids () throws {

        var shape = GridShape.elongatedHexagon(3, 4)
        var grid = HexGrid(
            shape: shape,
            orientation: .pointyOnTop)
        XCTAssertEqual(grid.cells.count, 30)

        // flat
        grid = HexGrid(
            shape: shape,
            orientation: .flatOnTop)
        XCTAssertEqual(grid.cells.count, 24)

        shape = GridShape.elongatedHexagon(2, 3)
        grid = HexGrid(
            shape: shape,
            orientation: .pointyOnTop)
        XCTAssertEqual(grid.cells.count, 14)

        grid = HexGrid(
            shape: shape,
            orientation: .flatOnTop)
        XCTAssertEqual(grid.cells.count, 10)

        shape = GridShape.elongatedHexagon(7, 3)
        grid = HexGrid(
            shape: shape,
            orientation: .pointyOnTop)
        XCTAssertEqual(grid.cells.count, 39)

        shape = GridShape.elongatedHexagon(3, 7)
        grid = HexGrid(
            shape: shape,
            orientation: .flatOnTop)
        XCTAssertEqual(grid.cells.count, 39)
    }

    /// Create irregular hexagon grids
    func testCreateIrregularHexagonGrids () throws {
        var orientation = Orientation.pointyOnTop
        var offsetLayout = OffsetLayout.even
        let hexSize = HexSize(width: 10.0, height: 10.0)
        let origin = Point(x: 0.0, y: 0.0)

        var shape = GridShape.irregularHexagon(3, 4)
        let gridPointy = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(gridPointy.cells.count, 27)

        shape = GridShape.irregularHexagon(2, 3)
        orientation = Orientation.flatOnTop
        offsetLayout = OffsetLayout.even
        let gridFlat = HexGrid(
            shape: shape,
            orientation: orientation,
            offsetLayout: offsetLayout,
            hexSize: hexSize,
            origin: origin)
        XCTAssertEqual(gridFlat.cells.count, 12)
    }

    static var allTests = [
        ("Create rectangular grids", testCreateRectangleGrid),
        ("Create hexagonal grid", testCreateHexagonGrid),
        ("Create triangular grid", testCreateTriangleGrid),
        ("Create invalid shape grid", testCreateInvalidShapeGrid),
        ("Create parallelogram shape grid", testCreateParallelogramGrids),
        ("Create elongated hexagon shape grid", testCreateElongatedHexagonGrids),
        ("Create irregular hexagon shape grid", testCreateIrregularHexagonGrids),
    ]

}
