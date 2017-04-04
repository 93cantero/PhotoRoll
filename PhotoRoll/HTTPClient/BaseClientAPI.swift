//
//  ClientAPI.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import Foundation

enum JSONType {
    case jsonNumber(NSNumber)
    case jsonString(String)
    case jsonBool(Bool)
    case jsonNull
    case jsonArray(Array<JSONType>)
    case jsonObject(Dictionary<String, JSONType>)
    case jsonInvalid(NSError)
}

typealias JSONObject = [String:Any]

protocol TargetAPI {
    var BaseURL: String { get }
    var parameters: [String : Any]? { get }
    var path: String { get }
    var sampleJSON: JSONObject { get }
}

extension TargetAPI {
    var description: String { return self.BaseURL + self.path }
}

/** Allows to extend functionality to several APIs that ends on the same resulting object.
 *
 */
protocol APISupport {
    var type: [APIType]? { set get }
}

protocol APIType {
    var notCommonKeys: Dictionary<String, String> { get }
}

// MARK: CLIENT
class BaseClientAPI {

    internal class CustomSession: NSObject, URLSessionDelegate {
        @objc internal func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential)
            }
        }
    }

    // MARK: private composition methods
    internal func post(_ target: TargetAPI, params: Dictionary<String, Any>? = nil, completion: @escaping (_ success: Bool, _ object: Any?) -> Void) {
        dataTask(clientURLRequest(target), method: "POST", completion: completion)
    }

    internal func put(_ target: TargetAPI, params: Dictionary<String, Any>? = nil, completion: @escaping (_ success: Bool, _ object: Any?) -> Void) {
        dataTask(clientURLRequest(target), method: "PUT", completion: completion)
    }

    internal func get(_ target: TargetAPI, params: Dictionary<String, Any>? = nil, completion: @escaping (_ success: Bool, _ object: Any?) -> Void) {
        dataTask(clientURLRequest(target), method: "GET", completion: completion)
    }

    fileprivate func dataTask(_ request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: Any?) -> Void) {
        request.httpMethod = method

//        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: CustomSession(), delegateQueue: nil)

//        let session = URLSession.shared

        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        let session = URLSession(configuration: configuration)
        defer {
            session.finishTasksAndInvalidate()
        }
        
        session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    print(response)
                    DispatchQueue.main.async(execute: {
                        completion(true, json)
                    })
                } else {
                    print(json)
                    DispatchQueue.main.async(execute: {
                        completion(false, json)
                    })
                }
            } else if let err = error {
                DispatchQueue.main.async(execute: {
                    completion(false, err.localizedDescription)
                })
            }
            } .resume()
    }

    fileprivate func clientURLRequest(_ target: TargetAPI) -> NSMutableURLRequest {

        let request = NSMutableURLRequest(url: URL(string: "\(target.BaseURL)\(target.path)")!)
        if let params = target.parameters {
            var paramString = ""
            for (key, value) in params {
                let escapedKey = key.URLEscapedString
                let escapedValue = (value as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                paramString += "\(escapedKey)=\(escapedValue!)&"
            }

            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = paramString.data(using: String.Encoding.utf8)
        }

        return request
    }
}
