import XCTest
@testable import HexGrid

class CoordinatesTests: XCTestCase {
    // Initializer tests
    /// create valid cube coordinates
    func testCreateValidCubeCoordinates() throws {
        let cubeCoordinates = try CubeCoordinates(x: 1, y: -1, z: 0)
        XCTAssertEqual(cubeCoordinates.x, 1)
        XCTAssertEqual(cubeCoordinates.y, -1)
        XCTAssertEqual(cubeCoordinates.z, 0)
    }
    
    /// create invalid cube coordinates (sum of x, y and z is not equal to 0)
    func testCreateInalidCubeCoordinates() throws {
        XCTAssertThrowsError(try CubeCoordinates(x: -1, y: 0, z: 0))
        XCTAssertThrowsError(try CubeCoordinates(x: 0, y: -1, z: 0))
        XCTAssertThrowsError(try CubeCoordinates(x: 0, y: 0, z: -1))
    }
    
    /// create valid fractional cube coordinates
    func testCreateValidFractionalCubeCoordinates() throws {
        let coordinates = try CubeFractionalCoordinates(x: 1.0, y: -1.0, z: 0.0)
        XCTAssertEqual(coordinates.x, 1.0)
        XCTAssertEqual(coordinates.y, -1.0)
        XCTAssertEqual(coordinates.z, 0.0)
    }
    
    /// create invalid fractional cube coordinates (sum of x, y and z is not equal to 0)
    func testCreateInalidFractionalCubeCoordinates() throws {
        XCTAssertThrowsError(try CubeFractionalCoordinates(x: -1.0, y: 0.0, z: 0.0))
        XCTAssertThrowsError(try CubeFractionalCoordinates(x: 0.0, y: -1.0, z: 0.0))
        XCTAssertThrowsError(try CubeFractionalCoordinates(x: 0.0, y: 0.0, z: -1.0))
    }
    
    /// create axial coordinates
    func testCreateAxialCoordinates() throws {
        let axialCoordinates = AxialCoordinates(q: 1, r: -1)
        XCTAssertEqual(axialCoordinates.q, 1)
        XCTAssertEqual(axialCoordinates.r, -1)
    }
    
    /// Create offset coordinates (odd row + pointy top)
    func testCreateOddRowOffsetCoordinates() throws {
        // ODD_ROW
        let oddRowOffsetCoordinates = OffsetCoordinates(column: 0, row: 0, orientation: Orientation.pointyOnTop, offsetLayout: OffsetLayout.odd)
        XCTAssertEqual(oddRowOffsetCoordinates.column, 0)
        XCTAssertEqual(oddRowOffsetCoordinates.row, 0)
        XCTAssertEqual(oddRowOffsetCoordinates.orientation, Orientation.pointyOnTop)
        XCTAssertEqual(oddRowOffsetCoordinates.offsetLayout, OffsetLayout.odd)
    }
    
    /// Create offset coordinates (even row + pointy top)
    func testCreateEvenRowOffsetCoordinates() throws {
        // EVEN_ROW
        let evenRowOffsetCoordinates = OffsetCoordinates(column: 0, row: 0, orientation: Orientation.pointyOnTop, offsetLayout: OffsetLayout.even)
        XCTAssertEqual(evenRowOffsetCoordinates.column, 0)
        XCTAssertEqual(evenRowOffsetCoordinates.row, 0)
        XCTAssertEqual(evenRowOffsetCoordinates.orientation, Orientation.pointyOnTop)
        XCTAssertEqual(evenRowOffsetCoordinates.offsetLayout, OffsetLayout.even)
    }
    
    /// Create offset coordinates (odd column + flat top)
    func testCreateOddColumnOffsetCoordinates() throws {
        // ODD_COLUMN
        let oddColumnOffsetCoordinates = OffsetCoordinates(column: 0, row: 0, orientation: Orientation.flatOnTop, offsetLayout: OffsetLayout.odd)
        XCTAssertEqual(oddColumnOffsetCoordinates.column, 0)
        XCTAssertEqual(oddColumnOffsetCoordinates.row, 0)
        XCTAssertEqual(oddColumnOffsetCoordinates.orientation, Orientation.flatOnTop)
        XCTAssertEqual(oddColumnOffsetCoordinates.offsetLayout, OffsetLayout.odd)
    }
    
    /// Create offset coordinates (even column + flat top)
    func testCreateEvenColumnOffsetCoordinates() throws {
        // EVEN_COLUMN
        let evenColOffsetCoordinates = OffsetCoordinates(column: 0, row: 0, orientation: Orientation.flatOnTop, offsetLayout: OffsetLayout.even)
        XCTAssertEqual(evenColOffsetCoordinates.column, 0)
        XCTAssertEqual(evenColOffsetCoordinates.row, 0)
        XCTAssertEqual(evenColOffsetCoordinates.orientation, Orientation.flatOnTop)
        XCTAssertEqual(evenColOffsetCoordinates.offsetLayout, OffsetLayout.even)
    }
    
