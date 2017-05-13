//
//  ViewController.swift
//  Abgabe1+2
//
//  Created by Rolf Paetow on 13.05.17.
//  Copyright © 2017 Rolf Paetow. All rights reserved.
//

import Cocoa
import SnapKit
import AppKit

class ViewController: NSViewController {

    let pushButton =  NSButton()
    let contentView = NSView()
    let imgView = NSImageView()
    let sizeLabel = NSText()
    let bmpTypeLabel = NSText()
    let rgbaValueLabel = NSText()
    var pixelRepresentation = [Pixel]()
    
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.layer?.borderWidth = 2
        view.layer?.borderColor = NSColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushButton.setButtonType(.pushOnPushOff)
        pushButton.title = "Bild laden"
        pushButton.action = #selector(ViewController.loadImage)
        
        view.addSubview(contentView)
        contentView.addSubview(pushButton)
        
        imgView.wantsLayer = true
        imgView.imageScaling = .scaleProportionallyDown //preserve the aspect ratio when image is loaded into image views' frame
        imgView.setContentCompressionResistancePriority(12, for: .horizontal)
        imgView.setContentCompressionResistancePriority(12, for: .vertical)
        //if compression resistance is set to its default level (which is 500), the window will only scale down upon the image views' image intrinsic size.
        
        imgView.layer?.backgroundColor = NSColor.green.cgColor
        
        sizeLabel.string = "Bitte lade ein Bild"
        sizeLabel.backgroundColor = NSColor.clear
        
        bmpTypeLabel.string = ""
        bmpTypeLabel.backgroundColor = NSColor.clear
        
        rgbaValueLabel.string = ""
        rgbaValueLabel.backgroundColor = NSColor.clear
        
        contentView.addSubview(imgView)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(bmpTypeLabel)
        contentView.addSubview(rgbaValueLabel)

        setupViews()
    }
    
    
    func setupViews() {
        
        contentView.snp.remakeConstraints {
            $0.edges.equalTo(view)
        }
        
        imgView.snp.remakeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(contentView).offset(20)
            $0.width.equalTo(contentView).inset(40)
            $0.height.equalTo(imgView.snp.width).multipliedBy(0.66)
        }
        
        sizeLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(40)
            $0.trailing.equalTo(contentView).offset(-40)
            $0.top.equalTo(imgView.snp.bottom).offset(10)
            $0.height.equalTo(20)
        }
        
        bmpTypeLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(40)
            $0.trailing.equalTo(contentView).offset(-40)
            $0.top.equalTo(sizeLabel.snp.bottom).offset(10)
            $0.height.equalTo(20)
        }
        
        rgbaValueLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(40)
            $0.trailing.equalTo(contentView).offset(-40)
            $0.top.equalTo(bmpTypeLabel.snp.bottom).offset(10)
            $0.height.equalTo(20)
        }
        
        pushButton.snp.remakeConstraints {
            $0.centerX.equalTo(contentView)
            $0.bottom.equalTo(contentView).inset(20)
            $0.height.equalTo(60)
            $0.width.equalTo(150)
        }
        
    }

    override func viewDidLayout() {
          setupViews()
        super.viewDidLayout()
    }
}


//MARK: Application Logic
extension ViewController {

    func loadImage() {
        
        guard let image = askUserForImage() else {return}
        sizeLabel.string = "Das Bild ist \(image.size.width) Pixel breit und \(image.size.height) Pixel hoch"
        
        //getting the image type
        bmpTypeLabel.string = "Image Type = \(image.imageType())"
        
        //getting the pixel information
        pixelRepresentation = image.pixelData()
        rgbaValueLabel.string = "RGBA Werte für ausgewählte Pixel: \(getPixelAt(x: 1, y: 1)?.description ?? "") (1|1), \(getPixelAt(x: 100, y: 500)?.description ?? "") (100|500), \(getPixelAt(x: 1000, y: 400)?.description ?? "") (1000|400), \(getPixelAt(x: 1400, y: 1000)?.description ?? "") (1400|1000)"
        
        //setting (and scaling) the image to its view
        imgView.image = image
        }
    
    
    func getPixelAt(x: Int, y: Int) -> Pixel? {
        for pixel in pixelRepresentation {
            if pixel.row == y && pixel.col == x {
                return pixel
            }
        }
        return nil
    }
    
    func askUserForImage() -> NSImage? {
    
        if let url = NSOpenPanel().selectUrl {
            return NSImage(contentsOf: url)
            print("file selected = \(url.path)")
        } else {
            print("file selection was canceled")
            return nil
        }
    }
}

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



extension NSImage {
    
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
        return "RGBA(\(r), \(g), \(b), \(a))"
    }
    
}
