//
//  AccelerateBackend.swift
//  MiniGrad ,
//
//  Created by AJ Ibraheem on 07/01/2024.
//  Copyright 2024, Ara Intelligence Limited.
   

import Foundation
import Accelerate

// https://developer.apple.com/documentation/accelerate/1513280-cblas_sdot
@available(macOS 13.3, *)
func blas_vectorDotProduct(left: Vector<Float>, right: Vector<Float>) -> Float {
    return cblas_sdot(Int32(left.data.count), left.data, 1, right.data, 1 )
}

@available(macOS 13.3, *)
func lapack_svd(
    u: UnsafePointer<Matrix<Float>>,
    sigma: UnsafeMutableBufferPointer<Float>,
    vt: inout Matrix<Float>,
    numRows: Int, numCols: Int,
    data: UnsafeMutableBufferPointer<Float>
) -> Int {
    var JOBU = Int8("V".utf8.first!) // Flag to compute all left singular vectors, see `RANGE`
    var JOBVT = Int8("V".utf8.first!) // Flag to compute all right singular vectors, see `RANGE`
    var RANGE = Int8("A".utf8.first!) // Flag to compute all singular values
    // The `VL` and `VT` parameters are ignored by `sgesvdx_` when the
    // the range is either `A` or `I`.
    var vl = Float(), vu = Float()
    
    var numRows = __LAPACK_int(numRows)
    var numCols = __LAPACK_int(numCols)
    var lda = __LAPACK_int(numRows) // The leading dimension of the array A.  LDA >= max(1,numRows)
    // The `IL` and `IU` parameters specify the first and last indices
    // of the singular values that `sgesvdx_` computes.
    // As this method computes all singlular values with `RANGE='A'`, then these values are ignored.
    var il = __LAPACK_int(-1) // The first index.
    var iu = __LAPACK_int(-1) // The last index.
    // This would be populated by `sgesvdx_` on exit, so use 0 as a placeholder
    var numSingularValues = __LAPACK_int(0)
    
    // Create the workspace:
    // See https://stackoverflow.com/a/46699543/2468129 for more information about WORK arrays for LAPACK
    // BLOT: In LAPACK, the provision of a WORK array is required because it serves as a
    // pre-allocated workspace for intermediate calculations during the execution of LAPACK routines.
    //
    // LAPACK aims for memory efficiency and performance by avoiding dynamic memory allocation during
    // computation.
    // By having the user provide a workspace, LAPACK routines minimize memory usage and can be more
    // easily reused in various applications. The size and purpose of the workspace depend on the specific
    // LAPACK routine and problem size. Allocating the workspace before calling the LAPACK routine and
    // appropriately managing it enhances efficiency and facilitates thread-safe usage in multi-threaded
    // environments.
    //
    // Use `sgesvdx_` to calculate the optimal size of the WORK array
    //    If LWORK = -1, then a workspace query is assumed; the routine
    //    only calculates the optimal size of the WORK array, returns
    //    this value as the first entry of the WORK array, and no error
    //    message related to LWORK is issued by XERBLA.
    let LWORK = __LAPACK_int(-1)
    // Create a copy of the `A` matrix, per the documentation, `sgesvdx` destroys the contents of the
    // `A` matrix on exit.
    let aCopy = UnsafeMutableBufferPointer<Float>.allocate(capacity: data.count)
    _ = aCopy.initialize(from: data)
    defer {
        aCopy.deallocate()
    }
    // Compute the dimension of the workspace needed for LAPACK
//    sgesvdx_(&JOBU, &JOBVT, &RANGE, &numRows, &numCols, aCopy.baseAddress, &lda,
//             &vl, &vu, &il, &iu, &numSingularValues, <#T##s: UnsafeMutablePointer<Float>?##UnsafeMutablePointer<Float>?#>, <#T##u: UnsafeMutablePointer<Float>?##UnsafeMutablePointer<Float>?#>, <#T##ldu: UnsafePointer<__LAPACK_int>##UnsafePointer<__LAPACK_int>#>, <#T##vt: UnsafeMutablePointer<Float>?##UnsafeMutablePointer<Float>?#>, <#T##ldvt: UnsafePointer<__LAPACK_int>##UnsafePointer<__LAPACK_int>#>, <#T##work: UnsafeMutablePointer<Float>##UnsafeMutablePointer<Float>#>, <#T##lwork: UnsafePointer<__LAPACK_int>##UnsafePointer<__LAPACK_int>#>, <#T##iwork: UnsafeMutablePointer<__LAPACK_int>?##UnsafeMutablePointer<__LAPACK_int>?#>, <#T##info: UnsafeMutablePointer<__LAPACK_int>##UnsafeMutablePointer<__LAPACK_int>#>)
    
    return Int(numSingularValues)
}