    /// Test offset coordinates equatablity
    func testOffsetCoordinatesEquatability() throws {
        let offsetCoordinatesA = OffsetCoordinates(column: 2, row: 4, orientation: Orientation.pointyOnTop, offsetLayout: OffsetLayout.odd)
        let offsetCoordinatesB = OffsetCoordinates(column: 2, row: 4, orientation: Orientation.pointyOnTop, offsetLayout: OffsetLayout.odd)
        XCTAssertEqual(offsetCoordinatesA, offsetCoordinatesB)
    }
    
    // conversions
    /// convert CubeToAxial
    func testCubeToAxial() throws {
        let cubeCoordinates = try CubeCoordinates(x: 1, y: 0, z: -1)
        let axialCoordinates = cubeCoordinates.toAxial()
        XCTAssertEqual(axialCoordinates.q, 1)
        XCTAssertEqual(axialCoordinates.r, -1)
    }
    
    /// convert CubeToPixel
    func testCubeToPixel() throws {
        let rootCubeCoordinates = try CubeCoordinates(x: 0, y: 0, z: 0)
        var pixelCoordinates = rootCubeCoordinates.toPixel(
            orientation: Orientation.pointyOnTop,
            hexSize: HexSize(width: 10.0, height: 10.0),
            origin: Point(x: 0.0, y: 0.0))
        XCTAssertEqual(pixelCoordinates.x, 0.0)
        XCTAssertEqual(pixelCoordinates.y, 0.0)
        
        let cubeCoordinates = try CubeCoordinates(x: 2, y: -1, z: -1)
        pixelCoordinates = cubeCoordinates.toPixel(
            orientation: Orientation.pointyOnTop,
            hexSize: HexSize(width: 10.0, height: 10.0),
            origin: Point(x: 0.0, y: 0.0))
        XCTAssertEqual(pixelCoordinates.x, 25.98076211353316)
        XCTAssertEqual(pixelCoordinates.y, -15.0)
    }
    
    /// Convert coordinates from cube to offset using `pointy on top` orientation and `odd` offset layout
    func testConvertCubeToOffsetOddRow () throws {
        let cubeCoordinates = try CubeCoordinates(x: 2, y: 0, z: -2)
        let offsetCoordinates = cubeCoordinates.toOffset(orientation: Orientation.pointyOnTop, offsetLayout: OffsetLayout.odd)
        XCTAssertEqual(offsetCoordinates.column, 1)
        XCTAssertEqual(offsetCoordinates.row, -2)
        XCTAssertEqual(offsetCoordinates.orientation, Orientation.pointyOnTop)
        XCTAssertEqual(offsetCoordinates.offsetLayout, OffsetLayout.odd)
    }
    
    /// convert Axial coordinates to Cube
    func testAxialToCube() throws {
        let axialCoordinates = AxialCoordinates(q: 1, r: -1)
        let cubeCoordinates = try axialCoordinates.toCube()
        XCTAssertEqual(cubeCoordinates.x, 1)
        XCTAssertEqual(cubeCoordinates.y, 0)
        XCTAssertEqual(cubeCoordinates.z, -1)
    }
    
    /// Test equatability of Axial coordinates
    func testAxialEquatable() throws {
        let axialCoordinates = AxialCoordinates(q: 1, r: -1)
        let validCoordinates = AxialCoordinates(q: 1, r: -1)
        let invalidCoordinates = AxialCoordinates(q: 2, r: 0)
        XCTAssertTrue(axialCoordinates == validCoordinates)
        XCTAssertFalse(axialCoordinates == invalidCoordinates)
    }
    
    static var allTests = [
        ("Create valid cube coordinates", testCreateValidCubeCoordinates),
        ("Create inalid cube coordinates", testCreateInalidCubeCoordinates),
        ("Create axial coordinates", testCreateAxialCoordinates),
        ("Create offset coordinates (odd row + pointy top)", testCreateOddRowOffsetCoordinates),
        ("Create offset coordinates (even row + pointy top)", testCreateEvenRowOffsetCoordinates),
        ("Create offset coordinates (odd column + flat top)", testCreateOddColumnOffsetCoordinates),
        ("Create offset coordinates (even column + flat top)", testCreateEvenColumnOffsetCoordinates),
        ("Test offset coordinates equatablity", testOffsetCoordinatesEquatability),
        ("Convert cube coordinates to axial", testCubeToAxial),
        ("Convert cube coordinates to pixel", testCubeToPixel),
        ("Convert cube coordinates to offset", testConvertCubeToOffsetOddRow),
        ("Convert axial coordinates to cube", testAxialToCube),
        ("Test equatability of Axial coordinates", testAxialEquatable),
        ]
}

