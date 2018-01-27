//
//  HuobiResponseModel.swift
//  HuobiSwift
//
//  Created by xushuifeng on 27/01/2018.
//

import Foundation

// MARK: - Market Response



// MARK: - Common Response

public struct HBCurrencys: Codable {
    let status: String
    let data: [String]
}

public struct HBServerTimestamp: Codable {
    let status: String
    let data: Int64
}

public struct HBSupportSymbols: Codable {
    let status: String
    let data: [HBSupportSymbol]
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
    let baseCurrency: String
    /// 计价币种
    let quoteCurrency: String
    /// 价格精度位数（0为个位）
    let pricePrecision: String
    /// 数量精度位数（0为个位）
    let amountPrecision: String
    /// 交易区,main主区，innovation创新区，bifurcation分叉区
    let symbolPartition: String
}
