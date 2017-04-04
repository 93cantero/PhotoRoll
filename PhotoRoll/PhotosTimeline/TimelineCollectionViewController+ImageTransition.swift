//
//  TimelineCollectionViewController+ImageTransition.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 08/03/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import UIKit

extension TimelineCollectionViewController : UIViewControllerTransitioningDelegate {
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return getImageTransitioning(for: presented as! ImageDetailViewController, presented: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return getImageTransitioning(for: dismissed as! ImageDetailViewController, presented: false)
    }
    
    func getImageTransitioning(for photoViewController: ImageDetailViewController, presented: Bool) -> UIViewControllerAnimatedTransitioning? {
        animationController.setupImageTransition(fromDelegate: presented ? self : photoViewController,
                                                 toDelegate: presented ? photoViewController : self)
        
        if let cell = getCurrentCell() as? PhotoImageCollectionViewCell, let img = cell.imageViewPhoto.image, cell.isPlaceHolderImageHidden {
            animationController.setImage(image: img)
        }
        
        return animationController
    }
    
}

extension TimelineCollectionViewController: ImageTransitionProtocol {
    
    func setVisibilityForSelectedCell(isHidden: Bool) {
        if let cell = getCurrentCell() {
            cell.isHidden = isHidden
        }
    }
    
    func showSelectedCell() {
        setVisibilityForSelectedCell(isHidden: false)
    }
    
    func hideSelectedCell() {
        setVisibilityForSelectedCell(isHidden: true)
    }
    
    func transitionSetup(unwinding isUnwinding: Bool) {
        if !isUnwinding {
            hideSelectedCell()
        }
    }
    
    func transitionCleanup(unwinding isUnwinding: Bool) {
        if isUnwinding {
            showSelectedCell()
        }
    }
    
    func imageWindowFrame() -> CGRect {
        return rectForImageUnderTopOrBottomBars()
    }
    
    func imageOffset() -> CGRect? {
        var cellRect = selectedCellRect()
        if let cell = getCurrentCell() as? PhotoImageCollectionViewCell{
            let origin = CGPoint(x: cellRect.origin.x - (cell.imageViewPhoto.frame.origin.x * -1),
                                 y: cellRect.origin.y - (cell.imageViewPhoto.frame.origin.y * -1))
            cellRect = CGRect(origin: origin, size: cell.imageViewPhoto.frame.size)
        }
        return collectionView!.convert(cellRect, to: .none)
    }
    
    func rectForImageUnderTopOrBottomBars() -> CGRect {
        let cellRect = selectedCellRect()
        var imageWindowRect = collectionView!.convert(cellRect, to: .none)
        
        if isUnderTopBars(y: imageWindowRect.origin.y) {
            imageWindowRect.size.height = imageWindowRect.size.height - (navigationAndStatusBarHeight - imageWindowRect.origin.y)
            imageWindowRect.origin.y = navigationAndStatusBarHeight
        }
        
        let imageEndingY = imageWindowRect.origin.y + imageWindowRect.size.height
        if isUnderBottomBar(imageEndingY: imageEndingY) {
            imageWindowRect.size.height = (self.view.frame.size.height - bottomBarHeight) - imageWindowRect.origin.y
        }
        
        return imageWindowRect
    }
    
    func isUnderTopBars(y: CGFloat) -> Bool {
        return y < navigationAndStatusBarHeight
    }
    
    func isUnderBottomBar(imageEndingY: CGFloat) -> Bool {
        return imageEndingY > self.view.frame.size.height - bottomBarHeight
    }
    
    var bottomBarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.height ?? 0
    }
    
    var navigationAndStatusBarHeight: CGFloat {
        let height = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.height
        return height
    }
    
    func selectedCellRect() -> CGRect {
        let indexPath = IndexPath(item: selectedIndex!, section: 0)
        let attributes = collectionView!.layoutAttributesForItem(at: indexPath)
        return attributes!.frame
    }
    
}
