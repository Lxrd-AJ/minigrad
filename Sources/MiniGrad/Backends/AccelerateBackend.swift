//
//  File.swift
//   - ,  
//
//  Created by AJ Ibraheem on 07/01/2024.
//  Copyright 2024, Ara Intelligence Limited.
   

import Foundation
import Accelerate

// https://developer.apple.com/documentation/accelerate/1513280-cblas_sdot
func blas_vectorDotProduct(left: Vector<Float>, right: Vector<Float>) -> Float {
    return cblas_sdot(Int32(left.data.count), left.data, 1, right.data, 1 )
}

func lapack_svd(u: UnsafePointer<Matrix<Float>>, sigma: inout Matrix<Float>, vt: inout Matrix<Float>) {
    let JOBU = Int8("V".utf8.first!) // Flag to compute all left singular vectors, see `RANGE`
    let JOBVT = Int8("V".utf8.first!) // Flag to compute all right singular vectors, see `RANGE`
    let RANGE = Int8("A".utf8.first!) // Flag to compute all singular values
    
}
