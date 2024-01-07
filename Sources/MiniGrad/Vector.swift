infix operator .*

enum VectorShape {
    case row
    case column
}

struct Vector<Element: Numeric> {
    let data: [Element]
    private var shape: VectorShape

    init(data: [Element], shape: VectorShape = .column) {
        self.data = data
        self.shape = shape
    }
    
    func transpose() -> Vector {
        let newShape: VectorShape = (self.shape == .column) ? .row : .column
        return Vector(data: self.data, shape: newShape)
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
    
    // MARK: - Vector dot product
    static func .* (left: Vector, right: Vector) -> Vector {
        precondition(left.data.count == right.data.count, "Vectors must be the same length for element-wise product")
        let product = zip(left.data, right.data).map({ $0 * $1 })
        return Vector(data: product)
    }
    
    /// NB: This vector product is not accurate, or rather is accurate probably up to 0.001 
    func dot(_ other: Vector) -> Element {
        precondition(self.shape != other.shape, "Vector shapes must not be the same")
        precondition(self.shape == .row, "Outer product not supported. `x` must be a row vector in `x.dot(y)`")
        
        let elementWiseProduct = self .* other
        return elementWiseProduct.data.reduce(0, +)
    }
}
