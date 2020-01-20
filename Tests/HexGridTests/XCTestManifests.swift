import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HexGridTests.allTests),
        testCase(GridGeneratorTests.allTests),
        testCase(ConvertorTests.allTests),
        testCase(CoordinatesTests.allTests),
        testCase(MathTests.allTests),
        testCase(CellTests.allTests),
        testCase(PriorityQueueTests.allTests),
        testCase(HeapTests.allTests),
        testCase(CodableTests.allTests)
    ]
}
#endif
