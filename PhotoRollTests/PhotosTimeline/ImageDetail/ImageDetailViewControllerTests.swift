//
//  ImageDetailViewControllerTests.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import XCTest

class ImageDetailViewControllerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: ImageDetailViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        setupImageDetailViewController()
    }
    
    override func tearDown()
    {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupImageDetailViewController()
    {
        let bundle = NSBundle(forClass: self.dynamicType)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewControllerWithIdentifier("ImageDetailViewController") as! ImageDetailViewController
    }
    
    func loadView()
    {
        window.addSubview(sut.view)
        NSRunLoop.currentRunLoop().runUntilDate(NSDate())
    }
    
    // MARK: Test doubles
    
    class ImageDetailViewControllerOutputSpy : ImageDetailViewControllerOutput {
        //Method call expectations
        var fetchMediaWithIdIsCalled = false
        
        //Spied methods
        func fetchImage(id: Photos.FetchImage.Request) {
            fetchMediaWithIdIsCalled = true
        }
    }
    
    
    // MARK: Tests
    
    func testFetchMediaWithIdIsCalledWhenViewIsLoaded () {
        //Given
        let output = ImageDetailViewControllerOutputSpy()
        sut.output = output

        //When
        loadView()
        
        //Then
        XCTAssert(output.fetchMediaWithIdIsCalled, "Fetch Media with Id should be called when the view is loaded")
    }
}
