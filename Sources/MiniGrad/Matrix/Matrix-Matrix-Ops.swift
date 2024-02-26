//
//  File.swift
//   - ,  
//
//  Created by AJ Ibraheem on 26/02/2024.
//  Copyright 2024, Ara Intelligence Limited.
   

import Foundation
import Accelerate

extension Matrix<Float> {
    
    @available(macOS 13.3, *)
    public static func * (lhs: Matrix, rhs: Matrix) -> Matrix {
        // Either use `vdsp_mmul` https://developer.apple.com/documentation/accelerate/1449984-vdsp_mmul
        // or BLAS `sgemm`
        assert(lhs.ncols == rhs.nrows, "Left columns must match right rows")
        let result = Matrix.zeros(nrows: lhs.nrows, ncols: rhs.ncols)
        
        cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                    __LAPACK_int(lhs.nrows), __LAPACK_int(rhs.ncols), __LAPACK_int(lhs.ncols), 1.0,
                    lhs.dataRef.data.baseAddress, __LAPACK_int(lhs.nrows),
                    rhs.dataRef.data.baseAddress, __LAPACK_int(rhs.nrows), 0.0,
                    result.dataRef.data.baseAddress, __LAPACK_int(result.nrows))
        
        return result
    }
}
