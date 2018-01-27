//
//  Models.swift
//  HuobiMac
//
//  Created by xu.shuifeng on 19/01/2018.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import HuobiSwift

struct SymbolTarget {
    let symbol: String
    let first: String
    let last: String
}

extension HBKLine {
    var symbol: SymbolTarget {
        let components = ch.split(separator: Character("."))
        let text = String(components[1])
        let targets = ["usdt", "btc", "eth"]
        for t in targets {
            if text.hasSuffix(t) {
                let first = text.replacingOccurrences(of: t, with: "")
                return SymbolTarget(symbol: text, first: first, last: t)
            }
        }
        return SymbolTarget(symbol: "btcusdt", first: "btc", last: "usdt")
    }
}

enum Symbol: String {
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
    
    
    static func usdtSymbols() -> [Symbol] {
        return [.btcusdt, .bchusdt, .xrpusdt, .ethusdt, .ltcusdt, .dashusdt, .eosusdt, .etcusdt, .omgusdt]
    }
    
    static func btcSymbols() -> [Symbol] {
        return [.ethbtc, .ltcbtc, .etcbtc]
    }
}






