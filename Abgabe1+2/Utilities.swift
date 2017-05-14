//
//  Utilities.swift
//  Abgabe1+2
//
//  Created by Rolf Paetow on 14.05.17.
//  Copyright © 2017 Rolf Paetow. All rights reserved.
//

import Cocoa
import AppKit


//MARK: Helper

extension NSOpenPanel {
    var selectUrl: URL? {
        title = "Select File"
        allowsMultipleSelection = false
        canChooseDirectories = false
        canChooseFiles = true
        canCreateDirectories = false
        allowedFileTypes = ["jpg","png","pdf","pct", "bmp", "tiff"]  // to allow only images, just comment out this line to allow any file type to be selected
        return runModal() == NSFileHandlingPanelOKButton ? urls.first : nil
    }
}

extension NSBitmapImageRep {

    func imageFromPixels(image: CGImage, size: NSSize, pixels: UnsafePointer<UInt8>)-> NSImage {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitsPerComponent = image.bitsPerComponent
        let bitsPerPixel = image.bitsPerPixel
        let bytesPerRow = image.bytesPerRow
        let providerRef = CGDataProvider(
            data: NSData(bytes: pixels, length: Int(size.height) * bytesPerRow) //Do not put `&` as pixels is already an `UnsafePointer`
        )

        let cgim = CGImage(
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: bytesPerRow,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )
        return NSImage(cgImage: cgim!, size: size)
    }
}


extension NSImage {
    
    
    var toCGImage: CGImage {
        var imageRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let image =  cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
            abort()
        }
        return image
    }
    
    
    func pixelData() -> [Pixel] {
        let bmp = self.representations[0] as! NSBitmapImageRep
        var data: UnsafeMutablePointer<UInt8> = bmp.bitmapData!
        var r, g, b, a: UInt8
        var pixels: [Pixel] = []
        
        for row in 0..<bmp.pixelsHigh {
            for col in 0..<bmp.pixelsWide {
                r = data.pointee
                data = data.advanced(by: 1)
                g = data.pointee
                data = data.advanced(by: 1)
                b = data.pointee
                data = data.advanced(by: 1)
                a = data.pointee
                data = data.advanced(by: 1)
                pixels.append(Pixel(r: r, g: g, b: b, a: a, row: row, col: col))
            }
        }
        return pixels
    }
    
    func countPixelForColorAndMinValue(color: rgbColor, minValue: UInt8) -> Int {
        let bmp = self.representations[0] as! NSBitmapImageRep
        var data: UnsafeMutablePointer<UInt8> = bmp.bitmapData!
        var r, g, b, a: UInt8
        var pixels: [Pixel] = []
        
        for row in 0..<bmp.pixelsHigh {
            for col in 0..<bmp.pixelsWide {
   
                r = data.pointee
                data = data.advanced(by: 1)
                g = data.pointee
                data = data.advanced(by: 1)
                b = data.pointee
                data = data.advanced(by: 1)
                a = data.pointee
                data = data.advanced(by: 1)
                
                if (color == .RED && r >= minValue) || (color == .GREEN && g >= minValue) || (color == .BLUE && b >= minValue) {
                    pixels.append(Pixel(r: r, g: g, b: b, a: a, row: row, col: col))
                }
            }
        }
        return pixels.count
    }
    
    func limit(maxR: Int, maxG: Int, maxB: Int) -> NSImage {
        let bmp = self.representations[0] as! NSBitmapImageRep
        var data: UnsafeMutablePointer<UInt8> = bmp.bitmapData!
        var r, g, b: UInt8
        
        for _ in 0..<bmp.pixelsHigh {
            for _ in 0..<bmp.pixelsWide {
                r = data.pointee
                if r > UInt8(maxR) {
                    data.pointee = UInt8(maxR)
                }
                data = data.advanced(by: 1)
                g = data.pointee
                if g > UInt8(maxG) {
                    data.pointee = UInt8(maxG)
                }
                data = data.advanced(by: 1)
                b = data.pointee
                if b > UInt8(maxB) {
                    data.pointee = UInt8(maxB)
                }
                 data = data.advanced(by: 2)
                /*
                    alpha values are not needed by this method, so we have to skip their memory adresses and move the pointer by two values
                    (as it is a typed pointer) in order to get to the next Pixel.
                */
            }
        }
        return bmp.imageFromPixels(image: self.toCGImage, size: bmp.size, pixels: bmp.bitmapData!)
    }

    
    func imageType() -> String {
        let bmp = self.representations[0] as! NSBitmapImageRep
        return bmp.bitmapFormat.description()
    }
    
}

extension NSBitmapFormat {
    
    func description() -> String {
        return ["alphaFirst","alphaNonPremultiplied","floatingPointSamples","16BitBigEndian","16BitLittleEndian","32BitBigEndian","32BitLittleEndian"][Int(self.rawValue)]
    }
}

enum rgbColor {
    case RED, GREEN, BLUE
}

struct Pixel {
    
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    var row: Int
    var col: Int
    
    init(r: UInt8, g: UInt8, b: UInt8, a: UInt8, row: Int, col: Int) {
        self.r = Float(r)
        self.g = Float(g)
        self.b = Float(b)
        self.a = Float(a)
        self.row = row
        self.col = col
    }
    
    var color: NSColor {
        return NSColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(a/255.0))
    }
    
    var description: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return "RGBA(\(formatter.string(from: NSNumber(value: r))!), \(formatter.string(from: NSNumber(value: g))!), \(formatter.string(from: NSNumber(value: b))!), \(formatter.string(from: NSNumber(value: a))!))"
    }
    
}
