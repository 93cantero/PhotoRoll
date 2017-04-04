//
//  ImageDetailInteractor.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//
//

import UIKit

protocol ImageDetailInteractorInput {
    func cancelFetchImage()
}

protocol ImageDetailInteractorOutput {
    func presentFetchedImage(_ viewModel: Photos.FetchImage.Response)
}

class ImageDetailInteractor: ImageDetailInteractorInput {
    var output: ImageDetailInteractorOutput!
    var worker: FetchImageWorker = FetchImageWorker(storeEnv: .live)
    var imageDownloader: BackgroundImageDownloader?

    // MARK: Business logic

    func fetchImage(_ request: Photos.FetchImage.Request) {
        if let id = request.id {
            fetchImage(byId: id)
        } else if let url = request.imageUrl {
            downloadImage(fromUrlString: url)
        }
    }
    
    func cancelFetchImage() {
        imageDownloader?.cancelDownloadTask()
    }
    
    private func fetchImage(byId id: Int) {
        worker.fetchImage(FiveHundredPx.photo(id)) { [unowned self] (inner) in
            
            do {
                let media: Media = try inner()
                self.downloadImage(fromUrlString: media.imageUrl)
            } catch {
                // TODO: Maybe set a timer to try again ?
            }
        }
    }
    
    private func downloadImage(fromUrlString urlString: String) {
        imageDownloader = BackgroundImageDownloader()
        imageDownloader?.getImageData(fromUrl: urlString) { [weak self] imageData in
            let response = Photos.FetchImage.Response(dataImage: imageData)
            self?.output.presentFetchedImage(response)
        }
    }

}
