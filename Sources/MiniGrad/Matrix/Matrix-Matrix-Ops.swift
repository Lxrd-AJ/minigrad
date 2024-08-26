import Foundation
import Accelerate

extension Matrix<Float> {
    
    @available(macOS 13.3, *)
    public static func * (A: Matrix, B: Matrix) -> Matrix {
        // Either use `vdsp_mmul` https://developer.apple.com/documentation/accelerate/1449984-vdsp_mmul
        // or BLAS `sgemm` https://netlib.org/lapack/explore-html/dd/d09/group__gemm_ga8cad871c590600454d22564eff4fed6b.html#ga8cad871c590600454d22564eff4fed6b
        assert(A.ncols == B.nrows, "Left columns must match right rows")
        let C = Matrix<Float>.zeros(nrows: A.nrows, ncols: B.ncols)
        
        // It seems LAPACK's Leading dimension format can be confusing,
        // see https://stackoverflow.com/questions/34698550/understanding-lapack-row-major-and-lapack-col-major-with-lda
        
        cblas_sgemm(
            CblasRowMajor, // Order
            CblasNoTrans, // TransA
            CblasNoTrans, // TransB
            __LAPACK_int(A.nrows), // M: Number of rows in matrices A and C.
            __LAPACK_int(B.ncols), // N: Number of columns in matrices B and C.
            __LAPACK_int(A.ncols), // K: Number of columns in matrix A; number of rows in matrix B.
            1.0, // alpha: Scaling factor for the product of matrices A and B.
            A.buffer.pointer(), // Matrix A.
            __LAPACK_int(A.ncols), // lda: For a row-major matrix, the leading dimension is the ncols.
            B.buffer.pointer(), // Matrix B.
            __LAPACK_int(B.ncols), // ldb: For a row-major matrix, the leading dimension is the ncols.
            0.0, // beta: Scaling factor for matrix C.
            C.buffer.mutablePointer(), // Matrix C.
            __LAPACK_int(C.ncols) // ldc: For a row-major matrix, the leading dimension is the ncols.
        )
        
        return C
    }
}
