import XCTest

import HexGridTests

var tests = [XCTestCaseEntry]()
tests += HexGridTests.allTests()
tests += GridGeneratorTests.allTests()
tests += ConvertorTests.allTests()
tests += MathTests.allTests()
XCTMain(tests)
