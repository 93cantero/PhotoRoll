//
//  ImageDetailPresenter.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit

protocol ImageDetailPresenterInput {
    func presentFetchedImage(_ viewModel: Photos.FetchImage.Response)
}

protocol ImageDetailPresenterOutput: class {
    func presentImage(_ img: UIImage)
}

class ImageDetailPresenter: ImageDetailPresenterInput {
    weak var output: ImageDetailPresenterOutput!

    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = DateFormatter.Style.none
        return dateFormatter
    }
    
    // MARK: Presentation logic

    func presentFetchedImage(_ viewModel: Photos.FetchImage.Response) {
        
        if let dataImage = viewModel.dataImage, let image = UIImage(data: dataImage) {
            DispatchQueue.main.async { [weak self] in
                self?.output.presentImage(image)
            }
        } else {
            // TODO: Set a timer with Reachability to try again
        }
    }
}
