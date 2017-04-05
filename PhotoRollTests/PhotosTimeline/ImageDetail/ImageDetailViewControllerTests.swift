//
//  ImageDetailViewControllerTests.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import XCTest

class ImageDetailViewControllerTests: XCTestCase {
    // MARK: Subject under test

    var sut: ImageDetailViewController!
    var window: UIWindow!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupImageDetailViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupImageDetailViewController() {
        let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles

    class ImageDetailViewControllerOutputSpy: ImageDetailViewControllerOutput {

        //Method call expectations
        var fetchMediaWithIdIsCalled = false
        var cancelFetchImageIsCalled = false

        //Spied methods
        func fetchImage(_ id: Photos.FetchImage.Request) {
            fetchMediaWithIdIsCalled = true
        }
        
        func cancelFetchImage() {
            cancelFetchImageIsCalled = true
        }
    }

    // MARK: Tests
    
    let displayedMedia = Photos.DisplayedMedia(imageId: "1", name: "Foto 1", desc: "Bonita", createdAt: "6/29/07, 3:34 PM", category: "0", imageUrl: "http://www.dumpaday.com/wp-content/uploads/2011/04/Random-Funny-Photos-Part-132_14-2.jpg", highQualityImageUrl: nil, width: 100, height: 100)

    func testFetchMediaWithIdIsCalledWhenViewIsLoaded () {
        //Given
        let output = ImageDetailViewControllerOutputSpy()
        sut.output = output
        
        sut.photo = displayedMedia

        //When
        loadView()

        //Then
        XCTAssert(output.fetchMediaWithIdIsCalled, "Fetch Media with Id should be called when the view is loaded")
    }
    
    func testCancelFetchMediaIsCalledWhenViewIsDeallocated() {
        //Given
        let output = ImageDetailViewControllerOutputSpy()
        sut.output = output
        
        //When
        loadView()
        sut = nil
        
        //Then
        XCTAssert(output.cancelFetchImageIsCalled, "Fetch Media with Id should be cancelled when the view is deallocated")

    }
}
