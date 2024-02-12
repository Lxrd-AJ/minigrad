//
//  tMatrix.swift
//
//  Created by AJ Ibraheem on 01/02/2024.


import XCTest
//@testable import MiniGrad
import MiniGrad

final class tMatrix: TestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMatrixZeros() throws {
        let randLength = Int.random(in: 1 ... 1_000)
        print("Verify matrix with length \(randLength)")
        let m = Matrix<Double>.zeros(nrows: randLength, ncols: randLength)
        for row in 0 ..< randLength {
            for col in 0 ..< randLength {
                XCTAssertEqual(0, m[row, col])
            }
        }
    }
    
    func testMatrixDiagonals() throws {
        let randLength = Int.random(in: 1 ... 10)
        let randDiagonals = (0..<randLength).map({ _ in Float.random(in: 0 ... 1) })
        let m = Matrix<Float>.diagonal(elements: randDiagonals)
        print(m)
        for idx in 0 ..< randLength {
            XCTAssertEqual(randDiagonals[idx], m[idx, idx], accuracy: 1e-10)
        }
    }
    
    func testMatrixVectorSlice() throws {
        let randLength = Int.random(in: 1 ... 10)
        let randDiagonals = (0..<randLength).map({ _ in Float.random(in: 0 ... 1) })
        let m = Matrix<Float>.diagonal(elements: randDiagonals)
        var v1 = m[0, 0 ..< randLength]
        v1[0] = 10
        let v2 = m[0, 0 ..< randLength]
        XCTAssertNotEqual(v1, v2)
        
        print(m)
    }
    
    func testMatrix32BitsFromCGImage() throws {
        let image = self.loadImage(named: "veles", ext: "jpeg")
        let imageMatrix = Matrix<Float>.from32Bits(cgImage: image)
        XCTAssertNotNil(imageMatrix)
        
        print(imageMatrix![10, 2...20])
        
        let returnedImage = imageMatrix!.toCGImage32Bits()!
        self.add(returnedImage, title: "recon_32bits_veles")
    }
    
    func testMatrixFromCGImageDirectly() throws {
        let image = self.loadImage(named: "veles", ext: "jpeg")
        print(image)
        
        let imageMatrix = Matrix<UInt8>.from(cgImage: image)!
//        let imageMatrix = Matrix<UInt8>.diagonal(elements: [UInt8](repeating: 255, count: 1000))
        
        let returnedImage = imageMatrix.toCGImage()!
        
        self.add(returnedImage, title: "recon_veles")
    }
}
