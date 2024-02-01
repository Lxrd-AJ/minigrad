import XCTest
import Foundation
@testable import MiniGrad

final class tVector: XCTestCase {
    func testAddition() throws {
        let randomSize = Int.random(in: 1...100)
        let v1 = randomArray(size: randomSize)
        let v2 = randomArray(size: randomSize)
        let v3 = Vector(data: v1) + Vector(data: v2)
        let expectedSum = zip(v1, v2).map({ $0 + $1 })
        XCTAssertEqual(v3.data, expectedSum)
    }

    func testSubtraction() throws {
        let randomSize = Int.random(in: 1...100)
        let v1 = randomArray(size: randomSize)
        let v2 = randomArray(size: randomSize)
        let v3 = Vector(data: v1) - Vector(data: v2)
        let expectedDiff = zip(v1, v2).map({ $0 - $1 })
        XCTAssertEqual(v3.data, expectedDiff)
    }

    func testAddZeroVector() throws {
        let v1 = Vector(data: randomArray(size: 10))
        XCTAssertEqual(v1 + .zero, v1)
        XCTAssertEqual(.zero + v1, v1)
    }

    func testZeroEffect() throws {
        let v1 = Vector(data: randomArray(size: 10))
        let similarZero = Vector(data: Array(repeating: 0, count: v1.data.count))
        XCTAssertEqual(v1 - v1, similarZero)
    }

    func testVectorScalarAddition() throws {
        let entries = randomArray(size: 10)
        let v1 = Vector(data: entries)
        let scalar = Int.random(in: -100...100)
        let expected = Vector(data: entries.map({ $0 + scalar }))

        XCTAssertEqual(v1 + scalar, expected)
        
        // Commutative test
        XCTAssertEqual(scalar + v1, expected)
    }
    
    func testCommutativeVectorScalarMultiplication() throws {
        let entries = randomFloatArray(size: 20)
        let v1 = Vector(data: entries)
        let scalar = Float.random(in: -100...100.0)
        let expected = entries.map({ $0 * scalar })
        
        XCTAssertEqual((v1 * scalar).data, expected)
        XCTAssertEqual((scalar * v1).data, expected)
    }
    
    func testAssociativityScalarMultiplication() throws {
        let a = Float.random(in: -1.0...1.0)
        let b = Float.random(in: -1.0...1.0)
        let v1 = Vector(data: randomFloatArray(size: 10) )
        
        verifyEqual((a * b) * v1, a * (b * v1))
    }
    
    func testDistributiveScalarVectorMultiplication() throws {
        let a = Float.random(in: -1.0...1.0)
        let b = Float.random(in: -1.0...1.0)
        let v1 = Vector(data: randomFloatArray(size: 10))
        
        let left = (a + b) * v1
        let right = v1 * (a + b)
        XCTAssertEqual(left, right)
    }
    
    func testElementWiseVectorProduct() throws {
        let d1 = randomArray(size: 10, max: 100)
        let d2 = randomArray(size: 10, max: 200)
        let expected = zip(d1, d2).map({ $0 * $1 })
        
        let v1 = Vector(data: d1)
        let v2 = Vector(data: d2)
        XCTAssertEqual((v1 .* v2).data, expected)
    }
    
    // MARK: - Inner Product or Dot Product
    func testDotProduct() throws {
        let v1 = Vector(data: [-1, 2, 2], shape: .column)
        let v2 = Vector(data: [1, 0, -3], shape: .column)
        
        let dotProduct = v1.transpose().dot(v2)
        XCTAssertEqual(dotProduct, -7)
    }
    
    /// For commutativity $a^T \times b = b^T \times a$
    func testDotProductCommutativity() throws {
        let v1 = Vector(data: randomArray(size: 10, max: 10), shape: .column)
        let v2 = Vector(data: randomArray(size: 10, max: 10), shape: .column)
        
        XCTAssertEqual(
            v1.transpose().dot(v2),
            v2.transpose().dot(v1),
            "Vector dot product is commutative"
        )
    }
    
    /// For scalar associativity
    /// $(c a)^T b = c(a^T b) = ca^Tb$
    func testAssociativityWithScalarMultiplication() throws {
        let v1 = Vector(data: randomFloatArray(size: 10), shape: .column)
        let v2 = Vector(data: randomFloatArray(size: 10), shape: .column)
        let scalar = Float.random(in: -100...100)
        
        XCTAssertEqual(
            (scalar * v1).transpose().dot(v2),
            scalar * (v1.transpose().dot(v2)),
            accuracy: 1e-5, // Expected BLAS accuracy 
            "Associativity with scalar dot product not matched"
        )
    }
    
    /// For distributivity with vector addition
    /// $ (a + b)^T c = (a^Tc + b^Tc)$
    func testDistributivityWithVectorAddition() throws {
        let v1 = Vector(data: randomFloatArray(size: 10), shape: .column)
        let v2 = Vector(data: randomFloatArray(size: 10), shape: .column)
        let scalar = Float.random(in: -100...100)
        
        verifyEqual(
            (v1 + v2).transpose() * scalar,
            (v1.transpose() * scalar) + (v2.transpose() * scalar),
            tolerance: 1e-3, // Use a low accuracy for now
            "Distributivity with vector addition"
        )
    }
    
    func testMatrix() throws {
        let m = Matrix<Float>.zeros(nrows: 10, ncols: 20)
        print(m)
    }
}

func randomArray(size: Int, max: Int = Int.max / 2) -> [Int] {
    let (upperBound, lowerBound) = (max, max/2)
    return (0...size).map({ _ in Int.random(in: lowerBound..<upperBound)})
}

func randomFloatArray(size: Int) -> [Float] {
    let upperBound = Float.random(in: 1...5)
    let lowerBound = -upperBound
    return (0..<size).map({ _ in Float.random(in: lowerBound..<upperBound) })
}
