//
//  MainViewController.swift
//  HuobiMac
//
//  Created by xu.shuifeng on 26/01/2018.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, HuobiSocketDelegate {

    @IBOutlet weak var segment: NSSegmentedControl!
    
    fileprivate var socket: HuobiSocket?
    
    fileprivate let USDTListcontroller = HMListViewController(nibName: NSNib.Name("HMListViewController"), bundle: nil)
    fileprivate let BTCListcontroller = HMListViewController()
    fileprivate let ETHListcontroller = HMListViewController()
    
    @IBOutlet weak var listContainerView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        segment.target = self
        segment.action = #selector(segmentControlClicked(_:))
        
        listContainerView.addSubview(USDTListcontroller.view)
        USDTListcontroller.view.frame = listContainerView.bounds
//        addChildViewController(USDTListcontroller)
    }
    
    func connect() {
        socket = HuobiSocket()
        socket?.delegate = self
        socket?.connect()
    }
    
    @objc func segmentControlClicked(_ sender: NSSegmentedControl) {
        let index = sender.selectedSegment
        print(index)
    }
    
    public func watch(symbols: [String]) {
        for symbol in symbols {
            let topic = "market.\(symbol).kline.1day"
            socket?.subscribe(topic)
        }
    }
    
    // MARK: - HuobiSocketDelegate
    
    func huobiSocketDidConnected(_ huobiSocket: HuobiSocket) {
//        let topic = "market.btcusdt.kline.1day"
//        socket?.subscribe(topic)
        watch(symbols: [Symbol.btcusdt.rawValue,
                        Symbol.etcusdt.rawValue,
                        Symbol.ethusdt.rawValue])
    }
    
    func huobiSocket(_ huobiSocket: HuobiSocket, didDisConnectError error: NSError?) {
        print("error:\(error?.localizedDescription)")
    }
    
    func huobiSocket(_ huobiSocket: HuobiSocket, didReceiveKLine kLine: KLine) {
        //kLine.ch
        USDTListcontroller.updateData(kLine)
    }
}
