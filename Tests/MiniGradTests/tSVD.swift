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
        
        
        // TODO: Reconstruct the original input matrix and verify that they are equal to a very small margin of error
        let T = svd.U * svd.Sigma * svd.Vt
        print(T.shape)
        
        // TODO: The doc says `U` computed by LAPACK contains the left singular vectors stored columnwise
        // I need to check if that is the case and implement some kind of transpose operation
        // TODO: Same for Vt, VT contains the rows of V**T (the right singular
        // vectors, stored rowwise)
        
//        let reconImage2D = image2D.toCGImage()!
//        self.add(reconImage2D, title: "Recon", lifetime: .keepAlways)
    }

}
