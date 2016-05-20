//
//  ImageDetailPresenterTests.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import XCTest

class ImageDetailPresenterTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: ImageDetailPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupImageDetailPresenter()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupImageDetailPresenter()
    {
        sut = ImageDetailPresenter()
    }
    
    // MARK: Test doubles
    
    // MARK: Tests
    
}
