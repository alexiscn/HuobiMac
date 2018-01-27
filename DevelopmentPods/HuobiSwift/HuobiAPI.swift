//
//  HuobiAPI.swift
//  Pods
//
//  Created by xushuifeng on 27/01/2018.
//

import Foundation
import GenericNetworking

class HuobiAPI {
    
    static let baseURLString = "https://api.huobi.pro"
    
    /// 获取K线数据
    ///
    /// - Parameters:
    ///   - symbol: 交易对, btcusdt, bchbtc, rcneth ...
    ///   - period: K线类型
    ///   - size: 获取数量, 默认值：150
    ///   - completion: 请求回调
    static func getHistoryKLine(symbol: HBSymbol, period: HBPeroid, size: Int = 150, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/market/history/kline"
        var params: [String: Any] = [:]
        params["symbol"] = symbol.rawValue
        params["period"] = period.rawValue
        params["size"] = size
        GenericNetworking.requestJSON(path: path, parameters: params, completion: completion)
    }

    /// 获取聚合行情(Ticker)
    ///
    /// - Parameters:
    ///   - symbol: 交易对, btcusdt, bchbtc, rcneth ...
    ///   - completion: 请求回调
    public static func getMerged(symbol: HBSymbol, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/market/detail/merged"
        let params = ["symbol": symbol.rawValue]
        GenericNetworking.requestJSON(path: path, parameters: params, completion: completion)
    }
 
    
    /// 获取 Market Depth 数据
    ///
    /// - Parameters:
    ///   - symbol: 交易对, btcusdt, bchbtc, rcneth ...
    ///   - depth: Depth 类型, step0, step1, step2, step3, step4, step5（合并深度0-5）；step0时，不合并深度
    ///   - completion: 请求回调
    public static func getMarketDepth(symbol: HBSymbol, depth: HBDepthStep, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/market/depth"
        let params = ["symbol": symbol.rawValue, "depth": depth.rawValue]
        GenericNetworking.requestJSON(path: path, parameters: params, completion: completion)
    }
    
    
    /// 获取 Trade Detail 数据
    ///
    /// - Parameters:
    ///   - symbol: 交易对, btcusdt, bchbtc, rcneth ...
    ///   - completion: 请求回调
    public static func getMarketTradeDetail(symbol: HBSymbol, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/market/trade"
        let params = ["symbol": symbol.rawValue]
        GenericNetworking.requestJSON(path: path, parameters: params, completion: completion)
    }
    
    
    /// 批量获取最近的交易记录
    ///
    /// - Parameters:
    ///   - symbol: 交易对, btcusdt, bchbtc, rcneth ...
    ///   - size: 获取交易记录的数量, 默认值 1, 取值范围: [1-2000]
    ///   - completion: 请求回调
    public static func getMarketHistoryTrade(symbol: HBSymbol, size: Int = 1, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/market/history/trade"
        let params: [String: Any] = ["symbol": symbol.rawValue, "size": size]
        GenericNetworking.requestJSON(path: path, parameters: params, completion: completion)
    }
}

// MARK: - Common API
extension HuobiAPI {
    
    ///  查询系统支持的所有交易对及精度
    ///
    /// - Parameter completion: 请求回调
    public static func getSymbols(completion: @escaping GenericNetworkingCompletion<HBSupportSymbols>) {
        let path = "/v1/common/symbols"
        GenericNetworking.requestJSON(baseURLString: baseURLString, path: path, completion: completion)
    }
    
    /// 查询系统支持的所有币种
    ///
    /// - Parameter completion: 请求回调
    public static func getCurrencys(completion: @escaping GenericNetworkingCompletion<HBCurrencys>) {
        let path = "/v1/common/currencys"
        GenericNetworking.requestJSON(baseURLString: baseURLString, path: path, completion: completion)
    }
    
    /// 查询系统当前时间
    ///
    /// - Parameter completion: 请求回调
    public static func getServerTimestamp(completion: @escaping GenericNetworkingCompletion<HBServerTimestamp>) {
        let path = "/v1/common/timestamp"
        GenericNetworking.requestJSON(baseURLString: baseURLString, path: path, completion: completion)
    }
}


// MARK: - Account API
extension HuobiAPI {
    
}


// MARK: - Order API
extension HuobiAPI {
    
}
