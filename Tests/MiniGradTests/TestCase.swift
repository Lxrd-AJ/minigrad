//
//  TestCase.swift
//   - ,  
//
//  Created by AJ Ibraheem on 12/02/2024.
//  Copyright 2024, Ara Intelligence Limited.
   

import XCTest
import Testing
@testable import MiniGrad

extension XCTestCase {
    func verifyEqual(_ left: Vector<Float>, _ right: Vector<Float>, tolerance: Float = Float.ulpOfOne, _ message: String = "") {
        XCTAssertEqual(left.data.count, right.data.count)
        let items = zip(left.data, right.data)
        for item in items {
            XCTAssertEqual(item.0, item.1, accuracy: tolerance, message)
        }
    }
    
    func verifyNotEqual(_ left: Vector<Float>, _ right: Vector<Float>, tolerance: Float = Float.ulpOfOne, _ message: String = "") {
        XCTAssertEqual(left.data.count, right.data.count)
        let items = zip(left.data, right.data)
        for item in items {
            XCTAssertNotEqual(item.0, item.1, accuracy: tolerance, message)
        }
    }
}


class TestCase: XCTestCase, TestCaseWithResources {
    func add(_ image: CGImage, title: String? = nil, lifetime: XCTAttachment.Lifetime = .deleteOnSuccess) {
        let attachment = XCTAttachment(image: NSImage(cgImage: image, size: NSSize(width: image.width, height: image.height)))
        attachment.lifetime = lifetime
        attachment.name = title
        self.add(attachment)
    }
}

protocol TestCaseWithResources {
}

extension TestCaseWithResources {
    func loadImage(named: String, ext: String? = nil) -> CGImage {
        guard let imgURL = Bundle.module.url(forResource: named, withExtension: ext) else {
            fatalError("could not find image url")
        }
        guard let imageData = try? Data(contentsOf: imgURL) else {
            print("Could not convert URL to data")
            fatalError()
        }
        
        #if canImport(AppKit)
        let pImage = NSImage(data: imageData)!
        return pImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        #else
        let pImage = UIImage(data: imageData)!
        return pImage.cgImage!
        #endif
    }
}

protocol TestWithBatteries {
}

extension TestWithBatteries {
//    func verifyEqual(a: Float, b: Float, within accuracy: Float = 1e-3) {
//        #expect(abs(a-b) <= accuracy)
//    }
    
    func verifyEqual<T>(a: @autoclosure () -> T, b: @autoclosure () -> T, within accuracy: T) where T : FloatingPoint {
        #expect(abs(a() - b()) <= accuracy)
    }
    
//    func verifyEqual(lhs A: Matrix<Float>, rhs B: Matrix<Float>, within accuracy: Float = 1e-3) {
//        #expect(A.shape == B.shape)
//        for row in 0..<A.nrows {
//            for col in 0..<B.ncols {
//                verifyEqual(a: A[row, col], b: B[row, col], within: accuracy)
//            }
//        }
//    }
    
    func verifyEqual<T: Numeric & Equatable & FloatingPoint>(lhs A: Matrix<T>, rhs B: Matrix<T>, within accuracy: T = 1e-3) {
        #expect(A.shape == B.shape)
        for row in 0..<A.nrows {
            for col in 0..<B.ncols {
                verifyEqual(a: A[row, col], b: B[row, col], within: accuracy)
            }
        }
    }
}
