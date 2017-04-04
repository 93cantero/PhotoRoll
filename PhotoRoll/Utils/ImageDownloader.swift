//
//  ImageDownloader.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 01/03/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import UIKit

class BackgroundImageDownloader {
    typealias ImageCacheCompletion = (Data?) -> Void
    var task: URLSessionDataTask?
    
    private func retrieveCachedImageData(_ urlString: String) -> Data? {
        return ImageCache.sharedCache.object(forKey: urlString as AnyObject) as? Data
    }
    
    func getImageData(fromUrl urlString: String, completion: @escaping ImageCacheCompletion) {
        let cachedImageData = retrieveCachedImageData(urlString)
        
        if let img = cachedImageData {
            completion(img)
        } else {
            constructDataTask(withUrl: urlString) {
                completion($0)
            }
        }
    }
    
    func getImage(fromUrl urlString: String, completion: @escaping (UIImage?) -> Void) {
        getImageData(fromUrl: urlString) { data in
            guard let data = data, let image = UIImage(data: data) else {
                completion(.none)
                return
            }
            completion(image)
        }
    }
    
    func cancelDownloadTask() {
        task?.cancel()
    }
    
    private func constructDataTask(withUrl urlString: String, usingCompletion completion: @escaping ImageCacheCompletion) {
        guard let url = URL(string: urlString) else {
            print("Bad url format while downloading image: \(urlString)")
            completion(.none)
            return
        }
        
        task = URLSession.shared.dataTask(with: url) {
            (data, _, error) in
            if error == nil {
                if let dataImage = data {
                    ImageCache.sharedCache.setObject(dataImage as AnyObject, forKey: urlString as AnyObject, cost: dataImage.count)
                    completion(data)
                }
            } else {
                if let err = error as? NSError, err.code != NSURLErrorCancelled {
                    completion(.none)
                }
            }
        }
        task?.resume()
    }
}
