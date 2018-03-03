//
//  File.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import Foundation

// MARK: INSTAGRAM 
//enum Instagram {
//    case Authorize
//    case Posts
////    case PostById(Int)
//}
//
//extension Instagram : TargetAPI, CustomStringConvertible {
//    var BaseURL : String { return "https://api.instagram.com/" }
//    var accessToken : String { return "" }
//    var clientId : String { return "0aa60a750cee47d5bf2aac280ead91f2" }
//    
//    var parameters : [String : AnyObject]? {
//        get {
//            switch self {
//            case .Posts:
//                return nil
//            case .Authorize:
//                return ["client_id" : clientId]
//            }
//        }
//    }
//    
//    var path : String {
//        switch self {
//        case .Posts:
//            return "posts"
//        case .Authorize:
//            return "oauth/authorize/"
//        }
//    }
//    
//    var sampleData : NSData {
//        switch self {
//        case .Posts:
//            return "".UTF8EncodedData
//        case .Authorize:
//            return "".UTF8EncodedData
//        }
//    }
//}

// MARK: 500px
enum FiveHundredPx {
    case popularPhotos(sized: [MediaDimensions]?)
    case photo(Int)
}

extension FiveHundredPx : TargetAPI, CustomStringConvertible {
    var BaseURL: String { return "https://api.500px.com/v1/" }
    var consumerKey: String { return "uKJSNSC9mE3PzuWiYoSX7PcVokWFZ8rkxXB1AsAC" }
    var parameters: [String : Any]? {
        get {
            let params: [String : Any]? = [:]
            switch self {
//            case .PopularPhotos:
//                params?.updateValue("popular", forKey: "feature")
            default: break
            }

//            params?.updateValue(self.consumerKey, forKey: "consumer_key") as? [String: AnyObject]
            return params
        }
    }

    var path: String {
        switch self {
        case .popularPhotos(let sized):
            guard let s = sized else { return "photos/?feature=popular&consumer_key=\(self.consumerKey)" }
            let imageSize = s.reduce("") { return "\($0)\($0 != "" ? "," : "")\($1)" }
            return "photos/?feature=popular&consumer_key=\(self.consumerKey)&image_size=\(imageSize)"
        case .photo(let id):
            return "photos/\(id)?consumer_key=\(self.consumerKey)"
        }
    }

    var sampleJSON: JSONObject {
        switch self {
        case .popularPhotos (_):
            return ["feature": "popular", "filters": [ "category": false, "exclude": false ], "current_page": 1, "total_pages": 250, "total_items": 5000, "photos": [["id": 1, "name": "Orange or lemon", "description": "", "category": 0, "width": 472, "height": 709, "image_url": "http://pcdn.500px.net/4910421/c4a10b46e857e33ed2df35749858a7e45690dae7/2.jpg", "created_at" : "2007-06-29T09:34:19-04:00"]]]
        case .photo(_):
            return ["photo": ["id": 1, "name": "Orange or lemon", "description": "", "category": 0, "width": 472, "height": 709, "image_url": "http://pcdn.500px.net/4910421/c4a10b46e857e33ed2df35749858a7e45690dae7/2.jpg", "created_at" : "2007-06-29T09:34:19-04:00"]]
        }
    }
}

//TODO: Flicker
