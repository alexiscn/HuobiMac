//
//  PopupSettingsAction.swift
//  HuobiMac
//
//  Created by xu.shuifeng on 26/01/2018.
//  Copyright © 2018 shuifeng. All rights reserved.
//

import Cocoa

class PopupSettingsAction {

    class func showIn(_ sender: NSView) {
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        
        let menu = NSMenu()
        
        menu.addItem(withTitle: "About", action: #selector(appDelegate.quit), keyEquivalent: "")
        menu.addItem(withTitle: "Settings", action: #selector(appDelegate.quit), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(appDelegate.quit), keyEquivalent: "q")
        NSMenu.popUpContextMenu(menu, with: NSApp.currentEvent!, for: sender)
    }
}
