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
}

protocol ImageDetailInteractorOutput {
    func presentFetchedImage(viewModel: Photos.FetchImage.Response)
}

class ImageDetailInteractor: ImageDetailInteractorInput
{
    var output: ImageDetailInteractorOutput!
    var worker : FetchImageWorker = FetchImageWorker(storeEnv: .Live)
    
    // MARK: Business logic
    
    func fetchImage(id: Photos.FetchImage.Request) {
        worker.fetchImage(FiveHundredPx.Photo(id.id)) { [unowned self] (inner) in
            
            do {
                let media : Media = try inner()
                self.output.presentFetchedImage(Photos.FetchImage.Response(media: media))
            } catch {
                
            }
        }
    }
    
}
