//
//  HuobiResponseModel.swift
//  HuobiSwift
//
//  Created by xushuifeng on 27/01/2018.
//

import Foundation

// MARK: - Market Response

/// K线
public struct HBKLine: Codable {
    public let ch: String
    public let ts: Int64
    public let tick: HBTick
}

/// K线详细数据
public struct HBTick: Codable {
    //K线id
    public let id: Int64
    //成交量
    public let amount: Double
    //成交笔数
    public let count: Int
    //开盘价
    public let open: Double
    //收盘价,当K线为最晚的一根时，是最新成交价
    public let close: Double
    //最低价
    public let low: Double
    //最高价
    public let high: Double
    //成交额, 即 sum(每一笔成交价 * 该笔的成交量)
    public let vol: Double
    
    public var rate: Double {
        let rate = ((close - open)/open) * 100.0
        return rate
    }
}

public struct HBDepthResponse: Codable {
    public let status: String
    public let ch: String
    public let ts: Int64
    public let tick: HBDepthTick
}

public struct HBDepthTick: Codable {
    public let id: Int64
    public let ts: Int64
    //买盘,[price(成交价), amount(成交量)], 按price降序
    public let bids: [[Double]]
    //卖盘,[price(成交价), amount(成交量)], 按price升序
    public let asks: [[Double]]
}

public struct HBTradeDetailResponse: Codable {
    public let status: String
    public let tick: HBTradeTicks
}

public struct HBTradeTicks: Codable {
    public let id: Int64
    public let ts: Int64
    public let data: [HBTradeTick]
}

public struct HBTradeTick: Codable {
    public let id: Int64
    public let price: Double
    public let amount: Double
    public let direction: String
    public let ts: Int64
}

public struct HBHistoryTradeResponse: Codable {
    public let status: String
    public let ch: String
    public let ts: Int64
    public let data: [HBTradeTicks]
}

/// 订阅失败错误
public struct SubscribeError: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case errCode = "err-code"
        case errorMsg = "err-msg"
        case ts
    }
    
    public let id: Int64
    public let status: String
    public let errCode: String
    public let errorMsg: String
    public let ts: Int64
}

// MARK: - Common Response

public struct HBCurrencys: Codable {
    public let status: String
    public let data: [String]
}

public struct HBServerTimestamp: Codable {
    public let status: String
    public let data: Int64
}

public struct HBSupportSymbols: Codable {
    public let status: String
    public let data: [HBSupportSymbol]
}

public struct HBSupportSymbol: Codable {
    
    enum CodingKeys: String, CodingKey {
        case baseCurrency = "base-currency"
        case quoteCurrency = "quote-currency"
        case pricePrecision = "price-precision"
        case amountPrecision = "amount-precision"
        case symbolPartition = "symbol-partition"
    }
    
    /// 基础币种
    public let baseCurrency: String
    /// 计价币种
    public let quoteCurrency: String
    /// 价格精度位数（0为个位）
    public let pricePrecision: String
    /// 数量精度位数（0为个位）
    public let amountPrecision: String
    /// 交易区,main主区，innovation创新区，bifurcation分叉区
    public let symbolPartition: String
}
