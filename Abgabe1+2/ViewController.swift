//
//  ViewController.swift
//  Abgabe1+2
//
//  Created by Rolf Paetow on 13.05.17.
//  Copyright © 2017 Rolf Paetow. All rights reserved.
//

import Cocoa
import SnapKit
import Photos

class ViewController: NSViewController {

    let pushButton =  NSButton()
    let contentView = NSView()
    let imgView = NSImageView()
    let sizeLabel = NSText()
    
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
        imgView.layer?.backgroundColor = NSColor.green.cgColor
        
        sizeLabel.string = "Bitte lade ein Bild"
        sizeLabel.backgroundColor = NSColor.clear
        
        contentView.addSubview(imgView)
        contentView.addSubview(sizeLabel)

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
            $0.bottom.equalTo(pushButton.snp.top).offset(-10)
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
        guard let image = NSImage(named:"Strand.jpg") else {return}
        sizeLabel.string = "Das Bild ist \(image.size.width) Pixel breit und \(image.size.height) Pixel hoch"
        
        let imageManager = PHImageManager.defaultManager()
        imageManager.requestImageDataForAsset(self.asset!, options: nil, resultHandler:{
            (data, responseString, imageOriet, info) -> Void in
            let imageData: NSData = data!
            if let imageSource = CGImageSourceCreateWithData(imageData, nil) {
                let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)! as NSDictionary
                
                
            }
        })
    }
}

