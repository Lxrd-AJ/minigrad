//
//  tSVD.swift
//   - ,  
//
//  Created by AJ Ibraheem on 12/02/2024.
//  Copyright 2024, Ara Intelligence Limited.
   

import Testing
import MiniGrad

struct SVDTests: TestCaseWithResources, TestWithBatteries {

    @available(macOS 13.3, *)
    @Test
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
        let T1 = svd.U * svd.Sigma
        let T2 = T1 * svd.Vt
        let T = T2
        print(T.shape)
        
        // TODO: Continue
//        verifyEqual(lhs: floatImage, rhs: T)
    }

}
