import XCTest
@testable import HexGrid

class ConvertorTests: XCTestCase {
    
    // Coordinates conversion tests
    /// Convert coordinates from cube to axial
    func testConvertCubeToAxial () throws {
        let cubeCoordinates = try CubeCoordinates(x: 1, y: 0, z: -1)
        let axialCoordinates = Convertor.cubeToAxial(from: cubeCoordinates)
        XCTAssertEqual(axialCoordinates.q, 1)
        XCTAssertEqual(axialCoordinates.r, -1)
    }
    
    /// Convert coordinates from cube to offset using `pointy on top` orientation and `odd` offset layout
    func testConvertCubeToOffsetOddRow () throws {
        let cubeCoordinates = try CubeCoordinates(x: 2, y: 0, z: -2)
        let offsetCoordinates = Convertor.cubeToOffset(from: cubeCoordinates, orientation: Orientation.pointyOnTop, offsetLayout: OffsetLayout.odd)
        XCTAssertEqual(offsetCoordinates.column, 1)
        XCTAssertEqual(offsetCoordinates.row, -2)
        XCTAssertEqual(offsetCoordinates.orientation, Orientation.pointyOnTop)
        XCTAssertEqual(offsetCoordinates.offsetLayout, OffsetLayout.odd)
    }
    
    /// Convert coordinates from cube to offset using `pointy on top` orientation,  `odd` offset layout and `alternate` row
    func testConvertCubeToOffsetOddRowAlt () throws {
        // test conversion for alterante row
        let cubeCoordinatesAlt = try CubeCoordinates(x: 2, y: -1, z: -1)
        let offsetCoordinatesAlt = Convertor.cubeToOffset(from: cubeCoordinatesAlt, orientation: Orientation.pointyOnTop, offsetLayout: OffsetLayout.odd)
        XCTAssertEqual(offsetCoordinatesAlt.column, 1)
        XCTAssertEqual(offsetCoordinatesAlt.row, -1)
        XCTAssertEqual(offsetCoordinatesAlt.orientation, Orientation.pointyOnTop)
        XCTAssertEqual(offsetCoordinatesAlt.offsetLayout, OffsetLayout.odd)
    }
    
    /// Convert coordinates from cube to offset using `pointy on top` orientation and `even` offset layout
    func testConvertCubeToOffsetEvenRow () throws {
        // test conversion for opposite row
        let cubeCoordinates = try CubeCoordinates(x: 2, y: 0, z: -2)
        let offsetCoordinates = Convertor.cubeToOffset(from: cubeCoordinates, orientation: Orientation.pointyOnTop, offsetLayout: OffsetLayout.even)
        XCTAssertEqual(offsetCoordinates.column, 1)
        XCTAssertEqual(offsetCoordinates.row, -2)
        XCTAssertEqual(offsetCoordinates.orientation, Orientation.pointyOnTop)
        XCTAssertEqual(offsetCoordinates.offsetLayout, OffsetLayout.even)
    }
    
    /// Convert coordinates from cube to offset using `pointy on top` orientation,  `even` offset layout and `alternate` row
    func testConvertCubeToOffsetEvenRowAlt () throws {
        // test conversion for alterante row
        let cubeCoordinatesAlt = try CubeCoordinates(x: 2, y: -1, z: -1)
        let offsetCoordinatesAlt = Convertor.cubeToOffset(from: cubeCoordinatesAlt, orientation: Orientation.pointyOnTop, offsetLayout: OffsetLayout.even)
        XCTAssertEqual(offsetCoordinatesAlt.column, 2)
        XCTAssertEqual(offsetCoordinatesAlt.row, -1)
        XCTAssertEqual(offsetCoordinatesAlt.orientation, Orientation.pointyOnTop)
        XCTAssertEqual(offsetCoordinatesAlt.offsetLayout, OffsetLayout.even)
    }
    
    /// Convert coordinates from cube to offset using `flat on top` orientation and `odd` offset layout
    func testConvertCubeToOffsetOddColumn () throws {
        // test conversion for opposite row
        let cubeCoordinates = try CubeCoordinates(x: 2, y: 0, z: -2)
        let offsetCoordinates = Convertor.cubeToOffset(from: cubeCoordinates, orientation: Orientation.flatOnTop, offsetLayout: OffsetLayout.odd)
        XCTAssertEqual(offsetCoordinates.column, 2)
        XCTAssertEqual(offsetCoordinates.row, -1)
        XCTAssertEqual(offsetCoordinates.orientation, Orientation.flatOnTop)
        XCTAssertEqual(offsetCoordinates.offsetLayout, OffsetLayout.odd)
    }
    
    /// Convert coordinates from cube to offset using `flat on top` orientation,  `odd` offset layout and `alternate` column
    func testConvertCubeToOffsetOddColumnAlt () throws {
        // test conversion for alterante column
        let cubeCoordinatesAlt = try CubeCoordinates(x: 1, y: 0, z: -1)
        let offsetCoordinatesAlt = Convertor.cubeToOffset(from: cubeCoordinatesAlt, orientation: Orientation.flatOnTop, offsetLayout: OffsetLayout.odd)
        XCTAssertEqual(offsetCoordinatesAlt.column, 1)
        XCTAssertEqual(offsetCoordinatesAlt.row, -1)
        XCTAssertEqual(offsetCoordinatesAlt.orientation, Orientation.flatOnTop)
        XCTAssertEqual(offsetCoordinatesAlt.offsetLayout, OffsetLayout.odd)
    }
    
