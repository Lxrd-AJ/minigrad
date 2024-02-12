//
//  TestCase.swift
//   - ,  
//
//  Created by AJ Ibraheem on 12/02/2024.
//  Copyright 2024, Ara Intelligence Limited.
   

import XCTest

class TestCase: XCTestCase {

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
    
    func add(_ image: CGImage, title: String? = nil, lifetime: XCTAttachment.Lifetime = .deleteOnSuccess) {
        let attachment = XCTAttachment(image: NSImage(cgImage: image, size: NSSize(width: image.width, height: image.height)))
        attachment.lifetime = lifetime
        attachment.name = title
        self.add(attachment)
    }

}
