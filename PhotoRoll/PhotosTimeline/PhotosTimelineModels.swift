//
//  PhotosTimelineModels.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit
import CoreData

struct PhotosTimeline_FetchMedia_Request {}

struct PhotosTimeline_FetchMedia_Response {
    var media : [Media]
}

struct PhotosTimeline_FetchMedia_ViewModel {
    
    var displayedMedia : [DisplayedMedia]
    
    struct DisplayedMedia {
        var name : String
        var desc : String
        var createdAt : String
        var category : String
        var imageUrl : String
        var width : Int
        var height : Int
    }
}

struct Media : StructDecoder {
    var name : String
    var desc : String?
    var createdAt : NSDate = NSDate()
    var category : Int//MAKE IT AN ENUM
    var width : Int
    var height : Int
    var imageUrl : String
    
    
//    static var path: String! = "photos"
    
    //TODO: Throw an error if the key does not exists
    static func parseWithDictionary(notCommonKeys: [String:String]?, json: [String: AnyObject]) -> Media {
        
        let media = Media(name: json[notCommonKeys?["name"] ?? "name"] as! String,
                          desc: json[notCommonKeys?["desc"] ?? "desc"] as? String,
                          createdAt: NSDate(timeIntervalSince1970: json[notCommonKeys?["category"] ?? "category"] as! Double),
                          category: json[notCommonKeys?["category"] ?? "category"] as! Int,
                          width: json[notCommonKeys?["width"] ?? "width"] as! Int,
                          height: json[notCommonKeys?["height"] ?? "height"] as! Int,
                          imageUrl: json[notCommonKeys?["image_url"] ?? "image_url"] as! String)
        
//        media.name =
//        media.desc =
//        media.createdAt =
//        media.category =
//        media.width =
//        media.height =
//        media.imageUrl =
        
        
        return media
    }
}

//extension Media : JSONParselable {
//    static func withJSON(json: [String : AnyObject]) -> Media? {
//        return nil
//    }
//}

//extension Media : APISupport {
//
//    var type: [APIType]? {
//        get {
//            return [TypeFiveHundredPx.Media]
//        }
//        set {
//        }
//    }
//}
//
//enum TypeFiveHundredPx : APIType {
//    case Media
//    
//    var notCommonKeys : Dictionary<String, String> {
//        switch self {
//        case .Media:
//            return ["desc":"description"]
//        }
//    }
//}
