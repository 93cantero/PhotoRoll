//
//  PhotosTimelinePresenterTests.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 17/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import XCTest

class PhotosTimelinePresenterTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: PhotosTimelinePresenter!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupPhotosTimelinePresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupPhotosTimelinePresenter()
  {
    sut = PhotosTimelinePresenter()
  }
  
  // MARK: Test doubles
  
    class PhotosTimeLinePresenterOutputSpy : PhotosTimelinePresenterOutput {
        //MARK: Method call expectations
        var displayMediaIsCalled = false
        var photosTimeline_fetchMedia_viewModel : PhotosTimeline_FetchMedia_ViewModel!
        
        //MARK: Spied methods
        func displayMedia(viewModel: PhotosTimeline_FetchMedia_ViewModel) {
            displayMediaIsCalled = true
            
            photosTimeline_fetchMedia_viewModel = viewModel
        }
    }
    
  // MARK: Tests
    
    func testPresentFetchedMediaShouldFormatMediaForDisplay() {
        //Given
        let output = PhotosTimeLinePresenterOutputSpy()
        sut.output = output
        
        let components = NSDateComponents()
        components.day = 29
        components.month = 06
        components.year = 2007
        
        let date = NSCalendar.currentCalendar().dateFromComponents(components)!
        
        let media = [Media(name: "Foto 1", desc: "Bonita", createdAt: date, category: 0, width: 0, height: 0, imageUrl: "http://www.dumpaday.com/wp-content/uploads/2011/04/Random-Funny-Photos-Part-132_14-2.jpg")]
        let response = PhotosTimeline_FetchMedia_Response(media: media)
        //When
        sut.presentFetchedMedia(response)
        
        //Then
        let displayedMedia : PhotosTimeline_FetchMedia_ViewModel.DisplayedMedia = output.photosTimeline_fetchMedia_viewModel.displayedMedia[0]
        XCTAssertEqual(displayedMedia.name, "Foto 1", "Name should be equal to Foto 1")
        XCTAssertEqual(displayedMedia.desc, "Bonita", "Description should be equal to 'Bonita'")
        XCTAssertEqual(displayedMedia.createdAt, "6/29/07", "CreatedAt date should equal to the day of the first iPhone release :D")
        XCTAssertEqual(displayedMedia.category, "0", "Category should be equal to 0")
        XCTAssertEqual(displayedMedia.imageUrl, "http://www.dumpaday.com/wp-content/uploads/2011/04/Random-Funny-Photos-Part-132_14-2.jpg", "ImageURL should be equal to the 'kidnap photo'")
    }

    func testPresentFetchedMediaShouldAskViewToDisplayMedia() {
        //Given
        let output = PhotosTimeLinePresenterOutputSpy()
        sut.output = output
        
        //Test with an empty array just to make sure it is called
        let response = PhotosTimeline_FetchMedia_Response(media: [])
        
        //When
        sut.presentFetchedMedia(response)
        
        //Then
        XCTAssert(output.displayMediaIsCalled, "presentFetchedMedia() should ask view controller to display the fetched media")
    }
    
}
