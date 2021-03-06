//
//  GenericNetworking.swift
//  GenericNetworking
//
//  Created by xu.shuifeng on 29/11/2017.
//

import Foundation
import Alamofire


/// HTTP request completion callback block
public typealias GenericNetworkingCompletion<T> = (GenericNetworkingResponse<T>) -> Void where T: Codable


/// GenericNetworkingResponse
///
/// - success: request successfully, with your provided type decoded
/// - error: some error occurs
public enum GenericNetworkingResponse<T> where T: Codable {
    case success(T)
    case error(GenericNetworkingError)
}


/// Networking error
///
/// - responseError: http response has an error.
/// - decodeError: `GenericNetworking` can not decode response into your type. please check members type.
/// - serverError: `GenericNetworking` do not known what's wrong with the request
/// - parameterError: `GenericNetworking` can not make a http request due to parameters error, eg: `baseURLString` missing
public enum GenericNetworkingError: Error {
    case responseError(DefaultDataResponse)
    case decodeError(Error, String)
    case serverError(String)
    case parameterError(String)
}


/// Just a simple wrapper around Alamofire with Codeable and Generic supports
///
/// See README for more information
open class GenericNetworking {
    
    /// server base host, eg: https://api.example.com
    public static var baseURLString: String?
    
    /// your can customize request headers, eg: your can add a common cookie for each request
    public static var defaultHeaders: HTTPHeaders?
    
    /// enable GenericNetworking print debugging information, default is `true`
    public static var enableDebugPrint: Bool = true
    
    
    /// make a GET request
    ///
    /// - Parameters:
    ///   - URLString: URLString
    ///   - completion: completion callback
    public class func getJSON<T>(URLString: String, completion: @escaping GenericNetworkingCompletion<T>) {
        requestJSON(URLString: URLString, method: .get, parameters: nil, headers: nil, completion: completion)
    }
    
    public class func getJSON<T>(path: String, completion: @escaping GenericNetworkingCompletion<T>) {
        requestJSON(path: path, method: .get, parameters: nil, headers: nil, completion: completion)
    }
    
    public class func getJSON<T>(path: String, parameters: Parameters, completion: @escaping GenericNetworkingCompletion<T>) {
        requestJSON(path: path, method: .get, parameters: parameters, headers: nil, completion: completion)
    }
    
    public class func getJSON<T>(path: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping GenericNetworkingCompletion<T>) {
        requestJSON(path: path, method: .get, parameters: parameters, headers: headers, completion: completion)
    }
    
    /// make a POST request
    ///
    /// - Parameters:
    ///   - URLString: URLString
    ///   - parameters: parameters
    ///   - headers: headers
    ///   - completion: completion callback
    public class func postJSON<T>(URLString: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping GenericNetworkingCompletion<T>) {
        requestJSON(URLString: URLString, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    
    /// make a request
    /// Note: if you want to use this function, make sure set `baseURLString` first
    ///
    /// - Parameters:
    ///   - path: request API path. eg: /gists
    ///   - parameters: parameters
    ///   - headers: HTTP Headers
    ///   - completion: completion callback
    public class func postJSON<T>(path: String, parameters: Parameters?, completion: @escaping GenericNetworkingCompletion<T>) {
        requestJSON(path: path, method: .post, parameters: parameters, headers: nil, completion: completion)
    }

    
    /// Request
    ///
    /// - Parameters:
    ///   - baseURLString: host URL string, eg: https://api.github.com
    ///   - path: request API path. eg: /gists
    ///   - method: HTTP Method, default is GET
    ///   - parameters: parameters
    ///   - headers: HTTP Headers
    ///   - completion: completion callback
    fileprivate class func requestJSON<T>(path: String, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping GenericNetworkingCompletion<T>) {
        guard let baseURLString = baseURLString else {
            let errorInfo = "[GenericNetworking] `baseURLString` is nil, make sure `baseURLString` is not nil before your call this function"
            let error = GenericNetworkingError.parameterError(errorInfo)
            let res = GenericNetworkingResponse<T>.error(error)
            completion(res)
            log(errorInfo)
            return
        }
        let urlString = baseURLString.appending(path)
        requestJSON(URLString: urlString, method: method, parameters: parameters, headers: headers, completion: completion)
    }
    
    fileprivate class func requestJSON<T>(URLString: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping GenericNetworkingCompletion<T>) {
        
        // configure HTTP Headers
        var httpHeaders: [String: String] = [:]
        if let header = defaultHeaders {
            httpHeaders = header
        }
        if let headers = headers {
            httpHeaders.merge(headers) { (current, new) in new }
        }
        
        Alamofire.request(URLString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: httpHeaders).response { (dataResponse) in
            
            if let error = dataResponse.error {
                let responseError = GenericNetworkingError.responseError(dataResponse)
                let res = GenericNetworkingResponse<T>.error(responseError)
                completion(res)
                log("[GenericNetworking] Response Error:\(error.localizedDescription) at URLString:\(URLString)")
                return;
            }
            
            // if we got data, try decode
            if let data = dataResponse.data {
                do {
                    let json = try JSONDecoder().decode(T.self, from: data)
                    let res = GenericNetworkingResponse<T>.success(json)
                    completion(res)
                } catch let error as NSError {
                    let responseText: String
                    if let responseString = String(data: data, encoding: String.Encoding.utf8) {
                        responseText = responseString
                    } else {
                        responseText = "can not convert response data to String"
                    }
                    let decodeError = GenericNetworkingError.decodeError(error, responseText)
                    let res = GenericNetworkingResponse<T>.error(decodeError)
                    completion(res)
                    let info = "[GenericNetworking] JSONDecoder error, origin response text is:\(responseText)"
                    log(info)
                }
                return;
            }
            
            let dataError = GenericNetworkingError.serverError("response data is nil")
            let res = GenericNetworkingResponse<T>.error(dataError)
            completion(res)
        }
    }
}

extension GenericNetworking {
    fileprivate class func log(_ text: String) {
        if enableDebugPrint {
            print(text)
        }
    }
}
