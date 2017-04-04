//
//  UIImageViewExtensions.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 01/03/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import UIKit
//import ImageIO

private var xoAssociationKey: UInt8 = 0

extension UIImageView {
    
    var currentImageTask: URLSessionTask? {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? URLSessionTask
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //Retrieves the pre-cached image, or nil if it isn't cached
    func retrieveCachedImage(_ urlString: String) -> UIImage? {
        return ImageCache.sharedCache.object(forKey: urlString as AnyObject) as? UIImage
    }
    
    //Fetched the image from the network and stores it in the cache if successful
    //Only calls completion on successful image download.
    func imageFrom(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cachedImage = self.retrieveCachedImage(urlString)
        //            let cachedImage = self?.retrieveCachedCGImage(urlString)
        
        //Check if the image is already cached
        if let img = cachedImage {
            // FIXME: White image appears for a second while changing the image to the original one
            DispatchQueue.main.async {
                completion(img)
            }
            //                self.layer.contents = img
        } else {
            //                self.image = nil
            let url = URL(string: urlString)!
            
            //                DispatchQueue.global(qos: .background).async { [weak self] in
            //                    let source : CGImageSource? = CGImageSourceCreateWithURL(url as CFURL, nil)
            //
            //                    guard let imageSource = source else { return }
            //
            //                    let dict: CFDictionary = [kCGImageSourceShouldCache as String : true,
            //                                              kCGImageSourceShouldCacheImmediately as String : true] as CFDictionary
            //
            //                    let ima : CGImage? = CGImageSourceCreateImageAtIndex(imageSource, 0, dict)
            //
            //                    if let img = ima {
            //                        DispatchQueue.main.async {
            //                            ImageCache.sharedCache.setObject(img, forKey: urlString as AnyObject)
            //                            self?.layer.contents = img
            //                        }
            //                    }
            //                }
            
            //Download the image
            let task = URLSession.shared.dataTask(with: url) {
                (data, _, error) in
                if error == nil {
                    if let data = data, let image = UIImage(data: data) {
                        ImageCache.sharedCache.setObject(image, forKey: urlString as AnyObject, cost: data.count)
                        DispatchQueue.main.async {
                            completion(image)
                            //                                self.layer.contents = CIImage(image: image)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        //Maybe return a default 'broken' image
                        completion(.none)
                    }
                }
            }
            self.currentImageTask = task
            task.resume()
            
        }
    }
    
    func imageFrom(_ urlString: String, placeHolder: String? = .none) {
        if let imgName = placeHolder {
            self.image = UIImage(named: imgName)
        }
        
        imageFrom(urlString) { [weak self] image in
            self?.image = image
        }
    }
    
}
