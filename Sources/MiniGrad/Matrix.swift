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
    public let nrows: Int

    /// The number of columns in the matrix
    public let ncols: Int
    
    public var shape: (nrows: Int, ncols: Int) {
        return (nrows, ncols)
    }
    
    /// The minimum dimension defined as `min(nrows, ncols)` for use with BLAS  & LAPACK Interop
    var minDimension: Int {
        return min(nrows, ncols)
    }

    internal var dataRef: MatrixDataReference<Element>
    
    fileprivate init(nrows: Int, ncols: Int, data: MatrixDataReference<Element>) {
        self.nrows = nrows
        self.ncols = ncols
        self.dataRef = data as MatrixDataReference<Element>
    }
    
    public static func zeros(nrows: Int, ncols: Int) -> Matrix<Element> {
        assert((nrows != 0) || (ncols != 0), "Cannot create matrix with zero rows or columns")
        let count = nrows * ncols
        let start = UnsafeMutablePointer<Element>.allocate(capacity: count)
        let buffer = UnsafeMutableBufferPointer(start: start, count: count)
        buffer.initialize(repeating: 0 as Element)
        
        let dataRef = MatrixDataReference(data: buffer)
        return Matrix(nrows: nrows, ncols: ncols, data: dataRef)
    }
    
    public static func diagonal(elements: [Element]) -> Matrix<Element> {
        let n = elements.count
        var mat = Matrix.zeros(nrows: n, ncols: n)
        
        for idx in 0 ..< n {
            mat[idx, idx] = elements[idx]
        }
        
        return mat
    }
}

/// Subscript access
public extension Matrix {
    private func indexIsValid(row: Int, column: Int) -> Bool {
        return (row >= 0 && row < nrows) && (column >= 0 && column < ncols)
    }
    
    /// return the element at the specified row & column
    subscript(row: Int, column: Int) -> Element {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            let stride = row * self.ncols
            return self.dataRef.data[stride + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            let stride = row * self.ncols
            return self.dataRef.data[stride + column] = newValue
        }
    }
    
    subscript(row: Int, column: Range<Int>) -> Vector<Element> {
        assert(indexIsValid(row: row, column: column.lowerBound), "Index out of range")
        assert(indexIsValid(row: row, column: column.upperBound - 1), "Index out of range")
        let stride = row * self.ncols
        let data = self.dataRef.data[(stride + column.lowerBound) ..< (stride + column.upperBound)]
        // Copy of the data for now
        let copyOfData: [Element] = Array(data)
        return Vector(data: copyOfData, shape: .row)
    }
    
    subscript(row: Int, column: ClosedRange<Int>) -> Vector<Element> {
        assert(indexIsValid(row: row, column: column.lowerBound), "Index out of range")
        assert(indexIsValid(row: row, column: column.upperBound), "Index out of range")
        let stride = row * self.ncols
        let data = self.dataRef.data[(stride + column.lowerBound) ... (stride + column.upperBound)]
        // Copy of the data for now
        let copyOfData: [Element] = Array(data)
        return Vector(data: copyOfData, shape: .row)
    }
    
    subscript(row: Int, column: UnboundedRange) -> Vector<Element> {
        assert((row >= 0 && row < nrows), "Index out of range")
        let stride = row * self.ncols
        let data = self.dataRef.data[(stride) ... (stride + self.ncols - 1)]
        // Copy of the data for now
        let copyOfData: [Element] = Array(data)
        return Vector(data: copyOfData, shape: .row)
    }
}

extension Matrix: CustomStringConvertible {
    public var description: String {
        var returnString = String(repeating: " --- ", count: ncols) + "\n"
        for row in 0 ..< nrows {
            var str = "|"
            for col in 0 ..< ncols {
                str += String(format: "%.2f ", self[row, col] as! CVarArg)
            }
            returnString += str + "|\n"
        }
        
        return returnString + String(repeating: " --- ", count: ncols)
    }
}
