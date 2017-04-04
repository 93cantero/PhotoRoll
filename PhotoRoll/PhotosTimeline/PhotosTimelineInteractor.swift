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
    func fetchMedia(_ request: Photos.FetchMedia.Request)
}

protocol PhotosTimelineInteractorOutput {
    func presentFetchedMedia(_ response: Photos.FetchMedia.Response)
}

class PhotosTimelineInteractor: PhotosTimelineInteractorInput {
    var output: PhotosTimelineInteractorOutput!
    var mediaFiveHundredPxWorker = FetchMediaWorker(storeEnv: .live)

    // MARK: Business logic

    func fetchMedia(_ request: Photos.FetchMedia.Request) {
        // Size 31
        let endpoint = FiveHundredPx.popularPhotos(sized:[.maxHeight(.fourHundredFifty),
                                                          .longestEdge(.twoThousandFourtyEight)])
        mediaFiveHundredPxWorker.fetchMedia(endpoint) { (inner: () throws -> [Media]) -> Void in

            do {
                var media = try inner()
                let mediaCopy = media
                let mediaCopy2 = mediaCopy
                media = media + mediaCopy + mediaCopy2
                let response = Photos.FetchMedia.Response(media: media)

                self.output.presentFetchedMedia(response)
            } catch {

            }
        }
    }

}
