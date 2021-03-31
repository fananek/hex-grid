import XCTest
@testable import HexGrid

class AttributeCodableTests: XCTestCase {
    
    /// test JSON Encoding
    func testJSONEncoding() throws {
        let dictionary: [String: Attribute] = [
            "boolean": true,
            "integer": 10,
            "double": 8.23423,
            "string": "string value",
            "array": [0, 1, 2],
            "nested": [
                "first": "fisrt value",
                "second": "second value",
                "third": "third value"
            ],
        ]

        let encoder = JSONEncoder()

        let json = try encoder.encode(dictionary)
        let encodedJSONObject = try JSONSerialization.jsonObject(with: json, options: []) as! NSDictionary
        let expected = """
        {
            "boolean": true,
            "integer": 10,
            "double": 8.23423,
            "string": "string value",
            "array": [0, 1, 2],
            "nested": {
                "first": "fisrt value",
                "second": "second value",
                "third": "third value"
            }
        }
        """.data(using: .utf8)!
        let expectedJSONObject = try JSONSerialization.jsonObject(with: expected, options: []) as! NSDictionary
        
        XCTAssertEqual(encodedJSONObject, expectedJSONObject)
    }
    
    /// test JSON Decoding
    func testJSONDecoding() throws {
        let json = """
        {
            "boolean": true,
            "integer": 10,
            "double": 8.23423,
            "string": "string value",
            "array": [0, 1, 2],
            "nested": {
                "first": "fisrt value",
                "second": "second value",
                "third": "third value"
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let dictionary = try decoder.decode([String: Attribute].self, from: json)
        
        XCTAssertEqual(dictionary["boolean"]?.value as! Bool, true)
        XCTAssertEqual(dictionary["integer"]?.value as! Int, 10)
        XCTAssertEqual(dictionary["double"]?.value as! Double, 8.23423, accuracy: 0.001)
        XCTAssertEqual(dictionary["string"]?.value as! String, "string value")
        XCTAssertEqual(dictionary["array"]?.value as! [Int], [0, 1, 2])
        XCTAssertEqual(dictionary["nested"]?.value as! [String: String],
                       ["first": "fisrt value",
                        "second": "second value",
                        "third": "third value"])
    }
    
    static var allTests = [
        ("Test JSON Encoding", testJSONEncoding),
        ("Test JSON Decoding", testJSONDecoding)
    ]
}

