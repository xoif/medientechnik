//
//  Task1ViewController.swift
//  Abgabe1+2
//
//  Created by Rolf Paetow on 13.05.17.
//  Copyright © 2017 Rolf Paetow. All rights reserved.
//

import Cocoa
import SnapKit
import AppKit

class Task1ViewController: NSViewController {

    let pushButton =  NSButton()
    let task2Button =  NSButton()
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
        pushButton.action = #selector(Task1ViewController.loadImage)
        
        task2Button.setButtonType(.pushOnPushOff)
        task2Button.title = "Zu Aufgabe 2 wechseln"
        task2Button.action = #selector(Task1ViewController.showPictureManipulation)

        
        view.addSubview(contentView)

        
        imgView.wantsLayer = true
        imgView.imageScaling = .scaleProportionallyDown //preserve the aspect ratio when image is loaded into image views' frame
        imgView.setContentCompressionResistancePriority(12, for: .horizontal)
        imgView.setContentCompressionResistancePriority(12, for: .vertical)
        //if compression resistance is set to its default level (which is 500), the window will only scale down upon the image views' image intrinsic size.
        
        imgView.layer?.backgroundColor = NSColor.green.cgColor
        
        sizeLabel.string = "Bitte lade ein Bild"
        sizeLabel.backgroundColor = NSColor.clear
        sizeLabel.isEditable = false

        
        bmpTypeLabel.string = ""
        bmpTypeLabel.backgroundColor = NSColor.clear
        bmpTypeLabel.isEditable = false
        
        rgbaValueLabel.string = "\n"
        rgbaValueLabel.backgroundColor = NSColor.clear
        rgbaValueLabel.isEditable = false
        
        
        contentView.addSubview(pushButton)
        contentView.addSubview(task2Button)
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
        
        sizeLabel.snp.remakeConstraints {
            $0.leading.equalTo(contentView).offset(40)
            $0.trailing.equalTo(contentView).offset(-40)
            $0.top.equalTo(imgView.snp.bottom).offset(10)
            $0.height.equalTo(20)
        }
        
        bmpTypeLabel.snp.remakeConstraints {
            $0.leading.equalTo(contentView).offset(40)
            $0.trailing.equalTo(contentView).offset(-40)
            $0.top.equalTo(sizeLabel.snp.bottom).offset(10)
            $0.height.equalTo(20)
        }
        
        rgbaValueLabel.snp.remakeConstraints {
            $0.leading.equalTo(contentView).offset(40)
            $0.trailing.equalTo(contentView).offset(-40)
            $0.top.equalTo(bmpTypeLabel.snp.bottom).offset(10)
            $0.height.equalTo(40)
        }
        
        pushButton.snp.remakeConstraints {
            $0.centerX.equalTo(contentView)
            $0.bottom.equalTo(contentView).inset(20)
            $0.height.equalTo(60)
            $0.width.equalTo(150)
        }
        
        task2Button.snp.remakeConstraints {
            $0.leading.equalTo(pushButton.snp.trailing).offset(20)
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
extension Task1ViewController {

    func loadImage() {
        
        guard let image = askUserForImage() else {return}
        sizeLabel.string = "Das Bild ist \(image.size.width) Pixel breit und \(image.size.height) Pixel hoch"
        
        //getting the image type
        bmpTypeLabel.string = "Image Type = \(image.imageType())"
        
        //getting the pixel information
        pixelRepresentation = image.pixelData()
        rgbaValueLabel.string = "RGBA Werte für ausgewählte Pixel: 1|1 -> \(getPixelAt(x: 1, y: 1)), 100|500 -> \(getPixelAt(x: 100, y: 500)), 1000|400 -> \(getPixelAt(x: 1000, y: 400)), 1400|1000 -> \(getPixelAt(x: 1400, y: 1000))"
        
        //setting (and scaling) the image to its view
        imgView.image = image
        }
    
    
    func getPixelAt(x: Int, y: Int) -> String {
        for pixel in pixelRepresentation {
            if pixel.row == y && pixel.col == x {
                return pixel.description
            }
        }
        return "ungültig"
    }
    
    func askUserForImage() -> NSImage? {
    
        if let url = NSOpenPanel().selectUrl {
            print("file selected = \(url.path)")
            return NSImage(contentsOf: url)
        } else {
            print("file selection was canceled")
            return nil
        }
    }
    
    func showPictureManipulation() {
        let viewController = Task2ViewController()
        viewController.image = imgView.image
        NSApplication.shared().mainWindow?.contentViewController = viewController
    }
}

