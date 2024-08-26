//
//  tMatrix-Matrix-Ops.swift
//
//  Created by AJ Ibraheem on 10/08/2024.
//  Copyright 2024.
   

import Testing
import MiniGrad

struct MatrixMultiplicationTests: TestWithBatteries {
    
    @available(macOS 13.3, *)
    @Test("Simple Random Square Matrix Multiplication", .tags(.DataTypeTest.float))
    func randSquareMatrixMultiplication() throws {
        // Manually generate a random matrix for now
        let randVectorGen: (Int) -> [Float] = { Array(0..<$0).map({ _ in Float.random(in: -10...10 )}) }
        let randMatrixGen: (Int) -> [[Float]] = { Array(repeating: $0, count: $0).map({ c in randVectorGen(c) }) }
        let randMatrixSize = Int.random(in: 1...100)
        
        let srcA = randMatrixGen(randMatrixSize)
        let srcB = randMatrixGen(randMatrixSize)
        
        let A = Matrix(data: srcA)
        let B = Matrix(data: srcB)
        
        let C = A * B
    
        let result = crudeMatrixMultiply(A: srcA, B: srcB)
        
        verifyMatricesEqual(lhs: result, rhs: C)
    }
    
    @available(macOS 13.3, *)
    @Test("Simple Non Square matrix multiplication", .tags(.DataTypeTest.float))
    func randNonSquareMatrixMul() async throws {
        // Manually generate a random matrix for now
        let randVectorGen: (Int) -> [Float] = { Array(0..<$0).map({ _ in Float.random(in: -10...10 )}) }
        let randMatrixGen: (Int) -> [[Float]] = { Array(repeating: $0, count: $0).map({ c in randVectorGen(c) }) }
        
        let srcA = randMatrixGen(5)
        let A = Matrix(data: srcA)
        let srcB = Array(randMatrixGen(10)[0..<5])
        let B = Matrix(data: srcB)
        
        let C = A * B
        
        let expectedResult = crudeMatrixMultiply(A: srcA, B: srcB)
        verifyMatricesEqual(lhs: expectedResult, rhs: C)
    }
    
    func crudeMatrixMultiply(A: [[Float]], B: [[Float]]) -> [[Float]] {
        let bCols = B[0].count
        let aRows = A.count
        let aCols = A[0].count
        var result: [[Float]] = Array(repeating: Array(repeating: 0.0, count: bCols), count: aRows)
        for i in 0..<aRows {
            for j in 0..<bCols {
                for k in 0..<aCols {
                    result[i][j] += A[i][k] * B[k][j]
                }
            }
        }
        
        return result
    }
}

// Verification Methods
extension MatrixMultiplicationTests {
    func verifyMatricesEqual(lhs: [[Float]], rhs: Matrix<Float>) {
        for i in 0..<rhs.nrows {
            for j in 0..<rhs.ncols {
                let actual = lhs[i][j]
                let expected = rhs[i,j]
                
                verifyEqual(a: actual, b: expected, within: 1e-3)
            }
        }
    }
}
