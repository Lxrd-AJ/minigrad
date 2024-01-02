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
        assert(left.data.count == right.data.count, "Both vectors must be the same length")
        let summed = zip(left.data, right.data).map({ $0 + $1 })

        return Vector(data: summed)
    }

    static func - (left: Vector, right: Vector) -> Vector {
        guard left != .zero else { return right }
        guard right != .zero else { return left }
        assert(left.data.count == right.data.count, "Both vectors must be the same length")
        let difference = zip(left.data, right.data).map({ $0 - $1 })
        return Vector(data: difference)
    }
}