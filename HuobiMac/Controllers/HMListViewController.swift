//
//  HMListViewController.swift
//  HuobiMac
//
//  Created by xu.shuifeng on 19/01/2018.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Cocoa
import HuobiSwift

class HMListViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var listTableView: NSTableView!
    
    var dataSource: [HBKLine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    public func updateData(_ line: HBKLine) {
        if let index = dataSource.index(where: { $0.ch == line.ch }), index > -1 {
            dataSource[index] = line
        } else {
            dataSource.append(line)
        }
        if listTableView != nil {
            listTableView.reloadData()
        }
    }
    
    // MARK: - NSTableViewDelegate
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let data = dataSource[row]
        return HMCoinListCell.view(tableView, owner: self, subject: data)
    }
}
