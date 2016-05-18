//
//  TimelineCollectionViewController.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 14/4/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

private let reuseIdentifier = "photoCell"
private let sectionInsets = UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5)
private var elementsCount = 0
private var sizeForElementsInRow : [CGSize] = []

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
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.blackColor()
        
        //TODO: Download it with Alamofire or implement own class with cached images.
        
//        let imageView = UIImageView(image: UIImage())
//        imageView.contentMode = .ScaleAspectFill
//        imageView.frame = cell.frame
//        cell.addSubview(imageView)
        
//        cell.bringSubviewToFront(imageView)
        // Configure the cell
        
        return cell
    }
    
    var sumOfSizes : CGFloat = 0
    var rowFulfilled : Bool = false
    
}


//MARK: CUSTOM LAYOUT FOR COLLECTION VIEW.

//TODO: Create a totally dynamic layout
////////////////////////////////////////
//TODO: CACHE ROW SIZE AND CHECK PERFORMANCE

extension TimelineCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if elementsCount == 0 || elementsCount == sizeForElementsInRow.count {
            sizeForElementsInRow = []
            //Calculate the size for the items on this row
            adjustSizeForMedia(indexPath.row)
        }
        
        let size = sizeForElementsInRow[safe: elementsCount] ?? CGSizeMake(0, 0)
        elementsCount = elementsCount == sizeForElementsInRow.count ? 0 : elementsCount + 1
        
        return size
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
}

extension TimelineCollectionViewController {
    
    func scaledSize(size: CGSize,constrainedTo maxSize: CGSize) -> CGSize {
        let ratio : CGFloat = min(maxSize.width / size.width, maxSize.height / size.height);
        
        return CGSize(width: size.width * ratio, height: size.height * ratio)
    }
    
    func adjustSizeForMedia(row: Int, constrainedTo maxSize: CGSize) {
        if let media = displayedMedia[safe:row] {
            let size = scaledSize(CGSize(width: media.width, height: media.height), constrainedTo: maxSize)
            sizeForElementsInRow.append(size)
        }
    }
    
    
    func adjustSizeForMedia(row: Int) {
        var screenSize = UIScreen.mainScreen().bounds.size
        screenSize.height = 180
        screenSize.width -= 6
        
//        screenSize.width -= CGFloat(sizeForElementsInRow.count) * 10
        
        adjustSizeForMedia(row, constrainedTo: screenSize)
        rowFulfilled = sizeForElementsInRow.map() { $0.width }.reduce(0, combine: +) >= screenSize.width - CGFloat(Double(sizeForElementsInRow.count) * 2.5)
        if (rowFulfilled) {
            preferredSizeForItems()
        } else {
            if (row < displayedMedia.count) { adjustSizeForMedia(row+1) }
        }
        
    }
    
    func preferredSizeForItems() -> CGSize {
        var screenSize = UIScreen.mainScreen().bounds.size
        screenSize.height = 180
        screenSize.width = screenSize.width - (6 + (sizeForElementsInRow.count > 1 ? (2.5 * CGFloat(sizeForElementsInRow.count)) : 0))
        
        //Get minHeight for the elements in the row
        var minHeight = sizeForElementsInRow.map{ $0.height }.minElement()
        minHeight = minHeight < 80 ? 80 : minHeight
        
//        minHeight = (maxHeight - minHeight) > 60 ? minHeight + 30 : minHeight
        
        //Filter and scale the images depending on the height of the smallest one.
        sizeForElementsInRow = sizeForElementsInRow.map { CGSizeMake($0.width, minHeight!) }
        
        //If there is only 1 element, adjust it to the screen width, so it fills all the space
        if sizeForElementsInRow.count == 1 {
            sizeForElementsInRow[0] = CGSizeMake(screenSize.width, sizeForElementsInRow[0].height)
            return sizeForElementsInRow[0]
        } else if sizeForElementsInRow.count > 1 {
            //If there are more than 1 elements, readjust the size for the items, taking in mind the number of items
            //and the ratio of the image to get the most proper size
            
            //sizeForElementsInRow = sizeForElementsInRow.map() { CGSizeMake(($0.width / screenSize.width) * sizeForElementsInRow.map() { $0.width }.reduce(0, combine: +), $0.height) }
            //The code above is much cleaner, but it's also much heavy for the performance
            var sumOfWidths : CGFloat = 0
            var sizes : [CGFloat] = []
            
            for s in sizeForElementsInRow {
                sizes.append(s.width)
                sumOfWidths = sumOfWidths + s.width
            }
            
            for i in 0 ..< sizes.count {
                sizeForElementsInRow[i] = CGSizeMake(((sizes[i] / sumOfWidths) * screenSize.width), sizeForElementsInRow[i].height)
            }
            
        }
        return CGSizeZero
    }
}

extension CollectionType {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}