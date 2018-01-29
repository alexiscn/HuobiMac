//
//  HuobiAPISignature.swift
//  HuobiSwift
//
//  Created by xushuifeng on 27/01/2018.
//

import Foundation
import Alamofire
import CommonCrypto

class HuobiAPISignature {
    
    static func sign(method: HTTPMethod, path: String, params: Parameters) -> String {
        
        let str = "\(method.rawValue)\n" +
            "api.huobi.pro\n" +
        "\(path)\n"
        
        
        
        // SignatureMethod=HmacSHA256&SignatureVersion=2&
        
        return ""
        
    }
    
}

