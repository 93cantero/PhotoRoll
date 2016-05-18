//
//  PhotosTimelineInteractorTests.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 17/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import XCTest

class PhotosTimelineInteractorTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: PhotosTimelineInteractor!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupPhotosTimelineInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupPhotosTimelineInteractor()
  {
    sut = PhotosTimelineInteractor()
  }
  
  // MARK: Test doubles
  
    class PhotosTimelineInteractorOutputSpy : PhotosTimelineInteractorOutput {
        //MARK: Method call expectations
        var presentFetchedMediaIsCalled = false
        
        func presentFetchedMedia(response: PhotosTimeline_FetchMedia_Response) {
            presentFetchedMediaIsCalled = true
        }
    }
    
    class FetchMediaWorkerSpy : FetchMediaWorker {
        //MARK: Method call expectations
        var fetchMediaIsCalled = false
        
        override func fetchMedia(target: TargetAPI, completionHandler: (inner: () throws -> [Media]) -> Void) {
            fetchMediaIsCalled = true
            
            //Call the closure to finish
            completionHandler(inner: { return [] } )
        }
        
    }
    
  // MARK: Tests

    func testFetchMediaShouldAskFetchMediaWorkerToFetchMedia() {
        //Given 
        let output = PhotosTimelineInteractorOutputSpy()
        sut.output = output
        
        let worker = FetchMediaWorkerSpy(storeEnv: .Stage)
        sut.mediaFiveHundredPxWorker = worker
        
        //When
        let request = PhotosTimeline_FetchMedia_Request()
        sut.fetchMedia(request)
        
        //Then
        XCTAssert(worker.fetchMediaIsCalled, "fetchMedia() should ask do FetchMediaWorker to fetch the media")
        XCTAssert(output.presentFetchedMediaIsCalled, "fetchMedia() should ask presenter to formar fetched media")
    }
    
    func testFetchMediaFiveHundredPxWorkerShouldReturnAListOfMedia() {
        //Given 
        let worker = FetchMediaWorker(storeEnv: .Stage)
        sut.mediaFiveHundredPxWorker = worker
        
        //When
        let expectation = expectationWithDescription("Waiting for media to be fetched")
        
        let dict = ["name": "Orange or lemon", "description": "",  "category": 0, "width": 472, "height": 709,"image_url": "http://pcdn.500px.net/4910421/c4a10b46e857e33ed2df35749858a7e45690dae7/2.jpg"]
        var media : [Media] = [Media.parseWithDictionary(["desc" : "description"], json: dict)]
        var innerMedia : [Media] = []
        worker.fetchMedia(FiveHundredPx.PopularPhotosWithSize(2048)) { (inner: () throws -> [Media]) -> Void in
            innerMedia = try! inner()
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
        
        //Then
//        XCTAssert(true, "It's true!!! \(media)")
        XCTAssertEqual(media[0].name, innerMedia[0].name, "Sample Data for photos should be converted to Media objects")
        XCTAssertEqual(media[0].desc, innerMedia[0].desc, "")
        XCTAssertEqual(media[0].createdAt, innerMedia[0].createdAt,"")
        XCTAssertEqual(media[0].category, innerMedia[0].category,"")
        XCTAssertEqual(media[0].width, innerMedia[0].width,"")
        XCTAssertEqual(media[0].height, innerMedia[0].height,"")
        XCTAssertEqual(media[0].imageUrl, innerMedia[0].imageUrl,"")
        
    }
}
