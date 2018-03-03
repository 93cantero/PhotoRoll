//
//  CollectionGridLayoutTests.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 05/04/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import XCTest

class CollectionGridLayoutTests: XCTestCase {
    
    var sut: CollectionGridLayout!
    let itemsSize: [CGSize] = [(1800.0, 1242.0), (1000.0, 667.0), (3840.0, 5760.0), (1600.0, 900.0), (7952.0, 5304.0), (2048.0, 1365.0), (5408.0, 3600.0), (3886.0, 2365.0), (3000.0, 2000.0), (5568.0, 3712.0), (1600.0, 757.0), (4912.0, 7360.0), (2000.0, 1333.0), (4480.0, 6720.0), (800.0, 1200.0), (1400.0, 788.0), (1600.0, 900.0), (5232.0, 3396.0), (1250.0, 835.0), (1200.0, 801.0), (1800.0, 1242.0), (1000.0, 667.0), (3840.0, 5760.0), (1600.0, 900.0), (7952.0, 5304.0), (2048.0, 1365.0), (5408.0, 3600.0), (3886.0, 2365.0), (3000.0, 2000.0), (5568.0, 3712.0), (1600.0, 757.0), (4912.0, 7360.0), (2000.0, 1333.0), (4480.0, 6720.0), (800.0, 1200.0), (1400.0, 788.0), (1600.0, 900.0), (5232.0, 3396.0), (1250.0, 835.0), (1200.0, 801.0), (1800.0, 1242.0), (1000.0, 667.0), (3840.0, 5760.0), (1600.0, 900.0), (7952.0, 5304.0), (2048.0, 1365.0), (5408.0, 3600.0), (3886.0, 2365.0), (3000.0, 2000.0), (5568.0, 3712.0), (1600.0, 757.0), (4912.0, 7360.0), (2000.0, 1333.0), (4480.0, 6720.0), (800.0, 1200.0), (1400.0, 788.0), (1600.0, 900.0), (5232.0, 3396.0), (1250.0, 835.0), (1200.0, 801.0)].map{ return CGSize(width:$0.0, height:$0.1) }
    
    // MARK: Test setup
    
    override func setUp() {
        super.setUp()
        sut = CollectionGridLayout(itemsSize: itemsSize)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test Doubles
    
    class CollectionGridLayoutMock: CollectionGridLayout {
        
        // MARK: Method call expectations
        var scaledSizesForCurrentRowIsCalled = false
        
        // MARK: Spied methods
        override func scaleSizesForCurrentRow() {
            scaledSizesForCurrentRowIsCalled = true
        }
    }
    
    // MARK: Tests
    
    func testScaledSizeConstrainedToMaxSize() {
        //Given
        let size = CGSize(width: 1800, height: 1242)
        
        //When
        let scaledSize = sut.scale(size:size, constrainedTo: sut.screenSizeWithConstrainedHeight)
        
        //Then
        XCTAssert(scaledSize.height == sut.maxHeight, "Scaled size height must be equal to max size height")
        XCTAssert(scaledSize.width == 260.87, "Scaled size width must be equal to round(size * ratio of Size) rounding to decimals up")
    }
    
    func testScaleSizesForCurrentRowIsCalledWhenRowIsFulfilled() {
        //Given
        let sizes = Array(itemsSize.prefix(3))
        let layout = CollectionGridLayoutMock(itemsSize: sizes)
        
        //When
        layout.calculateSizeForItem(numbered: 0)
        
        //Then
        XCTAssert(layout.scaledSizesForCurrentRowIsCalled, "scaleSizesForCurrentRow() should be called when a row is fulfilled")
    }
    
    func testScaleSizesForCurrentRowIsNotCalledWhenRowIsNotFulfilled() {
        //Given
        let sizes = Array(itemsSize.prefix(1))
        let layout = CollectionGridLayoutMock(itemsSize: sizes)
        
        //When
        layout.calculateSizeForItem(numbered: 0)
        
        //Then
        XCTAssert(!layout.scaledSizesForCurrentRowIsCalled, "scaleSizesForCurrentRow() should not be called until a row is fulfilled")
    }
    
    func testLastRowIsIncompleted() {
        //Given
        let lastItem = itemsSize.count - 1
        
        //When
        sut.calculateSizeForItem(numbered: lastItem)
        
        //Then
        XCTAssert(sut.isLastRowIncompleted, "Last row should be incompleted until the sum of all items' width is equal to the expected size (a.k.a row is not fulfilled)")
    }
    
    func testScaledSizesForARowWhenItemsWidthIsHigherThanScreenSizeWidth() {
        //Given 
        let screenSize = sut.screenSizeWithConstrainedHeight
        let sizes = Array(itemsSize.prefix(3))
        
        //When
        for s in sizes {
            sut.sizeForElementsInCurrentRow.append(sut.scale(size:s, constrainedTo: screenSize))
        }
        sut.scaleSizesForCurrentRow()
        
        //Then
        let spaceForElements = sut.insetForElements * Double(sizes.count + 1)
        let sumOfWidths = sut.scaledItemsSize.map{ $0.width }.reduce(0, +)
        let screenWidth = screenSize.width - CGFloat(spaceForElements)
        XCTAssert(sumOfWidths == screenWidth, "Sum of widths for a row must be equal to ScreenWidth - insetsForElements")
    }
    
}
