//
//  MainViewController.swift
//  HuobiMac
//
//  Created by xu.shuifeng on 26/01/2018.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Cocoa
import HuobiSwift

class MainViewController: NSViewController, HuobiSocketDelegate {

    @IBOutlet weak var segment: NSSegmentedControl!
    
    fileprivate var socket: HuobiSocket?
    
    fileprivate let USDTListcontroller = HMListViewController(nibName: NSNib.Name("HMListViewController"), bundle: nil)
    fileprivate let BTCListcontroller = HMListViewController(nibName: NSNib.Name("HMListViewController"), bundle: nil)
    fileprivate let ETHListcontroller = HMListViewController(nibName: NSNib.Name("HMListViewController"), bundle: nil)
    
    @IBOutlet weak var listContainerView: NSView!
    
    fileprivate var currentListView: NSView?
    
    fileprivate var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        segment.target = self
        segment.action = #selector(segmentControlClicked(_:))
        
        listContainerView.addSubview(USDTListcontroller.view)
        USDTListcontroller.view.frame = listContainerView.bounds
        currentListView = USDTListcontroller.view
    }
    
    func connect() {
        socket = HuobiSocket()
        socket?.delegate = self
        socket?.connect()
    }
    
    @objc func segmentControlClicked(_ sender: NSSegmentedControl) {
        let index = sender.selectedSegment
        print(index)
        
        if index != currentIndex {
            currentListView?.removeFromSuperview()
            if index == 0 {
                listContainerView.addSubview(USDTListcontroller.view)
                USDTListcontroller.view.frame = listContainerView.bounds
                currentListView = USDTListcontroller.view
            } else if index == 1 {
                listContainerView.addSubview(BTCListcontroller.view)
                BTCListcontroller.view.frame = listContainerView.bounds
                currentListView = BTCListcontroller.view
            } else {
                listContainerView.addSubview(ETHListcontroller.view)
                ETHListcontroller.view.frame = listContainerView.bounds
                currentListView = ETHListcontroller.view
            }
            currentIndex = index
        }
    }
    
    public func watch(symbols: [String]) {
        for symbol in symbols {
            let topic = "market.\(symbol).kline.1day"
            socket?.subscribe(topic)
        }
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        PopupSettingsAction.showIn(self.view)
    }
    
    
    // MARK: - HuobiSocketDelegate
    
    func huobiSocketDidConnected(_ huobiSocket: HuobiSocket) {
        let usdtSymbols: [String] = Symbol.usdtSymbols().map({ return $0.rawValue })
        watch(symbols: usdtSymbols)
        
        let btcSymbols: [String] = Symbol.btcSymbols().map({return $0.rawValue })
        watch(symbols: btcSymbols)
    }
    
    func huobiSocket(_ huobiSocket: HuobiSocket, didDisConnectError error: Error?) {
        if let error = error {
            print("error:\(error.localizedDescription)")
        }
    }
    
    func huobiSocket(_ huobiSocket: HuobiSocket, didReceiveData data: Data) {
        
        guard let content = String(data: data, encoding: .utf8) else {
            print("can not read receiveData")
            return
        }
        
        // 如果收到的是订阅成功的消息，不解析
        if content.contains("subbed") {
            return
        }
        // 否则用K线解析
        do {
            let kline = try JSONDecoder().decode(HBKLine.self, from: data)
            
            if kline.symbol.last == "usdt" {
                USDTListcontroller.updateData(kline)
            } else if kline.symbol.last == "btc" {
                BTCListcontroller.updateData(kline)
            }
            
        } catch(let err) {
            print(content)
            print(err.localizedDescription)
        }
    }
}
