//
//  HuobiModel.swift
//  HuobiSwift
//
//  Created by xushuifeng on 27/01/2018.
//

import Foundation

public enum HBSymbol: String {
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
public enum HBPeroid: String {
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

public enum HBDepthStep: String {
    case step0, step1, step2, step3, step4, step5
}



/// 订单类型
///
/// - buyMarket: 市价买
/// - sellMarket: 市价卖
/// - buyLimit: 限价买
/// - sellLimit: 限价卖
public enum HBTradeType: String {
    case buyMarket = "buy-market"
    case sellMarket = "sell-marke"
    case buyLimit = "buy-limit"
    case sellLimit = "sell-limit"
}


/// 查询的订单状态
///
/// - preSubmitted: 查询的订单状态
/// - submitted: 已提交
/// - partialFilled: 部分成交
/// - partialCanceled: 部分成交撤销
/// - filled: 完全成交
/// - canceled: 已撤销
public enum HBOrderState: String {
    case preSubmitted = "pre-submitted"
    case submitted = "submitted"
    case partialFilled = "partial-filled"
    case partialCanceled = "partial-canceled"
    case filled = "filled"
    case canceled = "canceled"
}


/// 查询方向
///
/// - prev: 向前
/// - next: 向后
public enum HBOrderDirection: String {
    case prev
    case next
}

