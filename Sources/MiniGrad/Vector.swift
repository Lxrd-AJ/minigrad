struct Vector<Element: Numeric> {
    let data: [Element]

    init(data: [Element]) {
        self.data = data
    }
}

extension Vector: AdditiveArithmetic {
    static var zero: Vector<Element> { return Vector(data: [0]) }

    static func + (left: Vector, right: Vector) -> Vector {
        // TODO: Use Macros, https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/ 
        // to reduce code duplication
        guard left != .zero else { return right }
        guard right != .zero else { return left }
        precondition(left.data.count == right.data.count, "Both vectors must be the same length")
        let summed = zip(left.data, right.data).map({ $0 + $1 })

        return Vector(data: summed)
    }

    static func - (left: Vector, right: Vector) -> Vector {
        guard left != .zero else { return right }
        guard right != .zero else { return left }
        precondition(left.data.count == right.data.count, "Both vectors must be the same length")
        let difference = zip(left.data, right.data).map({ $0 - $1 })
        return Vector(data: difference)
    }

    /// Vector + Scalar addition
    static func + (left: Vector, right: Element) -> Vector {
        return addition(scalar: right, vector: left)
    }
    
    static func + (left: Element, right: Vector) -> Vector {
        return addition(scalar: left, vector: right)
    }
    
    private static func addition(scalar: Element, vector: Vector) -> Vector {
        guard vector != .zero else { return Vector(data: [scalar]) }
        let added = vector.data.map({ $0 + scalar })
        return Vector(data: added)
    }
}

// Example showing specific
// Can use `Accelerate` for optimisations on specific types
//extension Vector<Int> {
//    func sdd() {
//        let x = self.data
//    }
//}

extension Vector {
    /// Vector-scalar multiplication
    static func * (left: Vector, right: Element) -> Vector {
        return multiplication(scalar: right, vector: left)
    }
    
    static func * (left: Element, right: Vector) -> Vector {
        return multiplication(scalar: left, vector: right)
    }
    
    private static func multiplication(scalar: Element, vector: Vector) -> Vector {
        return Vector(data: vector.data.map({ $0 * scalar }))
    }
}
