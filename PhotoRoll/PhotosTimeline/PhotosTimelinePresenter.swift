//
//  PhotosTimelinePresenter.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit

protocol PhotosTimelinePresenterInput {
    func presentFetchedMedia(_ response: Photos.FetchMedia.Response)
}

protocol PhotosTimelinePresenterOutput: class {
    func displayMedia(_ viewModel: Photos.FetchMedia.ViewModel)
}

class PhotosTimelinePresenter: PhotosTimelinePresenterInput {
    weak var output: PhotosTimelinePresenterOutput!

    var clientStyleDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HHmmssZZ"
        return dateFormatter
    }
    
    var storedDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter
    }

    // MARK: Presentation logic

    func presentFetchedMedia(_ response: Photos.FetchMedia.Response) {
        var displayedMedia: [Photos.DisplayedMedia] = []

        for media in response.media {

            var date: String = ""
            let s = media.createdAt.replacingOccurrences(of: ":", with: "")
            if let d = clientStyleDateFormatter.date(from: s) {
                date = storedDateFormatter.string(from: d)
            }

            let desc = media.desc ?? ""
            
            var highQualityImageUrl: String?
            if let imgs = media.images {
                let i = imgs.filter() { $0.size == .longestEdge(.twoThousandFourtyEight) }
                
                highQualityImageUrl = i.first?.httpsUrl
            }
            
            displayedMedia.append(Photos.DisplayedMedia(imageId: String(media.imageId), name: media.name, desc: desc, createdAt: date, category: "0", imageUrl: media.imageUrl, highQualityImageUrl: highQualityImageUrl, width: media.width, height: media.height))
        }

        let viewModel = Photos.FetchMedia.ViewModel(displayedMedia: displayedMedia)
        output.displayMedia(viewModel)
    }
}
