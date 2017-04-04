//
//  ImageCache.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 18/5/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import Foundation

class ImageCache {

    static let sharedCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.name = "ImageCache"
        cache.countLimit = 100 //Maximum of 100 images on cache
        return cache
    }()
}

