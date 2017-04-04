//
//  ImageUtils.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 30/5/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

extension UIImage {
    func scaledSizeConstrainedTo(_ maxSize: CGSize) -> CGSize {
//        let scaleFactor = maxSize.width / self.size.width
//        let newHeight = maxSize.height * scaleFactor
//        return CGSizeMake(maxSize.width, newHeight)

        let widthRatio = maxSize.width / self.size.width
        let heightRatio = maxSize.height / self.size.height
        let scale = min(widthRatio, heightRatio)
        let imageWidth = scale * self.size.width
        let imageHeight = scale * self.size.height

        return CGSize(width: imageWidth, height: imageHeight)
    }
}
