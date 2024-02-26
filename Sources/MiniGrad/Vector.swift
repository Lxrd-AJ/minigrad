infix operator .*

public enum VectorShape {
    case row
    case column
}

public struct Vector<Element: Numeric> {
    internal var data: [Element]
    private var shape: VectorShape
    
    public var length: Int {
        return data.count
    }

    public init(data: [Element], shape: VectorShape = .column) {
        self.data = data
        self.shape = shape
    }
    
    func transpose() -> Vector {
        let newShape: VectorShape = (self.shape == .column) ? .row : .column
        return Vector(data: self.data, shape: newShape)
    }
}

public extension Vector {
    subscript(index: Int) -> Element {
        get {
            return self.data[index]
        }
        set {
            self.data[index] = newValue
        }
    }
}

extension Vector: AdditiveArithmetic {
    public static var zero: Vector<Element> { return Vector(data: [0]) }

    public static func + (left: Vector, right: Vector) -> Vector {
        // TODO: Use Macros, https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/
        // to reduce code duplication
        guard left != .zero else { return right }
        guard right != .zero else { return left }
        precondition(left.data.count == right.data.count, "Both vectors must be the same length")
        let summed = zip(left.data, right.data).map({ $0 + $1 })

        return Vector(data: summed)
    }

    public static func - (left: Vector, right: Vector) -> Vector {
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

#if canImport(Accelerate)
extension Vector<Float> {
    /// When `Element` is a `Float` and the `Accelerate` library is available.
    /// An optimised version of a single precision vector dot product is computed using `BLAS`
    @available(macOS 13.3, *)
    func dot(_ other: Vector<Float>) -> Float {
        return blas_vectorDotProduct(left: self, right: other)
    }
}
#endif
