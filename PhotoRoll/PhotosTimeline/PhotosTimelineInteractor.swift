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
    func fetchMedia(request: PhotosTimeline_FetchMedia_Request)
}

protocol PhotosTimelineInteractorOutput {
    func presentFetchedMedia(response: PhotosTimeline_FetchMedia_Response)
}

class PhotosTimelineInteractor: PhotosTimelineInteractorInput
{
    var output: PhotosTimelineInteractorOutput!
    var mediaFiveHundredPxWorker = FetchMediaWorker(storeEnv: .Live)
    
    // MARK: Business logic
    
    func fetchMedia(request: PhotosTimeline_FetchMedia_Request) {
        
        mediaFiveHundredPxWorker.fetchMedia(FiveHundredPx.PopularPhotosWithSize(2048)) { (inner: () throws -> [Media]) -> Void in
            
            do{
                let response = PhotosTimeline_FetchMedia_Response(media: try inner())
                
                self.output.presentFetchedMedia(response)
            } catch {
                
            }
        }
    }
}
