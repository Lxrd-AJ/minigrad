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
        
        print("A: \(image2D.shape)")
        print("U: \(svd.U.shape)")
        print("S: \(svd.Sigma.shape)")
        print(svd.Vt.shape)
        
        let reconImage2D = image2D.toCGImage()!
        self.add(reconImage2D, title: "Recon", lifetime: .keepAlways)
    }

}
