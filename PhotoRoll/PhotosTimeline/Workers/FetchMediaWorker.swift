//
//  FetchMediaWorker.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 17/3/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

//protocol MediaStoreProtocol {
//    func fetchMedia(target: TargetAPI, completionHandler: (inner: () throws -> [Media]) -> Void)
//}

enum StoreEnv {
    case Live
    case Stage
}

class FetchMediaWorker {
    
//    var mediaStoreProtocol : MediaStoreProtocol!
    
//    init(storeProtocol: MediaStoreProtocol){
//        //Constructor dependency injection
//        mediaStoreProtocol = storeProtocol
//    }
    internal var storeEnv : StoreEnv
    lazy var client : BaseClientAPI = {
       return BaseClientAPI()
    }()
    
    init(storeEnv environment: StoreEnv) {
        storeEnv = environment
    }
    
    //Mark: Bussiness logic
    func fetchMedia(target: TargetAPI, completionHandler: (inner: () throws -> [Media]) -> Void) {
        
        switch storeEnv {
        case .Stage:
            completionHandler(inner: { () -> [Media] in
                let tuple = self.getPaths(target)

                return try self.parseMedia(target.sampleJSON, tuple: tuple)
            })
            
        case .Live:
            client.get(target) { (success, object) -> Void in
                if success {
                    //GOOD API CALL
                    //Parse 
                    let tuple = self.getPaths(target)
                    print(object)
                    
                    completionHandler(inner: { () -> [Media] in
                        return try self.parseMedia(object as! JSONObject, tuple: tuple)
                    })
                } else {
                    //BAD API CALL
                    if let errorDict = object as? JSONObject {
                        print(errorDict)
                    }
                }
            }
        }
    }
    
    //TODO: Throw error when a key is not found
    private func parseMedia(json: JSONObject, tuple : (notCommonKeys: [String:String]?, mediaPath: String)) throws -> [Media] {
        
        guard let array = json[tuple.mediaPath] as? Array<AnyObject> else { return [] /*throw Error*/ }
        
        var mediaArray : [Media] = []
        for case let obj in array {
            mediaArray.append(Media.parseWithDictionary(tuple.notCommonKeys, json: obj as! JSONObject))
        }
//        Media.parseWithDictionary(dict, json: object as! [String:AnyObject])
        return mediaArray
    }
    
    private func getPaths(target: TargetAPI) -> (notCommonKeys: [String:String]?, mediaPath: String) {
        var dict : [String:String]?
        var mediaPath : String
        if (target is FiveHundredPx) {
            dict = ["desc": "description"]
            mediaPath = "photos"
        } else {
            mediaPath = "photos"
        }
        
        return (dict, mediaPath)
    }
}