//
//  Models.swift
//  HuobiMac
//
//  Created by xu.shuifeng on 19/01/2018.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

enum Symbol: String {
    // usdt
    case btcusdt
    case ethusdt
    case ltcusdt
    case etcusdt
    case bccusdt
    // btc
    case ethbtc
    case ltcbtc
    case etcbtc
    
    // eth
    
}

enum Peroid: String {
    case minute1 = "1min"
    case minute5 = "5min"
    case minute15 = "15min"
    case minute30 = "30min"
    case hour = "60min"
    case day = "1day"
    case week = "1week"
    case month = "1mon"
    case year = "1year"
}


/// K线
struct KLine: Codable {
    let ch: String
    let ts: Int64
    let tick: Tick
    
    var symbol: String {
        let components = ch.split(separator: Character("."))
        return String(components[1])
    }
}

/// K线详细数据
struct Tick: Codable {
    //K线id
    let id: Int64
    //成交量
    let amount: Double
    //成交笔数
    let count: Int
    //开盘价
    let open: Double
    //收盘价,当K线为最晚的一根时，是最新成交价
    let close: Double
    //最低价
    let low: Double
    //最高价
    let high: Double
    //成交额, 即 sum(每一笔成交价 * 该笔的成交量)
    let vol: Double
    
    var rate: Double {
        let rate = ((close - open)/open) * 100.0
        return rate
    }
}

/// 订阅失败错误
struct SubscribeError: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case errCode = "err-code"
        case errorMsg = "err-msg"
        case ts
    }
    
    let id: Int64
    let status: String
    let errCode: String
    let errorMsg: String
    let ts: Int64
}
