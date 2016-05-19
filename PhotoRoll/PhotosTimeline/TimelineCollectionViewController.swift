//
//  TimelineCollectionViewController.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 14/4/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

internal let reuseIdentifier = "photoCell"
internal let sectionInsets = UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5)
internal var elementsCount = 0
internal var sizeForElementsInRow : [CGSize] = []

class TimelineCollectionViewController: UICollectionViewController, PhotosTimelineViewControllerInput {
    
    var output: PhotosTimelineViewControllerOutput!
    var router: PhotosTimelineRouter!
    
    var displayedMedia : [PhotosTimeline_FetchMedia_ViewModel.DisplayedMedia] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PhotosTimelineConfigurator.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        
        output.fetchMedia(PhotosTimeline_FetchMedia_Request())
    }
    
    // MARK: Display logic
    
    func displayMedia(viewModel: PhotosTimeline_FetchMedia_ViewModel) {
        displayedMedia = viewModel.displayedMedia
        collectionView!.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedMedia.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoImageCollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
                
        cell.imageViewPhoto.imageFromUrl(displayedMedia[indexPath.row].imageUrl)
        
        let yOffset:CGFloat = ((collectionView.contentOffset.y - cell.frame.origin.y) / 200) * 25
        cell.setImageOffset(CGPointMake(0, yOffset))
        
        
        return cell
    }
    
    var sumOfSizes : CGFloat = 0
    var rowFulfilled : Bool = false
    
    //Offset for images
    var currentImageOffset: CGPoint! = CGPointZero
}


//MARK: Extension for parallax effect on photos

extension TimelineCollectionViewController {
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        for view in collectionView!.visibleCells(){
            let view:PhotoImageCollectionViewCell = view as! PhotoImageCollectionViewCell
            let yOffset:CGFloat = ((collectionView!.contentOffset.y - view.frame.origin.y) / 200) * 25
            currentImageOffset = CGPointMake(0, yOffset)
            view.setImageOffset(currentImageOffset)
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView?.performBatchUpdates({ 
            self.collectionView?.reloadData()
        }, completion: nil)
    }

}
