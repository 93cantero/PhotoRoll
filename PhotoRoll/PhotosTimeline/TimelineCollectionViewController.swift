//
//  TimelineCollectionViewController.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 14/4/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

protocol PhotosTimelineViewControllerInput {
    func displayMedia(_ viewModel: Photos.FetchMedia.ViewModel)
}

protocol PhotosTimelineViewControllerOutput {
    func fetchMedia(_ request: Photos.FetchMedia.Request)
}

internal let reuseIdentifier = "photoCell"
internal let sectionInsets = UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5)
internal var elementsCount = 0
internal var sizeForElementsInRow: [CGSize] = []

class TimelineCollectionViewController: UICollectionViewController, PhotosTimelineViewControllerInput {
    
    var output: PhotosTimelineViewControllerOutput!
    var router: PhotosTimelineRouter!
    var image: UIImage!
    var imageId: String!
    
    var displayedMedia: [Photos.DisplayedMedia] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PhotosTimelineConfigurator.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        
        output.fetchMedia(Photos.FetchMedia.Request())
    }
    
    // MARK: Display logic
    
    func displayMedia(_ viewModel: Photos.FetchMedia.ViewModel) {
        displayedMedia = viewModel.displayedMedia
        collectionView!.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedMedia.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoImageCollectionViewCell
        
        cell.imageViewPhoto.imageFrom(self.displayedMedia[indexPath.item].imageUrl)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        setCellImageOffset(cell as! PhotoImageCollectionViewCell)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ///Navigate only when there is an image set
        if (collectionView.cellForItem(at: indexPath) as! PhotoImageCollectionViewCell).imageViewPhoto.layer.contents != nil {
            self.selectedIndex = indexPath.item
            router.navigateToImageDetails()
            
        }
        self.collectionView?.deselectItem(at: indexPath, animated: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    func getCurrentCell() -> UICollectionViewCell? {
        guard let index = selectedIndex else {
            return .none
        }
        return self.collectionView?.cellForItem(at: IndexPath(item:index, section: 0))
    }
    
    var sumOfSizes: CGFloat = 0
    var rowFulfilled: Bool = false
    
    /// Animation transitioning
    let animationController: ImageTransitioning = ImageTransitioning()
    var selectedIndex: Int?
}

// MARK: Extension for parallax effect on photos
/// TimelineCollectionViewController+Parallax
extension TimelineCollectionViewController {
    
    // TODO: Extend this under UICollectionViewController implementing ParallaxEffect Protocol
    // where the cells implement also ParallaxEffectCell
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for view in collectionView!.visibleCells {
            let cell: PhotoImageCollectionViewCell = view as! PhotoImageCollectionViewCell
            setCellImageOffset(cell)
        }
    }
    
    func setCellImageOffset(_ cell: PhotoImageCollectionViewCell) {
        let cellFrame = cell.frame
        let cellFrameInTable = self.collectionView!.convert(cellFrame, to:self.collectionView!.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = self.collectionView!.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        cell.setImageOffset(CGPoint(x: 0, y: cellOffsetFactor))
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { context in
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.layoutIfNeeded()
        }, completion: .none)
    }
}


