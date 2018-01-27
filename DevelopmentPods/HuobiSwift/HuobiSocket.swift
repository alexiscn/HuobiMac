//
//  HuobiSocket.swift
//  HuobiSwift
//
//  Created by xushuifeng on 27/01/2018.
//

import Foundation
import Starscream
import Gzip

public protocol HuobiSocketDelegate: class {
    func huobiSocketDidConnected(_ huobiSocket: HuobiSocket)
    func huobiSocket(_ huobiSocket: HuobiSocket, didDisConnectError error: Error?)
    func huobiSocket(_ huobiSocket: HuobiSocket, didReceiveKLine kLine: HBKLine)
}

open class HuobiSocket: NSObject {
    
    fileprivate let HOST_URLSTRING = "wss://api.huobi.pro/ws"
    
    fileprivate var webSocket: WebSocket?
    
    public weak var delegate: HuobiSocketDelegate?
    
    public func connect() {
        let socket = WebSocket(url: URL(string: HOST_URLSTRING)!)
        self.webSocket = socket
        socket.delegate = self
        socket.connect()
    }
    
    public func subscribe(_ topic: String) {
        let sub = Subscribe(sub: topic, id: generateID())
        sendMessage(sub)
    }
    
    public func unSubscribe(_ topic: String) {
        let unsub = UnSubscribe(unsub: topic, id: generateID())
        sendMessage(unsub)
    }
    
    fileprivate func sendMessage<T: Codable>(_ message: T) {
        if let encode = try? JSONEncoder().encode(message),
            let json = String(data: encode, encoding: .utf8) {
            self.webSocket?.write(string: json)
        } else {
            print("subscribe error......")
        }
    }
    
    fileprivate func generateID() -> String {
        let time = Int64((Date().timeIntervalSince1970 * 1000).rounded())
        return String(time)
    }
    
    struct Subscribe: Codable {
        let sub: String
        let id: String
    }
    
    struct UnSubscribe: Codable {
        let unsub: String
        let id: String
    }
}

extension HuobiSocket: WebSocketDelegate {
    
    public func websocketDidConnect(socket: WebSocketClient) {
        print("websocketDidConnect")
        self.delegate?.huobiSocketDidConnected(self)
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        //print("websocketDidReceiveData")
        if data.isGzipped {
            if let decompressedData = try? data.gunzipped(),
                let content = String(data: decompressedData, encoding: .utf8) {
                if content.hasPrefix("{\"ping") {
                    let msg = content.replacingOccurrences(of: "ping", with: "pong")
                    self.webSocket?.write(string: msg)
                    return;
                }
                
                do {
                    let obj = try JSONDecoder().decode(HBKLine.self, from: decompressedData)
                    self.delegate?.huobiSocket(self, didReceiveKLine: obj)
                } catch(let err) {
                    print(content)
                    print(err.localizedDescription)
                }
            }
        }
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect")
        self.delegate?.huobiSocket(self, didDisConnectError: error)
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
    }
}