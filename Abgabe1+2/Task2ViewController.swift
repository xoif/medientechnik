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
    let contentView = NSView()
    let imgView = NSImageView()
    var image: NSImage? {
        didSet {
            if image != nil {
            imgView.image = image
            processImage()
            }
        }
    }
    
    let sizeLabel = NSText()
    let bmpTypeLabel = NSText()
    let rgbaValueLabel = NSText()
    
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.layer?.borderWidth = 2
        view.layer?.borderColor = NSColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        task1Button.setButtonType(.pushOnPushOff)
        task1Button.title = "Zu Aufgabe 2 wechseln"
        task1Button.action = #selector(Task2ViewController.showPictureInfo)

        
        view.addSubview(contentView)
        contentView.addSubview(task1Button)
        
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

    func processImage() {
        
        image?.countPixelForColorAndMinValue(color: .RED, minValue: 128)

    }
    
    func showPictureInfo() {
        let viewController = Task1ViewController()
        NSApplication.shared().mainWindow?.contentViewController = viewController
    }
}







