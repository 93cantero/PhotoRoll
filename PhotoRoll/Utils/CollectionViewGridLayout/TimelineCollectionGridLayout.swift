//
//  TimelineCollectionViewController.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 18/5/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

// MARK: CUSTOM LAYOUT FOR COLLECTION VIEW.

//TODO: Create a totally dynamic layout
////////////////////////////////////////
//TODO: CACHE ROW SIZE AND CHECK PERFORMANCE

extension TimelineCollectionViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if elementsCount == 0 || elementsCount == sizeForElementsInRow.count {
            sizeForElementsInRow = []
            //Calculate the size for the items on this row
            adjustSizeForMedia((indexPath as NSIndexPath).row)
        }

        let size = sizeForElementsInRow[safe: elementsCount] ?? CGSize(width: 0, height: 0)
        elementsCount = elementsCount == sizeForElementsInRow.count-1 ? 0 : elementsCount + 1

        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

}

extension TimelineCollectionViewController {
    
    var minHeight: CGFloat {
        return 80
    }

    var maxHeight: CGFloat {
        return 180
    }
    
    var insetForElements: Double {
        return 2.5
    }

    func scaledSize(_ size: CGSize, constrainedTo maxSize: CGSize) -> CGSize {
        let ratio: CGFloat = min(maxSize.width / size.width, maxSize.height / size.height)

        return CGSize(width: floor(size.width * ratio), height: floor(size.height * ratio))
    }

    func adjustSizeForMedia(_ row: Int, constrainedTo maxSize: CGSize) {
        if let media = displayedMedia[safe:row] {
            let size = scaledSize(CGSize(width: media.width, height: media.height), constrainedTo: maxSize)
            sizeForElementsInRow.append(size)
        }
    }
    
    var numberOfElements: Int {
        return sizeForElementsInRow.count == 2 ? 1 : sizeForElementsInRow.count
    }
    
    var screenSizeWithConstrainedHeight: CGSize {
        var screenSize = UIScreen.main.bounds.size
        screenSize.height = maxHeight
        screenSize.width = screenSize.width - CGFloat(Double(numberOfElements) * 2.5) - 6
        return screenSize
    }

    func adjustSizeForMedia(_ row: Int) {
        adjustSizeForMedia(row, constrainedTo: screenSizeWithConstrainedHeight)
        rowFulfilled = sizeForElementsInRow.map { $0.width }.reduce(0, +) >= screenSizeWithConstrainedHeight.width - CGFloat(Double(numberOfElements) * 2.5)
        if (rowFulfilled) {
            preferredSizeForItems()
        } else {
            if (row < displayedMedia.count) { adjustSizeForMedia(row+1) }
            else if (screenSizeWithConstrainedHeight.width - (sizeForElementsInRow.last?.width)! < 120) { preferredSizeForItems()
            }
        }

    }

    func preferredSizeForItems() {
        var screenSize = screenSizeWithConstrainedHeight
        screenSize.width = screenSize.width - (6 - (sizeForElementsInRow.count > 1 ? (2.5 * CGFloat(numberOfElements - 1)) : 0))
        
        // 3 elementos == 4 espacios
        // | | |

        //Get minHeight for the elements in the row
        var minHeightForRow = sizeForElementsInRow.map { $0.height }.min()
        minHeightForRow = minHeightForRow! < CGFloat(minHeight) ? CGFloat(minHeight) : minHeightForRow

        //Filter and scale the images depending on the height of the smallest one.
        sizeForElementsInRow = sizeForElementsInRow.map { CGSize(width: $0.width, height: minHeightForRow!) }

        //If there is only 1 element, adjust it to the screen width, so it fills all the space
        if sizeForElementsInRow.count == 1 {
            sizeForElementsInRow[0] = CGSize(width: screenSize.width, height: sizeForElementsInRow[0].height)
        } else if sizeForElementsInRow.count > 1 {
            adjustSizeWhenMoreThanOneItem()
        }
    }
    
    func adjustSizeWhenMoreThanOneItem() {
        //If there are more than 1 elements, readjust the size for the items, taking in mind the number of items
        //and the ratio of the image to get the most proper size
        
        let sumOfWidths = sizeForElementsInRow.map() { $0.width }.reduce(0, +)
        sizeForElementsInRow = sizeForElementsInRow.map() {
            CGSize(
                width: ($0.width / sumOfWidths * screenSizeWithConstrainedHeight.width),
                height: $0.height)
        }
//        //The code above is much cleaner, but it's also much heavy for the performance
//        var sumOfWidths: CGFloat = 0
//        var sizes: [CGFloat] = []
//        
//        for s in sizeForElementsInRow {
//            sizes.append(s.width)
//            sumOfWidths = sumOfWidths + s.width
//        }
//        
//        for i in 0 ..< sizes.count {
//            sizeForElementsInRow[i] = CGSize(width: ((sizes[i] / sumOfWidths) * screenSizeWithConstrainedHeight.width), height: sizeForElementsInRow[i].height)
//        }
    }
}
