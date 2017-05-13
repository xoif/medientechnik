//
//  ViewController.swift
//  Abgabe1+2
//
//  Created by Rolf Paetow on 13.05.17.
//  Copyright © 2017 Rolf Paetow. All rights reserved.
//

import Cocoa
import SnapKit

class ViewController: NSViewController {

    let pushButton =  NSButton()
    let contentView = NSView()
    let imgView = NSImageView()
    
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
        
        view.addSubview(contentView)
        contentView.addSubview(pushButton)
        
        imgView.wantsLayer = true
        imgView.layer?.backgroundColor = NSColor.green.cgColor
        
        contentView.addSubview(imgView)

        setupViews()
    }
    
    
    func setupViews() {
        
        contentView.snp.remakeConstraints {
            $0.edges.equalTo(view)
        }
        pushButton.snp.remakeConstraints {
            $0.centerX.equalTo(contentView)
            $0.bottom.equalTo(contentView).inset(20)
            $0.height.equalTo(60)
            $0.width.equalTo(150)
        }
        
        imgView.snp.remakeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(contentView).offset(20)
            $0.width.equalTo(contentView).inset(40)
            $0.height.equalTo(imgView.snp.width).multipliedBy(0.66)
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
        imgView.image = NSImage(named:"test")
    }
}

