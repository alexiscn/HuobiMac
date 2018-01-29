//
//  HuobiAPISignature.swift
//  HuobiSwift
//
//  Created by xushuifeng on 27/01/2018.
//

import Foundation
import Alamofire
import CommonCrypto

internal final class HuobiAPISignature {
    
    /// 对需要签名的API参数进行加密处理
    ///
    /// - Parameters:
    ///   - path: 请求API的path路径，如 /v1/order/orders
    ///   - method: 请求方法，取值：GET、POST
    ///   - params: 请求参数
    /// - Returns: 返回加密后的QueryString
    static func queryStringFor(path: String, method: HTTPMethod, params: Parameters) -> String {
    
        guard let appID = HuobiAPI.apikey, let secret = HuobiAPI.secretkey else {
            return ""
        }

        var tempParameters = params
        tempParameters["AccessKeyId"] = appID
        tempParameters["SignatureMethod"] = "HmacSHA256"
        tempParameters["SignatureVersion"] = "2"
        tempParameters["Timestamp"] = UTCTimeStamp
        
        // 使用Alamofire提供的方法进行QueryString
        let urlRequest = URLRequest(url: URL(string: "https://baidu.com/")!)
        let request = try! URLEncoding.default.encode(urlRequest, with: tempParameters)
        let queryString = request.url!.query!
        // 拼凑要加密的字符串，参考 https://github.com/huobiapi/API_Docs/wiki/REST_authentication#%E7%AD%BE%E5%90%8D%E8%BF%90%E7%AE%97
        let text = "\(method.rawValue)\n" + "api.huobi.pro\n" + "\(path)\n" + queryString
        let Signature = text.hmac(algorithm: .SHA256, key: secret)
        return queryString + "&Signature=" + Signature
    }
    
    /// 返回UTC时间
    static var UTCTimeStamp: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        let timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.timeZone = timeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: currentDate)
    }
}

