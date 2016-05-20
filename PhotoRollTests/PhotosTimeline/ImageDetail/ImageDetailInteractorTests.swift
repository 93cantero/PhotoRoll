//
//  ImageDetailInteractorTests.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import XCTest

class ImageDetailInteractorTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: ImageDetailInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupImageDetailInteractor()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupImageDetailInteractor()
    {
        sut = ImageDetailInteractor()
    }
    
    // MARK: Test doubles
    class ImageDetailInteractorOutputSpy : ImageDetailInteractorOutput {
        //Method call expectations
        var presentFetchedImageIsCalled = false
        
        //Spied methods
        func presentFetchedImage(viewModel: Photos.FetchImage.Response) {
            presentFetchedImageIsCalled = true
        }
    }
    
    class FetchImageWorkerSpy : FetchImageWorker {
        //MARK: Method call expectations
        var fetchImageIsCalled = false
        
        override func fetchImage(target: TargetAPI, completionHandler: (inner: () throws -> Media) -> Void) {
            fetchImageIsCalled = true
            
            //Call the closure to finish
            completionHandler(inner: { return Media(name: "", desc: "", createdAt: NSDate(), category: 2, width: 200, height: 200, imageUrl: "") } )
        }
        
    }
    
    // MARK: Tests
    
    func testFetchImageShouldAskThePresenterToPresentFetchedImage () {
        //Given 
        let output = ImageDetailInteractorOutputSpy()
        sut.output = output
        
        let worker = FetchImageWorkerSpy(storeEnv: .Stage)
        sut.worker = worker
        
        //When
        sut.fetchImage(Photos.FetchImage.Request(id: 31))
        
        //Then
        XCTAssert(worker.fetchImageIsCalled, "fetchImage() should ask FetchImageWorker to fetch the image")
        XCTAssert(output.presentFetchedImageIsCalled, "fetchImage() should ask presenter to format the image")
    }
    
    func testFetchImageFiveHundredPxShouldReturnTheInformationOfTheImage () {
        //Given
        let worker = FetchImageWorker(storeEnv: .Stage)
        sut.worker = worker
        
        //When
        let expectation = expectationWithDescription("Waiting for media to be fetched")
        
        let dict = ["name": "Orange or lemon", "description": "",  "category": 0, "width": 472, "height": 709,"image_url": "http://pcdn.500px.net/4910421/c4a10b46e857e33ed2df35749858a7e45690dae7/2.jpg"]
        let media : Media = Media.parseWithDictionary(["desc" : "description"], json: dict)
        var innerMedia : Media?
        worker.fetchImage(FiveHundredPx.Photo(32)) { (inner: () throws -> Media) -> Void in
            innerMedia = try! inner()
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
        
        //Then
        XCTAssertEqual(media.name, innerMedia?.name, "Sample Data for photos should be converted to Media objects")
        XCTAssertEqual(media.desc, innerMedia?.desc, "")
        XCTAssertEqual(media.createdAt, innerMedia?.createdAt,"")
        XCTAssertEqual(media.category, innerMedia?.category,"")
        XCTAssertEqual(media.width, innerMedia?.width,"")
        XCTAssertEqual(media.height, innerMedia?.height,"")
        XCTAssertEqual(media.imageUrl, innerMedia?.imageUrl,"")
    }
}
