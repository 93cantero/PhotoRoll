//
//  PhotoImageCollectionViewCell.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 18/5/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

class PhotoImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    // Offset to Create parallax Effect
    lazy var imageOffset:CGPoint! = CGPointZero//CGPointMake(0, self.imageViewPhoto.bounds.origin.y)
    
    override func prepareForReuse() {
        self.imageViewPhoto.currentImageTask?.cancel()
        self.imageViewPhoto.currentImageTask = nil
//        self.setImageOffset(CGPointZero)
        imageViewPhoto.frame = CGRectMake(0, 0, imageViewPhoto.frame.width, imageViewPhoto.frame.height)
    }
    
    func setImageOffset(imageOffset:CGPoint) {
        self.imageOffset = imageOffset
        let frame:CGRect = imageViewPhoto.bounds
        let offsetFrame:CGRect = CGRectOffset(frame, self.imageOffset.x, self.imageOffset.y)
        
//        let offsetF = CGRectMake(imageViewPhoto.frame.origin.x, self.imageOffset.y, imageViewPhoto.frame.size.width, imageViewPhoto.frame.size.height)
//        imageViewPhoto.transform = CGAffineTransformMakeTranslation(0, offsetFrame.origin.y + frame.origin.y)
        imageViewPhoto.frame = offsetFrame
//        self.layoutIfNeeded()
    }
//    
//    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
//        self.setImageOffset(imageOffset)
//    }
}