    /// Convert coordinates from cube to offset using `flat on top` orientation and `even` offset layout
    func testConvertCubeToOffsetEvenColumn () throws {
        // test conversion for opposite row
        let cubeCoordinates = try CubeCoordinates(x: 2, y: 0, z: -2)
        let offsetCoordinates = Convertor.cubeToOffset(from: cubeCoordinates, orientation: Orientation.flatOnTop, offsetLayout: OffsetLayout.even)
        XCTAssertEqual(offsetCoordinates.column, 2)
        XCTAssertEqual(offsetCoordinates.row, -1)
        XCTAssertEqual(offsetCoordinates.orientation, Orientation.flatOnTop)
        XCTAssertEqual(offsetCoordinates.offsetLayout, OffsetLayout.even)
    }
    
    /// Convert coordinates from cube to offset using `flat on top` orientation,  `even` offset layout and `alternate` column
    func testConvertCubeToOffsetEvenColumnAlt () throws {
        // test conversion for alterante column
        let cubeCoordinatesAlt = try CubeCoordinates(x: 1, y: 0, z: -1)
        let offsetCoordinatesAlt = Convertor.cubeToOffset(from: cubeCoordinatesAlt, orientation: Orientation.flatOnTop, offsetLayout: OffsetLayout.even)
        XCTAssertEqual(offsetCoordinatesAlt.column, 1)
        XCTAssertEqual(offsetCoordinatesAlt.row, 0)
        XCTAssertEqual(offsetCoordinatesAlt.orientation, Orientation.flatOnTop)
        XCTAssertEqual(offsetCoordinatesAlt.offsetLayout, OffsetLayout.even)
    }
    
    // Convert coordinates from offset to cube
    func testConvertOffsetToCube() throws {
        let offsetCoordinatesPointy = OffsetCoordinates(column: 2, row: 4, orientation: Orientation.pointyOnTop, offsetLayout: OffsetLayout.odd)
        var cubeCoordinates = try offsetCoordinatesPointy.toCube()
        XCTAssertEqual(cubeCoordinates.x, 0)
        XCTAssertEqual(cubeCoordinates.y, -4)
        XCTAssertEqual(cubeCoordinates.z, 4)
        
        let offsetCoordinatesFlat = OffsetCoordinates(column: 2, row: 4, orientation: Orientation.flatOnTop, offsetLayout: OffsetLayout.odd)
        cubeCoordinates = try offsetCoordinatesFlat.toCube()
        XCTAssertEqual(cubeCoordinates.x, 2)
        XCTAssertEqual(cubeCoordinates.y, -5)
        XCTAssertEqual(cubeCoordinates.z, 3)
    }
    
    // Convert coordinates from pixel to cube
    func testConvertPixelToCube() throws {
        let point1 = Convertor.pixelToCube(
            from: Point(x: 3.2, y: 4.5),
            hexSize: HexSize(width: 10.0, height: 10.0),
            origin: Point(x: 0.0, y: 0.0),
            orientation: Orientation.pointyOnTop)
        let point2 = Convertor.pixelToCube(
            from: Point(x: 22.2, y: 4.5),
            hexSize: HexSize(width: 10.0, height: 10.0),
            origin: Point(x: 0.0, y: 0.0),
            orientation: Orientation.pointyOnTop)
        let point3 = Convertor.pixelToCube(
            from: Point(x: 0.0, y: -22.5),
            hexSize: HexSize(width: 10.0, height: 10.0),
            origin: Point(x: 0.0, y: 0.0),
            orientation: Orientation.pointyOnTop)
        
        let expectedCube1 = try CubeCoordinates(x: 0, y: 0, z: 0)
        let expectedCube2 = try CubeCoordinates(x: 1, y: -1, z: 0)
        let expectedCube3 = try CubeCoordinates(x: 1, y: 1, z: -2)
        
        XCTAssertEqual(expectedCube1, point1)
        XCTAssertEqual(expectedCube2, point2)
        XCTAssertEqual(expectedCube3, point3)
    }
    
    
    
    static var allTests = [
        ("Convert coordinates from cube to axial", testConvertCubeToAxial),
        ("Convert coordinates from cube to offset (odd row + pointy top)", testConvertCubeToOffsetOddRow),
        ("Convert coordinates from cube to offset (odd row + pointy top + alternate row)", testConvertCubeToOffsetOddRowAlt),
        ("Convert coordinates from cube to offset (even row + pointy top)", testConvertCubeToOffsetEvenRow),
        ("Convert coordinates from cube to offset (even row + pointy top + alternate row)", testConvertCubeToOffsetEvenRowAlt),
        ("Convert coordinates from cube to offset (odd column + flat top)", testConvertCubeToOffsetOddColumn),
        ("Convert coordinates from cube to offset (odd column + flat top + alternate column)", testConvertCubeToOffsetOddColumnAlt),
        ("Convert coordinates from cube to offset (even column + flat top)", testConvertCubeToOffsetEvenColumn),
        ("Convert coordinates from cube to offset (even column + flat top + alternate column)", testConvertCubeToOffsetEvenColumnAlt),
        ("Convert coordinates from offset to cube)", testConvertOffsetToCube),
        ("Convert coordinates from pixel to cube)", testConvertPixelToCube)
        ]
    
}
