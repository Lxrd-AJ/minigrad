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
}


func randomArray(size: Int) -> [Int] {
    let upperBound = Int.max / 2
    let lowerBound = Int.min / 2
    return (0...size).map({ _ in Int.random(in: lowerBound..<upperBound)})
}