//
//  PhotoImageCollectionViewCell.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 18/5/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

class PhotoImageCollectionViewCell: UICollectionViewCell {

    // MARK: Properties
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var placeHolderView: UIView!

    // Offset to Create parallax Effect
    lazy var imageOffset: CGPoint! = CGPoint.zero
    var imageParallaxFactor: CGFloat = 25

    var imgBackTopInitial: CGFloat!
    var imgBackBottomInitial: CGFloat!
    @IBOutlet weak var imgBackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgBackBottomConstraint: NSLayoutConstraint!

    var isPlaceHolderImageHidden: Bool {
        get {
            return self.placeHolderView.isHidden
        }
        set {
            placeHolderView.isHidden = newValue
        }
    }

    // MARK: Cell life cycle
    override func prepareForReuse() {
        self.imageViewPhoto.currentImageTask?.cancel()
        self.imageViewPhoto.currentImageTask = nil
        self.imageViewPhoto.image = nil
        self.isHidden = false
    }

    override func awakeFromNib() {
        self.imgBackBottomConstraint.constant -= 2 * imageParallaxFactor
        self.imgBackTopInitial = self.imgBackTopConstraint.constant
        self.imgBackBottomInitial = self.imgBackBottomConstraint.constant
    }
    
    // MARK: UI Modifiers

    let isRandomParallax: Bool = false
    lazy var isParallaxByZooming: Bool = {
        return self.isRandomParallax ? Bool(truncating: NSNumber(value: arc4random_uniform(2))) : false
    }()
    
    func setImageOffset(_ imageOffset: CGPoint) {
        let boundOffset = max(0, min(1, imageOffset.y))
        let pixelOffset = (1-boundOffset)*2*imageParallaxFactor
        
        // Parallax by zooming
        var topSpace = self.imgBackTopInitial - pixelOffset
        var bottomSpace = self.imgBackBottomInitial + pixelOffset
        
        if isParallaxByZooming {
            topSpace = topSpace > 0 ? topSpace : 0
            bottomSpace = bottomSpace < 0 ? bottomSpace : 0
        }
        
        self.imgBackTopConstraint.constant = topSpace
        self.imgBackBottomConstraint.constant = bottomSpace
    }

}
