//
//  UIPanGestureRecognizerExtensions.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 27/03/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import UIKit

enum Direction: Int {
    case up
    case down
    case left
    case right
    
    var isHorizontal: Bool { return self == .left || self == .right }
    var isVertical: Bool { return !isHorizontal }
}

extension UIPanGestureRecognizer {
    var direction: Direction? {
        let velo = velocity(in: view)
        let vertical = fabs(velo.y) > fabs(velo.x)
        
        switch (vertical, velo.x, velo.y) {
        case (true, _, let y) where y < 0:
            return .up
        case (true, _, let y) where y > 0:
            return .down
        case (false, let x, _) where x > 0:
            return .right
        case (false, let x, _) where x < 0:
            return .left
        default: return .none
        }
    }
}
