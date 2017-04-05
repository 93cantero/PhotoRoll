//
//  PhotosTimelineViewControllerTests.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 17/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import XCTest

class PhotosTimelineViewControllerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: TimelineCollectionViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupPhotosTimelineViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPhotosTimelineViewController() {
        let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "TimelineCollectionViewController") as! TimelineCollectionViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class PhotosTimelineViewControllerOutputSpy: PhotosTimelineViewControllerOutput {
        // MARK: Method call expectations
        var fetchMediaCalled = false
        
        // MARK: Spied methods
        func fetchMedia(_ request: Photos.FetchMedia.Request) {
            fetchMediaCalled = true
        }
    }
    
    class UICollectionViewSpy: UICollectionView {
        // MARK: Method call expectations
        var reloadDataCalled = false
        
        override func reloadData() {
            reloadDataCalled = true
        }
    }
    
    // MARK: Tests
    
    func testFetchMediaIsCalledWhenViewIsLoaded() {
        //Given
        let timelineOutput = PhotosTimelineViewControllerOutputSpy()
        sut.output = timelineOutput
        
        //When
        loadView()
        
        //Then
        XCTAssert(timelineOutput.fetchMediaCalled, "Fetch Media should be called when view is loaded")
    }
    
    let displayedMedia = [Photos.DisplayedMedia(imageId: "1", name: "Foto 1", desc: "Bonita", createdAt: "6/29/07", category: "0", imageUrl: "http://www.dumpaday.com/wp-content/uploads/2011/04/Random-Funny-Photos-Part-132_14-2.jpg", highQualityImageUrl: nil, width: 100, height: 100)]
    
    func testDisplayMediaShouldDisplayMedia() {
        //Given
        let collectionView = UICollectionViewSpy(frame: sut.collectionView!.frame, collectionViewLayout: sut.collectionView!.collectionViewLayout)
        sut.collectionView = collectionView
        
        let viewModel = Photos.FetchMedia.ViewModel(displayedMedia: displayedMedia)
        //When
        sut.displayMedia(viewModel)
        
        //Then
        XCTAssert(collectionView.reloadDataCalled, "displayMedia() should ask collection view to reload data")
    }
    
    func testNumberOfSectionsAlwaysReturnOne() {
        //Given
        let collectionView = sut.collectionView
        
        //When
        let numberOfSections = sut.numberOfSections(in: collectionView!)
        
        //Then
        XCTAssertEqual(numberOfSections, 1, "Number of sections should always be one")
    }
    
    func testNumberOfRowsInSectionShouldBeEqualToNumberOfDisplayedMedia() {
        //Given
        let collectionView = sut.collectionView
        
        sut.displayedMedia = displayedMedia
        //When
        let numberOfRows = sut.collectionView(collectionView!, numberOfItemsInSection: 0)
        
        //Then
        XCTAssertEqual(numberOfRows, 1, "Number of rows should equal the number of displayed media")
    }
}
