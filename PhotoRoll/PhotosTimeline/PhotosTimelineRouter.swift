//
//  PhotosTimelineRouter.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit

protocol PhotosTimelineRouterInput {
    func navigateToImageDetails()
}

class PhotosTimelineRouter: PhotosTimelineRouterInput {
    //TODO: Change this
    weak var viewController: TimelineCollectionViewController!

    // MARK: Navigation

    func navigateToSomewhere() {
        // NOTE: Teach the router how to navigate to another scene. Some examples follow:

        // 1. Trigger a storyboard segue
        // viewController.performSegueWithIdentifier("ShowSomewhereScene", sender: nil)

        // 2. Present another view controller programmatically
        // viewController.presentViewController(someWhereViewController, animated: true, completion: nil)

        // 3. Ask the navigation controller to push another view controller onto the stack
        // viewController.navigationController?.pushViewController(someWhereViewController, animated: true)

        // 4. Present a view controller from a different storyboard
        // let storyboard = UIStoryboard(name: "OtherThanMain", bundle: nil)
        // let someWhereViewController = storyboard.instantiateInitialViewController() as! SomeWhereViewController
        // viewController.navigationController?.pushViewController(someWhereViewController, animated: true)
    }

    func navigateToImageDetails() {
        viewController.performSegue(withIdentifier: "ImageDetails", sender: nil)
    }

    // MARK: Communication

    func passDataToNextScene(_ segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

        if segue.identifier == "ImageDetails", let destinationViewController = segue.destination as? ImageDetailViewController {
            passDataToImageDetails(destinationViewController)
        }
    }

    func passDataToImageDetails(_ imageDetailsController: ImageDetailViewController) {
        let selectedCell: PhotoImageCollectionViewCell = self.viewController.collectionView?.cellForItem(at: IndexPath(row: self.viewController.selectedIndex!, section: 0)) as! PhotoImageCollectionViewCell
        imageDetailsController.image = selectedCell.imageViewPhoto.image

        let displayedMedia: Photos.DisplayedMedia = self.viewController.displayedMedia[(self.viewController.collectionView?.indexPathsForSelectedItems![0])!.item]

//        imageDetailsController.imageId = value
        imageDetailsController.photo = displayedMedia
        imageDetailsController.transitioningDelegate = self.viewController
    }
}
