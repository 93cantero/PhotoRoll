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
    var imageOffset:CGPoint!
    
    override func prepareForReuse() {
        self.imageViewPhoto.currentImageTask?.cancel()
        self.imageViewPhoto.currentImageTask = nil
    }
    
    func setImageOffset(imageOffset:CGPoint) {
        self.imageOffset = imageOffset
        let frame:CGRect = imageViewPhoto.bounds
        let offsetFrame:CGRect = CGRectOffset(frame, self.imageOffset.x, self.imageOffset.y)
        

//        imageViewPhoto.transform = CGAffineTransformMakeTranslation(0, self.imageOffset.y)
        imageViewPhoto.frame = offsetFrame
    }
}
