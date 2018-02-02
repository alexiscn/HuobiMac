//
//  HuobiAPITests.swift
//  HuobiMac
//
//  Created by xu.shuifeng on 29/01/2018.
//  Copyright © 2018 shuifeng. All rights reserved.
//

import Foundation
import HuobiSwift

class HuobiAPITests {
    
    public class func test() {
        
        HuobiAPI.configurate(with: "your_app_id", secretKey: "your_app_secret")
        
        // GET /market/history/kline 获取K线数据
        HuobiAPI.getHistoryKLine(symbol: HBSymbol.btcusdt, period: HBPeroid.day) { response in
            switch response {
            case .error(let error):
                print(error)
            case .success(let kline):
                print("/market/history/kline")
                print(" data count:\(kline.data.count)")
            }
        }
        
        // GET /market/detail/merged 获取聚合行情(Ticker)
        HuobiAPI.getMarketDetailMerged(symbol: .btcusdt) { response in
            switch response {
            case .error(let error):
                print(error)
            case .success(let merged):
                print("/market/detail/merged")
                print("asks count:\(merged.tick.ask.count)")
            }
        }
        
        // GET  获取 Market Depth 数据
        HuobiAPI.getMarketDepth(symbol: .btcusdt, depth: .step1) { (response) in
            switch response {
            case .error(let error):
                print(error)
            case .success(let depth):
                print("/market/depth")
                print("depth:\(depth.tick)")
            }
        }
        
        // GET /market/trade 获取 Trade Detail 数据
        HuobiAPI.getMarketTradeDetail(symbol: .btcusdt) { response in
            switch response {
            case .error(let error):
                print(error)
            case .success(let detail):
                print("/market/depth")
                print("depth:\(detail.tick)")
            }
        }
        
        // GET /v1/common/symbols 查询系统支持的所有交易对及精度
        HuobiAPI.getSymbols { (response) in
            switch response {
            case .error(let error):
                print(error)
            case .success(let symbols):
                // do something with symbols
                // symbols is typeof HBSupportSymbols
                print(symbols.status)
            }
        }
    }
    
}
