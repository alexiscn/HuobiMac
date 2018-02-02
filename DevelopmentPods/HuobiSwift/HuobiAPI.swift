//
//  HuobiAPI.swift
//  Pods
//
//  Created by xushuifeng on 27/01/2018.
//

import Foundation
import GenericNetworking

public class HuobiAPI {
    
    fileprivate static let baseURLString = "https://api.huobi.pro"
    
    /// 网页版登录后，创建
    internal static var apikey: String?
    
    /// 网页端登录后，创建
    internal static var secretkey: String?
    
    /// 配置HuoboAPI的参数
    ///
    /// - Parameters:
    ///   - apiKey: APIKEY 可以在火币网页版 安全中心 - API 访问中申请
    ///   - secretKey: SecretKey为用户对请求进行签名的密钥
    public class func configurate(with apiKey: String, secretKey: String) {
        HuobiAPI.apikey = apiKey
        HuobiAPI.secretkey = secretKey
        GenericNetworking.baseURLString = baseURLString
    }
    
    /// 获取K线数据
    ///
    /// - Parameters:
    ///   - symbol: 交易对, btcusdt, bchbtc, rcneth ...
    ///   - period: K线类型
    ///   - size: 获取数量, 默认值：150
    ///   - completion: 请求回调
    public class func getHistoryKLine(symbol: HBSymbol, period: HBPeroid, size: Int = 150, completion: @escaping GenericNetworkingCompletion<HBKLineResponse>) {
        let path = "/market/history/kline"
        var params: [String: Any] = [:]
        params["symbol"] = symbol.rawValue
        params["period"] = period.rawValue
        params["size"] = size
        DispatchQueue.global(qos: .background).async {
            GenericNetworking.getJSON(path: path, parameters: params, completion: completion)
        }
    }

    /// 获取聚合行情(Ticker)
    ///
    /// - Parameters:
    ///   - symbol: 交易对, btcusdt, bchbtc, rcneth ...
    ///   - completion: 请求回调
    public class func getMarketDetailMerged(symbol: HBSymbol, completion: @escaping GenericNetworkingCompletion<HBMarketDetailMergedResponse>) {
        let path = "/market/detail/merged"
        let params = ["symbol": symbol.rawValue]
        GenericNetworking.getJSON(path: path, parameters: params, completion: completion)
    }
 
    
    /// 获取 Market Depth 数据
    ///
    /// - Parameters:
    ///   - symbol: 交易对, btcusdt, bchbtc, rcneth ...
    ///   - depth: Depth 类型, step0, step1, step2, step3, step4, step5（合并深度0-5）；step0时，不合并深度
    ///   - completion: 请求回调
    public class func getMarketDepth(symbol: HBSymbol, depth: HBDepthStep, completion: @escaping GenericNetworkingCompletion<HBDepthResponse>) {
        let path = "/market/depth"
        let params = ["symbol": symbol.rawValue, "type": depth.rawValue]
        GenericNetworking.getJSON(path: path, parameters: params, completion: completion)
    }
    
    
    /// 获取 Trade Detail 数据
    ///
    /// - Parameters:
    ///   - symbol: 交易对, btcusdt, bchbtc, rcneth ...
    ///   - completion: 请求回调
    public class func getMarketTradeDetail(symbol: HBSymbol, completion: @escaping GenericNetworkingCompletion<HBTradeDetailResponse>) {
        let path = "/market/trade"
        let params = ["symbol": symbol.rawValue]
        GenericNetworking.getJSON(path: path, parameters: params, completion: completion)
    }
    
    
    /// 批量获取最近的交易记录
    ///
    /// - Parameters:
    ///   - symbol: 交易对, btcusdt, bchbtc, rcneth ...
    ///   - size: 获取交易记录的数量, 默认值 1, 取值范围: [1-2000]
    ///   - completion: 请求回调
    public class func getMarketHistoryTrade(symbol: HBSymbol, size: Int = 1, completion: @escaping GenericNetworkingCompletion<HBHistoryTradeResponse>) {
        let path = "/market/history/trade"
        let params: [String: Any] = ["symbol": symbol.rawValue, "size": size]
        GenericNetworking.getJSON(path: path, parameters: params, completion: completion)
    }
}

// MARK: - Common API
extension HuobiAPI {
    
    ///  查询系统支持的所有交易对及精度
    ///
    /// - Parameter completion: 请求回调
    public class func getSymbols(completion: @escaping GenericNetworkingCompletion<HBSupportSymbols>) {
        let path = "/v1/common/symbols"
        GenericNetworking.getJSON(path: path, completion: completion)
    }
    
    /// 查询系统支持的所有币种
    ///
    /// - Parameter completion: 请求回调
    public class func getCurrencys(completion: @escaping GenericNetworkingCompletion<HBCurrencys>) {
        let path = "/v1/common/currencys"
        GenericNetworking.getJSON(path: path, completion: completion)
    }
    
    /// 查询系统当前时间
    ///
    /// - Parameter completion: 请求回调
    public class func getServerTimestamp(completion: @escaping GenericNetworkingCompletion<HBServerTimestamp>) {
        let path = "/v1/common/timestamp"
        GenericNetworking.getJSON(path: path, completion: completion)
    }
}


