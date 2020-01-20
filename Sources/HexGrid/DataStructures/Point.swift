public struct Point: Codable {
    var x: Double
    var y: Double

    public init (x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

extension Point: Equatable {
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x.isEqual(to: rhs.x) && lhs.y.isEqual(to: rhs.y)
    }
}
