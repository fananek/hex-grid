/*
 Copyright (c) 2016 Matthijs Hollemans and contributors
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 
 Priority Queue, a queue where the most "important" items are at the front of
 the queue.
 
 The heap is a natural data structure for a priority queue, so this object
 simply wraps the Heap struct.
 
 All operations are O(lg n).
 
 Just like a heap can be a max-heap or min-heap, the queue can be a max-priority
 queue (largest element first) or a min-priority queue (smallest element first).
 */
internal struct PriorityQueue<T> {
    fileprivate var heap: Heap<T>
    
    /*
     To create a max-priority queue, supply a > sort function. For a min-priority
     queue, use <.
     */
    init(sort: @escaping (T, T) -> Bool) {
        heap = Heap(sort: sort)
    }
    
    var isEmpty: Bool {
        return heap.isEmpty
    }
    
    var count: Int {
        return heap.count
    }
    
    func peek() -> T? {
        return heap.peek()
    }
    
    mutating func enqueue(_ element: T) {
        heap.insert(element)
    }

    mutating func dequeue() -> T? {
        return heap.remove()
    }

    /*
     Allows you to change the priority of an element. In a max-priority queue,
     the new priority should be larger than the old one; in a min-priority queue
     it should be smaller.
     */
    mutating func changePriority(index ind: Int, value: T) {
        return heap.replace(index: ind, value: value)
    }
}

extension PriorityQueue where T: Equatable {
    func index(of element: T) -> Int? {
        return heap.index(of: element)
    }
}
