//
//  PhotosTimelineConfigurator.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//
//

import UIKit

// MARK: Connect View, Interactor, and Presenter

//TODO: Change this
extension TimelineCollectionViewController: PhotosTimelinePresenterOutput {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    router.passDataToNextScene(segue)
  }
}

extension PhotosTimelineInteractor: PhotosTimelineViewControllerOutput {
}

extension PhotosTimelinePresenter: PhotosTimelineInteractorOutput {
}

class PhotosTimelineConfigurator {

  // MARK: Object lifecycle

  class var sharedInstance: PhotosTimelineConfigurator {
    let instance = PhotosTimelineConfigurator()
    return instance
  }

  // MARK: Configuration

    //TODO: Change this
  func configure(_ viewController: TimelineCollectionViewController) {
    let router = PhotosTimelineRouter()
    router.viewController = viewController

    let presenter = PhotosTimelinePresenter()
    presenter.output = viewController

    let interactor = PhotosTimelineInteractor()
    interactor.output = presenter

    viewController.output = interactor
    viewController.router = router
  }
}
