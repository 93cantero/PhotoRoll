//
//  ImageCache.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 18/5/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

class ImageCache {

    static let sharedCache : NSCache = {
        let cache = NSCache()
        cache.name = "ImageCache"
        cache.countLimit = 100 //Maximum of 100 images on cache
        return cache
    }()
    
}


protocol ImageCellProtocol {
    
    associatedtype ImageCacheCompletion = UIImage -> Void
    
}

private var xoAssociationKey: UInt8 = 0

extension UIImageView {
    
    var currentImageTask : NSURLSessionTask? {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? NSURLSessionTask
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //Retrieves the pre-cached image, or nil if it isn't cached
    func retrieveCachedImage(urlString: String) -> UIImage?{
        return ImageCache.sharedCache.objectForKey(urlString) as? UIImage
    }

    //Fetched the image from the network and stores it in the cache if successful
    //Only calls completion on successful image download.
    func imageFromUrl(urlString: String!) {
        let cachedImage = retrieveCachedImage(urlString)
        
        //Check if the image is already cached
        if let img = cachedImage {
            self.image = img
        } else {
            self.image = nil
            let url = NSURL(string: urlString)!
            //Download the image
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
                data, response, error in
                if error == nil {
                    if let data = data , image = UIImage(data: data){
                            ImageCache.sharedCache.setObject(image, forKey: urlString, cost: data.length)
                            dispatch_async(dispatch_get_main_queue()) {
                                self.image = image
                            }
                    }
                }
            }
            currentImageTask = task
            task.resume()
        }
        
    }
    
    func imageFromUrl(urlString: String!, placeHolder: String) {
        self.image = UIImage(named: placeHolder)
        imageFromUrl(urlString)
    }

}