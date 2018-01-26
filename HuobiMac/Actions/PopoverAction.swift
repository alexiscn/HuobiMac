//
//  PopoverAction.swift
//  HuobiMac
//
//  Created by xu.shuifeng on 26/01/2018.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Cocoa

class PopoverAction {
    
    fileprivate class var appDelegate: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    class func toggle() {
        if appDelegate.popover.isShown {
            close()
        } else {
            show()
        }
    }
    
    class func close() {
        guard appDelegate.popover.isShown else {
            return
        }
        appDelegate.popover.close()
    }
    
    class func show() {
        NSRunningApplication.current.activate(options: .activateIgnoringOtherApps)
        guard let button = appDelegate.statusItem.button else {
            return
        }
        appDelegate.popover.show(relativeTo: button.frame, of: button, preferredEdge: .minY)
    }
    
}
