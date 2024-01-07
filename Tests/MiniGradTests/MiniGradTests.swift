import XCTest
import Foundation
@testable import MiniGrad

final class MiniGradTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}

extension XCTestCase {
    func verifyEqual(_ left: Vector<Float>, _ right: Vector<Float>, tolerance: Float = Float.ulpOfOne, _ message: String = "") {
        XCTAssertEqual(left.data.count, right.data.count)
        let items = zip(left.data, right.data)
        for item in items {
            XCTAssertEqual(item.0, item.1, accuracy: tolerance, message)
        }
    }
}

