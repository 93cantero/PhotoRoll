//
//  PhotosTimelinePresenter.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit

protocol PhotosTimelinePresenterInput {
    func presentFetchedMedia(response: PhotosTimeline_FetchMedia_Response)
}

protocol PhotosTimelinePresenterOutput: class {
    func displayMedia(viewModel: PhotosTimeline_FetchMedia_ViewModel)
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
  
    func presentFetchedMedia(response: PhotosTimeline_FetchMedia_Response) {
        var displayedMedia : [PhotosTimeline_FetchMedia_ViewModel.DisplayedMedia] = []
        
        for media in response.media {
            
            var date : String = ""
            let d = media.createdAt
            date = dateFormatter.stringFromDate(d)

            let desc = media.desc ?? ""
            
            displayedMedia.append(PhotosTimeline_FetchMedia_ViewModel.DisplayedMedia(name: media.name, desc: desc, createdAt: date, category: "0", imageUrl: media.imageUrl, width: media.width, height: media.height))
        }
        
        let viewModel = PhotosTimeline_FetchMedia_ViewModel(displayedMedia: displayedMedia)
        output.displayMedia(viewModel)
    }
}
