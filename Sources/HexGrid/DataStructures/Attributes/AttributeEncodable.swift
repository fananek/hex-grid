import Foundation

/// A type-erased `Encodable` value.
///
/// The `AttributeEncodable` type forwards encoding responsibilities
/// to an underlying value, hiding its specific underlying type.
///
/// You can encode mixed-type values in dictionaries
/// and other collections that require `Encodable` conformance
/// by declaring their contained type to be `AttributeEncodable`.
public struct AttributeEncodable: Encodable {
    public let value: Any
    
    public init<T>(_ value: T?) {
        self.value = value ?? ()
    }
}

@usableFromInline
protocol _AttributeEncodable {
    var value: Any { get }
    init<T>(_ value: T?)
}

extension AttributeEncodable: _AttributeEncodable {}

// MARK: - Encodable

extension _AttributeEncodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case is NSNull, is Void:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let int8 as Int8:
            try container.encode(int8)
        case let int16 as Int16:
            try container.encode(int16)
        case let int32 as Int32:
            try container.encode(int32)
        case let int64 as Int64:
            try container.encode(int64)
        case let uint as UInt:
            try container.encode(uint)
        case let uint8 as UInt8:
            try container.encode(uint8)
        case let uint16 as UInt16:
            try container.encode(uint16)
        case let uint32 as UInt32:
            try container.encode(uint32)
        case let uint64 as UInt64:
            try container.encode(uint64)
        case let float as Float:
            try container.encode(float)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let date as Date:
            try container.encode(date)
        case let url as URL:
            try container.encode(url)
        case let array as [Any?]:
            try container.encode(array.map { Attribute($0) })
        case let dictionary as [String: Any?]:
            try container.encode(dictionary.mapValues { Attribute($0) })
        default:
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "Attribute value cannot be encoded")
            throw EncodingError.invalidValue(value, context)
        }
    }
}

extension AttributeEncodable: Equatable {
    public static func == (lhs: AttributeEncodable, rhs: AttributeEncodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case is (Void, Void):
            return true
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as [String: AttributeEncodable], rhs as [String: AttributeEncodable]):
            return lhs == rhs
        case let (lhs as [AttributeEncodable], rhs as [AttributeEncodable]):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension AttributeEncodable: CustomStringConvertible {
    public var description: String {
        switch value {
        case is Void:
            return String(describing: nil as Any?)
        case let value as CustomStringConvertible:
            return value.description
        default:
            return String(describing: value)
        }
    }
}

extension AttributeEncodable: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch value {
        case let value as CustomDebugStringConvertible:
            return "AttributeEncodable(\(value.debugDescription))"
        default:
            return "AttributeEncodable(\(description))"
        }
    }
}

extension AttributeEncodable: ExpressibleByNilLiteral {}
extension AttributeEncodable: ExpressibleByBooleanLiteral {}
extension AttributeEncodable: ExpressibleByIntegerLiteral {}
extension AttributeEncodable: ExpressibleByFloatLiteral {}
extension AttributeEncodable: ExpressibleByStringLiteral {}
extension AttributeEncodable: ExpressibleByArrayLiteral {}
extension AttributeEncodable: ExpressibleByDictionaryLiteral {}

extension _AttributeEncodable {
    public init(nilLiteral _: ()) {
        self.init(nil as Any?)
    }
    
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
    public init(floatLiteral value: Double) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public init(arrayLiteral elements: Any...) {
        self.init(elements)
    }
    
    public init(dictionaryLiteral elements: (AnyHashable, Any)...) {
        self.init([AnyHashable: Any](elements, uniquingKeysWith: { first, _ in first }))
    }
}
