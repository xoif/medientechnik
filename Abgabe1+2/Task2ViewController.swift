//
//  Task2ViewController.swift
//  Abgabe1+2
//
//  Created by Rolf Paetow on 13.05.17.
//  Copyright © 2017 Rolf Paetow. All rights reserved.
//

import Cocoa
import SnapKit
import AppKit

class Task2ViewController: NSViewController {

    let task1Button =  NSButton()

    let redButton =  NSButton()
    let greenButton =  NSButton()
    let blueButton =  NSButton()
    let vintageButton =  NSButton()
    let saveButton =  NSButton()

    let contentView = NSView()
    let imgView = NSImageView()
    var image: NSImage? {
        didSet {
            if image != nil {
            imgView.image = image
            countColoredPixel()
            }
        }
    }

    let pixelCountLabel = NSText()

    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.layer?.borderWidth = 2
        view.layer?.borderColor = NSColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        task1Button.setButtonType(.pushOnPushOff)
        task1Button.title = "Zu Aufgabe 1 wechseln"
        task1Button.action = #selector(Task2ViewController.showPictureInfo)

        redButton.title = "rot färben"
        greenButton.title = "grün färben"
        blueButton.title = "blau färben"
        vintageButton.title = "Vintage"
        saveButton.title = "speichern"
        redButton.action = #selector(Task2ViewController.processImage)
        greenButton.action = #selector(Task2ViewController.processImage)
        blueButton.action = #selector(Task2ViewController.processImage)
        vintageButton.action = #selector(Task2ViewController.processImage)
        saveButton.action = #selector(Task2ViewController.saveCurrentImage)

        view.addSubview(contentView)
        contentView.addSubview(task1Button)
        
        imgView.wantsLayer = true
        imgView.imageScaling = .scaleProportionallyDown //preserve the aspect ratio when image is loaded into image views' frame
        imgView.setContentCompressionResistancePriority(12, for: .horizontal)
        imgView.setContentCompressionResistancePriority(12, for: .vertical)
        //if compression resistance is set to its default level (which is 500), the window will only scale down upon the image views' image intrinsic size.
        
        imgView.layer?.backgroundColor = NSColor.green.cgColor

        pixelCountLabel.backgroundColor = NSColor.clear
        pixelCountLabel.isEditable = false


        contentView.addSubview(task1Button)
        contentView.addSubview(redButton)
        contentView.addSubview(greenButton)
        contentView.addSubview(blueButton)
        contentView.addSubview(vintageButton)
        contentView.addSubview(saveButton)

        contentView.addSubview(imgView)
        contentView.addSubview(pixelCountLabel)

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
        
        pixelCountLabel.snp.remakeConstraints {
            $0.leading.equalTo(contentView).offset(40)
            $0.trailing.equalTo(contentView).offset(-40)
            $0.top.equalTo(imgView.snp.bottom).offset(10)
            $0.height.equalTo(20)
        }

        redButton.snp.remakeConstraints {
            $0.leading.equalTo(contentView).offset(40)
            $0.height.equalTo(30)
            $0.top.equalTo(pixelCountLabel.snp.bottom).offset(10)
            $0.width.equalTo(75)
        }

        greenButton.snp.remakeConstraints {
            $0.leading.equalTo(redButton.snp.trailing).offset(20)
            $0.height.equalTo(30)
            $0.top.equalTo(pixelCountLabel.snp.bottom).offset(10)
            $0.width.equalTo(75)
        }

        blueButton.snp.remakeConstraints {
            $0.leading.equalTo(greenButton.snp.trailing).offset(20)
            $0.height.equalTo(30)
            $0.top.equalTo(pixelCountLabel.snp.bottom).offset(10)
            $0.width.equalTo(75)
        }

        vintageButton.snp.remakeConstraints {
            $0.leading.equalTo(blueButton.snp.trailing).offset(20)
            $0.height.equalTo(30)
            $0.top.equalTo(pixelCountLabel.snp.bottom).offset(10)
            $0.width.equalTo(75)
        }
        
        saveButton.snp.remakeConstraints {
            $0.leading.equalTo(vintageButton.snp.trailing).offset(20)
            $0.height.equalTo(30)
            $0.top.equalTo(pixelCountLabel.snp.bottom).offset(10)
            $0.width.equalTo(75)
        }


        task1Button.snp.remakeConstraints {
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
extension Task2ViewController {

    func countColoredPixel() {
        guard let img = image else {return}
        let redCount =  img.countPixelForColorAndMinValue(color: .RED, minValue: 128)
        let greenCount =  img.countPixelForColorAndMinValue(color: .GREEN, minValue: 128)
        let blueCount =   img.countPixelForColorAndMinValue(color: .BLUE, minValue: 128)
        pixelCountLabel.string = "Das Bild enthält \(redCount) Pixel mit roter Farbe, \(greenCount) Pixel mit grüner Farbe und \(blueCount) Pixel mit blauer Farbe"
    }

    func processImage(_ sender : NSButton) {
        
      
        guard let img = image?.copy() as? NSImage else {return}
        
        var maxR, maxG, maxB: Int
        
        if sender.isEqual(redButton) {
            maxR = 255
            maxG = 0
            maxB = 0
        } else if sender.isEqual(greenButton) {
            maxR = 0
            maxG = 255
            maxB = 0
        } else if sender.isEqual(blueButton) {
            maxR = 0
            maxG = 0
            maxB = 255
        } else if sender.isEqual(vintageButton){
            maxR = 255
            maxG = 255
            maxB = 128
        } else {
        return
        }
        
        imgView.image = img.limit(maxR: maxR, maxG: maxG, maxB: 128)
    }
    
    func saveCurrentImage(){
        guard let img = imgView.image else {return}
        
        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let path = desktopURL.appendingPathComponent("processed_image.png")
        img.pngWrite(to: path, options: .withoutOverwriting)
    }
    
    func showPictureInfo() {
        let viewController = Task1ViewController()
        NSApplication.shared().mainWindow?.contentViewController = viewController
    }
}







