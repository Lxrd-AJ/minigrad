//
//  File.swift
//   - ,  
//
//  Created by AJ Ibraheem on 10/02/2024.
//  Copyright 2024, Ara Intelligence Limited.
   

import Foundation
#if canImport(Accelerate)
import Accelerate
#endif

@available(macOS 13.3, *)
public extension Matrix<Float> {
    
    /// Compute the Singular Value Decomposition (SVD) of the matrix.
    ///
    /// The SVD is a matrix factorisation that decomposes the matrix `A` (nxm) into the factor matrices
    ///     * _U_: (nxn) left singular vectors
    ///     * _Σ_: (nxm) singular values
    ///     * $V^T$: (mxm) right singular vectors
    func svd() -> (U: Matrix, Sigma: Matrix, Vt: Matrix) {
        let numSingularValues = min(self.nrows, self.ncols)
        let start = UnsafeMutablePointer<Float>.allocate(capacity: numSingularValues)
        let sigmaBuffer = UnsafeMutableBufferPointer(start: start, count: numSingularValues)
        sigmaBuffer.initialize(repeating: 0 as Float)
        
        var U = Matrix.zeros(nrows: self.nrows, ncols: self.nrows)
        var sigma = Matrix.zeros(nrows: self.nrows, ncols: self.ncols)
        var vt = Matrix.zeros(nrows: self.ncols, ncols: self.ncols)
        
        #if canImport(Accelerate)
        let numSingularFound = lapack_svd(u: &U, sigma: sigmaBuffer, vt: &vt, numRows: self.nrows, numCols: self.ncols, data: self.dataRef.data)
        
        // Populate the diagonals of `sigma` with values from `sigmaBuffer`
        // If no singular values were found, then `numSingularFound` would be `0` and sigma would be as is
        for idx in 0..<numSingularFound {
            sigma[idx, idx] = sigmaBuffer[idx]
        }
        
        return (U, sigma, vt)
        #else
        fatalError("SVD not implemented for non-apple platforms")
        #endif
    }
}
