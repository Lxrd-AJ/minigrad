//
//  tSVD.swift
//   - ,  
//
//  Created by AJ Ibraheem on 12/02/2024.
//  Copyright 2024, Ara Intelligence Limited.
   

import XCTest
import MiniGrad

@available(macOS 13.3, *)
final class tSVD: TestCase {

    func testSVDOnAnImage() throws {
        let image = self.loadImage(named: "veles", ext: "jpeg")
        let image2D = Matrix<UInt8>.from(cgImage: image)!
        let floatImage = image2D.toFloat()
        
        print("Original matrix shape: \(floatImage.shape)")
        
        let svd = floatImage.svd()
        
        print("U: \(svd.U.shape)")
        print("S: \(svd.Sigma.shape)")
        print("Vt: \(svd.Vt.shape)")
        
        
        // Reconstruct the original input matrix
        let T = svd.U * svd.Sigma * svd.Vt
        print(T.shape)
        
        // TODO: and verify that they are equal to a very small margin of error
    }

}
