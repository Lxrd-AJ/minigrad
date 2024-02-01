/// An object that wraps the underlying data held by a matrix
/// It handles the allocation & de-allocation of the underying memory buffer
private class MatrixDataReference <Element: Numeric> {
    var data: UnsafeMutableBufferPointer<Element>
    
    init(data: UnsafeMutableBufferPointer<Element>) {
        self.data = data
    }
    
    deinit {
        self.data.deallocate()
    }
}


struct Matrix<Element: Numeric> {
    /// The number of rows in the matrix
    let nrows: Int

    /// The number of columns in the matrix
    let ncols: Int

    private var data: MatrixDataReference<Element>
    
    fileprivate init(nrows: Int, ncols: Int, data: MatrixDataReference<Element>) {
        self.nrows = nrows
        self.ncols = ncols
        self.data = data as MatrixDataReference<Element>
    }
    
    static func zeros(nrows: Int, ncols: Int) -> Matrix<Element> {
        let count = nrows * ncols
        let start = UnsafeMutablePointer<Element>.allocate(capacity: count)
        let buffer = UnsafeMutableBufferPointer(start: start, count: count)
        buffer.initialize(repeating: 0)
        
        let dataRef = MatrixDataReference(data: buffer)
        return Matrix(nrows: nrows, ncols: ncols, data: dataRef)
    }
}
