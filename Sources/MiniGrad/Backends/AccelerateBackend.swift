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
