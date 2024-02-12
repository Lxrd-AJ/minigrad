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

public extension Matrix<Float> {
    
    /// Compute the Singular Value Decomposition (SVD) of the matrix.
    ///
    /// The SVD is a matrix factorisation that decomposes the matrix `A` (nxm) into the factor matrices
    ///     * _U_: (nxn) left singular vectors
    ///     * _Σ_: (nxm) singular values
    ///     * V^T: (mxm) right singular vectors
    func svd() -> (U: Matrix, Sigma: Matrix, Vt: Matrix) {
        var U = Matrix.zeros(nrows: self.nrows, ncols: self.nrows)
        var sigma = Matrix.zeros(nrows: self.nrows, ncols: self.ncols)
        var vt = Matrix.zeros(nrows: self.ncols, ncols: self.ncols)
        
        
        #if canImport(Accelerate)
        lapack_svd(u: &U, sigma: &sigma, vt: &vt)
        return (U, sigma, vt)
        #else
        fatalError("SVD not implemented for non-apple platforms")
        #endif
    }
}
