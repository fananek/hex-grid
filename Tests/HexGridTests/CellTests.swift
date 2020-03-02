import XCTest
@testable import HexGrid

class CellTests: XCTestCase {
    
    /// create valid cell
    func testCreateCell() throws {
        let cell = try Cell(CubeCoordinates(x: 1, y: -1, z: 0))
        XCTAssertEqual(cell.coordinates.x, 1)
        XCTAssertEqual(cell.coordinates.y, -1)
        XCTAssertEqual(cell.coordinates.z, 0)
    }
    
    /// Rotate cell left
    func testRotateLeft() throws {
        let cell = try Cell(CubeCoordinates(x: 1, y: -1, z: 0))
        try cell.rotate(Rotation.left)
        XCTAssertEqual(cell.coordinates.x, 1)
        XCTAssertEqual(cell.coordinates.y, 0)
        XCTAssertEqual(cell.coordinates.z, -1)
    }
    
    /// Rotate cell right
    func testRotateRight() throws {
        let cell = try Cell(CubeCoordinates(x: 1, y: -1, z: 0))
        try cell.rotate(Rotation.right)
        XCTAssertEqual(cell.coordinates.x, 0)
        XCTAssertEqual(cell.coordinates.y, -1)
        XCTAssertEqual(cell.coordinates.z, 1)
    }
    
    func testDistanceForCoordinates() throws {
        let origin = try Cell(CubeCoordinates(x: 0, y: 0, z: 0))
        let target = try CubeCoordinates(x: 2, y: 0, z: -2)
        XCTAssertEqual(try origin.distance(to: target), 2)
    }
    
    func testDistanceForCell() throws {
        let origin = try Cell(CubeCoordinates(x: 0, y: 0, z: 0))
        let target = try Cell(CubeCoordinates(x: 2, y: 0, z: -2))
        XCTAssertEqual(try origin.distance(to: target), 2)
    }
    
    func testCellAttributes() throws {
        let cell = try Cell(CubeCoordinates(x: 0, y: 0, z: 0))
        cell.attributes["isVisible"] = true
        cell.attributes["customValue"] = 20
        cell.attributes["title"] = "Cell Title"
        
        XCTAssertEqual(cell.attributes["isVisible"], true)
        XCTAssertEqual(cell.attributes["customValue"], 20)
        XCTAssertEqual(cell.attributes["title"], "Cell Title")
        
        // assign new title
        cell.attributes["title"] = "New Title"
        XCTAssertEqual(cell.attributes["title"], "New Title")
    }
    
    static var allTests = [
        ("Test Create cell", testCreateCell),
        ("Test Rotate cell left", testRotateLeft),
        ("Test Rotate cell right", testRotateRight),
        ("Test Distance for coordinates", testDistanceForCoordinates),
        ("Test Distance for  cell", testDistanceForCell),
        ("Test cell attributes", testCellAttributes)
    ]
}

