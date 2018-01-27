//
//  HuobiModel.swift
//  HuobiSwift
//
//  Created by xushuifeng on 27/01/2018.
//

import Foundation



enum HBSymbol: String {
    // usdt
    case btcusdt
    case bchusdt
    case xrpusdt
    case ethusdt
    case ltcusdt
    case dashusdt
    case eosusdt
    case etcusdt
    case omgusdt
    
    // btc
    case ethbtc
    case ltcbtc
    case etcbtc
    
    // eth
    
    static func usdtSymbols() -> [HBSymbol] {
        return [.btcusdt, .bchusdt, .xrpusdt, .ethusdt, .ltcusdt, .dashusdt, .eosusdt, .etcusdt, .omgusdt]
    }
    
}

//K线类型
enum HBPeroid: String {
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

enum HBDepthStep: String {
    case step0, step1, step2, step3, step4, step5
}
