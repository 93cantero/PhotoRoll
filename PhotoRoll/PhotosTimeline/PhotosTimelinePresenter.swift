//
//  PhotosTimelinePresenter.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit

protocol PhotosTimelinePresenterInput {
    func presentFetchedMedia(response: Photos.FetchMedia.Response)
}

protocol PhotosTimelinePresenterOutput: class {
    func displayMedia(viewModel: Photos.FetchMedia.ViewModel)
}

class PhotosTimelinePresenter: PhotosTimelinePresenterInput {
  weak var output: PhotosTimelinePresenterOutput!
  
    var dateFormatter : NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        return dateFormatter
    }
    
  // MARK: Presentation logic
  
    func presentFetchedMedia(response: Photos.FetchMedia.Response) {
        var displayedMedia : [Photos.DisplayedMedia] = []
        
        for media in response.media {
            
            var date : String = ""
            let d = media.createdAt
            date = dateFormatter.stringFromDate(d)

            let desc = media.desc ?? ""
            
            displayedMedia.append(Photos.DisplayedMedia(name: media.name, desc: desc, createdAt: date, category: "0", imageUrl: media.imageUrl, width: media.width, height: media.height))
        }
        
        let viewModel = Photos.FetchMedia.ViewModel(displayedMedia: displayedMedia)
        output.displayMedia(viewModel)
    }
}
