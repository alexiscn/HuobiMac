//
//  HMCoinListCell.swift
//  HuobiMac
//
//  Created by xu.shuifeng on 19/01/2018.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Cocoa
import HuobiSwift

class HMCoinListCell: NSTableCellView {
    
    let redColor = NSColor(deviceRed: 174.0/255, green: 78.0/255, blue: 84.0/255, alpha: 1.0)
    let greenColor = NSColor(deviceRed: 88.0/255, green: 144.0/255, blue: 101.0/255, alpha: 1.0)
    
    @IBOutlet weak var codeLabel: NSTextField!
    
    @IBOutlet weak var priceLabel: NSTextField!
    
    @IBOutlet weak var rateLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    public func updateData(_ data: HBKLine) {
        
        if data.tick.rate < 0 {
            rateLabel.textColor = redColor
        } else {
            rateLabel.textColor = greenColor
        }
        rateLabel.stringValue = String(format: "%.2f %%", data.tick.rate)
        
        // 根据不同的币种选择不同的精度
        if data.symbol.last == "usdt" {
            priceLabel.stringValue = String(format: "%.2f", data.tick.close)
        } else if data.symbol.last == "btc" {
            priceLabel.stringValue = String(format: "%.6f", data.tick.close)
        }
        codeLabel.stringValue = data.symbol.first.uppercased()
    }
    
    class func view(_ tableView: NSTableView, owner: Any?, subject: Any?) -> NSView {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("coinCellViewIdentifier"), owner: owner) as! HMCoinListCell
        if let line = subject as? HBKLine {
            view.updateData(line)
        }
        return view
    }
}
