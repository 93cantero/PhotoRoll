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
    
    override func prepareForReuse() {
        self.imageViewPhoto.currentImageTask?.cancel()
        self.imageViewPhoto.currentImageTask = nil
    }
}
