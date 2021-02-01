import XCTest
@testable import HexGrid

class MathTests: XCTestCase {
    
    // Coordinates Math test
    /// Test add operation
    func testAddOperation() throws {
        let aCoord = try CubeCoordinates(x: 1, y: 1, z: -2)
        let bCoord = try CubeCoordinates(x: 2, y: 0, z: -2)
        let result = try Math.add(a: aCoord, b: bCoord)
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 1)
        XCTAssertEqual(result.z, -4)
    }
    
    /// Test subtract operation
    func testSubtractOperation() throws {
        let aCoord = try CubeCoordinates(x: 1, y: 1, z: -2)
        let bCoord = try CubeCoordinates(x: 2, y: 0, z: -2)
        let result = try Math.subtract(a: aCoord, b: bCoord)
        XCTAssertEqual(result.x, -1)
        XCTAssertEqual(result.y, 1)
        XCTAssertEqual(result.z, 0)
    }
    
    /// Test scale operation
    func testScaleOperation() throws {
        let coord = try CubeCoordinates(x: 1, y: 0, z: -1)
        let result = try Math.scale(a: coord, c: 3)
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 0)
        XCTAssertEqual(result.z, -3)
    }
    
    /// Test length
    func testLenght() throws {
        let coord = try CubeCoordinates(x: 1, y: 1, z: -2)
        let distance = Math.length(coordinates: coord)
        XCTAssertEqual(distance, 2)
    }
    
    /// Test distance
    func testDistance() throws {
        let aCoord = try CubeCoordinates(x: 2, y: -1, z: -1)
        let bCoord = try CubeCoordinates(x: 0, y: 4, z: -4)
        let distance = try Math.distance(from: aCoord, to: bCoord)
        XCTAssertEqual(distance, 5)
    }
    
    /// Test direction vector
    func testDirection() throws {
        var index = 0
        var direction = Math.direction(at: index)
        XCTAssertEqual(direction.x, 1)
        XCTAssertEqual(direction.y, 0)
        XCTAssertEqual(direction.z, -1)
        
        // test negative index outside the boundries
        index = -1
        direction = Math.direction(at: index)
        XCTAssertEqual(direction.x, 0)
        XCTAssertEqual(direction.y, 1)
        XCTAssertEqual(direction.z, -1)
    }
    
    /// Test neighbor
    func testNeighbor() throws {
        var coord = try CubeCoordinates(x: 0, y: 0, z: 0)
        var neighbor = try Math.neighbor(at: 0, origin: coord)
        XCTAssertEqual(neighbor.x, 1)
        XCTAssertEqual(neighbor.y, 0)
        XCTAssertEqual(neighbor.z, -1)
        
        coord = try CubeCoordinates(x: 1, y: -1, z: 0)
        neighbor = try Math.neighbor(at: 3, origin: coord)
        XCTAssertEqual(neighbor.x, 0)
        XCTAssertEqual(neighbor.y, -1)
        XCTAssertEqual(neighbor.z, 1)
        
        coord = try CubeCoordinates(x: 1, y: -1, z: 0)
        neighbor = try Math.neighbor(at: 1, origin: coord)
        XCTAssertEqual(neighbor.x, 2)
        XCTAssertEqual(neighbor.y, -2)
        XCTAssertEqual(neighbor.z, 0)
    }
    
    /// Test diagonal neighbor
    func testDiagonalNeighbor() throws {
        let coord = try CubeCoordinates(x: 0, y: 0, z: 0)
        let neighbor = try Math.diagonalNeighbor(at: 0, origin: coord)
        XCTAssertEqual(neighbor.x, 2)
        XCTAssertEqual(neighbor.y, -1)
        XCTAssertEqual(neighbor.z, -1)
    }
    
    /// Test left rotation
    func testRotateLeft() throws {
        let coord = try CubeCoordinates(x: 1, y: 0, z: -1)
        let result = try Math.rotateLeft(coordinates: coord)
        XCTAssertEqual(result.x, 0)
        XCTAssertEqual(result.y, 1)
        XCTAssertEqual(result.z, -1)
    }
    
    /// Test right rotation
    func testRotateRight() throws {
        let coord = try CubeCoordinates(x: 1, y: 0, z: -1)
        let result = try Math.rotateRight(coordinates: coord)
        XCTAssertEqual(result.x, 1)
        XCTAssertEqual(result.y, -1)
        XCTAssertEqual(result.z, 0)
    }
    
    /// Test rounding and linear interpolation
    func testRound() throws {
        let a = try CubeFractionalCoordinates(x: 0.0, y:  0.0, z: 0.0);
        let b = try CubeFractionalCoordinates(x: 1.0, y: -1.0, z: 0.0);
        let c = try CubeFractionalCoordinates(x: 0.0, y: -1.0, z: 1.0);
        let d = try CubeFractionalCoordinates(x: a.x * 0.4 + b.x * 0.3 + c.x * 0.3, y: a.y * 0.4 + b.y * 0.3 + c.y * 0.3, z: a.z * 0.4 + b.z * 0.3 + c.z * 0.3)
        let e = try CubeFractionalCoordinates(x: a.x * 0.3 + b.x * 0.3 + c.x * 0.4, y: a.y * 0.4 + b.y * 0.3 + c.y * 0.4, z: a.z * 0.4 + b.z * 0.3 + c.z * 0.4)
        XCTAssertEqual(try Math.lerpCube(a: CubeFractionalCoordinates(x: 0.0, y: 0.0, z: 0.0), b: CubeFractionalCoordinates(x: 10.0, y: -20.0, z: 10.0), f: 0.5), try CubeCoordinates(x: 5, y: -10, z: 5))
        XCTAssertEqual(Math.lerpCube(a: a, b: b, f: 0.499), CubeCoordinates(x: a.x, y: a.y, z: a.z))
        XCTAssertEqual(Math.lerpCube(a: a, b: b, f: 0.501), CubeCoordinates(x: b.x, y: b.y, z: b.z))
        XCTAssertEqual(CubeCoordinates(x: d.x, y: d.y, z: d.z), CubeCoordinates(x: a.x, y: a.y, z: a.z))
        XCTAssertEqual(CubeCoordinates(x: e.x, y: e.y, z: e.z), CubeCoordinates(x: c.x, y: c.y, z: c.z))
    }
    
    /// Test calculation of hexagon corners
    func testHexCorners() throws {
        let hex = try CubeCoordinates(x: 0, y: 0, z: 0)
        let hexSize = HexSize(width: 10.0, height: 10.0)
        let gridOrigin = Point(x: 0.0, y: 0.0)
        let cornersForPointy = Math.hexCorners(
            coordinates: hex,
            hexSize: hexSize,
            origin: gridOrigin,
            orientation: Orientation.pointyOnTop)
        let expectedCornersForPointy: [Point] = [
            Point(x: 8.6602540378443873, y: 4.9999999999999991),
            Point(x: 0.00000000000000061232339957367663, y: 10.0),
            Point(x: -8.6602540378443873, y: 4.9999999999999991),
            Point(x: -8.660254037844389, y: -4.9999999999999982),
            Point(x: -0.0000000000000018369701987210296, y: -10.0),
            Point(x: 8.6602540378443837, y: -5.0000000000000044)
        ]
        XCTAssertTrue(cornersForPointy == expectedCornersForPointy)
        
        let cornersForFlat = Math.hexCorners(
            coordinates: hex,
            hexSize: hexSize,
            origin: gridOrigin,
            orientation: Orientation.flatOnTop)
        let expectedCornersForFlat: [Point] = [
            Point(x: 10.0, y: 0.0),
            Point(x: 5.0000000000000009, y: 8.6602540378443855),
            Point(x: -4.9999999999999982, y: 8.660254037844389),
            Point(x: -10.0, y: 0.0000000000000012246467991473533),
            Point(x: -5.0000000000000044, y: -8.6602540378443837),
            Point(x: 5.0, y: -8.6602540378443855)
        ]
        XCTAssertTrue(cornersForFlat == expectedCornersForFlat)
    }
    
    /// Test line drawing
    func testLinedraw() throws {
        let line = try Math.line(from: CubeCoordinates(x: 0, y: 0, z: 0), to: CubeCoordinates(x: 1, y: -5, z: 4))
        let testSet: Set<CubeCoordinates> = try [
            CubeCoordinates(x: 0, y:  0, z: 0),
            CubeCoordinates(x: 0, y: -1, z: 1),
            CubeCoordinates(x: 0, y: -2, z: 2),
            CubeCoordinates(x: 1, y: -3, z: 2),
            CubeCoordinates(x: 1, y: -4, z: 3),
            CubeCoordinates(x: 1, y: -5, z: 4)
            ]
        XCTAssertEqual(line, testSet)
    }

    /// Test ring
    func testRing() throws {
        let ring1 = try Math.ring(from: CubeCoordinates(x: 1, y: -1, z: 0), in: 1)
        let testSet1: Set<CubeCoordinates> = try [
            CubeCoordinates(x:  0,  y: -1,  z:  1),
            CubeCoordinates(x:  0,  y:  0,  z:  0),
            CubeCoordinates(x:  1,  y:  0,  z: -1),
            CubeCoordinates(x:  2,  y: -1,  z: -1),
            CubeCoordinates(x:  2,  y: -2,  z:  0),
            CubeCoordinates(x:  1,  y: -2,  z:  1)
            ]
        XCTAssertEqual(ring1, testSet1)
        
        let ring2 = try Math.ring(from: CubeCoordinates(x: 1, y: -1, z: 0), in: 2)
        let testSet2: Set<CubeCoordinates> = try [
            CubeCoordinates(x: -1, y: -1, z: 2),
            CubeCoordinates(x: 0, y: -2, z: 2),
            CubeCoordinates(x: 1, y: -3, z: 2),
            CubeCoordinates(x: 2, y: -3, z: 1),
            CubeCoordinates(x: 3, y: -3, z: 0),
            CubeCoordinates(x: 3, y: -2, z: -1),
            CubeCoordinates(x: 3, y: -1, z: -2),
            CubeCoordinates(x: 2, y: 0, z: -2),
            CubeCoordinates(x: 1, y: 1, z: -2),
            CubeCoordinates(x: 0, y: 1, z: -1),
            CubeCoordinates(x: -1, y: 1, z: 0),
            CubeCoordinates(x: -1, y: 0, z: 1)
            ]
        XCTAssertEqual(ring2, testSet2)
    }
    
    /// Test zero ring
    func testZeroRing() throws {
        let ring = try Math.ring(from: CubeCoordinates(x: 1, y: -1, z: 0), in: 0)
        let testSet: Set<CubeCoordinates> = try [
            CubeCoordinates(x: 1, y: -1, z: 0),
        ]
        XCTAssertEqual(ring, testSet)
    }
    
    /// Test invalid ring
    func testInvalidRing() throws {
        XCTAssertThrowsError(try Math.ring(from: CubeCoordinates(x: 1, y: -1, z: 0), in: -1))
    }
    
    /// Test filled ring
    func testFilledRing() throws {
        let filledRing = try Math.filledRing(from: CubeCoordinates(x: 0, y: 0, z: 0), in: 1)
        let testSet: Set<CubeCoordinates> = try [
            CubeCoordinates(x:  0,  y:  0,  z:  0),
            CubeCoordinates(x:  1,  y:  0,  z: -1),
            CubeCoordinates(x:  1,  y: -1,  z:  0),
            CubeCoordinates(x:  0,  y: -1,  z:  1),
            CubeCoordinates(x: -1,  y:  0,  z:  1),
            CubeCoordinates(x: -1,  y:  1,  z:  0),
            CubeCoordinates(x:  0,  y:  1,  z: -1)
            ]
        XCTAssertEqual(filledRing, testSet)
    }
    
    // Test invalid filled ring
    func testInvalidFilledRing() throws {
        XCTAssertThrowsError(try Math.filledRing(from: CubeCoordinates(x: 0, y: 0, z: 0), in: -5))
    }
    
    func testFieldOfView () throws {
        let grid = HexGrid(shape: GridShape.hexagon(3))
        grid.cellAt(try CubeCoordinates(x: -1,  y:  1,  z:  0))?.isOpaque = true
        grid.cellAt(try CubeCoordinates(x: -1,  y:  0,  z:  1))?.isOpaque = true
        grid.cellAt(try CubeCoordinates(x:  1,  y: -1,  z:  0))?.isOpaque = true
        grid.cellAt(try CubeCoordinates(x:  1,  y:  1,  z: -2))?.isOpaque = true
        let fovSet = try Math.calculateFieldOfView(from: CubeCoordinates(x: 0, y: 0, z: 0), in: 3, on: grid)
        let testSet: Set<CubeCoordinates> = try [
            // origin/center
            CubeCoordinates(x:  0,  y:  0,  z:  0),
            // 1st ring
            CubeCoordinates(x: -1,  y:  1,  z:  0), // isOpauqe
            CubeCoordinates(x:  0,  y:  1,  z: -1),
            CubeCoordinates(x:  1,  y:  0,  z: -1),
            CubeCoordinates(x:  1,  y: -1,  z:  0), // isOpaque
            CubeCoordinates(x:  0,  y: -1,  z:  1),
            CubeCoordinates(x: -1,  y:  0,  z:  1), // isOpauqe
            
            // 2nd ring
            // CubeCoordinates(x: -2,  y:  2,  z:  0), // is shaded = true
            // CubeCoordinates(x: -1,  y:  2,  z: -1), // is shaded = true
            CubeCoordinates(x:  0,  y:  2,  z: -2),
            CubeCoordinates(x:  1,  y:  1,  z: -2),
            CubeCoordinates(x:  2,  y:  0,  z: -2),
            // CubeCoordinates(x:  2,  y: -1,  z: -1), // is shaded = true
            // CubeCoordinates(x:  2,  y: -2,  z:  0), // is shaded = true
            // CubeCoordinates(x:  1,  y: -2,  z:  1), // is shaded = true
            CubeCoordinates(x:  0,  y: -2,  z:  2),
            // CubeCoordinates(x: -1,  y: -1,  z:  2), // is shaded = true
            // CubeCoordinates(x: -2,  y:  0,  z:  2), // is shaded = true
            // CubeCoordinates(x: -2,  y:  1,  z:  1), // is shaded = true
            
            // 3rd ring
            // CubeCoordinates(x:  -3,  y:  3,  z: 0), // is shaded = true
            // CubeCoordinates(x:  -2,  y:  3,  z: -1), // is shaded = true
            CubeCoordinates(x:  -1,  y:  3,  z: -2),
            CubeCoordinates(x:  0,  y:  3,  z: -3),
            // CubeCoordinates(x:  1,  y:  2,  z: -3), // is shaded = true
            // CubeCoordinates(x:  2,  y:  1,  z: -3), // is shaded = true
            CubeCoordinates(x:  3,  y:  0,  z: -3),
            CubeCoordinates(x:  3,  y:  -1,  z: -2),
            // CubeCoordinates(x:  3,  y:  -2,  z: -1), // is shaded = true
            // CubeCoordinates(x:  3,  y:  -3,  z: 0), // is shaded = true
            // CubeCoordinates(x:  2,  y:  -3,  z: 1), // is shaded = true
            CubeCoordinates(x:  1,  y:  -3,  z: 2),
            CubeCoordinates(x:  0,  y:  -3,  z: 3),
            CubeCoordinates(x:  -1,  y:  -2,  z: 3),
            // CubeCoordinates(x:  -2,  y:  -1,  z: 3), // is shaded = true
            // CubeCoordinates(x:  -3,  y:  0,  z: 3), // is shaded = true
            // CubeCoordinates(x:  -3,  y:  1,  z: 2), // is shaded = true
            // CubeCoordinates(x:  -3,  y:  2,  z: 1) // is shaded = true
        ]
        XCTAssertEqual(testSet, fovSet)
        XCTAssertThrowsError(try Math.calculateFieldOfView(from: CubeCoordinates(x: 0, y: 0, z: 0), in: -5, on: grid))
    }
    
    func testFieldOfViewIncludingPartials () throws {
        let grid = HexGrid(shape: GridShape.hexagon(3))
        grid.cellAt(try CubeCoordinates(x: -1,  y:  1,  z:  0))?.isOpaque = true
        grid.cellAt(try CubeCoordinates(x: -1,  y:  0,  z:  1))?.isOpaque = true
        grid.cellAt(try CubeCoordinates(x:  1,  y: -1,  z:  0))?.isOpaque = true
        grid.cellAt(try CubeCoordinates(x:  1,  y:  1,  z: -2))?.isOpaque = true
        let fovSet = try Math.calculateFieldOfView(from: CubeCoordinates(x: 0, y: 0, z: 0), in: 3, on: grid, includePartiallyVisible: true)
        let testSet: Set<CubeCoordinates> = try [
            // origin/center
            CubeCoordinates(x:  0,  y:  0,  z:  0),
            // 1st ring
            CubeCoordinates(x: -1,  y:  1,  z:  0), // isOpauqe
            CubeCoordinates(x:  0,  y:  1,  z: -1),
            CubeCoordinates(x:  1,  y:  0,  z: -1),
            CubeCoordinates(x:  1,  y: -1,  z:  0), // isOpaque
            CubeCoordinates(x:  0,  y: -1,  z:  1),
            CubeCoordinates(x: -1,  y:  0,  z:  1), // isOpauqe
            
            // 2nd ring
            // CubeCoordinates(x: -2,  y:  2,  z:  0), // is shaded = true
            CubeCoordinates(x: -1,  y:  2,  z: -1),
            CubeCoordinates(x:  0,  y:  2,  z: -2),
            CubeCoordinates(x:  1,  y:  1,  z: -2),
            CubeCoordinates(x:  2,  y:  0,  z: -2),
            CubeCoordinates(x:  2,  y: -1,  z: -1),
            // CubeCoordinates(x:  2,  y: -2,  z:  0), // is shaded = true
            CubeCoordinates(x:  1,  y: -2,  z:  1),
            CubeCoordinates(x:  0,  y: -2,  z:  2),
            CubeCoordinates(x: -1,  y: -1,  z:  2),
            // CubeCoordinates(x: -2,  y:  0,  z:  2), // is shaded = true
            // CubeCoordinates(x: -2,  y:  1,  z:  1), // is shaded = true
            
            // 3rd ring
            // CubeCoordinates(x:  -3,  y:  3,  z: 0), // is shaded = true
            // CubeCoordinates(x:  -2,  y:  3,  z: -1), // is shaded = true
            CubeCoordinates(x:  -1,  y:  3,  z: -2),
            CubeCoordinates(x:  0,  y:  3,  z: -3),
            CubeCoordinates(x:  1,  y:  2,  z: -3),
            CubeCoordinates(x:  2,  y:  1,  z: -3),
            CubeCoordinates(x:  3,  y:  0,  z: -3),
            CubeCoordinates(x:  3,  y:  -1,  z: -2),
            // CubeCoordinates(x:  3,  y:  -2,  z: -1), // is shaded = true
            // CubeCoordinates(x:  3,  y:  -3,  z: 0), // is shaded = true
            // CubeCoordinates(x:  2,  y:  -3,  z: 1), // is shaded = true
            CubeCoordinates(x:  1,  y:  -3,  z: 2),
            CubeCoordinates(x:  0,  y:  -3,  z: 3),
            CubeCoordinates(x:  -1,  y:  -2,  z: 3),
            // CubeCoordinates(x:  -2,  y:  -1,  z: 3), // is shaded = true
            // CubeCoordinates(x:  -3,  y:  0,  z: 3), // is shaded = true
            // CubeCoordinates(x:  -3,  y:  1,  z: 2), // is shaded = true
            // CubeCoordinates(x:  -3,  y:  2,  z: 1) // is shaded = true
        ]
        XCTAssertEqual(testSet, fovSet)
        XCTAssertThrowsError(try Math.calculateFieldOfView(from: CubeCoordinates(x: 0, y: 0, z: 0), in: -5, on: grid))
    }
        
    /// Test breadthFirstSearch algorithm
    func testBreadthFirstSearch() throws {
        let grid = HexGrid(shape: GridShape.hexagon(2))
        grid.cellAt(try CubeCoordinates(x:  1,  y:  0,  z: -1))?.isBlocked = true
        grid.cellAt(try CubeCoordinates(x:  0,  y:  1,  z: -1))?.isBlocked = true
        let searchResultSet = try Math.breadthFirstSearch(from: CubeCoordinates(x: 0, y: 0, z: 0), in: 2, on: grid)
        let testSet: Set<CubeCoordinates> = try [
            CubeCoordinates(x:  0,  y:  0,  z:  0),
            // CubeCoordinates(x:  1,  y:  0,  z: -1), // Blocked hex
            CubeCoordinates(x:  1,  y: -1,  z:  0),
            CubeCoordinates(x:  0,  y: -1,  z:  1),
            CubeCoordinates(x: -1,  y:  0,  z:  1),
            CubeCoordinates(x: -1,  y:  1,  z:  0),
            // CubeCoordinates(x:  0,  y:  1,  z: -1), // Blocked hex
            // CubeCoordinates(x:  2, y:  0, z: -2), // Unreachable hex
            CubeCoordinates(x:  2, y: -1, z: -1),
            CubeCoordinates(x:  2, y: -2, z:  0),
            CubeCoordinates(x:  1, y: -2, z:  1),
            CubeCoordinates(x:  0, y: -2, z:  2),
            CubeCoordinates(x: -1, y: -1, z:  2),
            CubeCoordinates(x: -2, y:  0, z:  2),
            CubeCoordinates(x: -2, y:  1, z:  1),
            CubeCoordinates(x: -2, y:  2, z:  0),
            CubeCoordinates(x: -1, y:  2, z: -1),
            // CubeCoordinates(x:  0, y:  2, z: -2),  // Unreachable hex
            // CubeCoordinates(x:  1, y:  1, z: -2)  // Unreachable hex
        ]
        XCTAssertEqual(testSet, searchResultSet)
        XCTAssertThrowsError(try Math.breadthFirstSearch(from: CubeCoordinates(x: 0, y: 0, z: 0), in: -5, on: grid))
    }
    
    /// Test aStar algorithm
    func testAStarPath() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(2))
        grid.cellAt(try CubeCoordinates(x:  1, y:  0, z: -1))?.isBlocked = true
        grid.cellAt(try CubeCoordinates(x:  0, y:  1, z: -1))?.isBlocked = true
        if let path = try Math.aStarPath(from: CubeCoordinates(x: 0, y: 0, z: 0), to: CubeCoordinates(x: 2, y: 0, z: -2), on: grid) {
            let testSet: Set<CubeCoordinates> = try [
                CubeCoordinates(x:  0, y:  0, z:  0),
                CubeCoordinates(x:  1, y: -1, z:  0),
                CubeCoordinates(x:  2, y: -1, z: -1),
                CubeCoordinates(x:  2, y:  0, z: -2)
            ]
            XCTAssertEqual(path.count, testSet.count)
            for pathItem in path {
                XCTAssertTrue(testSet.contains(pathItem))
            }
        } else {
            XCTFail("Path not found.")
        }
    }

    // Test aStar algorithm for case when path doesn't exist
    func testAStarNoPath() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(2))
        grid.cellAt(try CubeCoordinates(x:  1, y:  0, z: -1))?.isBlocked = true
        grid.cellAt(try CubeCoordinates(x:  1, y:  1, z: -2))?.isBlocked = true
        grid.cellAt(try CubeCoordinates(x:  2, y: -1, z: -1))?.isBlocked = true
        XCTAssertNil(try Math.aStarPath(
            from: CubeCoordinates(x: 0, y: 0, z: 0),
            to: CubeCoordinates(x: 2, y: 0, z: -2),
            on: grid))
    }
    
    
    static var allTests = [
        ("Test Add operation", testAddOperation),
        ("Test Subtract operation", testSubtractOperation),
        ("Test Scale operation", testScaleOperation),
        ("Test Length", testLenght),
        ("Test Distance", testDistance),
        ("Test Direction vector", testDirection),
        ("Generate all neighbors for provided coordinates", testNeighbor),
        ("Generate all diagonal neighbors for provided coordinates", testDiagonalNeighbor),
        ("Test Rotate left", testRotateLeft),
        ("Test Rotate right", testRotateRight),
        ("Test calculation of hexagon corners", testHexCorners),
        ("Test rounding and linear interpolation", testRound),
        ("Test linedraw", testLinedraw),
        ("Test ring", testRing),
        ("Test zero ring", testZeroRing),
        ("Test invalid ring", testInvalidRing),
        ("Test filled ring", testFilledRing),
        ("Test invalid filled ring", testInvalidFilledRing),
        ("Test breadthFirstSearch algorithm", testBreadthFirstSearch),
        ("Test aStar algorithm", testAStarPath),
        ("Test aStar algorithm for case when path doesn't exist", testAStarNoPath)
        ]
    
}
