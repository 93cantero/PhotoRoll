//
//  CollectionGridLayout.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 05/04/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import UIKit

class CollectionGridLayout {
    
    // MARK: Properties
    
    var itemsSize: [CGSize]! {
        didSet{
            invalidateLayout()
        }
    }
    var scaledItemsSize: [CGSize] = [] {
        didSet{
            if isRowFulfilled {
                sizeForElementsInCurrentRow = []
            }
        }
        willSet{
            if newValue != [] {
                lastItemScaled = lastItemScaled + sizeForElementsInCurrentRow.count - 1
            }
        }
    }
    
    var sizeForElementsInCurrentRow: [CGSize] = []
    var lastItemScaled: Int = 0
    //
    let minHeight: CGFloat = 80
    let maxHeight: CGFloat = 180
    let insetForElements: Double = 2.5
    var screenSizeWithConstrainedHeight: CGSize {
        var screenSize = UIScreen.main.bounds.size
        screenSize.height = self.maxHeight
        return screenSize
    }
    
    // MARK: Convenience init

    convenience init(itemsSize: [CGSize]) {
        self.init()
        self.itemsSize = itemsSize
    }

    // MARK: Public methods
    
    func invalidateLayout() {
        resetPropertiesToItsInitialValue()
    }
    
    func setItemsSize(sizes: [CGSize]) {
        itemsSize = sizes
    }
    
    func appendSizes(_ sizes: [CGSize]) {
        self.itemsSize.append(contentsOf: sizes)
        //TODO: Recalculate size for last row if needed and for new rows
    }
    
    func sizeForItem(at itemNumber: Int) -> CGSize {
        if shouldCalculateSizeForCurrentItem {
            calculateSizeForItem(numbered: itemNumber)
        }
        
        let size = scaledItemsSize[safe: itemNumber] ?? CGSize(width: 0, height: 0)
        
        return size
    }
    
    // MARK: Helper functions

    func resetPropertiesToItsInitialValue() {
        scaledItemsSize = []
        lastItemScaled = 0
    }
    
    var shouldCalculateSizeForCurrentItem: Bool {
        return lastItemScaled == 0 || (lastItemScaled == scaledItemsSize.count || lastItemScaled < scaledItemsSize.count && isLastRowIncompleted)
    }
    
    // MARK: Size for elements
    
    var sumOfInsets: Double {
        return Double(sizeForElementsInCurrentRow.count + 1) * insetForElements
    }
    
    var spacingForElementInCurrentRow: CGFloat {
        return CGFloat(sumOfInsets / Double(sizeForElementsInCurrentRow.count))
    }
    
    var isRowFulfilled: Bool {
        return sizeForElementsInCurrentRow.map { $0.width }.reduce(0,+) > screenSizeWithConstrainedHeight.width
    }
    
    var isLastRowIncompleted: Bool {
        return !isRowFulfilled
    }
    
    func ratioOf(size: CGSize, constrainedTo maxSize: CGSize) -> CGFloat {
        return min(maxSize.width / size.width, maxSize.height / size.height)
    }
    
    func scale(size: CGSize, constrainedTo maxSize: CGSize) -> CGSize {
        let ratio: CGFloat = ratioOf(size: size, constrainedTo: maxSize)
        
        return CGSize(width: NSDecimalNumber(decimal:round(Double(size.width * ratio), toNearest: 0.01)).doubleValue, height: NSDecimalNumber(decimal:round(Double(size.height * ratio), toNearest: 0.01)).doubleValue)
    }
    
    func scaleSizeFor(item: Int) {
        if let s = itemsSize[safe:item] {
            let itemSize = scale(size: s, constrainedTo: screenSizeWithConstrainedHeight)
            sizeForElementsInCurrentRow.append(itemSize)
        }
    }
    
    func scaleSizesForCurrentRow() {
        let minHeightForActualSizes = sizeForElementsInCurrentRow.map{ $0.height }.min()!
        let sumOfWidths = sizeForElementsInCurrentRow.map { $0.width }.reduce(0, +)
        var remainingWidthForScreen: Decimal = Decimal(screenSizeWithConstrainedHeight.width.native - sumOfInsets)
        let size = sizeForElementsInCurrentRow.map { (e) -> CGSize in
            
            func getWidthForItem() -> Decimal {
                let proportionalElementWidth = e.width / sumOfWidths * screenSizeWithConstrainedHeight.width
                let _itemWidth = proportionalElementWidth.native - spacingForElementInCurrentRow.native
                var _width = round(_itemWidth, toNearest: 10)
                if remainingWidthForScreen - 3 < _width {
                    _width = roundDown(_itemWidth, toNearest: 1) - 3
                }
                return _width
            }
            
            //Adjust width for each element taking in mind the insets
            let width = getWidthForItem()
            remainingWidthForScreen = remainingWidthForScreen - width
            return CGSize(width: NSDecimalNumber(decimal:width).doubleValue, height: minHeightForActualSizes.native)
        }
        scaledItemsSize.append(contentsOf: size)
    }
    
    func calculateSizeForItem(numbered item: Int) {
        scaleSizeFor(item: item)
        if isRowFulfilled {
            scaleSizesForCurrentRow()
        } else if let _ = itemsSize[safe:item+1] {
            calculateSizeForItem(numbered: item+1)
        } else if (screenSizeWithConstrainedHeight.width - (sizeForElementsInCurrentRow.last?.width)! < 120) {
            scaleSizesForCurrentRow()
        }

    }
}

