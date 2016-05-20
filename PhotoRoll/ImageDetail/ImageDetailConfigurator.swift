//
//  ImageDetailConfigurator.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//
//

import UIKit

// MARK: Connect View, Interactor, and Presenter

extension ImageDetailViewController: ImageDetailPresenterOutput
{
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    router.passDataToNextScene(segue)
  }
}

extension ImageDetailInteractor: ImageDetailViewControllerOutput
{
}

extension ImageDetailPresenter: ImageDetailInteractorOutput
{
}

class ImageDetailConfigurator
{
  // MARK: Object lifecycle
  
  class var sharedInstance: ImageDetailConfigurator
  {
    struct Static {
      static var instance: ImageDetailConfigurator?
      static var token: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.token) {
      Static.instance = ImageDetailConfigurator()
    }
    
    return Static.instance!
  }
  
  // MARK: Configuration
  
  func configure(viewController: ImageDetailViewController)
  {
    let router = ImageDetailRouter()
    router.viewController = viewController
    
    let presenter = ImageDetailPresenter()
    presenter.output = viewController
    
    let interactor = ImageDetailInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}