// MARK: - Account API
extension HuobiAPI {
    
    
    /// 查询当前用户的所有账户(即account-id)
    ///
    /// - Parameter completion: 请求回调
    public class func getAccounts(completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/v1/account/accounts"
        let encodedPath = HuobiAPISignature.queryStringFor(path: path, method: .get, params: [:])
        GenericNetworking.getJSON(path: encodedPath, completion: completion)
    }
    
    
    /// 查询指定账户的余额
    ///
    /// - Parameters:
    ///   - accountID: ccount-id，填在 path 中，可用 GET /v1/account/accounts 获取
    ///   - completion: 请求回调
    public class func getAccountBalance(accountID: String, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/v1/account/accounts/\(accountID)/balance"
        let encodedPath = HuobiAPISignature.queryStringFor(path: path, method: .get, params: [:])
        GenericNetworking.getJSON(path: encodedPath, completion: completion)
    }
    
}


// MARK: - Order API
extension HuobiAPI {
    
    
    /// 下单
    ///
    /// - Parameters:
    ///   - accountID: 账户 ID，使用accounts方法获得。币币交易使用‘spot’账户的accountid；借贷资产交易，请使用‘margin’账户的accountid
    ///   - amount: 限价单表示下单数量，市价买单时表示买多少钱，市价卖单时表示卖多少币
    ///   - price: 下单价格，市价单不传该参数
    ///   - source: 订单来源
    ///   - symbol: 交易对
    ///   - type: 订单类型
    ///   - completion: 请求回调
    public class func placeOrder(accountID: String, amount: String, price: String?, source: String?, symbol: HBSymbol, type: HBTradeType, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/v1/order/orders/place"
        
        var params: [String: String] = [:]
        params["account-id"] = accountID
        params["amount"] = amount
        if type == .sellLimit || type == .buyLimit {
            params["price"] = price
        }
        if let source = source {
            params["source"] = source
        }
        params["symbol"] = symbol.rawValue
        params["type"] = type.rawValue
        
        let encodedPath = HuobiAPISignature.queryStringFor(path: path, method: .post, params: params)
        GenericNetworking.postJSON(path: encodedPath, parameters: params, completion: completion)
    }
    
    
    /// 申请撤销一个订单请求
    ///
    /// - Parameters:
    ///   - orderID: 订单ID，填在path中
    ///   - completion: 请求回调
    public class func cancelOrder(orderID: String, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/v1/order/orders/\(orderID)/submitcancel"
        let params = ["order-id": orderID]
        let encodedPath = HuobiAPISignature.queryStringFor(path: path, method: .post, params: params)
        GenericNetworking.postJSON(path: encodedPath, parameters: params, completion: completion)
    }
    
    
    
    /// 查询当前委托、历史委托
    ///
    /// - Parameters:
    ///   - symbol: 交易对
    ///   - states: 查询的订单状态组合，使用','分割
    ///   - types: 查询的订单类型组合，使用','分割
    ///   - startDate: 查询开始日期
    ///   - endDate: 查询结束日期
    ///   - fromID: 查询起始 ID
    ///   - size: 查询记录大小
    ///   - direction: 查询方向
    ///   - completion: 请求回调
    public class func getOrders(symbol: HBSymbol,
                                states: [HBOrderState],
                                types: [HBTradeType]?,
                                startDate: Date?,
                                endDate: Date?,
                                fromID: String?,
                                size: Int?,
                                direction: HBOrderDirection?, completion: @escaping GenericNetworkingCompletion<Int>) {
        
        func formatDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            let timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.timeZone = timeZone!
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        
        let path = "/v1/order/orders"
        var params: [String: String] = [:]
        params["symbol"] = symbol.rawValue
        params["states"] = states.map({ return $0.rawValue }).joined(separator: ",")
        if let types = types {
            params["types"] = types.map({ return $0.rawValue }).joined(separator: ",")
        }
        if let startDate = startDate {
            params["start-date"] = formatDate(startDate)
        }
        if let endDate = endDate {
            params["end-date"] = formatDate(endDate)
        }
        if let fromID = fromID {
            params["from"] = fromID
        }
        if let size = size {
            params["size"] = String(size)
        }
        if let direct = direction {
            params["direct"] = direct.rawValue
        }
        let encodedPath = HuobiAPISignature.queryStringFor(path: path, method: .get, params: params)
        GenericNetworking.postJSON(path: encodedPath, parameters: params, completion: completion)
    }
}


// MARK: - 借贷交易API
extension HuobiAPI {
    
    
    /// 申请提现虚拟币
    ///
    /// - Parameters:
    ///   - address: 提现地址
    ///   - amount: 提币数量
    ///   - currency: 资产类型
    ///   - fee: 转账手续费
    ///   - addrTag: 虚拟币共享地址tag，XRP特有
    ///   - completion: 请求回调
    public class func createWithdraw(address: String, amount: String, currency: String, fee: String?, addrTag: String?, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/v1/dw/withdraw/api/create"
        var params: [String: String] = [:]
        params["address"] = address
        params["amount"] = amount
        params["currency"] = currency
        if let f = fee { params["fee"] = f  }
        if let tag = addrTag { params["addr-tag"] = tag }
        let encodedPath = HuobiAPISignature.queryStringFor(path: path, method: .post, params: params)
        GenericNetworking.postJSON(path: encodedPath, parameters: params, completion: completion)
    }
    
    
    /// 申请取消提现虚拟币
    ///
    /// - Parameter withdrawId: 提现ID，填在path中
    public class func cancelWithdraw(_ withdrawId: Int64, completion: @escaping GenericNetworkingCompletion<Int>) {
        let path = "/v1/dw/withdraw-virtual/\(withdrawId)/cancel"
        let params = ["withdraw-id": withdrawId]
        let encodedPath = HuobiAPISignature.queryStringFor(path: path, method: .post, params: params)
        GenericNetworking.postJSON(path: encodedPath, parameters: params, completion: completion)
    }
    
}
