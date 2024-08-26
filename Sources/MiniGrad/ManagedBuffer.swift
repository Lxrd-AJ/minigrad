//
//  ManagedBuffer.swift
//
//  Created by AJ Ibraheem on 24/08/2024.
//  Copyright 2024.
   
typealias Element = Numeric

class MatrixBuffer<T>: ManagedBuffer<(rows: Int, cols:Int), T> {
    var numElements: Int {
        return Int(header.rows * header.cols)
    }
    
    deinit {
        let _ = withUnsafeMutablePointerToElements({ pointer in
            pointer.deinitialize(count: self.numElements)
        })
    }
    
    func clone() -> MatrixBuffer {
        let newBuffer = MatrixBuffer.create(minimumCapacity: self.numElements, makingHeaderWith: { buffer in
            return self.header
        })
        
        newBuffer.withUnsafeMutablePointerToElements({ newPointer in
            self.withUnsafeMutablePointerToElements({ oldPointer in
                newPointer.initialize(from: oldPointer, count: self.numElements)
            })
        })
        
        return newBuffer as! MatrixBuffer
    }
    
    static func create(size shape: (rows: Int, cols: Int), initial value: T) -> MatrixBuffer {
        let numElements = Int(shape.0 * shape.1)
        let buffer = MatrixBuffer.create(minimumCapacity: numElements, makingHeaderWith: { buffer in
            return (rows: shape.0, cols: shape.1)
        })
        
        buffer.withUnsafeMutablePointerToElements({ pointer in
            pointer.initialize(repeating: value, count: numElements)
        })
        
        return buffer as! MatrixBuffer
    }
    
    static func create(rows: Int, cols: Int, dataRef: UnsafeMutableBufferPointer<T>) -> MatrixBuffer {
        let numElements = rows * cols
        let buffer = MatrixBuffer.create(minimumCapacity: numElements, makingHeaderWith: { buffer in
            return (rows: rows, cols: cols)
        })
        
        buffer.withUnsafeMutablePointerToElements({ pointer in
            assert(dataRef.baseAddress != nil, "The source buffer cannot be nil")
            pointer.initialize(from: dataRef.baseAddress!, count: numElements)
        })
        
        return buffer as! MatrixBuffer<T>
    }
    
    subscript(index: Int) -> T {
        get {
            return withUnsafeMutablePointerToElements({ pointer in
                return pointer[index]
            })
        }
        set {
            withUnsafeMutablePointerToElements({ pointer in
                pointer[index] = newValue
            })
        }
    }
}

// Convenience pointer accessors
extension MatrixBuffer {
    func pointer() -> UnsafePointer<T> {
        let pointer: UnsafeMutablePointer<T> = withUnsafeMutablePointerToElements({ $0 })
        return UnsafePointer(pointer)
    }
    
    func mutablePointer() -> UnsafeMutablePointer<T> {
        let pointer: UnsafeMutablePointer<T> = withUnsafeMutablePointerToElements({ $0 })
        return pointer
    }
    
    /// Prefer `mutablePointer` over `mutableRawPointer` as the underlying type used for
    /// raw pointer is `UInt8` and it performs a possibly expensive conversion from `UInt8` to the
    /// desired datatype `T`
    /// Expected usecases for a raw pointer like this is for graphics drawing
    func mutableRawPointer() -> UnsafeMutableRawPointer {
        let pointer = withUnsafeMutablePointerToElements({ $0 })
        return UnsafeMutableRawPointer(pointer)
    }
    
    func mutableBufferPointer() -> UnsafeMutableBufferPointer<T> {
        let pointer = withUnsafeMutablePointerToElements({ $0 })
        return UnsafeMutableBufferPointer(start: pointer, count: numElements)
    }
    
    /// Prefer `mutableBufferPointer` over `mutableRawBufferPointer` as the underlying type used for
    /// raw pointer is `UInt8` and it performs a possibly expensive conversion from `UInt8` to the
    /// desired datatype `T`
    /// Expected usecases for a raw pointer like this is for graphics drawing
    func mutableRawBufferPointer () -> UnsafeMutableRawBufferPointer {
        let pointer = withUnsafeMutablePointerToElements({ $0 })
        let bufferPointer = UnsafeMutableRawBufferPointer(start: pointer, count: numElements)
        return bufferPointer
    }
}
