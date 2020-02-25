import XCTest
@testable import HexGrid

class HexGridTests: XCTestCase {   
    /// Get cell by coordinates
    func testGetCell() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(2))
        if let cell = grid.cellAt(try CubeCoordinates(x: 1, y: 0, z: -1)) {
            XCTAssertTrue(grid.cells.contains(cell))
        } else {
            XCTFail("Unable to get cell")
        }
    }
    
    /// Get non blocked cells
    func testGetNonBlockedCells() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(1))
        grid.cellAt(try CubeCoordinates(x: 1, y: 0, z: -1))?.isBlocked = true
        
        let expectedSet: Set<Cell> = try [
            Cell(CubeCoordinates(x:  0, y:  0, z:  0)),
            Cell(CubeCoordinates(x:  1, y: -1, z:  0)),
            Cell(CubeCoordinates(x:  0, y: -1, z:  1)),
            Cell(CubeCoordinates(x: -1, y:  0, z:  1)),
            Cell(CubeCoordinates(x: -1, y:  1, z:  0)),
            Cell(CubeCoordinates(x:  0, y:  1, z: -1))
        ]
        XCTAssertEqual(grid.nonBlockedCells(), expectedSet)
    }
    
    /// Get non blocked coordinates
    func testGetNonBlockedCoordinates() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(1))
        grid.cellAt(try CubeCoordinates(x: 1, y: 0, z: -1))?.isBlocked = true
        
        let expectedSet: Set<CubeCoordinates> = try [
            CubeCoordinates(x:  0, y:  0, z:  0),
            CubeCoordinates(x:  1, y: -1, z:  0),
            CubeCoordinates(x:  0, y: -1, z:  1),
            CubeCoordinates(x: -1, y:  0, z:  1),
            CubeCoordinates(x: -1, y:  1, z:  0),
            CubeCoordinates(x:  0, y:  1, z: -1)
        ]
        XCTAssertEqual(grid.nonBlockedCellsCoordinates(), expectedSet)
    }
    
    /// Test neighbor coordinates
    func testNeighborCoordinates() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(1))
        
        let expectedCoordinates = try CubeCoordinates(x: 1, y: 0, z: -1)
        let neighborCoordinates = try grid.neighborCoordinates(
            for: CubeCoordinates(x: 0, y: 0, z: 0),
            at: Direction.Pointy.northEast.rawValue)
        XCTAssertEqual(neighborCoordinates, expectedCoordinates)
        
        if let noCell = try grid.cellAt(CubeCoordinates(x: 0, y: 1, z: -1)) {
            grid.cells.remove(noCell)
        }
        XCTAssertNil(try grid.neighborCoordinates(
            for: CubeCoordinates(x: 0, y: 1, z: -1),
            at: Direction.Pointy.northWest.rawValue))
    }
    
    /// Test directions for all neighbors (orientation = PointyOnTop)
    func testNeighborDirectionsPointy() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(3),
            orientation: Orientation.pointyOnTop // just for better readability (pointyOnTop is a default value)
        )
        
        if let originCell = try grid.cellAt(CubeCoordinates(x: 1, y: 0, z: -1)) {
            var direction: Direction.Pointy
            // NorthEast
            direction = Direction.Pointy.northEast
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 2, y: 0, z: -2)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
            // East
            direction = Direction.Pointy.east
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 2, y: -1, z: -1)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
            // SouthEast
            direction = Direction.Pointy.southEast
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 1, y: -1, z: 0)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
            // SouthWest
            direction = Direction.Pointy.southWest
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 0, y: 0, z: 0)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
            // West
            direction = Direction.Pointy.west
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 0, y: 1, z: -1)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
            // NorthWest
            direction = Direction.Pointy.northWest
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 1, y: 1, z: -2)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
        } else {
            XCTFail("Unable to get origin cell")
        }
    }
    
    /// Test directions for all neighbors (orientation = FlatOnTop)
    func testNeighborDirectionsFlat() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(3),
            orientation: Orientation.flatOnTop
        )
        if let originCell = try grid.cellAt(CubeCoordinates(x: 1, y: 0, z: -1)) {
            var direction: Direction.Flat
            // NorthEast
            direction = Direction.Flat.north
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 1, y: 1, z: -2)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
            // NorthEast
            direction = Direction.Flat.northEast
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 2, y: 0, z: -2)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
            // SouthEast
            direction = Direction.Flat.southEast
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 2, y: -1, z: -1)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
            // South
            direction = Direction.Flat.south
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 1, y: -1, z: 0)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
            // SouthWest
            direction = Direction.Flat.southWest
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 0, y: 0, z: 0)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
            // NorthWest
            direction = Direction.Flat.northWest
            if let neighbor = try grid.neighbor(for: originCell, at: direction.rawValue) {
                let expectedNeighborCoordinates = try CubeCoordinates(x: 0, y: 1, z: -1)
                XCTAssertEqual(neighbor.coordinates, expectedNeighborCoordinates)
            } else {
                XCTFail("Unable to get \(direction) neighbor cell")
            }
            
        } else {
            XCTFail("Unable to get origin cell")
        }
    }
    
    /// Get cell neighbors coordinates
    func testGetCellNeighborsCoordinates() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(1))
        let originCoordinates = try CubeCoordinates(x: 1, y: 0, z: -1)
        let neighbors = try grid.neighborsCoordinates(for: originCoordinates)
        let expectedNeighbors: Set<CubeCoordinates> = try [
            CubeCoordinates(x:  0,  y:  1,  z: -1),
            CubeCoordinates(x:  0,  y:  0,  z:  0),
            CubeCoordinates(x:  1,  y: -1,  z:  0)
        ]
        XCTAssertEqual(neighbors, expectedNeighbors)
    }
    
    /// Get cell neighbors
    func testGetCellNeighbors() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(1))
        if let originCell = try grid.cellAt(CubeCoordinates(x: 1, y: 0, z: -1)) {
            let neighbors = try grid.neighbors(for: originCell)
            let expectedNeighbors: Set<Cell> = try [
                Cell(CubeCoordinates(x:  0,  y:  1,  z: -1)),
                Cell(CubeCoordinates(x:  0,  y:  0,  z:  0)),
                Cell(CubeCoordinates(x:  1,  y: -1,  z:  0))
            ]
            XCTAssertEqual(
                neighbors.count,
                expectedNeighbors.count
            )
            for neighbor in neighbors {
                XCTAssertTrue(expectedNeighbors.contains(neighbor))
            }
        } else {
            XCTFail("Unable to get origin cell")
        }
    }
    
    /// Get cell diagonal neighbor
    func testGetCellDiagonalNeighbor() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(3))
        if let originCell = try grid.cellAt(CubeCoordinates(x: 1, y: 0, z: -1)) {
            if let neighbor = try grid.diagonalNeighbor(for: originCell, at: Direction.Pointy.northEast.rawValue) {
                let neighborCoords = try CubeCoordinates(x: 3, y: -1, z: -2)
                XCTAssertEqual(neighbor.coordinates, neighborCoords)
            } else {
                XCTFail("Unable to get diagonal neighbor cell")
            }
        } else {
            XCTFail("Unable to get origin cell")
        }
    }
    
    /// Get cell diagonal neighbor coordinates
    func testGetCellDiagonalNeighborCoordinates() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(3))
        var origin = try CubeCoordinates(x: 1, y: 0, z: -1)
        var neighborCoords = try grid.diagonalNeighborCoordinates(for: origin, at: Direction.Pointy.northEast.rawValue)
        let expectedNeighborCoords = try CubeCoordinates(x: 3, y: -1, z: -2)
        XCTAssertEqual(neighborCoords, expectedNeighborCoords)
        
        origin = try CubeCoordinates(x: 3, y: -1, z: -2)
        neighborCoords = try grid.diagonalNeighborCoordinates(for: origin, at: Direction.Pointy.northEast.rawValue)
        XCTAssertNil(neighborCoords)
            
    }

    // Get cell diagonal neighbors coordinates
    func testGetCellDiagonalNeighborsCoordinates() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(2))
        let originCoordinates = try CubeCoordinates(x: 1, y: 0, z: -1)
        let neighbors = try grid.diagonalNeighborsCoordinates(for: originCoordinates)
        let expectedNeighbors: Set<CubeCoordinates> = try [
            CubeCoordinates(x:  2, y: -2, z:  0),
            CubeCoordinates(x:  0, y: -1, z:  1),
            CubeCoordinates(x: -1, y:  1, z:  0),
            CubeCoordinates(x:  0, y:  2, z: -2)
        ]
        XCTAssertEqual(
            neighbors.count,
            expectedNeighbors.count
        )
        for neighbor in neighbors {
            XCTAssertTrue(expectedNeighbors.contains(neighbor))
        }
    }

    /// Get cell diagonal neighbors
    func testGetCellDiagonalNeighbors() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(2))
        if let originCell = try grid.cellAt(CubeCoordinates(x: 1, y: 0, z: -1)) {
            let neighbors = try grid.diagonalNeighbors(for: originCell)
            let expectedNeighbors: Set<Cell> = try [
                Cell(CubeCoordinates(x:  2,  y: -2,  z:  0)),
                Cell(CubeCoordinates(x:  0,  y: -1,  z:  1)),
                Cell(CubeCoordinates(x: -1,  y:  1,  z:  0)),
                Cell(CubeCoordinates(x:  0,  y:  2,  z: -2))
            ]
            XCTAssertEqual(
                neighbors.count,
                expectedNeighbors.count
            )
            for neighbor in neighbors {
                XCTAssertTrue(expectedNeighbors.contains(neighbor))
            }
        } else {
            XCTFail("Unable to get origin cell")
        }
    }
    
    /// Get line between two cells
    func testLine() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(2))
        if let originCell = try grid.cellAt(CubeCoordinates(x: 0, y: 0, z: 0)), let targetCell = grid.cellAt(try CubeCoordinates(x: 2, y: 0, z: -2)) {
            if let line = try grid.line(from: originCell, to: targetCell) {
                let expectedLine: Set<Cell> = try [
                    Cell(CubeCoordinates(x:  0,  y:  0,  z:  0)),
                    Cell(CubeCoordinates(x:  1,  y:  0,  z: -1)),
                    Cell(CubeCoordinates(x:  2,  y:  0,  z: -2))
                ]
                
                XCTAssertEqual(
                    line.count,
                    expectedLine.count
                )
                for cell in line {
                    XCTAssertTrue(expectedLine.contains(cell))
                }
            } else {
                XCTFail("Unable to find line from: \(originCell) to: \(targetCell) cell")
            }
        } else {
            XCTFail("Unable to get origin cell")
        }
    }
    
    /// Test invalid line
    func testInvalidLine() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(2))
        if let noCell = try grid.cellAt(CubeCoordinates(x: 1, y: 0, z: -1)) {
            grid.cells.remove(noCell)
        }
        
        if let originCell = try grid.cellAt(CubeCoordinates(x: 0, y: 0, z: 0)), let targetCell = grid.cellAt(try CubeCoordinates(x: 2, y: 0, z: -2)) {
            let line = try grid.line(from: originCell, to: targetCell)
            XCTAssertNil(line)
        } else {
            XCTFail("Unable to get origin or target cell")
        }
    }
    
    /// Test ring coordinates
    func testRingCoordinates() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(1))
        grid.cellAt(try CubeCoordinates(x:  1, y:  0, z: -1))?.isBlocked = true
        
        let testSet: Set<CubeCoordinates> = try [
            CubeCoordinates(x:  1,  y: -1,  z:  0),
            CubeCoordinates(x:  0,  y: -1,  z:  1),
            CubeCoordinates(x: -1,  y:  0,  z:  1),
            CubeCoordinates(x: -1,  y:  1,  z:  0),
            CubeCoordinates(x:  0,  y:  1,  z: -1)
        ]
        
        let testSetWithBlocked: Set<CubeCoordinates> = try [
            CubeCoordinates(x:  1,  y:  0,  z: -1),
            CubeCoordinates(x:  1,  y: -1,  z:  0),
            CubeCoordinates(x:  0,  y: -1,  z:  1),
            CubeCoordinates(x: -1,  y:  0,  z:  1),
            CubeCoordinates(x: -1,  y:  1,  z:  0),
            CubeCoordinates(x:  0,  y:  1,  z: -1)
        ]
        
        let origin = try CubeCoordinates(x: 0, y: 0, z: 0)
        let ring = try grid.ringCoordinates(from: origin, in: 1)
        XCTAssertEqual(ring, testSet)
        let ringWithBlocked = try grid.ringCoordinates(from: origin, in: 1, includingBlocked: true)
        XCTAssertEqual(ringWithBlocked, testSetWithBlocked)
    }
    
    /// Test ring
    func testRing() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(1))
        grid.cellAt(try CubeCoordinates(x:  1, y:  0, z: -1))?.isBlocked = true
        
        let testSet: Set<Cell> = try [
            Cell(CubeCoordinates(x:  1,  y: -1,  z:  0)),
            Cell(CubeCoordinates(x:  0,  y: -1,  z:  1)),
            Cell(CubeCoordinates(x: -1,  y:  0,  z:  1)),
            Cell(CubeCoordinates(x: -1,  y:  1,  z:  0)),
            Cell(CubeCoordinates(x:  0,  y:  1,  z: -1))
        ]
        
        let testSetWithBlocked: Set<Cell> = try [
            Cell(CubeCoordinates(x:  1,  y:  0,  z: -1)),
            Cell(CubeCoordinates(x:  1,  y: -1,  z:  0)),
            Cell(CubeCoordinates(x:  0,  y: -1,  z:  1)),
            Cell(CubeCoordinates(x: -1,  y:  0,  z:  1)),
            Cell(CubeCoordinates(x: -1,  y:  1,  z:  0)),
            Cell(CubeCoordinates(x:  0,  y:  1,  z: -1))
        ]
        
        if let originCell = try grid.cellAt(CubeCoordinates(x: 0, y: 0, z: 0)) {
            let ring = try grid.ring(from: originCell, in: 1)
            XCTAssertEqual(ring, testSet)
            let ringWithBlocked = try grid.ring(from: originCell, in: 1, includingBlocked: true)
            XCTAssertEqual(ringWithBlocked, testSetWithBlocked)
        }
    }
    
    /// Test filled ring coordinates
    func testFilledRingCoordinates() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(1))
        grid.cellAt(try CubeCoordinates(x:  1, y:  0, z: -1))?.isBlocked = true
        
        let testSet: Set<CubeCoordinates> = try [
            CubeCoordinates(x:  0,  y:  0,  z:  0),
            CubeCoordinates(x:  1,  y: -1,  z:  0),
            CubeCoordinates(x:  0,  y: -1,  z:  1),
            CubeCoordinates(x: -1,  y:  0,  z:  1),
            CubeCoordinates(x: -1,  y:  1,  z:  0),
            CubeCoordinates(x:  0,  y:  1,  z: -1)
        ]
        
        let testSetWithBlocked: Set<CubeCoordinates> = try [
            CubeCoordinates(x:  0,  y:  0,  z:  0),
            CubeCoordinates(x:  1,  y:  0,  z: -1),
            CubeCoordinates(x:  1,  y: -1,  z:  0),
            CubeCoordinates(x:  0,  y: -1,  z:  1),
            CubeCoordinates(x: -1,  y:  0,  z:  1),
            CubeCoordinates(x: -1,  y:  1,  z:  0),
            CubeCoordinates(x:  0,  y:  1,  z: -1)
        ]
        
        let origin = try CubeCoordinates(x: 0, y: 0, z: 0)
        let ring = try grid.filledRingCoordinates(from: origin, in: 1, includingBlocked: false)
        XCTAssertEqual(ring, testSet)
        let ringWithBlocked = try grid.filledRingCoordinates(from: origin, in: 1, includingBlocked: true)
        XCTAssertEqual(ringWithBlocked, testSetWithBlocked)
    }
    
    /// Test filled ring
    func testFilledRing() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(1))
        grid.cellAt(try CubeCoordinates(x:  1, y:  0, z: -1))?.isBlocked = true
        
        let testSet: Set<Cell> = try [
            Cell(CubeCoordinates(x:  0,  y:  0,  z:  0)),
            Cell(CubeCoordinates(x:  1,  y: -1,  z:  0)),
            Cell(CubeCoordinates(x:  0,  y: -1,  z:  1)),
            Cell(CubeCoordinates(x: -1,  y:  0,  z:  1)),
            Cell(CubeCoordinates(x: -1,  y:  1,  z:  0)),
            Cell(CubeCoordinates(x:  0,  y:  1,  z: -1))
        ]
        
        let testSetWithBlocked: Set<Cell> = try [
            Cell(CubeCoordinates(x:  0,  y:  0,  z:  0)),
            Cell(CubeCoordinates(x:  1,  y:  0,  z: -1)),
            Cell(CubeCoordinates(x:  1,  y: -1,  z:  0)),
            Cell(CubeCoordinates(x:  0,  y: -1,  z:  1)),
            Cell(CubeCoordinates(x: -1,  y:  0,  z:  1)),
            Cell(CubeCoordinates(x: -1,  y:  1,  z:  0)),
            Cell(CubeCoordinates(x:  0,  y:  1,  z: -1))
        ]
        
        if let originCell = try grid.cellAt(CubeCoordinates(x: 0, y: 0, z: 0)) {
            let ring = try grid.filledRing(from: originCell, in: 1, includingBlocked: false)
            XCTAssertEqual(ring, testSet)
            let ringWithBlocked = try grid.filledRing(from: originCell, in: 1, includingBlocked: true)
            XCTAssertEqual(ringWithBlocked, testSetWithBlocked)
        }
    }
    
    /// Initialize grid with custom set of cells
    func testInitCustomGrid() throws {
        let cells: Set<Cell> = try [
            Cell(CubeCoordinates(x:  0,  y:  0,  z:  0)),
            Cell(CubeCoordinates(x:  1,  y:  0,  z: -1)),
            Cell(CubeCoordinates(x:  2,  y:  0,  z: -2))
        ]
        let grid = HexGrid(
            cells: cells)
        XCTAssertEqual(grid.cells.count, 3)
        for cell in grid.cells {
            XCTAssertTrue(cells.contains(cell))
        }
    }
    
    func testFindReachableCoordinates() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(1))
        grid.cellAt(try CubeCoordinates(x:  1, y:  0, z: -1))?.isBlocked = true
        grid.cellAt(try CubeCoordinates(x:  1, y: -1, z:  0))?.isBlocked = true
        
        let testSet: Set<CubeCoordinates> = try [
            CubeCoordinates(x:  0,  y:  0,  z:  0),
            CubeCoordinates(x:  0,  y: -1,  z:  1),
            CubeCoordinates(x: -1,  y:  0,  z:  1),
            CubeCoordinates(x: -1,  y:  1,  z:  0),
            CubeCoordinates(x:  0,  y:  1,  z: -1)
        ]
        let origin = try CubeCoordinates(x: 0, y: 0, z: 0)
        let reachableSet = try grid.findReachableCoordinates(from: origin, in: 1)
        XCTAssertEqual(reachableSet, testSet)
    }
    
    func testFindReachable() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(1))
        grid.cellAt(try CubeCoordinates(x:  1, y:  0, z: -1))?.isBlocked = true
        grid.cellAt(try CubeCoordinates(x:  1, y: -1, z:  0))?.isBlocked = true
        
        let testSet: Set<Cell> = try [
            Cell(CubeCoordinates(x:  0,  y:  0,  z:  0)),
            Cell(CubeCoordinates(x:  0,  y: -1,  z:  1)),
            Cell(CubeCoordinates(x: -1,  y:  0,  z:  1)),
            Cell(CubeCoordinates(x: -1,  y:  1,  z:  0)),
            Cell(CubeCoordinates(x:  0,  y:  1,  z: -1))
        ]
        if let origin = grid.cellAt(try CubeCoordinates(x: 0, y: 0, z: 0)) {
            let reachableSet = try grid.findReachable(from: origin, in: 1)
            XCTAssertEqual(reachableSet, testSet)
        }
    }
    
    /// Test pathfinding (coordinates only)
    func testFindPathCoordinates() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(2))
        grid.cellAt(try CubeCoordinates(x:  1, y:  0, z: -1))?.isBlocked = true
        grid.cellAt(try CubeCoordinates(x:  1, y:  1, z: -2))?.isBlocked = true
        
        let expectedPath: [CubeCoordinates] = try [
            CubeCoordinates(x:  0, y:  0, z:  0),
            CubeCoordinates(x:  1, y: -1, z:  0),
            CubeCoordinates(x:  2, y: -1, z: -1),
            CubeCoordinates(x:  2, y:  0, z: -2)
        ]
        let origin = try CubeCoordinates(x: 0, y: 0, z: 0)
        let target = try CubeCoordinates(x: 2, y: 0, z: -2)
        if let path = try grid.findPathCoordinates(from: origin, to: target) {
            XCTAssertEqual(path, expectedPath)
        }
    }
    
    /// Test pathfinding
    func testFindPath() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(2))
        grid.cellAt(try CubeCoordinates(x:  1, y:  0, z: -1))?.isBlocked = true
        grid.cellAt(try CubeCoordinates(x:  1, y:  1, z: -2))?.isBlocked = true
        
        let expectedPath: [Cell] = try [
            Cell(CubeCoordinates(x:  0, y:  0, z:  0)),
            Cell(CubeCoordinates(x:  1, y: -1, z:  0)),
            Cell(CubeCoordinates(x:  2, y: -1, z: -1)),
            Cell(CubeCoordinates(x:  2, y:  0, z: -2))
        ]
        if let originCell = grid.cellAt(try CubeCoordinates(x: 0, y: 0, z: 0)),
            let targetCell = grid.cellAt(try CubeCoordinates(x: 2, y: 0, z: -2)) {
            if let path = try grid.findPath(from: originCell, to: targetCell) {
                XCTAssertEqual(path, expectedPath)
            }
        }
    }
    
    /// Test non existing path
    func testFindNoPath() throws {
        let grid = HexGrid(
            shape: GridShape.hexagon(2))
        grid.cellAt(try CubeCoordinates(x:  1, y:  0, z: -1))?.isBlocked = true
        grid.cellAt(try CubeCoordinates(x:  1, y:  1, z: -2))?.isBlocked = true
        grid.cellAt(try CubeCoordinates(x:  2, y: -1, z: -1))?.isBlocked = true
        
        if let originCell = grid.cellAt(try CubeCoordinates(x: 0, y: 0, z: 0)),
            let targetCell = grid.cellAt(try CubeCoordinates(x: 2, y: 0, z: -2)) {
            XCTAssertNil(try grid.findPath(from: originCell, to: targetCell))
        }
    }
    
    /// Test calculation of polygon corners
    func testPolygonCorners() throws {
        let hexSize = HexSize(width: 10.0, height: 10.0)
        let gridOrigin = Point(x: 0.0, y: 0.0)
        let gridPointy = HexGrid(
            shape: GridShape.hexagon(1),
            orientation: Orientation.pointyOnTop,
            offsetLayout: OffsetLayout.even,
            hexSize: hexSize,
            origin: gridOrigin)
        let polygon = try Cell(CubeCoordinates(x: 0, y: 0, z: 0))
        let cornersForPointy = gridPointy.polygonCorners(for: polygon)
        let expectedCornersForPointy: [Point] = [
            Point(x: 8.6602540378443873, y: 4.9999999999999991),
            Point(x: 0.00000000000000061232339957367663, y: 10.0),
            Point(x: -8.6602540378443873, y: 4.9999999999999991),
            Point(x: -8.660254037844389, y: -4.9999999999999982),
            Point(x: -0.0000000000000018369701987210296, y: -10.0),
            Point(x: 8.6602540378443837, y: -5.0000000000000044)
        ]
        XCTAssertTrue(cornersForPointy == expectedCornersForPointy)
        
        
        let gridFlat = HexGrid(
            shape: GridShape.hexagon(1),
            orientation: Orientation.flatOnTop,
            offsetLayout: OffsetLayout.even,
            hexSize: hexSize,
            origin: gridOrigin)
        
        let cornersForFlat = gridFlat.polygonCorners(for: polygon)
        let expectedCornersForFlat: [Point] = [
            Point(x: 10.0, y: 0.0),
            Point(x: 5.0000000000000009, y: 8.6602540378443855),
            Point(x: -4.9999999999999982, y: 8.660254037844389),
            Point(x: -10.0, y: 0.0000000000000012246467991473533),
            Point(x: -5.0000000000000044, y: -8.6602540378443837),
            Point(x: 5.0, y: -8.6602540378443855)
        ]
        XCTAssertEqual(cornersForFlat, expectedCornersForFlat)
    }
    
    /// Test calculation cell pixel coordinates
    func testPixelCoordinates() throws {
        let hexSize = HexSize(width: 10.0, height: 10.0)
        let gridOrigin = Point(x: 0.0, y: 0.0)
        let gridPointy = HexGrid(
            shape: GridShape.hexagon(1),
            orientation: Orientation.pointyOnTop,
            offsetLayout: OffsetLayout.even,
            hexSize: hexSize,
            origin: gridOrigin)
        let cell = try Cell(CubeCoordinates(x: 1, y: -1, z: 0))
        let center = gridPointy.pixelCoordinates(for: cell)
        let expectedCenter = Point(x: 17.32050807568877, y: 0.0)
        XCTAssertEqual(center, expectedCenter)
    }
    
    /// Test get cell for pixel coordinates
    func testCellAtPixel() throws {
        let hexSize = HexSize(width: 10.0, height: 10.0)
        let gridOrigin = Point(x: 0.0, y: 0.0)
        let gridPointy = HexGrid(
            shape: GridShape.hexagon(2),
            orientation: Orientation.pointyOnTop,
            offsetLayout: OffsetLayout.even,
            hexSize: hexSize,
            origin: gridOrigin)
        let point = Point(x: 17.32050807568877, y: 0.0)
        if let cell = try gridPointy.cellAt(point) {
            let expectedCell = try Cell(CubeCoordinates(x: 1, y: -1, z: 0))
            XCTAssertEqual(cell.coordinates, expectedCell.coordinates)
        } else {
            XCTFail("Unable to find matching cell.")
        }
    }
    
    // Test grid pixel dimensions
    func testGridPixelDimensions() throws {
        let hexSize = HexSize(width: 10.0, height: 10.0)
        let gridOrigin = Point(x: 0.0, y: 0.0)
        let gridPointy = HexGrid(
            shape: GridShape.hexagon(2),
            orientation: Orientation.pointyOnTop,
            offsetLayout: OffsetLayout.even,
            hexSize: hexSize,
            origin: gridOrigin)
        let expectedWidthPonity: Double = 86.6
        let expectedHeightPonity: Double = 80.0
        XCTAssertEqual((gridPointy.pixelWidth * 10).rounded()/10, expectedWidthPonity)
        XCTAssertEqual(gridPointy.pixelHeight, expectedHeightPonity)
        
        let gridFlat = HexGrid(
            shape: GridShape.hexagon(2),
            orientation: Orientation.flatOnTop,
            offsetLayout: OffsetLayout.even,
            hexSize: hexSize,
            origin: gridOrigin)
        let expectedWidthFlat: Double = 80.0
        let expectedHeightFlat: Double = 86.6
        XCTAssertEqual(gridFlat.pixelWidth, expectedWidthFlat)
        XCTAssertEqual((gridFlat.pixelHeight * 10).rounded()/10, expectedHeightFlat)
    }
        
    static var allTests = [
        ("Test cell by coordinates", testGetCell),
        ("Test all non blocked cells", testGetNonBlockedCells),
        ("Test all non blocked coordinates", testGetNonBlockedCoordinates),
        ("Test neighbor coordinates", testNeighborCoordinates),
        ("Test directions for all neighbors (pointy on top orientation)", testNeighborDirectionsPointy),
        ("Test directions for all neighbors (flat on top orientation)", testNeighborDirectionsFlat),
        ("Test cell neighbors coordinates", testGetCellNeighborsCoordinates),
        ("Test all cell neighbors", testGetCellNeighbors),
        ("Test cell diagonal neighbor", testGetCellDiagonalNeighbor),
        ("Test cell diagonal neighbor coordinates", testGetCellDiagonalNeighborCoordinates),
        ("Test all cell diagonal neighbors coordinates", testGetCellDiagonalNeighborsCoordinates),
        ("Test cell diagonal neighbors", testGetCellDiagonalNeighbors),
        ("Test line between two cells", testLine),
        ("Test invalid line", testInvalidLine),
        ("Test ring coordinates", testRingCoordinates),
        ("Test ring", testRing),
        ("Test filled ring coordinates", testFilledRingCoordinates),
        ("Test filled ring", testFilledRing),
        ("Test initialize grid with custom set of cells", testInitCustomGrid),
        ("Test reachable (coordinates only)", testFindReachableCoordinates),
        ("Test pathfinding", testFindReachable),
        ("Test pathfinding (coordinates only)", testFindPathCoordinates),
        ("Test pathfinding", testFindPath),
        ("Test non existing path", testFindNoPath),
        ("Test calculation of polygon corners", testPolygonCorners),
        ("Test calculation cell pixel coordinates", testPixelCoordinates),
        ("Test get cell for pixel coordinates", testCellAtPixel),
        ("Test grid pixel dimensions", testGridPixelDimensions)
    ]
}
