//
//  File.swift
//   - ,  
//
//  Created by AJ Ibraheem on 23/02/2024.
//  Copyright 2024, Ara Intelligence Limited.
   

import Foundation

@available(macOS 11.0, *)
public extension Matrix where Element == UInt8 {
    func toFloat() -> Matrix<Float> {
        let count = Int(nrows * ncols)
        let start = UnsafeMutablePointer<Float>.allocate(capacity: count)
        let buffer = UnsafeMutableBufferPointer(start: start, count: count)
        
        for (idx, item) in self.dataRef.data.enumerated() {
            buffer.initializeElement(at: idx, to: Float(item))
        }
        
        let dataRef = MatrixDataReference(data: buffer)
        return Matrix<Float>(nrows: nrows, ncols: ncols, data: dataRef)
    }
}


public extension Matrix where Element == Float {
    func toUInt() -> Matrix<UInt> {
        let count = Int(nrows * ncols)
        let start = UnsafeMutablePointer<UInt>.allocate(capacity: count)
        let buffer = UnsafeMutableBufferPointer(start: start, count: count)
        
        for (idx, item) in self.dataRef.data.enumerated() {
            buffer.initializeElement(at: idx, to: UInt(item))
        }
        
        let dataRef = MatrixDataReference(data: buffer)
        return Matrix<UInt>(nrows: nrows, ncols: ncols, data: dataRef)
    }
}
