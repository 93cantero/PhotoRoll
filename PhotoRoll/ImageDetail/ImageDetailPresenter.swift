//
//  ImageDetailPresenter.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit

protocol ImageDetailPresenterInput {
}

protocol ImageDetailPresenterOutput: class {
}

class ImageDetailPresenter: ImageDetailPresenterInput {
    weak var output: ImageDetailPresenterOutput!
    
    // MARK: Presentation logic
    
    func presentFetchedImage(viewModel: Photos.FetchImage.Response) {
        
    }
}
