/// An object that wraps the underlying data held by a matrix
/// It handles the allocation & de-allocation of the underying memory buffer
class MatrixDataReference <Element: Numeric> {
    var data: UnsafeMutableBufferPointer<Element>
    
    init(data: UnsafeMutableBufferPointer<Element>) {
        self.data = data
    }
    
    deinit {
        self.data.deallocate()
    }
}


public struct Matrix<Element: Numeric> {
    /// The number of rows in the matrix
    public let nrows: UInt

    /// The number of columns in the matrix
    public let ncols: UInt
    
    public var shape: (nrows: UInt, ncols: UInt) {
        return (nrows, ncols)
    }
    
    /// The minimum dimension defined as `min(nrows, ncols)` for use with BLAS  & LAPACK Interop
    var minDimension: UInt {
        return min(nrows, ncols)
    }

    internal var dataRef: MatrixDataReference<Element>
    
    init(nrows: UInt, ncols: UInt, data: MatrixDataReference<Element>) {
        self.nrows = nrows
        self.ncols = ncols
        self.dataRef = data as MatrixDataReference<Element>
    }
    
    public init(data: [[Element]]) {
        assert(data.count > 0, "There has to be more than 1 element in the data")
        self.nrows = UInt(data.count)
        self.ncols = UInt(data.first!.count)
        for (idx, elem) in data.enumerated() {
            assert(elem.count == self.ncols, "Column \(idx) expected to have length \(self.ncols)")
        }
        
        let count = nrows * ncols
        let start = UnsafeMutablePointer<Element>.allocate(capacity: Int(count))
        let buffer = UnsafeMutableBufferPointer(start: start, count: Int(count))
        self.dataRef = MatrixDataReference(data: buffer)
        
        for row in 0..<self.nrows {
            let strideStart = Int(row) * Int(self.ncols)
            let strideEnd = strideStart + Int(self.ncols)
            
            var rowData = data[Int(row)]
            rowData.withUnsafeMutableBufferPointer({ rowDataBufferPtr in
                buffer[strideStart ..< strideEnd] = rowDataBufferPtr[0 ..< Int(self.ncols)]
            })
        }
    }
    
    public static func zeros(nrows: UInt, ncols: UInt) -> Matrix<Element> {
        assert((nrows != 0) || (ncols != 0), "Cannot create matrix with zero rows or columns")
        let count = nrows * ncols
        let start = UnsafeMutablePointer<Element>.allocate(capacity: Int(count))
        let buffer = UnsafeMutableBufferPointer(start: start, count: Int(count))
        buffer.initialize(repeating: 0 as Element)
        
        let dataRef = MatrixDataReference(data: buffer)
        return Matrix(nrows: nrows, ncols: ncols, data: dataRef)
    }
    
    public static func diagonal(elements: [Element]) -> Matrix<Element> {
        let n = UInt(elements.count)
        var mat = Matrix.zeros(nrows: UInt(n), ncols: UInt(n))
        
        for idx in 0 ..< n {
            mat[idx, idx] = elements[Int(idx)]
        }
        
        return mat
    }
}

/// Subscript access
public extension Matrix {
    private func indexIsValid(row: UInt, column: UInt) -> Bool {
        return (row >= 0 && row < nrows) && (column >= 0 && column < ncols)
    }
    
    /// return the element at the specified row & column
    subscript(row: UInt, column: UInt) -> Element {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            let stride = row * self.ncols
            return self.dataRef.data[Int(stride + column)]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            let stride = row * self.ncols
            return self.dataRef.data[Int(stride + column)] = newValue
        }
    }
    
    subscript(row: UInt, column: Range<UInt>) -> Vector<Element> {
        assert(indexIsValid(row: row, column: column.lowerBound), "Index out of range")
        assert(indexIsValid(row: row, column: column.upperBound - 1), "Index out of range")
        let stride = row * self.ncols
        let data = self.dataRef.data[Int(stride + column.lowerBound) ..< Int(stride + column.upperBound)]
        // Copy of the data for now
        let copyOfData: [Element] = Array(data)
        return Vector(data: copyOfData, shape: .row)
    }
    
    subscript(row: UInt, column: ClosedRange<UInt>) -> Vector<Element> {
        assert(indexIsValid(row: row, column: column.lowerBound), "Index out of range")
        assert(indexIsValid(row: row, column: column.upperBound), "Index out of range")
        let stride = row * self.ncols
        let data = self.dataRef.data[Int(stride + column.lowerBound) ... Int(stride + column.upperBound)]
        // Copy of the data for now
        let copyOfData: [Element] = Array(data)
        return Vector(data: copyOfData, shape: .row)
    }
    
    subscript(row: UInt, column: UnboundedRange) -> Vector<Element> {
        assert((row >= 0 && row < nrows), "Index out of range")
        let stride = row * self.ncols
        let data = self.dataRef.data[Int(stride) ... Int(stride + self.ncols - 1)]
        // Copy of the data for now
        let copyOfData: [Element] = Array(data)
        return Vector(data: copyOfData, shape: .row)
    }
}

public extension Matrix {
    func diagonals() -> Vector<Element> {
        assert((ncols > 0 && nrows > 0), "Matrix must not be vector-like")
        let range = 0 ... min(self.ncols, self.nrows) - 1
        
        var elements: [Element] = []
        elements.reserveCapacity(Int(min(self.ncols, self.nrows)))
        
        for idx in range {
            elements.append(self[idx, idx])
        }
        
        return Vector(data: elements, shape: .row)
    }
}

extension Matrix: CustomStringConvertible {
    public var description: String {
        var returnString = String(repeating: " --- ", count: Int(ncols)) + "\n"
        for row in 0 ..< nrows {
            var str = "|"
            for col in 0 ..< ncols {
                str += String(format: "%.2f ", self[row, col] as! CVarArg)
            }
            returnString += str + "|\n"
        }
        
        return returnString + String(repeating: " --- ", count: Int(ncols))
    }
}
