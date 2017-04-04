//
//  PhotosTimelineModels.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit
import CoreData

struct Photos {
    internal struct DisplayedMedia {
        var imageId: String
        var name: String
        var desc: String
        var createdAt: String
        var category: String
        var imageUrl: String
        var highQualityImageUrl: String?
        var width: Int
        var height: Int
    }

    //Media
    struct FetchMedia {

        struct Request {}
        struct Response {
            var media: [Media]
        }
        struct ViewModel {
            var displayedMedia: [DisplayedMedia]
        }
    }

    //Image
    struct FetchImage {
        struct Request {
            var id: Int?
            var imageUrl: String?
            init(id: Int) {
                self.id = id
            }
            init(imageUrl: String) {
                self.imageUrl = imageUrl
            }
        }
        struct Response {
            var dataImage: Data?
        }

        struct ViewModel {
            var image: UIImage
        }
    }
}

//Measured on Pixels
enum MediaDimensions {
    
    case longestEdge(LongestEdgePx)
    case croppedSize(CroppedSize)
    case maxHeight(MaxHeight)
    
    enum LongestEdgePx: Int {
        case nineHundred = 4
        case oneThousandSeventy = 5
        case twoHundredFiftySix = 30
        case oneThousandEighty = 1080
        case oneThousandSixHundred = 1600
        case twoThousandFourtyEight = 2048
    }
    
    enum CroppedSize: Int {
        case seventy = 1
    }
    
    enum MaxHeight: Int {
        case fourHundredFifty = 31
        case sixHundred = 21
    }
    
    init?(fromRawValue rawValue: Int) {
        
        if let l = LongestEdgePx(rawValue: rawValue) {
            self = MediaDimensions.longestEdge(l)
        } else if let c = CroppedSize(rawValue: rawValue) {
            self = MediaDimensions.croppedSize(c)
        } else if let m = MaxHeight(rawValue: rawValue) {
            self = MediaDimensions.maxHeight(m)
        } else {
            return nil
        }
    }
}

extension MediaDimensions: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .longestEdge(let l):
            return "\(l.rawValue)"
        case .croppedSize(let c):
            return "\(c.rawValue)"
        case .maxHeight(let m):
            return "\(m.rawValue)"
        }
    }
}

extension MediaDimensions :Equatable {}

func == (lhs: MediaDimensions, rhs: MediaDimensions) -> Bool {
    switch (lhs, rhs) {
    case (.croppedSize(let lKey), .croppedSize(let rKey)) where lKey == rKey:
        return true
    case (.longestEdge(let lKey), .longestEdge(let rKey)) where lKey == rKey:
        return true
    case (.maxHeight(let lKey), .maxHeight(let rKey)) where lKey == rKey:
        return true
    default:
        return false
    }
}


/*
 images = [
             {
             format = jpeg;
             "https_url" = "https://drscdn.500px.org/photo/200830933/w%3D70_h%3D70/ac9812166edfe77e03b8ab4e3f161ac1?v=0";
             size = 1;
             url = "https://drscdn.500px.org/photo/200830933/w%3D70_h%3D70/ac9812166edfe77e03b8ab4e3f161ac1?v=0";
             }
          ]
 */

struct Media: StructDecoder {
    var imageId: Int
    var name: String
    var desc: String?
    ///ISO 8601 format
    var createdAt: String = ""
    var category: Int//MAKE IT AN ENUM
    var width: Int
    var height: Int
    var imageUrl: String
    var images: [Image]?

    //TODO: Throw an error if the key does not exists
    static func parseWithDictionary(_ notCommonKeys: [String:String]?, json: [String: Any]) -> Media {

        var images: [Image]? = .none
        if let jsonImages = json[notCommonKeys?["images"] ?? "images"] as? [JSONObject] {
             images = jsonImages.map { return Image(withJson: $0 ) }
        }
        
        let media = Media(imageId: json[notCommonKeys?["id"] ?? "id"] as! Int,
                          name: json[notCommonKeys?["name"] ?? "name"] as! String,
                          desc: json[notCommonKeys?["desc"] ?? "desc"] as? String,
                          createdAt: json[notCommonKeys?["created_at"] ?? "created_at"] as! String,
                          category: json[notCommonKeys?["category"] ?? "category"] as! Int,
                          width: json[notCommonKeys?["width"] ?? "width"] as! Int,
                          height: json[notCommonKeys?["height"] ?? "height"] as! Int,
                          imageUrl: json[notCommonKeys?["image_url"] ?? "image_url"] as! String,
                          images: images)

        return media
    }
    
    enum ImageFormat: String{
        case jpeg = "jpeg"
        case png = "png"
    }
    struct Image {
        var format: ImageFormat
        var httpsUrl: String?
        var size: MediaDimensions
        var url: String
        
        init(format: ImageFormat, httpsUrl: String?, size: MediaDimensions, url: String) {
            self.format = format
            self.httpsUrl = httpsUrl
            self.size = size
            self.url = url
        }
        
        init(withJson json: JSONObject) {
            var format = ImageFormat.jpeg
            if let jf = json["format"] as? String, let f = ImageFormat(rawValue: jf) {
                format = f
            }
            
            var size = MediaDimensions.maxHeight(.fourHundredFifty)
            if let js = json["size"] as? Int, let s = MediaDimensions(fromRawValue: js) {
                size = s
            }
            
            self.init(format: format,
                      httpsUrl: json["https_url"] as? String,
                      size: size,
                      url: json["url"] as! String)
        }
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
