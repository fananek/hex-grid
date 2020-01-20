import XCTest
@testable import HexGrid

private struct Message: Equatable, Comparable {
    let text: String
    let priority: Int
}

private func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.text == rhs.text
}


private func < (m1: Message, m2: Message) -> Bool {
    return m1.priority < m2.priority
}

class PriorityQueueTests: XCTestCase {
    
    func testEmpty() {
        var queue = PriorityQueue<Message>(sort: <)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertNil(queue.peek())
        XCTAssertNil(queue.dequeue())
    }
    
    func testOneElement() {
        var queue = PriorityQueue<Message>(sort: <)
        let message = Message(text: "hello", priority: 100)
        queue.enqueue(message)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.peek()!.priority, 100)
        XCTAssertEqual(queue.index(of: message), 0)
        
        let result = queue.dequeue()
        XCTAssertEqual(result!.priority, 100)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertNil(queue.peek())
    }
    
    func testTwoElementsInOrder() {
        var queue = PriorityQueue<Message>(sort: <)
        let messageHello = Message(text: "hello", priority: 100)
        let messageWorld = Message(text: "world", priority: 50)
        let messageWorld2 = Message(text: "world", priority: 200)
        queue.enqueue(messageHello)
        queue.enqueue(messageWorld)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 2)
        XCTAssertEqual(queue.peek()!.priority, 50)
        
        queue.changePriority(index: queue.index(of: messageWorld)!, value: messageWorld2)
        
        let result1 = queue.dequeue()
        XCTAssertEqual(result1!.priority, 100)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.peek()!.priority, 200)
        
        let result2 = queue.dequeue()
        XCTAssertEqual(result2!.priority, 200)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertNil(queue.peek())
    }
    
    func testTwoElementsOutOfOrder() {
        var queue = PriorityQueue<Message>(sort: <)
        
        queue.enqueue(Message(text: "world", priority: 200))
        queue.enqueue(Message(text: "hello", priority: 100))
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 2)
        XCTAssertEqual(queue.peek()!.priority, 100)
        
        let result1 = queue.dequeue()
        XCTAssertEqual(result1!.priority, 100)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.peek()!.priority, 200)
        
        let result2 = queue.dequeue()
        XCTAssertEqual(result2!.priority, 200)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertNil(queue.peek())
    }
    
    func testCompareNodes() throws {
        let coords = try CubeCoordinates(x: 0, y: 0, z: 0)
        let nodeA = Node(coordinates: coords, parent: nil, costScore: 0.0, heuristicScore: 0.0)
        let nodeB = nodeA
        XCTAssertEqual(nodeA, nodeB)
    }
    
    static var allTests = [
        ("Test empty - priority queue", testEmpty),
        ("Test one element - priority queue", testOneElement),
        ("Test two elements in order - priority queue", testTwoElementsInOrder),
        ("Test teo element out of order - priority queue", testTwoElementsOutOfOrder),
        ("Test == func for nodes", testCompareNodes)
    ]
}
