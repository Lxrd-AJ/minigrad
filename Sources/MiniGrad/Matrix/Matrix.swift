//
//  Matrix.swift
//
//  Copyright 2024.

public class Matrix<Element: Numeric> {
    /// The number of rows in the matrix
    public var nrows: Int {
        return self.buffer.header.rows
    }

    /// The number of columns in the matrix
    public var ncols: Int {
        return self.buffer.header.cols
    }
    
    public var shape: (nrows: Int, ncols: Int) {
        return (nrows, ncols)
    }
    
    /// The minimum dimension defined as `min(nrows, ncols)` for use with BLAS  & LAPACK Interop
    var minDimension: Int {
        return min(nrows, ncols)
    }

    internal var buffer: MatrixBuffer<Element>
    
    private func ensureUniqueBuffer() {
        if !isKnownUniquelyReferenced(&self.buffer) {
            self.buffer = self.buffer.clone()
        }
    }
    
    public init(rows: Int, cols: Int, initialValue: Element) {
        self.buffer = MatrixBuffer.create(size: (rows, cols), initial: initialValue)
    }
    
    public init(data: [[Element]]) {
        precondition(data.count > 0, "There has to be more than 1 element in the data")
        let nrows = data.count
        let ncols = data.first!.count
        for (idx, elem) in data.enumerated() {
            assert(elem.count == ncols, "Column \(idx) expected to have length \(ncols)")
        }

        self.buffer = MatrixBuffer.create(size: (nrows, ncols), initial: 0 as Element)
        let mutableBufferPtr = self.buffer.mutableBufferPointer()
        
        for row in 0..<self.nrows {
            let strideStart = row * self.ncols
            let strideEnd = strideStart + self.ncols
            
            var rowData = data[row]
            rowData.withUnsafeMutableBufferPointer({ rowDataBufferPtr in
                mutableBufferPtr[strideStart ..< strideEnd] = rowDataBufferPtr[0 ..< self.ncols]
            })
        }
    }
    
    init(existingBuffer: MatrixBuffer<Element>) {
        self.buffer = existingBuffer
    }
}

/// Subscript access
public extension Matrix {
    private func indexIsValid(row: Int, column: Int) -> Bool {
        return (row >= 0 && row < nrows) && (column >= 0 && column < ncols)
    }
    
    /// return the element at the specified row & column
    /// row & column subscript access starts from 0 to `self.nrows-1`
    subscript(row: Int, column: Int) -> Element {
        get {
            precondition(indexIsValid(row: row, column: column), "Index out of range")
            let stride = row * self.ncols
            return self.buffer[stride + column] 
        }
        set {
            precondition(indexIsValid(row: row, column: column), "Index out of range")
            self.ensureUniqueBuffer()
            let stride = row * self.ncols
            self.buffer[stride + column] = newValue
        }
    }
    
    subscript(row: Int, columnRange: Range<Int>) -> Vector<Element> {
        get {
            precondition(indexIsValid(row: row, column: columnRange.lowerBound), "Index out of range")
            precondition(indexIsValid(row: row, column: columnRange.upperBound - 1), "Index out of range")
            
            let stride = (row * self.ncols) + columnRange.lowerBound
            return self.buffer.withUnsafeMutablePointerToElements({ pointer in
                let data: [Element] = (0..<columnRange.count).map({ i in pointer[stride + i] })
                return Vector(data: data, shape: .row)
            })
        }
        
        set {
            precondition(indexIsValid(row: row, column: columnRange.lowerBound) && indexIsValid(row: row, column: columnRange.upperBound - 1), "Index out of range")
            precondition(newValue.length == columnRange.count, "Mismatched element count")
            
            ensureUniqueBuffer()
            
            buffer.withUnsafeMutablePointerToElements { pointer in
                let stride = (row * self.ncols) + columnRange.lowerBound
                for i in 0..<columnRange.count {
                    pointer[stride + i] = newValue[i]
                }
            }
        }
    }
    
//    subscript(row: UInt, column: ClosedRange<UInt>) -> Vector<Element> {
//        assert(indexIsValid(row: row, column: column.lowerBound), "Index out of range")
//        assert(indexIsValid(row: row, column: column.upperBound), "Index out of range")
//        let stride = row * self.ncols
//        let data = self.dataRef.data[Int(stride + column.lowerBound) ... Int(stride + column.upperBound)]
//        // Copy of the data for now
//        let copyOfData: [Element] = Array(data)
//        return Vector(data: copyOfData, shape: .row)
//    }
//    
//    subscript(row: UInt, column: UnboundedRange) -> Vector<Element> {
//        assert((row >= 0 && row < nrows), "Index out of range")
//        let stride = row * self.ncols
//        let data = self.dataRef.data[Int(stride) ... Int(stride + self.ncols - 1)]
//        // Copy of the data for now
//        let copyOfData: [Element] = Array(data)
//        return Vector(data: copyOfData, shape: .row)
//    }
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
