//
//  ImageDetailViewController+ImageTransitionProtocol.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 08/03/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import UIKit

extension ImageDetailViewController: ImageTransitionProtocol {
    
    // Hide scroll view containing images
    func transitionSetup(unwinding isUnwinding: Bool) {
        if isUnwinding {
            self.view.alpha = backgroundAlpha
        } else {
            self.view.alpha = 0.0
        }
        scrollView.isHidden = true
        placeholderImageView?.removeFromSuperview()
        setTopAndBottomBarsAlpha(0)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // Unhide images and set correct image to be showing
    func transitionCleanup(unwinding isUnwinding: Bool) {
        scrollView.isHidden = false
        self.view.alpha = 1
        UIView.animate(withDuration: 0.2) {
            self.setTopAndBottomBarsAlpha(self.topAndBottomViewsAlpha)
        }
    }
    
    func imageOffset() -> CGRect? {
        return .none
    }
    
    // Return the imageView window frame
    func imageWindowFrame() -> CGRect {
        if let frame = imageFrame {
            return frame
        } else {
            let scrollWindowFrame = scrollView.superview!.convert(scrollView.frame, to: .none)
            
            if imageIsTouchingSides() && scrollView.zoomScale > scrollView.minimumZoomScale {
                return scrollView.convert(imageView.frame, to: .none)
            } else if imageIsTouchingSides() {
                return rectByAdjustingImageToScrollViewSize(size: scrollWindowFrame)
            } else {
                let width = scrollWindowFrame.size.height * imageRatio
                let xPoint = scrollWindowFrame.origin.x + (scrollWindowFrame.size.width - width) / 2
                return CGRect(x:xPoint, y: scrollWindowFrame.origin.y, width: width, height: scrollWindowFrame.size.height)
            }
        }
    }
    
    func rectByAdjustingImageToScrollViewSize(size scrollWindowFrame: CGRect) -> CGRect {
        let height = scrollWindowFrame.size.width / imageRatio
        let yPoint = scrollWindowFrame.origin.y + (scrollWindowFrame.size.height - height) / 2
        return CGRect(x: scrollWindowFrame.origin.x, y: yPoint, width: scrollWindowFrame.size.width, height: height)
    }
    
    var imageRatio: CGFloat {
        let imageSize = imageView.frame.size
        return imageSize.width / imageSize.height
    }
    
    var scrollViewRatio: CGFloat {
        return scrollView.frame.size.width / scrollView.frame.size.height
    }
    
    func imageIsTouchingSides() -> Bool {
        return (imageRatio > scrollViewRatio)
    }
}
