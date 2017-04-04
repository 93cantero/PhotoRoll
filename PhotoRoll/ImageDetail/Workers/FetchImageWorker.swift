//
//  FetchImageWorker.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit

class FetchImageWorker {

    internal var storeEnv: StoreEnv
    lazy var client: BaseClientAPI = {
        return BaseClientAPI()
    }()

    init(storeEnv environment: StoreEnv) {
        storeEnv = environment
    }

    func fetchImage(_ target: TargetAPI, completionHandler: @escaping (_ inner: () throws -> Media) -> Void) {
        switch storeEnv {
        case .stage:
            completionHandler({ () -> Media in
                let tuple = self.getPaths(target)

                return try self.parseMedia(target.sampleJSON, tuple: tuple)
            })

        case .live:
            client.get(target) { (success, object) -> Void in
                if success {
                    //GOOD API CALL
                    //Parse
                    let tuple = self.getPaths(target)
                    print(object)

                    completionHandler({ () -> Media in
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

    enum DummyError: Error {
        case nothing
    }

    //TODO: Throw error when a key is not found
    fileprivate func parseMedia(_ json: JSONObject, tuple : (notCommonKeys: [String:String]?, mediaPath: String)) throws -> Media {

        guard let obj = (json[tuple.mediaPath]  as? [String : AnyObject]) else { throw DummyError.nothing/*throw Error*/ }

        return Media.parseWithDictionary(tuple.notCommonKeys, json: obj)
    }

    fileprivate func getPaths(_ target: TargetAPI) -> (notCommonKeys: [String:String]?, mediaPath: String) {
        var dict: [String:String]?
        var mediaPath: String
        if (target is FiveHundredPx) {
            dict = ["desc": "description"]
            mediaPath = "photo"
        } else {
            mediaPath = "photo"
        }

        return (dict, mediaPath)
    }

}
