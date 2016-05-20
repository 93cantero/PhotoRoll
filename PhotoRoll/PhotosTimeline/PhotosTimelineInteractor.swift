//
//  PhotosTimelineInteractor.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//
//

import UIKit

protocol PhotosTimelineInteractorInput {
    func fetchMedia(request: Photos.FetchMedia.Request)
}

protocol PhotosTimelineInteractorOutput {
    func presentFetchedMedia(response: Photos.FetchMedia.Response)
}

class PhotosTimelineInteractor: PhotosTimelineInteractorInput
{
    var output: PhotosTimelineInteractorOutput!
    var mediaFiveHundredPxWorker = FetchMediaWorker(storeEnv: .Live)
    
    // MARK: Business logic
    
    func fetchMedia(request: Photos.FetchMedia.Request) {
        
        mediaFiveHundredPxWorker.fetchMedia(FiveHundredPx.PopularPhotosWithSize(31)) { (inner: () throws -> [Media]) -> Void in
            
            do{
                let response = Photos.FetchMedia.Response(media: try inner())
                
                self.output.presentFetchedMedia(response)
            } catch {
                
            }
        }
    }
}
