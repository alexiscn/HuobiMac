//
//  PreferencesWindowController.swift
//  HuobiMac
//
//  Created by xu.shuifeng on 30/01/2018.
//  Copyright © 2018 shuifeng. All rights reserved.
//
import AppKit

class PreferencesWindowController: NSWindowController {
    
    fileprivate var toolbar: NSToolbar?
    
    
    init() {
        let masks: NSWindow.StyleMask = [.closable, .miniaturizable, .resizable, .fullScreen, .fullScreen]
        
        
        
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
