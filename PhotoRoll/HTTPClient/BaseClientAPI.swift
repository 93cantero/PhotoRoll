//
//  ClientAPI.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import Foundation


enum JSONType {
    case JSONNumber(NSNumber)
    case JSONString(String)
    case JSONBool(Bool)
    case JSONNull
    case JSONArray(Array<JSONType>)
    case JSONObject(Dictionary<String,JSONType>)
    case JSONInvalid(NSError)
}

typealias JSONObject = [String:AnyObject]

protocol TargetAPI {
    var BaseURL : String { get }
    var parameters : [String : AnyObject]? { get }
    var path : String { get }
    var sampleJSON : JSONObject { get }
}

extension TargetAPI {
    var description : String { return self.BaseURL + self.path }
}

/** Allows to extend functionality to several APIs that ends on the same resulting object.
 *
 */
protocol APISupport {
    var type : [APIType]? { set get }
}

protocol APIType {
    var notCommonKeys : Dictionary<String, String> { get }
}


//MARK: CLIENT
class BaseClientAPI {
    
    internal class CustomSession : NSObject, NSURLSessionDelegate {
        @objc internal func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
                completionHandler(.UseCredential,credential);
            }
        }
    }
    
    // MARK: private composition methods
    internal func post(target: TargetAPI, params: Dictionary<String, AnyObject>? = nil, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(clientURLRequest(target) , method: "POST", completion: completion)
    }
    
    internal func put(target: TargetAPI, params: Dictionary<String, AnyObject>? = nil, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(clientURLRequest(target) , method: "PUT", completion: completion)
    }
    
    internal func get(target: TargetAPI, params: Dictionary<String, AnyObject>? = nil, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(clientURLRequest(target) , method: "GET", completion: completion)
    }
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: (success: Bool, object: AnyObject?) -> ()) {
        request.HTTPMethod = method
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: CustomSession(), delegateQueue: nil)
        
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let data = data {
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                if let response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
                    print(response)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(success: true, object: json)
                    })
                } else {
                    print(json)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(success: false, object: json)
                    })
                }
            } else if let err = error {
                dispatch_async(dispatch_get_main_queue(), {
                    completion(success: false, object: err.localizedDescription)
                })
            }
            }.resume()
    }
    
    private func clientURLRequest(target: TargetAPI) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(target.BaseURL)\(target.path)")!)
        if let params = target.parameters {
            var paramString = ""
            for (key, value) in params {
                let escapedKey = key.URLEscapedString
                let escapedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                paramString += "\(escapedKey)=\(escapedValue!)&"
            }
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        return request
    }
}