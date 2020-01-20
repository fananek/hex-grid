import XCTest
@testable import HexGrid

class CodableTests: XCTestCase {
    
    func testEncode() {
        do {
            let grid = HexGrid(shape: GridShape.hexagon(1) )
            let encoder = JSONEncoder()
            let data = try encoder.encode(grid)

//            if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
//                print(JSONString)
//            }
            
            let decoder = JSONDecoder()
            let secondGrid = try decoder.decode(HexGrid.self, from: data)
            XCTAssertEqual(secondGrid.cells, grid.cells)
            
        } catch {
            print("An error occured during JSON endocing/decoding: \(error)")
        }
    }
    
    static var allTests = [
        ("Test encode grid to JSON", testEncode)
    ]
}
