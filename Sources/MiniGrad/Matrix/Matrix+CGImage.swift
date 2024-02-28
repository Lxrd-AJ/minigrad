//
//  Matrix+CGImage.swift
//
//  Created by AJ Ibraheem on 05/02/2024.
   

import Foundation
import CoreGraphics
import Accelerate

/// A 32-bit planar image format for consuming & producing `CGImage` instances
@available(macOS 10.15, iOS 13.0, *)
private var imageFormat = vImage_CGImageFormat(
    bitsPerComponent: 32, bitsPerPixel: 32, colorSpace: CGColorSpaceCreateDeviceGray(),
    bitmapInfo: CGBitmapInfo(
        rawValue: kCGBitmapByteOrder32Host.rawValue | CGBitmapInfo.floatComponents.rawValue | CGImageAlphaInfo.none.rawValue
    )
)!

/// Conversions from CGImage to Matrix and back using Accelerate
public extension Matrix<Float> {
    /// Pixel values are scaled between 0 and 1
    @available(macOS 10.15, iOS 13.0, *)
    // This works for any 32 bit data type such as Float, Int, Double etc
    // but its best to constrain it as Float only so that the underlying data is meaningful
    static func from32Bits(cgImage: CGImage) -> Matrix<Element>? {
        let m = Matrix<Element>.zeros(nrows: UInt(cgImage.height), ncols: UInt(cgImage.width))
        var tmpBuffer = vImage_Buffer(
            data: m.dataRef.data.baseAddress, height: vImagePixelCount(m.nrows), width: vImagePixelCount(m.ncols),
            rowBytes: Int(m.ncols) * MemoryLayout<Element>.stride
        )
        let error = vImageBuffer_InitWithCGImage(&tmpBuffer, &imageFormat, [0, 0, 0, 0], cgImage, vImage_Flags(kvImageNoAllocate))
        if error == kvImageNoError {
            return m
        }else{
            return nil
        }
    }
    
    @available(macOS 10.15, iOS 13.0, *)
    func toCGImage32Bits() -> CGImage? {
        let tmpBuffer = vImage_Buffer(
            data: self.dataRef.data.baseAddress, height: vImagePixelCount(self.nrows),
            width: vImagePixelCount(self.ncols),
            rowBytes: Int(self.ncols) * MemoryLayout<Element>.stride
        )
        
        return try? tmpBuffer.createCGImage(format: imageFormat)
    }
}

// See also https://github.com/hollance/CoreMLHelpers/blob/master/CoreMLHelpers/CGImage%2BRawBytes.swift
public extension Matrix {
    static func from(cgImage: CGImage) -> Matrix? {
        let m = Matrix.zeros(nrows: UInt(cgImage.height), ncols: UInt(cgImage.width))
        let stride = MemoryLayout<Element>.stride
        
        guard let context = CGContext(
            data: m.dataRef.data.baseAddress, width: cgImage.width, height: cgImage.height,
            bitsPerComponent: 8, bytesPerRow: Int(m.ncols) * stride, space: CGColorSpaceCreateDeviceGray(),
                    bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: Int(m.ncols), height: Int(m.nrows)))
        return m
    }
    
    func toCGImage() -> CGImage? {
        let stride = MemoryLayout<Element>.stride
        guard let context = CGContext(data: self.dataRef.data.baseAddress, width: Int(self.ncols), height: Int(self.nrows), bitsPerComponent: 8, bytesPerRow: Int(self.ncols) * stride, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
            return nil
        }
        
        return context.makeImage()
    }
}
