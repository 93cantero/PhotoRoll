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

  var sut: PhotosTimelineViewController!
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
    sut = storyboard.instantiateViewController(withIdentifier: "PhotosTimelineViewController") as! PhotosTimelineViewController
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

    class UITableViewSpy: UITableView {
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

    func testDisplayMediaShouldDisplayMedia() {
        //Given
        let tableView = UITableViewSpy()
        sut.tableView = tableView

        let displayedMedia = [Photos.DisplayedMedia(imageId: "1", name: "Foto 1", desc: "Bonita", createdAt: "6/29/07", category: "0", imageUrl: "http://www.dumpaday.com/wp-content/uploads/2011/04/Random-Funny-Photos-Part-132_14-2.jpg", width: 100, height: 100)]
        let viewModel = Photos.FetchMedia.ViewModel(displayedMedia: displayedMedia)
        //When
        sut.displayMedia(viewModel)

        //Then
        XCTAssert(tableView.reloadDataCalled, "displayMedia() should ask table view to reload data")
    }

    func testNumberOfSectionsAlwaysReturnOne() {
        //Given
        let tableView = sut.tableView

        //When
        let numberOfSections = sut.numberOfSections(in: tableView!)

        //Then
        XCTAssertEqual(numberOfSections, 1, "Number of sections should always be one")
    }

    func testNumberOfRowsInSectionShouldBeEqualToNumberOfDisplayedMedia() {
        //Given
        let tableView = sut.tableView

        let displayedMedia = [Photos.DisplayedMedia(imageId: "1", name: "Foto 1", desc: "Bonita", createdAt: "6/29/07", category: "0", imageUrl: "http://www.dumpaday.com/wp-content/uploads/2011/04/Random-Funny-Photos-Part-132_14-2.jpg", width: 100, height: 100)]

        sut.displayedMedia = displayedMedia
        //When
        let numberOfRows = sut.tableView(tableView, numberOfRowsInSection: 0)

        //Then
        XCTAssertEqual(numberOfRows, 1, "Number of rows should equal the number of displayed media")
    }
}
