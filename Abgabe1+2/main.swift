//
//  main.swift
//  ImagePicker
//
//  Created by Rolf Paetow on 13.05.17.
//  Copyright © 2017 Rolf Paetow. All rights reserved.
//

import AppKit

final class ImagePickerApplicationController: NSObject, NSApplicationDelegate {
    
            let window1 = NSWindow()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        window1.contentViewController = ViewController()
        window1.styleMask = NSWindowStyleMask([.resizable, .titled, .closable])
        window1.contentMinSize = NSSize(width: 300, height: 300)
        window1.setFrame(CGRect(x: 0, y: 0, width: 900, height: 900), display: true)
        window1.aspectRatio = window1.frame.size
        window1.title = "Bild auslesen"
       
        window1.makeKeyAndOrderFront(self)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
}

/// When compared to Objective-C example, an `autoreleasepool`
/// is not required because Swift expected to install one automatically.
/// Anyway you can install one if you want to be safe.
autoreleasepool { () -> () in
    let app1 = NSApplication.shared()
    let con1 = ImagePickerApplicationController()
    
    app1.delegate = con1
    app1.run()
}
