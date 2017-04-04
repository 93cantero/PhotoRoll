//
//  UIColorExtensions.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 14/03/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import UIKit

// MARK: UIColor+HexString
extension UIColor {
    
    /// Initialize the UIColor with the given hex String
    ///
    /// - parameter hex:      Hex String description of the color (e.g: "#AAABBB")
    /// - parameter theAlpha: Alpha. Default value is 1
    ///
    /// - returns: UIColor
    convenience init(hex: String, alpha theAlpha: Float = 1.0) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        if ((cString.characters.count) != 6) {
            //Gray Color
            Scanner(string: "AAAAAA").scanHexInt32(&rgbValue)
        }
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(theAlpha)
        )
    }
    
}

// MARK: UIColor+CustomColors
extension UIColor {
    
    
    
}
