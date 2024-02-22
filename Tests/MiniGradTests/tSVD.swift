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
        let image2D = Matrix<Float>.from(cgImage: image)!
        
        let svd = image2D.svd()
        // TODO: Read in the image matrix as an integer matrix then convert it to a float afterwards
        
//        let randLength = 5
//        let randDiagonals = (0..<randLength).map({ _ in Float.random(in: 0 ... 1) })
//        let m = Matrix<Float>.diagonal(elements: randDiagonals)
//        let svd = m.svd()
        
        print("U: \(svd.U.shape)")
        print("S: \(svd.Sigma.shape)")
        print(svd.Vt.shape)
        
        print(svd.U)
        print(svd.Sigma)
        print(svd.Vt)
        
        // TODO: Reconstruct the original input matrix and verify that they are equal to a very small margin of error
        
//        print(image2D[10,...])
        
        // TODO: The doc says `U` computed by LAPACK contains the left singular vectors stored columnwise
        // I need to check if that is the case and implement some kind of transpose operation
        // TODO: Same for Vt, VT contains the rows of V**T (the right singular
        // vectors, stored rowwise)
        
//        let reconImage2D = image2D.toCGImage()!
//        self.add(reconImage2D, title: "Recon", lifetime: .keepAlways)
    }

}
